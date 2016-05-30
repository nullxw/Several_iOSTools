//
//  QRViewController.m
//  QR
//
//  Created by kouliang on 15/8/12.
//  Copyright (c) 2015年 tuanche. All rights reserved.
//

#import "QRViewController.h"
#import <AVFoundation/AVFoundation.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define RGBA(r,g,b,a)               [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]

@interface QRViewController ()<UIAlertViewDelegate,AVCaptureMetadataOutputObjectsDelegate>
@property(nonatomic,weak)UIView *boundView;
@property(nonatomic,weak)UIImageView *scanLine;
@property(nonatomic,strong)NSTimer *timer;
@property(assign,nonatomic)BOOL moveUp;
@property(assign,nonatomic)NSInteger num;

@property (strong,nonatomic)AVCaptureSession *session;
@property(nonatomic,copy)NSString *currentResultText;
@end

@implementation QRViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpViews];
    [self setUpTimer];
    [self setUpCamera];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
#pragma mark - setUpViews
- (void)setUpViews{
    // 扫描框
    UIImage *boundImg = [UIImage imageNamed:@"QRScan.bundle/qr_bg_bound"];
    CGRect boundRect = CGRectMake((kScreenWidth-boundImg.size.width)*0.5, (kScreenHeight-44-boundImg.size.height)*0.5, boundImg.size.width,boundImg.size.height);
    UIImageView *boundView = [[UIImageView alloc]initWithFrame:boundRect];
    boundView.image = boundImg;
    [self.view addSubview:boundView];
    _boundView = boundView;
    
    // 扫描线
    UIImage *insideImage = [UIImage imageNamed:@"QRScan.bundle/qr_bg_inside"];
    UIImageView *scanView = [[UIImageView alloc]initWithFrame:CGRectMake(-10, -5, insideImage.size.width, insideImage.size.height)];
    scanView.image = insideImage;
    [boundView addSubview:scanView];
    _scanLine = scanView;
    
    //边框蒙版
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, boundView.frame.origin.y)];
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, boundView.frame.origin.y, (kScreenWidth-boundView.frame.size.width)*0.5, boundView.frame.size.height)];
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(boundView.frame), boundView.frame.origin.y, (kScreenWidth-boundView.frame.size.width)*0.5, boundView.frame.size.height)];
    UIView *view4 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(boundView.frame), kScreenWidth, kScreenHeight-CGRectGetMaxY(boundView.frame))];
    
    UIColor *backColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    view1.backgroundColor = backColor;
    [self.view addSubview:view1];
    view2.backgroundColor = backColor;
    [self.view addSubview:view2];
    view3.backgroundColor = backColor;
    [self.view addSubview:view3];
    view4.backgroundColor = backColor;
    [self.view addSubview:view4];

    // 提示信息
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(boundView.frame)+10, kScreenWidth, 40)];
    tipsLabel.text = @"请将二维码置于取景框内扫描";
    tipsLabel.font = [UIFont systemFontOfSize:15];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.textColor = RGBA(197, 197, 197, 1.0);
    tipsLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tipsLabel];
    
    // 取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消扫描" forState:UIControlStateNormal];
    cancelBtn.titleLabel.textColor = RGBA(255, 255, 255, 1.0);
    [cancelBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    cancelBtn.frame = CGRectMake((kScreenWidth-185)/2, CGRectGetMaxY(tipsLabel.frame)+10, 185, 44);
    UIImage *cancelImg = [UIImage imageNamed:@"QRScan.bundle/qr_btn_cancel"];
    [cancelBtn setBackgroundImage:[cancelImg resizableImageWithCapInsets:UIEdgeInsetsMake(20, 30, 30, 20)] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
}
- (void)setUpTimer{
    _timer =[NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(scanAnimation) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
    _num = 0;
}
#pragma mark scanAnimation
- (void)scanAnimation{
    if (_moveUp) {
        _scanLine.frame = CGRectMake(-10, -5+2*_num--, _scanLine.frame.size.width, _scanLine.frame.size.height);
        if (_num == 0) {
            _moveUp = NO;
        }
    }else{
        _scanLine.frame = CGRectMake(-10, -5+2*_num++, _scanLine.frame.size.width, _scanLine.frame.size.height);
        if (2*_num == 220) {
            _moveUp = YES;
        }
    }
}
#pragma mark 取消扫描
- (void)backAction{
    [_timer invalidate];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - setUpCamera
-(void)setUpCamera{
    // device
    AVCaptureDevice *device;
    device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //获取后置摄像头的第二种方法
    //    NSArray *devArray = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    //    AVCaptureDevice *device;
    //    for (AVCaptureDevice *de in devArray) {
    //        if (de.position == AVCaptureDevicePositionFront) {
    //            device = de;
    //        }
    //    }
    
    
    // input
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    if(!input){
        [self deviceIsNotSupport];
        return;
    }
    
    // output
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:input]){
        [_session addInput:input];
    }
    if ([_session canAddOutput:output]){
        [_session addOutput:output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
//    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    output.metadataObjectTypes =[output availableMetadataObjectTypes];
    // 设置扫描范围
    CGRect cropRect = _boundView.frame;
    // RectOfInterest 以拉伸后原图右上角为原点，最大值为(0,0,1,1)
    [output setRectOfInterest : CGRectMake (cropRect.origin.y/kScreenHeight,cropRect.origin.x/kScreenWidth,cropRect.size.height/kScreenHeight, cropRect.size.width/kScreenWidth)];
    
    // Preview
    AVCaptureVideoPreviewLayer *preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    preview.frame =CGRectMake(0,0,kScreenWidth,kScreenHeight);
    [self.view.layer insertSublayer:preview atIndex:0];
    
    // Start
    dispatch_queue_t sessionQueue = dispatch_queue_create("com.camera.capture_session", DISPATCH_QUEUE_SERIAL);
    dispatch_async(sessionQueue, ^{
        [_session startRunning];
    });
}
- (void)deviceIsNotSupport{
    //判断是不是允许访问相机
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"请在系统设置中开启相机（设置>隐私>相机>开启XXX）" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alertView show];
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    NSString *stringValue;
    if ([metadataObjects count] >0){
        [_session stopRunning];
        id metadataObject = [metadataObjects objectAtIndex:0];
        // 条码
        if ([metadataObject isMemberOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            AVMetadataMachineReadableCodeObject *rcObject = (AVMetadataMachineReadableCodeObject *)metadataObject;
            stringValue = rcObject.stringValue;
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil message:stringValue delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
            [alertView show];
        }
        // 人脸
        else if ([metadataObject isMemberOfClass:[AVMetadataFaceObject class]]){
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil message:@"发现地球人" delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
            [alertView show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self backAction];
}

@end

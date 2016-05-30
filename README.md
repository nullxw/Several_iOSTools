# Several_iOSTools
几个iOS小工具
***
## GradientLabel
聚光灯扫射文字显示效果

usage
- 
	GradientLabel *label = [[GradientLabel alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 40)];
	     label.textAlignment = NSTextAlignmentCenter;
	     label.text = @"Helo everyone! Are you OK?";
	     label.font = [UIFont systemFontOfSize:25];
	     [self.view addSubview:label];

![image](https://github.com/kouliang/Several_iOSTools/blob/master/gif/01.gif)
***
## AdView
两行代码搞定图片轮播

usage
-
	ADView *adview = [[ADView alloc]initWithImages:imageURLArray];
	    adview.frame = CGRectMake(0, 100, 320, 135);
	    [self.view addSubview:adview];
![image](https://github.com/kouliang/Several_iOSTools/blob/master/gif/02.gif)
***
## QRScan
原生二维码扫描器，自带人脸识别功能哦

![image](https://github.com/kouliang/Several_iOSTools/blob/master/gif/03.gif)
***
## TagView
快速为你的view添加标签，自动换行，还具备单选功能

usage
-
	NSArray *titles = @[@"奥迪",@"比亚迪",@"龙",@"一汽大众"];
	    KLTagView *tagView = [[KLTagView alloc]initWithTitles:titles width:200];
	    CGSize size = [tagView getContentSize];
	    tagView.frame = CGRectMake(0, 0, size.width, size.height);
	    [self.view addSubview:tagView];
![image](https://github.com/kouliang/Several_iOSTools/blob/master/gif/04.gif)
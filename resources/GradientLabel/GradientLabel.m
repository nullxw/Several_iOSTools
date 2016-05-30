//
//  GradientLabel.m
//
//  Created by kou on 16/5/25.
//  Copyright © 2016年 kou. All rights reserved.
//

#import "GradientLabel.h"
@interface GradientLabel()
@property(nonatomic,weak)UILabel *label;
@property(nonatomic,weak)CAGradientLayer *gradientLayer;
@end
@implementation GradientLabel
- (instancetype)initWithFrame:(CGRect)frame{
    GradientLabel *view = [super initWithFrame:frame];
    UILabel *label = [[UILabel alloc]init];
    _label = label;
    [view addSubview:label];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    _gradientLayer = gradientLayer;
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    gradientLayer.colors = @[(__bridge id)[UIColor blackColor].CGColor,(__bridge id)[UIColor whiteColor].CGColor,(__bridge id)[UIColor blackColor].CGColor];
    gradientLayer.locations = @[@0.2,@0.5,@0.8];
    [self.layer addSublayer:gradientLayer];
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"locations";
    animation.fromValue = @[@0,@0,@0.25];
    animation.toValue = @[@0.75,@1,@1];
    animation.repeatCount = MAXFLOAT;
    animation.duration = 3.5;
    [gradientLayer addAnimation:animation forKey:nil];
    gradientLayer.mask = label.layer;
    label.layer.frame = gradientLayer.bounds;
    return view;
}
- (void)layoutSubviews{
    _label.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _gradientLayer.frame = _label.frame;
    [super layoutSubviews];
}
#pragma mark - setLabel
- (void)setTextAlignment:(NSTextAlignment)textAlignment{
    _textAlignment = textAlignment;
    _label.textAlignment = textAlignment;
}
- (void)setFont:(UIFont *)font{
    _font = font;
    _label.font = font;
}
- (void)setText:(NSString *)text{
    _text = text;
    _label.text = text;
}
@end

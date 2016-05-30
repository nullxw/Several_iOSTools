//
//  GradientLabel.h
//
//  Created by kou on 16/5/25.
//  Copyright © 2016年 kou. All rights reserved.
//

/**
 sample:
     GradientLabel *label = [[GradientLabel alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 40)];
     label.textAlignment = NSTextAlignmentCenter;
     label.text = @"Helo everyone! Are you OK?";
     label.font = [UIFont systemFontOfSize:25];
     [self.view addSubview:label];
 
 参考：http://www.devtalking.com/articles/calayer-animation-gradient-animation/
 */
#import <UIKit/UIKit.h>

@interface GradientLabel : UIView
@property(nonatomic,assign) NSTextAlignment     textAlignment;
@property(nonatomic,strong) UIFont              *font;
@property(nonatomic,copy)   NSString            *text;
@end

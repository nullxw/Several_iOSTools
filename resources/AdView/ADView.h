//
//  ADView.h
//
//  Created by coderkl on 15/11/25.
//  Copyright © 2015年 coderkl. All rights reserved.
//

/** 
 sample:
    ADView *adview = [[ADView alloc]initWithImages:imageURLArray];
    adview.frame = CGRectMake(0, 100, 320, 135);
    [self.view addSubview:adview];
    adview.adviewClicked = ^(NSInteger i){
        NSLog(@"%d",i);
    };
 
 notice: To use this View, you should add "SDWebImage" to your project.
 */
#import <UIKit/UIKit.h>

@interface ADView : UIView
@property(nonatomic,copy) void(^adviewClicked)(NSInteger);
/**
 *  @param images 图片URL的数组
 */
- (instancetype)initWithImages:(NSArray *)urlArray;
@end

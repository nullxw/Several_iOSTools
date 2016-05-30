//
//  KLTagView.h
//
//  Created by kouliang on 16/1/21.
//  Copyright © 2016年 kouliang. All rights reserved.
//

/**
 sample:
 
    NSArray *titles = @[@"奥迪",@"比亚迪",@"龙",@"一汽大众"];
    KLTagView *tagView = [[KLTagView alloc]initWithTitles:titles width:200];
    CGSize size = [tagView getContentSize];
    tagView.frame = CGRectMake(0, 0, size.width, size.height);
    [self.view addSubview:tagView];
 */

#import <UIKit/UIKit.h>

@interface KLTagView : UIView
- (instancetype)initWithTitles:(NSArray *)titles width:(CGFloat)width;
- (NSInteger)getSelectIndex;
- (NSInteger)getLines;
- (CGSize)getContentSize;
@end

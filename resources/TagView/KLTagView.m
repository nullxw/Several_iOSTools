//
//  KLTagView.m
//
//  Created by kouliang on 16/1/21.
//  Copyright © 2016年 kouliang. All rights reserved.
//

#import "KLTagView.h"

#define kMiniSpaceX 16
#define kMiniSpaceY 8
#define kFontSize 14

@interface KLTagView()
@property(nonatomic,strong)NSMutableArray *labelArray;
@property(nonatomic,strong)NSNumber *selectIndex;
@property(assign,nonatomic)NSInteger line;
@end

@implementation KLTagView
- (instancetype)initWithTitles:(NSArray *)titles width:(CGFloat)width{
    _labelArray = [NSMutableArray array];
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, width, 100);
        __weak typeof(self)weakSelf = self;
        __block CGFloat startX=0;
        __block CGFloat endX=0;
        [titles enumerateObjectsUsingBlock:^(NSString *text, NSUInteger idx, BOOL * _Nonnull stop) {
            CGSize size = [weakSelf sizeForText:text];
            endX = startX+size.width;
            if (endX>width) {
                startX = 0;
                weakSelf.line++;
            }
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(startX, weakSelf.line*(size.height+kMiniSpaceY), size.width, size.height)];
            label.backgroundColor = [UIColor whiteColor];
            label.text = text;
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:kFontSize];
            label.textColor = [UIColor colorWithRed:0x66/255.0 green:0x66/255.0 blue:0x66/255.0 alpha:1];
            label.layer.borderColor = [UIColor colorWithRed:0xde/255.0 green:0xde/255.0 blue:0xde/255.0 alpha:1].CGColor;
            label.layer.borderWidth = 1;
            label.layer.cornerRadius = 5.0;
            label.layer.masksToBounds = YES;
            label.layer.shouldRasterize = YES;
            [weakSelf addSubview:label];
            startX = CGRectGetMaxX(label.frame) + kMiniSpaceX;
            
            [weakSelf.labelArray addObject:label];
            label.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:weakSelf action:@selector(labelTaped:)];
            [label addGestureRecognizer:tap];
        }];
    }
    self.clipsToBounds = YES;
    return self;
}
- (void)labelTaped:(UITapGestureRecognizer *)tap{
    UILabel *label = (UILabel *)tap.view;
    if (_selectIndex) {
        [self unSelectLabel:[_labelArray objectAtIndex:_selectIndex.integerValue]];
    }
    [self selectLabel:label];
    _selectIndex = @([_labelArray indexOfObject:label]);
}
- (void)selectLabel:(UILabel *)label{
    label.backgroundColor = [UIColor redColor];
    label.textColor = [UIColor whiteColor];
    label.layer.borderColor = [UIColor redColor].CGColor;
}
- (void)unSelectLabel:(UILabel *)label{
    label.backgroundColor = [UIColor whiteColor];
    label.textColor = [UIColor colorWithRed:0x66/255.0 green:0x66/255.0 blue:0x66/255.0 alpha:1];
    label.layer.borderColor = [UIColor colorWithRed:0xde/255.0 green:0xde/255.0 blue:0xde/255.0 alpha:1].CGColor;
}

- (CGSize)sizeForText:(NSString *)text{
    UIFont *font = [UIFont systemFontOfSize:kFontSize];
    NSDictionary *attrs = @{NSFontAttributeName:font};
    CGSize size = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    return CGSizeMake(size.width+6, size.height+4);
}
- (NSInteger)getSelectIndex{
    if (_selectIndex) {
        return _selectIndex.integerValue;
    }
    return -1;
}
- (NSInteger)getLines{
    return _line+1;
}
- (CGSize)getContentSize{
    CGSize size = [self sizeForText:@"奥迪"];
    CGFloat width = self.bounds.size.width;
    CGFloat height = (size.height+kMiniSpaceY)*([self getLines]);
    return CGSizeMake(width, height);
}
@end

//
//  ADView.m
//
//  Created by coderkl on 15/11/25.
//  Copyright © 2015年 coderkl. All rights reserved.
//

#import "ADView.h"
#import "UIImageView+WebCache.h"
#import "NSTimer+BLocks.h"

@interface ADView()<UIScrollViewDelegate>
@property (weak, nonatomic)UIScrollView *scrollView;
@property (weak, nonatomic)UIPageControl *pageControl;
@property (strong,nonatomic)NSTimer *timer;
@property (strong,nonatomic)NSArray *urlArray;
@end

@implementation ADView
- (instancetype)initWithImages:(NSArray *)urlArray{
    if (self = [super init]) {
        _urlArray = urlArray;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tap];
    }
    return  self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    [self addSubview:scrollView];
    _scrollView = scrollView;
    self.scrollView.contentSize=CGSizeMake(self.bounds.size.width*(_urlArray.count+2), 0);
    self.scrollView.bounces=YES;
    self.scrollView.showsHorizontalScrollIndicator=NO;
    self.scrollView.showsVerticalScrollIndicator=NO;
    self.scrollView.pagingEnabled=YES;
    self.scrollView.delegate=self;
    
    [self addImages];
    [self addPageControl];
    [self addTimer];
}
- (void)addImages{
    CGFloat imageViewW=self.scrollView.bounds.size.width;
    CGFloat imageViewH=self.scrollView.bounds.size.height;
    CGFloat imageViewY=0;
    CGFloat imageViewX=0;
    for (int i=0; i<_urlArray.count+2; i++) {
        imageViewX=imageViewW*i;
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        UIImage *placeholderImage = [UIImage imageNamed:@"bg_mid_banner"];
        if (i == 0) {
            [imageView sd_setImageWithURL:[_urlArray lastObject] placeholderImage:placeholderImage];
        }else if (i == _urlArray.count+1){
            [imageView sd_setImageWithURL:[_urlArray firstObject] placeholderImage:placeholderImage];
        }else{
            [imageView sd_setImageWithURL:_urlArray[i-1] placeholderImage:placeholderImage];
        }
        [self.scrollView addSubview:imageView];
    }
    CGPoint offSet=CGPointMake(imageViewW,0);
    [self.scrollView setContentOffset:offSet animated:NO];
}
- (void)addPageControl{
    UIPageControl *pageControl = [[UIPageControl alloc]init];
    CGSize pageSize = [pageControl sizeForNumberOfPages:_urlArray.count];
    pageControl.frame = CGRectMake(self.bounds.size.width-pageSize.width-20, self.bounds.size.height-pageSize.height+10, pageSize.width, pageSize.height);
    pageControl.numberOfPages = _urlArray.count;
    pageControl.currentPage = 0;
    pageControl.pageIndicatorTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0x72/255.0 green:0xff/255.0 blue:0x4a/255.0 alpha:1];
    [self addSubview:pageControl];
    _pageControl = pageControl;
}
#pragma mark - Timer
-(void)addTimer{
    __weak typeof(self)weakSelf = self;
    self.timer = [NSTimer scheduleTimerWithTimerInternal:3.0 block:^{
        [weakSelf nextImage];
    } repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
-(void)removeTimer{
    [self.timer invalidate];
    self.timer=nil;
}

-(void)nextImage{
    NSInteger currentPage=self.pageControl.currentPage;
    currentPage++;
    CGPoint offSet=CGPointMake(self.scrollView.frame.size.width*(currentPage+1),0);
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:1.0 animations:^{
        [weakSelf.scrollView setContentOffset:offSet animated:NO];
    } completion:^(BOOL finished) {
        [weakSelf updateScrollView];
    }];
}
- (void)updateScrollView{
    CGFloat scrollViewW=self.scrollView.frame.size.width;
    int page=((self.scrollView.contentOffset.x+scrollViewW*0.5)/scrollViewW);
    if (page==0) {
        CGPoint offSet=CGPointMake(scrollViewW*_urlArray.count,0);
        [self.scrollView setContentOffset:offSet animated:NO];
    }else if (page==_urlArray.count+1) {
        CGPoint offSet=CGPointMake(scrollViewW,0);
        [self.scrollView setContentOffset:offSet animated:NO];
    }
}
#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat scrollViewW=self.scrollView.frame.size.width;
    int page=((self.scrollView.contentOffset.x+scrollViewW*0.5)/scrollViewW);
    if (page==0) {
        page=(int)_urlArray.count-1;
    }else if (page==_urlArray.count+1) {
        page=0;
    }else{
        page = page-1;
    }
    self.pageControl.currentPage=page;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self removeTimer];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (decelerate == NO) {
        [self updateScrollView];
    }
    [self addTimer];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self updateScrollView];
}
#pragma mark - TapGestureRecognizerAction
- (void)tap{
    if (_adviewClicked) {
        _adviewClicked(_pageControl.currentPage);
    }
}
@end
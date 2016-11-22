//
//  NJBannerView.m
//  BannerViewDemo
//
//  Created by JLee Chen on 16/6/27.
//  Copyright © 2016年 JLee Chen. All rights reserved.
//

#import "NJBannerView.h"
#import "NJBannerImageView.h"
#import "TAPageControl.h"

#define WIDTH self.frame.size.width
#define HEIGHT self.frame.size.height
#define selectCurrentPage 0


@interface NJBannerView () <UIScrollViewDelegate>

@property (weak , nonatomic) UIScrollView *scrollerView;
@property (weak , nonatomic) TAPageControl *pageControl;
@property (weak , nonatomic) UILabel *showTitleLabel;
@property (weak , nonatomic) NSTimer *timer;
@property (assign , nonatomic) CGFloat lastContentX;

/**
 *  存放用于展示广告页的View
 */
@property (copy , nonatomic) NSMutableArray *arrBannerImageViews;

//banner数量
@property (assign , nonatomic) NSInteger datasCount;
//当前显示的页码
@property (assign , nonatomic) NSInteger currentPage;

- (void) startAnimation;
- (void) stopAnimation;

@end

@implementation NJBannerView
@synthesize titles;
- (id) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _intervalTime = 4.0f;
        _isNeedAutoScroll = YES;
    }
    return self;
}

- (void)dealloc
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (id) initWithFrame:(CGRect)frame placeholderImg:(UIImage *) placeholderImg
{
    NJBannerView *bannerV = [self initWithFrame:frame];
    bannerV.placeholderImg = placeholderImg;
    return bannerV;
}

- (NSMutableArray *)arrBannerImageViews
{
    if (_arrBannerImageViews == nil) {
        _arrBannerImageViews = [NSMutableArray array];
        for (int i = 0; i < 3; i++) {
            CGRect frame = CGRectMake(WIDTH * i, 0, WIDTH,HEIGHT);
            NJBannerImageView *imageV = [[NJBannerImageView alloc] initWithFrame:frame];
            imageV.linkAction = ^(NSDictionary *link)
            {
                [self bannerAction:link];
            };
            [_arrBannerImageViews addObject:imageV];
        }
    }
    return _arrBannerImageViews;
}

- (NSInteger) currentPage
{
    return self.pageControl.currentPage;
}

- (void) setDatas:(NSMutableArray *)datas
{
    _datas = datas;
    self.datasCount = datas.count;
    
    if (datas.count <= 0) return;
    if (datas.count == 1) {
        NJBannerImageView *imageV = [[NJBannerImageView alloc] initWithFrame:self.bounds];
        imageV.linkAction = ^(NSDictionary *link)
        {
            [self bannerAction:link];
        };
        imageV.dicProperty = datas[0];
        [self addSubview:imageV];
        [self setShowTitleLabel];
        return;
    }
    
    [self setScrollerView];
    [self setShowTitleLabel];
    [self setPageControl];
    [self startAnimation];
}

- (void) setPlaceholderImg:(UIImage *)placeholderImg
{
    for (NJBannerImageView *imgV in self.arrBannerImageViews) {
        imgV.placeholderImg = placeholderImg;
    }
}

- (void) setIsNeedAutoScroll:(BOOL)isNeedAutoScroll
{
    _isNeedAutoScroll = isNeedAutoScroll;
    if (self.datasCount < 2) {
        return;
    }
    if (isNeedAutoScroll) {
        [self startAnimation];
        return;
    }
    if (!isNeedAutoScroll) {
        [self stopAnimation];
    }
}

- (void) bannerAction:(NSDictionary *)link
{
    if (self.linkAction) {
        self.linkAction(link);
    }
}

- (void) setScrollerView
{
    self.lastContentX = WIDTH;
    
    UIScrollView *scroller = [[UIScrollView alloc] initWithFrame:self.bounds];
    scroller.delegate = self;
    scroller.pagingEnabled = YES;
    scroller.bounces = YES;
    scroller.showsHorizontalScrollIndicator = NO;
    CGSize size = CGSizeMake(WIDTH * 3, HEIGHT);
    scroller.contentSize = size;
    
    if (selectCurrentPage == 0) {
        NSDictionary *lastDatas = [self.datas objectAtIndex:_datas.count-1];
        [self.datas removeObject:lastDatas];
        [self.datas insertObject:lastDatas atIndex:0];
    }
    
    for (int i = 0; i < self.arrBannerImageViews.count; i++) {
        NJBannerImageView *imageV = self.arrBannerImageViews[i];
        imageV.dicProperty = _datas[i%_datas.count];
        [scroller addSubview:imageV];
    }
    
    [scroller setContentOffset:CGPointMake(WIDTH, 0)];
    
    [self addSubview:scroller];
    self.scrollerView = scroller;
}

- (void)setShowTitleLabel
{
    UIView *showBackView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-35, self.bounds.size.width, 35)];
    showBackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self addSubview:showBackView];
    
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(5, self.bounds.size.height-35, self.bounds.size.width-10, 30)];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor whiteColor];
    titlelabel.font = SystemFont(15);
    titlelabel.text = [self.titles objectAtIndex:selectCurrentPage];
    [self addSubview:titlelabel];
    self.showTitleLabel = titlelabel;
}


- (void) setPageControl
{
    TAPageControl *pageControl = nil;
    CGRect frame = CGRectMake(0, HEIGHT * 0.95, WIDTH, HEIGHT * 0.05);
    pageControl = [[TAPageControl alloc] initWithFrame:frame];
    // Custom dot view with image
    pageControl.dotImage        = [UIImage imageNamed:@"dotInactive"];
    pageControl.currentDotImage = [UIImage imageNamed:@"dotActive"];
    pageControl.numberOfPages = self.datasCount;
    pageControl.currentPage = selectCurrentPage;
    
    [self addSubview:pageControl];
    self.pageControl = pageControl;
    
}

/**
 *  开始拖动，停止自动滚动
 *
 */
- (void) scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self stopAnimation];
}

/**
 *  拖动滚动停止
 *
 */
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self performSelector:@selector(startAnimation) withObject:nil afterDelay:0];
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat x = scrollView.contentOffset.x - self.lastContentX;
    NSUInteger index = fabs(x) / WIDTH;

    if (index == 1) {
        BOOL isRight = (x > 0);
        
        //设置PageControl
        if (self.isNeedAutoScroll  || (!(self.currentPage == self.datasCount - 1 && isRight)  && !(self.currentPage == 0 && !isRight))) {
            [self adjustPage:isRight];
        }
        
        BOOL isNeedAdjust = !((self.currentPage == self.datasCount -1) ||
                              (self.currentPage == self.datasCount -2 && !isRight) ||
                              (self.currentPage == 0) ||
                              (self.currentPage == 1 && isRight));
        
        if (self.isNeedAutoScroll || isNeedAdjust) {
            [self adjustBannerImage:isRight];
            [self adjustBanner];
        }
        
        if (!self.isNeedAutoScroll) {
            [self adjustLastContentX];
        }
        self.showTitleLabel.text = [self.titles objectAtIndex:self.currentPage];
    }
}

- (void) adjustPage:(BOOL) isRight
{
    if (isRight) {
        if (self.currentPage == self.datasCount - 1) {
            self.pageControl.currentPage = 0;
            return;
        }
        self.pageControl.currentPage += 1;

        return;
    }
    
    if (self.currentPage == 0) {
        self.pageControl.currentPage = self.datasCount - 1;
        return;
    }
    self.pageControl.currentPage -= 1;

}

- (void) adjustBannerImage:(BOOL) isRight
{
    int lastIndex =(int) self.datasCount - 1;
    if (isRight) {
        NSDictionary *firstDatas = [self.datas objectAtIndex:0];
        [self.datas removeObject:firstDatas];
        [self.datas addObject:firstDatas];
    }
    else
    {
        NSDictionary *lastDatas = self.datas[lastIndex];
        [self.datas removeObject:lastDatas];
        [self.datas insertObject:lastDatas atIndex:0];
    }
    
    for (int i = 0; i < self.arrBannerImageViews.count; i++) {
        NJBannerImageView *imageV = self.arrBannerImageViews[i];
        NSInteger index = i % [self.datas count];
        imageV.dicProperty = [self.datas objectAtIndex:index];
    }
    
}

- (void) adjustBanner
{
    [self.scrollerView setContentOffset:CGPointMake(WIDTH, 0)];
}

- (void) adjustLastContentX
{
    //如果是最后一个
    if (self.currentPage == self.datasCount - 1) {
        self.lastContentX = WIDTH *2;
    }
    else if (self.currentPage == 0)
    {
        self.lastContentX = 0;
    }
    else
    {
        self.lastContentX = WIDTH;
    }
}

- (void) autoAnimation
{
    [self.scrollerView setContentOffset:CGPointMake(WIDTH * 2, 0) animated:YES];
}

/**
 *  开始滚动
 */

- (void) startAnimation
{
    if (_isNeedAutoScroll && !_timer) {
       _timer = [NSTimer scheduledTimerWithTimeInterval:self.intervalTime target:self selector:@selector(autoAnimation) userInfo:nil repeats:YES];
    }
}

/**
 *  停止滚动
 */
- (void) stopAnimation
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end

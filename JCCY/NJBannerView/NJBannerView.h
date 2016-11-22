//
//  NJBannerView.h
//  BannerViewDemo
//
//  Created by JLee Chen on 16/6/27.
//  Copyright © 2016年 JLee Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol NJBannerViewDataSource <NSObject>

//@optional
//- (UIPageControl *)pageControlOfNJBannerView;
//
//@end

@interface NJBannerView : UIView

/**
 *  datas:字典数组，key:img,value:本地图片名或网络图片地址
 */
@property (strong , nonatomic) NSMutableArray *datas;
@property (strong , nonatomic) NSMutableArray *titles;

/**
 *  点击图片回调事件
 */
@property (copy , nonatomic) void(^linkAction)(NSDictionary *link);
@property (strong , nonatomic) UIImage *placeholderImg;
//@property (weak , nonatomic) id<NJBannerViewDataSource> dataSouce;
//图片滚动间隔,默认为2.0秒
@property (assign , nonatomic) CGFloat intervalTime;
//是否需要自动滚动,默认为YES
@property (assign , nonatomic) BOOL isNeedAutoScroll;

- (id) initWithFrame:(CGRect)frame placeholderImg:(UIImage *) placeholderImg;
@end

//
//  NJBannerImageView.m
//  BannerViewDemo
//
//  Created by JLee Chen on 16/6/27.
//  Copyright © 2016年 JLee Chen. All rights reserved.
//

#import "NJBannerImageView.h"
#import "UIImageView+WebCache.h"

@interface NJBannerImageView ()

@property (weak , nonatomic) UIImageView *imgV;

@end

@implementation NJBannerImageView

- (id) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:self.bounds];
        imgV.contentMode = UIViewContentModeScaleAspectFill;
        imgV.clipsToBounds = YES;
        [self addSubview:imgV];
        _imgV = imgV;
        
        [self addTarget:self action:@selector(bannerAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (void) setDicProperty:(NSDictionary *)dicProperty
{
    _dicProperty = dicProperty;
    
    NSString *imgURL = _dicProperty[@"img"];
    if ([imgURL hasPrefix:@"http"] || [imgURL hasPrefix:@"https"]) {  //网络图片
        UIImage *adimg = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imgURL];
        
        if (adimg) {
            [_imgV setImage:adimg];
        }else{
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager downloadImageWithURL:[NSURL URLWithString:imgURL]
                                  options:0
                                 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                     // progression tracking code
                                 }
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                    if (image) {
                                        // do something with image
                                        [_imgV setImage:image];
                                        
                                        [[SDImageCache sharedImageCache] storeImage:image forKey:imgURL];
                                    }
                                }];
        }
    }
    else
    {
        _imgV.image = [UIImage imageNamed:imgURL];
        
    }
}

- (void) bannerAction
{
    if (!_dicProperty || !_dicProperty[@"data"]) {
        return;
    }
    if (_linkAction) {
        NSDictionary *link = _dicProperty[@"data"];
        self.linkAction(link);
    }
}

@end


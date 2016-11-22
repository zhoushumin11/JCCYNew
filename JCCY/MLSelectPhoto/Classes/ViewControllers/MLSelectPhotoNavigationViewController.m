//  github: https://github.com/MakeZL/MLSelectPhoto
//  author: @email <120886865@qq.com>
//
//  MLNavigationViewController.m
//  MLSelectPhoto
//
//  Created by 张磊 on 15/4/22.
//  Copyright (c) 2015年 com.zixue101.www. All rights reserved.
//

#define isAtLeastiOS7 (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)


#import "MLSelectPhotoNavigationViewController.h"
#import "MLSelectPhotoCommon.h"

@interface MLSelectPhotoNavigationViewController ()

@end

@implementation MLSelectPhotoNavigationViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    
    UINavigationController *rootVc = (UINavigationController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    
    if ([rootVc isKindOfClass:[UINavigationController class]]) {
        [self.navigationBar setValue:DefaultNavbarTintColor forKeyPath:@"barTintColor"];
        [self.navigationBar setTintColor:DefaultNavTintColor];
        [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:DefaultNavTitleColor}];
        
    }else{
        [self.navigationBar setValue:DefaultNavbarTintColor forKeyPath:@"barTintColor"];
        [self.navigationBar setTintColor:DefaultNavTintColor];
        [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:DefaultNavTitleColor}];
    }
    
    if (isAtLeastiOS7) {
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_backimg.png"] forBarMetrics:UIBarMetricsDefault];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = YES;
        self.extendedLayoutIncludesOpaqueBars = YES;
    }else{
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_backimg.png"] forBarMetrics:UIBarMetricsDefault];
    }
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName :DefaultNavTitleColor,NSFontAttributeName:[UIFont boldSystemFontOfSize:18.]}];
}
@end

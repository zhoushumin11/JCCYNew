//
//  LBNavigationController.m
//  XianYu
//
//  Created by li  bo on 16/5/28.
//  Copyright © 2016年 li  bo. All rights reserved.
//

#import "LBNavigationController.h"
#import "LBTabBarController.h"
#import "UIImage+Image.h"
//黄色导航栏
#define NavBarColor [UIColor colorWithRed:250/255.0 green:227/255.0 blue:111/255.0 alpha:1.0]
@interface LBNavigationController ()

@end

@implementation LBNavigationController

+ (void)load
{

    UIBarButtonItem *item=[UIBarButtonItem appearanceWhenContainedIn:self, nil ];
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[NSFontAttributeName]=[UIFont systemFontOfSize:18];
    dic[NSForegroundColorAttributeName]=[UIColor whiteColor];
    [item setTitleTextAttributes:dic forState:UIControlStateNormal];

    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[self]];
   
    [bar setBackgroundImage:[UIImage imageWithColor:[UIColor colorFromHexRGB:@"e60013"]] forBarMetrics:UIBarMetricsDefault];
    NSMutableDictionary *dicBar=[NSMutableDictionary dictionary];

    dicBar[NSFontAttributeName]=[UIFont systemFontOfSize:15];
    [bar setTitleTextAttributes:dic];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
//    self.navigationBar.tintColor = [UIColor whiteColor];
//    NSDictionary  *textAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]};
//    // 设置导航栏的字体大小  颜色
//    [self.navigationBar setTitleTextAttributes:textAttributes];
//    self.navigationBar.tintColor = [UIColor whiteColor];
//    self.navigationBar.barTintColor = [UIColor colorFromHexRGB:@"e60013"];
    self.navigationBar.barStyle = UIBarStyleBlack;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{

    if (self.viewControllers.count > 0) {
        
        viewController.hidesBottomBarWhenPushed = YES;

    }

    return [super pushViewController:viewController animated:animated];
}









@end

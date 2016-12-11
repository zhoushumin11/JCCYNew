//
//  LBTabBarController.m
//  XianYu
//
//  Created by li  bo on 16/5/28.
//  Copyright © 2016年 li  bo. All rights reserved.
//

#import "LBTabBarController.h"
#import "LBNavigationController.h"

#import "HomeViewController.h"
#import "FirmViewController.h"
#import "RedPacketViewController.h"
#import "FourViewController.h"
#import "FiveViewController.h"

#import "LBTabBar.h"
#import "UIImage+Image.h"

#import "PPNavigationController.h"


@interface LBTabBarController ()<LBTabBarDelegate>

@end

@implementation LBTabBarController

#pragma mark - 第一次使用当前类的时候对设置UITabBarItem的主题
+ (void)initialize
{
    UITabBarItem *tabBarItem = [UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[self]];
    
    NSMutableDictionary *dictNormal = [NSMutableDictionary dictionary];
    dictNormal[NSForegroundColorAttributeName] = [UIColor grayColor];
    dictNormal[NSFontAttributeName] = [UIFont systemFontOfSize:11];

    NSMutableDictionary *dictSelected = [NSMutableDictionary dictionary];
    dictSelected[NSForegroundColorAttributeName] = [UIColor colorFromHexRGB:@"e60013"];
    dictSelected[NSFontAttributeName] = [UIFont systemFontOfSize:11];

    [tabBarItem setTitleTextAttributes:dictNormal forState:UIControlStateNormal];
    [tabBarItem setTitleTextAttributes:dictSelected forState:UIControlStateSelected];

}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpAllChildVc];

    //创建自己的tabbar，然后用kvc将自己的tabbar和系统的tabBar替换下
    LBTabBar *tabbar = [[LBTabBar alloc] init];
    tabbar.myDelegate = self;
    //kvc实质是修改了系统的_tabBar
    [self setValue:tabbar forKeyPath:@"tabBar"];


}


#pragma mark - ------------------------------------------------------------------
#pragma mark - 初始化tabBar上除了中间按钮之外所有的按钮

- (void)setUpAllChildVc
{

    HomeViewController *homeViewController = [[HomeViewController alloc] init];
    homeViewController.view.tag = 0;
    [self setUpOneChildVcWithVc:homeViewController Image:@"tabBar_icon_shouye_normal1@2x" selectedImage:@"tabBar_icon_shouye_selected1@2x" title:@"首页"];

    FirmViewController *firmViewController = [[FirmViewController alloc] init];
    firmViewController.view.tag = 1;
    [self setUpOneChildVcWithVc:firmViewController Image:@"tabBar_icon_shipan_normal1@2x" selectedImage:@"tabBar_icon_shipan_selected1@2x" title:@"实盘"];

    FourViewController *fourViewController = [[FourViewController alloc] init];
    fourViewController.view.tag = 2;
    [self setUpOneChildVcWithVc:fourViewController Image:@"tabBar_icon_miji_normal1@2x" selectedImage:@"tabBar_icon_miji_selected1@2x" title:@"秘籍"];

    FiveViewController *fiveViewController = [[FiveViewController alloc] init];
    fiveViewController.view.tag = 3;
    [self setUpOneChildVcWithVc:fiveViewController Image:@"tabBar_icon_kaihu_normal1@2x" selectedImage:@"tabBar_icon_kaihu_selected1@2x" title:@"开户"];
    

}

#pragma mark - 初始化设置tabBar上面单个按钮的方法

/**
 *  @author li bo, 16/05/10
 *
 *  设置单个tabBarButton
 *
 *  @param Vc            每一个按钮对应的控制器
 *  @param image         每一个按钮对应的普通状态下图片
 *  @param selectedImage 每一个按钮对应的选中状态下的图片
 *  @param title         每一个按钮对应的标题
 */
- (void)setUpOneChildVcWithVc:(UIViewController *)Vc Image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title
{
    PPNavigationController *nav = [[PPNavigationController alloc] initWithRootViewController:Vc];
    UIImage *myImage = [UIImage imageNamed:image];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //tabBarItem，是系统提供模型，专门负责tabbar上按钮的文字以及图片展示
    Vc.tabBarItem.image = myImage;

    UIImage *mySelectedImage = [UIImage imageNamed:selectedImage];
    mySelectedImage = [mySelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    Vc.tabBarItem.selectedImage = mySelectedImage;

    Vc.tabBarItem.title = title;
    
    Vc.tabBarItem.tag = Vc.view.tag;
    
//    Vc.navigationItem.title = title;

    [self addChildViewController:nav];
    
}



#pragma mark - ------------------------------------------------------------------
#pragma mark - LBTabBarDelegate
//点击中间按钮的代理方法
- (void)tabBarPlusBtnClick:(LBTabBar *)tabBar
{

    RedPacketViewController *plusVC = [[RedPacketViewController alloc] init];
    PPNavigationController *navVc = [[PPNavigationController alloc] initWithRootViewController:plusVC];
    [self presentViewController:navVc animated:YES completion:nil];



}




@end

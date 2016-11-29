//
//  BXTabBarController.m
//  BaoXianDaiDai
//
//  Created by JYJ on 15/5/28.
//  Copyright (c) 2015年 baobeikeji.cn. All rights reserved.
//

#import "BXTabBarController.h"
#import "BXNavigationController.h"
//五个控制器
#import "HomeViewController.h"
#import "FirmViewController.h"
#import "RedPacketViewController.h"
#import "FourViewController.h"
#import "FiveViewController.h"

#import "BXTabBar.h"

#define kTabbarHeight 49

@interface BXTabBarController ()<UITabBarControllerDelegate, UINavigationControllerDelegate, BXTabBarDelegate>

@property (nonatomic, assign) NSInteger lastSelectIndex;
@property (nonatomic, strong) UIView *redPoint;
/** view */
@property (nonatomic, strong) BXTabBar *mytabbar;

@property (nonatomic, strong) id popDelegate;
/** 保存所有控制器对应按钮的内容（UITabBarItem）*/
@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation BXTabBarController
+ (void)initialize {
    // 设置tabbarItem的普通文字
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [[UIColor alloc]initWithRed:113/255.0 green:109/255.0 blue:104/255.0 alpha:1];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    
    
    //设置tabBarItem的选中文字颜色
    NSMutableDictionary *selectedTextAttrs = [NSMutableDictionary dictionary];
    selectedTextAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:230/255.0 green:0/255.0 blue:19/255.0 alpha:1.0];

    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
}


- (NSMutableArray *)items {
    if (_items == nil) {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBar.hidden = YES;
    // 把系统的tabBar上的按钮干掉
    [self.tabBar removeFromSuperview];
    // 把系统的tabBar上的按钮干掉
    for (UIView *childView in self.tabBar.subviews) {
        if (![childView isKindOfClass:[BXTabBar class]]) {
            [childView removeFromSuperview];
            
        }
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
   
    
    self.tabBar.tintColor = [UIColor colorFromHexRGB:@"e60013"];
    
    // 添加所有子控制器
    [self addAllChildVc];
 
    // 自定义tabBar
    [self setUpTabBar];
    // 设置选中一定要在设置完tabBar以后, 默认选中第0个
    // self.selectedIndex = 0;
}

#pragma mark - 自定义tabBar
- (void)setUpTabBar
{
    BXTabBar *tabBar = [[BXTabBar alloc] init];
    // 存储UITabBarItem
    tabBar.items = self.items;
    
    tabBar.delegate = self;
    
    tabBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tab_background"]];
    
    tabBar.frame = self.tabBar.frame;
    [self.view addSubview:tabBar];
    self.mytabbar = tabBar;
}



/**
 *  添加所有的子控制器
 */
- (void)addAllChildVc {
    // 添加初始化子控制器 BXHomeViewController
    
    self.tabBar.tintColor = [UIColor colorFromHexRGB:@"e60013"];

    HomeViewController *home = [[HomeViewController alloc] init];
    [self addOneChildVC:home title:@"首页" imageName:@"tabBar_icon_shouye_normal" selectedImageName:@"tabBar_icon_shouye_selected"];
    
    FirmViewController *customer = [[FirmViewController alloc] init];
//    customer.tabBarItem.badgeValue = @"100";
    [self addOneChildVC:customer title:@"实盘" imageName:@"tabBar_icon_shipan_normal" selectedImageName:@"tabBar_icon_shipan_selected"];
    
    RedPacketViewController *insurance = [[RedPacketViewController alloc] init];
    [self addOneChildVC:insurance title:@"红包" imageName:@"tab_redparket" selectedImageName:@"tab_redparket"];
    
    FourViewController *compare = [[FourViewController alloc] init];
    [self addOneChildVC:compare title:@"秘籍" imageName:@"tabBar_icon_miji_normal" selectedImageName:@"tabBar_icon_miji_normal"];
    
    FiveViewController *profile = [[FiveViewController alloc]init];
    [self addOneChildVC:profile title:@"开户" imageName:@"tabBar_icon_kaihu_normal" selectedImageName:@"tabBar_icon_kaihu_normal"];
    
    
    //    //2.初始化tabBar视图控制器
//        pptabBarController = [[PPTabBarController alloc]init];
//        pptabBarController.tabBar.tintColor = [UIColor colorFromHexRGB:@"e60013"];
//        pptabBarController.delegate = self;
//        //    pptabBarController.tabBar.barTintColor = [UIColor colorFromHexRGB:@"fafafa"];
//    
//        HomeViewController *oneVC = [[HomeViewController alloc]init];
//        oneVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"home_bar1@2x.png"] selectedImage:[UIImage imageNamed:@"home_bar@2x.png"]];
//        [oneVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                  [UIColor colorFromHexRGB:@"999999"], NSForegroundColorAttributeName,
//                                                  [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName, nil]
//                                        forState:UIControlStateNormal];
//        [oneVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                  [UIColor colorFromHexRGB:@"e60013"], NSForegroundColorAttributeName,
//                                                  [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName, nil]
//                                        forState:UIControlStateSelected];
//    
//        PPNavigationController *oneNav = [[PPNavigationController alloc]initWithRootViewController:oneVC];
//        curNavController = oneNav;
//    
//        FirmViewController *twoVC = [[FirmViewController alloc]init];
//        twoVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"实盘" image:[UIImage imageNamed:@"firm_bar1@2x.png"] selectedImage:[UIImage imageNamed:@"firm_bar@2x.png"]];
//        [twoVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                  [UIColor colorFromHexRGB:@"999999"], NSForegroundColorAttributeName,
//                                                  [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName, nil]
//                                        forState:UIControlStateNormal];
//        [twoVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                  [UIColor colorFromHexRGB:@"e60013"], NSForegroundColorAttributeName,
//                                                  [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName, nil]
//                                        forState:UIControlStateSelected];
//    
//        PPNavigationController *twoNav = [[PPNavigationController alloc]initWithRootViewController:twoVC];
//    
//        ThreeViewController *threeVC = [[ThreeViewController alloc]init];
//        threeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"红包" image:[UIImage imageNamed:@"redPack_bar1@2x.png"] selectedImage:[UIImage imageNamed:@"redPack_bar@2x.png"]];
//        [threeVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                    [UIColor colorFromHexRGB:@"999999"], NSForegroundColorAttributeName,
//                                                    [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName, nil]
//                                          forState:UIControlStateNormal];
//        [threeVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                    [UIColor colorFromHexRGB:@"e60013"], NSForegroundColorAttributeName,
//                                                    [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName, nil]
//                                          forState:UIControlStateSelected];
//    
//        PPNavigationController *threeNav = [[PPNavigationController alloc]initWithRootViewController:threeVC];
//    
//        FourViewController *fourVC = [[FourViewController alloc]init];
//        fourVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"秘籍" image:[UIImage imageNamed:@"miji_bar@2x.png"] selectedImage:[UIImage imageNamed:@"miji_bar@2x.png"]];
//        [fourVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                     [UIColor colorFromHexRGB:@"999999"], NSForegroundColorAttributeName,
//                                                     [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName, nil]
//                                           forState:UIControlStateNormal];
//        [fourVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                     [UIColor colorFromHexRGB:@"e60013"], NSForegroundColorAttributeName,
//                                                     [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName, nil]
//                                           forState:UIControlStateSelected];
//    
//        PPNavigationController *fourNav = [[PPNavigationController alloc]initWithRootViewController:fourVC];
//    
//    
//        FiveViewController *fiveVC = [[FiveViewController alloc]init];
//        fiveVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"开户" image:[UIImage imageNamed:@"kaihu_bar@2x.png"] selectedImage:[UIImage imageNamed:@"kaihu_bar@2x.png"]];
//        [fiveVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                     [UIColor colorFromHexRGB:@"999999"], NSForegroundColorAttributeName,
//                                                     [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName, nil]
//                                           forState:UIControlStateNormal];
//        [fiveVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                     [UIColor colorFromHexRGB:@"e60013"], NSForegroundColorAttributeName,
//                                                     [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName, nil]
//                                           forState:UIControlStateSelected];
//    
//        PPNavigationController *fiveNav = [[PPNavigationController alloc]initWithRootViewController:fiveVC];
//    
//    
//        //    SecondNav
//        pptabBarController.viewControllers = @[oneNav, twoNav, threeNav,fourNav,fiveNav];
//    
//    
//        CGFloat ww = pptabBarController.tabBar.bounds.size.width/5*0.63;
//    
//        self.cornerLabel = [[UILabel alloc] initWithFrame:CGRectMake(ww, 2, 8, 8)];
//        cornerLabel.layer.cornerRadius = 4;
//        cornerLabel.clipsToBounds = YES;
//        cornerLabel.backgroundColor = [UIColor colorFromHexRGB:@"f74c31"];
//        cornerLabel.hidden = YES;
//    
//        [pptabBarController.tabBar addSubview:cornerLabel];
//        
//        tabbarbuttonArray = [NSMutableArray array];
//        for (UIView *tabBarButton in self.pptabBarController.tabBar.subviews) {
//            if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
//                [tabbarbuttonArray addObject:tabBarButton];
//            }
//        }
}


/**
 *  添加一个自控制器
 *
 *  @param childVc           子控制器对象
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中时的图标
 */

- (void)addOneChildVC:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName {
    // 设置标题
    childVc.tabBarItem.title = title;
    
    // 设置图标
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    
    // 设置选中的图标
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    // 不要渲染
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = selectedImage;
    
    // 记录所有控制器对应按钮的内容
    [self.items addObject:childVc.tabBarItem];
    
    // 添加为tabbar控制器的子控制器
    BXNavigationController *nav = [[BXNavigationController alloc] initWithRootViewController:childVc];

    nav.delegate = self;
    [self addChildViewController:nav];
}

#pragma mark - BXTabBarDelegate方法
// 监听tabBar上按钮的点击
- (void)tabBar:(BXTabBar *)tabBar didClickBtn:(NSInteger)index
{
    [super setSelectedIndex:index];
}

/**
 *  让myTabBar选中对应的按钮
 */
- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    // 通过mytabbar的通知处理页面切换
    self.mytabbar.seletedIndex = selectedIndex;
}


#pragma mark navVC代理
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    UIViewController *root = navigationController.viewControllers.firstObject;
    self.tabBar.hidden = YES;
    if (viewController != root) {
        //从HomeViewController移除
        [self.mytabbar removeFromSuperview];
        // 调整tabbar的Y值
        CGRect dockFrame = self.mytabbar.frame;

        dockFrame.origin.y = root.view.frame.size.height - kTabbarHeight;
        if ([root.view isKindOfClass:[UIScrollView class]]) { // 根控制器的view是能滚动
            UIScrollView *scrollview = (UIScrollView *)root.view;
            dockFrame.origin.y += scrollview.contentOffset.y;
        }
        self.mytabbar.frame = dockFrame;
        // 添加dock到根控制器界面
        [root.view addSubview:self.mytabbar];
    }
}

// 完全展示完调用
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    UIViewController *root = navigationController.viewControllers.firstObject;
    BXNavigationController *nav = (BXNavigationController *)navigationController;
    if (viewController == root) {
        // 更改导航控制器view的frame
//        navigationController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kTabbarHeight);
        
        navigationController.interactivePopGestureRecognizer.delegate = nav.popDelegate;
        // 让Dock从root上移除
        [_mytabbar removeFromSuperview];
 
        //_mytabbar添加dock到HomeViewController
        _mytabbar.frame = self.tabBar.frame;
        [self.view addSubview:_mytabbar];
    }
}

@end

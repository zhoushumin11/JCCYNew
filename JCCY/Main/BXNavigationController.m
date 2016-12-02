
//
//  BXNavigationController.m
//  BaoXianDaiDai
//
//  Created by JYJ on 15/5/28.
//  Copyright (c) 2015年 baobeikeji.cn. All rights reserved.
//

#import "BXNavigationController.h"

@interface BXNavigationController () <UINavigationControllerDelegate>
//@property (nonatomic, strong) id popDelegate;
@end

@implementation BXNavigationController

+ (void)initialize {
    // 设置UIUINavigationBar的主题
    [self setupNavigationBarTheme];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.popDelegate = self.interactivePopGestureRecognizer.delegate;
    self.delegate = self;
    self.navigationBar.tintColor = [UIColor whiteColor];
    NSDictionary  *textAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]};
    // 设置导航栏的字体大小  颜色
    [self.navigationBar setTitleTextAttributes:textAttributes];
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.barTintColor = [UIColor colorFromHexRGB:@"e60013"];
    self.navigationBar.barStyle = UIBarStyleBlack;
}

/**
 *  设置UIBarButtonItem的主题
 */
+ (void)setupNavigationBarTheme {
    
 }


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {// 如果现在push的不是栈底控制器(最先push进来的那个控制器)
        viewController.hidesBottomBarWhenPushed = YES;
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -5;
        
        //设置导航栏的按钮
        UIBarButtonItem *backButton = [UIBarButtonItem itemWithImageName:@"navigationbar_back_image" highImageName:@"navigationbar_back_image" target:self action:@selector(back)];
        viewController.navigationItem.leftBarButtonItems = @[negativeSpacer, backButton];
        
        // 就有滑动返回功能
        self.interactivePopGestureRecognizer.delegate = nil;
    }
    [super pushViewController:viewController animated:animated];
}

//// 完全展示完调用
//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    // 如果展示的控制器是根控制器，就还原pop手势代理
//    if (viewController == [self.viewControllers firstObject]) {
//        self.interactivePopGestureRecognizer.delegate = self.popDelegate;
//    }
//}

- (void)back {
    [self popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


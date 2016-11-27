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


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.tintColor = [UIColor whiteColor];
    NSDictionary  *textAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]};
    // 设置导航栏的字体大小  颜色
    [self.navigationBar setTitleTextAttributes:textAttributes];
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.barTintColor = [UIColor colorFromHexRGB:@"e60013"];
    self.navigationBar.barStyle = UIBarStyleBlack;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

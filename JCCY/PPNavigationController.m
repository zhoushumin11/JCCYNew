//
//  PPNavigationController.m
//  ParkProject
//
//  Created by yuanxuan on 16/6/27.
//  Copyright © 2016年 yuanxuan. All rights reserved.
//

#import "PPNavigationController.h"

@interface PPNavigationController ()

@end

@implementation PPNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.tintColor = [UIColor whiteColor];
    NSDictionary  *textAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]};
    // 设置导航栏的字体大小  颜色
    [self.navigationBar setTitleTextAttributes:textAttributes];
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.barTintColor = [UIColor colorFromHexRGB:@"e60013"];
    self.navigationBar.barStyle = UIBarStyleBlack;

    // Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

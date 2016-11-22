//
//  FiveViewController.m
//  JCCY
//
//  Created by 周书敏 on 2016/11/18.
//
//

#import "FiveViewController.h"

@interface FiveViewController ()

@end

@implementation FiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"开户";
    self.navigationController.navigationBar.barTintColor = [UIColor colorFromHexRGB:@"e60013"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

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

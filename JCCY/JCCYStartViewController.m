//
//  SpbStartViewController.m
//  SmartPhonebook
//
//  Created by kaiyitech on 14-3-3.
//  Copyright (c) 2014年 中国移动通信湖北分公司. All rights reserved.
//

#import "JCCYStartViewController.h"
#import "AppDelegate.h"
@interface JCCYStartViewController ()

@end

@implementation JCCYStartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self showIntroWithCrossDissolve];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)showIntroWithCrossDissolve {
    EAIntroPage *page1 = [EAIntroPage page];
    page1.bgImage = [UIImage imageNamed:@"yingdaoye.jpg"];
    
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1]];
    
    [intro setDelegate:self];
    [intro showInView:self.view animateDuration:0.0 button:self.buttonTitle];
}

- (void)introDidFinish {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate setupViewControllers];
    //设置本地存储值
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:@"1" forKey:@"isLooked4"];//已经看过滑页
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];//当前APP中的版本
    [userDefault setObject:appVersion forKey:@"oldVersion"];//已经看过滑页
    [userDefault synchronize];
 }
@end

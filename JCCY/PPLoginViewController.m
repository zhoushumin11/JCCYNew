//
//  PPLoginViewController.m
//  ParkProject
//
//  Created by yuanxuan on 16/6/27.
//  Copyright © 2016年 yuanxuan. All rights reserved.
//

#import "PPLoginViewController.h"
#import "EYInputPopupView.h"
#import "EYTextPopupView.h"

#import "AppDelegate.h"


#import <UMSocialCore/UMSocialCore.h>

#define UMSUserInfoPlatformTypeKey @"UMSUserInfoPlatformTypeKey"
#define UMSUserInfoPlatformNameKey @"UMSUserInfoPlatformNameKey"
#define UMSUserInfoPlatformIconNameKey @"UMSUserInfoPlatformIconNameKey"


@interface PPLoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *platformInfoArray;

@property (nonatomic, strong) UIScrollView *mainView;
@end

@implementation PPLoginViewController
@synthesize mainView;


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor colorFromHexRGB:@"f8f8f8"];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mainView = [[UIScrollView alloc] initWithFrame:PPMainFrame];
    mainView.backgroundColor = [UIColor whiteColor];
    mainView.scrollEnabled = NO;
    [self.view addSubview:mainView];
    
    UIImageView *iconimgView = [[UIImageView alloc] initWithFrame:CGRectMake(PPMainViewWidth/2 - 100,150, 200, 200)];
    iconimgView.image = [UIImage imageNamed:@"loginBackImg.png"];
    [mainView addSubview:iconimgView];
    
    //第三方登录label
    UILabel *thirdLoginLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,iconimgView.frame.origin.y + 250, PPMainViewWidth, 30)];
    thirdLoginLabel.textColor = [UIColor colorFromHexRGB:@"999999"];
    thirdLoginLabel.textAlignment = NSTextAlignmentCenter;
    thirdLoginLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:18];
    thirdLoginLabel.text = @"————— 请您使用微信登录 —————";
    [mainView addSubview:thirdLoginLabel];
    

    //第三方登录Button

    UIButton *wechatLoginBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    wechatLoginBtn.frame = CGRectMake(PPMainViewWidth/2 - 40, thirdLoginLabel.frame.origin.y + 50, 80 ,80);
    [wechatLoginBtn setBackgroundImage:[UIImage imageNamed:@"wechatLoginBtn"] forState:UIControlStateNormal];
    [wechatLoginBtn addTarget:self action:@selector(wechatLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:wechatLoginBtn];
    
    
}




//微信登录
-(void)wechatLoginBtn:(UIButton *)btn{

    //如果需要获得用户信息直接跳转的话，需要先取消授权
    //step1 取消授权
    [[UMSocialManager defaultManager] cancelAuthWithPlatform:UMSocialPlatformType_WechatSession completion:^(id result, NSError *error) {
    
        //step2 获得用户信息(获得用户信息中包含检查授权的信息了)
        [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
            
            NSString *message = nil;
            
            if (error) {
                message = @"Get user info fail";
                UMSocialLogInfo(@"Get user info fail with error %@",error);
            }else{
                if ([result isKindOfClass:[UMSocialUserInfoResponse class]]) {
                    UMSocialUserInfoResponse *resp = result;
                    // 授权信息
                    UMSocialLogInfo(@"UserInfoAuthResponse uid: %@", resp.uid);
                    UMSocialLogInfo(@"UserInfoAuthResponse accessToken: %@", resp.accessToken);
                    UMSocialLogInfo(@"UserInfoAuthResponse refreshToken: %@", resp.refreshToken);
                    UMSocialLogInfo(@"UserInfoAuthResponse expiration: %@", resp.expiration);
                    
                    // 用户信息
                    UMSocialLogInfo(@"UserInfoResponse name: %@", resp.name);
                    UMSocialLogInfo(@"UserInfoResponse iconurl: %@", resp.iconurl);
                    UMSocialLogInfo(@"UserInfoResponse gender: %@", resp.gender);
                    
                    // 第三方平台SDK源数据,具体内容视平台而定
                    UMSocialLogInfo(@"OriginalUserProfileResponse: %@", resp.originalResponse);
                    
                    message = [NSString stringWithFormat:@"name: %@\n icon: %@\n gender: %@\n  %@",resp.name,resp.iconurl,resp.gender,resp.uid];
                    // 保存信息
                    NSString *userId = resp.uid;
                    NSString *userIcon = resp.iconurl;
                    NSString *accessToken = resp.accessToken;
                    NSString *name = resp.name;
                    NSString *unionid = [resp.originalResponse objectForKey:@"unionid"];

                    

                    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"userId"];
                    [[NSUserDefaults standardUserDefaults] setObject:userIcon forKey:@"userIcon"];
                    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"accessToken"];
                    [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"userName"];
                    [[NSUserDefaults standardUserDefaults] setObject:unionid forKey:@"unionid"];
                    [[NSUserDefaults standardUserDefaults] synchronize];

                    
                    [self checkPhoneBangdingSucc:unionid :accessToken];
                    
                    
                }else{
                    message = @"Get user info fail";
                    UMSocialLogInfo(@"Get user info fail with  unknow error");
                }
            }

        }];
    }];
}

//登录
-(void)checkPhoneBangdingSucc:(NSString *)userId :(NSString *)accessToken {
    
    [WSProgressHUD showWithStatus:nil maskType:WSProgressHUDMaskTypeDefault];

    
    NSString *dJson = nil;
    dJson = [NSString stringWithFormat:@"{\"update_id\":\"%d\",\"token\":\"%@\",\"access_token\":\"%@\",\"openid\":\"%@\"}",87,@"",accessToken,userId];
        //获取类型接口
        PPRDData *pprddata1 = [[PPRDData alloc] init];
        [pprddata1 startAFRequest:@"/index.php/Api/Login/do_login/"
                      requestdata:dJson
                   timeOutSeconds:10
                  completionBlock:^(NSDictionary *json) {
                      
                      NSInteger code = [[json objectForKey:@"code"] integerValue];
                      
                      if (code == 1) {
                          
                          [WSProgressHUD showSuccessWithStatus:@"登录成功"];
                          [WSProgressHUD autoDismiss:2];
                          //保存token信息
                          NSDictionary *dataDic = [json objectForKey:@"data"];
                          NSString *token = [dataDic objectForKey:@"token"];
                          [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
                          [[NSUserDefaults standardUserDefaults] synchronize];

                          //再获取用户信息
                          [self getUserInfo];
                          
                      }else{
                          [WSProgressHUD showSuccessWithStatus:@"登录失败"];
                          [WSProgressHUD dismiss];
                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"微信授权失败,请稍后再试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                          [alert show];
                      }
                      
                  }
                failedBlock:^(NSError *error) {

        }];

}

-(void)getUserInfo{
    
    [WSProgressHUD showWithStatus:@"正在初始化用户数据" maskType:WSProgressHUDMaskTypeDefault];
        NSString *dJson = nil;
        //得到自己当前的下属
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        dJson = [NSString stringWithFormat:@"{\"update_id\":\"%d\",\"token\":\"%@\"}",87,token];
        //获取类型接口
        PPRDData *pprddata1 = [[PPRDData alloc] init];
        [pprddata1 startAFRequest:@"/index.php/Api/User/get_info/"
                      requestdata:dJson
                   timeOutSeconds:10
                  completionBlock:^(NSDictionary *json) {
                      NSInteger code = [[json objectForKey:@"code"] integerValue];
                      if (code == 1) {
                          
                          [WSProgressHUD showSuccessWithStatus:@"获取成功"];
                          [WSProgressHUD autoDismiss:2];
                          
                          NSDictionary *dataDic = [json objectForKey:@"data"];
                          NSUInteger golds = [[dataDic objectForKey:@"golds"] integerValue];
                          NSUInteger present_time = [[dataDic objectForKey:@"present_time"] integerValue];
                          NSUInteger time_service_1 = [[dataDic objectForKey:@"time_service_1"] integerValue];
                          NSUInteger time_service_2 = [[dataDic objectForKey:@"time_service_2"] integerValue];
                          NSUInteger time_service_3 = [[dataDic objectForKey:@"time_service_3"] integerValue];
                          NSString *user_chinese_name = [dataDic objectForKey:@"user_chinese_name"];
                          NSString *user_city = [dataDic objectForKey:@"user_city"];
                          NSString *user_level = [dataDic objectForKey:@"user_level"];
                          NSString *user_phone = [dataDic objectForKey:@"user_phone"];
                          NSString *user_pic = [dataDic objectForKey:@"user_pic"];
                          NSString *user_province = [dataDic objectForKey:@"user_province"];

                          NSUserDefaults *userDefauls = [NSUserDefaults standardUserDefaults];
                          [userDefauls setObject:[NSNumber numberWithInteger:golds] forKey:@"golds"];
                          [userDefauls setObject:[NSNumber numberWithInteger:present_time] forKey:@"present_time"];
                          [userDefauls setObject:[NSNumber numberWithInteger:time_service_1] forKey:@"time_service_1"];
                          [userDefauls setObject:[NSNumber numberWithInteger:time_service_2] forKey:@"time_service_2"];
                          [userDefauls setObject:[NSNumber numberWithInteger:time_service_3] forKey:@"time_service_3"];
                          [userDefauls setObject:user_chinese_name forKey:@"user_chinese_name"];
                          [userDefauls setObject:user_city forKey:@"user_city"];
                          [userDefauls setObject:user_level forKey:@"user_level"];
                          [userDefauls setObject:user_phone forKey:@"user_phone"];
                          [userDefauls setObject:user_pic forKey:@"user_pic"];
                          [userDefauls setObject:user_province forKey:@"user_province"];
                          [userDefauls synchronize];
                          //判断手机号是否绑定  如果没有 就绑定
                          if (user_phone == nil || user_phone.length == 0) {
                              [self bangdingPhone];
                          }else{
                              [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isBangding"];
                              [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isLogin"];
                              [[NSUserDefaults standardUserDefaults] synchronize];
                              AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
                              [appdel setupViewControllers];
                          }
                          
                      
                      }else{
                          NSString *msg = [json objectForKey:@"info"];
                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                          [alert show];
                          

                      }
                  }
                      failedBlock:^(NSError *error) {

                      }];
    
}


-(void)bangdingPhone{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isBangding"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdel setupViewControllers];

}


- (void)autoDismiss
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [WSProgressHUD dismiss];
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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

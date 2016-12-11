//
//  AppDelegate.m
//  JCCY
//
//  Created by 周书敏 on 2016/11/18.
//
//

#import "AppDelegate.h"
#import "CoreStatus.h"  //检查网络

#import "PPTabBarController.h"
#import "PPNavigationController.h"
#import "LBTabBarController.h"



#import "PPLoginViewController.h"
#import "PPRegistViewController.h"//绑定手机号
//启动页
#import "JCCYStartViewController.h"

#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

//五个控制器
#import "HomeViewController.h"
#import "FirmViewController.h"
#import "RedPacketViewController.h"
#import "FourViewController.h"
#import "FiveViewController.h"

//友盟第三方登录
#import <UMSocialCore/UMSocialCore.h>


// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import <AdSupport/ASIdentifierManager.h>

#import <sys/utsname.h>
#import "AdvertiseView.h"

@interface AppDelegate ()<CoreStatusProtocol,UITabBarControllerDelegate,JPUSHRegisterDelegate,UMSocialPlatformProvider,UIAlertViewDelegate,WXApiDelegate>
{
    PPNavigationController *curNavController;
    NSDictionary *notifactionUserInfo;

}

@property (nonatomic, assign) NSInteger indexFlag;
@property (nonatomic, strong) NSString *currentDeviceToken;
@property (nonatomic, strong) NSString *updateUrl; //更新的网址
@property (nonatomic, strong) UILabel *cornerLabel;
@property (nonatomic, strong) NSMutableArray *tabbarbuttonArray;

@end

@implementation AppDelegate
@synthesize currentStatus;
@synthesize ppLoginNavigationController,pptabBarController;
@synthesize cornerLabel;
@synthesize currentDeviceToken;
@synthesize tabbarbuttonArray;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSString *severurlstr = [[NSUserDefaults standardUserDefaults] objectForKey:SEVERURL];
    if (severurlstr == nil) {
        //设置服务器地址
        [PPAPPDataClass sharedappData].severUrl = severurl;
    }else{
        [PPAPPDataClass sharedappData].severUrl = severurlstr;
    }
    
#pragma mark --- 设置友盟 Begin ----
    //打开日志
    [[UMSocialManager defaultManager] openLog:YES];
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"5832b24ac62dca51f500018e"];
    // 获取友盟social版本号
    NSLog(@"UMeng social version: %@", [UMSocialGlobal umSocialSDKVersion]);
    //设置微信的appId和appKey
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxbc85f05c6861a34e" appSecret:@"48bb173f1e200ea671123dc229ac3f54" redirectURL:@"http://www.jc2006.com/index.html"];
    //设置分享到QQ互联的appId和appKey
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"100424468"  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
#pragma mark --- 设置友盟End ----
 
#pragma mark --- 初始化极光推送Begin ---
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:@"6a144b9c73248579a7c9d95e"
                          channel:@"App Store"
                 apsForProduction:1    //0 开发  1生产
            advertisingIdentifier:advertisingId];
#pragma mark ---- 初始化极光推送End
    
    
    //设置自动登录
    [PPAPPDataClass sharedappData].isAutoLogin = YES;
    
    BOOL isLoginsucc = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"];
    
    if (isLoginsucc) {
        //更新会员信息
        [self get_info];
    }
    
    //网络判断注册
    [self addCoreNetregister];
    
    //注册消息推送
    [self registerNotifiction];
    
    self.window = [[UIWindow alloc] initWithFrame:PPMainFrame];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //开启应用
    [self startApp];
    //退出登录 登录成功通知
    [self addLoginSuccessAndLogoutNotifaction];
    
    [self.window setRootViewController:self.viewController];
    [self.window makeKeyAndVisible];
    
    //显示启动页
    
    AdvertiseView *advertiseView = [[AdvertiseView alloc] initWithFrame:self.window.bounds];
    advertiseView.filePath = @"";
    [advertiseView show];
    
    
    //检查更新
    [self versionUpdate];

    [self refreshUpdataId];

    //获取手机型号
    NSString* phoneModel = [self iphoneType];
    NSLog(@"手机型号是--- %@",phoneModel);
    
    return YES;
}

- (NSString *)iphoneType {
    
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPod1,1"])  return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"])  return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"])  return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"])  return @"iPod Touch 4G";

    if ([platform isEqualToString:@"iPod5,1"])  return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])  return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"])  return @"iPad 2";

    if ([platform isEqualToString:@"iPad2,3"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"])  return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"])  return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"])  return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"])  return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])  return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"])  return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"])  return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"])  return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"])  return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"])  return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])  return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"])  return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"])  return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])  return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"])  return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"])  return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"]) return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"]) return @"iPhone Simulator";
    
    return platform;
    
}

#pragma mark --- 更新会员信息 ---- 
-(void)get_info{
    @autoreleasepool {
        NSString *dJson = nil;
        @autoreleasepool {
            NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
            NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
            NSUInteger version = [appVersion integerValue];
            NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
            
            NSInteger updata_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"updata_id"] integerValue];

            dJson = [NSString stringWithFormat:@"{\"update_id\":\"%d\",\"token\":\"%@\",\"device\":\"%d\",\"device_type\":\"%@\",\"version\":\"%ld\"}",updata_id,token,2,@"",version];
            //获取类型接口
            PPRDData *pprddata1 = [[PPRDData alloc] init];
            [pprddata1 startAFRequest:@"/index.php/Api/User/get_info/"
                          requestdata:dJson
                       timeOutSeconds:10
                      completionBlock:^(NSDictionary *json) {
                        NSInteger code = [[json objectForKey:@"code"] integerValue];
                          
                          if (code == 1) {
                              
                          }else if (code == -2){
                              //检查信息更新
                              [[NSNotificationCenter defaultCenter] postNotificationName:UPDATAUPIDDATA object:nil];
                              
                          }else{
                              
                          }
                          
                      } failedBlock:^(NSError *error) {
                              
                          }];
        }
    }
}


//获取公共信息更新接口(通知更新后).
#pragma mark - 手机收到推送要更新Up_id的时候
-(void)refreshUpdataId
{
    NSString *dJson = nil;
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    NSInteger updata_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"updata_id"] integerValue];
    
    
    dJson = [NSString stringWithFormat:@"{\"update_id\":\"%d\",\"token\":\"%@\"}",updata_id,token];
    //获取类型接口
    PPRDData *pprddata1 = [[PPRDData alloc] init];
    [pprddata1 startAFRequest:@"/index.php/Api/Update/index/"
                  requestdata:dJson
               timeOutSeconds:10
              completionBlock:^(NSDictionary *json) {
                  NSInteger code = [[json objectForKey:@"code"] integerValue];
                  if (code == 1) {
                      NSDictionary *dataDic = [json objectForKey:@"data"];
                      NSArray *updataArray = [dataDic objectForKey:@"update_data"];
                      
                      NSString *update_ids = [[json objectForKey:@"data"] objectForKey:@"update_id"];
                      
                      [[NSUserDefaults standardUserDefaults] setObject:update_ids forKey:@"updata_id"];
                      [[NSUserDefaults standardUserDefaults] synchronize];
                      [[NSNotificationCenter defaultCenter] postNotificationName:UPDATA_MYViews object:nil];
                      
                      //根据服务器返回的更新要求 更新界面
                      if (![updataArray isEqual:[NSNull null]] || updataArray.count > 0) {
                          
                          for (int j = 0; j<updataArray.count; j++) {
                              NSInteger updataId = [[updataArray objectAtIndex:j] integerValue];
                              
                              if (updataId == 1) {//公共信息更新
                                  [self updataPublicInfo];
                              }else if(updataId == 3){//充值设置更新
                                  [self getChongZhiStatus];
                              }else if (updataId == 4){//购买设置更新
                                  [self getBuyListInfo];
                              }
                          }
                      }
                      
                      NSNumber *update_id = [dataDic objectForKey:@"update_id"];
                      [[NSUserDefaults standardUserDefaults] setObject:update_id forKey:@"update_id"];
                      [[NSUserDefaults standardUserDefaults] synchronize];
                  }else if (code == -2){
                      //检查信息更新
                      [[NSNotificationCenter defaultCenter] postNotificationName:UPDATAUPIDDATA object:nil];
                      
                  }
              }
            failedBlock:^(NSError *error) {
                      
            }];
}

#pragma mark ---购买更新 
-(void)getBuyListInfo{
    NSString *dJson = nil;
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSInteger updata_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"updata_id"] integerValue];
    dJson = [NSString stringWithFormat:@"{\"update_id\":\"%d\",\"token\":\"%@\"}",updata_id,token];
    //获取类型接口
    PPRDData *pprddata1 = [[PPRDData alloc] init];
    [pprddata1 startAFRequest:@"/index.php/Api/Update/update_cost_service/"
                  requestdata:dJson
               timeOutSeconds:10
              completionBlock:^(NSDictionary *json) {
                  NSInteger code = [[json objectForKey:@"code"] integerValue];
                  
                  if (code == 1) {
                      NSArray *dataArr = [json objectForKey:@"data"];
                      if ([dataArr isEqual:[NSNull null]] || dataArr.count == 0) {
                          return;
                      }
                      
                      [[NSUserDefaults standardUserDefaults] setObject:dataArr forKey:@"getBuyListInfoArray"];
                      [[NSUserDefaults standardUserDefaults] synchronize];
                      
                  }
              } failedBlock:^(NSError *error) {
                  
        }];
}

#pragma mark ---充值更新
//获取充值详情页数据
-(void)getChongZhiStatus{
    NSString *dJson = nil;
    @autoreleasepool {
        
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        NSInteger updata_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"updata_id"] integerValue];
        
        dJson = [NSString stringWithFormat:@"{\"update_id\":\"%d\",\"token\":\"%@\"}",updata_id,token];
        //获取类型接
        PPRDData *pprddata1 = [[PPRDData alloc] init];
        [pprddata1 startAFRequest:@"/index.php/Api/Update/update_recharge/"
                      requestdata:dJson
                   timeOutSeconds:10
                  completionBlock:^(NSDictionary *json) {
                      NSInteger code = [[json objectForKey:@"code"] integerValue];
                      if (code == 1) {
                          NSArray *dataArr = [json objectForKey:@"data"];
                          [[NSUserDefaults standardUserDefaults] setObject:dataArr forKey:@"getChongZhiStatusArray"];
                          [[NSUserDefaults standardUserDefaults] synchronize];
                      }
                      
                  } failedBlock:^(NSError *error) {
                      
                  }];
    }
}
#pragma mark - 版本更新
- (void)versionUpdate
{

    NSString *dJson = nil;
        //得到自己当前的下属
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
        NSUInteger version = [appVersion integerValue];
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];

        NSInteger updata_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"updata_id"] integerValue];

        
        dJson = [NSString stringWithFormat:@"{\"update_id\":\"%d\",\"token\":\"%@\",\"device\":\"%d\",\"device_type\":\"%@\",\"version\":\"%ld\"}",updata_id,token,2,@"",version];
        //获取类型接口
        PPRDData *pprddata1 = [[PPRDData alloc] init];
        [pprddata1 startAFRequest:@"/index.php/Api/Update/update_version/"
                      requestdata:dJson
                   timeOutSeconds:10
                  completionBlock:^(NSDictionary *json) {
                      
                      NSInteger code = [[json objectForKey:@"code"] integerValue];
                      if (code == 1) {
                          NSDictionary *dataDic = [json objectForKey:@"data"];
                          
                          if ([dataDic isEqual:[NSArray array]]) {
                              return;
                          }
                          
                          NSString *version_url = [dataDic objectForKey:@"version_url"];
                          self.updateUrl = @"http://www.baidu.com";
                          
                          if ([version_url isEqual:[NSNull null]]) {
                              
                          }else{
                              self.updateUrl = version_url;
                          }
                          
                          NSInteger versionNum = [[dataDic objectForKey:@"version"] integerValue];
                          
                          NSString *version_update_type = [dataDic objectForKey:@"version_update_type"];
                          
                          if (versionNum > version && [version_update_type isEqualToString:@"1"]) {
                              NSString *msg = [NSString stringWithFormat:@"更新日志:\n%ld",versionNum];
                              UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"发现新版本!" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去更新", nil];
                              alertView.tag = 11111;
                              [alertView show];
                          }
                      }else if (code == -2){
                          //检查信息更新
                          [[NSNotificationCenter defaultCenter] postNotificationName:UPDATAUPIDDATA object:nil];
                          
                      }
                  }
                      failedBlock:^(NSError *error) {
                          
                }];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 11111) {
        if (buttonIndex == 0) {
            
        }else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.updateUrl]];
        }
    }
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
#pragma mark --- 注册极光推送DeviceToken ---
    [JPUSHService registerDeviceToken:deviceToken];
}

#pragma mark----- JPUSHRegisterDelegate Begin -----

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

#pragma mark----- JPUSHRegisterDelegate End -----



- (void)addLoginSuccessAndLogoutNotifaction
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginNotifaction:) name:LOGINSUCCESSNOTIFACTION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutNotifaction:) name:LOGOUTNOTIFACTION object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUpdataId) name:UPDATAUPIDDATA object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOutByService) name:LoginOutByService object:nil];
    


}

//服务器返回其他设备登录
-(void)loginOutByService{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的账号在其他设备登录，请重新登录！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [self logoutNotifaction:nil];
    [alert show];
}


- (void)logoutNotifaction:(NSNotification *)object
{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaultsCookie];
    //清除用户信息
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"golds"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"scores"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"present_time"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"time_service_1"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"time_service_2"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"time_service_3"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_chinese_name"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_city"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_level"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_phone"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_pic"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_province"];
    
    //清除公共数据
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KEFU_TELPHONE"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"IOS_IS_PRODUCE"];
    //支付宝
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ALIPAY_PRIVATE"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ALIPAY_APPID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ALIPAY_PID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ALIPAY_PUBLIC"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ALIPAY_SWITCH"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ALIPAY_ACCOUNT"];
    
    
    //微信
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"WX_APPID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"WX_APPSECRET"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"WEIXIN_SWITCH"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"WX_PAY_KEY"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"WX_SHANGHUHAO"];
    [[NSUserDefaults standardUserDefaults] setObject:@"No" forKey:@"isWechatAccess"];

    //服务器刷新时间
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LIVE_REFRESH_SECOND"];
    
    
    //清除登录信息
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isLogin"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isBangding"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.viewController = ppLoginNavigationController;
    [self.window setRootViewController:self.viewController];
    [self.window makeKeyAndVisible];
    [WSProgressHUD showShimmeringString:@"已退出登录" maskType:WSProgressHUDMaskTypeClear maskWithout:WSProgressHUDMaskWithoutDefault];
    
    [self autoDismiss];
}
- (void)autoDismiss
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [WSProgressHUD dismiss];
    });
    
}
- (void)loginNotifaction:(NSNotification *)object
{
    self.viewController = pptabBarController;
    pptabBarController.selectedIndex = 0;
    [self.window setRootViewController:self.viewController];
    [self.window makeKeyAndVisible];
    [self updataPublicInfo];

    [WSProgressHUD showShimmeringString:@"登录成功" maskType:WSProgressHUDMaskTypeClear maskWithout:WSProgressHUDMaskWithoutDefault];
    [self autoDismiss];
    
}

- (void)registerNotifiction
{
    //注册通知
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)])//IOS8
    {
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
}


//启动APP
-(void)startApp{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *isLooked  = [userDefault objectForKey:@"isLooked4"];//从本地存储获取是否看过引导页
    NSString *oldVersion = [userDefault objectForKey:@"oldVersion"];//从本地存储获取以前的APP版本
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];//当前APP中的版本
    
        if(![oldVersion isEqualToString:appVersion]){//检测到更新了版本，则出现滑动页
//            [self bootStartViewController];
            [self setupViewControllers];
        }else{//版本一样
            if(![isLooked isEqualToString:@"1"]){//没有看过滑动页,启动滑动页
//                [self bootStartViewController];
                [self setupViewControllers];
            }else{//直接启动登录页面
                
                [self setupViewControllers];
    
        }
    }
    
}

-(void)bootStartViewController{
    JCCYStartViewController *startViewController = [[JCCYStartViewController alloc]init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:startViewController];
    navigationController.navigationBarHidden = YES;
    [_window setRootViewController:navigationController];
    self.viewController = navigationController;
}

#pragma mark - 初始化功能
- (void)setupViewControllers {

#pragma mark --------------

    //初始化登录
    PPLoginViewController *ppLoginViewController = [[PPLoginViewController alloc] init];
    
    ppLoginNavigationController = [[PPNavigationController alloc] initWithRootViewController:ppLoginViewController];
    
    pptabBarController = [[LBTabBarController alloc] init];
    
    //2.初始化tabBar视图控制器
//    pptabBarController = [[PPTabBarController alloc]init];
    pptabBarController.tabBar.tintColor = [UIColor colorFromHexRGB:@"e60013"];
    pptabBarController.delegate = self;
//
//    //首页
//    HomeViewController *homeVC = [[HomeViewController alloc]init];
//    homeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"tabBar_icon_shouye_normal1@2x"] selectedImage:[UIImage imageNamed:@"tabBar_icon_shouye_selected1@2x"]];
//    [homeVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                              [UIColor colorFromHexRGB:@"999999"], NSForegroundColorAttributeName,
//                                              [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName, nil]
//                                    forState:UIControlStateNormal];
//    [homeVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                              [UIColor colorFromHexRGB:@"e60013"], NSForegroundColorAttributeName,
//                                              [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName, nil]
//                                    forState:UIControlStateSelected];
//    
//    PPNavigationController *homeNav = [[PPNavigationController alloc]initWithRootViewController:homeVC];
//    curNavController = homeNav;
//
//    //实盘
//    FirmViewController *firmVC = [[FirmViewController alloc]init];
//    firmVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"实盘" image:[UIImage imageNamed:@"tabBar_icon_shipan_normal1@2x"] selectedImage:[UIImage imageNamed:@"tabBar_icon_shipan_selected1@2x"]];
//    [firmVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                              [UIColor colorFromHexRGB:@"999999"], NSForegroundColorAttributeName,
//                                              [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName, nil]
//                                    forState:UIControlStateNormal];
//    [firmVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                              [UIColor colorFromHexRGB:@"e60013"], NSForegroundColorAttributeName,
//                                              [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName, nil]
//                                    forState:UIControlStateSelected];
//
//    PPNavigationController *firmNav = [[PPNavigationController alloc]initWithRootViewController:firmVC];
//    
//    //红包
//    RedPacketViewController *redPVC = [[RedPacketViewController alloc]init];
//    redPVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"红包" image:[UIImage imageNamed:@"tabBar_icon_redPacket_normal1@2x"] selectedImage:[UIImage imageNamed:@"tabBar_icon_redPacket_selected1@2x"]];
//    [redPVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                [UIColor colorFromHexRGB:@"999999"], NSForegroundColorAttributeName,
//                                                [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName, nil]
//                                      forState:UIControlStateNormal];
//    [redPVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                [UIColor colorFromHexRGB:@"e60013"], NSForegroundColorAttributeName,
//                                                [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName, nil]
//                                      forState:UIControlStateSelected];
//    PPNavigationController *redPNav = [[PPNavigationController alloc]initWithRootViewController:redPVC];
//    
//    //秘籍
//    FourViewController *mijiVC = [[FourViewController alloc]init];
//    mijiVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"秘籍" image:[UIImage imageNamed:@"tabBar_icon_miji_normal1@2x"] selectedImage:[UIImage imageNamed:@"tabBar_icon_miji_selected1@2x"]];
//    [mijiVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                 [UIColor colorFromHexRGB:@"999999"], NSForegroundColorAttributeName,
//                                                 [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName, nil]
//                                       forState:UIControlStateNormal];
//    [mijiVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                 [UIColor colorFromHexRGB:@"e60013"], NSForegroundColorAttributeName,
//                                                 [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName, nil]
//                                       forState:UIControlStateSelected];
//
//    PPNavigationController *mjNav = [[PPNavigationController alloc]initWithRootViewController:mijiVC];
//    
//    
//    //开户
//    FiveViewController *kaihuVC = [[FiveViewController alloc]init];
//    kaihuVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"开户" image:[UIImage imageNamed:@"tabBar_icon_kaihu_normal1@2x"] selectedImage:[UIImage imageNamed:@"tabBar_icon_kaihu_selected1@2x"]];
//    [kaihuVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                 [UIColor colorFromHexRGB:@"999999"], NSForegroundColorAttributeName,
//                                                 [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName, nil]
//                                       forState:UIControlStateNormal];
//    [kaihuVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                 [UIColor colorFromHexRGB:@"e60013"], NSForegroundColorAttributeName,
//                                                 [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName, nil]
//                                       forState:UIControlStateSelected];
//    
//    PPNavigationController *kaihuNav = [[PPNavigationController alloc]initWithRootViewController:kaihuVC];
//    
//    //    SecondNav
//    pptabBarController.viewControllers = @[homeNav,  firmNav, redPNav, mjNav,kaihuNav];
//    
//    CGFloat ww = pptabBarController.tabBar.bounds.size.width/5*0.63;
//    
//    self.cornerLabel = [[UILabel alloc] initWithFrame:CGRectMake(ww, 2, 8, 8)];
//    cornerLabel.layer.cornerRadius = 4;
//    cornerLabel.clipsToBounds = YES;
//    cornerLabel.backgroundColor = [UIColor colorFromHexRGB:@"f74c31"];
//    cornerLabel.hidden = YES;
//    [pptabBarController.tabBar addSubview:cornerLabel];
    
    
    
    BOOL isLoginsucc = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"];
    
    if (!isLoginsucc)
    {
        self.viewController = ppLoginNavigationController;
    }else{
        self.viewController = pptabBarController;
        //刷新公共信息
        [self updataPublicInfo];
    }
    
    [_window setRootViewController:self.viewController];

}

//-(void)getUpDataId{
//    NSString *dJson = nil;
//    
//        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
//        NSInteger updata_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"updata_id"] integerValue];
//        
//        dJson = [NSString stringWithFormat:@"{\"update_id\":\"%d\",\"token\":\"%@\"}",updata_id,token];
//        //获取类型接
//        PPRDData *pprddata1 = [[PPRDData alloc] init];
//        [pprddata1 startAFRequest:@"/index.php/Api/Update/index/"
//                      requestdata:dJson
//                   timeOutSeconds:10
//                  completionBlock:^(NSDictionary *json) {
//                      
//                      NSInteger code = [[json objectForKey:@"code"] integerValue];
//                      if (code == 1) {
//
//                          [self refreshUpdataId];
//
//                      }else if (code == -2){
//                          //检查信息更新
//                          [[NSNotificationCenter defaultCenter] postNotificationName:UPDATAUPIDDATA object:nil];
//                          
//                      }
//                  } failedBlock:^(NSError *error) {
//                      
//            }];
//}
#pragma  mark ---- 当服务器提示要做公共信息更新时 ----
-(void)updataPublicInfo{
    NSString *dJson = nil;
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        NSInteger updata_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"updata_id"] integerValue];
        
        
        dJson = [NSString stringWithFormat:@"{\"update_id\":\"%d\",\"token\":\"%@\"}",updata_id,token];
        //获取类型接
        PPRDData *pprddata1 = [[PPRDData alloc] init];
        [pprddata1 startAFRequest:@"/index.php/Api/Update/update_conf/"
                      requestdata:dJson
                   timeOutSeconds:10
                  completionBlock:^(NSDictionary *json) {
                      
                      NSInteger code = [[json objectForKey:@"code"] integerValue];
                      if (code == 1) {
                          NSDictionary *dataDic = [json objectForKey:@"data"];
                          
                          //红包使用相关
                          NSString *ZANSHANG_CONTENT = [dataDic objectForKey:@"ZANSHANG_CONTENT"];
                          NSString *ZANSHANG_USE_CONTENT = [dataDic objectForKey:@"ZANSHANG_USE_CONTENT"];
                          NSString *ZUANSHI_CONTENT = [dataDic objectForKey:@"ZUANSHI_CONTENT"];
                          NSString *ZUANSHI_USE_CONTENT = [dataDic objectForKey:@"ZUANSHI_USE_CONTENT"];
                          NSString *HUANGJIN_CONTENT = [dataDic objectForKey:@"HUANGJIN_CONTENT"];
                          NSString *HUANGJIN_USE_CONTENT = [dataDic objectForKey:@"HUANGJIN_USE_CONTENT"];

                          
                          
                          NSString *KEFU_TELPHONE = [dataDic objectForKey:@"KEFU_TELPHONE"];
                          NSString *IOS_IS_PRODUCE = [dataDic objectForKey:@"IOS_IS_PRODUCE"];
                          //微信支付相关
                          
                          NSString *WX_APPID = [dataDic objectForKey:@"WX_APPID"];
                          NSString *WX_APPSECRET = [dataDic objectForKey:@"WX_APPSECRET"];
                          NSString *WEIXIN_SWITCH = [dataDic objectForKey:@"WEIXIN_SWITCH"];
                          NSString *WX_PAY_KEY = [dataDic objectForKey:@"WX_PAY_KEY"];
                          NSString *WX_SHANGHUHAO = [dataDic objectForKey:@"WX_SHANGHUHAO"];
                          
                          //支付宝相关
                          NSString *ALIPAY_ACCOUNT = [dataDic objectForKey:@"ALIPAY_ACCOUNT"];
                          NSString *ALIPAY_APPID = [dataDic objectForKey:@"ALIPAY_APPID"];
                          NSString *ALIPAY_PID = [dataDic objectForKey:@"ALIPAY_PID"];
                          NSString *ALIPAY_PRIVATE = [dataDic objectForKey:@"ALIPAY_PRIVATE"];
                          NSString *ALIPAY_PUBLIC = [dataDic objectForKey:@"ALIPAY_PUBLIC"] ;
                          NSString *ALIPAY_SWITCH = [dataDic objectForKey:@"ALIPAY_SWITCH"];
                          
                          //充值说明
                          NSString *CHONGZHI_CONTENT = [dataDic objectForKey:@"CHONGZHI_CONTENT"];

                          //默认刷新时间
                          NSString *LIVE_REFRESH_SECOND = [dataDic objectForKey:@"LIVE_REFRESH_SECOND"];
                          
                          
                          
                          //红包
                          
                          
                          [[NSUserDefaults standardUserDefaults] setObject:ZANSHANG_CONTENT forKey:@"ZANSHANG_CONTENT"];
                          [[NSUserDefaults standardUserDefaults] setObject:ZANSHANG_USE_CONTENT forKey:@"ZANSHANG_USE_CONTENT"];
                          [[NSUserDefaults standardUserDefaults] setObject:ZUANSHI_CONTENT forKey:@"ZUANSHI_CONTENT"];
                          [[NSUserDefaults standardUserDefaults] setObject:ZUANSHI_USE_CONTENT forKey:@"ZUANSHI_USE_CONTENT"];
                          [[NSUserDefaults standardUserDefaults] setObject:HUANGJIN_CONTENT forKey:@"HUANGJIN_CONTENT"];
                          [[NSUserDefaults standardUserDefaults] setObject:HUANGJIN_USE_CONTENT forKey:@"HUANGJIN_USE_CONTENT"];

                          
                          
                          [[NSUserDefaults standardUserDefaults] setObject:KEFU_TELPHONE forKey:@"KEFU_TELPHONE"];
                          [[NSUserDefaults standardUserDefaults] setObject:IOS_IS_PRODUCE forKey:@"IOS_IS_PRODUCE"];
                          
                          
                          [[NSUserDefaults standardUserDefaults] setObject:WX_APPID forKey:@"WX_APPID"];
                          [[NSUserDefaults standardUserDefaults] setObject:WX_APPSECRET forKey:@"WX_APPSECRET"];
                          [[NSUserDefaults standardUserDefaults] setObject:WEIXIN_SWITCH forKey:@"WEIXIN_SWITCH"];
                          [[NSUserDefaults standardUserDefaults] setObject:WX_PAY_KEY forKey:@"WX_PAY_KEY"];
                          [[NSUserDefaults standardUserDefaults] setObject:WX_SHANGHUHAO forKey:@"WX_SHANGHUHAO"];
                          
                          
                          [[NSUserDefaults standardUserDefaults] setObject:LIVE_REFRESH_SECOND forKey:@"LIVE_REFRESH_SECOND"];
                          
                          [[NSUserDefaults standardUserDefaults] setObject:ALIPAY_PRIVATE forKey:@"ALIPAY_PRIVATE"];
                          [[NSUserDefaults standardUserDefaults] setObject:ALIPAY_APPID forKey:@"ALIPAY_APPID"];
                          [[NSUserDefaults standardUserDefaults] setObject:ALIPAY_PID forKey:@"ALIPAY_PID"];
                          [[NSUserDefaults standardUserDefaults] setObject:ALIPAY_PUBLIC forKey:@"ALIPAY_PUBLIC"];
                          [[NSUserDefaults standardUserDefaults] setObject:ALIPAY_SWITCH forKey:@"ALIPAY_SWITCH"];
                          [[NSUserDefaults standardUserDefaults] setObject:ALIPAY_ACCOUNT forKey:@"ALIPAY_ACCOUNT"];
                          
                          [[NSUserDefaults standardUserDefaults] setObject:CHONGZHI_CONTENT forKey:@"CHONGZHI_CONTENT"];


                          [[NSUserDefaults standardUserDefaults] synchronize];
                          
                      }else if (code == -2){
                          //检查信息更新
                          [[NSNotificationCenter defaultCenter] postNotificationName:UPDATAUPIDDATA object:nil];
                          
                      }
                  } failedBlock:^(NSError *error) {
                      
                  }];
}

#pragma mark - 网络判断
- (void)addCoreNetregister
{
    if ([CoreStatus isNetworkEnable]) {
        [PPAPPDataClass sharedappData].isNet = YES;
    }else{
        [PPAPPDataClass sharedappData].isNet = NO;
    }
    [CoreStatus beginNotiNetwork:self];
}

-(void)coreNetworkChangeNoti:(NSNotification *)noti{
    //因为这些是实时，所以每次的静态状态就是当前实时状态，你也可以从noti中取
    CoreNetWorkStatus currentNetStatus = [CoreStatus currentNetWorkStatus];
    
    switch (currentNetStatus) {
        case CoreNetWorkStatusNone:
        {
            [PPAPPDataClass sharedappData].isNet = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:NETWORKNOTIFACTION object:nil];
        }
            break;
            
        default:
        {
            [PPAPPDataClass sharedappData].isNet = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:NETWORKNOTIFACTION object:nil];
            
        }
            break;
    }
    
}

//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
//    if (!result) {
//        
//    }
//    return result;
//}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [WXApi handleOpenURL:url delegate:self];
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        
    }
    return result;
}


#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    curNavController = (PPNavigationController *)viewController;
    NSInteger index = [tabBarController selectedIndex];
    if (self.indexFlag != index) {
        
    }
    if (index == 2 || index == 3) {
        tabBarController.selectedIndex = self.nowSelectIndex;
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"此功能尚未完善" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        //        [alert show];
        [ALToastView toastInView:self.window withText:@"敬请期待"];
    }else{
        if (index == self.nowSelectIndex) {
            self.nowSelectIndex = index;
        }else{
            self.oldSelectIndex = self.oldSelectIndex;
            self.nowSelectIndex = index;
        }
    }

    
}


- (void)applicationWillResignActive:(UIApplication *)application {

}


- (void)applicationDidEnterBackground:(UIApplication *)application {

}


- (void)applicationWillEnterForeground:(UIApplication *)application {

}


- (void)applicationDidBecomeActive:(UIApplication *)application {

}


- (void)applicationWillTerminate:(UIApplication *)application {

    [self saveContext];
}

#pragma mark ---- 支付宝回调 ----- 
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    
    
    [[UMSocialManager defaultManager] handleOpenURL:url];

    //如果是微信的
    if ([url.host isEqualToString:@"pay"]) {
        [WXApi handleOpenURL:url delegate:self];
    }
    
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            [[NSNotificationCenter defaultCenter] postNotificationName:JCCYAliPayNotificationCenter object:resultDic];
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    return YES;
}



// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    
    [[UMSocialManager defaultManager] handleOpenURL:url];

    
    //如果是微信的
    if ([url.host isEqualToString:@"pay"]) {
        [WXApi handleOpenURL:url delegate:self];
    }
    
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            [[NSNotificationCenter defaultCenter] postNotificationName:JCCYAliPayNotificationCenter object:resultDic];
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
        
    }
    return YES;
}

//微信回调
- (void)onResp:(BaseResp *)resp {
    //errCode
    switch (resp.errCode) {
        case WXSuccess:
        //成功回调
            [[NSNotificationCenter defaultCenter] postNotificationName:JCCYWeiXinPaySucc object:nil];
            break;
        default:
            [[NSNotificationCenter defaultCenter] postNotificationName:JCCYWeiXinPayFail object:nil];
            break;
    }
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"JCCY"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {

                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {

        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end

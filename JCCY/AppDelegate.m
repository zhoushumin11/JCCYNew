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
#import "PPLoginViewController.h"
#import "PPRegistViewController.h"//绑定手机号
//启动页
#import "JCCYStartViewController.h"

//五个控制器
#import "HomeViewController.h"
#import "FirmViewController.h"
#import "ThreeViewController.h"
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


@interface AppDelegate ()<CoreStatusProtocol,UITabBarControllerDelegate,JPUSHRegisterDelegate,UMSocialPlatformProvider,UIAlertViewDelegate>
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
@synthesize pptabBarController,ppLoginNavigationController;
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
    
    //各平台的详细配置
    //设置微信的appId和appKey
    
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxbc85f05c6861a34e" appSecret:@"8568c44b8010dd430890f5037608a861" redirectURL:@"http://mobile.umeng.com/social"];

    
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
    [JPUSHService setupWithOption:launchOptions appKey:@""
                          channel:@"App Store"
                 apsForProduction:0    //0 开发  1生产
            advertisingIdentifier:advertisingId];
#pragma mark ---- 初始化极光推送End
    
    
    //设置自动登录
    [PPAPPDataClass sharedappData].isAutoLogin = YES;
    
    BOOL isLoginsucc = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"];
    
    if (isLoginsucc) {
        //更新会员信息
//        [self get_info];
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
    
    //检查更新
    [self versionUpdate];

    
    return YES;
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
            
            dJson = [NSString stringWithFormat:@"{\"update_id\":\"%d\",\"token\":\"%@\",\"device\":\"%d\",\"device_type\":\"%@\",\"version\":\"%ld\"}",87,token,2,@"",version];
            //获取类型接口
            PPRDData *pprddata1 = [[PPRDData alloc] init];
            [pprddata1 startAFRequest:@"/index.php/Api/Update/update_version/"
                          requestdata:dJson
                       timeOutSeconds:10
                      completionBlock:^(NSDictionary *json) {
                          
                          
                      
                      } failedBlock:^(NSError *error) {
                              
                          }];
        }
    }
}

#pragma mark - 版本更新
- (void)versionUpdate
{

    
    NSString *dJson = nil;
    @autoreleasepool {
        //得到自己当前的下属
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
        NSUInteger version = [appVersion integerValue];
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];

        dJson = [NSString stringWithFormat:@"{\"update_id\":\"%d\",\"token\":\"%@\",\"device\":\"%d\",\"device_type\":\"%@\",\"version\":\"%ld\"}",87,token,2,@"",version];
        //获取类型接口
        PPRDData *pprddata1 = [[PPRDData alloc] init];
        [pprddata1 startAFRequest:@"/index.php/Api/Update/update_version/"
                      requestdata:dJson
                   timeOutSeconds:10
                  completionBlock:^(NSDictionary *json) {
                      
                      NSInteger code = [[json objectForKey:@"code"] integerValue];
                      if (code == 1) {
                          NSDictionary *dataDic = [json objectForKey:@"data"];
                          NSString *version_url = [dataDic objectForKey:@"version_url"];
                          self.updateUrl = @"http://www.baidu.com";
                          if ([version_url isEqual:[NSNull null]]) {
                              
                          }else{
                              self.updateUrl = version_url;
                          }
                          NSInteger version_service = 0;
                          
                          if (![version_url isEqual:[NSNull null]]) {
                              version_service = [[dataDic objectForKey:@"version_service"] integerValue];
                          }
                          
                          if (version_service > version) {
                              NSString *msg = [NSString stringWithFormat:@"更新日志:\n%ld",version_service];
                              UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"发现新版本!" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去更新", nil];
                              alertView.tag = 11111;
                              [alertView show];
                          }
                      }
                  }
                      failedBlock:^(NSError *error) {
                          
                      }];
    }
    

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
}

- (void)logoutNotifaction:(NSNotification *)object
{
    self.viewController = ppLoginNavigationController;
    [self.window setRootViewController:self.viewController];
    [self.window makeKeyAndVisible];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
            [self bootStartViewController];
    
        }else{//版本一样
            if(![isLooked isEqualToString:@"1"]){//没有看过滑动页,启动滑动页
                [self bootStartViewController];
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
    
    //初始化登录
    PPLoginViewController *ppLoginViewController = [[PPLoginViewController alloc] init];
    
    ppLoginNavigationController = [[PPNavigationController alloc] initWithRootViewController:ppLoginViewController];
    
    
    //2.初始化tabBar视图控制器
    pptabBarController = [[PPTabBarController alloc]init];
    pptabBarController.tabBar.tintColor = [UIColor colorFromHexRGB:@"e60013"];
    pptabBarController.delegate = self;
    //    pptabBarController.tabBar.barTintColor = [UIColor colorFromHexRGB:@"fafafa"];
    
    HomeViewController *oneVC = [[HomeViewController alloc]init];
    oneVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"home_bar1@2x.png"] selectedImage:[UIImage imageNamed:@"home_bar@2x.png"]];
    [oneVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                              [UIColor colorFromHexRGB:@"999999"], NSForegroundColorAttributeName,
                                              [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName, nil]
                                    forState:UIControlStateNormal];
    [oneVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                              [UIColor colorFromHexRGB:@"e60013"], NSForegroundColorAttributeName,
                                              [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName, nil]
                                    forState:UIControlStateSelected];

    PPNavigationController *oneNav = [[PPNavigationController alloc]initWithRootViewController:oneVC];
    curNavController = oneNav;

    FirmViewController *twoVC = [[FirmViewController alloc]init];
    twoVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"实盘" image:[UIImage imageNamed:@"firm_bar1@2x.png"] selectedImage:[UIImage imageNamed:@"firm_bar@2x.png"]];
    [twoVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                              [UIColor colorFromHexRGB:@"999999"], NSForegroundColorAttributeName,
                                              [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName, nil]
                                    forState:UIControlStateNormal];
    [twoVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                              [UIColor colorFromHexRGB:@"e60013"], NSForegroundColorAttributeName,
                                              [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName, nil]
                                    forState:UIControlStateSelected];
    //     msgVC.tabBarItem.badgeValue = @"2";
    //    FirstVC.tabBarItem.image = [UIImage imageNamed:@"1@2x.png"];
    //    FirstVC.tabBarItem.title = @"首页";
    PPNavigationController *twoNav = [[PPNavigationController alloc]initWithRootViewController:twoVC];
    
    ThreeViewController *threeVC = [[ThreeViewController alloc]init];
    threeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"红包" image:[UIImage imageNamed:@"redPack_bar1@2x.png"] selectedImage:[UIImage imageNamed:@"redPack_bar@2x.png"]];
    [threeVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                [UIColor colorFromHexRGB:@"999999"], NSForegroundColorAttributeName,
                                                [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName, nil]
                                      forState:UIControlStateNormal];
    [threeVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                [UIColor colorFromHexRGB:@"e60013"], NSForegroundColorAttributeName,
                                                [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName, nil]
                                      forState:UIControlStateSelected];

    PPNavigationController *threeNav = [[PPNavigationController alloc]initWithRootViewController:threeVC];
    
    FourViewController *fourVC = [[FourViewController alloc]init];
    fourVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"秘籍" image:[UIImage imageNamed:@"miji_bar@2x.png"] selectedImage:[UIImage imageNamed:@"miji_bar@2x.png"]];
    [fourVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                 [UIColor colorFromHexRGB:@"999999"], NSForegroundColorAttributeName,
                                                 [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName, nil]
                                       forState:UIControlStateNormal];
    [fourVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                 [UIColor colorFromHexRGB:@"e60013"], NSForegroundColorAttributeName,
                                                 [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName, nil]
                                       forState:UIControlStateSelected];

    PPNavigationController *fourNav = [[PPNavigationController alloc]initWithRootViewController:fourVC];
    
    
    FiveViewController *fiveVC = [[FiveViewController alloc]init];
    fiveVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"开户" image:[UIImage imageNamed:@"kaihu_bar@2x.png"] selectedImage:[UIImage imageNamed:@"kaihu_bar@2x.png"]];
    [fiveVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                 [UIColor colorFromHexRGB:@"999999"], NSForegroundColorAttributeName,
                                                 [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName, nil]
                                       forState:UIControlStateNormal];
    [fiveVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                 [UIColor colorFromHexRGB:@"e60013"], NSForegroundColorAttributeName,
                                                 [UIFont fontWithName:@"Helvetica" size:11.0], NSFontAttributeName, nil]
                                       forState:UIControlStateSelected];

    PPNavigationController *fiveNav = [[PPNavigationController alloc]initWithRootViewController:fiveVC];
    
    
    //    SecondNav
    pptabBarController.viewControllers = @[oneNav, twoNav, threeNav,fourNav,fiveNav];

    
    CGFloat ww = pptabBarController.tabBar.bounds.size.width/5*0.63;
    
    self.cornerLabel = [[UILabel alloc] initWithFrame:CGRectMake(ww, 2, 8, 8)];
    cornerLabel.layer.cornerRadius = 4;
    cornerLabel.clipsToBounds = YES;
    cornerLabel.backgroundColor = [UIColor colorFromHexRGB:@"f74c31"];
    cornerLabel.hidden = YES;
    
    [pptabBarController.tabBar addSubview:cornerLabel];
    
    tabbarbuttonArray = [NSMutableArray array];
    for (UIView *tabBarButton in self.pptabBarController.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabbarbuttonArray addObject:tabBarButton];
        }
    }
    
    
    BOOL isLoginsucc = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"];
    
    if (!isLoginsucc)
    {
        self.viewController = ppLoginNavigationController;
    }else{
        self.viewController = pptabBarController;
    }
    
    
    [_window setRootViewController:self.viewController];

    
    
    
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


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        
    }
    return result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
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
        [self animationWithIndex:index];
    }
    
}

// 动画
- (void)animationWithIndex:(NSInteger) index {
    
    CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.duration = 0.08;
    pulse.repeatCount= 1;
    pulse.autoreverses= YES;
    pulse.fromValue= [NSNumber numberWithFloat:0.7];
    pulse.toValue= [NSNumber numberWithFloat:1.3];
    [[tabbarbuttonArray[index] layer]
     addAnimation:pulse forKey:nil];
    
    self.indexFlag = index;
    
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




#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"JCCY"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
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

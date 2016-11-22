//
//  AppDelegate.h
//  JCCY
//
//  Created by 周书敏 on 2016/11/18.
//
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@class PPNavigationController;
@class PPTabBarController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong) NSPersistentContainer *persistentContainer;

@property (strong, nonatomic) UIViewController *viewController;
@property (strong, nonatomic) PPTabBarController *pptabBarController;
@property (strong, nonatomic) PPNavigationController *ppLoginNavigationController;


- (void)saveContext;

- (void)setupViewControllers;
//更新用户信息
-(void)get_info;

@end

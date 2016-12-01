//
//  AppDelegate.h
//  JCCY
//
//  Created by 周书敏 on 2016/11/18.
//
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "BXTabBarController.h"

@class PPNavigationController;
@class PPTabBarController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong) NSPersistentContainer *persistentContainer;

@property(nonatomic,assign) NSInteger oldSelectIndex; //上一次的位置
@property(nonatomic,assign) NSInteger nowSelectIndex; //现在的位置


@property (strong, nonatomic) UIViewController *viewController;
//@property (strong, nonatomic) PPTabBarController *pptabBarController;
@property (strong, nonatomic) PPNavigationController *ppLoginNavigationController;

@property (nonatomic,strong) BXTabBarController *bXTabBarController;

- (void)saveContext;

- (void)setupViewControllers;
//更新用户信息
-(void)get_info;

@end


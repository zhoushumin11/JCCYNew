//
//  PPAPPDataClass.h
//  ParkProject
//
//  Created by yuanxuan on 16/8/3.
//  Copyright © 2016年 yuanxuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreStatus.h"

@interface PPAPPDataClass : NSObject
//当前网络状态
@property (nonatomic, assign) CoreNetWorkStatus netWorkStatus;
//iOS下载地址
@property (nonatomic, strong) NSString *appStoreuri;
//更新内容
@property (nonatomic, strong) NSString *appStoreUpdateContent;
//更新版本
@property (nonatomic, strong) NSString *appStoreUpdateVersion;
//是否有网络
@property (nonatomic, assign) BOOL isNet;
//是否为Wifi
@property (nonatomic, assign) BOOL isWifi;

@property (nonatomic, strong) NSString *severUrl;


@property (nonatomic , strong) NSString *userName;
@property (nonatomic , assign) BOOL isAutoLogin;
@property (nonatomic , assign) BOOL isLogin;
@property (nonatomic , assign) BOOL isPlayEar;
@property (nonatomic , assign) BOOL isSendMessageSound;
+ (PPAPPDataClass *)sharedappData;
@end

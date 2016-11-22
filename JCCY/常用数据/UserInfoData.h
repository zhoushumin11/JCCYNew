//
//  UserInfoData.h
//  JCCY
//
//  Created by 周书敏 on 2016/11/22.
//
//

#import <Foundation/Foundation.h>

@interface UserInfoData : NSObject


//剩余金币数
@property (nonatomic, assign) NSUInteger golds;
//服务器当前时间
@property (nonatomic, assign) NSUInteger present_time;
//赞赏到期时间戳
@property (nonatomic, assign) NSUInteger time_service_1;
//钻石到期时间戳
@property (nonatomic, assign) NSUInteger time_service_2;
//黄金到期时间戳
@property (nonatomic, assign) NSUInteger time_service_3;
//user_chinese_name
@property (nonatomic, strong) NSString *user_chinese_name;
//user_city
@property (nonatomic, strong) NSString *user_city;
//user_phone
@property (nonatomic, strong) NSString *user_phone;
//user_pic
@property (nonatomic, strong) NSString *user_pic;
//user_province
@property (nonatomic, strong) NSString *user_province;
//user_level
@property (nonatomic, strong) NSString *user_level;

+ (UserInfoData *)sharedappData;


@end

//
//  UserInfoData.m
//  JCCY
//
//  Created by 周书敏 on 2016/11/22.
//
//

#import "UserInfoData.h"

@implementation UserInfoData

+ (UserInfoData *)sharedappData
{
    static UserInfoData *sharedToolsInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedToolsInstance = [[self alloc] init];
    });
    return sharedToolsInstance;
}


@end

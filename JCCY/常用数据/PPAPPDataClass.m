//
//  PPAPPDataClass.m
//  ParkProject
//
//  Created by yuanxuan on 16/8/3.
//  Copyright © 2016年 yuanxuan. All rights reserved.
//

#import "PPAPPDataClass.h"

@implementation PPAPPDataClass
@synthesize severUrl;
+ (PPAPPDataClass *)sharedappData
{
    static PPAPPDataClass *sharedToolsInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedToolsInstance = [[self alloc] init];
    });
    return sharedToolsInstance;
}

@end

//
//  PPFileDownloadManage.m
//  ParkProject
//
//  Created by yuanxuan on 16/9/22.
//  Copyright © 2016年 yuanxuan. All rights reserved.
//

#import "PPFileDownloadManage.h"

@implementation PPFileDownloadManage
@synthesize downloadingList,downloadingDict;
+ (PPFileDownloadManage *)shared
{
    static PPFileDownloadManage *ppFileDownloadManage = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        ppFileDownloadManage = [[self alloc] init];
        ppFileDownloadManage.downloadingDict = [NSMutableDictionary dictionaryWithCapacity:0];
        ppFileDownloadManage.downloadingList = [NSMutableArray arrayWithCapacity:0];
    });
    return ppFileDownloadManage;
}
@end

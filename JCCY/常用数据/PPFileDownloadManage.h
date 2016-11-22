//
//  PPFileDownloadManage.h
//  ParkProject
//
//  Created by yuanxuan on 16/9/22.
//  Copyright © 2016年 yuanxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPFileDownloadManage : NSObject
@property (nonatomic, strong) NSMutableDictionary *downloadingDict;
@property (nonatomic, strong) NSMutableArray *downloadingList;
+ (PPFileDownloadManage *)shared;
@end

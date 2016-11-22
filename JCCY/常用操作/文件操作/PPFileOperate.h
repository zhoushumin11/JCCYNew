//
//  PPFileOperate.h
//  ParkProject
//
//  Created by yuanxuan on 16/7/8.
//  Copyright © 2016年 yuanxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPFileOperate : NSObject
- (void)createDir;
- (void)createDATADir;
- (void)createDirName:(NSString *)dirName;
- (NSString *)getDirName:(NSString *)dirName fileName:(NSString *)filename;
- (BOOL)deleteFile:(NSString *)filename;
- (BOOL)deleteFilePath:(NSString *)filePath;
- (BOOL)isFilePath:(NSString *)filePath;
//- (BOOL)deleteFilePath:(NSString *)filepath;
@end

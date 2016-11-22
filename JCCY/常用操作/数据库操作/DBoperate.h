//
//  DBoperate.h
//  MuTianXia
//
//  Created by yuanxuan on 15/9/18.
//  Copyright © 2015年 yuanxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBoperate : NSObject

//数据库常用操作
+ (void)createDB;//创建数据库

//通讯录操作
+ (BOOL)synContacts:(NSMutableArray *)contactList progress:(void (^)(void))progressFloat completionBlock:(void (^)(void))completionBlock;
+ (NSMutableArray *)getAllContacts;
+ (NSMutableArray *)getSearchContacts:(NSString *)text;
+ (BOOL)deleteAllContacts;
+ (NSString *)getuserNameFormuserId:(NSString *)userId;

//知识中心文件下载
+ (BOOL)isFileDownload:(NSString *)fileid;
+ (BOOL)addNewDownloadFile:(NSMutableDictionary *)fileAttribute;
+ (BOOL)deleteDownloadFile:(NSMutableDictionary *)fileAttribute;
+ (NSMutableArray *)getFileList:(NSString *)lastDownloadTime;
+ (NSMutableDictionary *)getDataFromFileid:(NSString *)fileid;

//巡检操作
+ (BOOL)synPlaces:(NSMutableArray *)placeList progress:(void (^)(void))progressFloat completionBlock:(void (^)(void))completionBlock;  //同步巡检位置
+ (NSMutableArray *)getSearchPlaces:(NSString *)text;   //根据条件获得区域
+ (NSMutableDictionary *)getDataFromPlaceId:(NSString *)text;
+ (BOOL)addOnePPFile:(NSMutableDictionary *)ppdata;
+ (BOOL)removeOnePPFile:(NSMutableDictionary *)ppdata;
+ (NSMutableArray *)getallPPFileData;
@end

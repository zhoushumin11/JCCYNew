//
//  DBoperate.m
//  MuTianXia
//
//  Created by yuanxuan on 15/9/18.
//  Copyright © 2015年 yuanxuan. All rights reserved.
//

#import "DBoperate.h"
#import "FMDB.h"

@implementation DBoperate
+ (DBoperate *)shareDBoperate{
    static DBoperate *dbOp = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dbOp = [[DBoperate alloc] init];
    });
    return dbOp;
}


+ (NSString *)getDBPath
{
    NSString* docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    docsdir = [docsdir stringByAppendingPathComponent:@"userData"];
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSString *usernumber = [NSString stringWithFormat:@"%@.db",userName];
    NSString* dbpath = [docsdir stringByAppendingPathComponent:usernumber];
    return dbpath;
}

//创建数据库
+ (void)createDB
{
    NSString *dbpath = [DBoperate getDBPath];
    NSFileManager *filemanager = [NSFileManager defaultManager];
    if (![filemanager fileExistsAtPath:dbpath]) {
        FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbpath];
        [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            //通讯录表
            [db executeUpdate:@"create table PP_ADDRESSBOOK_DATA (id integer primary key,userid text,userAccount text,userSex text,username text,usertype integer,email text,mobilePhone text,createTime text,userimgurl text,userPinYin text)"];
            //文件存储表
            [db executeUpdate:@"create table PP_FILE_DATA (id integer primary key,knowledgeId text,fileid text,filename text,fileExt integer,filePath text,fileSize text,fileClass text,downloadTime text,fileupdateTime text)"];
            //巡检位置表
            [db executeUpdate:@"create table PP_PPLACE_DATA (id integer primary key,areaName text,createTime text,latitude text,longitude text,patrolAreaId text,patrolPlaceName text,patrolPlaceId text,remark text)"];
            //区域表
            [db executeUpdate:@"create table PP_PPAREA_DATA (id integer primary key,areaName text,patrolAreaId text,remark text)"];
            
            //巡检素材本地保存表
            [db executeUpdate:@"create table PP_PPLACE_FILELOCALSAVE_DATA (id integer primary key,patrolRecordId text,filePath text)"];
        }];
        
    }else{
        NSLog(@"存在不需要创建");
    }
    
    
    
}

#pragma mark - 通讯录操作
+ (BOOL)synContacts:(NSMutableArray *)contactList progress:(void (^)(void))progressFloat completionBlock:(void (^)(void))completionBlock
{
    PPToolsClass *pptoolsclass = [PPToolsClass sharedTools];
    NSString *dbpath = [DBoperate getDBPath];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbpath];
    
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        progressFloat();
        //通讯录表
        [db executeUpdate:@"delete from PP_ADDRESSBOOK_DATA"];
        for (NSInteger i = 0; i < [contactList count]; i ++) {
            NSDictionary *dict = [contactList objectAtIndex:i];
            
            NSString *userid = [dict objectForKey:@"userId"];
            NSString *userAccount = [dict objectForKey:@"userAccount"];
            NSString *userSex = [dict objectForKey:@"userSex"];
            NSString *username = [dict objectForKey:@"userName"];
            NSString *usertype = [dict objectForKey:@"userType"];
            NSString *email = [dict objectForKey:@"email"];
            NSString *mobilePhone = [dict objectForKey:@"mobile"];
            NSString *createTime = [dict objectForKey:@"createTime"];
            NSString *userimgurl = [dict objectForKey:@"certNo"];
            NSString *userPinYin = [pptoolsclass pytransform:[dict objectForKey:@"userName"]];
//            if ([username isEqualToString:@"admin"]) {
//                
//            }else{
//                
//            }
            BOOL insert = [db executeUpdate:@"insert into PP_ADDRESSBOOK_DATA(userid,userAccount,userSex,username,usertype,email,mobilePhone,createTime,userimgurl,userPinYin) values (?,?,?,?,?,?,?,?,?,?)",userid,userAccount,userSex,username,usertype,email,mobilePhone,createTime,userimgurl,userPinYin];
            if (insert) {
                //                NSLog(@"insert Success!");
            }
            
        }
        completionBlock();
    }];
    return YES;
    
}

+ (BOOL)deleteAllContacts
{
    return NO;
}

+ (NSMutableArray *)getAllContacts
{
    NSMutableArray *contactsList = [NSMutableArray arrayWithCapacity:0];
    
    NSString* dbpath = [DBoperate getDBPath];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        // error
    }else{
        NSString *str = [NSString stringWithFormat:@"select * from PP_ADDRESSBOOK_DATA"];
        FMResultSet *set = [db  executeQuery:str];
        // 2.取出数据
        while ([set next]) {
            NSString *userid = [set stringForColumn:@"userid"];
            NSString *userAccount = [set stringForColumn:@"userAccount"];
            NSString *userSex = [set stringForColumn:@"userSex"];
            NSString *username = [set stringForColumn:@"username"];
            NSString *usertype = [set stringForColumn:@"usertype"];
            NSString *email = [set stringForColumn:@"email"];
            NSString *mobilePhone = [set stringForColumn:@"mobilePhone"];
            NSString *createTime = [set stringForColumn:@"createTime"];
            NSString *userimgurl = [set stringForColumn:@"userimgurl"];
            NSString *userPinYin = [set stringForColumn:@"userPinYin"];
            NSMutableDictionary *contactsinfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                             userid,@"userid",
                                             userAccount,@"userAccount",
                                             userSex,@"userSex",
                                             username,@"username",
                                             usertype,@"usertype",
                                             email,@"email",
                                             mobilePhone,@"mobilePhone",
                                             createTime,@"createTime",
                                             userimgurl,@"userimgurl",
                                             userPinYin,@"userPinYin",nil];
            if ([username isEqualToString:@"admin"]) {
            }else{
                [contactsList addObject:contactsinfo];
            }
            
        }
        [db close];
    }
    
    return contactsList;
}

+ (NSString *)getuserNameFormuserId:(NSString *)userId
{
    NSString *username = nil;
    NSString* dbpath = [DBoperate getDBPath];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        // error
    }else{
        
        if ([userId isEqualToString:@""]) {
            return @"";
        }
        NSString *str = [NSString stringWithFormat:@"select username from PP_ADDRESSBOOK_DATA where userid = '%@'",userId];
        FMResultSet *set = [db  executeQuery:str];
        // 2.取出数据
        while ([set next]) {
            username = [set stringForColumn:@"username"];
        }
        [db close];
    }
    
    return username;
}

+ (NSMutableArray *)getSearchContacts:(NSString *)text
{
    NSMutableArray *contactsList = [NSMutableArray arrayWithCapacity:0];
    
    NSString* dbpath = [DBoperate getDBPath];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        // error
    }else{
        if ([text isEqualToString:@""]) {
            return contactsList;
        }
        NSString *str = [NSString stringWithFormat:@"select * from PP_ADDRESSBOOK_DATA where username like '%@%%' OR  userPinYin like '%@%%'",text,text];
        FMResultSet *set = [db  executeQuery:str];
        // 2.取出数据
        while ([set next]) {
            NSString *userid = [set stringForColumn:@"userid"];
            NSString *userAccount = [set stringForColumn:@"userAccount"];
            NSString *userSex = [set stringForColumn:@"userSex"];
            NSString *username = [set stringForColumn:@"username"];
            NSString *usertype = [set stringForColumn:@"usertype"];
            NSString *email = [set stringForColumn:@"email"];
            NSString *mobilePhone = [set stringForColumn:@"mobilePhone"];
            NSString *createTime = [set stringForColumn:@"createTime"];
            NSString *userimgurl = [set stringForColumn:@"userimgurl"];
            NSString *userPinYin = [set stringForColumn:@"userPinYin"];
            NSMutableDictionary *contactsinfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                 userid,@"userid",
                                                 userAccount,@"userAccount",
                                                 userSex,@"userSex",
                                                 username,@"username",
                                                 usertype,@"usertype",
                                                 email,@"email",
                                                 mobilePhone,@"mobilePhone",
                                                 createTime,@"createTime",
                                                 userimgurl,@"userimgurl",
                                                 userPinYin,@"userPinYin",nil];
            [contactsList addObject:contactsinfo];
        }
        [db close];
    }
    
    return contactsList;
}

#pragma mark - 知识中心文件操作
+ (BOOL)addNewDownloadFile:(NSMutableDictionary *)fileAttribute
{
    NSString* dbpath = [DBoperate getDBPath];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        // error
        return NO;
    }
    NSDateFormatter *dateFormatter = [PPToolsClass sharedTools].dateFormatter;
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *downloadTime = [dateFormatter stringFromDate:[NSDate date]];
    BOOL insert = [db executeUpdate:@"insert into PP_FILE_DATA(knowledgeId,fileId,fileName,fileExt,filePath,fileSize,fileClass,fileupdateTime,downloadTime) values (?,?,?,?,?,?,?,?,?)"
                   ,[fileAttribute objectForKey:@"knowledgeId"]
                   ,[fileAttribute objectForKey:@"fileId"]
                   ,[fileAttribute objectForKey:@"fileName"]
                   ,[fileAttribute objectForKey:@"fileExt"]
                   ,[fileAttribute objectForKey:@"filePath"]
                   ,[fileAttribute objectForKey:@"fileSize"]
                   ,[fileAttribute objectForKey:@"fileClass"]
                   ,[fileAttribute objectForKey:@"fileupdateTime"]
                   ,downloadTime];
    if (insert) {
        NSLog(@"添加下载 Success!");
        return YES;
    }
    return NO;
}

+ (BOOL)deleteDownloadFile:(NSMutableDictionary *)fileAttribute
{
    NSString* dbpath = [DBoperate getDBPath];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        // error
        return NO;
    }
    NSString *deleteSql = [NSString stringWithFormat:
                           @"delete from PP_FILE_DATA where fileId = '%@'",[fileAttribute objectForKey:@"fileId"]];
    BOOL delete = [db executeUpdate:deleteSql];
    if (delete) {
        NSLog(@"删除成功 Success!");
        return YES;
    }
    return NO;
}
+ (NSMutableArray *)getFileList:(NSString *)lastDownloadTime
{
    NSMutableArray *fileList = [NSMutableArray arrayWithCapacity:0];
    
    NSString* dbpath = [DBoperate getDBPath];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        // error
    }else{
        NSString *str = [NSString stringWithFormat:@"select * from PP_FILE_DATA order by downloadTime desc"];
        FMResultSet *set = [db  executeQuery:str];
        // 2.取出数据
        while ([set next]) {
            
            // 取出姓名 fileId,fileName,fileExt,filePath,fileSize,fileClass,fileupdateTime,downloadTime
            NSString *knowledgeId = [set stringForColumn:@"knowledgeId"];
            NSString *fileId =      [set stringForColumn:@"fileId"];
            NSString *fileName =      [set stringForColumn:@"fileName"];
            NSString *fileExt =         [set stringForColumn:@"fileExt"];
            NSString *filePath =      [set stringForColumn:@"filePath"];
            NSString *fileSize =        [set stringForColumn:@"fileSize"];
            NSString *fileClass =     [set stringForColumn:@"fileClass"];
            NSString *fileupdateTime =    [set stringForColumn:@"fileupdateTime"];
            NSString *downloadTime =       [set stringForColumn:@"downloadTime"];
            
            
            NSMutableDictionary *fileinfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                             knowledgeId,@"knowledgeId",
                                             fileId,@"fileId",
                                             fileName,@"fileName",
                                             fileExt,@"fileExt",
                                             filePath,@"filePath",
                                             fileSize,@"fileSize",
                                             fileClass,@"fileClass",
                                             fileupdateTime,@"fileupdateTime",
                                             downloadTime,@"downloadTime",nil];
            [fileList addObject:fileinfo];
        }
        [db close];
    }
    
    return fileList;
}

+ (NSMutableDictionary *)getDataFromFileid:(NSString *)fileid
{
    NSMutableDictionary *fileinfo = nil;
    NSString* dbpath = [DBoperate getDBPath];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        // error
    }else{
        NSString *str = [NSString stringWithFormat:@"select * from PP_FILE_DATA where fileId = '%@'",fileid];
        FMResultSet *set = [db  executeQuery:str];
        // 2.取出数据
        while ([set next]) {
            
            // 取出姓名 fileId,fileName,fileExt,filePath,fileSize,fileClass,fileupdateTime,downloadTime
            NSString *knowledgeId = [set stringForColumn:@"knowledgeId"];
            NSString *fileId =      [set stringForColumn:@"fileId"];
            NSString *fileName =      [set stringForColumn:@"fileName"];
            NSString *fileExt =         [set stringForColumn:@"fileExt"];
            NSString *filePath =      [set stringForColumn:@"filePath"];
            NSString *fileSize =        [set stringForColumn:@"fileSize"];
            NSString *fileClass =     [set stringForColumn:@"fileClass"];
            NSString *fileupdateTime =    [set stringForColumn:@"fileupdateTime"];
            NSString *downloadTime =       [set stringForColumn:@"downloadTime"];
            
            
            fileinfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                             knowledgeId,@"knowledgeId",
                                             fileId,@"fileId",
                                             fileName,@"fileName",
                                             fileExt,@"fileExt",
                                             filePath,@"filePath",
                                             fileSize,@"fileSize",
                                             fileClass,@"fileClass",
                                             fileupdateTime,@"fileupdateTime",
                                             downloadTime,@"downloadTime",nil];
        }
        [db close];
    }
    
    return fileinfo;
}

+ (BOOL)isFileDownload:(NSString *)fileid
{
    NSString* dbpath = [DBoperate getDBPath];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    BOOL isExistFile = NO;
    if (![db open]) {
        // error
        return NO;
    }else{
        NSString *str = [NSString stringWithFormat:@"select * from PP_FILE_DATA where fileId = '%@'",fileid];
        FMResultSet *set = [db  executeQuery:str];
        // 2.取出数据
        while ([set next]) {
            
            isExistFile = YES;
        }
        [db close];
    }
    return isExistFile;
}
#pragma mark - 巡检操作
//同步所有位置
+ (BOOL)synPlaces:(NSMutableArray *)contactList progress:(void (^)(void))progressFloat completionBlock:(void (^)(void))completionBlock
{
    NSString *dbpath = [DBoperate getDBPath];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbpath];
    
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        progressFloat();
        
        //create table PP_PPLACE_DATA (id integer primary key,areaName text,createTime text,latitude text,longitude text,patrolAreaId text,patrolPlaceName text,remark text
        //通讯录表
        [db executeUpdate:@"delete from PP_PPLACE_DATA"];
        //            delete from TableName;
        
        for (NSInteger i = 0; i < [contactList count]; i ++) {
            NSDictionary *dict = [contactList objectAtIndex:i];
            
            NSString *areaName = [dict objectForKey:@"areaName"];
            NSString *createTime = [dict objectForKey:@"createTime"];
            NSString *latitude = [dict objectForKey:@"latitude"];
            NSString *longitude = [dict objectForKey:@"longitude"];
            NSString *patrolAreaId = [dict objectForKey:@"patrolAreaId"];
            NSString *patrolPlaceName = [dict objectForKey:@"patrolPlaceName"];
            NSString *patrolPlaceId = [dict objectForKey:@"patrolPlaceId"];
            
            NSString *remark = [dict objectForKey:@"remark"];
            BOOL insert = [db executeUpdate:@"insert into PP_PPLACE_DATA(areaName,createTime,latitude,longitude,patrolAreaId,patrolPlaceName,patrolPlaceId,remark) values (?,?,?,?,?,?,?,?)",areaName,createTime,latitude,longitude,patrolAreaId,patrolPlaceName,patrolPlaceId,remark];
            if (insert) {
                //                NSLog(@"insert Success!");
            }
        }
        completionBlock();
    }];
    return YES;
    
}

//搜索地点
+ (NSMutableArray *)getSearchPlaces:(NSString *)text
{
    NSMutableArray *placesList = [NSMutableArray arrayWithCapacity:0];
    
    NSString* dbpath = [DBoperate getDBPath];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        // error
    }else{
        if ([text isEqualToString:@""]) {
            return placesList;
        }
        NSString *str = [NSString stringWithFormat:@"select * from PP_PPLACE_DATA where patrolPlaceName like '%%%@%%'",text];
        FMResultSet *set = [db  executeQuery:str];
        // 2.取出数据
        while ([set next]) {
            NSString *areaName = [set stringForColumn:@"areaName"];
            NSString *createTime = [set stringForColumn:@"createTime"];
            NSString *latitude = [set stringForColumn:@"latitude"];
            NSString *longitude = [set stringForColumn:@"longitude"];
            NSString *patrolAreaId = [set stringForColumn:@"patrolAreaId"];
            NSString *patrolPlaceName = [set stringForColumn:@"patrolPlaceName"];
            NSString *patrolPlaceId = [set stringForColumn:@"patrolPlaceId"];
            NSString *remark = [set stringForColumn:@"remark"];
            
            NSMutableDictionary *placesinfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                 areaName,@"areaName",
                                                 createTime,@"createTime",
                                                 latitude,@"latitude",
                                                 longitude,@"longitude",
                                                 patrolAreaId,@"patrolAreaId",
                                                 patrolPlaceName,@"patrolPlaceName",
                                                 patrolPlaceId,@"patrolPlaceId",
                                                 remark,@"remark",nil];
            [placesList addObject:placesinfo];
        }
        [db close];
    }
    
    return placesList;
}

+ (NSMutableDictionary *)getDataFromPlaceId:(NSString *)text
{
    NSMutableDictionary *placesinfo = [NSMutableDictionary dictionaryWithCapacity:0];
    
    NSString* dbpath = [DBoperate getDBPath];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        // error
    }else{
        if ([text isEqualToString:@""]) {
            return placesinfo;
        }
        NSString *str = [NSString stringWithFormat:@"select * from PP_PPLACE_DATA where patrolPlaceId = '%@'",text];
        FMResultSet *set = [db  executeQuery:str];
        // 2.取出数据
        while ([set next]) {
            NSString *areaName = [set stringForColumn:@"areaName"];
            NSString *createTime = [set stringForColumn:@"createTime"];
            NSString *latitude = [set stringForColumn:@"latitude"];
            NSString *longitude = [set stringForColumn:@"longitude"];
            NSString *patrolAreaId = [set stringForColumn:@"patrolAreaId"];
            NSString *patrolPlaceName = [set stringForColumn:@"patrolPlaceName"];
            NSString *patrolPlaceId = [set stringForColumn:@"patrolPlaceName"];
            NSString *remark = [set stringForColumn:@"remark"];
            
            placesinfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                               areaName,@"areaName",
                                               createTime,@"createTime",
                                               latitude,@"latitude",
                                               longitude,@"longitude",
                                               patrolAreaId,@"patrolAreaId",
                                               patrolPlaceName,@"patrolPlaceName",
                                               patrolPlaceId,@"patrolPlaceId",
                                               remark,@"remark",nil];
        }
        [db close];
    }
    
    return placesinfo;
}


+ (BOOL)addOnePPFile:(NSMutableDictionary *)ppdata
{
    NSString* dbpath = [DBoperate getDBPath];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        // error
        return NO;
    }
//    PP_PPLACE_FILELOCALSAVE_DATA (id integer primary key,patrolPlaceId text,filePath text)
    
    BOOL insert = [db executeUpdate:@"insert into PP_PPLACE_FILELOCALSAVE_DATA(patrolRecordId,filePath) values (?,?)"
                   ,[ppdata objectForKey:@"patrolRecordId"]
                   ,[ppdata objectForKey:@"filePath"]];
    if (insert) {
        NSLog(@"添加下载 Success!");
        return YES;
    }
    return NO;
}

+ (BOOL)removeOnePPFile:(NSMutableDictionary *)ppdata
{
    NSString* dbpath = [DBoperate getDBPath];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        // error
        return NO;
    }
    NSString *deleteSql = [NSString stringWithFormat:
                           @"delete from PP_PPLACE_FILELOCALSAVE_DATA where id = '%@'",[ppdata objectForKey:@"fileId"]];
    BOOL delete = [db executeUpdate:deleteSql];
    if (delete) {
        NSLog(@"删除成功 Success!");
        return YES;
    }
    return NO;
}

+ (NSMutableArray *)getallPPFileData
{
    NSMutableArray *fileList = [NSMutableArray arrayWithCapacity:0];
    
    NSString* dbpath = [DBoperate getDBPath];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        // error
    }else{
        NSString *str = [NSString stringWithFormat:@"select * from PP_PPLACE_FILELOCALSAVE_DATA"];
        FMResultSet *set = [db  executeQuery:str];
        // 2.取出数据
        while ([set next]) {
            
            // 取出姓名 fileId,fileName,fileExt,filePath,fileSize,fileClass,fileupdateTime,downloadTime
            NSString *fileId =              [set stringForColumn:@"id"];
            NSString *patrolRecordId =       [set stringForColumn:@"patrolRecordId"];
            NSString *filePath =            [set stringForColumn:@"filePath"];
            
            
            NSMutableDictionary *fileinfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                             fileId,@"fileId",
                                             patrolRecordId,@"patrolRecordId",
                                             filePath,@"filePath",nil];
            [fileList addObject:fileinfo];
        }
        [db close];
    }
    
    return fileList;
}


@end

//
//  PPFileOperate.m
//  ParkProject
//
//  Created by yuanxuan on 16/7/8.
//  Copyright © 2016年 yuanxuan. All rights reserved.
//

#import "PPFileOperate.h"

@implementation PPFileOperate
//获取Documents目录
- (NSString *)dirDoc{
    //[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"app_home_doc: %@",documentsDirectory);
    return documentsDirectory;
}

//获取Library目录
-(void)dirLib{
    //[NSHomeDirectory() stringByAppendingPathComponent:@"Library"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];
    NSLog(@"app_home_lib: %@",libraryDirectory);
}

//获取Tmp目录
-(void)dirTmp{
    //[NSHomeDirectory() stringByAppendingPathComponent:@"tmp"];
    NSString *tmpDirectory = NSTemporaryDirectory();
    NSLog(@"app_home_tmp: %@",tmpDirectory);
}

//创建文件夹
-(void)createDir{
    NSString *documentsPath =[self dirDoc];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:@"knowledgeFile"];
    // 创建目录
    if ([fileManager fileExistsAtPath:testDirectory]) {
        NSLog(@"已存在此文件夹");
    }else{
        BOOL res=[fileManager createDirectoryAtPath:testDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        if (res) {
            NSLog(@"文件夹创建成功");
        }else
            NSLog(@"文件夹创建失败");
    }
    
}

//创建目录
- (void)createDirName:(NSString *)dirName{
    NSString *documentsPath =[self dirDoc];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:dirName];
    // 创建目录
    if ([fileManager fileExistsAtPath:testDirectory]) {
        NSLog(@"已存在此文件夹");
    }else{
        BOOL res=[fileManager createDirectoryAtPath:testDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        if (res) {
            NSLog(@"文件夹创建成功");
        }else
            NSLog(@"文件夹创建失败");
    }
}

//获取文件路径
- (NSString *)getDirName:(NSString *)dirName fileName:(NSString *)filename{
    NSString *documentsPath =[self dirDoc];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:dirName];
    NSString *filepath = [testDirectory stringByAppendingPathComponent:filename];
    // 创建目录
    if ([fileManager fileExistsAtPath:testDirectory]) {
        NSLog(@"已存在此文件夹");
    }else{
        BOOL res=[fileManager createDirectoryAtPath:testDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        if (res) {
            NSLog(@"文件夹创建成功");
        }else
            NSLog(@"文件夹创建失败");
    }
    return filepath;
}


//创建文件夹
-(void)createDATADir{
    NSString *documentsPath =[self dirDoc];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:@"userData"];
    // 创建目录
    if ([fileManager fileExistsAtPath:testDirectory]) {
        NSLog(@"已存在此文件夹");
    }else{
        BOOL res=[fileManager createDirectoryAtPath:testDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        if (res) {
            NSLog(@"文件夹创建成功");
        }else
            NSLog(@"文件夹创建失败");
    }
    
}


//创建文件
-(void)createFile{
    NSString *documentsPath =[self dirDoc];
    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:@"test"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testPath = [testDirectory stringByAppendingPathComponent:@"test.txt"];
    BOOL res=[fileManager createFileAtPath:testPath contents:nil attributes:nil];
    if (res) {
        NSLog(@"文件创建成功: %@" ,testPath);
    }else
        NSLog(@"文件创建失败");
}

//写文件
-(void)writeFile{
    NSString *documentsPath =[self dirDoc];
    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:@"test"];
    NSString *testPath = [testDirectory stringByAppendingPathComponent:@"test.txt"];
    NSString *content=@"测试写入内容！";
    BOOL res=[content writeToFile:testPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    if (res) {
        NSLog(@"文件写入成功");
    }else
        NSLog(@"文件写入失败");
}

//读文件
-(void)readFile{
    NSString *documentsPath =[self dirDoc];
    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:@"test"];
    NSString *testPath = [testDirectory stringByAppendingPathComponent:@"test.txt"];
    //    NSData *data = [NSData dataWithContentsOfFile:testPath];
    //    NSLog(@"文件读取成功: %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    NSString *content=[NSString stringWithContentsOfFile:testPath encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"文件读取成功: %@",content);
}

//文件属性
-(void)fileAttriutes{
    NSString *documentsPath =[self dirDoc];
    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:@"test"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testPath = [testDirectory stringByAppendingPathComponent:@"test.txt"];
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:testPath error:nil];
    NSArray *keys;
    id key, value;
    keys = [fileAttributes allKeys];
    NSInteger count = [keys count];
    for (int i = 0; i < count; i++)
    {
        key = [keys objectAtIndex: i];
        value = [fileAttributes objectForKey: key];
        NSLog (@"Key: %@ for value: %@", key, value);
    }
}

//删除文件
- (BOOL)deleteFile:(NSString *)filename{
    NSString *documentsPath =[self dirDoc];
    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:@"knowledgeFile"];
    NSString *filePath = [testDirectory stringByAppendingPathComponent:filename];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL res=[fileManager removeItemAtPath:filePath error:nil];
    if (res) {
        NSLog(@"文件删除成功");
        return YES;
    }else{
        
    }
    return NO;
//    NSLog(@"文件是否存在: %@",[fileManager isExecutableFileAtPath:filePath]?@"YES":@"NO");
}

- (BOOL)isFilePath:(NSString *)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 创建目录
    if ([fileManager fileExistsAtPath:filePath]) {
        return YES;
    }
    return NO;
    //    NSLog(@"文件是否存在: %@",[fileManager isExecutableFileAtPath:filePath]?@"YES":@"NO");
}

- (BOOL)deleteFilePath:(NSString *)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL res=[fileManager removeItemAtPath:filePath error:nil];
    if (res) {
        NSLog(@"文件删除成功");
        return YES;
    }else{
        
    }
    return NO;
    //    NSLog(@"文件是否存在: %@",[fileManager isExecutableFileAtPath:filePath]?@"YES":@"NO");
}

//- (BOOL)deleteFilePath:(NSString *)filepath{
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    BOOL res=[fileManager removeItemAtPath:filepath error:nil];
//    if (res) {
//        NSLog(@"文件删除成功");
//        return YES;
//    }else{
//        
//    }
//    return NO;
//    //    NSLog(@"文件是否存在: %@",[fileManager isExecutableFileAtPath:filePath]?@"YES":@"NO");
//}

@end

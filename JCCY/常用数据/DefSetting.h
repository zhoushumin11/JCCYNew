//
//  DefSetting.h
//  xiaoyijingzhineng
//
//  Created by yuanxuan on 15/5/16.
//  Copyright (c) 2015年 rp. All rights reserved.
//

#ifndef xiaoyijingzhineng_DefSetting_h
#define xiaoyijingzhineng_DefSetting_h

#pragma mark - 常用定义


#define PPMainFrame [UIScreen mainScreen].bounds
#define PPMainViewWidth  [UIScreen mainScreen].bounds.size.width
#define PPMainViewHeight [UIScreen mainScreen].bounds.size.height
#define isAtLeastiOS7 (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
#define IMG(imgname) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:imgname ofType:@"png"]]


typedef enum : NSUInteger {
    PPkrpsType,
    PPInitiateType,
    PPAttentionType,
} PPTaskType;

//网络状态通知
#define NETWORKNOTIFACTION @"NETWORKNOTIFACTIONNMTX"

#define kUserDefaultsCookie @"kUserDefaultsCookie"

//登录刷新
#define LOGINSUCCESSNOTIFACTION @"LOGINSUCCESSNOTIFACTION"
#define LOGOUTNOTIFACTION @"LOGOUTNOTIFACTION"

//即时通讯IM
#define PPIMAPPKEY @"8a216da855dd248e0155e34069f30776"
#define PPIMAPPTOKEN  @"36800e515eed42b61342e21c56fa5bbc"
#define TXLSM @"TXLSM"
//刷新消息数量
#define UPDATEMSGCount @"UPDATEMSGCount"

//隐藏显示工作角标
#define SHOWHIDDENCORNER @"showHiddenCorner"

//默认头像图片
#define imgiconDefault @"wdusericon.png"

//下载文件
#define DOWNLOADFILE @"DOWNLOADFILE"

//巡检相关
#define PPPROUTE @"PPPROUTE"
#define PPPONELOCATION @"PPPONELOCATION"
#define PPPdistance 100

//限制图片数量
#define minimgCount 5

#pragma mark - 工作

#pragma mark - 工作任务
#define TASKUPTATE @"TASKUPTATE"

#pragma mark - 审批
#define EAAUPTATE @"EAAUPTATE"

#pragma mark - 日志
#define LOGUPTATE @"LOGUPTATE"

#pragma mark - 通讯录
#define FIRSTSYNCONTACT @"FIRSTSYNCONTACT"
#define CONTACTSUPDATE @"CONTACTSUPDATE"

#pragma mark - 我的
#define UPDATEMYINFO @"UPDATEMYINFO"

//设置字体
#define SystemFont(s) [UIFont fontWithName:@"Avenir-Light" size:s] //Avenir-Roman
#define SystemFoldFont(s) [UIFont fontWithName:@"Avenir-Roman" size:s] //Avenir-Medium
#define SystemColor(c) [UIColor colorFromHexRGB:c];
//#define Log(s) NSLog(@"s");

//获取宽度高度无限的字符串位置大小
#define GetHTextSizeFoldFont(htitle,wsize,hfont) [htitle boundingRectWithSize:CGSizeMake(wsize, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SystemFoldFont(hfont)} context:nil].size;

#define GetWTextSizeFoldFont(wtitle,hsize,wfont) [wtitle boundingRectWithSize:CGSizeMake(MAXFLOAT, hsize) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SystemFoldFont(wfont)} context:nil].size;

#define GetHTextSizeFont(htitle,wsize,hfont) [htitle boundingRectWithSize:CGSizeMake(wsize, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SystemFont(hfont)} context:nil].size;

#define GetWTextSizeFont(wtitle,hsize,wfont) [wtitle boundingRectWithSize:CGSizeMake(MAXFLOAT, hsize) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SystemFont(wfont)} context:nil].size;
#pragma mark - 服务器
//102  服务器ip地址
#define SEVERURL @"SEVERURL"


#define severurl  @"http://wutong.jingchengidea.com"  //测试地址




#endif

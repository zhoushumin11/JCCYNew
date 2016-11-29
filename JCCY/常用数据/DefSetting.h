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

#define BXScreenH [UIScreen mainScreen].bounds.size.height
#define BXScreenW [UIScreen mainScreen].bounds.size.width
// 设置颜色
#define BXColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
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

//微信支付id
#define WXAppId @"wxbc85f05c6861a34e"
//微信支付商户号
#define WXPartnerId @"1406952902"

//刷新消息数量
#define UPDATEMSGCount @"UPDATEMSGCount"

//支付宝接口回调
#define JCCYAliPayNotificationCenter @"JCCYAliPayNotificationCenter"
//微信支付接口回调通知
#define JCCYWeChatNotificationCenter @"JCCYWeChatNotificationCenter"


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

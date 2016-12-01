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

//通知服务器有更新之后通知
#define UPDATAUPIDDATA @"UPDATAUPIDDATA"
//刷新我的视图
#define UPDATA_MYViews @"UPDATA_MYViews"

//微信支付id
#define WXAppId @"wxbc85f05c6861a34e"
//微信支付商户号
#define WXPartnerId @"1406952902"
//微信支付key
#define WXPayKey @"bdyX1UY9WgwA0MoEFBEw3DXdFbsRIB3O"

//刷新消息数量
#define UPDATEMSGCount @"UPDATEMSGCount"

//支付宝接口回调
#define JCCYAliPayNotificationCenter @"JCCYAliPayNotificationCenter"
//微信支付接口回调通知
#define JCCYWeChatNotificationCenter @"JCCYWeChatNotificationCenter"

//微信支付成功
#define JCCYWeiXinPaySucc @"WeiXinZhiFuSUCCESS"

//微信支付失败
#define JCCYWeiXinPayFail @"WeiXinZhiFuFail"

//支付宝支付相关
/**
 *  partner:合作身份者ID,以 2088 开头由 16 位纯数字组成的字符串。
 *
 */
#define kPartnerID @"2088021646202151"


/**
 *  seller:支付宝收款账号,手机号码或邮箱格式。
 */
#define kSellerAccount @"jingchengidea@qq.com"

/**
 *  支付宝服务器主动通知商户 网站里指定的页面 http 路径。
 */
#define kNotifyURL @"http://wutong.jingchengidea.com/Api/UserRechargeReturn/alipay_return/"


/**
 *  appSckeme:应用注册scheme,在Info.plist定义URLtypes，处理支付宝回调
 */
#define kAppScheme @"com.jingchengkeji.wtband.ios"


/**
 *  private_key:商户方的私钥,pkcs8 格式。
 */
#define kPrivateKey @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAKsJGK7zeIBUOznkIR7xcOfczbLMkaPMK52bGPeA3koqFiRuWBEdz+poPQlnYlnFqrBjn5BVWglZXIIFup+PtCngpcPJLsHqzkOkummu5+1p40MYIrycZiKIAyH4ME2Nrhr7IcqZvaT9rtp37uB8p+I1y9J8HcJqN+RodrGJJOp3AgMBAAECgYAchk3Zj71/GY0vIH7tnDLKWKbttPRtLvXvORi23oU0NUSwGr8RS7mLTIsxcE6UzkSjWloYRkPX31FwVehECEFxnLWuSHNuRxC24BsC0Q9f+fOrpqnIlYX3pPos2AevTn1ymfSP8zVqMfVTeiKvQowsTLwPo7vwxwvyvIqvRL4JcQJBANbWvkpyAu4O7+lqocsgV7PaALO6X75DYuzkCXLGjvjE5lw9ByBX9xB4G4diU/GPcwGrFpOWNlqRy5DaZzMYoT0CQQDLzeu6YDaFOesEY+bmBgzBnWNQvyJ4VO/5JAS/lJMzUXQnjkrnfpE56G/JYk9uNM0+hMh3mXno2Gl+zwbBGg3DAkAsz+IlWR6vVUJJp8pTuk1Q4HohAxEReLDbxL0LycrsrPV36+renjqUntjvJl1oF4nfoTY2VrDDt4GEl2nLSKnpAkEAneHuZbm3Qso1iHckHro9E5iroZgQSgvyw5zlmMyupCjLxQD0ghWIx8WLJAVm50c8YNxYuF5LFNjiEPysjNd0JQJBALji0WS7ofc9HDI0JS/0LkqvSxh4zglwdrVcDhIvt91ZnkiqoKOOVSRHqh5HphTjtm6GoyB/FQFVYum6IwO3CpU="



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

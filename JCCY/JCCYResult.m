//
//  XMConferenceResult.m
//  XMSipSDK
//
//  Created by 刘杨 on 16/3/14.
//  Copyright © 2016年 刘杨. All rights reserved.
//

#import "JCCYResult.h"
#import "UIAlertController+SimpleAlert.h"

@implementation JCCYResult
+ (void)showResultWithResult:(NSString *)result controller:(UIViewController *)controller{
    NSMutableString *message = [NSMutableString stringWithFormat:@""];
    if ([result isEqualToString:@"-1"]) {
        [message appendString:@"系统错误,参数无法解析"];
    }else if ([result isEqualToString:@"-2"]) {
        [message appendString:@"设置信息有更新,需要执行信息检查接口"];
    }else if ([result isEqualToString:@"-3"]){
        [message appendString:@"服务器程序异常"];
    }else if ([result isEqualToString:@"-4"]){
        [message appendString:@"该操作需要登录"];
    }else if ([result isEqualToString:@"-5"]){
        [message appendString:@"该栏目为收费栏目,请先购买"];
    }else if ([result isEqualToString:@"-6"]){
        [message appendString:@"该操作需要登录"];
    }else if ([result isEqualToString:@"-7"]){
        [message appendString:@"版本滞后,需要更新版本"];
    }else if ([result isEqualToString:@"-100"]){
        [message appendString:@"手机号不合法"];
    }else if ([result isEqualToString:@"-101"]){
        [message appendString:@"该手机号没有绑定微信,请先用微信登录再绑定手机号"];
    }else if ([result isEqualToString:@"-102"]){
        [message appendString:@"短信发送失败,请用微信登录"];
    }else if ([result isEqualToString:@"-103"]){
        [message appendString:@"微信信息不合法"];
    }else if ([result isEqualToString:@"-104"]){
        [message appendString:@"验证码不正确"];
    }else if ([result isEqualToString:@"-105"]){
        [message appendString:@"该用户已经被锁定,登录失败"];
    }else if ([result isEqualToString:@"-106"]){
        [message appendString:@"抱歉,该服务无法购买"];
    }else if ([result isEqualToString:@"-107"]){
        [message appendString:@"抱歉,您的余额不足,购买该服务失败."];
    }else if ([result isEqualToString:@"-108"]){
        [message appendString:@"抱歉,该条充值已经被更新"];
    }else if ([result isEqualToString:@"-109"]){
        [message appendString:@"充值信息异常,该信息已经被锁定,请联系管理员处理"];
    }else if ([result isEqualToString:@"-110"]){
        [message appendString:@"该用户已在其他设备中登录,请重新登录"];
    }else if ([result isEqualToString:@"-111"]){
        [message appendString:@"充值编号不合法"];
    }else{
        [message appendString:@"未知错误"];
    }
    [UIAlertController showTipsInViewController:controller message:message];

}
@end

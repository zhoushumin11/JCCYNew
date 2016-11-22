//
//  PPToolsClass.h
//  ParkProject
//
//  Created by yuanxuan on 16/7/15.
//  Copyright © 2016年 yuanxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPToolsClass : NSObject

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSCalendar *chineseClendar;

+ (PPToolsClass *)sharedTools;
//通讯录操作
+ (UIColor *)getColorForID:(NSString *)empid;
//字符操作
- (NSString *)pytransform:(NSString *)chinese; //字符转拼音
//Date 日期相关解决方案
- (NSString *)calDateIntervalendDate:(NSDate *)paramEndDate;
- (NSString *)CalDateIntervalFromData:(NSDate *)paramStartDate endDate:(NSDate *)paramEndDate;
- (NSString *)prettyDateWithReference:(NSDate *)reference;
- (NSString *)getcurrentYMDHMSDate:(NSDate *)date;

- (NSString *)getDateDisplayString:(long long) miliSeconds;
//根据当前的时间 对比获取年月日时分秒  如果是当前时间的年份 则获取月日时分秒
- (NSString *)getMonthDay:(NSString *)strdate;
- (NSString *)bySecondGetDate:(NSString *)second;
- (NSString *)bySecondGetNaturalDate:(NSString *)second;
- (NSDate *)getcurrentYearMonthDate:(NSString *)datestr;
- (NSString *)getcurrentDate:(NSDate *)date;
- (NSString *)getcurrentYearDate:(NSDate *)date;
- (NSString *)getcurrentMonthDate:(NSDate *)date;
//设置选中图
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (NSMutableAttributedString*)changeColor:(NSString*)Allstr partStr:(NSString*)partStr color:(UIColor*)Color font:(NSInteger)Font;
+ (NSMutableAttributedString*)changeColor:(NSString*)Allstr partStr1:(NSString*)partStr1 partStr2:(NSString*)partStr2 color:(UIColor*)Color font:(NSInteger)Font;
@end

//
//  PPToolsClass.m
//  ParkProject
//
//  Created by yuanxuan on 16/7/15.
//  Copyright © 2016年 yuanxuan. All rights reserved.
//

#import "PPToolsClass.h"

@interface PPToolsClass()

@end

@implementation PPToolsClass
+ (PPToolsClass *)sharedTools
{
    static PPToolsClass *sharedToolsInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedToolsInstance = [[self alloc] init];
    });
    return sharedToolsInstance;
}


- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    return _dateFormatter;
}

- (NSCalendar *)chineseClendar
{
    if (!_chineseClendar) {
        _chineseClendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    return _chineseClendar;
}

//字符操作
- (NSString *)pytransform:(NSString *)chinese
{
    NSMutableString *pinyin = [chinese mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
//    NSLog(@"%@", pinyin);
    return [pinyin uppercaseString];
}

// 计算到期时间的  最低单位小时  最高单位天
- (NSString *)CalDateIntervalFromData2:(NSDate *)paramStartDate endDate:(NSDate *)paramEndDate{
    
    NSString *strResult=nil;
    
    NSUInteger unitFlags =  NSCalendarUnitHour  | NSCalendarUnitDay  ;
    
    NSDateComponents *DateComponent = [self.chineseClendar components:unitFlags fromDate:paramStartDate toDate:paramEndDate options:0];
    
    NSInteger diffHour = [DateComponent hour];
    NSInteger diffDay   = [DateComponent day];
    
    
    if(diffDay>0){
        strResult=[NSString stringWithFormat:@"%ld天",(long)diffDay];
    }else if(diffHour>0){
        strResult=[NSString stringWithFormat:@"%ld小时",(long)diffHour];
    }else{
        strResult=[NSString stringWithFormat:@""];
    }
    return strResult;
}


//Date 日期相关解决方案
- (NSString *)CalDateIntervalFromData:(NSDate *)paramStartDate endDate:(NSDate *)paramEndDate{
    
    NSString *strResult=nil;
    
    NSUInteger unitFlags =  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitDay| NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday;
    
    NSDateComponents *DateComponent = [self.chineseClendar components:unitFlags fromDate:paramStartDate toDate:paramEndDate options:0];
    
    NSInteger diffHour = [DateComponent hour];
    
    NSInteger diffMin    = [DateComponent minute];
    
    NSInteger diffSec   = [DateComponent second];
    
    NSInteger diffDay   = [DateComponent day];
    
    NSInteger diffWeekDay = [DateComponent weekday];
    
    NSInteger diffMon  = [DateComponent month];
    
    NSInteger diffYear = [DateComponent year];
    
    if (diffYear>0) {
        strResult=[NSString stringWithFormat:@"%ld年前",(long)diffYear];
    }else if(diffMon>0){
        strResult=[NSString stringWithFormat:@"%ld月前",(long)diffMon];
    }else if(diffWeekDay>0){
        strResult=[NSString stringWithFormat:@"%ld周前",(long)diffWeekDay];
    }else if(diffDay>0){
        strResult=[NSString stringWithFormat:@"%ld天前",(long)diffDay];
    }else if(diffHour>0){
        strResult=[NSString stringWithFormat:@"%ld小时前",(long)diffHour];
    }else if(diffMin>0){
        strResult=[NSString stringWithFormat:@"%ld分钟前",(long)diffMin];
    }else if(diffSec>=0 || diffSec<0){
        strResult=[NSString stringWithFormat:@"刚刚"];//,(long)diffSec
    }
    else{
        strResult=[NSString stringWithFormat:@"未知时间"];
    }
    return strResult;
}

//Date 日期相关解决方案
- (NSString *)calDateIntervalendDate:(NSDate *)paramEndDate{
    
    NSString *strResult=nil;
    
    NSUInteger unitFlags =  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitDay| NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday;
    NSUInteger unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear ;
    
    NSDateComponents *nowCmps = [self.chineseClendar components:unit fromDate:[NSDate date]];
    NSDateComponents *myCmps = [self.chineseClendar components:unit fromDate:paramEndDate];
    
    
    NSDateComponents *DateComponent = [self.chineseClendar components:unitFlags fromDate:paramEndDate toDate:[NSDate date] options:0];
    
    NSInteger diffHour = [DateComponent hour];
    
    NSInteger diffMin    = [DateComponent minute];
    
    NSInteger diffSec   = [DateComponent second];
    
    NSInteger diffDay   = [DateComponent day];
    
    NSInteger diffWeekDay = [DateComponent weekday];
    
    NSInteger diffMon  = [DateComponent month];
    
    NSInteger diffYear = [DateComponent year];
    
    if (diffYear>0) {
        strResult=[NSString stringWithFormat:@"%@",[self getcurrentMonthDayDate:paramEndDate]];
    }else if(diffMon>0){
        strResult=[NSString stringWithFormat:@"%@",[self getcurrentMonthDayDate:paramEndDate]];
    }else if(diffWeekDay>0){
        strResult=[NSString stringWithFormat:@"%@",[self getcurrentMonthDayDate:paramEndDate]];
    }else if(diffDay>0){
        strResult=[NSString stringWithFormat:@"%@",[self getcurrentMonthDayDate:paramEndDate]];
    }else if(diffHour>0){
        strResult=[NSString stringWithFormat:@"%ld小时前",(long)diffHour];
    }else if(diffMin>0){
        strResult=[NSString stringWithFormat:@"%ld分钟前",(long)diffMin];
    }else if(diffSec>=0 || diffSec<0){
        strResult=[NSString stringWithFormat:@"刚刚"];//,(long)diffSec
    }
    else{
        strResult=[NSString stringWithFormat:@"未知时间"];
    }
    return strResult;
}

//时间显示内容
- (NSString *)getDateDisplayString:(long long) miliSeconds{
    
    NSTimeInterval tempMilli = miliSeconds;
    NSTimeInterval seconds = tempMilli/1000.0;
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:seconds];
    
    NSCalendar *calendar = [ NSCalendar currentCalendar ];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear ;
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[ NSDate date ]];
    NSDateComponents *myCmps = [calendar components:unit fromDate:myDate];
    
    NSDateFormatter *dateFmt = [[ NSDateFormatter alloc ] init ];
    if (nowCmps.year != myCmps.year) {
        dateFmt.dateFormat = @"yyyy-MM-dd HH:mm";
    } else {
        if (nowCmps.day==myCmps.day) {
            dateFmt.dateFormat = @"今天 HH:mm";//:ss
        } else if ((nowCmps.day-myCmps.day)==1) {
            dateFmt.dateFormat = @"昨天 HH:mm";
        } else {
            dateFmt.dateFormat = @"MM-dd HH:mm";
        }
    }
    return [dateFmt stringFromDate:myDate];
}



- (NSString *)prettyDateWithReference:(NSDate *)reference {
    NSString *suffix = @"前";
    NSDate *currentdate = [NSDate date];
    NSLog(@"currentdate:%@ reference:%@",currentdate,reference);
    float different = [currentdate timeIntervalSinceDate:reference];
    if (different <= 0) {
        different = -different;
        suffix = @"刚刚";
        return suffix;
    }
    
    // days = different / (24 * 60 * 60), take the floor value
    float dayDifferent = floor(different / 86400);
    
    int days   = (int)dayDifferent;
    int weeks  = (int)ceil(dayDifferent / 7);
    int months = (int)ceil(dayDifferent / 30);
    int years  = (int)ceil(dayDifferent / 365);
    
    // It belongs to today
    if (dayDifferent <= 0) {
        // lower than 60 seconds
        if (different < 60) {
            return @"刚刚";
        }
        
        // lower than 120 seconds => one minute and lower than 60 seconds
        if (different < 120) {
            return [NSString stringWithFormat:@"1分钟%@", suffix];
        }
        
        // lower than 60 minutes
        if (different < 660 * 60) {
            return [NSString stringWithFormat:@"%d分钟%@", (int)floor(different / 60), suffix];
        }
        
        // lower than 60 * 2 minutes => one hour and lower than 60 minutes
        if (different < 7200) {
            return [NSString stringWithFormat:@"1小时%@", suffix];
        }
        
        // lower than one day
        if (different < 86400) {
            return [NSString stringWithFormat:@"%d小时%@", (int)floor(different / 3600), suffix];
        }
    }
    // lower than one week
    else if (days < 7) {
        return [NSString stringWithFormat:@"%d天%@", days, suffix];
    }
    // lager than one week but lower than a month
    else if (weeks < 4) {
        return [NSString stringWithFormat:@"%d星期%@", weeks, suffix];
    }
    // lager than a month and lower than a year
    else if (months < 12) {
        return [NSString stringWithFormat:@"%d月%@", months, suffix];
    }
    // lager than a year
    else {
        return [NSString stringWithFormat:@"%d年%@", years, suffix];
    }
    
    return @"未知时间";
}

- (NSString *)bySecondGetDate:(NSString *)second{
    NSDateFormatter *df = self.dateFormatter;
    
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeInterval time=[second integerValue]/1000;
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    df.timeZone = [NSTimeZone systemTimeZone];//系统所在时区
    df.dateFormat = @"yyyy";
    NSString *datetime = nil;
    NSString *selectTimeStr =  [df stringFromDate:detaildate];
    NSString *systemTimeZoneStr =  [df stringFromDate:[NSDate date]];
    if ([selectTimeStr isEqualToString:systemTimeZoneStr]) {
        df.dateFormat = @"MM月dd日 HH:mm";
        datetime =  [df stringFromDate:detaildate];
    }else{
        df.dateFormat = @"yyyy-MM-dd HH:mm";
        datetime =  [df stringFromDate:detaildate];
    }
    
    
    
    return datetime;
}

- (NSString *)bySecondGetNaturalDate:(NSString *)second{
    NSDateFormatter *df = self.dateFormatter;
    
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeInterval time=[second integerValue]/1000;
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    df.timeZone = [NSTimeZone systemTimeZone];//系统所在时区
    NSString *datetime = nil;
//    NSString *selectTimeStr =  [df stringFromDate:detaildate];
//    NSString *systemTimeZoneStr =  [df stringFromDate:[NSDate date]];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    datetime =  [df stringFromDate:detaildate];
    return datetime;
}

- (NSDate *)getcurrentYearMonthDate:(NSString *)datestr
{
    NSDateFormatter *df = self.dateFormatter;
    df.timeZone = [NSTimeZone systemTimeZone];//系统所在时区
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [df dateFromString:datestr];
    return date;
}

//
- (NSString *)getMonthDay:(NSString *)strdate
{
    NSDateFormatter *df = self.dateFormatter;
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [df dateFromString:strdate];
    
    df.timeZone = [NSTimeZone systemTimeZone];//系统所在时区
    df.dateFormat = @"yyyy";
    NSString *datetime = nil;
    NSString *selectTimeStr =  [df stringFromDate:date];
    NSString *systemTimeZoneStr =  [df stringFromDate:[NSDate date]];
    if ([selectTimeStr isEqualToString:systemTimeZoneStr]) {
        df.dateFormat = @"MM-dd HH:mm";
        datetime =  [df stringFromDate:date];
    }else{
        df.dateFormat = @"yyyy-MM-dd HH:mm";
        datetime =  [df stringFromDate:date];
    }
    
    return datetime;
}

- (NSString *)getcurrentYMDHMSDate:(NSDate *)date
{
    NSDateFormatter *df = self.dateFormatter;
    df.timeZone = [NSTimeZone systemTimeZone];//系统所在时区
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *systemTimeZoneStr =  [df stringFromDate:date];
    return systemTimeZoneStr;
}

- (NSString *)getcurrentDate:(NSDate *)date
{
    NSDateFormatter *df = self.dateFormatter;
    df.timeZone = [NSTimeZone systemTimeZone];//系统所在时区
    df.dateFormat = @"yyyy-MM-dd";
    NSString *systemTimeZoneStr =  [df stringFromDate:date];
    return systemTimeZoneStr;
}

- (NSString *)getcurrentMonthDayDate:(NSDate *)date
{
    NSDateFormatter *df = self.dateFormatter;
    df.timeZone = [NSTimeZone systemTimeZone];//系统所在时区
    df.dateFormat = @"MM-dd HH:mm";
    NSString *systemTimeZoneStr =  [df stringFromDate:date];
    return systemTimeZoneStr;
}


- (NSString *)getcurrentYearDate:(NSDate *)date
{
    NSDateFormatter *df = self.dateFormatter;
    df.timeZone = [NSTimeZone systemTimeZone];//系统所在时区
    df.dateFormat = @"yyyy";
    NSString *systemTimeZoneStr =  [df stringFromDate:date];
    return systemTimeZoneStr;
}

- (NSString *)getcurrentMonthDate:(NSDate *)date
{
    NSDateFormatter *df = self.dateFormatter;
    df.timeZone = [NSTimeZone systemTimeZone];//系统所在时区
    df.dateFormat = @"MM";
    NSString *systemTimeZoneStr =  [df stringFromDate:date];
    return systemTimeZoneStr;
}

#pragma mark - 获取颜色
+ (UIColor *)getColorForID:(NSString *)empid
{
    UIColor *color = nil;
    int lastnumber = [[empid substringFromIndex:[empid length]-1] intValue];
    lastnumber = lastnumber %5;
    //    NSLog(@"%@,%@,%ld",empid,[empid substringFromIndex:[empid length]-1],lastnumber);
    switch (lastnumber) {
        case 0:
        {
            color = [UIColor colorFromHexRGB:@"ea6749"];
        }
            break;
        case 1:
        {
            color = [UIColor colorFromHexRGB:@"f6ba4a"];
        }
            break;
        case 2:
        {
            color = [UIColor colorFromHexRGB:@"0991e7"];
        }
            break;
        case 3:
        {
            color = [UIColor colorFromHexRGB:@"44b46a"];
        }
            break;
        case 4:
        {
            color = [UIColor colorFromHexRGB:@"5ad0e2"];
        }
            break;
            
        default:
            break;
    }
    //
    return color;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (NSMutableAttributedString*)changeColor:(NSString*)Allstr partStr:(NSString*)partStr color:(UIColor*)Color font:(NSInteger)Font
{
    
    NSMutableAttributedString *mAttStri = [[NSMutableAttributedString alloc] initWithString:Allstr];
    
    NSRange range = [Allstr rangeOfString:partStr];
    
    [mAttStri addAttribute:NSForegroundColorAttributeName value:Color range:range];
    
    [mAttStri addAttribute:NSFontAttributeName value:SystemFont(Font) range:range];
    
    return mAttStri;
}

+ (NSMutableAttributedString*)changeColor:(NSString*)Allstr partStr1:(NSString*)partStr1 partStr2:(NSString*)partStr2 color:(UIColor*)Color font:(NSInteger)Font
{
    
    NSMutableAttributedString *mAttStri = [[NSMutableAttributedString alloc] initWithString:Allstr];
    
    NSRange range1 = [Allstr rangeOfString:partStr1];
    
    [mAttStri addAttribute:NSForegroundColorAttributeName value:Color range:range1];
    
    [mAttStri addAttribute:NSFontAttributeName value:SystemFont(Font) range:range1];
    
    NSRange range2 = [Allstr rangeOfString:partStr2];
    
    [mAttStri addAttribute:NSForegroundColorAttributeName value:Color range:range2];
    
    [mAttStri addAttribute:NSFontAttributeName value:SystemFont(Font) range:range2];
    
    return mAttStri;
}

@end

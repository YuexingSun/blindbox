//
//  NSDate+WGExtension.m
//  WG_Common
//
//  Created by zhongzhifeng on 2021/4/30.
//

#import "NSDate+WGExtension.h"

@implementation NSDate (WGExtension)

/**
 *@desc 格式化为年月日 如2013.03.07 22:22
 *@return 格式化后的字符串
 */
+ (NSString *)wg_stringFormatForYearMonthDayHourMinuteDotWithTimestamp:(NSTimeInterval)timestamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(timestamp / 1000)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone systemTimeZone];
    formatter.dateFormat = @"yyyy.MM.dd HH:mm";
    return [formatter stringFromDate:date];
}

/// 判断该时间是否已经开始
/// @param currentTimestampStr 当前服务器时间
/// @param timeStr 需要比对的时间
+ (BOOL)wg_checkIsStartWithCurrentTimestampStr:(NSString *)currentTimestampStr
                                       timeStr:(NSString *)timeStr{
    
    if(!timeStr.length){
        return NO;
    }
    
    long long currentTimestamp = 0;
    if(currentTimestampStr && currentTimestampStr.length){
        currentTimestamp = [currentTimestampStr longLongValue];
    }else{
        NSDate *currentDate = [NSDate date];
        NSTimeInterval interval = [currentDate timeIntervalSince1970];
        currentTimestamp = interval * 1000;
    }
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *startDate = [formatter dateFromString:timeStr];
    long long startTimestamp = [startDate timeIntervalSince1970] * 1000;
    if(currentTimestamp - startTimestamp >= 0){
        return YES;
    }
    
    return NO;
}

/// 判断该时间是否已经结束
/// @param currentTimestampStr 当前服务器时间
/// @param timeStr 需要比对的时间
+ (BOOL)wg_checkIsEndWithCurrentTimestampStr:(NSString *)currentTimestampStr
                                     timeStr:(NSString *)timeStr{
    
    if(!timeStr.length){
        return NO;
    }
    long long currentTimestamp = 0;
    if(currentTimestampStr && currentTimestampStr.length){
        currentTimestamp = [currentTimestampStr longLongValue];
    }else{
        NSDate *currentDate = [NSDate date];
        NSTimeInterval interval = [currentDate timeIntervalSince1970];
        currentTimestamp = interval * 1000;
    }
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *endDate = [formatter dateFromString:timeStr];
    long long endTimestamp = [endDate timeIntervalSince1970] * 1000;
    if(currentTimestamp - endTimestamp > 0){
        return YES;
    }
    
    return NO;
}

/** 判断当天是不是在该时间区间内 */
+ (BOOL)wg_checkIsCurrentDayWithStartTimeStr:(NSString *)startTimeStr
                                  endTimeStr:(NSString *)endTimeStr{
    
    if(!startTimeStr.length || !endTimeStr.length){
        return NO;
    }
    
    NSDate *currentDate = [NSDate date];
    NSTimeInterval interval = [currentDate timeIntervalSince1970];
    long long currentTimestamp = interval * 1000 ;
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    NSDate *startDate = [formatter dateFromString:startTimeStr];
    long long startTimestamp = [startDate timeIntervalSince1970];
    
    NSDate *endDate = [formatter dateFromString:endTimeStr];
    long long endTimestamp = [endDate timeIntervalSince1970];

    if(currentTimestamp - startTimestamp >= 0 && endTimestamp - currentTimestamp > 0){
        return YES;
    }
    
    return NO;
}

+ (NSString *)getTimeStrFromTimestamp:(NSString *)string formatterStr:(NSString *)formatterStr{
    NSInteger time = [string integerValue] / 1000;
    NSDate * myDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter * formatter=[[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:formatterStr];
    NSString *timeStr=[formatter stringFromDate:myDate];
    return timeStr;
}


//用开始时间叠加期限天数
+ (NSString *)wg_resetTimeAddDayWithStartTime:(NSString *)startTime addDay:(NSInteger)addDay{
    
    if([startTime isKindOfClass:[NSNull class]] || startTime == nil || [[startTime stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0 || [startTime length] < 1) return @"";
    
    NSTimeInterval time = [startTime doubleValue] / 1000;
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:time];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponents = [calendar components: unitFlags fromDate:myDate];
    //计算当前月有多少天
    NSInteger curMonthNumber = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:myDate].length;
    NSInteger year = dateComponents.year;
    NSInteger month = dateComponents.month;
    NSInteger day = dateComponents.day;
    day += addDay;
    if(day > curMonthNumber){
        day -= curMonthNumber;
        if(month == 12){
            month = 1;
            year += 1;
        }else{
            month += 1;
        }
    }
    [dateComponents setYear:year];
    [dateComponents setMonth:month];
    [dateComponents setDay:day];
    
    NSString *timeStr = [NSString stringWithFormat:@"%ld.%02ld.%02ld %02ld:%02ld",dateComponents.year,(long)dateComponents.month,dateComponents.day,dateComponents.hour,dateComponents.minute];
    
    return timeStr;
}

+ (NSString *)wg_stringFormatForJustMonthDay:(NSTimeInterval)timestamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(timestamp / 1000)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone systemTimeZone];
    formatter.dateFormat = @"MM月dd日";
    return [formatter stringFromDate:date];
}

+ (NSTimeInterval)wg_stringFormatForJustHourMinute:(NSTimeInterval)timestamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(timestamp / 1000)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone systemTimeZone];
    formatter.dateFormat = @"HH:00";
    return [[formatter stringFromDate:date] integerValue];
}

+ (NSTimeInterval)wg_stringFormatForJustMinute:(NSTimeInterval)timestamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(timestamp / 1000)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone systemTimeZone];
    formatter.dateFormat = @"MM:00";
    return [[formatter stringFromDate:date] integerValue];
}


@end

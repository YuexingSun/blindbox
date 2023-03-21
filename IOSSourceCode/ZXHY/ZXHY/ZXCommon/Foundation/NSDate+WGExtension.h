//
//  NSDate+WGExtension.h
//  WG_Common
//
//  Created by zhongzhifeng on 2021/4/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (WGExtension)

/// 时间格式化为年月日 如2013.03.07 22:22
/// @param timestamp 需要格式化的时间
/// @return 格式化后的时间（2013.03.07 22:22）
+ (NSString *)wg_stringFormatForYearMonthDayHourMinuteDotWithTimestamp:(NSTimeInterval)timestamp;

/// 判断当天是不是在该时间区间内
/// @param startTimeStr 开始时间
/// @param endTimeStr 结束时间
/// @return 当天是不是在该时间区间内
+ (BOOL)wg_checkIsCurrentDayWithStartTimeStr:(NSString *)startTimeStr
                                  endTimeStr:(NSString *)endTimeStr;

/// 判断该时间是否已经开始
/// @param currentTimestampStr 当前服务器时间
/// @param timeStr 需要比对的时间
+ (BOOL)wg_checkIsStartWithCurrentTimestampStr:(nullable NSString *)currentTimestampStr
                                       timeStr:(NSString *)timeStr;

/// 判断该时间是否已经结束
/// @param currentTimestampStr 当前服务器时间
/// @param timeStr 需要比对的时间
+ (BOOL)wg_checkIsEndWithCurrentTimestampStr:(nullable NSString *)currentTimestampStr
                                     timeStr:(NSString *)timeStr;

/// 时间戳转时间字符串
/// @param string 字符串格式的时间戳
/// @param formatterStr 时间格式
/// @return 对应格式的时间
+ (NSString *)getTimeStrFromTimestamp:(NSString *)string
                      formatterStr:(NSString *)formatterStr;

/// 用开始时间叠加期限天数
/// @param startTime 开始时间
/// @param addDay 叠加期限天数
/// @return 计算后的时间
+ (NSString *)wg_resetTimeAddDayWithStartTime:(NSString *)startTime addDay:(NSInteger)addDay;

/// 只返回月份、日期
/// @param timestamp 时间戳
/// @return MM月dd日
+ (NSString *)wg_stringFormatForJustMonthDay:(NSTimeInterval)timestamp;

/// 只返回小时
/// @param timestamp 时间戳
/// @return 小时数
+ (NSTimeInterval)wg_stringFormatForJustHourMinute:(NSTimeInterval)timestamp;

/// 只返回分钟
/// @param timestamp 时间戳
/// @return 分钟数
+ (NSTimeInterval)wg_stringFormatForJustMinute:(NSTimeInterval)timestamp;
@end

NS_ASSUME_NONNULL_END

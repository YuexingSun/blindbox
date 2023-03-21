//
//  NSString+WGExtension.h
//  WG_Common
//
//  Created by zhongzhifeng on 2021/4/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NSString *WGLocalizedString(NSString *key);

NSString *WGLocalizedStringWithFormatStr(NSString *key, NSString *formatStr);

@interface NSString (WGExtension)

#pragma mark - Encode

/// 32位小写md5加密
- (NSString *)md5HashToLower32Bit;

/// 32位大写md5加密
- (NSString *)md5HashToUpper32Bit;

/// URL编码
- (NSString *)wg_stringURLUsingEncoding;

#pragma mark - WGCaConstant
+ (NSBundle *)wg_bundleLanguage;

+ (NSString *)wg_localizedStrForKey:(NSString *)key;

+ (NSString *)wg_localizedFormatStrForKey:(NSString *)key str1:(NSString *)str1;

+ (NSString *)wg_localizedFormatStrForKey:(NSString *)key str1:(NSString *)str1 str2:(NSString *)str2;

+ (NSString *)wg_getSeparatedPhoneNumberWithString:(NSString *)phoneString;

- (NSDictionary *)wg_dictionaryFromJSON;

/// 格式化小数点后最多显示一位，有0忽略0，没0展示最多一位
/// @param numFloat 待格式化小数
/// @return 字符串结果
+ (NSString *)wg_formatOneDecimalStrWithNumFloat:(CGFloat)numFloat;

/// 格式化小数点后最多显示两位，有0忽略0，没0展示最多两位非零数字
/// @param numFloat 待格式化小数
/// @return 字符串结果
+ (NSString *)wg_formatDecimalStrWithNumFloat:(CGFloat)numFloat;

/// 格式化小数点后始终显示一位，但是不四舍五入
/// @param numFloat 待格式化小数
/// @return 字符串结果
+ (NSString *)wg_formatNoRoundDecimalStrWithNumFloat:(CGFloat)numFloat;

/// 格式化小数点后最多显示两位，强制保留两位
/// @param numFloat 待格式化小数
/// @return 字符串结果
+ (NSString *)wg_formatDecimalStrForceKeepTwoWithNumFloat:(CGFloat)numFloat;

/// 格式化小数点后最多显示四位，强制保留四位
/// @param numFloat 待格式化小数
/// @return 字符串结果
+ (NSString *)wg_formatNoRoundDecimalStrForceKeepTwoWithNumFloat:(CGFloat)numFloat;

/// 去掉小数点后多余的0
/// @param numFloat 待格式化小数
/// @return 字符串结果
+ (NSString *)wg_removeFloatAllZeroWithNumFloat:(CGFloat)numFloat;

/// 处理后台返回数据转JSON丢失精度问题
/// @param string 待处理字符串
/// @return 字符串结果
+ (NSString *)wg_reviseString:(NSString *)string;

/// 判断是否纯数字
/// @return 判断结果
- (BOOL)wg_isNumberInteger;

/// 判断是否纯数字和英文
/// @return 判断结果
- (BOOL)wg_isNumberIntegerOrEnglish;

#pragma mark - WGCaNotifyConstant
- (void)wg_postNotificationOnMainThreadWithObject:(id)object userInfo:(NSDictionary *)userInfo;

- (void)wg_postNotificationOnMainThreadWithObject:(id)object userInfo:(NSDictionary *)userInfo afterNotificationBlock:(void(^)(void))afterNotificationBlock;

- (void)wg_postNotificationWithObject:(id)object userInfo:(NSDictionary *)userInfo;

- (void)wg_postNotificationWithObject:(id)object userInfo:(NSDictionary *)userInfo afterNotificationBlock:(void(^)(void))afterNotificationBlock;


#pragma mark - WGMeasure

/// jk的方法，考虑用自己的方法替换，不建议使用了
/// @param font 字体
/// @param width 宽度
/// @return 计算后的高度
- (CGFloat)wg_heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;

/// jk的方法，考虑用自己的方法替换，不建议使用了
/// @param font 字体
/// @param height 高度
/// @return 计算后的宽度
- (CGFloat)wg_widthWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height;

/// 计算字符串的宽度
/// @param font 字体
/// @param height 高度
/// @return 计算后的宽度
- (CGFloat)widthOfStringFont:(UIFont *)font height:(CGFloat)height;

/// 计算字符串文字的高
/// @param font 字体
/// @param width 宽度
/// @return 计算后的高度
- (CGFloat)heightOfStringFont:(UIFont *)font width:(CGFloat)width;

/// 计算字符串的size，可能不准，慎用
+ (CGSize)wg_sizeWithString:(NSString *)str andFont:(UIFont *)font andMaxSize:(CGSize)size;

/// 给选中字符串第一次出现的位置添加颜色和文字
/// @param hightLightText 选中的字符串
/// @param hightLightColor 选中的颜色
/// @param hightLightFont 选中的字体
/// @param normalColor 普通的颜色
/// @param normalFont 普通的字体
- (NSMutableAttributedString *)attributeTextWithHightLightText:(NSString *__nullable)hightLightText
                                               hightLightColor:(UIColor *__nullable)hightLightColor
                                                hightLightFont:(UIFont *__nullable)hightLightFont
                                                   normalColor:(UIColor *__nullable)normalColor
                                                    normalFont:(UIFont *__nullable)normalFont;

/// 字符串中间划线（适用于打折划线价）
/// @param color 颜色
/// @param font 字体
/// @return 结果
- (NSMutableAttributedString *)attributeTextAddUnderlineWithColor:(UIColor *)color font:(UIFont *)font;

#pragma mark - WidthHeight
- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;
- (CGFloat)widthForFont:(UIFont *)font;
- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width;

//判断是否全是空字符串
+ (BOOL)isAllEmptySting:(NSString *)str;

#pragma mark - WGRepresentation
+ (NSString *)wg_stringWithPrice:(double)price;

+ (NSString *)wg_arrayToJSONString:(NSArray *)arrayData;

+ (NSString *)wg_convertToJsonData:(NSDictionary *)dict;

///时间戳变为自定义格式时间
+ (NSString *)wg_timestampStrToTimeStr:(NSString *)timestampStr formatterStr:(NSString *)formatterStr;

///满折满减活动转 字符串
+ (NSString *)wg_handleDiscountRuleMapWithDiscountRuleMap:(NSDictionary *)discountRuleMap type:(NSInteger)type;

///满折满减活动转 字符串 styleStr: 间隔符号 discountRule 活动的拼接字符串
+ (NSString *)wg_handleDiscountRuleMapWithDiscountRule:(NSString *)discountRule type:(NSInteger)type styleStr:(NSString *)styleStr;

///满折满减活动转 字符串 styleStr: 间隔符号
+ (NSString *)wg_handleDiscountRuleMapWithDiscountRuleMap:(NSDictionary *)discountRuleMap type:(NSInteger)type styleStr:(NSString *)styleStr;

#pragma mark - 时间处理

/// 时间戳转成YYYY-MM-dd HH:mm格式，该字符串必须是精确到毫秒数时间戳
- (NSString *)wg_getTimeFromTimestamp;

#pragma mark - 富文本处理

+ (NSAttributedString *)wg_buildPriceAttributedStringWithPriceString:(NSString *)priceString deprecatedPriceString:(NSString *)deprecatedPriceString font:(UIFont *)font potFont:(UIFont *)potFont deprecatedFont:(UIFont *)deprecatedFont foregroundColor:(UIColor *)foregroundColor secondaryTextColor:(UIColor *)secondaryColor;

@end

NS_ASSUME_NONNULL_END

//
//  NSString+WGExtension.m
//  WG_Common
//
//  Created by zhongzhifeng on 2021/4/29.
//

#import "NSString+WGExtension.h"
#import <CommonCrypto/CommonDigest.h>
//#import "NSString+WGBusinessConstant.h"
#import "NSString+WGSafe.h"
#import "NSDictionary+WGSafe.h"

#define WGNotification [NSNotificationCenter defaultCenter]

#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"//数字和字母

static NSString *const WGConZhHans = @"zh-Hans";
static NSString *const WGConLproj = @"lproj";

NSString *WGLocalizedString(NSString *string)
{
    return [NSString wg_localizedStrForKey:string];
}

NSString *TKLocalizedStringWithFormatStr(NSString *key, NSString *formatStr)
{
    return [NSString wg_localizedFormatStrForKey:key str1:formatStr];
}



@implementation NSString (WGExtension)

#pragma mark - MD5
// 32位 小写
- (NSString *)md5HashToLower32Bit
{
    const char *input = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [digest appendFormat:@"%02x", result[i]];
    }
    
    return digest;
}

// 32位 大写
- (NSString *)md5HashToUpper32Bit
{
    const char *input = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [digest appendFormat:@"%02X", result[i]];
    }
    
    return digest;
}

- (NSString *)wg_stringURLUsingEncoding
{
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

#pragma mark - WGCaConstant

+ (NSString *)wg_currentLanguage {
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages firstObject];
    return [NSString stringWithString:currentLanguage];
}

+ (NSBundle *)wg_bundleLanguage
{
    NSString *path = [[NSBundle mainBundle] pathForResource:[self wg_currentLanguage] ofType:WGConLproj];
    if (!path)
    {
        path = [[NSBundle mainBundle] pathForResource:WGConZhHans ofType:WGConLproj];
    }
    
    return [NSBundle bundleWithPath:path];
}

+ (NSString *)wg_localizedStrForKey:(NSString *)key
{
    return NSLocalizedStringFromTableInBundle(key, nil, [self wg_bundleLanguage], nil);
}

+ (NSString *)wg_localizedFormatStrForKey:(NSString *)key str1:(NSString *)str1
{
    return [NSString localizedStringWithFormat:[self wg_localizedStrForKey:key], str1];
}

+ (NSString *)wg_localizedFormatStrForKey:(NSString *)key str1:(NSString *)str1 str2:(NSString *)str2
{
    return [NSString localizedStringWithFormat:[self wg_localizedStrForKey:key], str1, str2];
}


- (NSDictionary *)wg_dictionaryFromJSON
{
    return [self wg_dictionaryValue];
}

/**
 *  @brief  JSON字符串转成NSDictionary
 *
 *  @return NSDictionary
 */
-(NSDictionary *)wg_dictionaryValue{
    NSError *errorJson;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&errorJson];
    if (errorJson != nil) {
#ifdef DEBUG
        NSLog(@"fail to get dictioanry from JSON: %@, error: %@", self, errorJson);
#endif
    }
    return jsonDict;
}

+ (NSString *)wg_formatOneDecimalStrWithNumFloat:(CGFloat)numFloat{
    
    NSString *numberStr = [self wg_formatDecimalStrForceKeepOneWithNumFloat:numFloat];
    if (numberStr.length > 1)
    {
        if ([numberStr componentsSeparatedByString:@"."].count == 2)
        {
            NSString *last = [numberStr componentsSeparatedByString:@"."].lastObject;
            if ([last isEqualToString:@"0"])
            {
                numberStr = [numberStr componentsSeparatedByString:@"."].firstObject;
                return numberStr;
            }
        }
        return numberStr;
    }
    return nil;
}

+ (NSString *)wg_formatDecimalStrForceKeepOneWithNumFloat:(CGFloat)numFloat
{
    return [NSString stringWithFormat:@"%.1f", numFloat];;
}

+ (NSString *)wg_formatDecimalStrWithNumFloat:(CGFloat)numFloat
{
    NSString *numberStr = [self wg_formatDecimalStrForceKeepTwoWithNumFloat:numFloat];
    if (numberStr.length > 1)
    {
        if ([numberStr componentsSeparatedByString:@"."].count == 2)
        {
            NSString *last = [numberStr componentsSeparatedByString:@"."].lastObject;
            if ([last isEqualToString:@"00"])
            {
                numberStr = [numberStr wg_safeSubstringToIndex:numberStr.length - (last.length + 1)];
                return numberStr;
            }
            else
            {
                if ([[last wg_safeSubstringFromIndex:last.length - 1] isEqualToString:@"0"])
                {
                    numberStr = [numberStr wg_safeSubstringToIndex:numberStr.length - 1];
                    return numberStr;
                }
            }
        }
        return numberStr;
    }
    return nil;
}

+ (NSString *)wg_formatNoRoundDecimalStrWithNumFloat:(CGFloat)numFloat
{
    NSString *numberStr = [self wg_formatNoRoundDecimalStrForceKeepTwoWithNumFloat:numFloat];
    numberStr = [numberStr wg_safeSubstringToIndex:numberStr.length-3];
    
    return numberStr;
}

+ (NSString *)wg_formatDecimalStrForceKeepTwoWithNumFloat:(CGFloat)numFloat
{
    return [NSString stringWithFormat:@"%.2f", numFloat];;
}

+ (NSString *)wg_formatNoRoundDecimalStrForceKeepTwoWithNumFloat:(CGFloat)numFloat
{
    return [NSString stringWithFormat:@"%.4f", numFloat];
}

+ (NSString *)wg_removeFloatAllZeroWithNumFloat:(CGFloat)numFloat
{
    NSString * outNumber = [NSString stringWithFormat:@"%@", @(numFloat)];
    
    //价格格式化显示
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    NSString *formatterString = [formatter stringFromNumber:[NSNumber numberWithFloat:[outNumber doubleValue]]];
    
    //现获取要截取的字符串位置
    NSRange range = [formatterString rangeOfString:@"."];
    if (range.length > 0)
    {
        //截取字符串
        NSString * result = [formatterString wg_safeSubstringFromIndex:range.location];
        if (result.length >= 4)
        {
            formatterString = [formatterString wg_safeSubstringToIndex:formatterString.length - 1];
        }
    }
    return formatterString;
}

+ (NSString *)wg_reviseString:(NSString *)string{
    //直接传入精度丢失有问题的Double类型
    double conversionValue = [string doubleValue];
    NSString *doubleString = [NSString stringWithFormat:@"%lf", conversionValue];
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}

- (BOOL)wg_isNumberInteger
{
    NSScanner *scanner = [NSScanner scannerWithString:self];
    NSInteger val;
    return [scanner scanInteger:&val] && [scanner isAtEnd];
}

+ (NSString *)wg_getSeparatedPhoneNumberWithString:(NSString *)phoneString {
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSString * string = phoneString;
    //invertedSet方法是去反字符,把所有的除了characterSet里的字符都找出来(包含去空格功能)
    NSCharacterSet *specCharacterSet = [characterSet invertedSet];
    NSArray * strArr = [string componentsSeparatedByCharactersInSet:specCharacterSet];
    return [strArr componentsJoinedByString:@""];
}


- (BOOL)wg_isNumberIntegerOrEnglish
{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
    NSString *filtered = [[self componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [self isEqualToString:filtered];
}

#pragma mark - WGCaNotifyConstant
- (void)wg_postNotificationOnMainThreadWithObject:(id)object userInfo:(NSDictionary *)userInfo
{
    [self wg_postNotificationOnMainThreadWithObject:object userInfo:userInfo afterNotificationBlock:NULL];
}

- (void)wg_postNotificationOnMainThreadWithObject:(id)object userInfo:(NSDictionary *)userInfo afterNotificationBlock:(void(^)(void))afterNotificationBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [WGNotification postNotificationName:self object:object userInfo:userInfo];
        if (afterNotificationBlock)
        {
            afterNotificationBlock();
        }
    });
}

- (void)wg_postNotificationWithObject:(id)object userInfo:(NSDictionary *)userInfo
{
    [self wg_postNotificationWithObject:object userInfo:userInfo afterNotificationBlock:NULL];
}

- (void)wg_postNotificationWithObject:(id)object userInfo:(NSDictionary *)userInfo afterNotificationBlock:(void(^)(void))afterNotificationBlock
{
    [WGNotification postNotificationName:self object:object userInfo:userInfo];
    if (afterNotificationBlock)
    {
        afterNotificationBlock();
    }
}


#pragma mark - WGMeasure
/**
 *  @brief 计算文字的高度
 *
 *  @param font  字体(默认为系统字体)
 *  @param width 约束宽度
 */
- (CGFloat)wg_heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width
{
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGSize textSize;
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                 NSParagraphStyleAttributeName: paragraph};
    textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                  options:(NSStringDrawingUsesLineFragmentOrigin |
                                           NSStringDrawingTruncatesLastVisibleLine)
                               attributes:attributes
                                  context:nil].size;
    
    return ceil(textSize.height);
}

/**
 *  @brief 计算文字的宽度
 *
 *  @param font   字体(默认为系统字体)
 *  @param height 约束高度
 */
- (CGFloat)wg_widthWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height
{
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGSize textSize;
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                 NSParagraphStyleAttributeName: paragraph};
    textSize = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                  options:(NSStringDrawingUsesLineFragmentOrigin |
                                           NSStringDrawingTruncatesLastVisibleLine)
                               attributes:attributes
                                  context:nil].size;
    
    return ceil(textSize.width);
}


//字符串文字的宽
- (CGFloat)widthOfStringFont:(UIFont *)font height:(CGFloat)height{
    
    CGRect bounds;
    NSDictionary * parameterDict=[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    bounds = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:parameterDict context:nil];
    return bounds.size.width;
}
//字符串文字的高
- (CGFloat)heightOfStringFont:(UIFont *)font width:(CGFloat)width{
    
    CGRect bounds;
    NSDictionary * parameterDict=[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    bounds = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:parameterDict context:nil];
    return bounds.size.height;
}

+ (CGSize)wg_sizeWithString:(NSString *)str andFont:(UIFont *)font andMaxSize:(CGSize)size
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

//富文本
- (NSMutableAttributedString *)attributeTextWithFirstColor:(UIColor *)fColor
                                                 nextColor:(UIColor *)nColor
                                               divideIndex:(NSInteger)index{
  
  NSDictionary *attributeDict1 = [NSDictionary dictionaryWithObjectsAndKeys:fColor, NSForegroundColorAttributeName,nil];
  NSDictionary *attributeDict2 = [NSDictionary dictionaryWithObjectsAndKeys:nColor, NSForegroundColorAttributeName,nil];
  NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithString:self];
  [contentStr setAttributes:attributeDict1 range:NSMakeRange(0, index)];
  [contentStr setAttributes:attributeDict2 range:NSMakeRange(index, contentStr.length-index)];
  return contentStr;
}

//富文本[全]
- (NSMutableAttributedString *)attributeTextWithFirstColor:(UIColor *)fColor
                                                 nextColor:(UIColor *)nColor
                                                 firstFont:(UIFont *)firstFont
                                                  nextFont:(UIFont *)nextFont
                                               divideIndex:(NSInteger)index{
  
  NSDictionary *attributeDict1 = [NSDictionary dictionaryWithObjectsAndKeys:fColor, NSForegroundColorAttributeName,firstFont,NSFontAttributeName,nil];
  NSDictionary *attributeDict2 = [NSDictionary dictionaryWithObjectsAndKeys:nColor, NSForegroundColorAttributeName,nextFont,NSFontAttributeName,nil];
  NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithString:self];
  [contentStr setAttributes:attributeDict1 range:NSMakeRange(0, index)];
  [contentStr setAttributes:attributeDict2 range:NSMakeRange(index, contentStr.length-index)];
  return contentStr;
}

- (NSMutableAttributedString *)attributeTextWithHightLightText:(NSString *__nullable)hightLightText
                                               hightLightColor:(UIColor *__nullable)hightLightColor
                                                hightLightFont:(UIFont *__nullable)hightLightFont
                                                   normalColor:(UIColor *__nullable)normalColor
                                                    normalFont:(UIFont *__nullable)normalFont
{
    NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableDictionary *normalDict = [NSMutableDictionary dictionary];
    if (normalColor) {
        [normalDict setValue:normalColor forKey:NSForegroundColorAttributeName];
    }
    if (normalFont) {
        [normalDict setValue:normalFont forKey:NSFontAttributeName];
    }
    [contentStr setAttributes:normalDict range:NSMakeRange(0, self.length)];
    
    if ([hightLightText isKindOfClass:[NSString class]] && hightLightText.length && hightLightText.length <= self.length) {
        NSMutableDictionary *hightDict = [NSMutableDictionary dictionary];
        if (hightLightColor) {
            [hightDict setValue:hightLightColor forKey:NSForegroundColorAttributeName];
        }
        if (hightLightFont) {
            [hightDict setValue:hightLightFont forKey:NSFontAttributeName];
        }
        
        [contentStr setAttributes:hightDict range:[self rangeOfString:hightLightText]];
    }
    
    return contentStr;
}

- (NSMutableAttributedString *)attributeTextAddUnderlineWithColor:(UIColor *)color
                                                             font:(UIFont *)font{
    
    if(!self || !self.length) return nil;
    NSDictionary *attributeDict1 = [NSDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName,font,NSFontAttributeName,nil];
    NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithString:self];
    [contentStr setAttributes:attributeDict1 range:NSMakeRange(0, contentStr.length)];
    [contentStr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, contentStr.length)];

    return contentStr;
}

#pragma mark - WidthHeight
- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode {
    CGSize result;
    if (!font) font = [UIFont systemFontOfSize:12];
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableDictionary *attr = [NSMutableDictionary new];
        attr[NSFontAttributeName] = font;
        if (lineBreakMode != NSLineBreakByWordWrapping) {
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineBreakMode = lineBreakMode;
            attr[NSParagraphStyleAttributeName] = paragraphStyle;
        }
        CGRect rect = [self boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:attr context:nil];
        result = rect.size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        result = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
    return result;
}

- (CGFloat)widthForFont:(UIFont *)font {
    CGSize size = [self sizeForFont:font size:CGSizeMake(HUGE, HUGE) mode:NSLineBreakByWordWrapping];
    return size.width;
}

- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width {
    CGSize size = [self sizeForFont:font size:CGSizeMake(width, HUGE) mode:NSLineBreakByWordWrapping];
    return size.height;
}

//判断是否全是空字符串
+ (BOOL)isAllEmptySting:(NSString *)str{
    if (!str) {
        return YES;
    }else{
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        if (trimedString.length == 0) {
            return YES;
        }else{
            return NO;
        }
    }
}

#pragma mark - WGRepresentation

+ (NSString *)wg_stringWithPrice:(double)price {
    // 去除末尾的0
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterNoStyle];
    formatter.maximumFractionDigits = 3;
    formatter.minimumIntegerDigits = 1;
    NSString *priceStr = [formatter stringFromNumber:[NSNumber numberWithDouble:price]];
    NSArray *priceArr = [priceStr componentsSeparatedByString:@"."];
    if (priceArr.count>1 && [priceArr[1] intValue]>0) {
        NSInteger priceLength = [(NSString *)priceArr[1] length];
        priceStr = [NSString stringWithFormat:@"%@.%@",priceArr[0], [priceArr[1] wg_safeSubstringWithRange:NSMakeRange(0, priceLength>2?2:priceLength)]];
    } else {
        priceStr = [NSString stringWithFormat:@"%@",priceArr[0]];
    }
    return [@"¥" stringByAppendingString:[priceStr length] > 0 ? [NSString stringWithFormat:@"%@ ",priceStr] : @"0"];
}

+ (NSString *)wg_arrayToJSONString:(NSArray *)arrayData{
    NSData *data = [NSJSONSerialization dataWithJSONObject:arrayData
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    if (data == nil) {
        return nil;
    }
    NSString *string = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
    return string;
}


+ (NSString *)wg_convertToJsonData:(NSDictionary *)dict{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
//        WGLog(@"%@",error);
    } else {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];

    return mutStr;
}

//时间戳变为自定义格式时间yyyy-MM-dd HH:mm
+ (NSString *)wg_timestampStrToTimeStr:(NSString *)timestampStr formatterStr:(NSString *)formatterStr{
    
    long long time = [timestampStr longLongValue];
    //    如果服务器返回的是15位字符串，需要除以1000，否则显示不正确(13位其实代表的是毫秒，需要除以1000)
    if(timestampStr.length >= 13){
        time = [timestampStr longLongValue] / 1000;
    }
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:formatterStr];
    NSString*timeString = [formatter stringFromDate:date];
    return timeString;
}

+ (NSString *)wg_handleDiscountRuleMapWithDiscountRule:(NSString *)discountRule type:(NSInteger)type styleStr:(NSString *)styleStr{
    NSArray *array = [discountRule componentsSeparatedByString:@","];//分隔符逗号
    NSString * tagStr = @"";
    if (type == 1) {//满元减
        for (int i = 0 ;i < array.count;i++) {
            NSString *str = array[i];
            NSRange range = [str wg_safeRangeOfString:@":"];//匹配得到的下标
            NSString *key = [str wg_safeSubstringWithRange:NSMakeRange(0, range.location)];//截取范围内的字符串
            NSString *value = [str wg_safeSubstringWithRange:NSMakeRange(range.location + 1, str.length - (range.location + 1))];//截取范围内的字符串
            value = [NSString wg_formatDecimalStrWithNumFloat:value.floatValue];
            key =   [NSString wg_formatDecimalStrWithNumFloat:key.floatValue];
            
            if (i == array.count - 1) {
                tagStr = [tagStr stringByAppendingString:[NSString stringWithFormat:@"满%@元减%@元",key,value]];
            }else{
                tagStr = [tagStr stringByAppendingString:[NSString stringWithFormat:@"满%@元减%@元%@",key,value,styleStr]];
            }
        }
    }else if (type == 2){
        for (int i = 0 ;i < array.count;i++) {
            NSString *str = array[i];
            NSRange range = [str wg_safeRangeOfString:@":"];//匹配得到的下标
            NSString *key = [str wg_safeSubstringWithRange:NSMakeRange(0, range.location)];//截取范围内的字符串
            NSString *value = [str wg_safeSubstringWithRange:NSMakeRange(range.location + 1, str.length - (range.location + 1))];//截取范围内的字符串
            value = [NSString wg_formatDecimalStrWithNumFloat:value.floatValue];
            key =   [NSString wg_formatDecimalStrWithNumFloat:key.floatValue];
            if (i == array.count - 1) {
                tagStr = [tagStr stringByAppendingString:[NSString stringWithFormat:@"满%@件减%@元",key,value]];
            }else{
                tagStr = [tagStr stringByAppendingString:[NSString stringWithFormat:@"满%@件减%@元%@",key,value,styleStr]];
            }
        }
    }else if (type == 3){
        for (int i = 0 ;i < array.count;i++) {
            NSString *str = array[i];
            NSRange range = [str wg_safeRangeOfString:@":"];//匹配得到的下标
            NSString *key = [str wg_safeSubstringWithRange:NSMakeRange(0, range.location)];//截取范围内的字符串
            NSString *value = [str wg_safeSubstringWithRange:NSMakeRange(range.location + 1, str.length - (range.location + 1))];//截取范围内的字符串
            value = [NSString wg_formatOneDecimalStrWithNumFloat:value.floatValue];
            key =   [NSString wg_formatDecimalStrWithNumFloat:key.floatValue];
            if (i == array.count - 1) {
                tagStr = [tagStr stringByAppendingString:[NSString stringWithFormat:@"满%@元打%@折",key,value]];
            }else{
                tagStr = [tagStr stringByAppendingString:[NSString stringWithFormat:@"满%@元打%@折%@",key,value,styleStr]];
            }
        }
    }else if (type == 4){
        for (int i = 0 ;i < array.count;i++) {
            NSString *str = array[i];
            NSRange range = [str wg_safeRangeOfString:@":"];//匹配得到的下标
            NSString *key = [str wg_safeSubstringWithRange:NSMakeRange(0, range.location)];//截取范围内的字符串
            NSString *value = [str wg_safeSubstringWithRange:NSMakeRange(range.location + 1, str.length - (range.location + 1))];//截取范围内的字符串
            value = [NSString wg_formatOneDecimalStrWithNumFloat:value.floatValue];
            key =   [NSString wg_formatDecimalStrWithNumFloat:key.floatValue];
            if ( i == array.count - 1) {
                tagStr = [tagStr stringByAppendingString:[NSString stringWithFormat:@"满%@件打%@折",key,value]];
            }else{
                tagStr = [tagStr stringByAppendingString:[NSString stringWithFormat:@"满%@件打%@折%@",key,value,styleStr]];
            }
        }
    }
    return tagStr;

}

+ (NSString *)wg_handleDiscountRuleMapWithDiscountRuleMap:(NSDictionary *)discountRuleMap type:(NSInteger)type styleStr:(NSString *)styleStr{
    
    NSString * tagStr = @"";
    NSArray *keys = discountRuleMap.allKeys;
    keys = [self sortedArrayWithArray:keys rise:YES];
    if (discountRuleMap) {
        if (type == 1) {//满元减
            for (int i = 0 ;i < keys.count;i++) {
                NSString *key = keys[i];
                NSString *value = [NSString wg_formatDecimalStrWithNumFloat:[[discountRuleMap wg_safeObjectForKey:key] floatValue]];
                key = [NSString wg_formatDecimalStrWithNumFloat:key.floatValue];
                if (i == keys.count - 1) {
                    tagStr = [tagStr stringByAppendingString:[NSString stringWithFormat:@"满%@元减%@元",key,value]];
                }else{
                    tagStr = [tagStr stringByAppendingString:[NSString stringWithFormat:@"满%@元减%@元%@",key,value,styleStr]];
                }
            }
        }else if (type == 2){//满件减
            for (int i = 0 ;i < discountRuleMap.allKeys.count;i++) {
                NSString *key = keys[i];
                NSString *value = [NSString wg_formatDecimalStrWithNumFloat:[[discountRuleMap wg_safeObjectForKey:key] floatValue]];
                key = [NSString wg_formatDecimalStrWithNumFloat:key.floatValue];
                if (i == keys.count - 1) {
                    tagStr = [tagStr stringByAppendingString:[NSString stringWithFormat:@"满%@件减%@元",key,value]];
                }else{
                    tagStr = [tagStr stringByAppendingString:[NSString stringWithFormat:@"满%@件减%@元%@",key,value,styleStr]];
                }
            }
        }else if (type == 3){//满元折
            for (int i = 0 ;i < discountRuleMap.allKeys.count;i++) {
                NSString *key = keys[i];
                NSString *value = [NSString wg_formatOneDecimalStrWithNumFloat:[[discountRuleMap wg_safeObjectForKey:key] floatValue] *10];
                key = [NSString wg_formatDecimalStrWithNumFloat:key.floatValue];
                
                if (i == keys.count - 1) {
                    tagStr = [tagStr stringByAppendingString:[NSString stringWithFormat:@"满%@元打%@折",key,value]];
                }else{
                    tagStr = [tagStr stringByAppendingString:[NSString stringWithFormat:@"满%@元打%@折%@",key,value,styleStr]];
                }
            }
        }else if (type == 4){//满件折
            for (int i = 0 ;i < discountRuleMap.allKeys.count;i++) {
                NSString *key = keys[i];
                NSString *value = [NSString wg_formatOneDecimalStrWithNumFloat:[[discountRuleMap wg_safeObjectForKey:key] floatValue] *10];
                key = [NSString wg_formatDecimalStrWithNumFloat:key.floatValue];
                if ( i == keys.count - 1) {
                    tagStr = [tagStr stringByAppendingString:[NSString stringWithFormat:@"满%@件打%@折",key,value]];
                }else{
                    tagStr = [tagStr stringByAppendingString:[NSString stringWithFormat:@"满%@件打%@折%@",key,value,styleStr]];
                }
            }
        }
    }
    return tagStr;
}

+ (NSString *)wg_handleDiscountRuleMapWithDiscountRuleMap:(NSDictionary *)discountRuleMap type:(NSInteger)type{
    return [self wg_handleDiscountRuleMapWithDiscountRuleMap:discountRuleMap type:type styleStr:@"；"];
}

+ (NSArray *)sortedArrayWithArray:(NSArray *)array rise:(BOOL)rise{
    NSArray *result;
    if (rise) {//升序
        result = [array sortedArrayUsingComparator:^(NSString * obj1, NSString * obj2){
            return (NSComparisonResult)[obj1 compare:obj2 options:NSNumericSearch];
        }];
    }else{//降序
        result = [array sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
        return [obj2 compare:obj1];
        }];
    }
    return result;
}

#pragma mark - 时间拓展

- (NSString *)wg_getTimeFromTimestamp
{
    NSInteger time = [self integerValue] / 1000;
    NSDate * myDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSString *timeStr=[formatter stringFromDate:myDate];
    return timeStr;
}

#pragma mark - 富文本

+ (NSAttributedString *)wg_buildPriceAttributedStringWithPriceString:(NSString *)priceString deprecatedPriceString:(NSString *)deprecatedPriceString font:(UIFont *)font potFont:(UIFont *)potFont deprecatedFont:(UIFont *)deprecatedFont foregroundColor:(UIColor *)foregroundColor secondaryTextColor:(UIColor *)secondaryColor
{
    UIFont *integerFont = font;
    UIFont *fractionFont = deprecatedFont;
    NSMutableAttributedString *finalAttrStr = [[NSMutableAttributedString alloc] init];
    
    //Price portion
    NSMutableAttributedString *priceAttrStr = [[NSMutableAttributedString alloc] initWithString:priceString attributes:@{NSForegroundColorAttributeName:foregroundColor}];
    [priceAttrStr addAttributes:@{NSFontAttributeName:fractionFont} range:NSMakeRange(0, 1)];
    [priceAttrStr addAttributes:@{NSFontAttributeName:integerFont} range:NSMakeRange(0, priceAttrStr.length - 1)];
    if ([priceString containsString:@"折"]) {
        NSRange range = [priceString wg_safeRangeOfString:@"折"];
        [priceAttrStr addAttributes:@{NSFontAttributeName:potFont} range:NSMakeRange(range.location,priceString.length - range.location)];
    }else if ([priceString containsString:@"."]) {
        NSRange range = [priceString wg_safeRangeOfString:@"."];
        [priceAttrStr addAttributes:@{NSFontAttributeName:potFont} range:NSMakeRange(range.location,priceString.length - range.location)];
    }
    [finalAttrStr appendAttributedString:priceAttrStr];
    
    //Deprecated price portion
    if (deprecatedPriceString != nil) { [finalAttrStr appendAttributedString:[[NSAttributedString alloc] initWithString:[@" " stringByAppendingString:deprecatedPriceString] attributes:@{NSForegroundColorAttributeName:secondaryColor, NSFontAttributeName:fractionFont, NSStrikethroughStyleAttributeName:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle)}]]; }
    return finalAttrStr;
}

@end

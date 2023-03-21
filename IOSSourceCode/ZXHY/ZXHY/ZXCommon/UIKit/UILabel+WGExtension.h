//
//  UILabel+ZHLabel.h
//  BaseProject
//
//  Created by 张浩 on 2020/10/24.
//  获取label宽度和高度自适应

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (WGExtension)

/// 生成一个不带约束的UILabel
+ (instancetype)wg_autolayoutLabelWithFont:(UIFont*)font textColor:(UIColor*)textColor numberOfLines:(NSInteger)numberOfLines textAlignment:(NSTextAlignment)textAlignment;

/// 生成一个不带约束的UILabel
+ (instancetype)wg_autolayoutLabelWithFont:(UIFont*)font textColor:(UIColor*)textColor textAlignment:(NSTextAlignment)textAlignment;

/**
 UILabel

 @param font 大小
 @param textAlignment textAlignment
 @param textColor textColor
 @param textStr 初始textStr
 @param numberOfLines numberOfLines
 @return UILabel
 */
+ (UILabel *)labelWithFont:(UIFont *)font TextAlignment:(NSTextAlignment)textAlignment TextColor:(UIColor *)textColor TextStr:(NSString *)textStr NumberOfLines:(NSInteger)numberOfLines;

@property (assign, nonatomic) UIEdgeInsets wg_edgeInsets;

#pragma mark - Chain

- (UILabel *(^)(CGFloat x))wg_x;
- (UILabel *(^)(CGFloat y))wg_y;
- (UILabel *(^)(CGFloat maxX))wg_maxX;
- (UILabel *(^)(CGFloat maxY))wg_maxY;
- (UILabel *(^)(CGFloat width))wg_width;
- (UILabel *(^)(CGFloat height))wg_height;
- (UILabel *(^)(UIColor *backgroundColor))wg_backgroundColor;
- (UILabel *(^)(CGRect frame))wg_frame;
- (UILabel * (^)(CGFloat centerX))wg_centerX;
- (UILabel * (^)(CGFloat centerY))wg_centerY;
- (UILabel * (^)(CGFloat radius))wg_cornerRaduis;
- (UILabel * (^)(UIColor *borderColor))wg_borderColor;

- (UILabel *(^)(UIColor *textColor))wg_textColor;
- (UILabel *(^)(NSString *text))wg_text;
- (UILabel *(^)(NSAttributedString *text))wg_attrText;
- (UILabel *(^)(NSInteger fontSize,UIFontWeight weight))wg_font;
- (UILabel *(^)(NSInteger fontSize))wg_fontSize;
- (UILabel *)wg_unlimitedLine;
- (UILabel *(^)(NSInteger number))wg_numberOfLine;
- (UILabel *(^)(NSTextAlignment alignment))wg_textAlignment;

/// 使用iconfont作为图标，在这种情况下不要使用wg_font，iconName参照 https://weeget-iconfont-ios.github.io/ ，如果是&#xe677;,则传入\U0000e677
- (UILabel *(^)(NSString *iconName,CGFloat iconSize))wg_iconFont;


/// 拼接版本的iconFont生成label，使用这个可以自动拼接上\U0000，
#define wg_icon(name,fontSize) wg_iconFont(@WGICONTOSTRING(\U0000##name),fontSize)
#define WGICONTOSTRING(x) #x

@end

NS_ASSUME_NONNULL_END


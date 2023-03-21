//
//  UILabel+ZHLabel.m
//  BaseProject
//
//  Created by 张浩 on 2020/10/24.
//

#import "UILabel+WGExtension.h"
#import <objc/runtime.h>

static char kAutomaticWritingEdgeInsetsKey;

@implementation UILabel (WGExtension)

+ (instancetype)wg_autolayoutLabelWithFont:(UIFont*)font textColor:(UIColor*)textColor numberOfLines:(NSInteger)numberOfLines textAlignment:(NSTextAlignment)textAlignment {
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.font = font;
    label.textColor = textColor;
    label.numberOfLines = numberOfLines;
    label.textAlignment = textAlignment;
    return label;
}

+ (instancetype)wg_autolayoutLabelWithFont:(UIFont*)font textColor:(UIColor*)textColor textAlignment:(NSTextAlignment)textAlignment {
    return [UILabel wg_autolayoutLabelWithFont:font textColor:textColor numberOfLines:1 textAlignment:textAlignment];
}

- (void)setWg_edgeInsets:(UIEdgeInsets)wg_edgeInsets
{
    objc_setAssociatedObject(self, &kAutomaticWritingEdgeInsetsKey, [NSValue valueWithUIEdgeInsets:wg_edgeInsets], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)wg_edgeInsets
{
    NSValue *edgeInsetsValue = objc_getAssociatedObject(self, &kAutomaticWritingEdgeInsetsKey);
    
    if (edgeInsetsValue)
    {
        return edgeInsetsValue.UIEdgeInsetsValue;
    }
    
    edgeInsetsValue = [NSValue valueWithUIEdgeInsets:UIEdgeInsetsZero];
    
    objc_setAssociatedObject(self, &kAutomaticWritingEdgeInsetsKey, edgeInsetsValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return edgeInsetsValue.UIEdgeInsetsValue;
}


+ (UILabel *)labelWithFont:(UIFont *)font TextAlignment:(NSTextAlignment)textAlignment TextColor:(UIColor *)textColor TextStr:(NSString *)textStr NumberOfLines:(NSInteger)numberOfLines
{
    UILabel *label = [UILabel new];
    label.font = font;
    label.textAlignment = textAlignment;
    label.textColor = textColor;
    label.text = textStr;
    label.numberOfLines = numberOfLines;
    return label;
}

#pragma mark - Chain

- (UILabel *)wg_unlimitedLine
{
    self.numberOfLines = 0;
    return self;
}

- (UILabel *(^)(NSInteger number))wg_numberOfLine
{
    return ^UILabel *(NSInteger number){
        self.numberOfLines = number;
        return self;
    };
}

- (UILabel *(^)(UIColor *textColor))wg_textColor
{
    return ^UILabel *(UIColor *textColor){
        self.textColor = textColor;
        return self;
    };
}

- (UILabel *(^)(NSTextAlignment alignment))wg_textAlignment
{
    return ^UILabel *(NSTextAlignment alignment){
        self.textAlignment = alignment;
        return self;
    };
}

- (UILabel *(^)(NSString *text))wg_text
{
    return ^UILabel *(NSString *text){
        self.text = text;
        return self;
    };
}

- (UILabel *(^)(NSAttributedString *))wg_attrText
{
    return ^UILabel *(NSAttributedString *text){
        self.attributedText = text;
        return self;
    };
}

- (UILabel *(^)(NSInteger, UIFontWeight))wg_font
{
    return ^UILabel *(NSInteger fontSize,UIFontWeight weight){
        self.font = [UIFont systemFontOfSize:fontSize weight:weight];
        return self;
    };
}

- (UILabel *(^)(NSInteger))wg_fontSize
{
    return ^UILabel *(NSInteger fontSize){
        self.font = [UIFont systemFontOfSize:fontSize];
        return self;
    };
}

- (UILabel *(^)(NSString *,CGFloat))wg_iconFont {
    return ^UILabel *(NSString *name,CGFloat fontSize) {
        self.font = [UIFont fontWithName:@"iconfont" size:fontSize];
        self.text = name;
        return self;
    };
}


@end

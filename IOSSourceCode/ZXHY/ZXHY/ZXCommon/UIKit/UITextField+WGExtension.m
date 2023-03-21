//
//  UITextField+WGExtension.m
//  WG_Common
//
//  Created by apple on 2021/4/30.
//

#import "UITextField+WGExtension.h"
#import <objc/runtime.h>

static const void *WGTextFieldInputLimitMaxLength = &WGTextFieldInputLimitMaxLength;

@implementation UITextField (WGExtension)

- (NSInteger)wg_maxLength {
    return [objc_getAssociatedObject(self, WGTextFieldInputLimitMaxLength) integerValue];
}
- (void)setWg_maxLength:(NSInteger)maxLength {
    objc_setAssociatedObject(self, WGTextFieldInputLimitMaxLength, @(maxLength), OBJC_ASSOCIATION_ASSIGN);
    [self addTarget:self action:@selector(wg_textFieldTextDidChange) forControlEvents:UIControlEventEditingChanged];
}
- (void)wg_textFieldTextDidChange {
    NSString *toBeString = self.text;
    //获取高亮部分
    UITextRange *selectedRange = [self markedTextRange];
    UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
    
    //没有高亮选择的字，则对已输入的文字进行字数统计和限制
    //在iOS7下,position对象总是不为nil
    if ( (!position ||!selectedRange) && (self.wg_maxLength > 0 && toBeString.length > self.wg_maxLength))
    {
        NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:self.wg_maxLength];
        if (rangeIndex.length == 1)
        {
            self.text = [toBeString substringToIndex:self.wg_maxLength];
        }
        else
        {
            NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.wg_maxLength)];
            NSInteger tmpLength;
            if (rangeRange.length > self.wg_maxLength) {
                tmpLength = rangeRange.length - rangeIndex.length;
            }else{
                tmpLength = rangeRange.length;
            }
            self.text = [toBeString substringWithRange:NSMakeRange(0, tmpLength)];
        }
    }
}

@end

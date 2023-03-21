//
//  UITextView+WGExtension.m
//  Bravat
//
//  Created by 廖其进 on 2020/6/8.
//  Copyright © 2020 com.xf.wind. All rights reserved.
//

#import <objc/runtime.h>
#import "UITextView+WGExtension.h"

static const void *WGTextViewInputLimitMaxLength = &WGTextViewInputLimitMaxLength;

@implementation UITextView (WGExtension)

#pragma mark - Swizzle Dealloc

+ (void)load {
    // is this the best solution?
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc")),
                                   class_getInstanceMethod(self.class, @selector(swizzledDealloc)));
}

- (void)swizzledDealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    UITextView *textView = objc_getAssociatedObject(self, @selector(placeholderTextView));
    if (textView) {
        for (NSString *key in self.class.observingKeys) {
            @try {
                [self removeObserver:self forKeyPath:key];
            }
            @catch (NSException *exception) {
                // Do nothing
            }
        }
    }
    [self swizzledDealloc];
}


#pragma mark - Class Methods
#pragma mark `defaultPlaceholderColor`

+ (UIColor *)defaultPlaceholderColor {
    if (@available(iOS 13, *)) {
        SEL selector = NSSelectorFromString(@"placeholderTextColor");
        if ([UIColor respondsToSelector:selector]) {
            return [UIColor performSelector:selector];
        }
    }
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UITextField *textField = [[UITextField alloc] init];
        textField.placeholder = @" ";
        NSDictionary *attributes = [textField.attributedPlaceholder attributesAtIndex:0 effectiveRange:nil];
        color = attributes[NSForegroundColorAttributeName];
        if (!color) {
            color = [UIColor colorWithRed:0 green:0 blue:0.0980392 alpha:0.22];
        }
    });
    return color;
}


#pragma mark - `observingKeys`

+ (NSArray *)observingKeys {
    return @[@"attributedText",
             @"bounds",
             @"font",
             @"frame",
             @"text",
             @"textAlignment",
             @"textContainerInset",
             @"textContainer.lineFragmentPadding",
             @"textContainer.exclusionPaths"];
}


#pragma mark - Properties
#pragma mark `placeholderTextView`

- (UITextView *)placeholderTextView {
    UITextView *textView = objc_getAssociatedObject(self, @selector(placeholderTextView));
    if (!textView) {
        NSAttributedString *originalText = self.attributedText;
        self.text = @" "; // lazily set font of `UITextView`.
        self.attributedText = originalText;
        
        textView = [[UITextView alloc] init];
        textView.backgroundColor = [UIColor clearColor];
        textView.textColor = [self.class defaultPlaceholderColor];
        textView.userInteractionEnabled = NO;
        textView.isAccessibilityElement = NO;
        objc_setAssociatedObject(self, @selector(placeholderTextView), textView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        self.needsUpdateFont = YES;
        [self updatePlaceholderTextView];
        self.needsUpdateFont = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updatePlaceholderTextView)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:self];
        
        for (NSString *key in self.class.observingKeys) {
            [self addObserver:self forKeyPath:key options:NSKeyValueObservingOptionNew context:nil];
        }
    }
    return textView;
}


#pragma mark `placeholder`

- (NSString *)placeholder {
    return self.placeholderTextView.text;
}

- (void)setPlaceholder:(NSString *)placeholder {
    self.placeholderTextView.text = placeholder;
    [self updatePlaceholderTextView];
}

- (NSAttributedString *)wg_attributedPlaceholder {
    return self.placeholderTextView.attributedText;
}

- (void)setWg_attributedPlaceholder:(NSAttributedString *)attributedPlaceholder {
    self.placeholderTextView.attributedText = attributedPlaceholder;
    [self updatePlaceholderTextView];
}

#pragma mark `placeholderColor`

- (UIColor *)placeholderColor {
    return self.placeholderTextView.textColor;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    self.placeholderTextView.textColor = placeholderColor;
}


#pragma mark `needsUpdateFont`

- (BOOL)needsUpdateFont {
    return [objc_getAssociatedObject(self, @selector(needsUpdateFont)) boolValue];
}

- (void)setNeedsUpdateFont:(BOOL)needsUpdate {
    objc_setAssociatedObject(self, @selector(needsUpdateFont), @(needsUpdate), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"font"]) {
        self.needsUpdateFont = (change[NSKeyValueChangeNewKey] != nil);
    }
    [self updatePlaceholderTextView];
}


#pragma mark - Update

- (void)updatePlaceholderTextView {
    if (self.text.length) {
        [self.placeholderTextView removeFromSuperview];
        self.accessibilityValue = self.text;
    } else {
        [self insertSubview:self.placeholderTextView atIndex:0];
        self.accessibilityValue = self.placeholder;
    }
    
    if (self.needsUpdateFont) {
        self.placeholderTextView.font = self.font;
        self.needsUpdateFont = NO;
    }
    if (self.placeholderTextView.attributedText.length == 0) {
        self.placeholderTextView.textAlignment = self.textAlignment;
    }
    self.placeholderTextView.textContainer.exclusionPaths = self.textContainer.exclusionPaths;
    self.placeholderTextView.textContainerInset = self.textContainerInset;
    self.placeholderTextView.textContainer.lineFragmentPadding = self.textContainer.lineFragmentPadding;
    self.placeholderTextView.frame = self.bounds;
}

#pragma mark - 输入限制

- (NSInteger)wg_maxLength {
    return [objc_getAssociatedObject(self, WGTextViewInputLimitMaxLength) integerValue];
}
- (void)setWg_maxLength:(NSInteger)maxLength {
    objc_setAssociatedObject(self, WGTextViewInputLimitMaxLength, @(maxLength), OBJC_ASSOCIATION_ASSIGN);
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wg_textViewTextDidChange:)
                                                name:@"UITextViewTextDidChangeNotification" object:self];

}
- (void)wg_textViewTextDidChange:(NSNotification *)notification {
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

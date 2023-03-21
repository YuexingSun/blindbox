//
//  UITextView+WGExtension.h
//  Bravat
//
//  Created by 廖其进 on 2020/6/8.
//  Copyright © 2020 com.xf.wind. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT double UITextView_PlaceholderVersionNumber;
FOUNDATION_EXPORT const unsigned char UITextView_PlaceholderVersionString[];

@interface UITextView (WGExtension)

@property (nonatomic, readonly) UITextView *placeholderTextView NS_SWIFT_NAME(placeholderTextView);

@property (nonatomic, strong) IBInspectable NSString *placeholder;
@property (nonatomic, strong) NSAttributedString *wg_attributedPlaceholder;
@property (nonatomic, strong) IBInspectable UIColor *placeholderColor;

@property (assign, nonatomic) NSInteger wg_maxLength;//if <=0, no limit

+ (UIColor *)defaultPlaceholderColor;

@end

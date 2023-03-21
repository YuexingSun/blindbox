//
//  ZX_EmojiManager.h
//  ZXHY
//
//  Created by Bern Lin on 2022/2/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZXEmojiAttachment.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZX_EmojiManager : NSObject

/**
 给输入框插入自定义表情
 @param emojiAttachment 表情对象
 @param textView 对象文本框
 */

+ (void)zx_insertEmojiToString:(ZXEmojiAttachment *)emojiAttachment textView:(UITextView *)textView;


/**
 表情纯文本 转换富文本
 @param string  @"[emji-001]"
 @return 带表情的NSAttributedString
 */
+ (NSAttributedString *)zx_emojiWithServerString:(NSString *)string;


/**
 富文本 转换 表情纯文本
 @param attributedStr  @"🤔😴"
 @return 纯文本NSString
 */
+ (NSString *)zx_stringWithEmojiString:(NSAttributedString *)attributedStr;

@end

NS_ASSUME_NONNULL_END

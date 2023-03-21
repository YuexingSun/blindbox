//
//  ZXEmojiAttachment.h
//  ZXHY
//
//  Created by Bern Lin on 2022/2/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXEmojiAttachment : NSTextAttachment

@property(nonatomic, strong) NSString *imageName; /** 表情图片名 */
@property(nonatomic, strong) NSString *tagName; /** 标签名 */
@property(nonatomic, assign) NSRange range; /** 位置 */

@end

NS_ASSUME_NONNULL_END

//
//  ZXMsgEmojiView.h
//  ZXHY
//
//  Created by Bern Lin on 2022/2/23.
//

#import <UIKit/UIKit.h>
#import "ZX_EmojiManager.h"
#import "ZXEmojiAttachment.h"


NS_ASSUME_NONNULL_BEGIN

@class  ZXMsgEmojiView;

@protocol ZXMsgEmojiViewDelegate <NSObject>

//删除
- (void)zx_removeEmojiView:(ZXMsgEmojiView *)emojiView;

//选中Item
- (void)zx_selectEmojiView:(ZXMsgEmojiView *)emojiView SelectItemAtEmojiAttachment:(ZXEmojiAttachment *)attachment;

@end


@interface ZXMsgEmojiView : UIView

@property (nonatomic, weak) id <ZXMsgEmojiViewDelegate> delegate;


@end

NS_ASSUME_NONNULL_END

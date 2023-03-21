//
//  ZXMsgInputView.h
//  ZXHY
//
//  Created by Bern Lin on 2021/12/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZXMsgInputView;

@protocol ZXMsgInputViewDelegate <NSObject>

//发送代理
- (void)zx_sendMsgInputView:(ZXMsgInputView *)msgInputView MsgText:(NSString *)msgText;



@end



@interface ZXMsgInputView : UIView

@property (nonatomic, weak) id <ZXMsgInputViewDelegate> delegate;

- (void)wg_resignFirstResponder;

- (void)wg_becomeFirstResponder;

- (BOOL)wg_isEmoji;


@end

NS_ASSUME_NONNULL_END

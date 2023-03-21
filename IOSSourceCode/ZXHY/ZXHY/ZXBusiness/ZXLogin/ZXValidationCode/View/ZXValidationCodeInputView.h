//
//  ZXValidationCodeInputView.h
//  ZXHY
//
//  Created by Bern Mac on 8/10/21.
//

#import "WGBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@class ZXValidationCodeInputView;

@protocol ZXValidationCodeInputViewDelegate <NSObject>

//输入中
- (void)inputValidationCodeingInputWithUITextField:(UITextField *)textField CodeInputView:(ZXValidationCodeInputView *)validationCodeInputView;


//输入完毕
- (void)didInputWithValidationCodeInputView:(ZXValidationCodeInputView *)validationCodeInputView;

@end

@interface ZXValidationCodeInputView : WGBaseView

// 当前输入的内容
@property (nonatomic, copy, readonly) NSString *code;

- (instancetype)initWithCount:(NSInteger)count margin:(CGFloat)margin;

@property (nonatomic, weak) id <ZXValidationCodeInputViewDelegate> delegate;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

@end

NS_ASSUME_NONNULL_END

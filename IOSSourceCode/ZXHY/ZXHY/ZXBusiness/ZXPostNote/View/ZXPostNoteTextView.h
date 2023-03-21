//
//  ZXPostNoteTextView.h
//  ZXHY
//
//  Created by Bern Lin on 2021/12/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXPostNoteTextView : UITextView

/** 占位文字 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位文字颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;
//行间距
@property (nonatomic, assign) CGFloat verticalSpacing;
/**设置最大高度*/
@property (nonatomic, assign) CGFloat maxHeight;
/**设置最小高度*/
@property (nonatomic, assign) CGFloat minHeight;
/**是不是自适应高度，默认为YES*/
@property (nonatomic, assign) BOOL isAutoHeight;

@property (nonatomic, copy) void(^textDidChangedBlock)(NSString * text);
@property (nonatomic, copy) void (^textViewAutoHeight)(CGFloat textHeight);

@end

NS_ASSUME_NONNULL_END

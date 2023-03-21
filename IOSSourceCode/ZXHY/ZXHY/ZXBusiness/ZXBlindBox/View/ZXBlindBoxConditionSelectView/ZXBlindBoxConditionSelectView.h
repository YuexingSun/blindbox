//
//  ZXBlindBoxConditionSelectView.h
//  ZXHY
//
//  Created by Bern Lin on 2021/11/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZXBlindBoxConditionSelectView;

@protocol ZXBlindBoxConditionSelectViewDelegate <NSObject>

//取消
- (void)zx_closeBlindBoxConditionSelectView:(ZXBlindBoxConditionSelectView *)conditionSelectView;

//确定
- (void)zx_sureBlindBoxConditionSelectView:(ZXBlindBoxConditionSelectView *)conditionSelectView QuestionArray:(NSMutableArray *)questionArray;

@end





@interface ZXBlindBoxConditionSelectView : UIView

@property (nonatomic, weak) id <ZXBlindBoxConditionSelectViewDelegate> delegate;


//获取问答数据
- (void)zx_reqApiGetBoxQuesListWithTypeId:(NSString *)typeId;

@end



NS_ASSUME_NONNULL_END

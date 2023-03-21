//
//  ZXBlindBoxSelectView.h
//  ZXHY
//
//  Created by Bern Mac on 7/29/21.
//

#import "WGBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@class ZXBlindBoxSelectView;

@protocol ZXBlindBoxSelectViewDelegate <NSObject>

- (void)blindBoxSelectView:(ZXBlindBoxSelectView *)blindBoxSelectView SelectorWithCancel:(UIButton *)sender;

- (void)blindBoxSelectView:(ZXBlindBoxSelectView *)blindBoxSelectView SelectorWithSure:(UIButton *)sender CurrentBudgetDisance:(NSMutableDictionary *)budgetDisanceDic QuestList:(NSMutableArray *)questList;

@end

@interface ZXBlindBoxSelectView : WGBaseView

@property (nonatomic, weak) id <ZXBlindBoxSelectViewDelegate> delegate;

//获取问答数据
- (void)zx_reqApiGetBoxQuesListWithTypeId:(NSString *)typeId;

@end

NS_ASSUME_NONNULL_END

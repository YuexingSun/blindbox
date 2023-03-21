//
//  ZXBlindBoxConditionSelectBudgetCell.h
//  ZXHY
//
//  Created by Bern Lin on 2021/11/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZXBlindBoxConditionSelectBudgetCell,ZXBlindBoxSelectViewItemlistModel,ZXBlindBoxSelectViewModel;

@protocol ZXBlindBoxConditionSelectBudgetCellDelegate <NSObject>

//选中回调
- (void)conditionSelectBudgetCell:(ZXBlindBoxConditionSelectBudgetCell *)cell BlindBoxSelectViewItemlistModel:(ZXBlindBoxSelectViewItemlistModel *)itemlistModel;

@end



@interface ZXBlindBoxConditionSelectBudgetCell : UITableViewCell

+ (NSString *)wg_cellIdentifier;

//代理
@property (nonatomic, weak) id <ZXBlindBoxConditionSelectBudgetCellDelegate> delegate;

//数据赋值
- (void)zx_setBlindBoxSelectViewModel:(ZXBlindBoxSelectViewModel *)blindBoxSelectViewModel;

@end

NS_ASSUME_NONNULL_END

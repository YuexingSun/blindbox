//
//  ZXBlindBoxSelectBudgetCell.h
//  ZXHY
//
//  Created by Bern Mac on 8/5/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZXBlindBoxSelectViewModel,ZXBlindBoxSelectBudgetCell,ZXBlindBoxSelectViewItemlistModel;


@protocol ZXBlindBoxSelectBudgetCellDelegate <NSObject>

//选中回调
- (void)selectBudgetCell:(ZXBlindBoxSelectBudgetCell *)view BlindBoxSelectViewItemlistModel:(ZXBlindBoxSelectViewItemlistModel *)itemlistModel;


@end

@interface ZXBlindBoxSelectBudgetCell : UITableViewCell

+ (NSString *)wg_cellIdentifier;

//数据赋值
- (void)zx_setBlindBoxSelectViewModel:(ZXBlindBoxSelectViewModel *)blindBoxSelectViewModel;

//代理
@property (nonatomic, weak) id <ZXBlindBoxSelectBudgetCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

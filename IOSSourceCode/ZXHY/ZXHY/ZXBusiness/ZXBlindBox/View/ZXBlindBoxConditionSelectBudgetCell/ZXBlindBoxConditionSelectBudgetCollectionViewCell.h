//
//  ZXBlindBoxConditionSelectBudgetCollectionViewCell.h
//  ZXHY
//
//  Created by Bern Lin on 2021/11/19.
//

#import "WGBaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class ZXBlindBoxSelectViewItemlistModel;

@interface ZXBlindBoxConditionSelectBudgetCollectionViewCell : WGBaseCollectionViewCell

+ (NSString *)wg_cellIdentifier;

@property (nonatomic,strong) UILabel *brandNameLabel;

//数据赋值
- (void)zx_setBlindBoxSelectViewItemlistModel:(ZXBlindBoxSelectViewItemlistModel *)blindBoxSelectViewItemlistModel;

@end

NS_ASSUME_NONNULL_END

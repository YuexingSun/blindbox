//
//  ZXBlindBoxConditionSelectMoodCollectionViewCell.h
//  ZXHY
//
//  Created by Bern Lin on 2021/11/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZXBlindBoxSelectViewItemlistModel;

@interface ZXBlindBoxConditionSelectMoodCollectionViewCell : UICollectionViewCell

+ (NSString *)wg_cellIdentifier;

//数据赋值
- (void)zx_setBlindBoxSelectViewItemlistModel:(ZXBlindBoxSelectViewItemlistModel *)blindBoxSelectViewItemlistModel;

@end

NS_ASSUME_NONNULL_END

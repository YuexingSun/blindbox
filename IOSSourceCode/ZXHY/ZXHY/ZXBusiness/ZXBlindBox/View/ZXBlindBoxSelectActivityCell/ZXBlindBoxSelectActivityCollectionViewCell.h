//
//  ZXBlindBoxSelectActivityCollectionViewCell.h
//  ZXHY
//
//  Created by Bern Mac on 8/24/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZXBlindBoxSelectViewItemlistModel;

@interface ZXBlindBoxSelectActivityCollectionViewCell : UICollectionViewCell

+ (NSString *)wg_cellIdentifier;

//数据赋值
- (void)zx_setBlindBoxSelectViewItemlistModel:(ZXBlindBoxSelectViewItemlistModel *)blindBoxSelectViewItemlistModel;

@end

NS_ASSUME_NONNULL_END

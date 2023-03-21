//
//  ZXBlindBoxSelectHeaderCollectionViewCell.h
//  Yunhuoyouxuan
//
//  Created by Bern on 2021/3/31.
//  Copyright © 2021 apple. All rights reserved.
//

#import "WGBaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class ZXBlindBoxSelectViewItemlistModel;

@interface ZXBlindBoxSelectHeaderCollectionViewCell : WGBaseCollectionViewCell

+ (NSString *)wg_cellIdentifier;

//数据赋值
- (void)zx_setBlindBoxSelectViewItemlistModel:(ZXBlindBoxSelectViewItemlistModel *)blindBoxSelectViewItemlistModel;

@end

NS_ASSUME_NONNULL_END

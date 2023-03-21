//
//  ZXBlindBoxSelectActivityCell.h
//  ZXHY
//
//  Created by Bern Mac on 8/3/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZXBlindBoxSelectViewModel,ZXBlindBoxSelectViewItemlistModel;

@interface ZXBlindBoxSelectActivityCell : UITableViewCell

+ (NSString *)wg_cellIdentifier;


//数据赋值
- (void)zx_setBlindBoxSelectViewModel:(ZXBlindBoxSelectViewModel *)blindBoxSelectViewModel NumberModel:(ZXBlindBoxSelectViewItemlistModel *)selectViewItemlistModel;

@end

NS_ASSUME_NONNULL_END

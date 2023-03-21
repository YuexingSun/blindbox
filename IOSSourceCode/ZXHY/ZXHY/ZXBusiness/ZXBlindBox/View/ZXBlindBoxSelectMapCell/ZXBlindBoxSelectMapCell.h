//
//  ZXBlindBoxSelectMapCell.h
//  ZXHY
//
//  Created by Bern Mac on 9/29/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZXBlindBoxSelectViewModel;

@interface ZXBlindBoxSelectMapCell : UITableViewCell

+ (NSString *)wg_cellIdentifier;

//数据赋值
- (void)zx_setBlindBoxSelectViewModel:(ZXBlindBoxSelectViewModel *)blindBoxSelectViewModel;

@end

NS_ASSUME_NONNULL_END

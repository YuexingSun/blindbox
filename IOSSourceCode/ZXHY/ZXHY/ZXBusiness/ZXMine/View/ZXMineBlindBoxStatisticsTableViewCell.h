//
//  ZXMineBlindBoxStatisticsTableViewCell.h
//  ZXHY
//
//  Created by Bern Mac on 1/4/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZXMineModel;

@interface ZXMineBlindBoxStatisticsTableViewCell : UITableViewCell

+ (NSString *)wg_cellIdentifier;

//数据赋值
- (void)zx_dataWithMineModel:(ZXMineModel *)mineModel;

@end

NS_ASSUME_NONNULL_END

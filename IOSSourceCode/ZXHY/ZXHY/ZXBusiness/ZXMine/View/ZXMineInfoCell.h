//
//  ZXMineInfoCell.h
//  ZXHY
//
//  Created by Bern Mac on 8/27/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZXMineModel;

@interface ZXMineInfoCell : UITableViewCell

+ (NSString *)wg_cellIdentifier;



//数据赋值
- (void)zx_dataWithMineModel:(ZXMineModel *)mineModel;

@end

NS_ASSUME_NONNULL_END

//
//  ZXMineBoxDetailsInfoCell.h
//  ZXHY
//
//  Created by Bern Mac on 8/30/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ZXOpenResultsModel;

@interface ZXMineBoxDetailsInfoCell : UITableViewCell

+ (NSString *)wg_cellIdentifier;

//数据赋值
- (void)zx_dataWithMineBoxResultsModel:(ZXOpenResultsModel *)resultsModel;

@end

NS_ASSUME_NONNULL_END

//
//  ZXMineBoxListViewCell.h
//  ZXHY
//
//  Created by Bern Mac on 8/27/21.
//

#import <UIKit/UIKit.h>

@class  ZXMineBoxListModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZXMineBoxListViewCell : UITableViewCell

+ (NSString *)wg_cellIdentifier;

//数据赋值
- (void)zx_dataWithMineBoxModel:(ZXMineBoxListModel *)boxListModel;

@end

NS_ASSUME_NONNULL_END

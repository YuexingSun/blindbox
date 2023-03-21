//
//  ZXMineAchievementCollectionViewCell.h
//  ZXHY
//
//  Created by Bern Mac on 8/29/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZXMineMyAchieveListModel;

@interface ZXMineAchievementCollectionViewCell : UICollectionViewCell

+ (NSString *)wg_cellIdentifier;


//数据赋值
- (void)zx_dataWithMineMyAchieveListModel:(ZXMineMyAchieveListModel *)listModel;

@end

NS_ASSUME_NONNULL_END

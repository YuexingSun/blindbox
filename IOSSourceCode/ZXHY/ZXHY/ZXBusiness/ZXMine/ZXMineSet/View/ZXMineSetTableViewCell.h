//
//  ZXMineSetTableViewCell.h
//  ZXHY
//
//  Created by Bern Mac on 9/23/21.
//

#import <UIKit/UIKit.h>
#import "ZXMineSetManager.h"

NS_ASSUME_NONNULL_BEGIN

@class  ZXMineUserProfileModel;

@interface ZXMineSetTableViewCell : UITableViewCell

+ (NSString *)wg_cellIdentifier;

- (void)zx_setDataWithMineSetType:(ZXMineSetType)mineSetType UserProfileModel:(ZXMineUserProfileModel *)userProfileModel;

@end

NS_ASSUME_NONNULL_END

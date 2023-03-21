//
//  ZXMineSetHeaderTableViewCell.h
//  ZXHY
//
//  Created by Bern Mac on 1/4/22.
//

#import <UIKit/UIKit.h>
#import "ZXMineSetManager.h"

@class  ZXMineUserProfileModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZXMineSetHeaderTableViewCell : UITableViewCell

+ (NSString *)wg_cellIdentifier;

- (void)zx_setDataWithMineSetType:(ZXMineSetType)mineSetType UserProfileModel:(ZXMineUserProfileModel *)userProfileModel;

@end

NS_ASSUME_NONNULL_END

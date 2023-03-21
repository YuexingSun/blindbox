//
//  ZXMyCollectionTableViewCell.h
//  ZXHY
//
//  Created by Bern Lin on 2022/1/6.
//

#import <UIKit/UIKit.h>

@class  ZXMyCollectionModel,ZXMyCollectionListModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZXMyCollectionTableViewCell : UITableViewCell

+ (NSString *)wg_cellIdentifier;

- (void)zx_setListModel:(ZXMyCollectionListModel *)listModel;

@end

NS_ASSUME_NONNULL_END

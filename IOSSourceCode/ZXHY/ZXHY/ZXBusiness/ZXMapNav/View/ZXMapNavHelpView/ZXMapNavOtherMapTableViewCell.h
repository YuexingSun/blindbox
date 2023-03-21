//
//  ZXMapNavOtherMapTableViewCell.h
//  ZXHY
//
//  Created by Bern Lin on 2022/1/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZXOpenResultsModel;

@interface ZXMapNavOtherMapTableViewCell : UITableViewCell

+ (NSString *)wg_cellIdentifier;

//数据
- (void)zx_openResultsModel:(ZXOpenResultsModel *)openResultsModel;

@end

NS_ASSUME_NONNULL_END

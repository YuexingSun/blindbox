//
//  ZXMapNavResultGreenHeaderCell.h
//  ZXHY
//
//  Created by Bern Lin on 2021/12/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class  ZXOpenResultsModel;

@interface ZXMapNavResultGreenHeaderCell : UITableViewCell

+ (NSString *)wg_cellIdentifier;

//数据
- (void)zx_openResultsModel:(ZXOpenResultsModel *)openResultsModel;

@property (nonatomic, copy) void(^goonBtBlock)(void);

@end

NS_ASSUME_NONNULL_END

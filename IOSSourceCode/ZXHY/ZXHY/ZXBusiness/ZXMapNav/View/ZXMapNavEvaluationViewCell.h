//
//  ZXMapNavEvaluationViewCell.h
//  ZXHY
//
//  Created by Bern Lin on 2021/11/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class  ZXOpenResultsModel;

@interface ZXMapNavEvaluationViewCell : UITableViewCell

+ (NSString *)wg_cellIdentifier;

- (void)zx_openResultsModel:(ZXOpenResultsModel *)openResultsModel;

@end

NS_ASSUME_NONNULL_END

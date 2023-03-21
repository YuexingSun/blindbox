//
//  ZXMineBoxDetailsEvaluationCell.h
//  ZXHY
//
//  Created by Bern Mac on 8/30/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZXOpenResultsModel;
@class  ZXMineBoxDetailsEvaluationCell;

@protocol ZXMineBoxDetailsEvaluationCellDelegate <NSObject>

//满意
- (void)satisfied:(ZXMineBoxDetailsEvaluationCell *)evaluationCell;

//不满意
- (void)notSatisfied:(ZXMineBoxDetailsEvaluationCell *)evaluationCell;

//查看评价
- (void)checkReviewButton:(UIButton *)reviewButton WithCell:(ZXMineBoxDetailsEvaluationCell *)evaluationCell;

//评价完成后刷新
- (void)completeEvaluationReload:(ZXMineBoxDetailsEvaluationCell *)evaluationCell;

@end

@interface ZXMineBoxDetailsEvaluationCell : UITableViewCell

+ (NSString *)wg_cellIdentifier;

@property (nonatomic, weak) id <ZXMineBoxDetailsEvaluationCellDelegate> delegate;

//数据赋值
- (void)zx_dataWithMineBoxResultsModel:(ZXOpenResultsModel *)resultsModel;




@end

NS_ASSUME_NONNULL_END

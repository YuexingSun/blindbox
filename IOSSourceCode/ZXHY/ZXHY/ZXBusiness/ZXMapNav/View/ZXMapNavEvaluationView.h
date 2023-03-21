//
//  ZXMapNavEvaluationView.h
//  ZXHY
//
//  Created by Bern Lin on 2021/11/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define CancelButton 1000
#define SatisfiedButtonTag 1001
#define NotSatisfiedButtonTag 1002
#define SubmitButton 1003


@class ZXMapNavEvaluationView;
@class  ZXOpenResultsModel;

@protocol ZXMapNavEvaluationViewDelegate <NSObject>

- (void)mapNavEvaluationView:(ZXMapNavEvaluationView *)evaluationView SelectorWithEvaluation:(UIButton *)sender;

@end


@interface ZXMapNavEvaluationView : UIView

//代理
@property (nonatomic, weak) id <ZXMapNavEvaluationViewDelegate> delegate;

//传入Model ，BoxId
- (void)zx_openResultsModel:(ZXOpenResultsModel *)openResultsModel;

//是否满意
- (void)zx_isSatisfied:(BOOL)isSatisfied;

@end

NS_ASSUME_NONNULL_END

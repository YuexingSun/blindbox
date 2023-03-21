//
//  ZXMapNavResultsGreenView.h
//  ZXHY
//
//  Created by Bern Lin on 2021/12/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZXOpenResultsModel;
@class ZXMapNavResultsGreenView;


@protocol ZXMapNavResultsGreenViewDelegate <NSObject>

// 关闭响应
- (void)closeResultsGreenView:(ZXMapNavResultsGreenView *)resultsGreenView;

@end

@interface ZXMapNavResultsGreenView : UIView

@property (nonatomic, weak) id <ZXMapNavResultsGreenViewDelegate> delegate;


- (instancetype)initWithFrame:(CGRect)frame withOpenResultsModel:(ZXOpenResultsModel *)openResultsModel;



@end

NS_ASSUME_NONNULL_END

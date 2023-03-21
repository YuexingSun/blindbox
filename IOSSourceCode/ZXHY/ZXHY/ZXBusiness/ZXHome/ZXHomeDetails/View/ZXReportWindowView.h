//
//  ZXReportWindowView.h
//  ZXHY
//
//  Created by Bern Lin on 2022/2/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZXReportWindowView;

@protocol ZXReportWindowViewDelegate <NSObject>

//取消 响应
- (void)closeReportWindowView:(ZXReportWindowView *)reportWindowView;

//确定 响应
- (void)sureReportWindowView:(ZXReportWindowView *)reportWindowView;

@end

@interface ZXReportWindowView : UIView

@property (nonatomic, weak) id <ZXReportWindowViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

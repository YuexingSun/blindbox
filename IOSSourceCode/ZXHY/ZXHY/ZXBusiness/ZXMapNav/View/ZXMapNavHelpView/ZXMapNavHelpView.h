//
//  ZXMapNavHelpView.h
//  ZXHY
//
//  Created by Bern Lin on 2021/12/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, NavHelpType) {
    NavHelpType_OtherNav,
    NavHelpType_Call,
};

@class  ZXMapNavHelpView;
@class ZXOpenResultsModel;

@protocol ZXMapNavHelpViewDelegate <NSObject>

//按钮 响应
- (void)zx_navHelpView:(ZXMapNavHelpView *)helpView NavHelpType:(NavHelpType)navHelpType;

@end


@interface ZXMapNavHelpView : UIView

@property (nonatomic, weak) id <ZXMapNavHelpViewDelegate> delegate;

//数据
- (void)zx_openResultsModel:(ZXOpenResultsModel *)openResultsModel;

@end

NS_ASSUME_NONNULL_END

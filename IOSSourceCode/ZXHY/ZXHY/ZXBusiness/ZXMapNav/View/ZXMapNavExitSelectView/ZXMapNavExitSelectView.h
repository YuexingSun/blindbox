//
//  ZXMapNavExitSelectView.h
//  ZXHY
//
//  Created by Bern Lin on 2021/12/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, NavExitType) {
    NavExitType_ExitAndCancelBox,
    NavExitType_Exit,
};

@class  ZXMapNavExitSelectView;

@protocol ZXMapNavExitSelectViewDelegate <NSObject>

//按钮 响应
- (void)zx_exitSelectView:(ZXMapNavExitSelectView *)exitSelectView NavExitType:(NavExitType)navExitType;

@end


@interface ZXMapNavExitSelectView : UIView

- (instancetype)initWithFrame:(CGRect)frame withBoxId:(NSString *)boxId;

@property (nonatomic, weak) id <ZXMapNavExitSelectViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

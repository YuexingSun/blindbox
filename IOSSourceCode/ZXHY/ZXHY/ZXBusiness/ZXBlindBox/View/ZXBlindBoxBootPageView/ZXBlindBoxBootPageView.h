//
//  ZXBlindBoxBootPageView.h
//  ZXHY
//
//  Created by Bern Lin on 2022/1/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZXBlindBoxBootPageView;

@protocol ZXBlindBoxBootPageViewDelegate <NSObject>

//关闭
- (void)zx_closeBlindBoxBootPageView:(ZXBlindBoxBootPageView *)bootPageView;

@end


@interface ZXBlindBoxBootPageView : UIView

@property (nonatomic, weak) id <ZXBlindBoxBootPageViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

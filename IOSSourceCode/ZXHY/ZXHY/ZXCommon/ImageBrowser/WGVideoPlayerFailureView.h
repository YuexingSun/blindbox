//
//  WGVideoPlayerFailureView.h
//  Yunhuoyouxuan
//
//  Created by admin on 2020/12/14.
//  Copyright © 2020 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class WGVideoPlayerFailureView;
@protocol WGVideoPlayerFailureViewDelegate <NSObject>

- (void)reSubmitClickWithVideoPlayerFailureView:(WGVideoPlayerFailureView *)videoPlayerFailureView;

@end

@interface WGVideoPlayerFailureView : UIView

@property (nonatomic, weak) id<WGVideoPlayerFailureViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END

//
//  WGIBVideoView.h
//  WG_Common
//
//  Created by apple on 2021/5/14.
//  Copyright © 2021 广州微革网络科技有限公司（本内容仅限于广州微革网络科技有限公司内部传阅，禁止外泄以及用于其他的商业目的）. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <YBImageBrowser/YBIBVideoView.h>
#import "WGImageBrowserTitleView.h"
#import "WGVideoActionProgressView.h"

NS_ASSUME_NONNULL_BEGIN

@interface WGIBVideoView : UIView

@property (nonatomic, strong) UIImageView *thumbImageView;

@property (nonatomic, weak) id<YBIBVideoViewDelegate> delegate;

- (void)updateLayoutWithExpectOrientation:(UIDeviceOrientation)orientation containerSize:(CGSize)containerSize;

@property (nonatomic, strong, nullable) AVAsset *asset;

@property (nonatomic, assign, readonly, getter=isPlaying) BOOL playing;

@property (nonatomic, assign, readonly, getter=isPlayFailed) BOOL playFailed;

@property (nonatomic, assign, readonly, getter=isPreparingPlay) BOOL preparingPlay;

@property (nonatomic, strong, readonly) UITapGestureRecognizer *tapGesture;

- (void)reset;

- (void)hideToolBar:(BOOL)hide;

- (void)hidePlayButton;

- (void)preparPlay;

- (void)updateActionBarYWithHeight;

@property (nonatomic, assign) BOOL needAutoPlay;

@property (nonatomic, assign) NSUInteger autoPlayCount;

@property (nonatomic, strong, readonly) WGImageBrowserTitleView *topBar;
@property (nonatomic, strong, readonly) WGVideoActionProgressView *actionBar;

@property (nonatomic, copy) NSString *pageTitle;

@end

NS_ASSUME_NONNULL_END

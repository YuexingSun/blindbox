//
//  WGIBVideoView.m
//  WG_Common
//
//  Created by apple on 2021/5/14.
//  Copyright © 2021 广州微革网络科技有限公司（本内容仅限于广州微革网络科技有限公司内部传阅，禁止外泄以及用于其他的商业目的）. All rights reserved.
//

#import "WGIBVideoView.h"
#import <YBImageBrowser/YBIBVideoActionBar.h>
#import <YBImageBrowser/YBIBVideoTopBar.h>
#import <YBImageBrowser/YBIBUtilities.h>

#import "WGVideoPlayerFailureView.h"

#import <AFNetworking/AFNetworkReachabilityManager.h>

#import "UIImage+WGExtension.h"
#import "UIColor+WGExtension.h"
#import "NSString+WGExtension.h"
#import "UIView+WGExtension.h"

@interface WGIBVideoView () <WGVideoPlayerFailureViewDelegate>
@property (nonatomic, strong) WGImageBrowserTitleView *topBar;
@property (nonatomic, strong) WGVideoActionProgressView *actionBar;
@property (nonatomic, strong) UIButton *playButton;

@property (nonatomic, strong) WGVideoPlayerFailureView *videoPlayerFailureView;
@property (nonatomic, strong) UILabel *noWifiLabel;

@end

@implementation WGIBVideoView{
    AVPlayer *_player;
    AVPlayerItem *_playerItem;
    AVPlayerLayer *_playerLayer;
    BOOL _active;
}

#pragma mark - life cycle

- (void)dealloc {
    [self removeObserverForSystem];
    [self reset];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initValue];
        self.backgroundColor = UIColor.clearColor;
        
        [self addSubview:self.thumbImageView];
        [self addSubview:self.topBar];
        [self addSubview:self.actionBar];
        [self addSubview:self.playButton];
        [self addObserverForSystem];
        
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTapGesture:)];
        [self addGestureRecognizer:_tapGesture];
    }
    return self;
}

- (void)initValue {
    _playing = NO;
    _active = YES;
    _needAutoPlay = NO;
    _autoPlayCount = 0;
    _playFailed = NO;
    _preparingPlay = NO;
}

#pragma mark - public

- (void)updateLayoutWithExpectOrientation:(UIDeviceOrientation)orientation containerSize:(CGSize)containerSize {
    UIEdgeInsets padding = YBIBPaddingByBrowserOrientation(orientation);
    CGFloat width = containerSize.width - padding.left - padding.right;
    self.topBar.frame = CGRectMake(padding.left, padding.top, width, [YBIBVideoTopBar defaultHeight]);
    
    CGFloat firstImgRate = 1;
    if (self.thumbImageView.size.height > 0) {
        firstImgRate = self.thumbImageView.size.width/self.thumbImageView.size.height;
    }
    CGFloat firstImgH = containerSize.width;
    CGFloat firstImgW = firstImgH * firstImgRate;
        
    CGRect firstFrame = CGRectMake(0, (containerSize.height - firstImgH) / 2, firstImgW, firstImgH);
    self.actionBar.frame = CGRectMake(padding.left, CGRectGetMaxY(firstFrame) , width, 2);
    
//    CGRectMake(padding.left, height - [YBIBVideoActionBar defaultHeight] - padding.bottom - 10, width, 2);
    self.playButton.center = CGPointMake(containerSize.width / 2.0, containerSize.height / 2.0);
    _playerLayer.frame = (CGRect){CGPointZero, containerSize};
        
    self.videoPlayerFailureView.frame = CGRectMake(0, 0, containerSize.width, 62);
    self.videoPlayerFailureView.center = self.playButton.center;
        
    self.noWifiLabel.y = (containerSize.height - containerSize.width) / 2 + 16;
    self.noWifiLabel.centerX = containerSize.width / 2;
}

- (void)updateActionBarYWithHeight {
    CGFloat firstImgRate = 1;
    if (self.thumbImageView.size.height > 0) {
        firstImgRate = self.thumbImageView.size.width/self.thumbImageView.size.height;
    }
    CGFloat firstImgH = self.thumbImageView.size.height;
    CGFloat firstImgW = firstImgH * firstImgRate;
        
    CGRect firstFrame = CGRectMake(0, (_playerLayer.bounds.size.height - firstImgH) / 2, firstImgW, firstImgH);
    self.actionBar.y = CGRectGetMaxY(firstFrame);
}

- (void)reset {
    [self removeObserverForPlayer];
    
    // If set '_playerLayer.player = nil' or '_player = nil', can not cancel observeing of 'addPeriodicTimeObserverForInterval'.
    [_player pause];
    _playerItem = nil;
    [_playerLayer removeFromSuperlayer];
    _playerLayer = nil;

    [self finishPlay];
}

- (void)hideToolBar:(BOOL)hide {
    if (hide) {
        self.actionBar.hidden = YES;
        self.topBar.hidden = YES;
    } else if (self.isPlaying) {
        self.actionBar.hidden = NO;
        self.topBar.hidden = NO;
    }
}

- (void)hidePlayButton {
    self.playButton.hidden = YES;
}

#pragma mark - private

- (void)videoJumpWithScale:(float)scale {
    CMTime startTime = CMTimeMakeWithSeconds(scale, _player.currentTime.timescale);
    AVPlayer *tmpPlayer = _player;
    
    if (CMTIME_IS_INDEFINITE(startTime) || CMTIME_IS_INVALID(startTime)) return;
    [_player seekToTime:startTime toleranceBefore:CMTimeMake(1, 1000) toleranceAfter:CMTimeMake(1, 1000) completionHandler:^(BOOL finished) {
        if (finished && tmpPlayer == self->_player) {
            [self startPlay];
        }
    }];
}

- (void)preparPlay {
    _preparingPlay = YES;
    _playFailed = NO;
    
    self.playButton.hidden = YES;
    
    [self.delegate yb_preparePlayForVideoView:self];
    
    if (!_playerLayer) {
        _playerItem = [AVPlayerItem playerItemWithAsset:self.asset];
        _player = [AVPlayer playerWithPlayerItem:_playerItem];
        
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        _playerLayer.frame = (CGRect){CGPointZero, [self.delegate yb_containerSizeForVideoView:self]};
        [self.layer insertSublayer:_playerLayer above:self.thumbImageView.layer];
        
        [self addObserverForPlayer];
    } else {
        [self videoJumpWithScale:0];
    }
}

- (void)startPlay {
    if (_player) {
        _playing = YES;
        
        [_player play];
//        [self.actionBar play];
        
        self.topBar.hidden = NO;
        self.actionBar.hidden = NO;
        
        [self.delegate yb_startPlayForVideoView:self];
        
        if(![[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi]){
            [self showNoWifiLabel];
        }
    }
}

- (void)finishPlay {
    self.playButton.hidden = NO;
    [self.actionBar setPlayerProgress:0];
    self.actionBar.hidden = YES;
//    self.topBar.hidden = YES;
    
    _playing = NO;
    
    [self.delegate yb_finishPlayForVideoView:self];
}

- (void)playerPause {
    if (_player) {
        [_player pause];
//        [self.actionBar pause];
    }
}

- (BOOL)autoPlay {
    if (self.autoPlayCount == NSUIntegerMax) {
        [self preparPlay];
    } else if (self.autoPlayCount > 0) {
        --self.autoPlayCount;
        [self.delegate yb_autoPlayCountChanged:self.autoPlayCount];
        [self preparPlay];
    } else {
        return NO;
    }
    return YES;
}

#pragma mark - <YBIBVideoActionBarDelegate>

- (void)yb_videoActionBar:(YBIBVideoActionBar *)actionBar clickPlayButton:(UIButton *)playButton {
    [self startPlay];
}

- (void)yb_videoActionBar:(YBIBVideoActionBar *)actionBar clickPauseButton:(UIButton *)pauseButton {
    [self playerPause];
}

- (void)yb_videoActionBar:(YBIBVideoActionBar *)actionBar changeValue:(float)value {
    [self videoJumpWithScale:value];
}

#pragma mark - observe

- (void)addObserverForPlayer {
    [_playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监控网络缓冲进度
    [_playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
       
    __weak typeof(self) wSelf = self;
    [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        __strong typeof(wSelf) self = wSelf;
        if (!self) return;
        //当前播放的时间
        float current = CMTimeGetSeconds(time);
        //总时间
        float total = CMTimeGetSeconds(self->_playerItem.duration);
        if (current && total > 0) {
            float progress = current / total;
            //更新播放进度条
            [self.actionBar setPlayerProgress:progress];
        }
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPlayToEndTime:) name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
}

- (void)removeObserverForPlayer {
    [_playerItem removeObserver:self forKeyPath:@"status"];
    [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (![self.delegate yb_isFreezingForVideoView:self]) {
        if (object == _playerItem) {
            if ([keyPath isEqualToString:@"status"]) {
                [self playerItemStatusChanged];
            } else if([keyPath isEqualToString:@"loadedTimeRanges"]) {
                NSArray *loadedTimeRanges = [self->_playerItem loadedTimeRanges];
                CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
                float startSeconds = CMTimeGetSeconds(timeRange.start);
                float durationSeconds = CMTimeGetSeconds(timeRange.duration);
                NSTimeInterval timeInterval = startSeconds + durationSeconds;// 计算缓冲总进度
                CMTime duration = self->_playerItem.duration;
                CGFloat totalDuration = CMTimeGetSeconds(duration);
                if(totalDuration > 0){
                    CGFloat loadProgress = timeInterval / totalDuration;
                    [self.actionBar setLoadedProgress:loadProgress];
                }
            }
        }
    }
}

- (void)didPlayToEndTime:(NSNotification *)noti {
    if (noti.object == _playerItem) {
        [self finishPlay];
        [self.delegate yb_didPlayToEndTimeForVideoView:self];
    }
}

- (void)playerItemStatusChanged {
    if (!_active) return;
    
    _preparingPlay = NO;
    
    switch (_playerItem.status) {
        case AVPlayerItemStatusReadyToPlay: {
            // Delay to update UI.
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self startPlay];
                [self.videoPlayerFailureView removeFromSuperview];
                double max = CMTimeGetSeconds(self->_playerItem.duration);
//                [self.actionBar setMaxValue:(isnan(max) || isinf(max)) ? 0 : max];
            });
        }
            break;
        case AVPlayerItemStatusUnknown: {
            _playFailed = YES;
            [self addSubview:self.videoPlayerFailureView];
//            [self.delegate yb_playFailedForVideoView:self];
            [self reset];
            self.playButton.hidden = YES;
        }
            break;
        case AVPlayerItemStatusFailed: {
            _playFailed = YES;
            [self addSubview:self.videoPlayerFailureView];
//            [self.delegate yb_playFailedForVideoView:self];
            [self reset];
            self.playButton.hidden = YES;
        }
            break;
    }
}

- (void)removeObserverForSystem {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:nil];
}

- (void)addObserverForSystem {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeStatusBarFrame) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:)   name:AVAudioSessionRouteChangeNotification object:nil];
}

- (void)applicationWillResignActive:(NSNotification *)notification {
    _active = NO;
    [self playerPause];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    _active = YES;
}

- (void)didChangeStatusBarFrame {
    if ([UIApplication sharedApplication].statusBarFrame.size.height > YBIBStatusbarHeight()) {
        [self playerPause];
    }
}

- (void)audioRouteChangeListenerCallback:(NSNotification*)notification {
    YBIB_DISPATCH_ASYNC_MAIN(^{
        NSDictionary *interuptionDict = notification.userInfo;
        NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
        switch (routeChangeReason) {
            case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
                [self playerPause];
                break;
        }
    })
}

#pragma mark - event

- (void)respondsToTapGesture:(UITapGestureRecognizer *)tap {
    if (self.isPlaying) {
        self.actionBar.hidden = !self.actionBar.isHidden;
        self.topBar.hidden = !self.topBar.isHidden;
        self.playButton.hidden = self.actionBar.isHidden;
    } else {
        [self.delegate yb_respondsToTapGestureForVideoView:self];
    }
}

- (void)clickCancelButton:(UIButton *)button {
    [self.delegate yb_cancelledForVideoView:self];
}

- (void)clickPlayButton:(UIButton *)button {
    button.selected = !button.isSelected;
    if (button.isSelected) {
        [self playerPause];
    } else {
        [self startPlay];
    }
}


#pragma mark - WGVideoPlayerFailureViewDelegate

- (void)reSubmitClickWithVideoPlayerFailureView:(WGVideoPlayerFailureView *)videoPlayerFailureView{
    [videoPlayerFailureView removeFromSuperview];
    [self preparPlay];
}

- (void)showNoWifiLabel{
    if(self.noWifiLabel.superview) {
        return;
    }
    
    self.noWifiLabel.alpha = 0;
    [self addSubview:self.noWifiLabel];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.noWifiLabel.alpha = 1;
    } completion:^(BOOL finished) {
        [weakSelf hideNoWifiLabel];
    }];
}

- (void)hideNoWifiLabel{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [UIView animateWithDuration:0.3 animations:^{
            self.noWifiLabel.alpha = 0;
        } completion:^(BOOL finished) {
            [self.noWifiLabel removeFromSuperview];
        }];
    });
}

#pragma mark - getters & setters

- (void)setNeedAutoPlay:(BOOL)needAutoPlay {
    if (needAutoPlay && _asset && !self.isPlaying) {
        [self autoPlay];
    } else {
        _needAutoPlay = needAutoPlay;
    }
}

@synthesize asset = _asset;
- (void)setAsset:(AVAsset *)asset {
    _asset = asset;
    if (!asset) return;
    if (self.needAutoPlay) {
        if (![self autoPlay]) {
            self.playButton.hidden = NO;
        }
        self.needAutoPlay = NO;
    } else {
        self.playButton.hidden = NO;
    }
}

- (AVAsset *)asset {
    if ([_asset isKindOfClass:AVURLAsset.class]) {
        _asset = [AVURLAsset assetWithURL:((AVURLAsset *)_asset).URL];
    }
    return _asset;
}

- (void)setPageTitle:(NSString *)pageTitle {
    _pageTitle = pageTitle;
    
    [self.topBar setText:pageTitle];
}

- (WGImageBrowserTitleView *)topBar {
    if (!_topBar) {
        _topBar = [[WGImageBrowserTitleView alloc] initWithFrame:CGRectZero];
        __weak typeof(self) weakSelf = self;
        [_topBar setTitleViewCloseBlock:^{
            __strong typeof(self) self = weakSelf;
            [self clickCancelButton:nil];
        }];
    }
    return _topBar;
}

- (WGVideoActionProgressView *)actionBar {
    if (!_actionBar) {
        _actionBar = [WGVideoActionProgressView new];
        _actionBar.hidden = YES;
    }
    return _actionBar;
}

- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playButton.bounds = CGRectMake(0, 0, 60, 60);
        [_playButton setImage:[UIImage wg_imageNamed:@"video_browser_play"] forState:UIControlStateSelected];
        [_playButton setImage:[UIImage wg_imageNamed:@"video_browser_stop"] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(clickPlayButton:) forControlEvents:UIControlEventTouchUpInside];
        _playButton.hidden = YES;
    }
    return _playButton;
}

- (WGVideoPlayerFailureView *)videoPlayerFailureView {
    if(!_videoPlayerFailureView){
        _videoPlayerFailureView = [[WGVideoPlayerFailureView alloc] initWithFrame:CGRectZero];
        _videoPlayerFailureView.delegate = self;
    }
    return _videoPlayerFailureView;
}

- (UILabel *)noWifiLabel {
    if(!_noWifiLabel){
        NSString *noWifiStr = @"当前非WiFi环境，请注意流量消耗";
        UIFont *noWifiFont = [UIFont systemFontOfSize:14];
        CGFloat noWifiStrWidth = [noWifiStr wg_widthWithFont:noWifiFont constrainedToHeight:40]+32;
        _noWifiLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, noWifiStrWidth, 40)];
        _noWifiLabel.textAlignment = NSTextAlignmentCenter;
        _noWifiLabel.text = noWifiStr;
        _noWifiLabel.layer.cornerRadius = 20;
        _noWifiLabel.layer.masksToBounds = YES;
        _noWifiLabel.font = noWifiFont;
        _noWifiLabel.textColor = [UIColor whiteColor];
        _noWifiLabel.backgroundColor = [UIColor wg_colorWithHexString:@"#000000"];
        _noWifiLabel.alpha = 0;
    }
    return _noWifiLabel;
}

- (UIImageView *)thumbImageView {
    if (!_thumbImageView) {
        _thumbImageView = [UIImageView new];
        _thumbImageView.contentMode = UIViewContentModeScaleAspectFit;
        _thumbImageView.layer.masksToBounds = YES;
    }
    return _thumbImageView;
}

@end

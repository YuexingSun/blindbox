//
//  WGVideoBrowserLoadingView.m
//  Yunhuoyouxuan
//
//  Created by admin on 2020/12/15.
//  Copyright © 2020 apple. All rights reserved.
//

#import "WGVideoBrowserLoadingView.h"
#import "UIView+WGExtension.h"

@interface WGVideoBrowserLoadingView()

@property (nonatomic, strong) UIImageView *loadingImgView;

@end

@implementation WGVideoBrowserLoadingView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:CGRectMake(0, 0, 100, 100)]){
        [self setupUI];
    }
    return self;
}

- (void)setupUI{

    CGFloat loadingImgViewWH = 40.f;
    CGFloat loadingImgViewX = (self.width-loadingImgViewWH)/2.0;
    CGFloat loadingImgViewY = 5.f;
    _loadingImgView = [[UIImageView alloc] initWithFrame:CGRectMake(loadingImgViewX, loadingImgViewY, loadingImgViewWH, loadingImgViewWH)];
    _loadingImgView.image = [UIImage imageNamed:@"browser_loading_video"];
    [self addSubview:_loadingImgView];
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1.f;
//    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VAL;
    rotationAnimation.removedOnCompletion = NO;
    [_loadingImgView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];//开始动画

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, loadingImgViewWH+loadingImgViewY+32, self.width, 18)];
    titleLabel.text = @"努力播放中";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:titleLabel];
}

@end

//
//  WGVideoActionProgressView.m
//  Yunhuoyouxuan
//
//  Created by admin on 2020/12/12.
//  Copyright © 2020 apple. All rights reserved.
//
//
#import "WGVideoActionProgressView.h"
#import "UIColor+WGExtension.h"
#import "UIView+WGExtension.h"

@interface WGVideoActionProgressView()

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *middleView;

@end

@implementation WGVideoActionProgressView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setupUI];
    }
    return self;
}

- (void)setupUI{

    self.alpha = 0.5;
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    _middleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, self.height)];
    _middleView.backgroundColor = [UIColor wg_colorWithHexString:@"#F0F0F0" andAlpha:1];
//    _middleView.backgroundColor = [UIColor blueColor];
    [self addSubview:_middleView];
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, self.height)];
    _topView.backgroundColor = [UIColor wg_colorWithHexString:@"#ff445e"];
    [self addSubview:_topView];
}

- (void)setPlayerProgress:(CGFloat)playerProgress{
    if(playerProgress <= 0){
        playerProgress = 0;
    }else if(playerProgress >= 1){
        playerProgress = 1;
    }
    CGFloat topViewW = self.width * playerProgress;
    self.topView.width = topViewW;
    self.topView.height = self.height;
}

- (void)setLoadedProgress:(CGFloat)loadedProgress{
    if(loadedProgress <= 0){
        loadedProgress = 0;
    }else if(loadedProgress >= 1){
        loadedProgress = 1;
    }
    CGFloat middleViewW = self.width * loadedProgress;
    self.middleView.width = middleViewW;
    self.middleView.height = self.height;
}

@end

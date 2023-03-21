//
//  WGVideoPlayerFailureView.m
//  Yunhuoyouxuan
//
//  Created by admin on 2020/12/14.
//  Copyright © 2020 apple. All rights reserved.
//

#import "WGVideoPlayerFailureView.h"
#import "UIView+WGExtension.h"

@interface WGVideoPlayerFailureView()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *reSubmitBtn;

@end

@implementation WGVideoPlayerFailureView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){

        self.height = 62.f;
        [self setBackgroundColor:[UIColor clearColor]];
        [self setupUI];
    }
    return self;
}

- (void)layoutSubviews{
    self.titleLabel.frame = CGRectMake(0, 0, self.width, 18);
    self.reSubmitBtn.frame = CGRectMake((self.width-80)/2.0, 34, 80, 28);
}

- (void)setupUI{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 18)];
    titleLabel.text = @"视频加载失败，请检查网络并重试";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;

    UIButton *reSubmitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reSubmitBtn.frame = CGRectMake((self.width-80)/2.0, 34, 80, 28);
    reSubmitBtn.layer.cornerRadius = 14;
    reSubmitBtn.layer.masksToBounds = YES;
    [reSubmitBtn setTitle:@"点击重试" forState:UIControlStateNormal];
    reSubmitBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [reSubmitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    reSubmitBtn.layer.borderWidth = 0.5;
    reSubmitBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [self addSubview:reSubmitBtn];
    [reSubmitBtn addTarget:self action:@selector(btClick) forControlEvents:UIControlEventTouchUpInside];
    self.reSubmitBtn = reSubmitBtn;
}

#pragma mark - onClick
- (void)btClick{

    if(self.delegate && [self.delegate respondsToSelector:@selector(reSubmitClickWithVideoPlayerFailureView:)]){
        [self.delegate reSubmitClickWithVideoPlayerFailureView:self];
    }
}
@end

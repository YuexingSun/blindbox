//
//  WGNoMoreDataFooterView.m
//  Yunhuoyouxuan
//
//  Created by apple on 2021/4/16.
//  Copyright © 2021 apple. All rights reserved.
//

#import "WGNoMoreDataFooterView.h"
#import "UIView+WGExtension.h"
#import "UILabel+WGExtension.h"
#import "UIColor+WGExtension.h"

static NSString *const WGStrAlreadyToBottom = @"已经到底啦";

@interface WGNoMoreDataFooterView ()

@property(nonatomic,copy) NSString *text;

@property(nonatomic,strong) UILabel *leftCircleView;

@property(nonatomic,strong) UILabel *rightCircleView;

@property(nonatomic,strong) UILabel *textLabel;

@property(nonatomic,strong) UILabel *iconImageView;

@property(nonatomic,assign) BOOL isText;

@end

@implementation WGNoMoreDataFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame text:WGStrAlreadyToBottom];
}

- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text {
    if (CGRectEqualToRect(frame, CGRectZero)) {
        frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 56);
    }
    if (self = [super initWithFrame:frame]) {
        self.text = [text?:WGStrAlreadyToBottom copy];
        self.isText = YES;
        [self setup];
    }
    return self;
}

- (instancetype)initWithLogoType {
    if (self = [super initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 100)]) {
        self.isText = NO;
        [self setup];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.isText) {
        [self.textLabel sizeToFit];
        self.textLabel.centerY = self.height / 2;
        self.textLabel.centerX = self.width / 2;

        self.leftCircleView.centerY = self.height / 2;
        self.rightCircleView.centerY = self.height / 2;
        
        self.leftCircleView.right = self.textLabel.left - 8;
        self.rightCircleView.left = self.textLabel.right + 8;
    } else {
        self.iconImageView.y = 20;
        self.iconImageView.centerX = self.width / 2;
    }
}

- (void)setup {
    
    if (self.isText) {
        [self addSubview:self.leftCircleView];
        [self addSubview:self.textLabel];
        [self addSubview:self.rightCircleView];
    } else {
        [self addSubview:self.iconImageView];
    }
}

- (UILabel *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = UILabel.instance
        .wg_icon(e71a,60)
        .wg_textColor([UIColor wg_colorWithHexString:@"#3C3C3C" andAlpha:0.15])
        .wg_frame(CGRectMake(0, 0, 240, 60))
        .wg_sizeToFit;
    }
    return _iconImageView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:13];
        _textLabel.textColor = [UIColor wg_colorWithHexString:@"#B2B2B2"];
        _textLabel.text = self.text;
        [_textLabel sizeToFit];
    }
    return _textLabel;
}

- (UILabel *)leftCircleView {
    if (!_leftCircleView) {
        _leftCircleView = UILabel.instance
        .wg_icon(e71c,12)
        .wg_textColor([UIColor wg_colorWithHexString:@"#3C3C3C" andAlpha:0.08])
        .wg_frame(CGRectMake(0, 0, 12, 4))
        .wg_sizeToFit;
    }
    return _leftCircleView;
}

- (UILabel *)rightCircleView {
    if (!_rightCircleView) {
        _rightCircleView = UILabel.instance
        .wg_icon(e71b,12)
        .wg_textColor([UIColor wg_colorWithHexString:@"#3C3C3C" andAlpha:0.08])
        .wg_frame(CGRectMake(0, 0, 12, 4))
        .wg_sizeToFit;
    }
    return _rightCircleView;
}

@end

//
//  WGImageBrowserToolsView.m
//  Yunhuoyouxuan
//
//  Created by admin on 2020/11/15.
//  Copyright © 2020 apple. All rights reserved.
//

#import "WGImageBrowserTitleView.h"

#import "UIView+WGExtension.h"

@interface WGImageBrowserTitleView()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *closeImgView;

@property (nonatomic, strong) UIView *closeBgView;


@end

@implementation WGImageBrowserTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{

    self.backgroundColor = [UIColor clearColor];
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 28)];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.backgroundColor = [UIColor blackColor];
    _titleLabel.layer.cornerRadius = _titleLabel.frame.size.height / 2;
    _titleLabel.layer.masksToBounds = YES;
    [self addSubview:_titleLabel];
    
    UIView *closeBgView = [[UIView alloc] initWithFrame:CGRectMake(8, 6, 32, 32)];
    closeBgView.backgroundColor = [UIColor blackColor];
    closeBgView.clipsToBounds = NO;
    closeBgView.layer.cornerRadius = 16;
    [self addSubview:closeBgView];
    self.closeBgView = closeBgView;
    
    UIImageView *closeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 6, 20, 20)];
    closeImgView.image = [UIImage imageNamed:@"com_close_white"];
    [closeBgView addSubview:closeImgView];
    self.closeImgView = closeImgView;
}

- (void)didClickedCloseItem:(UITapGestureRecognizer *)tap {
    if (_titleViewCloseBlock) {
        _titleViewCloseBlock();
    }
}

- (void)updateLayout:(CGSize)size padding:(UIEdgeInsets)padding {
    self.closeBgView.x = padding.left + 8;
    self.titleLabel.centerX = size.width / 2;
    self.titleLabel.centerY = self.closeBgView.centerY;
}

- (void)setText:(NSString *)text {
    self.titleLabel.text = text;
    [self.titleLabel sizeToFit];

    CGRect rect = self.titleLabel.frame;
    rect.size.height = 28;
    rect.size.width = rect.size.width + 24;
    
    self.titleLabel.frame = rect;
}

- (void)setTitleViewCloseBlock:(void (^)(void))titleViewCloseBlock {
    _titleViewCloseBlock = titleViewCloseBlock;
    if (titleViewCloseBlock) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickedCloseItem:)];
        self.closeImgView.userInteractionEnabled = YES;
        [self.closeImgView addGestureRecognizer:tap];
    }
}

@end

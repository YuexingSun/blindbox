//
//  WGNavigationView.m
//  Yunhuoyouxuan
//
//  Created by Apple on 2020/12/28.
//  Copyright © 2020 apple. All rights reserved.
//

#import "WGNavigationView.h"
#import "WGBadgeButton.h"
#import "WGBadgeView.h"

#import "UIFont+WGExtension.h"
#import "UIColor+WGExtension.h"
#import "NSNumber+WGExtension.h"
#import "UIDevice+WGExtension.h"
#import "NSArray+WGSafe.h"
#import "WGMacro.h"

#define rightTextFont [UIFont wg_fontWithSize:16.0]
#define navDefaultTextColor [UIColor wg_colorWithHexString:@"3C3C3C"]

@interface WGNavigationView()

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIColor *titleColor;

@property (nonatomic, strong) NSMutableArray *rightBtnArr;
@property (nonatomic, strong) UIButton *payAttentionBtn;

@end

@implementation WGNavigationView

+ (instancetype)wg_navigationView
{
    WGNavigationView *nav = [[WGNavigationView alloc] initWithFrame:CGRectMake(0, 0, WGNumScreenWidth(), kNavBarHeight)];
    return nav;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initProperty];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initProperty];
    }
    return self;
}

- (void)initProperty
{
    self.backgroundColor = [UIColor wg_colorWithHexString:@"#F0F0F0"];
    
    self.titleColor = navDefaultTextColor;
    [self addSubview:self.leftView];
    [self addSubview:self.centerView];
    [self addSubview:self.rightView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat subViewY = kNavTopBarHeight;
    CGFloat rightViewRightGap = 8.0;
    CGFloat rightBtnHeight = kNavigationHeight;
    CGFloat rightBtnWidth = 40.0;
    if (self.rightBtnArr.count) {
        for (int i = 0; i < self.rightBtnArr.count; i++) {
            WGBadgeButton *btn = [self.rightBtnArr wg_safeObjectAtIndex:i];
            CGFloat btnX = (self.rightBtnArr.count - 1 - i) * rightBtnWidth;
            btn.frame = CGRectMake(btnX, 0, rightBtnWidth, rightBtnHeight);
            if (btn.wg_badgeView.wg_text.length) {
                [btn.wg_badgeView wg_adjustFrameWithQuantity:btn.wg_badgeView.wg_text offsetX:4 offsetY:8 superViewFrame:btn.frame isForBarButtonItem:NO];
            }
        }
    }
    CGFloat rightViewW = self.rightBtnArr.count * rightBtnWidth;
    CGFloat rightViewX = WGNumScreenWidth() - rightViewW - rightViewRightGap;
    if (self.payAttentionBtn.hidden == NO) {
        self.payAttentionBtn.frame = self.rightView.bounds;
        self.rightView.frame = CGRectMake(rightViewX, subViewY, rightViewW*1.3, rightBtnHeight*1.3);
    }else{
        self.rightView.frame = CGRectMake(rightViewX, subViewY, rightViewW, rightBtnHeight);
    }
    
    CGFloat leftViewWidth = 44.0;
    self.leftView.frame = CGRectMake(0, subViewY, leftViewWidth, rightBtnHeight);
    self.backBtn.frame = self.leftView.bounds;
    
    CGFloat centerViewGap = 10.0;
    CGFloat centerViewX = WGNumScreenWidth() - CGRectGetMinX(self.rightView.frame) + centerViewGap;
    centerViewX = centerViewX > (leftViewWidth + centerViewGap) ? centerViewX : (leftViewWidth + centerViewGap);
    CGFloat centerViewW = WGNumScreenWidth() - centerViewX*2;
    self.centerView.frame = CGRectMake(centerViewX, subViewY, centerViewW, rightBtnHeight);
    self.titleLabel.frame = self.centerView.bounds;
}

#pragma mark - setter & getter
- (UIView *)leftView {
    if (!_leftView) {
        _leftView = [[UIView alloc]init];
    }
    return _leftView;
}

- (UIView *)rightView {
    if (!_rightView) {
        _rightView = [[UIView alloc]init];
    }
    return _rightView;
}

- (UIView *)centerView {
    if (!_centerView) {
        _centerView = [[UIView alloc]init];
    }
    return _centerView;
}

- (UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        [_backBtn setImage:[UIImage imageNamed:@"icon_nav_back"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.leftView addSubview:_backBtn];
    }
    return _backBtn;
}

//- (UIButton *)payAttentionBtn {
//    if (!_payAttentionBtn) {
//        _payAttentionBtn = [[UIButton alloc] init];
//        [_payAttentionBtn setImage:[UIImage wg_imageNamed:WGImgIcon_btn_follow_white] forState:UIControlStateNormal];
//        _payAttentionBtn.titleLabel.font = kFontMedium(10);
//        [_payAttentionBtn setTitle:@"关注" forState:UIControlStateNormal];
//        [_payAttentionBtn setTitleColor:WGHEXColor(@"#FFFFFF") forState:UIControlStateNormal];
//        [_payAttentionBtn wg_setImagePosition:WGImagePositionStyleTop spacing:1];
//        [_payAttentionBtn addTarget:self action:@selector(jumpNoticeList) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _payAttentionBtn;
//}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = self.titleColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont wg_boldFontWithSize:17.0f];
        [self.centerView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (NSMutableArray *)rightBtnArr
{
    if (!_rightBtnArr) {
        _rightBtnArr = [NSMutableArray array];
    }
    return _rightBtnArr;
}

#pragma mark - 事件交互
- (void)backBtnClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(navigationViewBackBtnClick:)]) {
        [self.delegate navigationViewBackBtnClick:self];
    }
}

- (void)rightBtnClick:(UIButton *)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(navigationViewRightBtnClick:btnTag:)]) {
        [self.delegate navigationViewRightBtnClick:self btnTag:btn.tag];
    }
}

#pragma mark - private method
- (void)setRightBtnWithText:(nullable NSString *)text textColor:(nullable UIColor *)color normalImageName:(nullable NSString *)normalImageName highlightedImageName:(nullable NSString *)highlightedImageName selectedImageName:(nullable NSString *)selectedImageName btnTag:(NSInteger)btnTag
{
    WGBadgeButton *selectedBtn = nil;
    for (WGBadgeButton *rightBtn in self.rightBtnArr) {
        if (rightBtn.tag == btnTag) {
            selectedBtn = rightBtn;
            break;
        }
    }
    if (!selectedBtn) {
        selectedBtn = [[WGBadgeButton alloc] init];
        selectedBtn.tag = btnTag;
        [selectedBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.rightBtnArr wg_safeAddObject:selectedBtn];
    }
    
    if (text) {
        selectedBtn.titleLabel.font = rightTextFont;
        [selectedBtn setTitle:text forState:UIControlStateNormal];
        if (color) {
            self.titleColor = color;
            [selectedBtn setTitleColor:color forState:UIControlStateNormal];
        } else {
            [selectedBtn setTitleColor:self.titleColor forState:UIControlStateNormal];
        }
    } else {
        selectedBtn.contentMode = UIViewContentModeScaleAspectFit;
        if (normalImageName)
        {
            [selectedBtn setImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
        }
        if (highlightedImageName) {
            [selectedBtn setImage:[UIImage imageNamed:highlightedImageName] forState:UIControlStateHighlighted];
        }
        if (selectedImageName) {
            [selectedBtn setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
        }
    }
    
//    if (self.payAttentionBtn) {
        [self.rightView addSubview:selectedBtn];
//    }
    
}

#pragma mark - public method
- (void)wg_setIsBack:(BOOL)isBack
{
    if (isBack) {
        self.backBtn.hidden = NO;
    } else {
        self.backBtn.hidden = YES;
    }
}

//// 是否显示关注按钮
//- (void)wg_setIsFollow:(BOOL)isFollow {
////    [self.rightView addSubview:_payAttentionBtn];
//    if (isFollow) {
//        self.payAttentionBtn.hidden = NO;
//    } else {
//        self.payAttentionBtn.hidden = YES;
//    }
//}

- (void)wg_setBackBtnImageName:(NSString *)imageName
{
    [self.backBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void)wg_setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (void)wg_setTitleColor:(UIColor *)color
{
    self.titleColor = color;
    self.titleLabel.textColor = color;
}

- (void)wg_setRightBtnWithText:(nullable NSString *)text textColor:(nullable UIColor *)color btnTag:(NSInteger)btnTag
{
    [self setRightBtnWithText:text textColor:color normalImageName:nil highlightedImageName:nil selectedImageName:nil btnTag:btnTag];
}

- (void)wg_setRightBtnWithNormalImageName:(nullable NSString *)normalImageName highlightedImageName:(nullable NSString *)highlightedImageName selectedImageName:(nullable NSString *)selectedImageName btnTag:(NSInteger)btnTag
{
    [self setRightBtnWithText:nil textColor:nil normalImageName:normalImageName highlightedImageName:highlightedImageName selectedImageName:selectedImageName btnTag:btnTag];
}

- (void)wg_setRightBtnBadgeCount:(NSString *)badgeCount btnTag:(NSInteger)btnTag
{
    WGBadgeButton *selectedBtn = nil;
    for (WGBadgeButton *rightBtn in self.rightBtnArr) {
        if (rightBtn.tag == btnTag) {
            selectedBtn = rightBtn;
            break;
        }
    }
    if (selectedBtn && badgeCount) {
        [selectedBtn.wg_badgeView wg_adjustFrameWithQuantity:badgeCount offsetX:4 offsetY:8 superViewFrame:selectedBtn.frame isForBarButtonItem:NO];
    }
}

- (void)wg_setCenterView:(UIView *)centerView {
    self.centerView = centerView;
}

- (void)setType:(WGNavigationViewType)type
{
    if (_type != type) {
        _type = type;
        [self refreshType];
    }
}

- (void)refreshType
{
    switch (self.type) {
        case WGNavigationViewType_Default:
            self.backgroundColor = [UIColor wg_colorWithHexString:@"#F0F0F0"];
            [self.backBtn setImage:[UIImage imageNamed:@"icon_nav_back"] forState:UIControlStateNormal];
            [self wg_setTitleColor:navDefaultTextColor];
            break;
        case WGNavigationViewType_Red:
            self.backgroundColor = [UIColor wg_colorWithHexString:@"FF445E"];
            [self.backBtn setImage:[UIImage imageNamed:@"common_arrow_left_white"] forState:UIControlStateNormal];
            [self wg_setTitleColor:[UIColor whiteColor]];
            break;
            
        default:
            break;
    }
}

- (UIButton *)wg_getRightBtnWithBtnTag:(NSInteger)btnTag
{
    WGBadgeButton *selectedBtn = nil;
    for (WGBadgeButton *rightBtn in self.rightBtnArr) {
        if (rightBtn.tag == btnTag) {
            selectedBtn = rightBtn;
            break;
        }
    }
    return selectedBtn;
}

- (void)wg_clearAllRightBtn
{
    if (self.rightBtnArr.count) {
        for (int i = 0; i < self.rightBtnArr.count; i++) {
            WGBadgeButton *btn = [self.rightBtnArr wg_safeObjectAtIndex:i];
            [btn removeFromSuperview];
        }
    }
}

- (void)dealloc {
    
}


@end

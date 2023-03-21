//
//  ZXMapFirstEntryTipsView.m
//  ZXHY
//
//  Created by Bern Mac on 8/25/21.
//

#import "ZXMapFirstEntryTipsView.h"

@interface ZXMapFirstEntryTipsView()

@property (nonatomic, strong) UIButton *checkButton;
@property (nonatomic, assign) ZXTipsType  tipsType;

@end

@implementation ZXMapFirstEntryTipsView

- (instancetype)initWithFrame:(CGRect)frame WithEntryTipsType:(ZXTipsType)tipsType{
    if (self = [super initWithFrame:frame]) {
        
        self.tipsType = tipsType;
        
        [self zx_setUI];
        
    }
    return self;
}

#pragma mark - Initialization UI
- (void)zx_setUI{
    
    self.layer.cornerRadius = 15;
    self.backgroundColor =  UIColor.whiteColor;
    
    NSString *imageName = @"";
    NSString *tipsStr1 = @"";
    NSString *tipsStr2 = @"";
    
    if (self.tipsType == ZXTipsType_FristEntry){
        imageName = @"FristEntryLogo";
        tipsStr1 = @"请先前往目的地附近";
        tipsStr2 = @"接近目的地时可揭晓盲盒结果";
    }else if (self.tipsType == ZXTipsType_CloseNavi){
        imageName = @"CloseNaviLogo";
        tipsStr1 = @"确定要关闭当前导航吗";
        tipsStr2 = @"关闭导航后您的行程仍会继续";
    }
    
    
    UIImageView *tipsLogoView = [UIImageView wg_imageViewWithImageNamed:imageName];
    [self addSubview:tipsLogoView];
    [tipsLogoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(25);
        make.centerX.mas_equalTo(self);
        make.height.width.offset(130);
    }];
    
    
    UILabel *tipsLabel1 = [UILabel labelWithFont:kFontMedium(18) TextAlignment:NSTextAlignmentCenter TextColor:WGRGBColor(255, 89, 159) TextStr:tipsStr1 NumberOfLines:1];
    [self addSubview:tipsLabel1];
    [tipsLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipsLogoView.mas_bottom).offset(20);
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.height.offset(20);
    }];
    
    UILabel *tipsLabel2 = [UILabel labelWithFont:kFont(16) TextAlignment:NSTextAlignmentCenter TextColor:WGRGBAlpha(68, 44, 96, 0.75) TextStr:tipsStr2 NumberOfLines:1];
    [self addSubview:tipsLabel2];
    [tipsLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipsLabel1.mas_bottom).offset(10);
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.height.offset(20);
    }];
    
    
    UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    checkButton.titleLabel.font = kFont(14);
    [checkButton setTitle:@"  下次不再提示" forState:UIControlStateNormal];
    [checkButton setTitleColor:WGRGBAlpha(0, 0, 0, 0.5) forState:UIControlStateNormal];
    [checkButton setImage:IMAGENAMED(@"unCheck") forState:UIControlStateNormal];
    [checkButton setImage:IMAGENAMED(@"check") forState:UIControlStateSelected];
    [checkButton addTarget:self action:@selector(checkAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:checkButton];
    [checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipsLabel2.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self);
        make.width.offset(110);
        make.height.offset(20);
    }];
    self.checkButton = checkButton;

    
    
    UIButton *konwButton = [UIButton buttonWithType:UIButtonTypeCustom];
    konwButton.titleLabel.font = kFontSemibold(16);
    [konwButton setTitle:@"我知道了" forState:UIControlStateNormal];
    [konwButton setTitleColor:WGRGBColor(255, 89, 159) forState:UIControlStateNormal];
    [konwButton wg_setLayerRoundedCornersWithRadius:24];
    konwButton.layer.borderColor = WGRGBColor(255, 69, 69).CGColor;
    konwButton.layer.borderWidth = 1;
    [konwButton addTarget:self action:@selector(konwAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:konwButton];
    [konwButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(checkButton.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self);
        make.height.offset(48);
        make.width.offset(170);
    }];

    
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = UIColor.clearColor;
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.right.mas_equalTo(self);
        make.height.offset(45);
    }];
    
    UIView *lineView1 = [UIView new];
    lineView1.backgroundColor = WGGrayColor(221);
    [bottomView addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView);
        make.left.right.mas_equalTo(bottomView);
        make.height.offset(1);
    }];

    UIView *lineView2 = [UIView new];
    lineView2.backgroundColor = WGGrayColor(221);
    [bottomView addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bottomView);
        make.top.bottom.mas_equalTo(bottomView);
        make.width.offset(1);
    }];
    
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.titleLabel.font = kFontMedium(16);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:WGGrayColor(153) forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(bottomView);
        make.right.equalTo(lineView2.mas_left);
    }];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.titleLabel.font = kFontMedium(16);
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:WGGrayColor(51) forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:sureButton];
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(bottomView);
        make.left.equalTo(lineView2.mas_right);
    }];
    
    
    
    if (self.tipsType == ZXTipsType_FristEntry){
       
        bottomView.hidden = YES;
    }else if (self.tipsType == ZXTipsType_CloseNavi){
       
        konwButton.hidden = YES;
    }
}

#pragma mark - 按钮响应
- (void)checkAction:(UIButton *)sender{
    sender.selected = !sender.selected;
}


- (void)konwAction:(UIButton *)sender{
    
    NSString *str = (self.checkButton.selected ) ? @"1" : @"0";
    ZX_SetUserDefaultsIsFristEntryBoxTips(str);
   
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(closeTipsView:)]){
        [self.delegate closeTipsView:self];
    }
}


- (void)cancelAction:(UIButton *)sender{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(closeTipsView:)]){
        [self.delegate closeTipsView:self];
    }
    
}


- (void)sureAction:(UIButton *)sender{
    
    NSString *str = (self.checkButton.selected ) ? @"1" : @"0";
    ZX_SetUserDefaultsIsCloseExitNavTips(str);
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(sureTipsView:)]){
        [self.delegate sureTipsView:self];
    }
}

@end

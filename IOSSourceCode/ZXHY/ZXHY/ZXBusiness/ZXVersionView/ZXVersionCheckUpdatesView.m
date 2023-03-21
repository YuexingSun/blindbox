//
//  ZXVersionCheckUpdatesView.m
//  ZXHY
//
//  Created by Bern Lin on 2021/11/10.
//

#import "ZXVersionCheckUpdatesView.h"
#import "ZXVersionCheckUpdatesViewModel.h"

@interface ZXVersionCheckUpdatesView()

//@property (nonatomic, assign) ZXCheckUpType  checkUpType;
@property (nonatomic, strong) ZXVersionCheckUpdatesViewModel  *versionCheckUpdatesModel;

@end

@implementation ZXVersionCheckUpdatesView

- (instancetype)initWithFrame:(CGRect)frame withVersionCheckUpdatesModel:(ZXVersionCheckUpdatesViewModel *)versionCheckUpdatesModel{
   
    if (self = [super initWithFrame:frame]) {
        self.versionCheckUpdatesModel = versionCheckUpdatesModel;
        [self zx_setUI];
    }
    return self;
}


#pragma mark - Initialization UI
- (void)zx_setUI{
    
    self.layer.cornerRadius = 15;
    self.backgroundColor =  UIColor.whiteColor;
    
    NSString *imageName = @"loginLogo";
    NSString *tipsStr1 = @"检测到新版本";
    NSString *tipsStr2 = @"";
    
    UIImageView *tipsLogoView = [UIImageView wg_imageViewWithImageNamed:imageName];
//    tipsLogoView.layer.cornerRadius = 65;
//    tipsLogoView.layer.masksToBounds = YES;
    tipsLogoView.layer.shadowColor =  WGHEXAlpha(@"828282", 0.25).CGColor;
    tipsLogoView.layer.shadowOffset = CGSizeMake(0,4);
    tipsLogoView.layer.shadowRadius = 3;
    tipsLogoView.layer.shadowOpacity = 1;
    
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
    
    UIButton *checkupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    checkupButton.titleLabel.font = kFontSemibold(16);
    [checkupButton setTitle:@"去更新" forState:UIControlStateNormal];
    [checkupButton setTitleColor:WGRGBColor(255, 89, 159) forState:UIControlStateNormal];
    [checkupButton wg_setLayerRoundedCornersWithRadius:24];
    checkupButton.layer.borderColor = WGRGBColor(255, 69, 69).CGColor;
    checkupButton.layer.borderWidth = 1;
    [checkupButton addTarget:self action:@selector(checkupAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:checkupButton];
    [checkupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-20);
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
    [cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(bottomView);
        make.right.equalTo(lineView2.mas_left);
    }];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.titleLabel.font = kFontMedium(16);
    [sureButton setTitle:@"去更新" forState:UIControlStateNormal];
    [sureButton setTitleColor:WGRGBColor(255, 89, 159) forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(checkupAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:sureButton];
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(bottomView);
        make.left.equalTo(lineView2.mas_right);
    }];
    
    
    if (self.versionCheckUpdatesModel.force == 0){
        checkupButton.hidden = YES;
    }else if (self.versionCheckUpdatesModel.force == 1){
        bottomView.hidden = YES;
    }
    
}

#pragma mark - 按钮响应

//更新
- (void)checkupAction:(UIButton *)sender{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.versionCheckUpdatesModel.url] options:nil completionHandler:^(BOOL success) {
        //关闭弹窗
        if ((self.versionCheckUpdatesModel.force == 0) && success){
            [self cancelAction];
        }
    }];
}


//取消
- (void)cancelAction{
    
    if (self.checkUpdatesViewBlock){
        self.checkUpdatesViewBlock();
    }
}

@end

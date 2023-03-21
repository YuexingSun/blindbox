//
//  ZXLogoutTipsView.m
//  ZXHY
//
//  Created by Bern Mac on 9/26/21.
//

#import "ZXLogoutTipsView.h"


@interface ZXLogoutTipsView()

@property (nonatomic, strong) UILabel  *titleLabel;
@property (nonatomic, strong) UILabel  *contentLabel;

@property (nonatomic, strong) NSString  *titleStr;
@property (nonatomic, strong) NSString  *contentStr;
@property (nonatomic, strong) NSString  *sureStr;

@end


@implementation ZXLogoutTipsView

- (instancetype)initWithFrame:(CGRect)frame TipsTitle:(NSString *)titleStr Content:(NSString *)contentStr SureButtonTitle:(NSString *)sureStr;{
    if (self = [super initWithFrame:frame]) {
        
        self.titleStr = titleStr;
        self.contentStr = contentStr;
        self.sureStr = sureStr;
        
        [self zx_setUI];
    }
    return self;
}


#pragma mark - Initialization UI

- (void)zx_setUI{
    
    self.layer.cornerRadius = 15;
    self.backgroundColor =  UIColor.whiteColor;
    
    self.titleLabel = [UILabel labelWithFont:kFontMedium(18) TextAlignment:NSTextAlignmentCenter TextColor:WGGrayColor(0) TextStr:self.titleStr  NumberOfLines:1];
    
    self.contentLabel = [UILabel labelWithFont:kFontMedium(14) TextAlignment:NSTextAlignmentCenter TextColor:WGGrayColor(153) TextStr:self.contentStr NumberOfLines:0];
    
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(30);
        make.left.right.mas_equalTo(self);
        make.height.offset(25);
    }];
    
    [self addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.right.mas_equalTo(self.mas_right).offset(-10);
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
    [sureButton setTitle:self.sureStr forState:UIControlStateNormal];
    [sureButton setTitleColor:WGRGBColor(213, 43, 42) forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:sureButton];
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(bottomView);
        make.left.equalTo(lineView2.mas_right);
    }];
}

- (void)cancelAction:(UIButton *)sender{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(closeTipsView:)]){
        [self.delegate closeTipsView:self];
    }
    
}


- (void)sureAction:(UIButton *)sender{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(sureTipsView:)]){
        [self.delegate sureTipsView:self];
    }
}

@end

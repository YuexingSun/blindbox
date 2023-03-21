//
//  ZXReportWindowView.m
//  ZXHY
//
//  Created by Bern Lin on 2022/2/11.
//

#import "ZXReportWindowView.h"

@implementation ZXReportWindowView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}


- (void)setupUI{
    
    self.layer.cornerRadius = 15;
    self.backgroundColor =  UIColor.whiteColor;
    
    
    UILabel *titleLabel = [UILabel labelWithFont:kFontMedium(18) TextAlignment:NSTextAlignmentCenter TextColor:WGGrayColor(0) TextStr:@"确定要举报该条评论吗？"  NumberOfLines:1];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.left.right.mas_equalTo(self);
        make.height.offset(25);
    }];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.titleLabel.font = kFontMedium(16);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setBackgroundColor:WGRGBColor(240, 240, 240)];
    [cancelButton setTitleColor:WGGrayColor(153) forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.layer.cornerRadius = 5;
    cancelButton.layer.masksToBounds = YES;
    [self addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(20);
        make.right.equalTo(self.mas_centerX).offset(-15);
        make.width.offset(108);
        make.height.offset(40);
    }];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.titleLabel.font = kFontMedium(16);
    [sureButton setTitle:@"举报" forState:UIControlStateNormal];
    [sureButton setBackgroundColor:WGRGBColor(255, 62, 61)];
    [sureButton setTitleColor:WGRGBColor(255, 255, 255) forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    sureButton.layer.cornerRadius = 5;
    sureButton.layer.masksToBounds = YES;
    [self addSubview:sureButton];
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(20);
        make.left.equalTo(self.mas_centerX).offset(15);
        make.width.offset(108);
        make.height.offset(40);
    }];
    
}


- (void)cancelAction:(UIButton *)sender{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(closeReportWindowView:)]){
        [self.delegate closeReportWindowView:self];
    }
    
}


- (void)sureAction:(UIButton *)sender{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(sureReportWindowView:)]){
        [self.delegate sureReportWindowView:self];
    }
}
@end

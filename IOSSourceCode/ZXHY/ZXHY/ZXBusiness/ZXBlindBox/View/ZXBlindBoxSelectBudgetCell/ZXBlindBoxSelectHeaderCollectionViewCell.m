//
//  ZXBlindBoxSelectHeaderCollectionViewCell.m
//  Yunhuoyouxuan
//
//  Created by Bern on 2021/3/31.
//  Copyright © 2021 apple. All rights reserved.
//

#import "ZXBlindBoxSelectHeaderCollectionViewCell.h"
#import "ZXBlindBoxSelectViewModel.h"

@interface ZXBlindBoxSelectHeaderCollectionViewCell()

@property (nonatomic,strong) UILabel *brandNameLabel;
@property (nonatomic, strong) UIImageView  *backgroundImageView;

@end

@implementation ZXBlindBoxSelectHeaderCollectionViewCell

+ (NSString *)wg_cellIdentifier{
    return @"ZXBlindBoxSelectHeaderCollectionViewCellID";
}


- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        
        self.backgroundColor = UIColor.clearColor;

//        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:25];
//        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
//        maskLayer.frame = self.bounds;
//        maskLayer.path = maskPath.CGPath;
//        self.layer.mask = maskLayer;
//        CAShapeLayer *borderLayer = [CAShapeLayer layer];
//        borderLayer.path = maskPath.CGPath;
//        borderLayer.lineWidth = 0;
//        borderLayer.strokeColor = WGRGBAlpha(180, 172, 188, 1).CGColor;
//        borderLayer.fillColor = [UIColor clearColor].CGColor;
//        borderLayer.frame = self.bounds;
//        [self.layer addSublayer:borderLayer];
        
        
        self.backgroundImageView = [UIImageView wg_imageViewWithImageNamed:@"BlindBoxSelectBudgetImage"];
        self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.backgroundImageView];
        [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).offset(10);
            make.left.mas_equalTo(self.contentView).offset(-5);
            make.right.mas_equalTo(self.contentView.mas_right).offset(5);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(5);
        }];
        
        
        self.brandNameLabel = [[UILabel alloc]init];
        self.brandNameLabel.font = kFontBold(15);
        self.brandNameLabel.numberOfLines = 2;
        self.brandNameLabel.textAlignment = NSTextAlignmentCenter;
        self.brandNameLabel.textColor = WGGrayColor(161);
        self.brandNameLabel.backgroundColor = WGGrayColor(240);
        [self.contentView addSubview:self.brandNameLabel];
        [self.brandNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.mas_equalTo(self.contentView);
        }];
        self.brandNameLabel.layer.cornerRadius = 25;
        self.brandNameLabel.layer.masksToBounds = YES;
        
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
}


#pragma mark - Private Method
//数据赋值
- (void)zx_setBlindBoxSelectViewItemlistModel:(ZXBlindBoxSelectViewItemlistModel *)blindBoxSelectViewItemlistModel{
    if (!blindBoxSelectViewItemlistModel) return;
    
    self.brandNameLabel.text = blindBoxSelectViewItemlistModel.itemname;
    
    self.brandNameLabel.textColor = (blindBoxSelectViewItemlistModel.select) ? WGGrayColor(255) : WGGrayColor(161);
    
    self.brandNameLabel.backgroundColor = (blindBoxSelectViewItemlistModel.select) ? UIColor.clearColor :  WGGrayColor(240);
    
    self.backgroundImageView.hidden = (blindBoxSelectViewItemlistModel.select) ? NO : YES;
    
    
}

@end

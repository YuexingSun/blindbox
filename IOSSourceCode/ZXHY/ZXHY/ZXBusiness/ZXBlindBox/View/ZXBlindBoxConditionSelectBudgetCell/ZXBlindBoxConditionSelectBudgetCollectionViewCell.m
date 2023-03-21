//
//  ZXBlindBoxConditionSelectBudgetCollectionViewCell.m
//  ZXHY
//
//  Created by Bern Lin on 2021/11/19.
//

#import "ZXBlindBoxConditionSelectBudgetCollectionViewCell.h"
#import "ZXBlindBoxSelectViewModel.h"

@interface ZXBlindBoxConditionSelectBudgetCollectionViewCell()


@end



@implementation ZXBlindBoxConditionSelectBudgetCollectionViewCell

+ (NSString *)wg_cellIdentifier{
    return @"ZXBlindBoxConditionSelectBudgetCollectionViewCellID";
}


- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        
        self.backgroundColor = UIColor.clearColor;
        
        
        self.brandNameLabel = [[UILabel alloc]init];
        self.brandNameLabel.font = kFontSemibold(16);
        self.brandNameLabel.numberOfLines = 2;
        self.brandNameLabel.textAlignment = NSTextAlignmentCenter;
        self.brandNameLabel.textColor = WGGrayColor(172);
        self.brandNameLabel.backgroundColor = WGGrayColor(244);
        [self.contentView addSubview:self.brandNameLabel];
        [self.brandNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self.contentView);
            make.left.mas_equalTo(self.contentView).offset(5);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-5);
        }];
        self.brandNameLabel.layer.cornerRadius = 20;
        self.brandNameLabel.layer.masksToBounds = YES;
        
    }
    return self;
}


#pragma mark - Private Method
//数据赋值
- (void)zx_setBlindBoxSelectViewItemlistModel:(ZXBlindBoxSelectViewItemlistModel *)blindBoxSelectViewItemlistModel{
    if (!blindBoxSelectViewItemlistModel) return;
    
    self.brandNameLabel.text = blindBoxSelectViewItemlistModel.itemname;
    
    self.brandNameLabel.textColor = (blindBoxSelectViewItemlistModel.select) ? WGRGBColor(255, 82, 128) : WGGrayColor(172);
    
    self.brandNameLabel.backgroundColor = (blindBoxSelectViewItemlistModel.select) ? WGRGBAlpha(244, 154, 192, 0.2) :  WGGrayColor(244);
    
    
    self.brandNameLabel.layer.borderColor = (blindBoxSelectViewItemlistModel.select) ? WGRGBColor(255, 82, 128).CGColor : UIColor.clearColor.CGColor;
    self.brandNameLabel.layer.borderWidth = (blindBoxSelectViewItemlistModel.select) ? 1 : 0;
}

        
@end

//
//  ZXMineBoxDetailsEvaluationCollectionViewCell.m
//  ZXHY
//
//  Created by Bern Lin on 2021/11/1.
//

#import "ZXMineBoxDetailsEvaluationCollectionViewCell.h"
#import "ZXBlindBoxSelectViewModel.h"

@interface ZXMineBoxDetailsEvaluationCollectionViewCell()

@property (nonatomic,strong) UILabel *brandNameLabel;

@end

@implementation ZXMineBoxDetailsEvaluationCollectionViewCell

+ (NSString *)wg_cellIdentifier{
    return @"ZXMineBoxDetailsEvaluationCollectionViewCellID";
}

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        
        self.backgroundColor = UIColor.clearColor;
       
        
        
        self.brandNameLabel = [[UILabel alloc]init];
        self.brandNameLabel.font = kFont(14);
        self.brandNameLabel.numberOfLines = 1;
        self.brandNameLabel.textAlignment = NSTextAlignmentCenter;
        self.brandNameLabel.textColor = WGGrayColor(77);
        self.brandNameLabel.backgroundColor = WGGrayColor(255);
        [self.contentView addSubview:self.brandNameLabel];
        [self.brandNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(self.contentView).offset(5);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-5);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-5);
        }];
        self.brandNameLabel.layer.masksToBounds = YES;
        self.brandNameLabel.layer.cornerRadius = 20;
        self.brandNameLabel.layer.borderColor = WGRGBAlpha(0, 0, 0, 1).CGColor;
        self.brandNameLabel.layer.borderWidth = 1.2;
    }
    
    return self;
}


#pragma mark - Private Method
//数据赋值
- (void)zx_setBlindBoxSelectViewItemlistModel:(ZXBlindBoxSelectViewItemlistModel *)blindBoxSelectViewItemlistModel{
    if (!blindBoxSelectViewItemlistModel) return;
    
    self.brandNameLabel.text = blindBoxSelectViewItemlistModel.itemname;
    
    self.brandNameLabel.textColor = (blindBoxSelectViewItemlistModel.select) ? WGRGBColor(255, 74, 128) : WGGrayColor(206);
    
    self.brandNameLabel.layer.borderColor = (blindBoxSelectViewItemlistModel.select) ? WGRGBAlpha(255, 74, 129, 0.8).CGColor :  WGGrayColor(206).CGColor;

    self.brandNameLabel.backgroundColor =  (blindBoxSelectViewItemlistModel.select) ? WGRGBAlpha(248, 108, 151, 0.25) : WGGrayColor(255);
}


@end

//
//  ZXMineBoxDetailsScoreCell.m
//  ZXHY
//
//  Created by Bern Mac on 8/30/21.
//

#import "ZXMineBoxDetailsScoreCell.h"
#import "ZXStartView.h"
#import "ZXOpenResultsModel.h"

@interface ZXMineBoxDetailsScoreCell ()

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *consumptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *newnessLabel;
@property (weak, nonatomic) IBOutlet UILabel *mystiqueLabel;

@property (weak, nonatomic) IBOutlet UILabel *distanceValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *consumptionValueLabel;

@property (weak, nonatomic) IBOutlet UIView *newnessValueView;
@property (nonatomic, strong) ZXStartView  *newnessStartValueView;

@property (weak, nonatomic) IBOutlet UIView *mystiqueValueView;
@property (nonatomic, strong) ZXStartView  *mystiqueStartValueView;

@end


@implementation ZXMineBoxDetailsScoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.backView.layer.cornerRadius = 8;
    self.backView.clipsToBounds = YES;
    
    self.newnessStartValueView = [ZXStartView new];
    [self.newnessValueView addSubview:self.newnessStartValueView ];
    [self.newnessStartValueView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(self.newnessValueView);
        make.width.offset(85);
    }];
    
    
    self.mystiqueStartValueView = [ZXStartView new];
    [self.mystiqueValueView addSubview:self.mystiqueStartValueView ];
    [self.mystiqueStartValueView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(self.mystiqueValueView);
        make.width.offset(85);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

+ (NSString *)wg_cellIdentifier{
    return @"ZXMineBoxDetailsScoreCellID";
}


//数据赋值
- (void)zx_dataWithMineBoxResultsModel:(ZXOpenResultsModel *)resultsModel{
    
    ZXOpenResultsItemsModel *itemsModel = [resultsModel.items wg_safeObjectAtIndex:0];
    self.distanceLabel.text = [NSString stringWithFormat:@"%@",itemsModel.item];
    self.distanceValueLabel.text = [NSString stringWithFormat:@"%@",itemsModel.value];
    
    ZXOpenResultsItemsModel *itemsModel1 = [resultsModel.items wg_safeObjectAtIndex:1];
    self.consumptionLabel.text = [NSString stringWithFormat:@"%@",itemsModel1.item];
    self.consumptionValueLabel.text = [NSString stringWithFormat:@"%@",itemsModel1.value];
    
    ZXOpenResultsItemsModel *itemsModel2 = [resultsModel.items wg_safeObjectAtIndex:2];
    self.mystiqueLabel.text = [NSString stringWithFormat:@"%@",itemsModel2.item];
    
    ZXOpenResultsItemsModel *itemsModel3 = [resultsModel.items wg_safeObjectAtIndex:3];
    self.newnessLabel.text = [NSString stringWithFormat:@"%@",itemsModel3.item];
    
    [self.newnessStartValueView zx_scores:itemsModel2.value WithType:ZXStartType_Info];
    [self.mystiqueStartValueView zx_scores:itemsModel3.value WithType:ZXStartType_Info];
    
}
@end

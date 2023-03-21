//
//  ZXOpenResultsCollectionViewCell.m
//  ZXHY
//
//  Created by Bern Mac on 10/12/21.
//

#import "ZXOpenResultsCollectionViewCell.h"
#import "ZXStartView.h"
#import "ZXOpenResultsModel.h"

@interface ZXOpenResultsCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *resultsTagView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *consumptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *newnessLabel;
@property (weak, nonatomic) IBOutlet UILabel *mystiqueLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *consumptionValueLabel;
@property (weak, nonatomic) IBOutlet UIView *newnessValueView;
@property (weak, nonatomic) IBOutlet UIView *mystiqueValueView;
@property (nonatomic, strong) ZXStartView  *newnessStartValueView;
@property (nonatomic, strong) ZXStartView  *mystiqueStartValueView;
@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property (nonatomic, strong) NSIndexPath *indexPath;


@property (nonatomic, strong) ZXOpenResultsModel *resultsModel;
@end

@implementation ZXOpenResultsCollectionViewCell

+ (NSString *)wg_cellIdentifier{
    return @"ZXOpenResultsCollectionViewCellID";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backView.layer.cornerRadius = 15;
    self.backView.layer.shadowColor = WGGrayColor(166).CGColor;
    self.backView.layer.shadowOffset = CGSizeMake(0,2);
    self.backView.layer.shadowRadius = 3;
    self.backView.layer.shadowOpacity = 1;
    
    
    self.infoView.layer.cornerRadius = 8;
    
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

- (void)layoutSubviews{
    [super layoutSubviews];

    
}

- (void)zx_setDataWithResultModel:(ZXOpenResultsModel *)resultsModel ForItemAtIndexPath:(NSIndexPath *)indexPath{
 

    self.resultsModel = resultsModel;
    self.resultsModel.selectIndex = indexPath.row + 1;
    if (kObjectIsEmpty(resultsModel)) return;;
    
    NSString *typeStr = @"";
    NSString *boxImageStr = @"";
    NSString *resultsTagSrt = @"ResultsTagOrg";
    UIColor *backColor = WGRGBColor(255, 245, 230);
    UIColor *textColor = WGRGBColor(255, 119, 42);
    
    if (indexPath.row == 0){
        
        typeStr = @"正餐";
        boxImageStr = @"BoxEat";
        resultsTagSrt = @"ResultsTagOrg";
        backColor = WGRGBColor(255, 245, 230);
        textColor = WGRGBColor(255, 119, 42);
        
        
    }else if (indexPath.row == 1){
        
        typeStr = @"游玩";
        boxImageStr = @"BoxGame";
        resultsTagSrt = @"ResultsTagBlue";
        backColor = WGRGBColor(229, 244, 255);
        textColor = WGRGBColor(45, 154, 255);
        
    }else if (indexPath.row == 2){
        
        typeStr = @"小吃饮品";
        boxImageStr = @"BoxDrink";
        resultsTagSrt = @"ResultsTagPink";
        backColor = WGRGBColor(255, 229, 239);
        textColor = WGRGBColor( 255, 87, 127);
        
    }
    
    self.backView.backgroundColor = backColor;
    
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:resultsModel.typelogo] placeholderImage:IMAGENAMED(boxImageStr)];
    
    self.resultsTagView.image = IMAGENAMED(resultsTagSrt);
    
    self.typeLabel.text = resultsModel.typenameStr;
    
    self.titleLabel.text = resultsModel.title;
    self.titleLabel.textColor = textColor;
    
    ZXOpenResultsItemsModel *itemsModel = [resultsModel.items wg_safeObjectAtIndex:0];
    self.distanceLabel.text = [NSString stringWithFormat:@"%@",itemsModel.item];
    self.distanceValueLabel.text = [NSString stringWithFormat:@"%@",itemsModel.value];
    
    ZXOpenResultsItemsModel *itemsModel1 = [resultsModel.items wg_safeObjectAtIndex:1];
    self.consumptionLabel.text = [NSString stringWithFormat:@"%@",itemsModel1.item];
    self.consumptionValueLabel.text = [NSString stringWithFormat:@"%@",itemsModel1.value];
    
    ZXOpenResultsItemsModel *itemsModel2 = [resultsModel.items wg_safeObjectAtIndex:2];
    self.mystiqueLabel.text = [NSString stringWithFormat:@"%@",itemsModel2.item];
    [self.newnessStartValueView zx_scores:itemsModel2.value WithType:ZXStartType_Point];
    
    ZXOpenResultsItemsModel *itemsModel3 = [resultsModel.items wg_safeObjectAtIndex:3];
    self.newnessLabel.text = [NSString stringWithFormat:@"%@",itemsModel3.item];
    [self.mystiqueStartValueView zx_scores:itemsModel3.value WithType:ZXStartType_Point];
}


//马上启程
- (IBAction)goAction:(UIButton *)sender {
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(OpenResultsCollectionViewCell:OpenResultsModel:)]){
        [self.delegate OpenResultsCollectionViewCell:self OpenResultsModel:self.resultsModel];
    }
    
}



@end

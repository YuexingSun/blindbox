//
//  ZXBlindBoxTypeSelectCollectionViewCell.m
//  ZXHY
//
//  Created by Bern Lin on 2021/11/23.
//

#import "ZXBlindBoxTypeSelectCollectionViewCell.h"
#import "ZXStartView.h"
#import "ZXOpenResultsModel.h"


#define BannerHeight IS_IPHONE_X_SER ? 200 : 160

@interface ZXBlindBoxTypeSelectCollectionViewCell()

@property (nonatomic, strong) UIView       *bgView;
@property (nonatomic, strong) UIView       *imageBgView;
@property (nonatomic, strong) UIImageView  *bannerImageView;
@property (nonatomic, strong) UIImageView  *tipsLogoImageView;
@property (nonatomic, strong) UILabel      *titleLabel;
@property (nonatomic, strong) UILabel      *introduceLabel;
@property (nonatomic, strong) UILabel      *distanceLabel;
@property (nonatomic, strong) UILabel      *priceLabel;
@property (nonatomic, strong) ZXStartView  *newnessStartView;
@property (nonatomic, strong) ZXStartView  *mystiqueStartView;

@end

@implementation ZXBlindBoxTypeSelectCollectionViewCell


+ (NSString *)wg_cellIdentifier{
    return @"ZXBlindBoxSelectActivityCollectionViewCellID";
}


- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        
        self.backgroundColor = UIColor.clearColor;
        self.contentView.backgroundColor = UIColor.clearColor;
        
        [self zx_initializationUI];
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.imageBgView.layer.shadowColor = WGHEXAlpha(@"1A1A1A", 0.25).CGColor;
    self.imageBgView.layer.shadowOffset = CGSizeMake(0,10);
    self.imageBgView.layer.shadowRadius = 15;
    self.imageBgView.layer.shadowOpacity = 1;
    self.imageBgView.clipsToBounds = NO;

    
    self.bgView.layer.cornerRadius = 15;
    self.bgView.layer.masksToBounds = YES;
}



#pragma mark - Initialization UI
//初始化UI
- (void)zx_initializationUI{
    
    self.bgView = [UIView new];
    self.bgView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(7);
    }];
    
    UIView *imageBgView = [UIView new];
    [self.bgView addSubview:imageBgView];
    [imageBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.bgView);
        make.height.offset(BannerHeight);
    }];
    self.imageBgView = imageBgView;
    
    self.bannerImageView = [UIImageView wg_imageViewWithImageNamed:@""];
    self.bannerImageView.backgroundColor = UIColor.clearColor;
    self.bannerImageView.layer.cornerRadius = 15;
    self.bannerImageView.layer.masksToBounds = YES;
    [imageBgView addSubview:self.bannerImageView];
    [self.bannerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(imageBgView);
//        make.height.offset(BannerHeight);
    }];
    
    
    self.tipsLogoImageView = [UIImageView wg_imageViewWithImageNamed:@"FoodTipsLogo"];
    [self.contentView addSubview:self.tipsLogoImageView];
    [self.tipsLogoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bannerImageView.mas_top).offset(IS_IPHONE_X_SER ? 24 : 18);
        make.left.mas_equalTo(self.contentView);
        make.height.offset(IS_IPHONE_X_SER ? 38 : 30);
        make.width.offset(IS_IPHONE_X_SER ? 64 : 54);
    }];
    
    
    self.titleLabel = [UILabel labelWithFont:kFont(16) TextAlignment:NSTextAlignmentLeft TextColor:WGRGBAlpha(5, 3, 42, 0.65) TextStr:@"一寸脂肪一串爽?" NumberOfLines:1];
    [self.bgView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bannerImageView.mas_bottom).offset(22);
        make.left.equalTo(self.bgView.mas_left).offset(20);
        make.right.equalTo(self.bgView.mas_right).offset(-20);
        make.height.offset(17);
    }];
    
    
    self.introduceLabel = [UILabel labelWithFont:kFontSemibold(24) TextAlignment:NSTextAlignmentLeft TextColor:WGRGBColor(5, 3, 42) TextStr:@"忽悠文案还是得写忽悠文案还是得写忽悠文案还是得写忽悠文案还是得写" NumberOfLines:2];
    [self.bgView addSubview:self.introduceLabel];
    [self.introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.equalTo(self.bgView.mas_left).offset(20);
        make.right.equalTo(self.bgView.mas_right).offset(-8);
    }];
    
    
    
    UILabel *mystiqueLabel = [UILabel labelWithFont:kFont(16) TextAlignment:NSTextAlignmentLeft TextColor:WGRGBAlpha(4, 2, 42, 0.5) TextStr:@"神秘感" NumberOfLines:1];
    [self.bgView addSubview:mystiqueLabel];
    [mystiqueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-(IS_IPHONE_X_SER ? 30 : 22));
        make.left.equalTo(self.titleLabel);
        make.height.offset(15);
        make.width.offset(50);
        
    }];
    
    UILabel *newnessLabel = [UILabel labelWithFont:kFont(16) TextAlignment:NSTextAlignmentLeft TextColor:WGRGBAlpha(4, 2, 42, 0.5) TextStr:@"新鲜度" NumberOfLines:1];
    [self.bgView addSubview:newnessLabel];
    [newnessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(mystiqueLabel.mas_top).offset(-8);
        make.left.equalTo(self.titleLabel);
        make.height.width.mas_equalTo(mystiqueLabel);
    }];
    
    //距离
    UILabel *distanceTitleLabel = [UILabel labelWithFont:kFont(16) TextAlignment:NSTextAlignmentLeft TextColor:WGRGBAlpha(4, 2, 42, 0.5) TextStr:@"实时距离" NumberOfLines:1];
    [self.bgView addSubview:distanceTitleLabel];
    [distanceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(newnessLabel.mas_top).offset(-20);
        make.left.right.equalTo(self.titleLabel);
        make.height.offset(15);
    }];
    
    self.distanceLabel = [UILabel labelWithFont:kFontSemibold(40) TextAlignment:NSTextAlignmentLeft TextColor:WGRGBColor(255, 70, 146) TextStr:@"512m" NumberOfLines:1];
    [self.bgView addSubview:self.distanceLabel];
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(distanceTitleLabel.mas_top).offset(-5);
        make.left.right.equalTo(self.titleLabel);
        make.height.offset(40);
    }];
  
   
    
    
    //新鲜感星星
    self.newnessStartView = [ZXStartView new];
    [self.bgView addSubview:self.newnessStartView ];
    [self.newnessStartView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(newnessLabel);
        make.left.mas_equalTo(newnessLabel.mas_right).offset(8);
        make.width.offset(85);
        make.height.offset(15);
    }];
    
    //神秘感星星
    self.mystiqueStartView = [ZXStartView new];
    [self.bgView addSubview:self.mystiqueStartView ];
    [self.mystiqueStartView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(mystiqueLabel);
        make.left.mas_equalTo(self.newnessStartView);
        make.width.offset(85);
        make.height.offset(15);
    }];
    
    [self.newnessStartView zx_scores:@"4.5" WithType:ZXStartType_Info];
    [self.mystiqueStartView zx_scores:@"3" WithType:ZXStartType_Info];
    
    
    //价格文本
    self.priceLabel = [UILabel labelWithFont:kFontMedium(30) TextAlignment:NSTextAlignmentRight TextColor:WGRGBColor(255, 70, 146) TextStr:@"¥42" NumberOfLines:1];
    [self.bgView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.newnessStartView);
        make.left.equalTo(self.newnessStartView.mas_right).offset(3);
        make.right.equalTo(self.bgView.mas_right).offset(-20);
        make.height.offset(28);
    }];
    
    
    UILabel *priceTitleLabel = [UILabel labelWithFont:kFont(16) TextAlignment:NSTextAlignmentRight TextColor:WGRGBAlpha(4, 2, 42, 0.5) TextStr:@"人均消费" NumberOfLines:1];
    [self.bgView addSubview:priceTitleLabel];
    [priceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mystiqueStartView);
        make.left.right.equalTo(self.priceLabel);
        make.height.offset(15);
    }];
}


#pragma mark - Private Method
//数据处理
- (void)zx_openResultsModel:(ZXOpenResultsModel *)openResultsModel AtIndex:(NSUInteger)index{

    [self.bannerImageView sd_setImageWithURL:[NSURL URLWithString:openResultsModel.pic] placeholderImage:nil];
    
    self.titleLabel.text = openResultsModel.title;
    
    self.introduceLabel.text = openResultsModel.detail;
    
   
    //距离
    ZXOpenResultsItemsModel *itemsModel = [openResultsModel.items wg_safeObjectAtIndex:0];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:itemsModel.value];
    
    NSRange range = NSMakeRange(0, 0);
    if ([itemsModel.value containsString:@"公里"]){
        range = [[attributedString string] rangeOfString:@"公里"];
    } else if ([itemsModel.value containsString:@"米"]){
        range = [[attributedString string] rangeOfString:@"米"];
    }
    [attributedString addAttribute:NSFontAttributeName value:kFontSemibold(20) range:range];
    
    self.distanceLabel.attributedText = attributedString;
//    text = [NSString stringWithFormat:@"%@",itemsModel.value];
    
    //新鲜
    ZXOpenResultsItemsModel *itemsModel1 = [openResultsModel.items wg_safeObjectAtIndex:3];
    [self.newnessStartView zx_scores:itemsModel1.value WithType:ZXStartType_Info];
    
    //神秘
    ZXOpenResultsItemsModel *itemsModel2 = [openResultsModel.items wg_safeObjectAtIndex:2];
    [self.mystiqueStartView zx_scores:itemsModel2.value WithType:ZXStartType_Info];
    
    //人均消费
    ZXOpenResultsItemsModel *itemsModel3 = [openResultsModel.items wg_safeObjectAtIndex:1];
    NSMutableAttributedString *attributedString3 = [[NSMutableAttributedString alloc]initWithString:itemsModel3.value];
    NSRange range3 = NSMakeRange(0, 0);
    if ([itemsModel3.value containsString:@"¥"]){
        range3 = [[attributedString3 string] rangeOfString:@"¥"];
    }else if ([itemsModel3.value containsString:@"￥"]){
        range3 = [[attributedString3 string] rangeOfString:@"￥"];
    }
    [attributedString3 addAttribute:NSFontAttributeName value:kFontSemibold(20) range:range3];
    self.priceLabel.attributedText = attributedString3;
    
    
    
    //tipsLogo
    NSString *imageStr = @"";
    if (index == 0){
        imageStr = @"FoodTipsLogo";
    } else if (index == 1){
        imageStr = @"playHappy";
    } else if (index == 2){
        imageStr = @"smallFood";
    }
    self.tipsLogoImageView.image = IMAGENAMED(imageStr);
    
    [self.tipsLogoImageView sd_setImageWithURL:[NSURL URLWithString:openResultsModel.typelogo] placeholderImage:nil];
    
}
@end

//
//  ZXMapNavResultsheaderViewCell.m
//  ZXHY
//
//  Created by Bern Lin on 2021/11/3.
//

#import "ZXMapNavResultsheaderViewCell.h"
#import "ZXStartView.h"
#import "ZXReachedNumView.h"
#import "ZXOpenResultsModel.h"


@interface ZXMapNavResultsheaderViewCell ()

@property (nonatomic, strong) ZXOpenResultsModel *openResultsModel;

@property (nonatomic, strong) UIView *infoView;;
@property (nonatomic, strong) UIImageView  *infoImageView;
@property (nonatomic, strong) UILabel  *infoNameLabel;
@property (nonatomic, strong) UILabel  *infoAddressLabel;
@property (nonatomic, strong) UIView  *infoArrivedBgView;
@property (nonatomic, strong) UIImageView  *infoArrivedBgImageView;
@property (nonatomic, strong) UILabel  *infoArrivedtextLabel;
//星星✨
@property (nonatomic, strong) ZXStartView  *startView;
//来过人数View
@property (nonatomic, strong) ZXReachedNumView *reachedView;


@end

@implementation ZXMapNavResultsheaderViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)wg_cellIdentifier{
    return @"ZXMapNavResultsheaderViewCellID";
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self setupUI];
    }
    return self;
}

#pragma mark - Private Method
//设置UI
- (void)setupUI{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = UIColor.clearColor;
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.backgroundColor = UIColor.clearColor;
    
    
    //TopView
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 216, 65)];;
    [topView wg_setRoundedCornersWithRadius:8];
    NSArray * colors = @[WGRGBColor(253, 226, 237),WGRGBColor(255, 243, 214)];
    [topView wg_backgroundGradientHorizontalColors:colors];
    [self.contentView addSubview:topView];
    

    UILabel *tipsLabel1 = [UILabel labelWithFont:kFontMedium(16) TextAlignment:NSTextAlignmentLeft TextColor:WGRGBColor(255, 57, 152) TextStr:@"到达目的地" NumberOfLines:1];
    [topView addSubview:tipsLabel1];
    [tipsLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView).offset(10);
        make.left.mas_equalTo(topView).offset(15);
        make.height.offset(25);
    }];
    
    
    UIImageView *luckImageView = [UIImageView wg_imageViewWithImageNamed:@"Luck"];
    [topView addSubview:luckImageView];
    [luckImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tipsLabel1);
        make.left.mas_equalTo(tipsLabel1.mas_right).offset(10);
        make.width.offset(95);
        make.height.offset(22);
    }];
    
    
    //infoView
    UIView *infoView = [UIView new];
    infoView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:infoView];
    [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(45);
        make.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-70);
    }];
    self.infoView = infoView;
    self.infoView.layer.cornerRadius = 8;
    self.infoView.clipsToBounds = NO;
    self.infoView.layer.shadowColor =  WGHEXAlpha(@"828282", 0.25).CGColor;
    self.infoView.layer.shadowOffset = CGSizeMake(0,-4);
    self.infoView.layer.shadowRadius = 3;
    self.infoView.layer.shadowOpacity = 1;
    
    
    self.infoImageView = [UIImageView wg_imageViewWithImageNamed:@""];
    [infoView addSubview:self.infoImageView];
    [self.infoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(infoView).offset(10);
        make.width.height.offset(75);
    }];
    
    
    
    self.infoNameLabel = [UILabel labelWithFont:kFont(18) TextAlignment:NSTextAlignmentLeft TextColor:UIColor.blackColor TextStr:@"悦行咖啡" NumberOfLines:2];
    [infoView addSubview:self.infoNameLabel];
    [self.infoNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.infoImageView);
        make.left.mas_equalTo(self.infoImageView.mas_right).offset(15);
        make.right.mas_equalTo(infoView.mas_right).offset(-15);
    }];
    
    
    //星星
    ZXStartView *startView = [ZXStartView new];
    [infoView addSubview:startView];
    [startView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.infoNameLabel.mas_bottom).offset(15);
        make.left.mas_equalTo(self.infoImageView.mas_right).offset(15);
        make.right.mas_equalTo(infoView.mas_right).offset(-15);
        make.height.offset(20);
    }];
    self.startView = startView;
    
    
    self.infoAddressLabel = [UILabel labelWithFont:kFont(14) TextAlignment:NSTextAlignmentLeft TextColor:WGRGBAlpha(0, 0, 0, 0.5) TextStr:@"华夏路28号富力盈信大厦3楼" NumberOfLines:0];
    [infoView addSubview:self.infoAddressLabel];
    [self.infoAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(startView.mas_bottom).offset(15);
        make.left.right.mas_equalTo(self.infoNameLabel);
    }];
    
    self.infoArrivedBgView = [UIView new];
    self.infoArrivedBgView.backgroundColor = UIColor.whiteColor;
    [infoView addSubview:self.infoArrivedBgView];
    [self.infoArrivedBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.infoAddressLabel.mas_bottom).offset(15);
        make.bottom.left.right.mas_equalTo(infoView);
    }];
    
    
    self.infoArrivedBgImageView = [UIImageView wg_imageViewWithImageNamed:@""];
    self.infoArrivedBgImageView.alpha = 0.3;
    [self.infoArrivedBgView addSubview:self.infoArrivedBgImageView];
    [self.infoArrivedBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.right.left.mas_equalTo(self.infoArrivedBgView);
        make.centerY.mas_equalTo(self.infoArrivedBgView);
        make.right.mas_equalTo(self.infoArrivedBgView.mas_right).offset(-15);
        make.width.offset(60);
        make.height.offset(55);
    }];
    
    
    self.infoArrivedtextLabel = [UILabel labelWithFont:kFontMedium(15) TextAlignment:NSTextAlignmentLeft TextColor:UIColor.blackColor TextStr:@"此时的你" NumberOfLines:0];
    [self.infoArrivedBgView addSubview:self.infoArrivedtextLabel];
    [self.infoArrivedtextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.infoArrivedBgView).offset(15);
        make.left.mas_equalTo(self.infoArrivedBgView).offset(15);
        make.right.mas_equalTo(self.infoArrivedBgView.mas_right).offset(-15);
        make.bottom.mas_equalTo(self.infoArrivedBgView.mas_bottom).offset(-15);
    }];
    
    
    //来过人数View
    ZXReachedNumView *reachedView = [ZXReachedNumView new];
    [self.contentView addSubview:reachedView];
    [reachedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(infoView.mas_bottom);
        make.left.right.mas_equalTo(self);
        make.height.offset(70);
    }];
    self.reachedView = reachedView;
}

//遍历特殊文本
- (void)zx_attributedText{
    
    NSString *mainStr = self.openResultsModel.arrivedtext;

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:mainStr];
    
    for (int i = 0; i < self.openResultsModel.arrivedvarlist.count; i++){
        
        NSString *placeStr =  [NSString stringWithFormat:@" %@ ",[self.openResultsModel.arrivedvarlist wg_safeObjectAtIndex:i]];
        
        NSString *str = [NSString stringWithFormat:@"{{SJTL%d}}",i + 1];
        
        if ([mainStr containsString:str]){
           
            NSRange range = [[attributedString string] rangeOfString:str];
            [attributedString addAttribute:NSForegroundColorAttributeName value:WGHEXColor(self.openResultsModel.colorlist.textcolor) range:range];
            [attributedString addAttribute:NSFontAttributeName value:kFontSemibold(16) range:range];
            [attributedString replaceCharactersInRange:range withString:placeStr];
            
        }
        
    }
    self.infoArrivedtextLabel.attributedText = attributedString;
    
}

//数据赋值
- (void)zx_openResultsModel:(ZXOpenResultsModel *)openResultsModel{
    
    self.openResultsModel = openResultsModel;
    
    self.infoNameLabel.text = self.openResultsModel.realname;

    self.infoAddressLabel.text = self.openResultsModel.address;
    
    [self.infoImageView wg_setImageWithURL:[NSURL URLWithString:self.openResultsModel.logo] placeholderImage:nil];
    
    self.infoArrivedtextLabel.text = self.openResultsModel.arrivedtext;
    [self zx_attributedText];
    
   
    
    [self.infoArrivedBgImageView sd_setImageWithURL:[NSURL URLWithString:self.openResultsModel.typelogo] placeholderImage:nil];
    
    [self.startView zx_scores:self.openResultsModel.point WithType:ZXStartType_Point];
    
    [self.reachedView zx_resultsheaderViewOpenResultsModel:self.openResultsModel];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    NSArray * colors = @[WGHEXColor(self.openResultsModel.colorlist.varcolor),WGRGBColor(255, 255, 255)];
    [self.infoArrivedBgView wg_backgroundGradientHorizontalColors:colors];
}

@end

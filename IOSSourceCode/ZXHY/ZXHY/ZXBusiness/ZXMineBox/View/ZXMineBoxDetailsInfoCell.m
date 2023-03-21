//
//  ZXMineBoxDetailsInfoCell.m
//  ZXHY
//
//  Created by Bern Mac on 8/30/21.
//

#import "ZXMineBoxDetailsInfoCell.h"
#import "ZXStartView.h"
#import "ZXOpenResultsModel.h"


@interface ZXMineBoxDetailsInfoCell ()

@property (nonatomic, strong) UIImageView  *infoImageView;
@property (nonatomic, strong) UILabel  *infoNameLabel;
@property (nonatomic, strong) UILabel  *infoAddressLabel;
@property (nonatomic, strong) UIView  *infoArrivedBgView;
@property (nonatomic, strong) UILabel  *infoArrivedtextLabel;
@property (nonatomic, strong) ZXStartView  *startView;

@end


@implementation ZXMineBoxDetailsInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)wg_cellIdentifier{
    return @"ZXMineBoxDetailsInfoCellID";
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self initSubView];
    }
    return self;
}

- (void)initSubView{
    
    self.backgroundColor = UIColor.clearColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *infoView = [UIView new];
    infoView.layer.cornerRadius = 8;
    infoView.clipsToBounds = YES;
    infoView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:infoView];
    [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(5);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-5);
        make.left.mas_equalTo(self.contentView).offset(15);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
    }];
//    [infoView  layoutIfNeeded];
//    [infoView  wg_setRoundedCornersWithRadius:5];

    
    self.infoImageView = [UIImageView wg_imageViewWithImageNamed:@""];
    [infoView addSubview:self.infoImageView];
    [self.infoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(infoView).offset(10);
        make.width.height.offset(75);
    }];
    
    self.infoNameLabel = [UILabel labelWithFont:kFont(18) TextAlignment:NSTextAlignmentLeft TextColor:UIColor.blackColor TextStr:@"-" NumberOfLines:2];
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
    
    
    self.infoAddressLabel = [UILabel labelWithFont:kFont(14) TextAlignment:NSTextAlignmentLeft TextColor:WGRGBAlpha(0, 0, 0, 0.5) TextStr:@"-" NumberOfLines:0];
    [infoView addSubview:self.infoAddressLabel];
    [self.infoAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(startView.mas_bottom).offset(15);
        make.left.right.mas_equalTo(self.infoNameLabel);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-15);
    }];
}

//数据赋值
- (void)zx_dataWithMineBoxResultsModel:(ZXOpenResultsModel *)resultsModel{
    
    self.infoNameLabel.text = resultsModel.realname;
    
    self.infoAddressLabel.text = resultsModel.address;
    
    [self.startView zx_scores:resultsModel.point WithType:ZXStartType_Point];
    
    [self.infoImageView wg_setImageWithURL:[NSURL URLWithString:resultsModel.logo] placeholderImage:nil];
    
}

@end

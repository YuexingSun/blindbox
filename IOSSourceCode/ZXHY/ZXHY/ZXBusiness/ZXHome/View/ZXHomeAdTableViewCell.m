//
//  ZXHomeAdTableViewCell.m
//  ZXHY
//
//  Created by Bern Lin on 2021/12/22.
//

#import "ZXHomeAdTableViewCell.h"
#import "ZXHomeModel.h"


@interface ZXHomeAdTableViewCell()

@property (nonatomic, strong) UIView  *shadowView;
@property (nonatomic, strong) UIImageView  *bgImageView;

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong)  UILabel *nameLabel;

@property (nonatomic, strong)  UILabel *pinyinLabel;

@property (nonatomic, strong)  UILabel *contentLabel;

@property (nonatomic, strong) UILabel *openBoxLabel;
@property (nonatomic, strong) UIButton *openBoxButton;

@end

@implementation ZXHomeAdTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)wg_cellIdentifier{
    return @"ZXHomeAdTableViewCellID";
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self initSubView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.shadowView.layer.cornerRadius = 8;
    self.shadowView.layer.shadowColor = WGHEXAlpha(@"000000", 0.10).CGColor;
    self.shadowView.layer.shadowOffset = CGSizeMake(0,4);
    self.shadowView.layer.shadowRadius = 3;
    self.shadowView.layer.shadowOpacity = 1;
    self.shadowView.clipsToBounds = NO;
    
//    self.bgView.layer.cornerRadius = 8;
//    self.bgView.layer.masksToBounds = YES;
}


- (void)initSubView{
    
    self.backgroundColor = UIColor.clearColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    //投影View
    self.shadowView = [UIView new];
    self.shadowView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:self.shadowView];
    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(40);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-5);
        make.left.mas_equalTo(self.contentView).offset(12);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-12);
        
    }];
    
    //背景
    self.bgImageView = [UIImageView wg_imageViewWithImageNamed:@""];
    self.bgImageView.alpha = 0.15;
    self.bgImageView.contentMode = UIViewContentModeScaleToFill;
    [self.bgImageView wg_setLayerRoundedCornersWithRadius:8];
    [self.contentView addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(40);
        make.left.mas_equalTo(self.contentView).offset(12);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-12);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-5);
    }];
    
    
    //头像
    self.iconImageView = [UIImageView wg_imageViewWithImageNamed:@""];
    [self.iconImageView wg_setLayerRoundedCornersWithRadius:8];
    [self.contentView addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(15);
        make.left.mas_equalTo(self.bgImageView.mas_left).offset(15);
        make.width.height.offset(95);
    }];

    //名字
    self.nameLabel = [UILabel labelWithFont:kFontSemibold(24) TextAlignment:NSTextAlignmentLeft TextColor:WGRGBAlpha(51, 51, 51, 1) TextStr:@"" NumberOfLines:1];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgImageView.mas_top).offset(15);
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(20);
        make.right.mas_equalTo(self.bgImageView.mas_right).offset(-10);
    }];

    //拼音
    self.pinyinLabel = [UILabel labelWithFont:kFontSemibold(14) TextAlignment:NSTextAlignmentLeft TextColor:WGRGBAlpha(248, 110, 151, 1) TextStr:@"" NumberOfLines:1];
    [self.contentView addSubview:self.pinyinLabel];
    [self.pinyinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(2);
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(20);
        make.right.mas_equalTo(self.bgImageView.mas_right).offset(-10);
    }];
    

    
    //================开盒view================
    UIView *openView = [UIView new];
    openView.backgroundColor = WGRGBColor(248, 110, 151);
    [openView wg_setLayerRoundedCornersWithRadius:18];
    [self.contentView addSubview:openView];
    [openView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.right.mas_equalTo(self.bgImageView.mas_right).offset(-20);
       make.bottom.mas_equalTo(self.bgImageView.mas_bottom).offset(-20);
       make.height.offset(36);
   }];
    
    UIImageView *openImageView = [UIImageView wg_imageViewWithImageNamed:@"homeOpenRight"];
    [openView addSubview:openImageView];
    [openImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(openView);
        make.right.mas_equalTo(openView.mas_right).offset(-12);
        make.width.height.offset(24);
    }];
    
    //开盒按钮文本
    self.openBoxLabel = [UILabel labelWithFont:kFontSemibold(14) TextAlignment:NSTextAlignmentRight TextColor:WGRGBAlpha(255, 255, 255, 1) TextStr:@"去开个盲盒" NumberOfLines:1];
    [openView addSubview:self.openBoxLabel];
    [self.openBoxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(openImageView);
        make.right.mas_equalTo(openImageView.mas_left).offset(-8);
        make.left.mas_equalTo(openView.mas_left).offset(15);
    }];
    
    //开盒按钮
    self.openBoxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.openBoxButton.adjustsImageWhenHighlighted = NO;
    self.openBoxButton.backgroundColor = UIColor.clearColor;
    self.openBoxButton.userInteractionEnabled = NO;
    [openView addSubview:self.openBoxButton];
    [self.openBoxButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(openView);
    }];
    
    //介绍
    UILabel *contentLabel = [UILabel labelWithFont:kFont(16) TextAlignment:NSTextAlignmentLeft TextColor:WGGrayColor(51) TextStr:@"" NumberOfLines:0];
    [self.contentView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(15);
        make.left.mas_equalTo(self.iconImageView);
        make.right.mas_equalTo(self.nameLabel);
        make.bottom.mas_equalTo(openView.mas_top).offset(-20);
    }];
    self.contentLabel = contentLabel;
    
}




- (void)zx_setListModel:(ZXHomeListModel *)listModel{
    
    if (kObjectIsEmpty(listModel)) return;;
    
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[listModel.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    self.contentLabel.attributedText = attrStr;
    self.contentLabel.font = kFont(16);
    
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:listModel.banner] placeholderImage:IMAGENAMED(@"placeholderImage")];
    
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:listModel.bgimg] placeholderImage:IMAGENAMED(@"placeholderImage")];
    
    self.nameLabel.text = listModel.title;
    self.pinyinLabel.text = listModel.subtitle;
    
    self.openBoxLabel.text = listModel.btntxt;
    
    self.openBoxButton.userInteractionEnabled = YES;
}

@end

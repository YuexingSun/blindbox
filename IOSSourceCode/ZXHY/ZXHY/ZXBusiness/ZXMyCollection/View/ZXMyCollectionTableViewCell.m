//
//  ZXMyCollectionTableViewCell.m
//  ZXHY
//
//  Created by Bern Lin on 2022/1/6.
//

#import "ZXMyCollectionTableViewCell.h"
#import "ZXMyCollectionModel.h"


@interface ZXMyCollectionTableViewCell()

@property (nonatomic, strong) UIView  *bgView;
@property (nonatomic, strong) UIImageView *bannerView;
@property (nonatomic, strong)  UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong)  UILabel *nameLabel;
@property (nonatomic, strong) ZXMyCollectionListModel *listModel;

@end

@implementation ZXMyCollectionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)wg_cellIdentifier{
    return @"ZXMyCollectionTableViewCell";
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
    self.contentView.backgroundColor = UIColor.clearColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //背景
    UIView *bgView = [UIView new];
    bgView.layer.cornerRadius = 4;
    bgView.layer.masksToBounds = YES;
    bgView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(5);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-5);
        make.left.right.mas_equalTo(self.contentView);
    }];
    self.bgView = bgView;
    
    //bannerView
    self.bannerView = [UIImageView wg_imageViewWithImageNamed:@""];
    self.bannerView.contentMode = UIViewContentModeScaleAspectFill;
    self.bannerView.layer.cornerRadius = 4;
    self.bannerView.layer.masksToBounds = YES;
    [bgView addSubview:self.bannerView];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bgView);
        make.left.mas_equalTo(bgView.mas_left).offset(12);
        make.width.height.offset(75);
    }];
    
    //头像
    UIImageView *iconView = [UIImageView wg_imageViewWithImageNamed:@""];
    [iconView wg_setLayerRoundedCornersWithRadius:12];
    [bgView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bannerView.mas_bottom);
        make.left.mas_equalTo(self.bannerView.mas_right).offset(12);
        make.width.height.offset(24);
    }];
    self.iconView = iconView;
    
    //名字
    UILabel *nameLabel = [UILabel labelWithFont:kFontMedium(14) TextAlignment:NSTextAlignmentLeft TextColor:WGRGBAlpha(51, 51, 51, 0.8) TextStr:@"空手劈榴莲QAQ" NumberOfLines:1];
    [bgView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(iconView);
        make.left.mas_equalTo(iconView.mas_right).offset(4);
        make.right.mas_equalTo(bgView.mas_right).offset(-10);
    }];
    self.nameLabel = nameLabel;
    
    //标题
    UILabel *titleLabel = [UILabel labelWithFont:kFontSemibold(14) TextAlignment:NSTextAlignmentLeft TextColor:WGGrayColor(51) TextStr:@"佛山探店｜这大概是佛山最京都的庭院下午茶佛山探店｜这大概是佛山最京都的庭院下午茶佛山探店｜这大概是佛山最京都的庭院下午茶" NumberOfLines:2];
    [bgView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bannerView.mas_top);
        make.left.mas_equalTo(self.bannerView.mas_right).offset(12);
        make.right.mas_equalTo(bgView.mas_right).offset(-10);
    }];
    self.titleLabel = titleLabel;
}


//数据赋值
- (void)zx_setListModel:(ZXMyCollectionListModel *)listModel{
    
    self.listModel = listModel;
    
    [self.bannerView wg_setImageWithURL:[NSURL URLWithString:listModel.banner] placeholderImage:IMAGENAMED(@"placeholderImage")];
    
    self.titleLabel.text = listModel.title;
    
    [self.iconView wg_setImageWithURL:[NSURL URLWithString:listModel.avatar] placeholderImage:IMAGENAMED(@"placeholderImage")];
    
    self.nameLabel.text = listModel.nickname;
    
}
@end

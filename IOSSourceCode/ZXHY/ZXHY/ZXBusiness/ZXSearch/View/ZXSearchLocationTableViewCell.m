//
//  ZXSearchLocationTableViewCell.m
//  ZXHY
//
//  Created by Bern Lin on 2021/12/31.
//

#import "ZXSearchLocationTableViewCell.h"


@interface ZXSearchLocationTableViewCell()

@property (nonatomic, strong) UIImageView  *selectImageView;
@property (nonatomic, strong) UILabel   *nameLabel;
@property (nonatomic, strong) UILabel  *contentLabel;

@end

@implementation ZXSearchLocationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)wg_cellIdentifier{
    return @"ZXSearchLocationTableViewCell";
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
    
    //选中
    self.selectImageView = [UIImageView wg_imageViewWithImageNamed:@"LocationSelect"];
    self.selectImageView.hidden = YES;
    [self.contentView addSubview:self.selectImageView];
    [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.width.height.offset(32);
    }];

    //名字
    self.nameLabel = [UILabel labelWithFont:kFontSemibold(15) TextAlignment:NSTextAlignmentLeft TextColor:WGRGBAlpha(51, 51, 51, 1) TextStr:@"" NumberOfLines:1];
    self.nameLabel.frame = CGRectMake(15, 10, WGNumScreenWidth() - 87 , 20);
    [self.contentView addSubview:self.nameLabel];

    
    //
    self.contentLabel = [UILabel labelWithFont:kFont(12) TextAlignment:NSTextAlignmentLeft TextColor:WGRGBAlpha(153, 153, 153, 1) TextStr:@"" NumberOfLines:1];
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(2);
        make.left.right.mas_equalTo(self.nameLabel);
        make.height.offset(20);
    }];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = WGGrayColor(221);
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.left.mas_equalTo(self.nameLabel);
        make.right.mas_equalTo(self.contentView);
        make.height.offset(1);
    }];
    
}

- (void)zx_setAMapPOI:(AMapPOI *)mapPOI{
    
    self.contentLabel.height = ([mapPOI.uid isEqualToString:@"不显示地点"]);

    self.nameLabel.text =  mapPOI.name;
    self.contentLabel.text = [NSString stringWithFormat:@"%@%@%@",mapPOI.city,mapPOI.district,mapPOI.address];

    self.nameLabel.mj_y = ([mapPOI.uid isEqualToString:@"不显示地点"]) ? 20 : 10;
}

@end

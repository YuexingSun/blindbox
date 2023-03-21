//
//  ZXMapNavTelephoneTableViewCell.m
//  ZXHY
//
//  Created by Bern Lin on 2022/1/14.
//

#import "ZXMapNavTelephoneTableViewCell.h"

@implementation ZXMapNavTelephoneTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (NSString *)wg_cellIdentifier{
    return @"ZXMapNavTelephoneTableViewCell";
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
    self.contentView.backgroundColor = UIColor.clearColor;
    
    UIImageView *logoImgView = [UIImageView wg_imageViewWithImageNamed:@"NaviTelPhone"];
    [self.contentView addSubview:logoImgView];
    [logoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView.mas_left).offset(32);
        make.width.height.offset(28);
    }];
    
    UILabel *numberLabel = [UILabel labelWithFont:kFontMedium(16) TextAlignment:NSTextAlignmentLeft TextColor:UIColor.blackColor TextStr:@"" NumberOfLines:1];
    [self.contentView addSubview:numberLabel];
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(logoImgView);
        make.left.mas_equalTo(logoImgView.mas_right).offset(12);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-12);
    }];
    self.numberLabel = numberLabel;
    
    //分割线
    UIView *lineVeiw = [UIView new];
    lineVeiw.backgroundColor = WGGrayColor(239);
    [self.contentView addSubview:lineVeiw];
    [lineVeiw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.left.mas_equalTo(numberLabel);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-30);
        make.height.offset(1);
    }];
    
}
@end

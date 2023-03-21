//
//  ZXMineSetHeaderTableViewCell.m
//  ZXHY
//
//  Created by Bern Mac on 1/4/22.
//

#import "ZXMineSetHeaderTableViewCell.h"
#import "ZXMineModel.h"

@interface ZXMineSetHeaderTableViewCell ()

@property (nonatomic, strong) UIView  *bgView;
@property (nonatomic, strong) UIImageView  *iconView;
@property (nonatomic, strong) UILabel  *nameLabel;
@property (nonatomic, strong) UILabel  *ageLabel;
@property (nonatomic, strong) UIImageView  *sexImageView;
@property (nonatomic, strong) UIImageView  *rightImageView;

@property (nonatomic, strong) ZXMineUserProfileModel  *userProfileModel;

@end

@implementation ZXMineSetHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)wg_cellIdentifier{
    return @"ZXMineSetHeaderTableViewCell";
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self zx_initializationUI];
    }
    return self;
}

//初始化UI
- (void)zx_initializationUI{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = UIColor.clearColor;
    self.contentView.backgroundColor = UIColor.clearColor;
    
    UIView *bgView = [UIView new];
    bgView.backgroundColor = UIColor.whiteColor;
//    bgView.frame = CGRectMake(15, 0, WGNumScreenWidth() - 30, 60);
    bgView.layer.cornerRadius = 12;
    bgView.layer.masksToBounds = YES;
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(15);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.top.bottom.mas_equalTo(self.contentView);
    }];
    self.bgView = bgView;
    
    self.iconView = [UIImageView wg_imageViewWithImageNamed:@""];
    self.iconView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconView.layer.cornerRadius = 33;
    self.iconView.layer.masksToBounds = YES;
    [bgView addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView).offset(15);
        make.centerY.mas_equalTo(self.bgView);
        make.width.height.offset(66);
    }];

    self.rightImageView = [UIImageView wg_imageViewWithImageNamed:@"arrow_Right"];
    [bgView addSubview:self.rightImageView];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(bgView.mas_right).offset(-15);
        make.centerY.mas_equalTo(bgView);
        make.height.offset(17);
        make.width.offset(10);
    }];

    self.nameLabel = [UILabel labelWithFont:kFontSemibold(16) TextAlignment:NSTextAlignmentLeft TextColor:WGGrayColor(0) TextStr:@"用户名" NumberOfLines:1];
    [bgView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).offset(12);
        make.top.mas_equalTo(self.iconView.mas_top).offset(12);
        make.right.mas_equalTo(self.rightImageView.mas_left).offset(-10);
        make.height.offset(20);
    }];

    self.sexImageView = [UIImageView wg_imageViewWithImageNamed:@"meMan"];
    [bgView addSubview:self.sexImageView];
    [self.sexImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel);
        make.bottom.mas_equalTo(self.iconView.mas_bottom).offset(-6);
        make.height.width.offset(16);
    }];
    
    self.ageLabel = [UILabel labelWithFont:kFontSemibold(14) TextAlignment:NSTextAlignmentLeft TextColor:WGRGBColor(180, 172, 188) TextStr:@"18岁" NumberOfLines:1];
    [bgView addSubview:self.ageLabel];
    [self.ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.sexImageView.mas_right).offset(5);
        make.centerY.mas_equalTo(self.sexImageView);
        make.right.mas_equalTo(self.nameLabel);
        make.height.offset(20);
    }];

}



- (void)zx_setDataWithMineSetType:(ZXMineSetType )mineSetType UserProfileModel:(ZXMineUserProfileModel *)userProfileModel{
   
    self.userProfileModel = userProfileModel;
    
    [self.iconView wg_setImageWithURL:[NSURL URLWithString:self.userProfileModel.headimg]];
    self.nameLabel.text = self.userProfileModel.nickname;
    self.ageLabel.text = self.userProfileModel.age;
    
    if ([userProfileModel.sex intValue] == 0){
        self.sexImageView.image = IMAGENAMED(@"meWoman");
    }else{
        self.sexImageView.image = IMAGENAMED(@"meMan");
    }
    
}

@end

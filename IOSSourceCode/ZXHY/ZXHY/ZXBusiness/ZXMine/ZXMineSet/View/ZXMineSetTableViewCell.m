//
//  ZXMineSetTableViewCell.m
//  ZXHY
//
//  Created by Bern Mac on 9/23/21.
//

#import "ZXMineSetTableViewCell.h"

#import "ZXMineModel.h"

@interface ZXMineSetTableViewCell ()

@property (nonatomic, strong) UIView  *bgView;
@property (nonatomic, strong) UIImageView  *iconView;
@property (nonatomic, strong) UILabel  *titleLabel;
@property (nonatomic, strong) UILabel  *infoLabel;
@property (nonatomic, strong) UILabel  *centerLabel;
@property (nonatomic, strong) UIImageView  *rightImageView;
@property (nonatomic, strong) UISwitch * switchButton;

@property (nonatomic, strong) ZXMineUserProfileModel  *userProfileModel;

@end

@implementation ZXMineSetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self zx_initializationUI];
    }
    return self;
}


+ (NSString *)wg_cellIdentifier{
    return @"ZXMineSetTableViewCellID";
}

#pragma mark - Initialization UI
//初始化UI
- (void)zx_initializationUI{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = UIColor.clearColor;
    self.contentView.backgroundColor = UIColor.clearColor;
    
    UIView *bgView = [UIView new];
    bgView.backgroundColor = UIColor.whiteColor;
    bgView.frame = CGRectMake(15, 0, WGNumScreenWidth() - 30, 45);
    [self.contentView addSubview:bgView];
    self.bgView = bgView;

    
    self.titleLabel = [UILabel labelWithFont:kFontSemibold(16) TextAlignment:NSTextAlignmentLeft TextColor:WGGrayColor(0) TextStr:@"昵称" NumberOfLines:1];
    [bgView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bgView).offset(20);
        make.centerY.mas_equalTo(bgView);
        make.width.offset(100);
        make.height.offset(20);
    }];
    
    
    self.rightImageView = [UIImageView wg_imageViewWithImageNamed:@"arrow_Right"];
    [bgView addSubview:self.rightImageView];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(bgView.mas_right).offset(-15);
        make.centerY.mas_equalTo(bgView);
        make.height.offset(17);
        make.width.offset(10);
    }];
    
    self.infoLabel = [UILabel labelWithFont:kFontMedium(16) TextAlignment:NSTextAlignmentRight TextColor:WGGrayColor(153) TextStr:@"知行盒子" NumberOfLines:1];
    [bgView addSubview:self.infoLabel];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(10);
        make.right.mas_equalTo(self.rightImageView.mas_left).offset(-8);
        make.centerY.mas_equalTo(bgView);
        make.height.offset(20);
    }];
    
    
    self.centerLabel = [UILabel labelWithFont:kFontSemibold(18) TextAlignment:NSTextAlignmentRight TextColor:WGRGBColor(226, 78, 78) TextStr:@"退出登陆" NumberOfLines:1];
    [self.contentView addSubview:self.centerLabel];
    [self.centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.bgView);
        make.height.offset(25);
    }];
    
    
    UISwitch * switchButton = [[UISwitch alloc]init];
    switchButton.hidden = YES;
    [switchButton setOnTintColor:WGRGBColor(248, 110, 151)];
    switchButton.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [switchButton addTarget:self
                   action:@selector(switchButtonClicked:)
         forControlEvents:UIControlEventValueChanged];
    [bgView addSubview:switchButton];
    [switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bgView).offset(-5);
        make.right.mas_equalTo(bgView.mas_right).offset(-15);
        make.height.offset(25);
        make.width.offset(45);
    }];
    self.switchButton = switchButton;
    
    
}

#pragma mark - Private Method
//按钮切换
- (void)switchButtonClicked:(UISwitch *)sender{

    NSString *selctStr = (sender.on) ? @"1" : @"0";
    
    [[ZXMineSetManager shareNetworkManager] zx_setMineType:ZXMineSetType_Notice Value:selctStr Completion:^{
        
        self.userProfileModel.notifystatus = selctStr ;
        
    }];
    
}


//数据导入
- (void)zx_setDataWithMineSetType:(ZXMineSetType )mineSetType UserProfileModel:(ZXMineUserProfileModel *)userProfileModel{
   
    self.userProfileModel = userProfileModel;
    
    
    self.iconView.hidden = YES;
    self.titleLabel.hidden = NO;
    self.centerLabel.hidden = YES;
    self.infoLabel.textColor = WGRGBAlpha(0, 0, 0, 0.5);
    self.rightImageView.hidden = NO;
    self.switchButton.hidden = YES;
    
    switch (mineSetType) {
        case ZXMineSetType_Icon:
        {
            self.iconView.hidden = NO;
            self.titleLabel.hidden = YES;
            self.infoLabel.text = @"修改头像";
           
        }
        break;
        
        case ZXMineSetType_nickName:
        {
            self.titleLabel.text = @"昵称";
            self.infoLabel.text =  self.userProfileModel.nickname;
            [self.bgView wg_setRoundedCorners:UIRectCornerAllCorners radius:12];;
        }
        break;
            
        case ZXMineSetType_Interest:
        {
            self.titleLabel.text = @"兴趣偏好";
            self.infoLabel.text = @"";
//
            [self.bgView wg_setRoundedCorners:UIRectCornerAllCorners radius:12];;
            
            [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.bgView).offset(20);
                make.centerY.mas_equalTo(self.bgView);
                make.height.offset(20);
                make.width.offset(150);
            }];
        }
        break;
            
            
            
        case ZXMineSetType_Mobile:
        {
            self.titleLabel.text = @"手机";
            self.infoLabel.text = self.userProfileModel.mob;
            [self.bgView wg_setRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight radius:12];
            
        }
        break;
            
        case ZXMineSetType_Wechat:
        {
            self.titleLabel.text = @"微信";
            self.infoLabel.text = self.userProfileModel.mob;
            [self.bgView wg_setRoundedCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight radius:12];
        }
        break;
            
        case ZXMineSetType_Age:
        {
            self.titleLabel.text = @"年龄";
            self.infoLabel.text = @"去设置";
            self.infoLabel.textColor = WGRGBColor(255, 74, 128);
        }
        break;
            
        case ZXMineSetType_Sex:
        {
            self.titleLabel.text = @"性别";
            self.infoLabel.text = @"去设置";
            self.infoLabel.textColor = WGRGBColor(255, 74, 128);
        }
        break;
            
        case ZXMineSetType_Hobbies:
        {
            self.titleLabel.text = @"兴趣爱好";
            self.infoLabel.text = @"";
        }
        break;
            
        case ZXMineSetType_Notice:
        {
            self.titleLabel.text = @"允许系统推送";
            self.rightImageView.hidden = YES;
            self.switchButton.hidden = NO;
            
            self.switchButton.on = ([self.userProfileModel.notifystatus intValue] == 1);
            self.infoLabel.text = @"";
            [self.bgView wg_setRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight radius:12];
        }
        break;
            
        case ZXMineSetType_Cancellation:
        {
            self.titleLabel.text = @"注销账号";
            self.infoLabel.text = @"";
        }
        break;
            
        case ZXMineSetType_About:
        {
            self.titleLabel.text = @"关于我们";
            //获取版本号
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *verionStr = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            self.infoLabel.text = verionStr;
            [self.bgView wg_setRoundedCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight radius:12];
        }
        break;
            
        case ZXMineSetType_Exit:
        {
            self.centerLabel.hidden = NO;
            self.centerLabel.text = @"退出登陆";
            self.infoLabel.text = @"";
            self.rightImageView.hidden = YES;
            self.titleLabel.hidden = YES;
            [self.bgView wg_setRoundedCorners:UIRectCornerAllCorners radius:12];;
            
        }
        break;
            
        default:
            break;
    }
    
}


@end

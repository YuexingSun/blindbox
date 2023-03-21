//
//  ZXMineHeaderView.m
//  ZXHY
//
//  Created by Bern Mac on 8/27/21.
//

#import "ZXMineHeaderView.h"
#import "ZXMineModel.h"



@interface ZXMineHeaderView ()

@property (nonatomic, strong) UIButton  *headrButton;
@property (nonatomic, strong) UILabel  *nameLabel;
@property (nonatomic, strong) UILabel *levelTipsLabel;
@property (nonatomic, strong) UISlider *levelSlider;
@property (nonatomic, strong) UILabel *lastLevelLabel;
@property (nonatomic, strong) UILabel *nextLevelLabel;

@end

@implementation ZXMineHeaderView



- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        
        self.backgroundColor = [UIColor clearColor];
        [self setupUI];
    }
    
    return self;
}


#pragma mark - Initialization UI

- (void)setupUI{
    
    self.backgroundColor = UIColor.clearColor;
    
   
    
    
    self.headrButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.headrButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.headrButton  setImage:IMAGENAMED(@"") forState:UIControlStateNormal];
    [self.headrButton addTarget:self action:@selector(headrButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.headrButton];
    [self.headrButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(40);
        make.left.mas_equalTo(self).offset(25);
        make.width.height.offset(96);
    }];
    [self.headrButton layoutIfNeeded];
    [self.headrButton wg_setRoundedCornersWithRadius:48];
    
    self.nameLabel = [UILabel labelWithFont:kFontSemibold(18) TextAlignment:NSTextAlignmentLeft TextColor:WGGrayColor(51) TextStr:@"" NumberOfLines:1];
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headrButton.mas_top).offset(12);
        make.left.mas_equalTo(self.headrButton.mas_right).offset(12);
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.height.offset(20);
    }];

    
    //levelView
    UIView * levelView = [UIView new];
    levelView.backgroundColor = WGRGBAlpha(255, 255, 255, 0.7);
    levelView.alpha = 0.7;
    levelView.layer.cornerRadius = 16;
    levelView.layer.masksToBounds = YES;
    [self addSubview:levelView];
    [self sendSubviewToBack:levelView];
    [levelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.headrButton.mas_bottom).offset(-12);
        make.left.mas_equalTo(self.headrButton.mas_left).offset(50);
        make.width.offset(215);
        make.height.offset(32);
    }];
    

    
    UISlider *levelSlider = [UISlider new];
    [levelSlider setMinimumValue:0];
    [levelSlider setMaximumValue:100];
    [levelSlider setValue:0];
    [levelSlider setMinimumTrackTintColor:WGRGBAlpha(248, 110, 151, 1)];
    [levelSlider setMaximumTrackTintColor:WGGrayColor(238)];
    [levelSlider setThumbTintColor:UIColor.clearColor];
    levelSlider.userInteractionEnabled = NO;
    [self addSubview:levelSlider];
    [levelSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(levelView);
        make.left.mas_equalTo(self.headrButton.mas_right).offset(12);
        make.right.mas_equalTo(levelView.mas_right).offset(-80);
        make.height.offset(20);
    }];
    self.levelSlider = levelSlider;
    
    
    
    UILabel *nextLevelLabel = [UILabel labelWithFont:kFontSemibold(14) TextAlignment:NSTextAlignmentCenter TextColor:kMainTitleColor TextStr:@"" NumberOfLines:1];
    [self addSubview:nextLevelLabel];
    [nextLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(levelSlider);
        make.left.mas_equalTo(levelSlider.mas_right).offset(12);
        make.right.mas_equalTo(levelView.mas_right).offset(10);
        make.height.offset(20);
    }];
    self.nextLevelLabel = nextLevelLabel;
    
 
//    UILabel *lastLevelLabel = [UILabel labelWithFont:kFontSemibold(14) TextAlignment:NSTextAlignmentLeft TextColor:kMainTitleColor TextStr:@"" NumberOfLines:1];
//    [self addSubview:lastLevelLabel];
//    [lastLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(levelSlider.mas_bottom).offset(0);
//        make.left.mas_equalTo(levelTipsLabel);
//        make.height.offset(20);
//    }];
//    self.lastLevelLabel = lastLevelLabel;
//
    
}

#pragma mark - Private Method

//等级等赋值
- (void)zx_dataWithMineModel:(ZXMineModel *)mineModel{
    
    [self.headrButton wg_setImageWithURL:[NSURL URLWithString:mineModel.memberinfo.avatar] forState:UIControlStateNormal placeholderImage:nil];
    
    self.nameLabel.text = mineModel.memberinfo.nickname;
    
    self.levelTipsLabel.text = [NSString stringWithFormat:@"还有%@点升级",mineModel.memberinfo.nextlevelpoint];
    
    self.lastLevelLabel.text = mineModel.memberinfo.nowlevel;
    self.nextLevelLabel.text = mineModel.memberinfo.nextlevel;
    
    
    NSInteger allNum = [mineModel.memberinfo.nextlevelpoint intValue] + [mineModel.memberinfo.nowpoint intValue];
    [self.levelSlider setMinimumValue:0];
    [self.levelSlider setMaximumValue:allNum];
    [self.levelSlider setValue:[mineModel.memberinfo.nowpoint intValue] animated:YES];
}

//头像更改
- (void)headrButton:(UIButton *)sender{
//    [WGImageBrowser wg_showImageBrowserWithImages:imageArr index:0];
}



@end

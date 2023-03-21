//
//  ZXMineHeaderCollectionReusableView.m
//  ZXHY
//
//  Created by Bern Lin on 2022/1/7.
//

#import "ZXMineHeaderCollectionReusableView.h"
#import "ZXMineModel.h"
#import "ZXMineBoxViewController.h"
#import "ZXMyCollectionViewController.h"
#import "ZXMineBlindBoxStatisticsView.h"

@interface ZXMineHeaderCollectionReusableView ()

//个人信息
@property (nonatomic, strong) UIButton  *headrButton;
@property (nonatomic, strong) UILabel  *nameLabel;
@property (nonatomic, strong) UILabel *levelTipsLabel;
@property (nonatomic, strong) UISlider *levelSlider;
@property (nonatomic, strong) UILabel *lastLevelLabel;
@property (nonatomic, strong) UILabel *nextLevelLabel;

//进行中View
@property (nonatomic, strong) UIView  *beginView;
@property (nonatomic, strong) UIButton  *goSeeButton;

//盒子信息和收藏
@property (nonatomic, strong) UIView  *boxCollectionView;
@property (nonatomic, strong) UIButton  *historyButton;
@property (nonatomic, strong) UIButton  *collectionButton;

//盒子统计
@property (nonatomic, strong) ZXMineBlindBoxStatisticsView  *boxStatisticsView;


@end


@implementation ZXMineHeaderCollectionReusableView

+ (NSString *)wg_cellIdentifier{
    return @"ZXMineHeaderCollectionReusableView";
}


- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
     
        self.backgroundColor = [UIColor clearColor];
        
        [self wg_setupUI];
        //进行中
        [self zx_BeginBoxView];
        
        //盒子信息和收藏信息
        [self zx_boxAndCollectionView];
        
        //盒子信息统计
        [self zx_boxStatisticsView];
        

    }
    return self;
}

- (void)wg_setupUI{
    
    self.headrButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.headrButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.headrButton  setImage:IMAGENAMED(@"BeginLogo") forState:UIControlStateNormal];
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

    
    //MeBoxLogo
    UIImageView *boxLogo = [UIImageView wg_imageViewWithImageNamed:@"MeBoxLogo"];
    [self addSubview:boxLogo];
   
    [boxLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headrButton.mas_top).offset(20);
        make.right.mas_equalTo(self.mas_right).offset(-30);
        make.width.offset(90);
        make.height.offset(110);
    }];
    
    
    //levelView
    UIView * levelView = [UIView new];
    levelView.backgroundColor = WGRGBAlpha(255, 255, 255, 0.7);
    levelView.alpha = 0.7;
    levelView.layer.cornerRadius = 16;
    levelView.layer.masksToBounds = YES;
    [self addSubview:levelView];
    [self sendSubviewToBack:levelView];
    [self sendSubviewToBack:boxLogo];
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
    
   
    
}

//进行中的盒子
- (void)zx_BeginBoxView{
    
    self.beginView = [UIView new];
    self.beginView.backgroundColor = UIColor.whiteColor;
    self.beginView.layer.cornerRadius = 5;
    self.beginView.layer.masksToBounds = YES;
    [self addSubview:self.beginView];
    [self.beginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headrButton.mas_bottom).offset(20);
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.height.offset(50);
    }];
    
    
    UIImageView *logoImageView = [UIImageView wg_imageViewWithImageNamed:@"BeginLogo"];
    [self.beginView addSubview:logoImageView];
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.beginView);
        make.left.mas_equalTo(self.beginView.mas_left).offset(15);
        make.height.width.offset(35);
    }];
    
    
    UILabel *tipsLabel = [UILabel labelWithFont:kFont(15) TextAlignment:NSTextAlignmentLeft TextColor:WGGrayColor(51) TextStr:@"有一个进行中的盲盒行程" NumberOfLines:1];
    [self.beginView addSubview:tipsLabel];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(logoImageView);
        make.left.mas_equalTo(logoImageView.mas_right).offset(15);
        make.right.mas_equalTo(self.beginView.mas_right).offset(-85);
    }];
    
    self.goSeeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.goSeeButton.adjustsImageWhenHighlighted = NO;
    self.goSeeButton.layer.cornerRadius = 15;
    self.goSeeButton.layer.masksToBounds = YES;
    self.goSeeButton.backgroundColor = WGRGBColor(255, 199, 223);
    self.goSeeButton.titleLabel.font = kFont(14);
    [self.goSeeButton setTitle:@"去看看" forState:UIControlStateNormal];
    [self.goSeeButton setTitleColor:kMainTitleColor forState:UIControlStateNormal];
    [self.goSeeButton addTarget:self action:@selector(goSeeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.beginView addSubview:self.goSeeButton];
    [self.goSeeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(logoImageView);
        make.right.mas_equalTo(self.beginView.mas_right).offset(-15);
        make.height.offset(30);
        make.width.offset(60);
    }];
}

//盒子信息和收藏信息
- (void)zx_boxAndCollectionView{
    
    self.boxCollectionView = [UIView new];
    self.boxCollectionView.backgroundColor = UIColor.clearColor;
    [self addSubview:self.boxCollectionView];
    [self.boxCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.beginView.mas_bottom).offset(20);
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.height.offset(55);
    }];
    
    
    self.historyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.historyButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.historyButton setBackgroundImage:IMAGENAMED(@"MeHistory") forState:UIControlStateNormal];
    [self.historyButton addTarget:self action:@selector(histroyAction) forControlEvents:UIControlEventTouchUpInside];
    [self.boxCollectionView addSubview:self.historyButton];
    [self.historyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(self.boxCollectionView);
        make.width.offset((WGNumScreenWidth() -30) / 2  - 7.5);
    }];
    
    
    self.collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.collectionButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.collectionButton  setBackgroundImage:IMAGENAMED(@"MeFavorites") forState:UIControlStateNormal];
    [self.collectionButton addTarget:self action:@selector(collectionAction) forControlEvents:UIControlEventTouchUpInside];
    [self.boxCollectionView addSubview:self.collectionButton];
    [self.collectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(self.boxCollectionView);
        make.width.mas_equalTo(self.historyButton);
    }];
}

//盒子统计信息
- (void)zx_boxStatisticsView{

    ZXMineBlindBoxStatisticsView *view = [[ZXMineBlindBoxStatisticsView alloc] initWithFrame:CGRectZero];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.boxCollectionView.mas_bottom).offset(10);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.height.offset(255);
    }];
    self.boxStatisticsView = view;
    
    UILabel *postLabel = [UILabel labelWithFont:kFontSemibold(14) TextAlignment:NSTextAlignmentLeft TextColor:WGRGBColor(180, 172, 188) TextStr:@"已发布的笔记" NumberOfLines:1];
    [self addSubview:postLabel];
    [postLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).offset(-8);
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.height.offset(20);
    }];
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
    
    
    //是否有进行中的盒子
    [self zx_isBegin:([mineModel.mybeingboxlist.beingbox intValue] == 1)];
    
    //统计
    [self.boxStatisticsView zx_dataWithMineModel:mineModel];
}


//是否有进行中的盒子
- (void)zx_isBegin:(bool)isBegin{
    
    self.beginView.hidden = !isBegin;
    [self.beginView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(!isBegin ? 0 : 50);
    }];
    
    [self.boxCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.beginView.mas_bottom).offset(!isBegin ? 0 : 20);
    }];
}


//头像更改
- (void)headrButton:(UIButton *)sender{
//    [WGImageBrowser wg_showImageBrowserWithImages:imageArr index:0];
}


//去看看
- (void)goSeeAction{
    [[AppDelegate wg_sharedDelegate].tabBarController changeToSelectedIndex:WGTabBarType_Box];
}


//历史行程
- (void)histroyAction{
    ZXMineBoxViewController  *vc = [ZXMineBoxViewController new];
    [[WGUIManager wg_currentIndexNavTopController].navigationController pushViewController:vc animated:YES];
}

//收藏
- (void)collectionAction{
    ZXMyCollectionViewController *vc = [ZXMyCollectionViewController new];
    [[WGUIManager wg_currentIndexNavTopController].navigationController pushViewController:vc animated:YES];
}

@end



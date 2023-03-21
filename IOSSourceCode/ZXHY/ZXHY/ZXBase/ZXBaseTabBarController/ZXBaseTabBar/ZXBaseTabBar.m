//
//  ZXBaseTabBar.m
//  ZXHY
//
//  Created by Bern Lin on 2021/11/24.
//

#import "ZXBaseTabBar.h"
#import "WGTabBarItem.h"
#import "WGTabBarModel.h"
#import "ZXCurrentBlindBoxStatusModel.h"

@interface ZXBaseTabBar()

@property (nonatomic, strong) WGTabBarModel *tabHome;
@property (nonatomic, strong) WGTabBarModel *tabBox;
@property (nonatomic, strong) WGTabBarModel *tabMe;

@property (nonatomic, strong) WGTabBarItem *tabbarItemHome;
@property (nonatomic, strong) WGTabBarItem *tabbarItemMe;
@property (nonatomic, strong) UIButton     *tabbatItemBox;

@property (nonatomic, strong) ZXCurrentBlindBoxStatusModel *statusModel;
@end

@implementation ZXBaseTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self zx_initializationUI];
        
        //接收通知
        [WGNotification addObserver:self selector:@selector(tabbarStopReloadNoti:) name:ZXNotificationMacro_BlindBoxTabbarReload object:nil];
        
        //接收是否有开始中的盲盒通知
        [WGNotification addObserver:self selector:@selector(isBeingBoxNoti:) name:ZXNotificationMacro_BlindBoxIsBeingBox object:nil];
    }
    return self;
}

#pragma mark - Initialization UI
- (void)zx_initializationUI{
    
    CGFloat H = kTabBarHeight ;
    UIImageView *tabBarImageView = [UIImageView wg_imageViewWithImageNamed:@"TabBar"];
    tabBarImageView.contentMode = UIViewContentModeScaleAspectFill;
    tabBarImageView.frame = CGRectMake(0, self.mj_h - H, WGNumScreenWidth(), H);
    tabBarImageView.layer.shadowColor = WGHEXAlpha(@"000000", 0.10).CGColor;
    tabBarImageView.layer.shadowOffset = CGSizeMake(0,-2);
    tabBarImageView.layer.shadowRadius = 3;
    tabBarImageView.layer.shadowOpacity = 1;
    tabBarImageView.clipsToBounds = NO;
    [self addSubview:tabBarImageView];
    

    WGTabBarModel *tabBox = [[WGTabBarModel alloc] init];
    tabBox.tabType         = WGTabBarType_Box;
    tabBox.tabName         = @"";
    tabBox.tabImgNormal    = @"BlindBoxGray";
    tabBox.tabImgSelected  = @"BlindBoxReload";
    tabBox.animationStr    = @"";
    self.tabBox = tabBox;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:IMAGENAMED(tabBox.tabImgNormal) forState:UIControlStateNormal];
    [button setBackgroundImage:IMAGENAMED(tabBox.tabImgSelected) forState:UIControlStateSelected];
    button.tag = WGTabBarType_Box;
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tabBarImageView).offset(-23);//-26
        make.centerX.mas_equalTo(tabBarImageView);
        make.width.height.offset(IS_IPHONE_X_SER ? 74 : 78);
    }];
    self.tabbatItemBox = button;
    //添加点击事件
    [button addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabBarItemTap:)]];
    
   
    WGTabBarModel *tabHome = [[WGTabBarModel alloc] init];
    tabHome.tabType         = WGTabBarType_Home;
    tabHome.tabName         = @"";
    tabHome.tabImgNormal    = @"Community";
    tabHome.tabImgSelected  = @"CommunitySelect";
    tabHome.animationStr    = @"";
    tabHome.isSelected      = YES;
    self.tabHome = tabHome;
    
    WGTabBarItem *tabbarItemHome = [[WGTabBarItem alloc] init];
    tabbarItemHome.tabBarModel = tabHome;
    tabbarItemHome.tag = WGTabBarType_Home;
    [self addSubview:tabbarItemHome];
    [tabbarItemHome mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(button).offset((IS_IPHONE_X_SER)? 29 : 10);
        make.centerX.mas_equalTo(tabBarImageView).offset(-(WGNumScreenWidth()/4) - 20);
        make.width.offset((tabBarImageView.mj_w / 2) - 40);
        make.height.offset(tabBarImageView.mj_h);
    }];
    self.tabbarItemHome = tabbarItemHome;
    //添加点击事件
    [tabbarItemHome addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabBarItemTap:)]];
    
    
    WGTabBarModel *tabMe = [[WGTabBarModel alloc] init];
    tabMe.tabType = WGTabBarType_Me;
    tabMe.tabName = @"";
    tabMe.tabImgNormal = @"Me";
    tabMe.tabImgSelected = @"MeSelect";
    tabMe.animationStr    = @"";
    self.tabMe = tabMe;
    
    WGTabBarItem *tabbarItemMe = [[WGTabBarItem alloc] init];
    tabbarItemMe.tabBarModel = tabMe;
    tabbarItemMe.tag = WGTabBarType_Me;
    [self addSubview:tabbarItemMe];
    [tabbarItemMe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.width.height.mas_equalTo(tabbarItemHome);
        make.centerX.mas_equalTo(tabBarImageView).offset((WGNumScreenWidth()/4) + 20);
    }];
    self.tabbarItemMe = tabbarItemMe;
    //添加点击事件
    [tabbarItemMe addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabBarItemTap:)]];
}


#pragma mark - 点击事件
- (void)tabBarItemTap:(UITapGestureRecognizer *)recognizer{
    [self zx_setBarImageTabType:recognizer.view.tag];
    
}

#pragma mark - Private Method
//赋值模式
- (void)setSelectedTabType:(WGTabBarType)selectedTabType{
    [self zx_setBarImageTabType:selectedTabType];
}


//处理图片显示问题
- (void)zx_setBarImageTabType:(WGTabBarType)selectedTabType{
    
    self.tabHome.isSelected = NO;
    self.tabBox.isSelected = NO;
    self.tabMe.isSelected = NO;
    
    WGTabBarModel *currentBarModel = [WGTabBarModel new];
    
    if (selectedTabType == WGTabBarType_Home){
        self.tabHome.isSelected = YES;
        currentBarModel = self.tabHome;
    }
    else if (selectedTabType == WGTabBarType_Box){
        self.tabBox.isSelected = YES;
        currentBarModel = self.tabBox;
    }
    else if (selectedTabType == WGTabBarType_Me){
        self.tabMe.isSelected = YES;
        currentBarModel = self.tabMe;
    }
    
    self.tabbarItemHome.tabBarModel = self.tabHome;
    self.tabbatItemBox.selected = self.tabBox.isSelected;
    self.tabbarItemMe.tabBarModel = self.tabMe;

    if (!self.tabBox.isSelected)  [self.tabbatItemBox.layer removeAllAnimations];
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(zxtabBar:didSelectItem:)]) {
        [self.delegate zxtabBar:self didSelectItem:currentBarModel];
    }
}


//按钮旋转
- (void)zx_tabBoxAnimation{
    
    if ([ self.statusModel.isbeing intValue] == 1) return;
    
    //是否转动
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.duration = 0.6;
    animation.repeatCount = CGFLOAT_MAX;
    animation.fromValue = [NSNumber numberWithFloat:0.0];
    animation.toValue = [NSNumber numberWithFloat:2 * M_PI];
    animation.removedOnCompletion = YES;
    [self.tabbatItemBox.layer addAnimation:animation forKey:@"rotate-layer"];
}

#pragma mark - Notification
//请求结束通知
- (void)tabbarStopReloadNoti:(NSNotification *)notice{
    
    
    if (notice){
        NSString *str = (NSString *)notice.object;
        if ([str integerValue] == 1){
            [self zx_tabBoxAnimation];
        }else if ([str integerValue] == 2){
            [self.tabbatItemBox.layer removeAllAnimations];
        }
    }
}

//接收是否有开始中的盲盒通知
- (void)isBeingBoxNoti:(NSNotification *)notice{
    
    
    if (notice){
        self.statusModel = (ZXCurrentBlindBoxStatusModel *)notice.object;
        //是否有在进行中的盒子
        if ([ self.statusModel.isbeing intValue] == 1){
            self.tabBox.tabImgSelected  = @"BlindBoxSelect";
            [self.tabbatItemBox.layer removeAllAnimations];
        }
        else {
            self.tabBox.tabImgSelected  = @"BlindBoxReload";
        }
        [self.tabbatItemBox setBackgroundImage:IMAGENAMED(self.tabBox.tabImgSelected) forState:UIControlStateSelected];
    }
    
}


@end

//
//  WGBaseTabBarController.m
//  Yunhuoyouxuan
//
//  Created by Bern on 2021/4/28.
//  Copyright © 2021 apple. All rights reserved.
//

#import "WGBaseTabBarController.h"
#import "WGBaseTabBar.h"
#import "WGTabBarModel.h"

//控制器
#import "ZXOpenResultsViewController.h"
#import "ZXopenResultsSelectViewController.h"
#import "ZXLoginViewController.h"
#import "ZXMineViewController.h"

#import "ZXPersonalPreferenceViewController.h"

//模型
#import "ZXCurrentBlindBoxStatusModel.h"





@interface WGBaseTabBarController ()<WGBaseTabBarDelegate>

@property(nonatomic, strong) WGBaseTabBar *wgTarBar;
@property (nonatomic, strong) WGGeneralAlertController *generalAlertVC;

@end

@implementation WGBaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTabBar];
    
    [self zx_reqApiCheckBeingBox];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 移除之前的4个UITabBarButton
    for (UIView *child in self.tabBar.subviews){
        if ([child isKindOfClass:[UIControl class]]){
            [child removeFromSuperview];
        }
    }
    
}

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    // 移除之前的4个UITabBarButton
    for (UIView *child in self.tabBar.subviews){
        if ([child isKindOfClass:[UIControl class]]){
            [child removeFromSuperview];
        }
    }
}

- (void)initTabBar{

    WGBaseTabBar *tabbarView = [[WGBaseTabBar alloc] initWithFrame:self.tabBar.bounds];
    tabbarView.delegate = self;
    tabbarView.backgroundColor = UIColor.whiteColor;
    self.wgTarBar = tabbarView;
    self.tabBar.backgroundColor = UIColor.whiteColor;
    self.tabBar.barTintColor = UIColor.whiteColor;
    [self.tabBar addSubview:tabbarView];
    
    WGTabBarModel *tabHome = [[WGTabBarModel alloc] init];
    tabHome.tabType         = WGTabBarType_Home;
    tabHome.tabName         = @"Community";
    tabHome.tabImgNormal    = @"Community";
    tabHome.tabImgSelected  = @"CommunitySelect";
    tabHome.animationStr    = @"";
//    tabHome.isSelected = YES;
    
    
    WGTabBarModel *tabBox = [[WGTabBarModel alloc] init];
    tabBox.tabType = WGTabBarType_Box;
    tabBox.tabName = @"Blind Box";
    tabBox.tabImgNormal = @"BlindBox";
    tabBox.tabImgSelected = @"BlindBoxSelect";
    tabBox.animationStr    = @"blindbox";
    tabBox.isSelected = YES;
    
    WGTabBarModel *tabMe = [[WGTabBarModel alloc] init];
    tabMe.tabType = WGTabBarType_Me;
    tabMe.tabName = @"Me";
    tabMe.tabImgNormal = @"Me";
    tabMe.tabImgSelected = @"MeSelect";
    tabMe.animationStr    = @"me";
    
//    tabHome,
    self.wgTarBar.tabbarArray = @[tabBox,tabMe];
    
}

- (void)initViewControllers{
    
    WGBaseViewController *homeVC  = [WGBaseViewController new];
    WGBaseViewController *boxVC = [[WGBaseViewController alloc] init];
    ZXMineViewController *mineVC = [[ZXMineViewController  alloc] init];

//    homeVC,
    NSArray * viewControllers = @[boxVC,mineVC];
    NSMutableArray *navViewControllers = [NSMutableArray array];
   
    for (int i = 0; i<viewControllers.count; i++){
        WGBaseNavigationController* nav = [[WGBaseNavigationController  alloc] initWithRootViewController:[viewControllers wg_safeObjectAtIndex:i]];
        [navViewControllers wg_safeAddObject:nav];
    }
    
    [self setViewControllers:navViewControllers animated:YES];
   
}

#pragma mark - WGBaseTabBarDelegate代理
- (void)wgtabBar:(WGBaseTabBar *)tabbar didSelectItem:(WGTabBarModel *)tabBarModel{
    self.selectedIndex = tabBarModel.tabType;
    
    if (tabBarModel.tabType == WGTabBarType_Box){
//        [self zx_reqApiCheckBeingBox];
    }
}
#pragma mark - Private Method

//跳转到指定页®
- (void)changeToSelectedIndex:(WGTabBarType)selectedIndex{
    
    self.selectedIndex = selectedIndex;
    
    self.wgTarBar.selectedTabType = selectedIndex;

}


#pragma mark - NetworkRequest

//查询是否有未开启和进行中的盲盒
- (void)zx_reqApiCheckBeingBox{
    
    WEAKSELF;
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiCheckBeingBox Parameter:@{} success:^(NSDictionary * _Nonnull resultDic) {
        STRONGSELF;
        NSArray * viewControllers = [NSArray array];
        NSMutableArray *navViewControllers = [NSMutableArray array];
        
        ZXCurrentBlindBoxStatusModel *statusModel = [ZXCurrentBlindBoxStatusModel wg_objectWithDictionary:resultDic[@"data"]];
        
        if ([statusModel.isbeing intValue] == 1){
            
            
            if ([statusModel.status intValue] == 1){
               
                ZXOpenResultsViewController *openResultsVC = [ZXOpenResultsViewController new];
                [openResultsVC zx_getBeingBox:statusModel.boxid];
                
                
                ZXMineViewController *mineVC = [[ZXMineViewController  alloc] init];
                viewControllers = @[openResultsVC,mineVC];
                
            }else{
                
                ZXopenResultsSelectViewController *openResultsSelectVC = [ZXopenResultsSelectViewController new];
                [openResultsSelectVC zx_getBeingBox:statusModel.boxid];
                ZXMineViewController *mineVC = [[ZXMineViewController  alloc] init];
                viewControllers = @[openResultsSelectVC,mineVC];
            }
    
        }
        else{
            //TODO: 修复拖动问题，记录一下
//            ZXPersonalPreferenceViewController *boxVC = [[ZXPersonalPreferenceViewController alloc] init];
            WGBaseViewController *boxVC = [[WGBaseViewController alloc] init];
            ZXMineViewController *mineVC = [[ZXMineViewController  alloc] init];
            viewControllers = @[boxVC,mineVC];
        }
        
        for (int i = 0; i<viewControllers.count; i++){
            WGBaseNavigationController* nav = [[WGBaseNavigationController  alloc] initWithRootViewController:[viewControllers wg_safeObjectAtIndex:i]];
            [navViewControllers wg_safeAddObject:nav];
        }
        [self setViewControllers:navViewControllers animated:YES];
        
    } failure:^(NSError * _Nonnull error) {
        [self initViewControllers];
        
    }];
}




@end

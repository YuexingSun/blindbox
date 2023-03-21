//
//  ZXBaseTabBarController.m
//  ZXHY
//
//  Created by Bern Lin on 2021/11/24.
//

#import "ZXBaseTabBarController.h"
#import "ZXBaseTabBar.h"
#import "ZXVersionCheckUpdatesViewModel.h"
#import "ZXWebViewViewController.h"

//控制器
#import "ZXHomeViewController.h"
#import "ZXBlindBoxViewController.h"
#import "ZXOpenResultsViewController.h"
#import "ZXopenResultsSelectViewController.h"
#import "ZXLoginViewController.h"
#import "ZXMineViewController.h"
#import "ZXMineCenterViewController.h"


@interface ZXBaseTabBarController ()
<ZXBaseTabBarDelegate>

@property (nonatomic, strong) ZXVersionCheckIndexShowViewModel  *indexShowViewModel;
@property (nonatomic, strong) ZXBaseTabBar *tabbarView;
@property (nonatomic, strong) WGTabBarModel  *tabBarModel;

@property (nonatomic, assign) bool  isAnimation;

@end

@implementation ZXBaseTabBarController

-(id)init{
    self = [super init];
    
    if (self) {
        //必须要在init方法中才有效果
        NSLog(@"\n\n必须要在init方法中才有效果\n");
       
    }
    return self;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self zx_initializationUI];
//    [self initViewControllers];
    [self zx_reqApiGetInitData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tabBar removeFromSuperview];
    self.tabBar.hidden = YES;
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.tabBar removeFromSuperview];
    self.tabBar.hidden = YES;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.tabBar.hidden = YES;
    [self.tabBar removeFromSuperview];
   
}

#pragma mark - Initialization UI
- (void)zx_initializationUI{

    [self.tabBar removeFromSuperview];
    CGFloat tabBarHeight = kTabBarHeight + ((IS_IPHONE_X_SER) ? 24.5 : 35.5);
    
    ZXBaseTabBar *tabbarView = [[ZXBaseTabBar alloc] initWithFrame:CGRectMake(0, WGNumScreenHeight() - tabBarHeight, WGNumScreenWidth(), tabBarHeight)];
    tabbarView.delegate = self;
    [self.view addSubview:tabbarView];
    self.tabbarView = tabbarView;
    
    
}

- (void)initViewControllers{
    
    ZXHomeViewController *homeVC  = [ZXHomeViewController new];
    homeVC.hidesBottomBarWhenPushed = YES;
    
    ZXBlindBoxViewController *boxVC = [ZXBlindBoxViewController new];
    boxVC.hidesBottomBarWhenPushed = YES;
    
//    ZXMineViewController *mineVC = [[ZXMineViewController  alloc] init];
//    mineVC.hidesBottomBarWhenPushed = YES;
    
    ZXMineCenterViewController *mineVC = [[ZXMineCenterViewController  alloc] init];
    mineVC.hidesBottomBarWhenPushed = YES;
    
    
    NSArray * viewControllers = @[homeVC,boxVC,mineVC];
    NSMutableArray *navViewControllers = [NSMutableArray array];
   
    for (int i = 0; i<viewControllers.count; i++){
        WGBaseNavigationController* nav = [[WGBaseNavigationController  alloc] initWithRootViewController:[viewControllers wg_safeObjectAtIndex:i]];
        [navViewControllers wg_safeAddObject:nav];
    }
    
    [self setViewControllers:navViewControllers animated:YES];
}

- (void)initViewControllersWithHomeType:(ZXVersionCheckIndexShowViewModel *)indexShowViewModel{
    
    WGBaseViewController *homeVC = [WGBaseViewController new];
    
    if (indexShowViewModel.type == 2){
        ZXWebViewViewController *vc = [ZXWebViewViewController new];
        vc.webViewURL = indexShowViewModel.url;
        vc.webViewTitle = @"首页";
        [vc.navigationView wg_setIsBack:NO];
        homeVC = vc;
    }else{
        ZXHomeViewController *vc = [ZXHomeViewController new];
        homeVC  = vc;
    }
    homeVC.hidesBottomBarWhenPushed = YES;
    
    
    ZXBlindBoxViewController *boxVC = [ZXBlindBoxViewController new];
    boxVC.hidesBottomBarWhenPushed = YES;
    
    
    ZXMineCenterViewController *mineVC = [[ZXMineCenterViewController  alloc] init];
    mineVC.hidesBottomBarWhenPushed = YES;
    
    
    NSArray * viewControllers = @[homeVC,boxVC,mineVC];
    NSMutableArray *navViewControllers = [NSMutableArray array];
   
    for (int i = 0; i<viewControllers.count; i++){
        WGBaseNavigationController* nav = [[WGBaseNavigationController  alloc] initWithRootViewController:[viewControllers wg_safeObjectAtIndex:i]];
        [navViewControllers wg_safeAddObject:nav];
    }
    
    [self setViewControllers:navViewControllers animated:YES];
}


#pragma mark - ZXBaseTabBarDelegate代理
- (void)zxtabBar:(ZXBaseTabBar *)tabbar didSelectItem:(WGTabBarModel *)tabBarModel{
    
    self.selectedIndex = tabBarModel.tabType;
    
    if (self.selectedIndex == WGTabBarType_Box && self.tabBarModel.tabType == WGTabBarType_Box){
        [WGNotification postNotificationName:ZXNotificationMacro_BlindBox object:nil];
        [self.tabbarView zx_tabBoxAnimation];
    }
    
    self.tabBarModel = tabBarModel;
}

#pragma mark - Private Method
//跳转到指定页®
- (void)changeToSelectedIndex:(WGTabBarType)selectedIndex{
    self.selectedIndex = selectedIndex;
    self.tabbarView.selectedTabType = selectedIndex;
}


- (void)hideTabBar{

    WEAKSELF
    
    CGRect tabFrame = self.tabbarView.frame;
    tabFrame.origin.y = WGNumScreenHeight();
    [UIView animateWithDuration:0.3 animations:^{
        STRONGSELF
        
        if (!self.isAnimation){
            self.tabbarView.frame = tabFrame;
        }
        self.isAnimation = YES;
        
    } completion:^(BOOL finished) {
        if (finished){
            self.isAnimation = NO;
            
        }
        
    }];

}

- (void)showTabBar{
 
    WEAKSELF
    CGRect tabFrame = self.tabbarView.frame;
    tabFrame.origin.y = WGNumScreenHeight() - self.tabbarView.mj_h;
    [UIView animateWithDuration:0.3 animations:^{
       
        STRONGSELF
        
        if (!self.isAnimation){
            self.tabbarView.frame = tabFrame;
        }
        self.isAnimation = YES;
        
    } completion:^(BOOL finished) {
        if (finished){
            self.isAnimation = NO;
        }
        
    }];

}

- (CGFloat)zx_tabBarHeight{
    return  self.tabbarView.mj_h;
}



#pragma mark - NetworkRequest
//获取客户端初始化信息--（检查是否需要更新）
- (void)zx_reqApiGetInitData{
    
    NSLog(@"测试线程 --- 1 --- %@",[NSThread currentThread]);
    
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiGetInitData Parameter:@{} success:^(NSDictionary * _Nonnull resultDic) {
        
        //检查展示类型
        self.indexShowViewModel = [ZXVersionCheckIndexShowViewModel wg_objectWithDictionary:[resultDic wg_safeObjectForKey:@"data"][@"indexshow"]];

        [self initViewControllersWithHomeType:self.indexShowViewModel];
        
        NSLog(@"测试线程 --- 2 --- %@",[NSThread currentThread]);
        
    } failure:^(NSError * _Nonnull error) {
        
        
    }];
    
    
    NSLog(@"测试线程 --- 3 --- %@",[NSThread currentThread]);
}
 



@end

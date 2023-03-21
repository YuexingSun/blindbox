//
//  ZXMinePropsViewController.m
//  ZXHY
//
//  Created by Bern Mac on 9/13/21.
//

#import "ZXMinePropsViewController.h"
#import "WGScrollPageView.h"
#import "ZXMinePropsListViewController.h"

@interface ZXMinePropsViewController ()
<
WGScrollPageViewDelegate
>

@property (nonatomic, strong) WGScrollPageView *scrollPageView;

@end

@implementation ZXMinePropsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self wg_setupUI];
}

#pragma mark - Initialization UI
- (void)wg_setupUI{
    
    self.view.backgroundColor = WGGrayColor(255);
    
    self.wg_mainTitle = @"道具使用记录";
    [self.navigationView wg_setTitleColor:UIColor.blackColor];
    self.navigationView.backgroundColor = [UIColor clearColor];
    [self.view bringSubviewToFront:self.navigationView];
    
    
    NSMutableArray *titleArr = [NSMutableArray arrayWithObjects:@"未使用",@"已使用",@"已过期", nil];
    
    NSMutableArray *childArr = [NSMutableArray array];
    for (int i = 0; i < titleArr.count; i++) {
        ZXMinePropsListViewController * vc = [ZXMinePropsListViewController new];
//        vc.vcType = i;
        [childArr wg_safeAddObject:vc];
    }
    
    self.scrollPageView = [[WGScrollPageView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, WGNumScreenWidth(), WGNumScreenHeight() - kNavBarHeight)
                                                    andRootVc:self
                                                  andTitleArr:titleArr
                                                     andVcArr:childArr style:WGScrollPageViewStyleCenterShow];
    self.scrollPageView.titleFontSize = 14.0;
    self.scrollPageView.titleSelectedColor = [UIColor wg_colorWithHexString:@"#FF445E"];
    self.scrollPageView.titleNormalColor = [UIColor wg_colorWithHexString:@"#3C3C3C"];
    self.scrollPageView.showAllTitle = NO;
    [self.scrollPageView refreshScrollPageView];
    
    self.scrollPageView.delegate = self;
    [self.scrollPageView setHideTopLineView:YES];
    [self.scrollPageView setTitleFont:[UIFont systemFontOfSize:14]];
    
    [self.scrollPageView scrollToPageIndex:0];
    
    [self.view addSubview:self.scrollPageView];
    
}

#pragma mark - WGScrollPageViewDelegate
- (void)scrollToItemIndex:(NSInteger)index selectItemController:(UIViewController *)selectItemController{
    
}

@end

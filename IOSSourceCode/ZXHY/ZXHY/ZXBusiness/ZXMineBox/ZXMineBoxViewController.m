//
//  ZXMineBoxViewController.m
//  ZXHY
//
//  Created by Bern Mac on 8/27/21.
//

#import "ZXMineBoxViewController.h"
#import "WGScrollPageView.h"
#import "ZXMineBoxListViewController.h"
#import "ZXMineBoxModel.h"

#define topViewHeight (IS_IPHONE_X_SER ? 300 :250)

@interface ZXMineBoxViewController ()
<
WGScrollPageViewDelegate,
UIScrollViewDelegate
>

@property (nonatomic, strong) UIScrollView  *mainScrollView;
@property (nonatomic, strong) WGScrollPageView *scrollPageView;
@property (nonatomic, strong) UILabel   *myBoxTicketNumLabel;
@property (nonatomic, strong) UILabel   *boxRaiseNumLabel;

@end

@implementation ZXMineBoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self wg_setupUI];
    
    [WGNotification addObserver:self selector:@selector(reloadHeaderNoti:) name:ZXNotificationMacro_MineBox object:nil];
}


#pragma mark - Initialization UI
- (void)wg_setupUI{
    self.view.backgroundColor = WGGrayColor(239);
    
    
    
    //topView
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WGNumScreenWidth(), topViewHeight)];
    topView.backgroundColor = UIColor.clearColor;
    [self.view addSubview:topView];
    UIImageView *bgImgV = [UIImageView wg_imageViewWithImageNamed:@"MeBackground"];
    bgImgV.contentMode = UIViewContentModeScaleToFill;
    bgImgV.frame = topView.frame;
    [topView addSubview:bgImgV];
    
    UILabel *label1 = [UILabel labelWithFont:kFontSemibold(24) TextAlignment:NSTextAlignmentCenter TextColor:WGRGBColor(255, 65, 111) TextStr:@"0%" NumberOfLines:1];
    self.boxRaiseNumLabel = label1;
    
    UILabel *label2 = [UILabel labelWithFont:kFont(16) TextAlignment:NSTextAlignmentCenter TextColor:WGRGBColor(255, 65, 111) TextStr:@"盲盒满意度" NumberOfLines:1];
    

    UILabel *label3 = [UILabel labelWithFont:kFontSemibold(24) TextAlignment:NSTextAlignmentCenter TextColor:WGRGBColor(255, 65, 111) TextStr:@"0" NumberOfLines:1];
    self.myBoxTicketNumLabel = label3;
    
    UILabel *label4 = [UILabel labelWithFont:kFont(16) TextAlignment:NSTextAlignmentCenter TextColor:WGRGBColor(255, 65, 111) TextStr:@"可使用盲盒" NumberOfLines:1];
    
    
//    [topView addSubview:label1];
//    [topView addSubview:label2];
//    [topView addSubview:label3];
//    [topView addSubview:label4];
//
//    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(topView.mas_centerX).offset(-90);
//        make.bottom.mas_equalTo(topView.mas_bottom).offset(-20);
//        make.height.offset(25);
//    }];
//
//    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(label2);
//        make.bottom.mas_equalTo(label2.mas_top).offset(-10);
//    }];
//
//
//    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(topView.mas_centerX).offset(90);
//        make.centerY.mas_equalTo(label2);
//        make.height.offset(25);
//    }];
//
//    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(label4);
//        make.centerY.mas_equalTo(label1);
//    }];
    
   
    //scrollPageView
    NSMutableArray *titleArr = [NSMutableArray arrayWithObjects:@"全部",@"已完成",@"已失效",@"待评价", nil];
    
    NSMutableArray *childArr = [NSMutableArray array];
    for (int i = 0; i < titleArr.count; i++) {
        ZXMineBoxListViewController * vc = [ZXMineBoxListViewController new];
        vc.vcType = i;
        vc.view.backgroundColor = UIColor.clearColor;
        [childArr wg_safeAddObject:vc];
    }
    
    self.scrollPageView = [[WGScrollPageView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, WGNumScreenWidth(), WGNumScreenHeight() - kNavBarHeight)
                                                    andRootVc:self
                                                  andTitleArr:titleArr
                                                     andVcArr:childArr style:WGScrollPageViewStyleCenterShow];
    self.scrollPageView.titleFontSize = 15.0;
    self.scrollPageView.titleSelectedColor = WGRGBColor(68, 44, 96);
    self.scrollPageView.titleNormalColor = WGRGBColor(180, 172, 188);
    self.scrollPageView.showAllTitle = NO;
    
    self.scrollPageView.delegate = self;
    [self.scrollPageView setHideTopLineView:YES];
    [self.scrollPageView setTitleFont:kFontSemibold(15)];
    
    [self.scrollPageView scrollToPageIndex:0];
    self.scrollPageView.backgroundColor = UIColor.clearColor;
    [self.scrollPageView refreshScrollPageView];
    [self.view addSubview:self.scrollPageView];
    
//    [self.view addSubview:self. ];
//    [self.mainScrollView addSubview:topView];
//    [self.mainScrollView addSubview:self.scrollPageView];
    
    self.wg_mainTitle = @"历史行程";
    [self.navigationView wg_setTitleColor:UIColor.blackColor];
    self.navigationView.backgroundColor = [UIColor clearColor];
    [self.view bringSubviewToFront:self.navigationView];
    
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    
}


#pragma mark - ScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if(scrollView == self.mainScrollView){
       
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView == self.mainScrollView){
        self.navigationView.backgroundColor = WGRGBAlpha(255, 255, 255, [scrollView wg_alphaWhenScroll]);
        
        bool isScroll;
        if (topViewHeight - kNavBarHeight <= scrollView.contentOffset.y){
            
            scrollView.contentOffset = CGPointMake(0, topViewHeight - kNavBarHeight);
            isScroll = YES;
        }else{
            
            scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
            isScroll = NO;
        }
        
//        CGFloat Y = scrollView.contentOffset.y - topViewHeight + kNavBarHeight;
        [WGNotification postNotificationName:@"aaa" object:@(isScroll)];
    }
}


#pragma mark - WGScrollPageViewDelegate
- (void)scrollToItemIndex:(NSInteger)index selectItemController:(UIViewController *)selectItemController{
    
}




#pragma mark - Private Method

//头部刷新通知
- (void)reloadHeaderNoti:(NSNotification *)notice{
   
    if(notice.object) {
        
        ZXMineBoxModel *mineBoxModel = (ZXMineBoxModel *)notice.object;
        self.myBoxTicketNumLabel.text = [NSString stringWithFormat:@"%ld",mineBoxModel.myboxticketnum];
        self.boxRaiseNumLabel.text = [NSString stringWithFormat:@"%ld%%",mineBoxModel.boxraisenum];
    }
    
}

#pragma mark - Lazy

- (UIScrollView *)mainScrollView{
    
    if(!_mainScrollView){
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WGNumScreenWidth(),  WGNumScreenHeight() )];
        _mainScrollView.pagingEnabled = NO;
        _mainScrollView.contentSize = CGSizeMake(0, WGNumScreenHeight() + topViewHeight - kNavBarHeight);
//
        _mainScrollView.delegate = self;
        _mainScrollView.backgroundColor = [UIColor clearColor];
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        _mainScrollView.bounces = NO;
        
//        UIViewController *firstVc = [self.vcArr firstObject];
//        firstVc.view.frame = CGRectMake(0, 0, WGNumScreenWidth(), self.frame.size.height-itemHeight);
//        [self.rootVc addChildViewController:firstVc];
//        [self.mainScrollView addSubview:firstVc.view];
//        [firstVc didMoveToParentViewController:self.rootVc];
//        _currentShowVc = firstVc;
        
    }
    return _mainScrollView;
}

@end

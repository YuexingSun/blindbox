//
//  ZXMineCenterViewController.m
//  ZXHY
//
//  Created by Bern Lin on 2022/1/6.
//

#import "ZXMineCenterViewController.h"
#import "ZXMineSetViewController.h"
#import "ZXMineModel.h"
#import "ZXWaterfallsCollectionViewLayout.h"
#import "ZXMineHeaderCollectionReusableView.h"
#import "ZXMineFooterCollectionReusableView.h"
#import "ZXSearchCollectionViewCell.h"
#import "ZXHomeModel.h"
#import "ZXHomeDetailsViewController.h"
#import "ZXValidationManager.h"

#import "ZXHitTestView.h"

@interface ZXMineCenterViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
ZXWaterfallsCollectionViewLayoutDelegate
>

@property (nonatomic, strong) UIImageView  *headerBGView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) CGFloat  lastContentOffsetY;
@property (nonatomic, assign) CGFloat  lastContentOffsetX;

//数据
@property (nonatomic, strong) ZXMineModel *mineModel;
@property (nonatomic, strong) ZXMineUserProfileModel *userProfileModel;

//数据
@property (nonatomic, strong) NSString  *currentPage;
@property (nonatomic, strong) NSMutableArray  *dataList;
@property (nonatomic, strong) ZXHomeModel *homeModel;


@end

@implementation ZXMineCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self zx_initialization];
    
    [self zx_setNavigationView];
    
    [self restartLoadData];
    
//    ZXHitTestView *hitView = [[ZXHitTestView alloc] initWithFrame:CGRectMake(0, 0, WGNumScreenWidth(), 300)];
//    hitView.backgroundColor = UIColor.whiteColor;
//    [self.view addSubview:hitView];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationView wg_setIsBack:NO];

}

#pragma mark - Initialization UI
- (void)zx_initialization{
    
    self.view.backgroundColor = WGGrayColor(239);
    
    //头部背景
    [self.view addSubview:self.headerBGView];
    
    //CollectionView
    [self.view addSubview:self.collectionView];
    
    //接收个人资料改变
    [WGNotification addObserver:self selector:@selector(reloadNoti:) name:ZXNotificationMacro_MineSet object:nil];
    
    //接收到笔记发布
    [WGNotification addObserver:self selector:@selector(reloadNoteListNoti:) name:ZXNotificationMacro_PostOrDeleteNote object:nil];
    
    //网络状态改变
    [WGNotification addObserver:self selector:@selector(networkStatusNoti:) name:ZXNotificationMacro_NetworkStatus object:nil];
    
    
    
}

//导航栏
- (void)zx_setNavigationView{
    
    self.wg_mainTitle = @"我的";
    self.navigationView.delegate = self;
    [self.navigationView wg_setIsBack:NO];
    [self.navigationView wg_setTitleColor:UIColor.clearColor];
    self.navigationView.backgroundColor = [UIColor clearColor];
    [self.view bringSubviewToFront:self.navigationView];
    [self.navigationView wg_setRightBtnWithNormalImageName:@"MeSet" highlightedImageName:nil selectedImageName:nil btnTag:1];

}




#pragma mark - WGNavigationViewDelegate
- (void)navigationViewRightBtnClick:(WGNavigationView *)navigationView btnTag:(NSInteger)btnTag{
    
    if (btnTag == 1){
        if (!self.userProfileModel || !self.mineModel) return;

        ZXMineSetViewController *vc = [ZXMineSetViewController new];
        [vc zx_setMineModel:self.mineModel UserProfileMdoel:self.userProfileModel];
        [self.navigationController pushViewController:vc animated:YES];
        
    
//        static dispatch_once_t onceToken;
//
//        dispatch_once(&onceToken, ^{
//            NSLog(@"213432115421");
//        });
    }
    else{
    }
}

#pragma mark - Notification
//刷新个人资料通知
- (void)reloadNoti:(NSNotification *)notice{
    [self zx_reqApiGetMyDataList];
}

//接收到笔记发布
- (void)reloadNoteListNoti:(NSNotification *)notice{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self restartLoadData];
    });
    
}


//网络状态改变通知
- (void)networkStatusNoti:(NSNotification *)notice{
//    [WGUIManager wg_showHUD];
    [self restartLoadData];
}


#pragma mark - Private Method
//下拉刷新
- (void)restartLoadData{
    self.currentPage = @"1";
    [self.dataList removeAllObjects];
    self.dataList = nil;
    self.dataList = [NSMutableArray array];
    [self zx_reqApiGetMyDataList];
    
    [self zx_reqApiInfomationGetMyInfoList];
}

//上拉加载
- (void)loadMore{
    
    if ([self.currentPage isEqualToString:self.homeModel.totalpage] || [self.homeModel.totalpage intValue] == 0) return;
    
    self.currentPage = [NSString stringWithFormat:@"%d", [self.currentPage intValue] + 1];
    
    [self zx_reqApiInfomationGetMyInfoList];
}





#pragma mark - scrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.lastContentOffsetY = scrollView.contentOffset.y;
    self.lastContentOffsetX = scrollView.contentOffset.x;
}


//滑动更改headerView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSLog(@"scrollView.contentOffset.y  ----- %lf",scrollView.contentOffset.y);
    
    if(scrollView.contentOffset.y <= 0 ){
       [[AppDelegate wg_sharedDelegate].tabBarController showTabBar];
        return;
    }
    
    if(scrollView.contentOffset.y > self.lastContentOffsetY){
        NSLog(@"向上滑动");
        [[AppDelegate wg_sharedDelegate].tabBarController hideTabBar];
    }else if(scrollView.contentOffset.y < self.lastContentOffsetY){
        NSLog(@"向下滑动");
        [[AppDelegate wg_sharedDelegate].tabBarController showTabBar];
    }
    
    
    //========================
    if(self.collectionView == scrollView){
        
        CGRect frame = self.headerBGView.frame;
        
        if (scrollView.contentOffset.y > 0){
            frame.origin.y = -scrollView.contentOffset.y;
        }else if (scrollView.contentOffset.y == 0){
            frame.size.height =  250 + kNavBarHeight;
        }else{
            frame.size.height = -scrollView.contentOffset.y + 250 + kNavBarHeight;
        }

        self.headerBGView.frame = frame;
    }
    
    [self.navigationView wg_setTitleColor: WGRGBAlpha(255, 65, 111, [scrollView wg_alphaWhenScroll])];
    self.navigationView.backgroundColor = WGRGBAlpha(255, 255, 255, [scrollView wg_alphaWhenScroll]);
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ZXSearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ZXSearchCollectionViewCell wg_cellIdentifier] forIndexPath:indexPath];
    
    ZXHomeListModel *listModel = [self.dataList wg_safeObjectAtIndex:indexPath.row];
    
    [cell zx_typeImage:listModel.bannerImg typeTitle:listModel.title];
    
    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZXHomeListModel *listModel = [self.dataList wg_safeObjectAtIndex:indexPath.row];
    ZXHomeDetailsViewController *vc = [ZXHomeDetailsViewController new];
    [vc zx_setTypeIdToRequest:listModel.typeId];
    [self.navigationController pushViewController:vc animated:YES];
   
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
   
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        ZXMineHeaderCollectionReusableView *reuseableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[ZXMineHeaderCollectionReusableView wg_cellIdentifier] forIndexPath:indexPath];
        [reuseableView zx_dataWithMineModel:self.mineModel];
        return reuseableView;
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        
        ZXMineFooterCollectionReusableView *reuseableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:[ZXMineFooterCollectionReusableView wg_cellIdentifier] forIndexPath:indexPath];
        
        [reuseableView zx_isHidden: (self.dataList.count)];
        
        return reuseableView;
        
    }
    
    return nil;
}


#pragma mark - ZXWaterfallsCollectionViewLayoutDelegate

//计算item高度的代理方法，将item的高度与indexPath传递给外界
- (CGFloat)zx_waterfallLayout:(ZXWaterfallsCollectionViewLayout *)waterfallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath{
    //根据图片的原始尺寸，及显示宽度，等比例缩放来计算显示高度
    
    ZXHomeListModel *listModel = [self.dataList wg_safeObjectAtIndex:indexPath.row];
    CGFloat itemHeight = listModel.bannerImg.size.height / listModel.bannerImg.size.width * itemWidth;
    return itemHeight + 50;
}



//计算header高度的代理方法，将header的高度与indexPath传递给外界
- (CGSize)zx_waterfallLayout:(ZXWaterfallsCollectionViewLayout *)waterfallLayout HeaderViewSizeAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.mineModel.mybeingboxlist.beingbox intValue] == 1){
        return CGSizeMake(WGNumScreenWidth(), 600);
    }
    
    return CGSizeMake(WGNumScreenWidth(), 530);
}

//计算footer高度的代理方法，将header的高度与indexPath传递给外界
- (CGSize)zx_waterfallLayout:(ZXWaterfallsCollectionViewLayout *)waterfallLayout FooterViewSizeAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataList.count){
        return CGSizeMake(WGNumScreenWidth(), 0);
    }
    return CGSizeMake(WGNumScreenWidth(), 240);
}

#pragma mark - NetworkRequest
//获取个人信息
- (void)zx_reqApiGetMyDataList{
    
   
    WEAKSELF;
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiGetMyDataList Parameter:@{} success:^(NSDictionary * _Nonnull resultDic) {
        STRONGSELF;
        self.mineModel = [ZXMineModel wg_objectWithDictionary:[resultDic wg_safeObjectForKey:@"data"]];

        
        [self zx_reqApiGetUserProfile];
        
        
    } failure:^(NSError * _Nonnull error) {
        [WGUIManager wg_hideHUD];
        
    }];
}


//获取用户资料信息
- (void)zx_reqApiGetUserProfile{
    
    WEAKSELF;
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiGetUserProfile Parameter:@{} success:^(NSDictionary * _Nonnull resultDic) {
        STRONGSELF;
        self.userProfileModel = [ZXMineUserProfileModel wg_objectWithDictionary:[resultDic wg_safeObjectForKey:@"data"]];
        
        [self.collectionView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView reloadData];
        [WGUIManager wg_hideHUD];
    }];
}



//获取我发布的笔记
- (void)zx_reqApiInfomationGetMyInfoList{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic wg_safeSetObject:self.currentPage forKey:@"page"];
    [dic wg_safeSetObject:@"10" forKey:@"limit"];
    
    
    WEAKSELF;
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiInfomationGetMyInfoList Parameter:dic success:^(NSDictionary * _Nonnull resultDic) {
        STRONGSELF;
        
        [WGUIManager wg_hideHUD];
    
        self.homeModel = [ZXHomeModel wg_objectWithDictionary:[resultDic wg_safeObjectForKey:@"data"]];
        
        for (ZXHomeListModel *listModel in self.homeModel.list){
            
            [[UIImageView new] wg_setImageWithURL:[NSURL URLWithString:listModel.banner] completed:^(UIImage *image, NSError *error, WGImageCacheType cacheType, NSURL *imageURL) {
                listModel.bannerImg = image;
                [self.dataList wg_safeAddObject:listModel];
            }];
        }
        
        
        
        self.collectionView.mj_footer.hidden = ([self.currentPage isEqualToString:self.homeModel.totalpage] || [self.homeModel.totalpage intValue] == 0);
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        
    }];
}





#pragma mark - lazy
- (UICollectionView *)collectionView{
    if (!_collectionView){
        
        //创建瀑布流布局
        ZXWaterfallsCollectionViewLayout *waterfallLayout = [ZXWaterfallsCollectionViewLayout zx_waterFallLayoutWithColumnCount:2];
        waterfallLayout.delegate = self;
        waterfallLayout.columnSpacing = -15;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0 , kNavBarHeight, WGNumScreenWidth(), WGNumScreenHeight() - kNavBarHeight) collectionViewLayout:waterfallLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;

        [_collectionView registerClass:[ZXMineHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier: [ZXMineHeaderCollectionReusableView wg_cellIdentifier]];
        
        [_collectionView registerClass:[ZXMineFooterCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier: [ZXMineFooterCollectionReusableView wg_cellIdentifier]];
        
        [_collectionView registerClass:[ZXSearchCollectionViewCell class] forCellWithReuseIdentifier:[ZXSearchCollectionViewCell wg_cellIdentifier]];
        
        [WGCommonRefreshUtil configRefreshInScrollView:_collectionView target:self action:@selector(restartLoadData) headerRefreshType:WGCommonHeaderRefreshTypeRed];
        [WGCommonRefreshUtil configLoadMoreInScrollView:_collectionView target:self action:@selector(loadMore)];
    }
    return _collectionView;
}


- (UIImageView *)headerBGView{
    if (!_headerBGView){
        _headerBGView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WGNumScreenWidth(), 250 + kNavBarHeight)];
        _headerBGView.contentMode = UIViewContentModeScaleToFill;
        _headerBGView.image = [UIImage wg_imageNamed:@"MeBackground"];
    }
    return _headerBGView;
}

@end

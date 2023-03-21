//
//  ZXMineViewController.m
//  ZXHY
//
//  Created by Bern Mac on 8/12/21.
//

#import "ZXMineViewController.h"
#import "ZXMineHeaderView.h"
#import "ZXMineIsBeginCell.h"
#import "ZXMineInfoCell.h"
#import "ZXMineModel.h"
#import "ZXMineAchievementCell.h"
#import "ZXMineBlindBoxStatisticsTableViewCell.h"
#import "ZXMineSetViewController.h"
#import "ZXMineCenterViewController.h"



typedef NS_ENUM(NSUInteger, ZXMineCellType) {
    ZXMineCellType_BeginBox,
    ZXMineCellType_InfoBox,
    ZXMineCellType_Achievement,
};


@interface ZXMineViewController ()
<
WGNavigationViewDelegate,
UITableViewDelegate,
UITableViewDataSource,
UICollectionViewDelegate
>


@property (nonatomic, strong) WGBaseTableView            *tableView;
@property (nonatomic, strong) ZXMineHeaderView           *headerView;
@property (nonatomic, strong) UIView                     *headerBGView;
@property (nonatomic, strong) ZXMineModel *mineModel;
@property (nonatomic, strong) ZXMineUserProfileModel *userProfileModel;
@property (nonatomic, strong) NSMutableArray  *dataList;




@end

@implementation ZXMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self zx_initializationXIB];
    [self zx_setNavigationViewButton];
   
    [WGUIManager wg_showHUD];
//    [self zx_reqApiGetMyDataList];
    
    [WGNotification addObserver:self selector:@selector(reloadNoti:) name:ZXNotificationMacro_MineSet object:nil];
    
    //网络状态改变
    [WGNotification addObserver:self selector:@selector(networkStatusNoti:) name:ZXNotificationMacro_NetworkStatus object:nil];
    
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationView wg_setIsBack:NO];

    [self restartLoadData];
}

#pragma mark - Initialization UI

//设置Nav右边按钮
- (void)zx_setNavigationViewButton{
    
    self.wg_mainTitle = @"Me";
    [self.navigationView wg_setTitleColor:UIColor.clearColor];
    self.navigationView.backgroundColor = [UIColor clearColor];
    [self.view bringSubviewToFront:self.navigationView];
    
    self.navigationView.delegate = self;
    [self.navigationView wg_setRightBtnWithNormalImageName:@"MeSet" highlightedImageName:nil selectedImageName:nil btnTag:1];
    [self.navigationView wg_setRightBtnWithNormalImageName:@"" highlightedImageName:nil selectedImageName:nil btnTag:2];

}


//初始化XIB
- (void)zx_initializationXIB{
    
    self.view.backgroundColor = WGGrayColor(244);

    [self.view addSubview:self.headerBGView];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(kNavBarHeight);
    }];
    self.tableView.tableHeaderView = self.headerView;
    
    
//    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WGNumScreenWidth(), [[AppDelegate wg_sharedDelegate].tabBarController zx_tabBarHeight])];
//    self.tableView.tableFooterView = footView;
    
    
}




#pragma mark - WGNavigationViewDelegate
- (void)navigationViewRightBtnClick:(WGNavigationView *)navigationView btnTag:(NSInteger)btnTag{
    
    if (btnTag == 1){
        if (!self.userProfileModel || !self.mineModel) return;

        ZXMineSetViewController *vc = [ZXMineSetViewController new];
        [vc zx_setMineModel:self.mineModel UserProfileMdoel:self.userProfileModel];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else{
        ZXMineCenterViewController *vc = [ZXMineCenterViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark - Notification
//刷新通知
- (void)reloadNoti:(NSNotification *)notice{
   
    if(notice) {
        [self.headerView zx_dataWithMineModel:self.mineModel];
    }
    
}

//网络状态改变通知
- (void)networkStatusNoti:(NSNotification *)notice{
    [WGUIManager wg_showHUD];
    [self restartLoadData];
}



#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    

    if(self.tableView == scrollView){
        
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


#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    NSNumber *num = [self.dataList wg_safeObjectAtIndex:indexPath.row];
    
    if (num.intValue == ZXMineCellType_BeginBox){
        
        ZXMineIsBeginCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZXMineIsBeginCell wg_cellIdentifier]];
        return cell;
        
    }else if (num.intValue == ZXMineCellType_InfoBox){
        
        ZXMineInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZXMineInfoCell wg_cellIdentifier]];
        [cell zx_dataWithMineModel:self.mineModel];
        return cell;
        
    }else if (num.intValue == ZXMineCellType_Achievement){
        
//        ZXMineAchievementCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZXMineAchievementCell wg_cellIdentifier]];
//        [cell zx_dataWithMineModel:self.mineModel];
//        return cell;
        
        ZXMineBlindBoxStatisticsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[ZXMineBlindBoxStatisticsTableViewCell wg_cellIdentifier]];
        [cell zx_dataWithMineModel:self.mineModel];
        return cell;
        
    }
        
    UITableViewCell *cell = [UITableViewCell new];
    cell.backgroundColor = UIColor.clearColor;
    return cell;
        
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSNumber *num = [self.dataList wg_safeObjectAtIndex:indexPath.row];
    
    if (num.intValue == ZXMineCellType_BeginBox){
        
        return 60;
        
    }else if (num.intValue == ZXMineCellType_InfoBox){
        
        return 85;
        
    }else if (num.intValue == ZXMineCellType_Achievement){
        
        return 226;
        
    }else {
        
        return 0.1f;
        
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


#pragma mark - Private Method


//下拉刷新
- (void)restartLoadData{
    [self.dataList removeAllObjects];
    self.dataList = nil;
    self.dataList = [NSMutableArray arrayWithObjects:@(ZXMineCellType_InfoBox), nil];
    [self zx_reqApiGetMyDataList];

}

#pragma mark - NetworkRequest

//获取个人信息
- (void)zx_reqApiGetMyDataList{
    
   
    WEAKSELF;
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiGetMyDataList Parameter:@{} success:^(NSDictionary * _Nonnull resultDic) {
        STRONGSELF;
        self.mineModel = [ZXMineModel wg_objectWithDictionary:[resultDic wg_safeObjectForKey:@"data"]];
        
        [self.headerView zx_dataWithMineModel:self.mineModel];
        
        if ([self.mineModel.mybeingboxlist.beingbox intValue] == 1){
            [self.dataList wg_safeInsertObject:@(ZXMineCellType_BeginBox) atIndex:0];
        }
        
        if (self.mineModel.myachievelist.count){
            [self.dataList wg_safeAddObject:@(ZXMineCellType_Achievement)];
        }
        
        
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
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        [WGUIManager wg_hideHUD];
        
    } failure:^(NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        [WGUIManager wg_hideHUD];
    }];
}



#pragma mark - layz

- (WGBaseTableView *)tableView{
    if (!_tableView){
        _tableView = [[WGBaseTableView alloc] initWithFrame:CGRectZero];
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        
        [_tableView registerNib:[UINib nibWithNibName:@"ZXMineIsBeginCell" bundle:nil] forCellReuseIdentifier:[ZXMineIsBeginCell wg_cellIdentifier]];
        
        [_tableView registerNib:[UINib nibWithNibName:@"ZXMineInfoCell" bundle:nil] forCellReuseIdentifier:[ZXMineInfoCell wg_cellIdentifier]];
        
        [_tableView registerNib:[UINib nibWithNibName:@"ZXMineAchievementCell" bundle:nil] forCellReuseIdentifier:[ZXMineAchievementCell wg_cellIdentifier]];
        
        [_tableView registerClass:[ZXMineBlindBoxStatisticsTableViewCell class] forCellReuseIdentifier:[ZXMineBlindBoxStatisticsTableViewCell wg_cellIdentifier]];
        
        [WGCommonRefreshUtil configRefreshInScrollView:self.tableView target:self action:@selector(restartLoadData) headerRefreshType:WGCommonHeaderRefreshTypeRed];
        
    }
    return _tableView;
}

- (ZXMineHeaderView *)headerView{
    if (!_headerView){
        _headerView = [[ZXMineHeaderView alloc] initWithFrame:CGRectMake(0, 0, WGNumScreenWidth(), 150 )];
    }
    return _headerView;
}

- (UIView *)headerBGView{
    if (!_headerBGView){
        _headerBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WGNumScreenWidth(), 250 + kNavBarHeight)];
        UIImageView *bgImgView = [[UIImageView alloc] init];
        bgImgView.contentMode = UIViewContentModeScaleToFill;
        bgImgView.image = [UIImage wg_imageNamed:@"MeBackground"];
        [_headerBGView addSubview:bgImgView];
        [bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.bottom.mas_equalTo(_headerBGView);
        }];
        
    }
    return _headerBGView;
}


- (NSMutableArray *)dataList{
    if (!_dataList){
        _dataList = [NSMutableArray arrayWithObjects:@(ZXMineCellType_InfoBox), nil];
    }
    return _dataList;
}


@end

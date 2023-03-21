//
//  ZXMineBoxListViewController.m
//  ZXHY
//
//  Created by Bern Mac on 8/27/21.
//

#import "ZXMineBoxListViewController.h"
#import "ZXMineBoxListViewCell.h"
#import "ZXMineBoxModel.h"
#import "ZXMineBoxDetailsViewController.h"
#import "ZXOpenResultsModel.h"
#import "CustomUIViewController.h"
#import "ZXBlindBoxViewModel.h"



@interface ZXMineBoxListViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) WGBaseTableView            *tableView;
@property (nonatomic, strong) ZXMineBoxModel             *mineBoxModel;

@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UILabel *tipsLabel;

@property (nonatomic, strong) NSString  *currentPage;
@property (nonatomic, strong) NSMutableArray  *boxList;

@property (nonatomic, assign) bool  isScroll;
@property (nonatomic, strong)  NSNumber *num;

@end

@implementation ZXMineBoxListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self zx_initializationXIB];
    
    [self restartLoadData];
 
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.navigationView.hidden = YES;
    
    self.navigationView.alpha = 0;
    
}

#pragma mark - Initialization UI

//初始化XIB
- (void)zx_initializationXIB{
    
    self.view.backgroundColor = WGGrayColor(244);
    
    UIImageView *logoView = [UIImageView wg_imageViewWithImageNamed:@"NotBlindBox"];
    [self.view addSubview:logoView];
    [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-120);
        make.width.offset(170);
        make.height.offset(160);
    }];
    self.logoView = logoView;
    self.logoView.hidden = YES;
    
    UILabel *tipsLabel = [UILabel labelWithFont:kFont(15) TextAlignment:NSTextAlignmentCenter TextColor:WGRGBAlpha(0, 0, 0, 0.65) TextStr:@"除了空空...什么也没有" NumberOfLines:1];
    [self.view addSubview:tipsLabel];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoView.mas_bottom).offset(5);
        make.left.right.equalTo(self.view);
        make.height.offset(20);
    }];
    self.tipsLabel = tipsLabel;
    self.tipsLabel.hidden = YES;
    
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(0);
    }];
}


#pragma mark - Private Method

//下拉刷新
- (void)restartLoadData{
    
    self.currentPage = @"1";
    [self.boxList removeAllObjects];
    self.boxList = nil;
    
    [self ZX_ReqApiGetMyBoxList];
    
}

//上拉加载
- (void)loadMore{
    
    if ([self.currentPage isEqualToString:self.mineBoxModel.totalpage] || [self.mineBoxModel.totalpage intValue] == 0) return;
    
    self.currentPage = [NSString stringWithFormat:@"%d", [self.currentPage intValue] + 1];
    
    [self ZX_ReqApiGetMyBoxList];
}


#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.boxList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZXMineBoxListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZXMineBoxListViewCell wg_cellIdentifier]];
    
    ZXMineBoxListModel *listModel = [self.boxList wg_safeObjectAtIndex:indexPath.row];
    
    [cell zx_dataWithMineBoxModel:listModel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZXMineBoxListModel *listModel = [self.boxList wg_safeObjectAtIndex:indexPath.row];
    
    if (listModel.status == 4 || listModel.status == 5) return;;
    
    [self ZX_ReqApiGetBoxDetail:listModel.boxid];
   
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (IS_iPhoneX){
        UIView *footView = [UIView  new];
        footView.backgroundColor = UIColor.clearColor;
        return footView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return kHomeIndicatorHeight;
}

#pragma mark - ScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"####%f",scrollView.contentOffset.y);
    
   
//    if (scrollView.contentOffset.y <= kNavBarHeight -230){
//        scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
//    }
    
//    if (self.isScroll){
//        self.tableView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
//    }else{
//        self.tableView.contentOffset = CGPointMake(0, 0);
//    }
}

#pragma mark - NetworkRequest

//获取我的盲盒列表
- (void)ZX_ReqApiGetMyBoxList{
    
    NSString *status = @"";
    
    if (self.vcType == 0){
        status = @"";
    }else if (self.vcType == 1){
        status = @"2|3";
    }else if (self.vcType == 2){
        status = @"4|5";
    }else if (self.vcType == 3){
        status = @"2";
    }
    
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic wg_safeSetObject:status forKey:@"status"];
    [dic wg_safeSetObject:self.currentPage forKey:@"page"];
    [dic wg_safeSetObject:@"10" forKey:@"limit"];
    
    
    WEAKSELF;
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiGetMyBoxList Parameter:dic success:^(NSDictionary * _Nonnull resultDic) {
        STRONGSELF;
        
        self.mineBoxModel = [ZXMineBoxModel wg_objectWithDictionary:[resultDic wg_safeObjectForKey:@"data"]];
        
        for (ZXMineBoxListModel *listModel in self.mineBoxModel.list){
            [self.boxList wg_safeAddObject:listModel];
        }
        
        if (self.mineBoxModel.list.count){
            self.tipsLabel.hidden = YES;
            self.logoView.hidden = YES;
        }else{
            self.tipsLabel.hidden = NO;
            self.logoView.hidden = NO;
        }
        
        [WGNotification postNotificationName:ZXNotificationMacro_MineBox object:self.mineBoxModel];
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_footer.hidden = ([self.currentPage isEqualToString:self.mineBoxModel.totalpage] || [self.mineBoxModel.totalpage intValue] == 0);
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
}


//获取盲盒信息
- (void)ZX_ReqApiGetBoxDetail:(NSString *)boxid{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict wg_safeSetObject:boxid forKey:@"boxid"];
    
    [WGUIManager wg_showHUD];
    WEAKSELF;
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiGetBoxDetail Parameter:dict success:^(NSDictionary * _Nonnull resultDic) {
        [WGUIManager wg_hideHUD];
        STRONGSELF;
        
        ZXBlindBoxViewModel *blindBoxViewModel = [ZXBlindBoxViewModel wg_objectWithDictionary:resultDic[@"data"]];
        ZXBlindBoxViewParentlistModel *parentlistModel = [blindBoxViewModel.parentlist wg_safeObjectAtIndex:blindBoxViewModel.selparentindex];
        ZXOpenResultsModel *resultsModel = [parentlistModel.childlist wg_safeObjectAtIndex: blindBoxViewModel.selchildindex];
        
        if (resultsModel.status == 1){
            
            CustomUIViewController *vc = [CustomUIViewController new];
            [vc zx_openResultslnglatModel:resultsModel ParentlistModel:nil];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            
            ZXMineBoxDetailsViewController *vc = [ZXMineBoxDetailsViewController new];
            [vc ZX_ReqApiGetBoxDetail:resultsModel];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        
    } failure:^(NSError * _Nonnull error) {
        
        
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
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 140;
        [_tableView registerNib:[UINib nibWithNibName:@"ZXMineBoxListViewCell" bundle:nil] forCellReuseIdentifier:[ZXMineBoxListViewCell wg_cellIdentifier]];
        
        [WGCommonRefreshUtil configRefreshInScrollView:self.tableView target:self action:@selector(restartLoadData) headerRefreshType:WGCommonHeaderRefreshTypeRed];
        
        [WGCommonRefreshUtil configLoadMoreInScrollView:self.tableView target:self action:@selector(loadMore)];
    }
    return _tableView;
}

- (NSMutableArray *)boxList{
    if (!_boxList){
        _boxList = [NSMutableArray array];
    }
    return _boxList;
}

@end

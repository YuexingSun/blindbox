//
//  ZXMyCollectionViewController.m
//  ZXHY
//
//  Created by Bern Lin on 2022/1/6.
//

#import "ZXMyCollectionViewController.h"
#import "ZXMyCollectionTableViewCell.h"
#import "ZXMyCollectionModel.h"
#import "ZXHomeDetailsViewController.h"
#import "ZXHomeManager.h"


@interface ZXMyCollectionViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) WGBaseTableView     *tableView;

//数据
@property (nonatomic, strong) NSString            *currentPage;
@property (nonatomic, strong) NSMutableArray      *sourceList;
@property (nonatomic, strong) ZXMyCollectionModel  *collectionModel;
//没数据展示
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UILabel *tipsLabel;

@end

@implementation ZXMyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self zx_initializationXIB];
    
    [self restartLoadData];
}

//初始化XIB
- (void)zx_initializationXIB{
    
    self.view.backgroundColor = WGGrayColor(239);
    
    UIImageView *headerBGView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WGNumScreenWidth(), 250 + kNavBarHeight)];
    headerBGView.contentMode = UIViewContentModeScaleToFill;
    headerBGView.image = [UIImage wg_imageNamed:@"MeBackground"];
    [self.view addSubview:headerBGView];
    
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
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(self.view).offset(kNavBarHeight);
        make.bottom.equalTo(self.view.mas_bottom).offset(IS_IPHONE_X_SER ?-20 :0 );
    }];
    
    //导航栏
    self.wg_mainTitle = @"我的收藏";
    [self.navigationView wg_setTitleColor:UIColor.blackColor];
    self.navigationView.backgroundColor = [UIColor clearColor];
    [self.view bringSubviewToFront:self.navigationView];
    
}

#pragma mark - Private Method

//下拉刷新
- (void)restartLoadData{
    
    self.currentPage = @"1";
    [self.sourceList removeAllObjects];
    self.sourceList = [NSMutableArray array];
    
    [self zx_reqApiInfomationGetMyfavList];
    
}

//上拉加载
- (void)loadMore{
    
    if ([self.currentPage isEqualToString:self.collectionModel.totalpage] || [self.collectionModel.totalpage intValue] == 0) return;
    
    self.currentPage = [NSString stringWithFormat:@"%d", [self.currentPage intValue] + 1];
    
    [self zx_reqApiInfomationGetMyfavList];
}


#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZXMyCollectionTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:[ZXMyCollectionTableViewCell wg_cellIdentifier]];
    
    ZXMyCollectionListModel *listModel = [self.sourceList wg_safeObjectAtIndex:indexPath.row];
    
    [cell zx_setListModel:listModel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZXMyCollectionListModel *listModel = [self.sourceList wg_safeObjectAtIndex:indexPath.row];
    ZXHomeDetailsViewController *vc = [ZXHomeDetailsViewController new];
    [vc zx_setTypeIdToRequest:listModel.typeId];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    //删除
    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        
        ZXMyCollectionListModel *listModel = [self.sourceList wg_safeObjectAtIndex:indexPath.row];
        
        [WGUIManager wg_showHUD];
        [ZXHomeManager zx_reqApiInfomationLikeFavArticleWithNoteId:listModel.typeId SuccessBlock:^(NSDictionary * _Nonnull dic) {
            [WGUIManager wg_hideHUD];
            [self.sourceList wg_safeRemoveObjectAtIndex:indexPath.row];
            completionHandler (YES);
            [self.tableView reloadData];
        } ErrorBlock:^(NSError * _Nonnull error) {
            [WGUIManager wg_hideHUDWithText:@"删除失败"];
        }];
        
    }];
    
    deleteRowAction.image = [UIImage imageNamed:@"delete"];
    deleteRowAction.backgroundColor = WGRGBAlpha(255, 255, 255, 0);
    
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction]];
    return config;
}




#pragma mark - NetworkRequest
//获取盲盒信息
- (void)zx_reqApiInfomationGetMyfavList{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic wg_safeSetObject:self.currentPage forKey:@"page"];
    [dic wg_safeSetObject:@"10" forKey:@"limit"];
    
    
    WEAKSELF;
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiInfomationGetMyfavList Parameter:dic success:^(NSDictionary * _Nonnull resultDic) {
        STRONGSELF;
        
        self.collectionModel = [ZXMyCollectionModel wg_objectWithDictionary:[resultDic wg_safeObjectForKey:@"data"]];
        
        for (ZXMyCollectionListModel *listModel in self.collectionModel.list){
            [self.sourceList wg_safeAddObject:listModel];
        }

        if (self.collectionModel.list.count){
            self.tipsLabel.hidden = YES;
            self.logoView.hidden = YES;
        }else{
            self.tipsLabel.hidden = NO;
            self.logoView.hidden = NO;
        }
        
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_footer.hidden = ([self.currentPage isEqualToString:self.collectionModel.totalpage] || [self.collectionModel.totalpage intValue] == 0);
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
}





#pragma mark - layz
- (WGBaseTableView *)tableView{
    if (!_tableView){
        _tableView = [[WGBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = 105;
        _tableView.sectionHeaderHeight = 0.1f;
        _tableView.sectionFooterHeight = 0.1f;
        
        [_tableView registerClass:[ZXMyCollectionTableViewCell class] forCellReuseIdentifier:[ZXMyCollectionTableViewCell wg_cellIdentifier]];
        
        [WGCommonRefreshUtil configRefreshInScrollView:self.tableView target:self action:@selector(restartLoadData) headerRefreshType:WGCommonHeaderRefreshTypeRed];
        
        [WGCommonRefreshUtil configLoadMoreInScrollView:self.tableView target:self action:@selector(loadMore)];
    }
    return _tableView;
}
   
- (NSMutableArray *)sourceList{
    if (!_sourceList){
        _sourceList = [NSMutableArray array];
    }
    return _sourceList;
}


@end

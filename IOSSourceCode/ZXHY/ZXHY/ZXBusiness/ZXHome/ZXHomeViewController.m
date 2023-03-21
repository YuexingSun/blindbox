//
//  ZXHomeViewController.m
//  ZXHY
//
//  Created by Bern Lin on 2021/12/20.
//

#import "ZXHomeViewController.h"
#import "ZXSearchViewController.h"
#import "ZXHomeTopAdHeaderView.h"
#import "ZXHomeTableViewCell.h"
#import "ZXHomeAdTableViewCell.h"
#import "ZXHomeDetailsViewController.h"
#import "ZXHomeModel.h"
#import "ZXHomeManager.h"
#import "ZXPostNoteViewController.h"
#import "SDImageCache.h"


@interface ZXHomeViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
ZXHomeTopAdHeaderViewDelegate
>


@property (nonatomic, strong) WGGeneralAlertController *alertVc;

@property (nonatomic, strong) WGBaseTableView  *tableView;
@property (nonatomic, assign) CGFloat  lastContentOffsetY;
@property (nonatomic, assign) CGFloat  lastContentOffsetX;
//数据
@property (nonatomic, strong) NSString  *currentPage;
@property (nonatomic, strong) NSMutableArray  *sourceList;

@property (nonatomic, strong) ZXHomeModel *homeModel;

//发笔记按钮
@property (nonatomic, strong) UIButton *noteButon;
//是否动画中
@property (nonatomic, assign) bool  isAnimation;

//无数据或无网络展示
@property (nonatomic, strong) UIImageView *tipsView;
@property (nonatomic, strong) UIButton  *reloadButton;

@end

@implementation ZXHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self zx_initializationUI];
    
    //首页数据列表
    [self restartLoadData];
    
    

    //接收通知
    [WGNotification addObserver:self selector:@selector(homeReloadNoti:) name:ZXNotificationMacro_Home object:nil];
    
    //文章三大状态改变刷新
    [WGNotification addObserver:self selector:@selector(statusReloadNoti:) name:ZXNotificationMacro_HomeSupportCollectionComments object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - Notification
//刷新通知
- (void)homeReloadNoti:(NSNotification *)notice{
    if (notice){
        NSLog(@"ZXNotificationMacro_Home -- %@",[NSThread currentThread]);
        [self restartLoadData];
    }
}

//文章三大状态改变刷新
- (void)statusReloadNoti:(NSNotification *)notice{
    
    if(notice.object) {
        
        ZXHomeListModel *notiListModel = notice.object;
        
        for (int i = 0; i < self.sourceList.count ; i++){
            
            ZXHomeListModel *listModel = [self.sourceList wg_safeObjectAtIndex:i];
            if ([listModel.typeId isEqualToString:notiListModel.typeId]){
                [self.sourceList replaceObjectAtIndex:i withObject:notiListModel];
            }
        }
        [self.tableView reloadData];
    }
}



#pragma mark - Initialization
//初始化UI
- (void)zx_initializationUI{
    
    [self.navigationView wg_setIsBack:NO];

    self.navigationView.backgroundColor = [UIColor whiteColor];
    
    //搜索栏
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0,kNavTopBarHeight, WGNumScreenWidth() , 52)];
    titleView.backgroundColor = UIColor.clearColor;
    [self.navigationView addSubview:titleView];
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(16, 6, WGNumScreenWidth() - 32, 32);
    searchButton.adjustsImageWhenHighlighted = NO;
    searchButton.layer.cornerRadius = 16;
    searchButton.layer.masksToBounds = YES;
    searchButton.backgroundColor = WGGrayColor(239);
    [searchButton setImage:IMAGENAMED(@"search") forState:UIControlStateNormal];
    [searchButton setTitle:@"搜索文章" forState:UIControlStateNormal];
    [searchButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    searchButton.titleLabel.font = kFontMedium(14);
    [searchButton setTitleColor:WGGrayColor(153) forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:searchButton];

    //无网络或者找不到 SearchNoNetwork  SearchNothing
    self.tipsView = [UIImageView wg_imageViewWithImageNamed:@"SearchNoNetwork"];
    self.tipsView.hidden = YES;
    [self.view addSubview:self.tipsView];
    [self.tipsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-120);
        make.width.offset(160);
        make.height.offset(130);
    }];
   
    self.reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.reloadButton.hidden = YES;
    self.reloadButton.adjustsImageWhenHighlighted = NO;
    self.reloadButton.layer.cornerRadius = 22;
    self.reloadButton.layer.borderColor = WGRGBColor(248, 110, 151).CGColor;
    self.reloadButton.layer.borderWidth = 1;
    self.reloadButton.layer.masksToBounds = YES;
    self.reloadButton.titleLabel.font = kFontMedium(16);
    [self.reloadButton setTitle:@"重新加载" forState:UIControlStateNormal];
    [self.reloadButton setTitleColor:WGRGBColor(248, 110, 151) forState:UIControlStateNormal];
    [self.reloadButton addTarget:self action:@selector(reloadAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.reloadButton];
    [self.reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tipsView);
        make.top.equalTo(self.tipsView.mas_bottom).offset(15);
        make.width.offset(130);
        make.height.offset(44);
    }];
    
    
    
    //TableView
    CGFloat Y = kNavigationBarHeight;
    self.tableView.frame = CGRectMake(0, Y, WGNumScreenWidth(), WGNumScreenHeight() - Y);
    [self.view addSubview:self.tableView];
    
    
    //写笔记按钮
    CGFloat conditionButonX = WGNumScreenWidth() - 67;
    CGFloat conditionButonY = WGNumScreenHeight() - 55 - [[AppDelegate wg_sharedDelegate].tabBarController zx_tabBarHeight];
    
    UIButton *conditionButon = [UIButton buttonWithType:UIButtonTypeCustom];
    [conditionButon setBackgroundImage:IMAGENAMED(@"writeNote") forState:UIControlStateNormal];
    conditionButon.frame = CGRectMake(conditionButonX, conditionButonY, 55, 55);
    conditionButon.layer.shadowColor = WGHEXAlpha(@"000000", 0.25).CGColor;
    conditionButon.layer.shadowOffset = CGSizeMake(0,4);
    conditionButon.layer.shadowRadius = 3;
    conditionButon.layer.shadowOpacity = 1;
    conditionButon.clipsToBounds = NO;
    [conditionButon addTarget:self action:@selector(zx_noteAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:conditionButon];
    self.noteButon = conditionButon;
    
    
    //广告TopView
    ZXHomeTopAdHeaderView *topAdHeaderView = [[ZXHomeTopAdHeaderView alloc] initWithFrame:CGRectMake(0, 0, WGNumScreenWidth(), 0.1)];
    topAdHeaderView.delegate = self;
    self.tableView.tableHeaderView = topAdHeaderView;
    
    
}

#pragma mark - Private Method
//重新加载
- (void)reloadAction{
    [WGUIManager wg_showHUD];
    [self restartLoadData];
}

//下拉刷新
- (void)restartLoadData{
    
    self.currentPage = @"1";
    self.sourceList  = [NSMutableArray array];
    
    [self zx_reqApiInfomationGetList];
}

//上拉加载
- (void)loadMore{
    
    if ([self.currentPage isEqualToString:self.homeModel.totalpage] || [self.homeModel.totalpage intValue] == 0) return;
    
    self.currentPage = [NSString stringWithFormat:@"%d", [self.currentPage intValue] + 1];
    
    [self zx_reqApiInfomationGetList];
}


//搜索响应
- (void)searchAction:(UIButton *)sender{
    ZXSearchViewController *vc = [ZXSearchViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

//隐藏或显示写笔记和搜索
- (void)zx_hideOrNoteButonAndNav:(BOOL)hide{
  

    
    WEAKSELF
    [UIView animateWithDuration:0.3 animations:^{
        STRONGSELF
        if (!self.isAnimation){
            if(hide){

                self.noteButon.mj_x = WGNumScreenWidth();
                self.navigationView.mj_h = 0;
                self.tableView.mj_y = 0;
                self.tableView.mj_h = WGNumScreenHeight();
            }else{

                self.noteButon.mj_x = WGNumScreenWidth() - 67;
                self.navigationView.mj_h = kNavBarHeight;
                self.tableView.mj_y = kNavBarHeight;
                self.tableView.mj_h = WGNumScreenHeight() - kNavBarHeight;
            }
        }
        self.isAnimation = YES;

    } completion:^(BOOL finished) {
        if (finished){
            self.isAnimation = NO;
        }
    }];
    
    
    
    

}


//写笔记
- (void)zx_noteAction:(UIButton *)sender{

    ZXPostNoteViewController *vc = [ZXPostNoteViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - ZXHomeTopAdHeaderViewDelegate (顶部广告实图)
//高度返回
- (void)homeTopAdHeaderView:(ZXHomeTopAdHeaderView *)topAdHeaderView returnViewHeight:(CGFloat)viewHeight{
    topAdHeaderView.frame = CGRectMake(0, 0, WGNumScreenWidth(), viewHeight);
    self.tableView.tableHeaderView = topAdHeaderView;
}


#pragma mark - scrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.lastContentOffsetY = scrollView.contentOffset.y;
    self.lastContentOffsetX = scrollView.contentOffset.x;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(scrollView.contentOffset.y <= 0 ){
//        NSLog(@"\n\n 小于 0 了");
       [[AppDelegate wg_sharedDelegate].tabBarController showTabBar];
        [self zx_hideOrNoteButonAndNav:NO];
        return;
    }

    if(scrollView.contentOffset.y > self.lastContentOffsetY){
       
        
       
        
    }else if(scrollView.contentOffset.y < self.lastContentOffsetY){
    
       
        
    }
    
     
    CGPoint point =  [scrollView.panGestureRecognizer translationInView:self.view];
    if (point.y >0 ) {
        
        [[AppDelegate wg_sharedDelegate].tabBarController showTabBar];
        [self zx_hideOrNoteButonAndNav:NO];
    }else{
    
        [[AppDelegate wg_sharedDelegate].tabBarController hideTabBar];
        [self zx_hideOrNoteButonAndNav:YES];
        
    }
    
    //内存释放
    [[SDImageCache sharedImageCache] clearMemory];
}



#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZXHomeListModel *listModel = [self.sourceList wg_safeObjectAtIndex:indexPath.row];
    
    
    if (listModel.type == 2){
        ZXHomeAdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZXHomeAdTableViewCell wg_cellIdentifier]];
        [cell zx_setListModel:listModel];
        return cell;
    
    }
    
    ZXHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZXHomeTableViewCell wg_cellIdentifier]];
    [cell zx_setListModel:listModel];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZXHomeListModel *listModel = [self.sourceList wg_safeObjectAtIndex:indexPath.row];
    if (listModel.type == 2){
        return 265;
    }
    
    return listModel.cellHeight;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZXHomeListModel *listModel = [self.sourceList wg_safeObjectAtIndex:indexPath.row];
    if (listModel.type == 2){
        return;
    }
    
    ZXHomeDetailsViewController *vc = [ZXHomeDetailsViewController new];
    [vc zx_setListModel:listModel];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


#pragma mark - NetworkRequest
//获取首页信息流列表
- (void)zx_reqApiInfomationGetList{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic wg_safeSetObject:self.currentPage forKey:@"page"];
    [dic wg_safeSetObject:@"10" forKey:@"limit"];
    
    NSLog(@"\n\nself.currentPage---%@",self.currentPage);
    
    WEAKSELF;
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiInfomationGetList Parameter:dic success:^(NSDictionary * _Nonnull resultDic) {
        STRONGSELF;
    
        self.homeModel = [ZXHomeModel wg_objectWithDictionary:[resultDic wg_safeObjectForKey:@"data"]];
        
        
        for (ZXHomeListModel *listModel in self.homeModel.list){
            listModel.cellHeight = [ZXHomeTableViewCell  zx_heightWithListModel:listModel];
            [self.sourceList wg_safeAddObject:listModel];
        }
        
        
        self.tableView.hidden = NO;
        self.tipsView.hidden = YES;
        self.reloadButton.hidden = YES;
        
        
        self.tableView.mj_footer.hidden = ([self.currentPage isEqualToString:self.homeModel.totalpage] || [self.homeModel.totalpage intValue] == 0);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        
        [WGUIManager wg_hideHUD];
        
        NSLog(@"\n\nself.currentPage---请求完");
        
    } failure:^(NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        self.tableView.hidden = YES;
        self.tipsView.hidden = NO;
        self.reloadButton.hidden = NO;
    }];
}



#pragma mark - layz

- (WGBaseTableView *)tableView{
    if (!_tableView){
        _tableView = [[WGBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = WGGrayColor(239);
        
        
        [_tableView registerClass:[ZXHomeTableViewCell class] forCellReuseIdentifier:[ZXHomeTableViewCell wg_cellIdentifier]];
        [_tableView registerClass:[ZXHomeAdTableViewCell class] forCellReuseIdentifier:[ZXHomeAdTableViewCell wg_cellIdentifier]];
        
    
        [WGCommonRefreshUtil configRefreshInScrollView:self.tableView target:self action:@selector(restartLoadData) headerRefreshType:WGCommonHeaderRefreshTypeRed];
        [WGCommonRefreshUtil configLoadMoreInScrollView:self.tableView target:self action:@selector(loadMore)];
        
        //footView
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WGNumScreenWidth(), 20)];
        footView.backgroundColor = UIColor.clearColor;
        _tableView.tableFooterView = footView;
    }
    return _tableView;
}

@end

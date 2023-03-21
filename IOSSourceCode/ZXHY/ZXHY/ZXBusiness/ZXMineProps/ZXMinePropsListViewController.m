//
//  ZXMinePropsListViewController.m
//  ZXHY
//
//  Created by Bern Mac on 9/13/21.
//

#import "ZXMinePropsListViewController.h"
#import "ZXMineBoxModel.h"
#import "ZXMineBoxListViewCell.h"

@interface ZXMinePropsListViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) WGBaseTableView            *tableView;

@property (nonatomic, strong) ZXMineBoxModel             *mineBoxModel;

@property (nonatomic, strong) NSString  *currentPage;
@property (nonatomic, strong) NSMutableArray  *boxList;

@end

@implementation ZXMinePropsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self zx_initializationXIB];
    
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
    
    self.tableView.hidden = YES;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
    }];
    
    UIImageView *logoView = [UIImageView wg_imageViewWithImageNamed:@"NotBlindBox"];
    [self.view addSubview:logoView];
    [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-10);
        make.width.offset(170);
        make.height.offset(160);
    }];
    
    UILabel *label = [UILabel labelWithFont:kFont(15) TextAlignment:NSTextAlignmentCenter TextColor:WGRGBAlpha(0, 0, 0, 0.65) TextStr:@"除了空空...什么也没有" NumberOfLines:1];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoView.mas_bottom).offset(5);
        make.left.right.equalTo(self.view);
        make.height.offset(20);
    }];
    
}


#pragma mark - Private Method

//下拉刷新
- (void)restartLoadData{
    
    self.currentPage = @"1";
    [self.boxList removeAllObjects];
    self.boxList = nil;
    

}

//上拉加载
- (void)loadMore{
    
    if ([self.currentPage isEqualToString:self.mineBoxModel.totalpage] || [self.mineBoxModel.totalpage intValue] == 0) return;
    
    self.currentPage = [NSString stringWithFormat:@"%d", [self.currentPage intValue] + 1];
    
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


#pragma mark - NetworkRequest



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
        _tableView.estimatedRowHeight = 130;
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

//
//  ZXMineBoxDetailsViewController.m
//  ZXHY
//
//  Created by Bern Mac on 8/30/21.
//

#import "ZXMineBoxDetailsViewController.h"
#import "ZXMineModel.h"
#import "ZXOpenResultsModel.h"
#import "ZXMineBoxDetailsTopViewCell.h"
#import "ZXMineBoxDetailsInfoCell.h"
#import "ZXMineBoxDetailsScoreCell.h"
#import "ZXMineBoxDetailsEvaluationCell.h"

@interface ZXMineBoxDetailsViewController ()
<
WGNavigationViewDelegate,
UITableViewDelegate,
UITableViewDataSource,
ZXMineBoxDetailsEvaluationCellDelegate
>

@property (nonatomic, strong) WGBaseTableView            *tableView;
@property (nonatomic, strong) UIView                     *headerBGView;
@property (nonatomic, strong) ZXOpenResultsModel         *resultsModel;

@property (nonatomic, assign) CGFloat  evaluationCellHeigh;

@end

@implementation ZXMineBoxDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self zx_initializationXIB];
    [self zx_setNavigationView];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    
    [self.navigationView wg_setIsBack:YES];
    
}

#pragma mark - Initialization UI

//设置Nav右边按钮
- (void)zx_setNavigationView{
    
    self.wg_mainTitle = @"行程详情";
    [self.navigationView wg_setTitleColor:UIColor.blackColor];
    self.navigationView.backgroundColor = [UIColor clearColor];
    [self.view bringSubviewToFront:self.navigationView];
    
    self.navigationView.delegate = self;

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
    
    UIView *tableFootVeiw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WGNumScreenWidth(), 40)];
    tableFootVeiw.backgroundColor = UIColor.clearColor;
    self.tableView.tableFooterView = tableFootVeiw;
    
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSLog(@"scrollView.contentOffset.y  ----- %lf",scrollView.contentOffset.y);
    
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
    
    self.navigationView.backgroundColor = WGRGBAlpha(255, 255, 255, [scrollView wg_alphaWhenScroll]);
}

#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0){
        
        ZXMineBoxDetailsTopViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZXMineBoxDetailsTopViewCell wg_cellIdentifier]];
        [cell zx_dataWithMineBoxResultsModel:self.resultsModel];
        return cell;
        
    }else if(indexPath.row == 1){
        
        ZXMineBoxDetailsInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZXMineBoxDetailsInfoCell wg_cellIdentifier]];
        [cell zx_dataWithMineBoxResultsModel:self.resultsModel];
        return cell;
        
    }else if(indexPath.row == 2){
        
        ZXMineBoxDetailsScoreCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZXMineBoxDetailsScoreCell wg_cellIdentifier]];
        [cell zx_dataWithMineBoxResultsModel:self.resultsModel];
        return cell;
        
    }else if (indexPath.row == 3){
        
        ZXMineBoxDetailsEvaluationCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZXMineBoxDetailsEvaluationCell wg_cellIdentifier]];
        cell.delegate = self;
        [cell zx_dataWithMineBoxResultsModel:self.resultsModel];
        return cell;
        
    }else{
        UITableViewCell *cell = [UITableViewCell new];
        cell.backgroundColor = UIColor.blueColor;
        return cell;
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0){
       
        return 190;
        
    }else if (indexPath.row == 1){
        
        return UITableViewAutomaticDimension;
        
    }else if (indexPath.row == 2){
        
        return 205;
        
    }else if (indexPath.row == 3){
        
        
        return self.evaluationCellHeigh;
        
    }

    return 0.1f;
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


#pragma mark - ZXMineBoxDetailsEvaluationCellDelegate

//满意
- (void)satisfied:(ZXMineBoxDetailsEvaluationCell *)evaluationCell{
    self.evaluationCellHeigh = 320;
    [self.tableView reloadData];
}

//不满意
- (void)notSatisfied:(ZXMineBoxDetailsEvaluationCell *)evaluationCell{
    self.evaluationCellHeigh = 500;
    [self.tableView reloadData];
}

//查看评价
- (void)checkReviewButton:(UIButton *)reviewButton WithCell:(ZXMineBoxDetailsEvaluationCell *)evaluationCell;{
    
    if (reviewButton.selected){
        if (self.resultsModel.mycommentlist.count > 4){
            self.evaluationCellHeigh = 440;
        }else if (self.resultsModel.mycommentlist.count > 2){
            self.evaluationCellHeigh = 375;
        }else{
            self.evaluationCellHeigh = 320;
        }
        
        
//        self.evaluationCellHeigh = 390;
    }else{
        self.evaluationCellHeigh = 240;
    }
    
    [self.tableView reloadData];
}

//评价完成后刷新
- (void)completeEvaluationReload:(ZXMineBoxDetailsEvaluationCell *)evaluationCell{
    [self ZX_ReqApiAgainGetBoxDetail];
}

#pragma mark - Private Method

//获取盲盒信息
- (void)ZX_ReqApiGetBoxDetail:(ZXOpenResultsModel *)resultsModel{
    
    self.resultsModel = resultsModel;
    
    if (self.resultsModel.islike == 1){
        
        self.evaluationCellHeigh = 250;
        
    }else if (self.resultsModel.islike == 2){
        
        
        if (self.resultsModel.mycommentlist.count){
            self.evaluationCellHeigh = 240;
        }else{
            self.evaluationCellHeigh = 450;
        }
        
    }else {
        
        self.evaluationCellHeigh = 200;
        
    }
    
    [self.tableView reloadData];

}

#pragma mark - NetworkRequest

//获取盲盒信息
- (void)ZX_ReqApiAgainGetBoxDetail{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict wg_safeSetObject:self.resultsModel.boxid forKey:@"boxid"];
    
    [WGUIManager wg_showHUD];
    WEAKSELF;
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiGetBoxDetail Parameter:dict success:^(NSDictionary * _Nonnull resultDic) {
        [WGUIManager wg_hideHUD];
        STRONGSELF;
        
        NSArray *dataList = [ZXOpenResultsModel wg_initObjectsWithOtherDictionary:resultDic key:@"data"];
        
        ZXOpenResultsModel *resultsModel = [dataList wg_safeObjectAtIndex:0];
        
        [self ZX_ReqApiGetBoxDetail:resultsModel];
    
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
        _tableView.estimatedRowHeight = 130;
        
        [_tableView registerNib:[UINib nibWithNibName:@"ZXMineBoxDetailsTopViewCell" bundle:nil] forCellReuseIdentifier:[ZXMineBoxDetailsTopViewCell wg_cellIdentifier]];
        
        [_tableView registerClass:[ZXMineBoxDetailsInfoCell class] forCellReuseIdentifier:[ZXMineBoxDetailsInfoCell wg_cellIdentifier]];

        [_tableView registerNib:[UINib nibWithNibName:@"ZXMineBoxDetailsScoreCell" bundle:nil] forCellReuseIdentifier:[ZXMineBoxDetailsScoreCell wg_cellIdentifier]];
        
        [_tableView registerClass:[ZXMineBoxDetailsEvaluationCell class] forCellReuseIdentifier:[ZXMineBoxDetailsEvaluationCell wg_cellIdentifier]];
        
    }
    return _tableView;
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


@end

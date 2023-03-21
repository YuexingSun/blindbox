//
//  ZXMapNavResultsGreenView.m
//  ZXHY
//
//  Created by Bern Lin on 2021/12/2.
//

#import "ZXMapNavResultsGreenView.h"
#import "ZXOpenResultsModel.h"
#import "ZXMapNavResultGreenHeaderCell.h"
#import "ZXMapNavEvaluationView.h"
#import "ZXMapNavHelpView.h"
#import "ZXWebViewViewController.h"

#define EvaluationViewSatisfiedH  ((IS_IPHONE_X_SER) ? ceil(CGRectGetHeight(UIScreen.mainScreen.bounds) * .37f) : ceil(CGRectGetHeight(UIScreen.mainScreen.bounds) * .46f))

#define EvaluationViewNotSatisfiedH  ceil(CGRectGetHeight(UIScreen.mainScreen.bounds) * .55f) + ((IS_IPHONE_X_SER) ? 20 : 100)

@interface ZXMapNavResultsGreenView()
<
UITableViewDelegate,
UITableViewDataSource,
ZXMapNavEvaluationViewDelegate,
ZXMapNavHelpViewDelegate
>

@property (nonatomic, strong) WGBaseTableView     *tableView;
@property (nonatomic, strong) ZXOpenResultsModel  *openResultsModel;
@property (nonatomic, strong) UIButton            *doneButton;
@property (nonatomic, strong) ZXMapNavEvaluationView *evaluationView;
@property (nonatomic, strong) WGGeneralSheetController *sheetVc;

@end



@implementation ZXMapNavResultsGreenView

- (instancetype)initWithFrame:(CGRect)frame withOpenResultsModel:(ZXOpenResultsModel *)openResultsModel{
    if (self = [super initWithFrame:frame]) {
        self.openResultsModel = openResultsModel;
        
        [self zx_initializationUI];
    }
    return self;
}


#pragma mark - Initialization UI

//初始化
- (void)zx_initializationUI{
    
    self.backgroundColor = WGRGBAlpha(0, 164, 115, 0.75);
    
    
    //帮组
    UIButton *helpButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [helpButton setBackgroundImage:IMAGENAMED(@"NavHelp2")  forState:UIControlStateNormal];
    [helpButton setImage:IMAGENAMED(@"NavHelp2") forState:UIControlStateNormal];
    [helpButton addTarget:self action:@selector(helpAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:helpButton];
    [helpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).offset(-40);
        make.left.mas_equalTo(self.mas_left).offset(40);
        make.height.width.offset(65);
    }];
    
    
    //完成
    self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.doneButton setBackgroundImage:IMAGENAMED(@"navDone")  forState:UIControlStateNormal];
    [self.doneButton addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.doneButton];
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(helpButton);
        make.left.mas_equalTo(helpButton.mas_right).offset(25);
        make.right.mas_equalTo(self.mas_right).offset(-40);
        make.height.offset(65);
//        make.width.offset(285);
    }];
    
//    NavHelp2
    
    //tableview
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(kNavBarHeight - 20);
        make.bottom.mas_equalTo(self.doneButton.mas_top).offset(-5);
        make.left.right.mas_equalTo(self);
    }];
    
    
}


#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZXMapNavResultGreenHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZXMapNavResultGreenHeaderCell wg_cellIdentifier]];
    [cell zx_openResultsModel:self.openResultsModel];
    cell.goonBtBlock = ^{
        if(self.delegate && [self.delegate respondsToSelector:@selector(closeResultsGreenView:)]){
            [self.delegate closeResultsGreenView:self];
        }
    };
    return cell;
    
}

#pragma mark - Private Method
//完成按钮响应
- (void)doneAction:(UIButton *)sender{
    
    if (kObjectIsEmpty(self.openResultsModel)) return;;
    
    ZXMapNavEvaluationView *evaluationView  = [[ZXMapNavEvaluationView alloc] initWithFrame:CGRectMake(0, 0, WGNumScreenWidth(), EvaluationViewSatisfiedH)];
    evaluationView.delegate = self;
    [evaluationView zx_openResultsModel:self.openResultsModel];
    self.evaluationView = evaluationView;
    self.sheetVc = [WGGeneralSheetController sheetControllerWithCustomView:evaluationView];
    [self.sheetVc showToCurrentVc];
}


//帮助响应
- (void)helpAction:(UIButton *)sender{
    if (kObjectIsEmpty(self.openResultsModel)) return;;
    
    ZXMapNavHelpView *view = [[ZXMapNavHelpView alloc] initWithFrame:CGRectMake(0, 0, WGNumScreenWidth(), 480)];
    view.delegate = self;
    [view zx_openResultsModel:self.openResultsModel];
    self.sheetVc = [WGGeneralSheetController  sheetControllerWithCustomView:view];
    [self.sheetVc showToCurrentVc];
}

#pragma mark - ZXMapNavEvaluationViewDelegate (评价View代理)

- (void)mapNavEvaluationView:(ZXMapNavEvaluationView *)evaluationView SelectorWithEvaluation:(UIButton *)sender{
    
    if (sender.tag == CancelButton ){
        [self.sheetVc dissmissSheetVc];
        return;
    }else if (sender.tag == SubmitButton){
        [self.sheetVc dissmisSheetVcCompletion:^{
            [WGNotification postNotificationName:ZXNotificationMacro_ExitNav object:nil];
            
            //有活动
            if (self.openResultsModel.activityinfo){
                ZXWebViewViewController *vc = [ZXWebViewViewController new];
                vc.webViewURL = self.openResultsModel.url;
                vc.webViewTitle = @"";
                [[WGUIManager wg_currentIndexNavTopController].navigationController pushViewController: vc animated:YES];
            }
        }];
        return;
    }
    
    
    
    CGFloat Y = 0;
    CGFloat H = 0;
    
    if (sender.tag == SatisfiedButtonTag){
        H = EvaluationViewSatisfiedH;
    }else if (sender.tag == NotSatisfiedButtonTag){
        H = EvaluationViewNotSatisfiedH;
    }
    Y = WGNumScreenHeight() - H ;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.evaluationView.mj_h =  H;
        self.evaluationView.mj_y =  Y;
    }];
    
}


#pragma mark - ZXMapNavHelpViewDelegate
- (void)zx_navHelpView:(ZXMapNavHelpView *)helpView NavHelpType:(NavHelpType)navHelpType{

    [self.sheetVc dissmissSheetVc];
}



#pragma mark - NetworkRequest
//盲盒到达后评价
- (void)zx_reqApiFinishBoxIslike:(NSString *)islike{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict wg_safeSetObject:self.openResultsModel.boxid forKey:@"boxid"];
    [dict wg_safeSetObject:islike forKey:@"islike"];
    
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiFinishBox Parameter:dict success:^(NSDictionary * _Nonnull resultDic) {
        [WGUIManager wg_hideHUD];
        
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
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 400;
        
        [_tableView registerClass:[ZXMapNavResultGreenHeaderCell class] forCellReuseIdentifier:[ZXMapNavResultGreenHeaderCell wg_cellIdentifier]];
    }
    return _tableView;
}

@end

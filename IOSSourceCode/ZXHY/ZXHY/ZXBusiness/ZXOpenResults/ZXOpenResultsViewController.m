//
//  ZXOpenResultsViewController.m
//  ZXHY
//
//  Created by Bern Mac on 7/30/21.
//

#import "ZXOpenResultsViewController.h"
#import "ZXOpenResultsModel.h"
#import "ZXStartView.h"
#import "CustomUIViewController.h"
#import "ZXMapNavViewController.h"
#import "ZXNavViewController.h"

@interface ZXOpenResultsViewController ()

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

@property (weak, nonatomic) IBOutlet UIView *moodTipsView;
@property (weak, nonatomic) IBOutlet UILabel *moodTipsLabel;

@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *consumptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *newnessLabel;
@property (weak, nonatomic) IBOutlet UILabel *mystiqueLabel;

@property (weak, nonatomic) IBOutlet UILabel *distanceValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *consumptionValueLabel;


@property (weak, nonatomic) IBOutlet UIView *newnessValueView;
@property (nonatomic, strong) ZXStartView  *newnessStartValueView;

@property (weak, nonatomic) IBOutlet UIView *mystiqueValueView;
@property (nonatomic, strong) ZXStartView  *mystiqueStartValueView;

@property (nonatomic, strong) ZXOpenResultsModel *resultsModel;
@property (nonatomic, strong) NSString  *boxid;

@property (weak, nonatomic) IBOutlet UIImageView *resultsTagView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end

@implementation ZXOpenResultsViewController

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationView.alpha = 0;
    self.navigationController.navigationBar.hidden  = YES;
    
    //禁止返回
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self zx_initializationXIB];
    
    [self zx_initWtihData];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}


#pragma mark - Initialization UI
//初始化XIB
- (void)zx_initializationXIB{
    
    self.backgroundView.layer.cornerRadius = 15;
    
    self.infoView.layer.cornerRadius = 8;
    
    self.moodTipsView.layer.cornerRadius = 30;
    
//    [self.goButton wg_setLayerRoundedCornersWithRadius:24];
//    NSArray * colors = @[WGRGBColor(248, 109, 148),WGRGBColor(237, 86, 88)];
//    [self.goButton wg_backgroundGradientHorizontalColors:colors];
    
    [self.logoImageView wg_setRoundedCornersWithRadius:47.5];
   
    
    self.newnessStartValueView = [ZXStartView new];
    [self.newnessValueView addSubview:self.newnessStartValueView ];
    [self.newnessStartValueView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(self.newnessValueView);
        make.width.offset(85);
    }];
    
    
    self.mystiqueStartValueView = [ZXStartView new];
    [self.mystiqueValueView addSubview:self.mystiqueStartValueView ];
    [self.mystiqueStartValueView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(self.mystiqueValueView);
        make.width.offset(85);
    }];
}


#pragma mark - Private Method

//马上起程
- (IBAction)goAction:(UIButton *)sender {
    

    //TODO: 修复
    CustomUIViewController *vc = [CustomUIViewController new];
    [vc zx_openResultslnglatModel:self.resultsModel ParentlistModel:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
//    ZXNavViewController *vc = [[ZXNavViewController alloc] init];
//    [vc zx_enterNavControllerWithResultsModel:self.resultsModel ParentlistModel:nil];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];

}


//终止行程
- (IBAction)backAction:(UIButton *)sender {
    [self ZX_ReqApiCancel];
}


//获取盒子信息
- (void)zx_getBlindBox:(NSDictionary *)resultDic{
    
    NSArray *dataList = [ZXOpenResultsModel wg_initObjectsWithOtherDictionary:resultDic key:@"data"];
    NSLog(@"-----%@",dataList);
    
    ZXOpenResultsModel *resultsModel = [dataList wg_safeObjectAtIndex:0];
    
    self.resultsModel = resultsModel;
    
}

//进行中数据传入
- (void)zx_getBeingBox:(NSString *)boxid{
    [self ZX_ReqApiGetBoxDetail:boxid];
}

//数据赋值
- (void)zx_initWtihData{
    self.titleLabel.text = self.resultsModel.title;
    
    ZXOpenResultsItemsModel *itemsModel = [self.resultsModel.items wg_safeObjectAtIndex:0];
    self.distanceLabel.text = [NSString stringWithFormat:@"%@",itemsModel.item];
    self.distanceValueLabel.text = [NSString stringWithFormat:@"%@",itemsModel.value];
    
    ZXOpenResultsItemsModel *itemsModel1 = [self.resultsModel.items wg_safeObjectAtIndex:1];
    self.consumptionLabel.text = [NSString stringWithFormat:@"%@",itemsModel1.item];
    self.consumptionValueLabel.text = [NSString stringWithFormat:@"%@",itemsModel1.value];
    
    ZXOpenResultsItemsModel *itemsModel2 = [self.resultsModel.items wg_safeObjectAtIndex:2];
    self.mystiqueLabel.text = [NSString stringWithFormat:@"%@",itemsModel2.item];
//    self.mystiqueValueLabel.text = [NSString stringWithFormat:@"%@",itemsModel2.value];
    
    ZXOpenResultsItemsModel *itemsModel3 = [self.resultsModel.items wg_safeObjectAtIndex:3];
    self.newnessLabel.text = [NSString stringWithFormat:@"%@",itemsModel3.item];
//    self.newnessValueLabel.text = [NSString stringWithFormat:@"%@",itemsModel3.value];
    
    
    [self.newnessStartValueView zx_scores:itemsModel2.value WithType:ZXStartType_Point];
    [self.mystiqueStartValueView zx_scores:itemsModel3.value WithType:ZXStartType_Point];
    
    
    self.moodTipsLabel.text = self.resultsModel.detail;
    self.moodTipsLabel.textColor =  WGHEXColor(self.resultsModel.colorlist.textcolor);
    self.moodTipsView.backgroundColor = WGHEXColor(self.resultsModel.colorlist.bgcolor);

    NSLog(@"\n\n---%@",self.resultsModel.colorlist.bgcolor);
    
    [self.logoImageView wg_setImageWithURL:[NSURL URLWithString:self.resultsModel.typelogo] placeholderImage:nil];
    
    self.backgroundView.backgroundColor = WGHEXColor(self.resultsModel.colorlist.varcolor);
    
    self.typeLabel.text = self.resultsModel.typenameStr;
    
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:self.resultsModel.pic] placeholderImage:nil];
    
    NSString *resultsTagSrt = @"ResultsTagOrg";
   
    if (self.resultsModel.indexid == 1){
        resultsTagSrt = @"ResultsTagOrg";
    }else if (self.resultsModel.indexid == 2){
        resultsTagSrt = @"ResultsTagBlue";
    }else if (self.resultsModel.indexid == 3){
        resultsTagSrt = @"ResultsTagPink";
    }
    self.resultsTagView.image = IMAGENAMED(resultsTagSrt);
}



#pragma mark - NetworkRequest
//起程盲盒
- (void)zx_reqApiStartBox{
   
    
    NSDictionary *dict = @{
        @"boxid":self.resultsModel.boxid?:@"",
        @"indexid":@(self.resultsModel.indexid)
    };
  
    WEAKSELF;
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiStartBox Parameter:dict success:^(NSDictionary * _Nonnull resultDic) {
        STRONGSELF;
        
        
    } failure:^(NSError * _Nonnull error) {

        
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
        [self zx_getBlindBox:resultDic];
        
        [self zx_initWtihData];
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}


//终止行程
- (void)ZX_ReqApiCancel{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict wg_safeSetObject:self.resultsModel.boxid forKey:@"boxid"];
    
    [WGUIManager wg_showHUD];
    WEAKSELF;
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiCancelBox Parameter:dict success:^(NSDictionary * _Nonnull resultDic) {
        [WGUIManager wg_hideHUD];
        STRONGSELF;
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        //TODO: 修复
//        [[AppDelegate wg_sharedDelegate].tabBarController zx_reqApiCheckBeingBox];
    } failure:^(NSError * _Nonnull error) {
        
        
    }];

}
@end

//
//  ZXBlindBoxViewController.m
//  ZXHY
//
//  Created by Bern Lin on 2021/11/26.
//

#import "ZXBlindBoxViewController.h"
#import <AMapNaviKit/AMapNaviKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "ZXBlindBoxConditionSelectView.h"
#import "ZXBlindBoxTypeSelectView.h"
#import "ZXMapNavViewController.h"
#import "ZXAnnotationView.h"
#import "ZXMapMeAnnotationView.h"
#import "BlindBoxViewModel.h"
#import "ZXBlindBoxViewModel.h"
#import "ZXCurrentBlindBoxStatusModel.h"
#import "ZXMapNavResultsGreenView.h"
#import "ZXBlindBoxBootPageView.h"
#import "ZXBlindBoxFloatTagView.h"

#define ZoomLevelMin    15.99
#define ZoomLevelMedium 13.4
#define ZoomLevelMax    11.6
#define CustomMapStyle @"BlindBoxMap"


@interface ZXBlindBoxViewController ()
<
MAMapViewDelegate,
ZXBlindBoxConditionSelectViewDelegate,
ZXBlindBoxTypeSelectViewDelegate,
ZXBlindBoxBootPageViewDelegate,
ZXBlindBoxFloatTagViewDelegate
>

@property (nonatomic, strong) WGGeneralSheetController *sheetVc;
@property (nonatomic, strong) WGGeneralAlertController *alertVC;

//地图上的控件
@property (nonatomic, strong) UIButton *conditionButon; //条件选择按钮
@property (nonatomic, strong) UIImageView *distanceImageView;//距离提示View
@property (nonatomic, strong) UIButton  *selectConditionTipsButton; //条件选择提示按钮
@property (nonatomic, strong) UIButton  *selectDistanceTipsButton; //距离选择提示按钮
@property (nonatomic, strong) ZXBlindBoxFloatTagView *floatTagView;//浮窗
@property (nonatomic, strong) UIImageView  *scopenotImageView;


//地图
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) MACircle *mapViewCircle;
@property (nonatomic, assign) double  radius;

//缩放按钮index
@property (nonatomic, assign) NSInteger  rangeIndex;
@property (nonatomic, strong) UIButton  *addButton;
@property (nonatomic, strong) UIButton  *subtractButton;


//标记数组
@property (nonatomic, strong) NSMutableArray *pointAnnotationList;

//自己标记
@property (nonatomic, strong) ZXMapMeAnnotationView  *meAnnotationView;

//起点 、终点 坐标
@property (nonatomic, strong) AMapNaviPoint *startPoint;
@property (nonatomic, strong) AMapNaviPoint *endPoint;

//数据
@property (nonatomic, strong) NSMutableArray  *dataList;
@property (nonatomic, strong) ZXBlindBoxViewModel  *blindBoxViewModel;
@property (nonatomic, strong) BlindBoxViewModel *boxModel;

//品类ID
@property (nonatomic, strong) NSString  *cateId;

//问答数组
@property (nonatomic, strong) NSMutableArray  *questionArray;

//进行中的View
@property (nonatomic, strong) ZXBlindBoxTypeSelectView *beginTypeSelectView;

//进行中的Model
@property (nonatomic, strong)  ZXCurrentBlindBoxStatusModel *statusModel;


@end

@implementation ZXBlindBoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self zx_initializationUI];
    
    self.rangeIndex = 1;

    
    //接收刷新通知
    [WGNotification addObserver:self selector:@selector(reloadNoti:) name:ZXNotificationMacro_BlindBox object:nil];
    
    //退出导航通知
    [WGNotification addObserver:self selector:@selector(exitNavNoti:) name:ZXNotificationMacro_ExitNav object:nil];
    
    //网络状态改变
    [WGNotification addObserver:self selector:@selector(networkStatusNoti:) name:ZXNotificationMacro_NetworkStatus object:nil];
    
    
    
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationView.alpha = 0;
    self.navigationController.navigationBar.hidden  = YES;

    //查询是否有进行中的盲盒
    [self zx_reqApiCheckBeingBox];
    
    //开启浮窗所有定时器
//    [self.floatTagView zx_resumeAllTimerRunloop];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   
   
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self zx_initializationMap];
}

#pragma mark - Initialization
//初始化UI
- (void)zx_initializationUI{
    
    //浮窗
    ZXBlindBoxFloatTagView *floatTagView = [[ZXBlindBoxFloatTagView alloc] initWithFrame:CGRectMake(0, kNavBarHeight - 40, WGNumScreenWidth(), 100)];
    floatTagView.delegate = self;
//    [self.view addSubview:floatTagView];
//    self.floatTagView = floatTagView;
    
    
    //范围没有
    self.scopenotImageView = [UIImageView wg_imageViewWithImageNamed:@"scopenot"];
    self.scopenotImageView.frame = CGRectMake(WGNumScreenWidth() / 2 - 140,kNavBarHeight + 80, 280, 57);
    self.scopenotImageView.alpha = 0;
    [self.view addSubview:self.scopenotImageView];
    
    
    CGFloat Y = WGNumScreenHeight() - 48 - [[AppDelegate wg_sharedDelegate].tabBarController zx_tabBarHeight];
    
    //距离提示
    UIImageView *distanceImageView = [UIImageView wg_imageViewWithImageNamed:@"500m"];
    distanceImageView.frame = CGRectMake(WGNumScreenWidth() / 2 - 70, Y - 50, 140, 50);
    distanceImageView.layer.shadowColor = WGHEXAlpha(@"000000", 0.25).CGColor;
    distanceImageView.layer.shadowOffset = CGSizeMake(0,4);
    distanceImageView.layer.shadowRadius = 3;
    distanceImageView.layer.shadowOpacity = 1;
    distanceImageView.clipsToBounds = NO;
    [self.view addSubview:distanceImageView];
    self.distanceImageView = distanceImageView;
    
    
     
    
    //条件选择按钮
    UIButton *conditionButon = [UIButton buttonWithType:UIButtonTypeCustom];
    [conditionButon setBackgroundImage:IMAGENAMED(@"NavCondition") forState:UIControlStateNormal];
    conditionButon.frame = CGRectMake(30, Y, 48, 48);
    conditionButon.layer.shadowColor = WGHEXAlpha(@"000000", 0.15).CGColor;
    conditionButon.layer.shadowOffset = CGSizeMake(0,4);
    conditionButon.layer.shadowRadius = 3;
    conditionButon.layer.shadowOpacity = 1;
    conditionButon.clipsToBounds = NO;
    [conditionButon addTarget:self action:@selector(zx_conditionAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:conditionButon];
    self.conditionButon = conditionButon;
    
   
    //缩放按钮
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(WGNumScreenWidth() - 78, Y - 50, 48, 98)];
    bgView.backgroundColor = UIColor.whiteColor;
    bgView.layer.shadowColor = WGHEXAlpha(@"000000", 0.15).CGColor;
    bgView.layer.shadowOffset = CGSizeMake(0,4);
    bgView.layer.shadowRadius = 3;
    bgView.layer.shadowOpacity = 1;
    bgView.layer.cornerRadius = 24;
    bgView.clipsToBounds = NO;
    [self.view addSubview:bgView];
    
    
    // +和-
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:IMAGENAMED(@"NavAdd") forState:UIControlStateNormal];
    addButton.frame = CGRectMake(0, 0, 48, 49);
    addButton.tag = 70001;
    [addButton setAdjustsImageWhenHighlighted:NO];
    [addButton addTarget:self action:@selector(zx_mapAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:addButton];
    self.addButton = addButton;
    
    UIButton *subtractButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [subtractButton setImage:IMAGENAMED(@"NavSubtract") forState:UIControlStateNormal];
    subtractButton.frame = CGRectMake(0, 49, 48, 49);
    subtractButton.tag = 70002;
    [subtractButton setAdjustsImageWhenHighlighted:NO];
    [subtractButton addTarget:self action:@selector(zx_mapAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:subtractButton];
    self.subtractButton = subtractButton;
    
    
    //横线。navLine
    UIImageView *navLine = [UIImageView wg_imageViewWithImageNamed:@"navLine"];
    navLine.frame = CGRectMake(18, 48, 12, 1);
    [bgView addSubview:navLine];
    
    
    //条件选择提示按钮
    UIButton *selectConditionTipsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectConditionTipsButton setBackgroundImage:IMAGENAMED(@"selectConditionTips") forState:UIControlStateNormal];
    selectConditionTipsButton.frame = CGRectMake(conditionButon.mj_x, conditionButon.mj_y - 50, 130, 40);
    [self.view addSubview:selectConditionTipsButton];
    selectConditionTipsButton.tag = 1;
    [selectConditionTipsButton addTarget:self action:@selector(zx_tipsAction:) forControlEvents:UIControlEventTouchUpInside];
    self.selectConditionTipsButton = selectConditionTipsButton;
    
    
    
    //距离选择提示按钮
    UIButton *selectDistanceTipsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectDistanceTipsButton setBackgroundImage:IMAGENAMED(@"selectDistanceTips") forState:UIControlStateNormal];
    selectDistanceTipsButton.frame = CGRectMake(WGNumScreenWidth() - 160, bgView.mj_y - 50, 130, 40);
    [self.view addSubview:selectDistanceTipsButton];
    selectDistanceTipsButton.tag = 2;
    [selectDistanceTipsButton addTarget:self action:@selector(zx_tipsAction:) forControlEvents:UIControlEventTouchUpInside];
    self.selectDistanceTipsButton = selectDistanceTipsButton;
    
    //显示或者隐藏
    self.selectConditionTipsButton.hidden = YES;
    self.selectDistanceTipsButton.hidden = YES;
    
    
    //构造圆
    self.radius = 0;
    self.mapViewCircle = [MACircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(self.mapView.userLocation.location.coordinate.latitude,self.mapView.userLocation.location.coordinate.longitude) radius:self.radius];
    [self.mapView addOverlay: self.mapViewCircle];
    
    
    
    
    //进行中的View
    self.beginTypeSelectView = [[ZXBlindBoxTypeSelectView alloc] initWithFrame:CGRectMake(0, 0, WGNumScreenWidth(), WGNumScreenHeight())];
    self.beginTypeSelectView.backgroundColor = WGRGBAlpha(0, 0, 0, 0.5);
    self.beginTypeSelectView.hidden = YES;
    [self.view addSubview:self.beginTypeSelectView];
    [self.view bringSubviewToFront:self.beginTypeSelectView];
    
    
    //首次进来操作指南
    if (![kUserDefaultsIsFristEntryBoxTips isEqualToString:@"1"]){
//        ZXBlindBoxBootPageView*view = [[ZXBlindBoxBootPageView alloc] initWithFrame:CGRectMake(0, 0, WGNumScreenWidth(), WGNumScreenHeight()) ];
//        view.delegate = self;
//        self.alertVC = [WGGeneralAlertController alertControllerWithCustomView:view];
//        [self.alertVC showToCurrentVc];
    }
}


//初始化Map
- (void)zx_initializationMap{
    [self.view addSubview:self.mapView];
    [self.view sendSubviewToBack:self.mapView];
 
}



#pragma mark - Notification
//刷新通知
- (void)reloadNoti:(NSNotification *)notice{
    
    [self zx_locationIsOpen];
    
    if ([self.statusModel.isbeing intValue] == 1) return;
    
    self.cateId = @"";
    
    [self zx_reqApiGetBoxType];
    
    //查询是否有进行中的盲盒
    [self zx_reqApiCheckBeingBox];
}

//评价完成通知
- (void)exitNavNoti:(NSNotification *)notice{
    self.beginTypeSelectView.hidden = YES;
    [self.alertVC dissmisAlertVcWithCompletion:^{
       
    }];
    //查询是否有进行中的盲盒
    [self zx_reqApiCheckBeingBox];
    
}

//网络状态改变通知
- (void)networkStatusNoti:(NSNotification *)notice{
    
    [self zx_reqApiGetBoxType];
    //查询是否有进行中的盲盒
    [self zx_reqApiCheckBeingBox];
}



#pragma mark - Private Method

//判断定位是否可用
- (BOOL)zx_locationIsOpen{
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)) {
        
        //定位功能可用
        return  YES;
        
    }
    else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {

        //定位不能用
        //设置提示提醒用户打开定位服务
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"允许定位提示" message:@"请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]){
                [[UIApplication sharedApplication] openURL:url];
            }
        }];

        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alert addAction:okAction];
        [alert addAction:cancelAction];
        [[WGUIManager wg_topViewController] presentViewController:alert animated:YES completion:nil];
        
        
        return NO;

    }
    return  NO;
    
}

//隐藏或显示范围无数据
- (void)zx_hideScopenotImageView:(BOOL)hide{

    [UIView animateWithDuration:0.3 animations:^{
        if (hide){
            self.scopenotImageView.alpha = 0;
        }else{
            self.scopenotImageView.alpha = 1;
            
        }
    }];

}



//提示按钮响应
- (void)zx_tipsAction:(UIButton *)sender{
    
    if (sender.tag == 1){
        ZX_SetUserDefaultsIsFristEntryBoxTips(@"1");
        self.selectConditionTipsButton.hidden = YES;
        
    }else if (sender.tag == 2){
        ZX_SetUserDefaultsIsCloseExitNavTips(@"1");
        self.selectDistanceTipsButton.hidden = YES;
    }
    
    
}

//条件按钮响应
- (void)zx_conditionAction:(UIButton *)sender{
    
    CGFloat Height = 550;
    ZXBlindBoxConditionSelectView * topListView = [[ZXBlindBoxConditionSelectView alloc] initWithFrame:CGRectMake(0, 0, WGNumScreenWidth(), Height)];
    topListView.delegate = self;
    [topListView zx_reqApiGetBoxQuesListWithTypeId:self.boxModel.typeId];
    self.sheetVc = [WGGeneralSheetController  sheetControllerWithCustomView:topListView];
    [self.sheetVc showToCurrentVc];
 
}

//地图缩放按钮响应
- (void)zx_mapAction:(UIButton *)sender{
    
    if (!self.dataList.count) return;
    
    if (sender.tag == 70001 ){
        
        self.rangeIndex++;
    }
    else if (sender.tag == 70002){
        
        self.rangeIndex--;
    }
    
    
    //限制rangIndex
    if (self.rangeIndex <= 0){
        self.rangeIndex = 0;
        [self.subtractButton setImage:IMAGENAMED(@"NavSubtractGray") forState:UIControlStateNormal];
        self.subtractButton.userInteractionEnabled = NO;
    } else if (self.rangeIndex >= self.dataList.count){
        
        self.rangeIndex = self.dataList.count - 1;

    } else if (self.rangeIndex == self.dataList.count - 1){
        [self.addButton setImage:IMAGENAMED(@"NavAddGray") forState:UIControlStateNormal];
        
        self.addButton.userInteractionEnabled = NO;
        
        
    } else {
        self.addButton.userInteractionEnabled = YES;
        self.subtractButton.userInteractionEnabled = YES;
        [self.addButton setImage:IMAGENAMED(@"NavAdd") forState:UIControlStateNormal];
        [self.subtractButton setImage:IMAGENAMED(@"NavSubtract") forState:UIControlStateNormal];
    }
    
    
    
    NSLog(@"\n\n rangeIndex----%ld",self.rangeIndex);
    
    
    //提示logo更换
    NSArray * tipsLogoArray = @[IMAGENAMED(@"500m"),IMAGENAMED(@"3km"),IMAGENAMED(@"10km")];
    UIImage *image = [tipsLogoArray wg_safeObjectAtIndex:self.rangeIndex];
    self.distanceImageView.image = image;
    
    
    //缩放大小
    NSArray * zoomLeveArray = @[@(ZoomLevelMin),@(ZoomLevelMedium),@(ZoomLevelMax)];
    double zoomLeve = [[zoomLeveArray wg_safeObjectAtIndex:self.rangeIndex] doubleValue];
    [self.mapView setZoomLevel:zoomLeve  animated:YES];
    
    
    //范围蓝圈实际距离
    ZXBlindBoxViewParentlistModel *parentlistModel = [self.dataList wg_safeObjectAtIndex:self.rangeIndex];
    
    self.radius = parentlistModel.range;
    [self.mapViewCircle setCircleWithCenterCoordinate:CLLocationCoordinate2DMake(self.mapView.userLocation.location.coordinate.latitude,self.mapView.userLocation.location.coordinate.longitude) radius:self.radius];
    
   
    //标记点
    [self.mapView removeAnnotations:self.pointAnnotationList];
    self.pointAnnotationList = [NSMutableArray array];
    for (ZXOpenResultsModel *resultsModel in parentlistModel.childlist){
        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake([resultsModel.lnglat.lat doubleValue], [resultsModel.lnglat.lng doubleValue]);
        [self.pointAnnotationList wg_safeAddObject:pointAnnotation];
    }
    [self.mapView addAnnotations:self.pointAnnotationList];

    
    //范围内没有数据提示
    [self zx_hideScopenotImageView:parentlistModel.childlist.count];
    
 
}



#pragma mark - MAMapViewDelegate
-(MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay{
    
    if ([overlay isKindOfClass:[MACircle class]]){
        MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];
        circleRenderer.lineWidth    = 1.f;
        circleRenderer.strokeColor  = WGRGBAlpha(61, 139, 255, 0.8);
        circleRenderer.fillColor    = WGRGBAlpha(61, 139, 255, 0.25);
        return circleRenderer;
    }
    return nil;
}


- (void)mapViewRequireLocationAuth:(CLLocationManager *)locationManager{
    
}


- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{

    
    if (updatingLocation){
        
        //浮窗
        if (!self.startPoint){
            [self.floatTagView zx_inputStartPoint:userLocation.coordinate];
        }
        
        
        //用户起始坐标
        self.startPoint = [AMapNaviPoint locationWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
        
        //范围圈
        [self.mapViewCircle setCircleWithCenterCoordinate:CLLocationCoordinate2DMake(self.mapView.userLocation.location.coordinate.latitude,self.mapView.userLocation.location.coordinate.longitude) radius:self.radius];
        
        if (kObjectIsEmpty(self.boxModel)){
            //获取可选盲盒类型
            [self zx_reqApiGetBoxType];
        }
        
        
       
    }
    //heading数据更新
    else{
        self.meAnnotationView.heading = userLocation.heading;
    }

}

//在地图View停止定位后，会调用此函数
- (void)mapViewDidStopLocatingUser:(MAMapView *)mapView{
    
    
}

// 定位失败后，会调用此函数
- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    [self zx_locationIsOpen];
}

//自定义标注图标
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    
    
//    annotation.
    
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        
        static NSString *reuseIndetifier = @"meReuseIndetifier";
        
        ZXMapMeAnnotationView *annotationView = (ZXMapMeAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil){
            annotationView = [[ZXMapMeAnnotationView alloc] initWithAnnotation:annotation
                                                               reuseIdentifier:reuseIndetifier];
        }
        annotationView.centerOffset = CGPointMake(0, 0);
       
        annotationView.heading = mapView.userLocation.heading;
        
        self.meAnnotationView = annotationView;
        
        return annotationView;
    }

    if ([annotation isKindOfClass:[MAPointAnnotation class]]){

        
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";

        ZXAnnotationView *annotationView = (ZXAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];

        if (annotationView == nil){
            annotationView = [[ZXAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
          
        }

        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -47.5);
        
        
        
        return annotationView;
    }
    
    return nil;
}


- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    
    for (int i = 0 ; i < views.count ;i++){
        
        MAAnnotationView  *annotationView = [views wg_safeObjectAtIndex:i];
        
        annotationView.selected = NO;
        annotationView.canShowCallout = NO;
    }
    
    
    for (int i = 0 ; i < mapView.annotations.count; i++){
        MAPointAnnotation *annotation = [mapView.annotations wg_safeObjectAtIndex:i];
        
        ZXAnnotationView *zxannotationView = (ZXAnnotationView *)[mapView viewForAnnotation:annotation];
        //选中
        zxannotationView.tag = i;
        
        ZXBlindBoxViewParentlistModel *parentlistModel = [self.dataList wg_safeObjectAtIndex:self.rangeIndex];
        ZXOpenResultsModel *resultsModel = [parentlistModel.childlist wg_safeObjectAtIndex:i];
        [zxannotationView zx_openResultsModel:resultsModel];
        
    }
}


//选中
- (void)mapView:(MAMapView *)mapView didAnnotationViewTapped:(MAAnnotationView *)view{
    if (![view isKindOfClass:[ZXAnnotationView class]]) {
        return;
    }
       
    ZXBlindBoxViewParentlistModel *parentlistModel = [self.dataList wg_safeObjectAtIndex:self.rangeIndex];
    parentlistModel.startPoint = self.startPoint;
    parentlistModel.selectIndex = view.tag;

    ZXBlindBoxTypeSelectView *typeSelectView = [[ZXBlindBoxTypeSelectView alloc] initWithFrame:CGRectMake(0, 0, WGNumScreenWidth(), WGNumScreenHeight())];
    typeSelectView.delegate = self;
    [typeSelectView zx_parentlistModel:parentlistModel];
    self.alertVC = [WGGeneralAlertController alertControllerWithCustomView:typeSelectView];
    [self.alertVC showToCurrentVc];
}


#pragma mark - ZXBlindBoxFloatTagViewDelegate(浮窗代理)
//选中Item cateId
- (void)zx_blindBoxFloatTagView:(ZXBlindBoxFloatTagView *)floatTagView didSelectItemAtCateId:(NSString *)cateId{
    self.cateId = cateId;
    
    [self zx_reqApiGetBox];
}



#pragma mark - ZXBlindBoxBootPageViewDelegate(首次进来导航栏)
//关闭
- (void)zx_closeBlindBoxBootPageView:(ZXBlindBoxBootPageView *)bootPageView{
    [self.alertVC dissmisAlertVc];
}



#pragma mark - ZXBlindBoxConditionSelectViewDelegate

//取消代理
- (void)zx_closeBlindBoxConditionSelectView:(ZXBlindBoxConditionSelectView *)conditionSelectView{
 
    [self.sheetVc dissmissSheetVc];
}

//确定代理
- (void)zx_sureBlindBoxConditionSelectView:(ZXBlindBoxConditionSelectView *)conditionSelectView  QuestionArray:(NSMutableArray *)questionArray{
    
    [self.sheetVc dissmissSheetVc];
    self.questionArray = questionArray;
    [WGNotification postNotificationName:ZXNotificationMacro_BlindBoxTabbarReload object:@"1"];
    [self zx_reqApiGetBox];
}


#pragma mark - ZXBlindBoxTypeSelectViewDelegate
//出发
- (void)zx_goBlindBoxTypeSelectView:(ZXBlindBoxTypeSelectView *)typeSelectView{
    [self.alertVC dissmisAlertVc];
}


#pragma mark - NetworkRequest

//获取可选盲盒类型
- (void)zx_reqApiGetBoxType{
    
    self.conditionButon.userInteractionEnabled = NO;
        
    [WGNotification postNotificationName:ZXNotificationMacro_BlindBoxTabbarReload object:@"1"];
    
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiGetBoxType Parameter:@{} success:^(NSDictionary * _Nonnull resultDic) {
        
        NSArray *dataArray = [BlindBoxViewModel wg_initObjectsWithOtherDictionary:resultDic key:@"data"];
        self.boxModel = [dataArray wg_safeObjectAtIndex:0];
        
        self.conditionButon.userInteractionEnabled = YES;
        
        //获取盲盒
        [self zx_reqApiGetBox];

        
    } failure:^(NSError * _Nonnull error) {
        self.conditionButon.userInteractionEnabled = YES;
    }];
}


//获取盲盒
- (void)zx_reqApiGetBox{
    
    NSString *lng = [NSString stringWithFormat:@"%f",self.mapView.userLocation.coordinate.longitude];
    NSString *lat = [NSString stringWithFormat:@"%f",self.mapView.userLocation.coordinate.latitude];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict wg_safeSetObject:self.boxModel.typeId forKey:@"typeid"];
    [dict wg_safeSetObject:self.cateId forKey:@"cateid"];
    [dict wg_safeSetObject:lng forKey:@"lng"];
    [dict wg_safeSetObject:lat forKey:@"lat"];
    [dict wg_safeSetObject:[self.questionArray wg_modelWithJSON] forKey:@"jsonstr"];
    
    
    WEAKSELF;
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiGetBox Parameter:dict success:^(NSDictionary * _Nonnull resultDic) {
        STRONGSELF;
        //发送停止旋转通知
        [WGUIManager wg_hideHUD];
        [WGNotification postNotificationName:ZXNotificationMacro_BlindBoxTabbarReload object:@"2"];

        self.blindBoxViewModel = [ZXBlindBoxViewModel wg_objectWithDictionary:[resultDic wg_safeObjectForKey:@"data"]];
        
        self.dataList = [NSMutableArray arrayWithArray:self.blindBoxViewModel.parentlist];
        
        [self zx_mapAction:[UIButton new]];
        
        //更新地图自己emo
        [self.meAnnotationView zx_blindBoxViewModel:self.blindBoxViewModel];
    
    
    } failure:^(NSError * _Nonnull error) {
        //发送停止旋转通知
        [WGUIManager wg_hideHUD];
        [WGNotification postNotificationName:ZXNotificationMacro_BlindBoxTabbarReload object:@"2"];
        
    }];
    
}


//查询是否有进行中的盲盒
- (void)zx_reqApiCheckBeingBox{
    
    WEAKSELF;
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiCheckBeingBox Parameter:@{} success:^(NSDictionary * _Nonnull resultDic) {
        STRONGSELF;

        
        self.statusModel = [ZXCurrentBlindBoxStatusModel wg_objectWithDictionary:resultDic[@"data"]];
        
        //是否有在进行中的盒子
        if ([self.statusModel.isbeing intValue] == 1){
            [self zx_reqApiGetBoxDetail:self.statusModel.boxid withCurrentStatus:[self.statusModel.status integerValue]];
        }
        
        [WGNotification postNotificationName:ZXNotificationMacro_BlindBoxIsBeingBox object:self.statusModel];
        
        
    } failure:^(NSError * _Nonnull error) {
        [WGUIManager wg_hideHUD];
        self.beginTypeSelectView.hidden = YES;
        [self.alertVC dissmisAlertVc];
        
    }];
    
}


//获取盲盒信息
- (void)zx_reqApiGetBoxDetail:(NSString *)boxid withCurrentStatus:(NSInteger)status{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict wg_safeSetObject:boxid forKey:@"boxid"];

    WEAKSELF;
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiGetBoxDetail Parameter:dict success:^(NSDictionary * _Nonnull resultDic) {
        [WGUIManager wg_hideHUD];
        STRONGSELF;
        
        ZXBlindBoxViewModel *blindBoxViewModel = [ZXBlindBoxViewModel wg_objectWithDictionary:resultDic[@"data"]];
       
        ZXBlindBoxViewParentlistModel *parentlistModel = [blindBoxViewModel.parentlist wg_safeObjectAtIndex:blindBoxViewModel.selparentindex];
       
        ZXOpenResultsModel *OpenResultsModel = [parentlistModel.childlist wg_safeObjectAtIndex: blindBoxViewModel.selchildindex];
        
        //未到达的盒子
        if (status == 1 && parentlistModel){
            NSArray  *childlist = [NSArray arrayWithObject:OpenResultsModel];
            parentlistModel.childlist = childlist;
            self.beginTypeSelectView.hidden = NO;
            [self.beginTypeSelectView zx_beginParentlistModel:parentlistModel];
        }
      
        //未评价的盒子
        else if (status == 2 && parentlistModel){
            
            OpenResultsModel.startPoint = self.startPoint;
            ZXMapNavResultsGreenView *greenView = [[ZXMapNavResultsGreenView alloc] initWithFrame:CGRectMake(0, 0, WGNumScreenWidth(),  WGNumScreenHeight()) withOpenResultsModel:OpenResultsModel];
            
            if (self.alertVC){
                [self.alertVC dissmisAlertVcWithCompletion:^{
                    
                    self.alertVC = [WGGeneralAlertController alertControllerWithCustomView:greenView];
                    [self.alertVC showToCurrentVc];
                }];
            }else{
                self.alertVC = [WGGeneralAlertController alertControllerWithCustomView:greenView];
                [self.alertVC showToCurrentVc];
            }
            
            
            
        }
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}




#pragma mark - layz
- (MAMapView *)mapView{
    if (!_mapView){
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, WGNumScreenWidth(), WGNumScreenHeight())];
        _mapView.delegate = self;
        _mapView.rotateCameraEnabled= YES;   //是否支持camera旋转, 默认YES
        _mapView.scrollEnabled = NO;    //NO表示禁用滑动手势，YES表示开启
        _mapView.zoomEnabled = NO;    //NO表示禁用缩放手势，YES表示开启
        _mapView.rotateEnabled= NO;    //NO表示禁用旋转手势，YES表示开启
        [_mapView setZoomLevel:ZoomLevelMin animated:YES]; //缩放比例
        _mapView.showsCompass = NO; //指南针显示
        
        //如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = MAUserTrackingModeFollow;

        //设定定位的最小更新距离。默认为kCLDistanceFilterNone，会提示任何移动
        _mapView.distanceFilter  = 50.0;
        //设定定位精度。默认为kCLLocationAccuracyBest
        _mapView.desiredAccuracy  = 10.0;
        
        //自定义地图样式
        NSString *path = [NSString stringWithFormat:@"%@/%@.data", [NSBundle mainBundle].bundlePath ,CustomMapStyle];
        NSData *data = [NSData dataWithContentsOfFile:path];
        MAMapCustomStyleOptions *options = [[MAMapCustomStyleOptions alloc] init];
        options.styleData = data;
        [_mapView setCustomMapStyleOptions:options];
        _mapView.customMapStyleEnabled = YES;

       
    }
    return _mapView;
}

@end

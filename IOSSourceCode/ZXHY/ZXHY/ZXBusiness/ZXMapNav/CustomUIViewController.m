//
//  CustomUIViewController.m
//  DevDemoNavi
//
//  Created by eidan on 2018/5/11.
//  Copyright © 2018年 Amap. All rights reserved.
//

#import "CustomUIViewController.h"
#import <AMapNaviKit/AMapNaviKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "ZXOpenResultsModel.h"
#import "ZXMapFirstEntryTipsView.h"
#import "ZXMapNavResultsView.h"
#import "ZXMapNavManager.h"
#import <AudioToolbox/AudioToolbox.h>

#import "ZXMapNavDetailsView.h"
#import "ZXBlindBoxViewModel.h"
#import "ZXMapNavEndPointView.h"
#import "ZXMapNavResultsGreenView.h"
#import "ZXTerminalAnnotationView.h"
#import "ZXMapMeAnnotationView.h"


#define ProximityDistance 120
#define EmulatorNaviSpeed 120
#define CarImage @"NavCar"
#define CustomMapStyle @"BlindBoxMap"

@interface CustomUIViewController ()
<
AMapNaviDriveViewDelegate,
AMapNaviDriveManagerDelegate,
AMapNaviDriveDataRepresentable,
AMapNaviWalkViewDelegate,
AMapNaviWalkManagerDelegate,
AMapNaviWalkDataRepresentable,
AMapLocationManagerDelegate,
ZXMapFirstEntryTipsViewDelegate,
ZXMapNavResultsViewDelegate,
ZXMapNavResultsGreenViewDelegate,
UIAlertViewDelegate,
MAMapViewDelegate
>

//
@property (nonatomic, strong) WGGeneralAlertController *sheetVC;

//定位
@property (nonatomic, strong) AMapLocationManager  *locationManager;

@property (nonatomic, strong) AMapNaviPoint *startPoint;
@property (nonatomic, strong) AMapNaviPoint *endPoint;
//驾车导航
@property (nonatomic, strong) AMapNaviDriveView *driveView;
//步行导航
@property (nonatomic, strong) AMapNaviWalkView *walkView;
@property (nonatomic, strong) AMapNaviRouteGroup *walkGroup;

//当前位置naviLocation
@property (nonatomic, strong) AMapNaviLocation *naviLocation;

//定时器
@property (nonatomic, strong) NSTimer *timer;



//xib views
@property (weak, nonatomic) IBOutlet UIView *topBgView;
@property (weak, nonatomic) IBOutlet UIView *topBgWhiteView;

@property (nonatomic, weak) IBOutlet UIView *topInfoBgView;
@property (nonatomic, weak) IBOutlet UIImageView *topTurnImageView;
@property (nonatomic, weak) IBOutlet UILabel *topRemainLabel;
@property (weak, nonatomic) IBOutlet UILabel *topRemainUnitLabel;
@property (nonatomic, weak) IBOutlet UILabel *topRoadLabel;
@property (nonatomic, weak) IBOutlet UIImageView *crossImageView;

@property (nonatomic, weak) IBOutlet UIButton *closeBtn;

//底部距离提醒
@property (weak, nonatomic) IBOutlet UIView *routeRemainInfoBgView;
@property (nonatomic, weak) IBOutlet UIView *routeRemianInfoView;
@property (weak, nonatomic) IBOutlet UIView *routeRemainnInfoLogoView;

@property (nonatomic, weak) IBOutlet UILabel *routeRemainInfoLabel;
@property (nonatomic, weak) IBOutlet UIButton *rightBrowserBtn;
@property (nonatomic, weak) IBOutlet UIView *startEndPointInfoView;
@property (nonatomic, weak) IBOutlet AMapNaviTrafficBarView *trafficBarView;
//模拟导航按钮
@property (nonatomic, weak) IBOutlet UIButton *rightTrafficBtn;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topInfoViewTopSpace;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottomInfoLabelBottomSpace;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topInfoViewLeftSpace;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *crossImageViewHeight;


@property (nonatomic, weak) IBOutlet UILabel *theEndLabel;
@property (nonatomic, weak) IBOutlet UILabel *theEndDetailsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *endDetailsImageView;
@property (weak, nonatomic) IBOutlet UIButton *endDetailsButton;


@property (nonatomic, strong) ZXOpenResultsModel *openResultsModel;
@property (nonatomic, strong) ZXBlindBoxViewParentlistModel *parentlistModel;

//当前相差距离
@property (nonatomic, assign)  NSInteger remainDistance;


@property (nonatomic, strong) ZXMapNavDetailsView *detailsView;

@property (nonatomic, strong) ZXMapNavEndPointView *endPointView;

//地图
@property (nonatomic, strong) MAMapView  *mapView;
//终点标注
@property (nonatomic, strong)  ZXTerminalAnnotationView *terminalAnnotationView;
//自己标注
@property (nonatomic, strong)  ZXMapMeAnnotationView *meAnnotationView;

//测试
@property (nonatomic, copy) void(^itemBtBlock)(void);


@end

@implementation CustomUIViewController

#pragma mark - LifeCycle

- (instancetype)init {
    self = [super initWithNibName:@"CustomUIViewController" bundle:nil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //初始化xib界面上的元素
    [self updateViewsWhenInit];
    
   
    
    //通知关闭导航
    [WGNotification addObserver:self selector:@selector(zx_back) name:ZXNotificationMacro_ExitNav object:nil];


    self.detailsView = [[ZXMapNavDetailsView alloc] initWithFrame:CGRectMake(0, 0, WGNumScreenWidth(), WGNumScreenHeight())];
    [self.detailsView zx_openResultslnglatModel:self.openResultsModel ParentlistModel:self.parentlistModel];
    [self.view addSubview:self.detailsView];
    
    //隐藏XIB元素
    [self zx_xibElementIsHidden:YES];
    
    
    

    
    
#ifdef DEBUG
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
   //长按时间
    longPress.minimumPressDuration = 2.2;
    [self.detailsView addGestureRecognizer:longPress];
    
    
    self.itemBtBlock = ^{
//        self.topBgView.backgroundColor = UIColor.redColor;
    };
    
    self.itemBtBlock();

#endif
    
}

//长按响应
-(void)longPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
 
        
        if (self.openResultsModel.currentNavType == ZXCurrentNavType_Drive){
            //驾驶模拟导航
            [[AMapNaviDriveManager sharedInstance] stopNavi];
            [[AMapNaviDriveManager sharedInstance] setEmulatorNaviSpeed:EmulatorNaviSpeed];
            [[AMapNaviDriveManager sharedInstance] startEmulatorNavi];

        }else{
            //步行模拟导航
            [[AMapNaviWalkManager sharedInstance] stopNavi];
            [[AMapNaviWalkManager sharedInstance] setEmulatorNaviSpeed:EmulatorNaviSpeed];
            [[AMapNaviWalkManager sharedInstance] startEmulatorNavi];
        }
    }
   
}



- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.toolbarHidden = YES;
    self.navigationView.alpha = 0;
    self.navigationController.navigationBar.hidden  = YES;
    
    //禁止右滑返回
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
    
}

#pragma mark - Setup
//初始化xib界面上的元素
- (void)updateViewsWhenInit {

    
    self.topBgView.layer.cornerRadius = 20;
    
    self.routeRemainInfoBgView.layer.cornerRadius = 50;
    self.routeRemainInfoBgView.alpha = 0;
    
    self.closeBtn.layer.cornerRadius = 15;
    self.closeBtn.layer.borderColor = WGRGBAlpha(255, 255, 255, 0.3).CGColor;
    self.closeBtn.layer.borderWidth = 0.7;
    
    self.routeRemianInfoView.layer.cornerRadius = 40;
    self.routeRemainnInfoLogoView.layer.cornerRadius = 20;
    
    self.startEndPointInfoView.layer.cornerRadius = 5;
    self.startEndPointInfoView.hidden = YES;
    
    self.trafficBarView.borderWidth = 2.5;
    self.trafficBarView.hidden = YES;
    self.rightTrafficBtn.hidden = NO;
    self.rightBrowserBtn.hidden = NO;
    
    self.crossImageViewHeight.constant = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) * 16.0 / 25.0;  //路口放大图宽高为25:16
    self.crossImageView.hidden = YES;
    
    if ([self isiPhoneX]) {
        self.topInfoViewTopSpace.constant = 30;
        self.bottomInfoLabelBottomSpace.constant = 12;
        self.topInfoViewLeftSpace.constant = 24;
    }
    
    //hide
    self.topInfoBgView.hidden =  NO;
    self.topInfoBgView.layer.cornerRadius = 5;
    
    
    self.theEndLabel.text = self.openResultsModel.buildName;
    self.theEndDetailsLabel.text = self.openResultsModel.address;
    
    
    self.routeRemianInfoView.backgroundColor = UIColor.whiteColor;
    self.routeRemianInfoView.layer.shadowColor = WGRGBAlpha(0, 0, 0, 0.3).CGColor;
    self.routeRemianInfoView.layer.shadowOffset = CGSizeMake(0,4);
    self.routeRemianInfoView.layer.shadowRadius = 6;
    self.routeRemianInfoView.layer.shadowOpacity = 1;
    
    self.rightBrowserBtn.backgroundColor = UIColor.whiteColor;
    self.rightBrowserBtn.layer.shadowColor = WGRGBAlpha(0, 0, 0, 0.3).CGColor;
    self.rightBrowserBtn.layer.shadowOffset = CGSizeMake(0,4);
    self.rightBrowserBtn.layer.shadowRadius = 6;
    self.rightBrowserBtn.layer.shadowOpacity = 1;
    
    self.rightTrafficBtn.backgroundColor = UIColor.whiteColor;
    self.rightTrafficBtn.layer.shadowColor = WGRGBAlpha(0, 0, 0, 0.3).CGColor;
    self.rightTrafficBtn.layer.shadowOffset = CGSizeMake(0,4);
    self.rightTrafficBtn.layer.shadowRadius = 6;
    self.rightTrafficBtn.layer.shadowOpacity = 1;
    
    self.endDetailsButton.userInteractionEnabled = NO;
}



//传入模型
- (void)zx_openResultslnglatModel:(ZXOpenResultsModel *)openResultsModel ParentlistModel:(ZXBlindBoxViewParentlistModel *)parentlistModel{
    
    self.openResultsModel = openResultsModel;
    self.parentlistModel = parentlistModel;

    //计算道路
    [self zx_calculateRouteWithPlan];

}



#pragma mark - Private Method
// 计划路线并选择出行方式
- (void)zx_calculateRouteWithPlan{
    
    self.endPoint = [AMapNaviPoint locationWithLatitude:[self.openResultsModel.lnglat.lat floatValue] longitude:[self.openResultsModel.lnglat.lng floatValue]];
    
    AMapNaviPOIInfo *startPOIInfo = [[AMapNaviPOIInfo alloc] init];
   
    AMapNaviPOIInfo *endPOIInfo = [[AMapNaviPOIInfo alloc] init];
    endPOIInfo.locPoint = self.endPoint;
    
    
    WEAKSELF;
    [[AMapNaviDriveManager sharedInstance] independentCalculateDriveRouteWithStartPOIInfo:startPOIInfo endPOIInfo:endPOIInfo wayPOIInfos:nil drivingStrategy:AMapNaviDrivingStrategyMultipleDefault callback:^(AMapNaviRouteGroup * _Nullable routeGroup, NSError * _Nullable error) {
        STRONGSELF;
        
        if (error){
            
            
            if (error.code == AMapNaviCalcRouteStateCLAuthorizationStatusDenied || error.code == AMapNaviCalcRouteStateCLAuthorizationReducedAccuracy ){
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
            }
            return;
        }
        
        //获取起点坐标
        self.openResultsModel.startPoint = routeGroup.naviRoute.routeStartPoint;
        self.startPoint = routeGroup.naviRoute.routeStartPoint;

        
       
        //获取地图
        MAMapView *mapView = [MAMapView new];
        
        //选择出行方式 （>3000 驾车、<3000步行）
        if (routeGroup.naviRoute.routeLength > 3000){
            self.openResultsModel.currentNavType = ZXCurrentNavType_Drive;
            //驾驶导航
            [self zx_startDriveNavi];
            
            //获取地图
            mapView = [self.driveView valueForKeyPath:@"naviMapView.internalMapView"];
           
        }else{
            self.openResultsModel.currentNavType = ZXCurrentNavType_Walk;
            //步行导航
            [self zx_startWalkNavi];
            
            //获取地图
            mapView = [self.walkView valueForKeyPath:@"naviMapView.internalMapView"];
            
        }
        
        
        //添加终点标记
        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(self.endPoint.latitude, self.endPoint.longitude);
        mapView.delegate = self;
        [mapView addAnnotation:pointAnnotation];
        
        self.mapView = mapView;
        
    }];
    
}

#pragma mark - MAMapViewDelegate  (MAAnnotationView自定义标注图标)
// (自定义标注图标)
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    
    //自己
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

    //终点
    if ([annotation isKindOfClass:[MAPointAnnotation class]]){

        static NSString *reuseIndetifier = @"annotationReuseIndetifier";

        ZXTerminalAnnotationView *annotationView = (ZXTerminalAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];

        if (annotationView == nil){
            annotationView = [[ZXTerminalAnnotationView alloc] initWithAnnotation:annotation
                                                        reuseIdentifier:reuseIndetifier];
        }

        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -178);
        
        self.terminalAnnotationView = annotationView;
        [self.terminalAnnotationView zx_openResultsModel:self.openResultsModel];
        
        return annotationView;
    }
    
    return nil;
}

//获取heading信息
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{

    if (!updatingLocation){
        //heading数据更新
//        self.meAnnotationView.heading = userLocation.heading;
    }

}


#pragma mark - 步行导航
- (void)zx_startWalkNavi{
    
    if (self.walkView){
        return;
    }
    
    //walkView
    self.walkView = [[AMapNaviWalkView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.walkView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.walkView.showSensorHeading = YES;
    self.walkView.lineWidth = 5;
    self.walkView.showGreyAfterPass = YES;
    self.walkView.showBrowseRouteButton = YES;
    
    
    self.walkView.delegate = self;
    [self.walkView setCarImage:IMAGENAMED(CarImage)];
    [self.walkView setEndPointImage:IMAGENAMED(@"clearImage")];
    [self.walkView setCarCompassImage:IMAGENAMED(@"clearImage")];
    self.walkView.mapViewModeType = AMapNaviViewMapModeTypeDay;
    self.walkView.showUIElements = NO;
    self.walkView.showTurnArrow = YES;

    
    
    //更改地图样式
    self.walkView.normalTexture = [UIImage imageNamed:@"btn_38px"];;
    
    NSString *path = [NSString stringWithFormat:@"%@/%@.data", [NSBundle mainBundle].bundlePath ,CustomMapStyle];
    NSData *data = [NSData dataWithContentsOfFile:path];
    MAMapCustomStyleOptions *options = [[MAMapCustomStyleOptions alloc] init];
    options.styleData = data;
    [self.walkView setCustomMapStyleOptions:options];
    self.walkView.mapViewModeType = AMapNaviViewMapModeTypeCustom;
    
    
    [self.view addSubview:self.walkView];
    [self.view sendSubviewToBack:self.walkView];
    
   

    //walkManager 请在 dealloc 函数中执行 [AMapNaviDriveManager destroyInstance] 来销毁单例
    [[AMapNaviWalkManager sharedInstance] setDelegate:self];
    [[AMapNaviWalkManager sharedInstance] setIsUseInternalTTS:NO];
    
    //将self 、walkView、trafficBarView 添加为导航数据的Representative，使其可以接收到导航诱导数据
    [[AMapNaviWalkManager sharedInstance] addDataRepresentative:self.walkView];
    [[AMapNaviWalkManager sharedInstance] addDataRepresentative:self];

    //算路
    [[AMapNaviWalkManager sharedInstance] calculateWalkRouteWithStartPoints:@[self.startPoint] endPoints:@[self.endPoint]];
    
}



#pragma mark - AMapNaviWalkManager Delegate （步行）
//计算路线成功
- (void)walkManagerOnCalculateRouteSuccess:(AMapNaviWalkManager *)walkManager{
    NSLog(@"onCalculateRouteSuccess");
   
    //算路成功后开始导航
    [[AMapNaviWalkManager sharedInstance] startGPSNavi];
}

//模拟导航到达目的地停止导航后的回调函数
- (void)walkManagerDidEndEmulatorNavi:(AMapNaviWalkManager *)walkManager{
}

//导航到达目的地后的回调函数
- (void)walkManagerOnArrivedDestination:(AMapNaviWalkManager *)walkManager{
}


#pragma mark - AMapNaviWalkDataRepresentable（步行）
//诱导信息
- (void)walkManager:(AMapNaviWalkManager *)walkManager updateNaviInfo:(nullable AMapNaviInfo *)naviInfo {

    if (naviInfo) {
        
        
        
        if (self.topInfoBgView.hidden) {
            self.topInfoBgView.hidden = NO;
        }
        
        self.topRemainLabel.text = [NSString stringWithFormat:@"%@",[self topRemainLabelDistance:naviInfo.segmentRemainDistance]];
  
        
        self.topRoadLabel.text = naviInfo.nextRoadName;

        NSString *remainDis = [self normalizedRemainDistance:naviInfo.routeRemainDistance];
        self.routeRemainInfoLabel.text = [NSString stringWithFormat:@"%@ %@",remainDis,@"      "];
        
        
        NSDictionary *imageDict = @{@(AMapNaviIconTypeNone): @"AMapNaviIconTypeDefault",
                                     @(AMapNaviIconTypeDefault): @"AMapNaviIconTypeDefault",
                                     @(AMapNaviIconTypeLeft): @"AMapNaviIconTypeLeft",
                                     @(AMapNaviIconTypeRight): @"AMapNaviIconTypeRight",
                                     @(AMapNaviIconTypeLeftFront): @"AMapNaviIconTypeLeftFront",
                                     @(AMapNaviIconTypeRightFront): @"AMapNaviIconTypeRightFront",
                                     @(AMapNaviIconTypeLeftBack): @"AMapNaviIconTypeLeftBack",
                                     @(AMapNaviIconTypeRightBack): @"AMapNaviIconTypeRightBack",
                                     @(AMapNaviIconTypeLeftAndAround): @"AMapNaviIconTypeLeftAndAround",
                                     @(AMapNaviIconTypeStraight): @"AMapNaviIconTypeDefault",
                                     @(AMapNaviIconTypeArrivedWayPoint) : @"",
                                     @(AMapNaviIconTypeEnterRoundabout) : @"",
                                     @(AMapNaviIconTypeOutRoundabout): @"",
                                     @(AMapNaviIconTypeArrivedServiceArea): @"",
                                     @(AMapNaviIconTypeArrivedTollGate): @"",
                                     @(AMapNaviIconTypeArrivedDestination): @"AMapNaviIconTypeDefault",
                                     @(AMapNaviIconTypeArrivedTunnel): @"",
                                     @(AMapNaviIconTypeCrosswalk): @"AMapNaviIconTypeCrosswalk",
                                     @(AMapNaviIconTypeFlyover): @"AMapNaviIconTypeFlyover",
                                     @(AMapNaviIconTypeUnderpass): @"AMapNaviIconTypeUnderpass",
                                    @(AMapNaviIconTypeEntryRingLeft):@"AMapNaviIconTypeEntryRingLeft",
                                    @(AMapNaviIconTypeEntryLeftRingLeft):@"AMapNaviIconTypeEntryLeftRingLeft",
                                     };
        
        NSString *imageStr = [imageDict wg_safeObjectForKey:@(naviInfo.iconType)];
        if (kIsEmptyString(imageStr)) imageStr = @"AMapNaviIconTypeDefault";
        self.topTurnImageView.image = IMAGENAMED(imageStr);
        
        //TODO: 修复
        [self.detailsView zx_updateNaviInfo:naviInfo];
        [self.endPointView zx_updateNaviInfo:naviInfo];
        [self.terminalAnnotationView zx_updateNaviInfo:naviInfo];
        [self.detailsView zx_setTurnIconImage:IMAGENAMED(imageStr)];
    }
}

/**
 * @brief 自车位置更新回调
 * @param walkManager 步行导航管理类
 * @param naviLocation 自车位置信息,参考 AMapNaviLocation 类
 */
- (void)walkManager:(AMapNaviWalkManager *)walkManager updateNaviLocation:(nullable AMapNaviLocation *)naviLocation{
    self.naviLocation = naviLocation;
    
}






#pragma mark - 驾车导航
- (void)zx_startDriveNavi{
    //driveView
    self.driveView = [[AMapNaviDriveView alloc] initWithFrame:self.view.bounds];
    self.driveView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.driveView.delegate = self;
    self.driveView.showUIElements = NO;
    //是否显示实时交通按钮,默认YES
    self.driveView.showTrafficButton = NO;
    //是否显示路况光柱,默认YES
    self.driveView.showTrafficBar = NO;
    self.driveView.lineWidth = 5;
    self.driveView.showGreyAfterPass = YES;
    self.driveView.dashedLineGreyColor = UIColor.clearColor;
    self.driveView.autoZoomMapLevel = YES;
    self.driveView.autoSwitchShowModeToCarPositionLocked = YES;
    self.driveView.showCamera = NO;
    self.driveView.showVectorline = NO;
    self.driveView.showTrafficLights = NO;
    [self.driveView setCarImage:IMAGENAMED(CarImage)];
    [self.driveView setEndPointImage:IMAGENAMED(@"clearImage")];
    [self.driveView setCarCompassImage:IMAGENAMED(@"clearImage")];
    
    
//    self.driveView.showRoute = NO;
    
    [self.driveView setStatusTextures:@{@(AMapNaviRouteStatusUnknow): [UIImage imageNamed:@"btn_38px"],
                                                @(AMapNaviRouteStatusSmooth): [UIImage imageNamed:@"btn_38px"],
                                                @(AMapNaviRouteStatusSlow): [UIImage imageNamed:@"btn_38px"],
                                                @(AMapNaviRouteStatusJam): [UIImage imageNamed:@"btn_38px"],
                                                @(AMapNaviRouteStatusSeriousJam): [UIImage imageNamed:@"btn_38px"],}];
    
    self.driveView.normalTexture = [UIImage imageNamed:@"btn_38px"];
    
    //自定义地图样式
    NSString *path = [NSString stringWithFormat:@"%@/%@.data", [NSBundle mainBundle].bundlePath ,CustomMapStyle];
    NSData *data = [NSData dataWithContentsOfFile:path];
    MAMapCustomStyleOptions *options = [[MAMapCustomStyleOptions alloc] init];
    options.styleData = data;
    [self.driveView setCustomMapStyleOptions:options];
    self.driveView.mapViewModeType = AMapNaviViewMapModeTypeCustom;
    
    
    self.driveView.trackingMode = AMapNaviViewTrackingModeCarNorth;
    self.driveView.logoCenter = CGPointMake(self.driveView.logoCenter.x + 2, self.driveView.logoCenter.y + 60);
    [self.view addSubview:self.driveView];
    [self.view sendSubviewToBack:self.driveView];

    
    //driveManager 请在 dealloc 函数中执行 [AMapNaviDriveManager destroyInstance] 来销毁单例
    [[AMapNaviDriveManager sharedInstance] setDelegate:self];
    [[AMapNaviDriveManager sharedInstance] setIsUseInternalTTS:NO];
    
    [[AMapNaviDriveManager sharedInstance] setAllowsBackgroundLocationUpdates:YES];
    [[AMapNaviDriveManager sharedInstance] setPausesLocationUpdatesAutomatically:NO];
    
    //将self 、driveView、trafficBarView 添加为导航数据的Representative，使其可以接收到导航诱导数据
    [[AMapNaviDriveManager sharedInstance] addDataRepresentative:self.driveView];
    [[AMapNaviDriveManager sharedInstance] addDataRepresentative:self];
    
    //算路
    [[AMapNaviDriveManager sharedInstance] calculateDriveRouteWithStartPoints:@[self.startPoint]
                                                                    endPoints:@[self.endPoint]
                                                                    wayPoints:nil
                                                              drivingStrategy:AMapNaviDrivingStrategySingleDefault];
    
    
    
}


#pragma mark - AMapNaviDriveManager Delegate （驾车）

//计算录像成功
- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager {
    NSLog(@"onCalculateRouteSuccess");
    
    //算路成功后开始导航
    [[AMapNaviDriveManager sharedInstance] startGPSNavi];
    
}

//模拟到导航到达目的地回调
- (void)driveManagerDidEndEmulatorNavi:(AMapNaviDriveManager *)driveManager{
    NSLog(@"\n\n\n模拟到导航到达目的地回调\n\n\n");
}

//实时导航到导航到达目的地回调
- (void)driveManagerOnArrivedDestination:(AMapNaviDriveManager *)driveManager{
    NSLog(@"\n\n\n实时导航到导航到达目的地回调\n\n\n");
}

#pragma mark - AMapNaviDriveDataRepresentable （驾车）
//诱导信息
- (void)driveManager:(AMapNaviDriveManager *)driveManager updateNaviInfo:(AMapNaviInfo *)naviInfo {
    if (naviInfo) {
        
        //TODO: 修复
        [self.detailsView zx_updateNaviInfo:naviInfo];
        [self.endPointView zx_updateNaviInfo:naviInfo];
        [self.terminalAnnotationView zx_updateNaviInfo:naviInfo];
       
        
        if (self.topInfoBgView.hidden) {
            self.topInfoBgView.hidden = NO;
        }
        
        self.topRemainLabel.text = [NSString stringWithFormat:@"%@",[self topRemainLabelDistance:naviInfo.segmentRemainDistance]];
  
        self.topRoadLabel.text = naviInfo.nextRoadName;
        
        
        NSString *remainDis = [self normalizedRemainDistance:naviInfo.routeRemainDistance];
        
        self.routeRemainInfoLabel.text = [NSString stringWithFormat:@"%@ %@",remainDis,@"      "];
    }
}

//转向图标
- (void)driveManager:(AMapNaviDriveManager *)driveManager updateTurnIconImage:(UIImage *)turnIconImage turnIconType:(AMapNaviIconType)turnIconType {
    if (turnIconImage) {
        self.topTurnImageView.image = turnIconImage;
        [self.detailsView zx_setTurnIconImage:turnIconImage];
    }
}


/**
 * @brief 自车位置更新回调 (since 5.0.0，模拟导航和实时导航的自车位置更新都会走此回调)
 * @param driveManager 驾车导航管理类
 * @param naviLocation 自车位置信息,参考 AMapNaviLocation 类
 */
- (void)driveManager:(AMapNaviDriveManager *)driveManager updateNaviLocation:(nullable AMapNaviLocation *)naviLocation{
    self.naviLocation = naviLocation;
}


#pragma mark - AMapNaviDriveViewDelegate（驾车）

- (void)driveView:(AMapNaviDriveView *)driveView didChangeDayNightType:(BOOL)showStandardNightType {
    NSLog(@"didChangeDayNightType:%ld", (long)showStandardNightType);
}

- (void)driveView:(AMapNaviDriveView *)driveView didChangeOrientation:(BOOL)isLandscape {
    NSLog(@"didChangeOrientation:%ld", (long)isLandscape);
  
    if (self.driveView.showMode == AMapNaviDriveViewShowModeOverview) {  //如果是全览状态，重新适应一下全览路线，让其均可见
        [self.driveView updateRoutePolylineInTheVisualRangeWhenTheShowModeIsOverview];
    }
}

- (void)driveView:(AMapNaviDriveView *)driveView didChangeShowMode:(AMapNaviDriveViewShowMode)showMode {
    
    if (showMode == AMapNaviDriveViewShowModeOverview) {
        self.rightBrowserBtn.selected = YES;
    } else {
        self.rightBrowserBtn.selected = NO;
    }
}





#pragma mark - DEllOC
- (void)dealloc {
    
    BOOL successWalk = [AMapNaviWalkManager destroyInstance];
    BOOL successDrive = [AMapNaviDriveManager destroyInstance];
    NSLog(@"单例是否销毁成功 : successWalk--%d successDrive--%d",successWalk,successDrive);
}


#pragma mark - Button Click
//退出必备销毁响应 
- (void)zx_back{
    
    //通知个人中心刷新
    [WGNotification postNotificationName:ZXNotificationMacro_MineSet object:nil];
    
    
    if (self.sheetVC){
        [self.sheetVC dissmisAlertVcWithCompletion:^{
            
            [self zx_mapDestroyInstance];
           
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }else{
        [self zx_mapDestroyInstance];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}


//地图代理销毁
- (void)zx_mapDestroyInstance{
    //关闭定时器
    [self invalidateTimer];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    });
    
    //地图处理
    [self.mapView setCompassImage:nil];
    [self.mapView removeAnnotations:self.mapView.annotations];
    self.mapView = nil;
    self.walkView = nil;
    self.driveView = nil;
    [self.walkView removeFromSuperview];
    [self.driveView removeFromSuperview];
    
    
    [[AMapNaviWalkManager sharedInstance] stopNavi];
    [[AMapNaviWalkManager sharedInstance] removeDataRepresentative:self.walkView];
    [[AMapNaviWalkManager sharedInstance] removeDataRepresentative:self];
    [[AMapNaviWalkManager sharedInstance] setDelegate:nil];
    
    
   
    [[AMapNaviDriveManager sharedInstance] stopNavi];
    [[AMapNaviDriveManager sharedInstance] setDelegate:nil];
    [[AMapNaviDriveManager sharedInstance] removeDataRepresentative:self.driveView];
    [[AMapNaviDriveManager sharedInstance] removeDataRepresentative:self];
    
  
 
   
}

- (IBAction)closeBtnClick:(id)sender {
    
    NSLog(@"\n\nkUserDefaultsIsCloseExitNavTips---%@",kUserDefaultsIsCloseExitNavTips);
    if ([kUserDefaultsIsCloseExitNavTips isEqualToString:@"1"]){
        [self zx_back];
    }else{
        [self zx_exitNavWindow];
    }
    
}

- (IBAction)trafficBtnClick:(id)sender {

    CLLocationCoordinate2D startCllo = CLLocationCoordinate2DMake(self.startPoint.latitude, self.startPoint.longitude);
    CLLocationCoordinate2D endCllo = CLLocationCoordinate2DMake([self.openResultsModel.lnglat.lat floatValue] ,[self.openResultsModel.lnglat.lng floatValue]);

    UIAlertController *actionSheet = [ZXMapNavManager  getInstalledMapAppWithEndLocation:endCllo currentLocation:startCllo];
    [self.navigationController presentViewController:actionSheet animated:YES completion:nil];

    
}

- (IBAction)browserBtn:(id)sender {
    self.driveView.showMode = AMapNaviDriveViewShowModeCarPositionLocked;
    self.walkView.showMode = AMapNaviWalkViewShowModeCarPositionLocked;
    
}

- (IBAction)endDetailsButton:(UIButton *)sender {
    [self zx_reachDestinationWindowIsFirst:NO];
}

//模拟导航
- (IBAction)navAction:(UIButton *)sender {
    
    NSLog(@"模拟导航");
    
    if ([self.openResultsModel.navigationlist.distance intValue] > 3000){
        //驾驶模拟导航
        [[AMapNaviDriveManager sharedInstance] stopNavi];
        [[AMapNaviDriveManager sharedInstance] setEmulatorNaviSpeed:EmulatorNaviSpeed];
        [[AMapNaviDriveManager sharedInstance] startEmulatorNavi];

    }else{
        //步行模拟导航
        [[AMapNaviWalkManager sharedInstance] stopNavi];
        [[AMapNaviWalkManager sharedInstance] setEmulatorNaviSpeed:EmulatorNaviSpeed];
        [[AMapNaviWalkManager sharedInstance] startEmulatorNavi];
    }
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UITextField *passwordText = [alertView textFieldAtIndex:0];
    NSLog(@"%@",passwordText.text);
    
    NSScanner *scan = [NSScanner scannerWithString:passwordText.text];
    int val;
    
    NSLog(@"输入确认 ----- %d",[scan scanInt:&val] && [scan isAtEnd]);
   
    int speed = EmulatorNaviSpeed;
    
    if([scan scanInt:&val] && [scan isAtEnd]){
        speed = [passwordText.text intValue];
    }
    
    
    
    
}


#pragma mark - Utility

- (BOOL)isiPhoneX {
    return [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO;
}


- (NSString *)topRemainLabelDistance:(NSInteger)remainDistance {
    
    if (remainDistance < 0) {
        return nil;
    }
    
    if (remainDistance >= 1000) {
        CGFloat kiloMeter = remainDistance / 1000.0;
        self.topRemainUnitLabel.text = @"km";
        return [NSString stringWithFormat:@"%.1f", kiloMeter];
    } else {
        self.topRemainUnitLabel.text = @"m";
        return [NSString stringWithFormat:@"%ld", (long)remainDistance];
    }
    
    
}

- (NSString *)normalizedRemainDistance:(NSInteger)remainDistance {
    
    self.remainDistance = remainDistance;
    
    if (remainDistance < 0) {
        return nil;
    }

    
//    self.walkView.userLocation.
    
    
    
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(self.naviLocation.coordinate.latitude,self.naviLocation.coordinate.longitude);
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake([self.openResultsModel.lnglat.lat floatValue] ,[self.openResultsModel.lnglat.lng floatValue]);
    
    
    BOOL isContains = MACircleContainsCoordinate(location, center, ProximityDistance);
    
    
    
    //接近目的地提醒
    if (isContains && !self.timer){
        [self zx_routeRemainInfoBgViewAnimation];
        
        [self zx_reachDestination];
        [self zx_reqApiArrivedBox];
        
    }else if (remainDistance > ProximityDistance){
        [self invalidateTimer];
    }
    
    //按钮
    if (remainDistance > ProximityDistance){
        self.endDetailsImageView.image = IMAGENAMED(@"cantClick");
        self.endDetailsButton.userInteractionEnabled = NO;
    }else{
        self.endDetailsImageView.image = IMAGENAMED(@"canClick");
        self.endDetailsButton.userInteractionEnabled = YES;
    }
    
    if (remainDistance >= 1000) {
        CGFloat kiloMeter = remainDistance / 1000.0;
       
        return [NSString stringWithFormat:@"%.1f公里", kiloMeter];
    } else {

        return [NSString stringWithFormat:@"%ld米", (long)remainDistance];
    }
    
    
}


//背景动画
- (void)zx_routeRemainInfoBgViewAnimation{
    
    [self invalidateTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(zx_animation) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}

- (void)zx_animation{
    
    NSLog(@"timer ---- %f",self.routeRemainInfoBgView.alpha);
    [UIView animateWithDuration:2 animations:^{
        if (self.routeRemainInfoBgView.alpha == 1){
            self.routeRemainInfoBgView.alpha = 0;
        }else{
            self.routeRemainInfoBgView.alpha = 1;
        }
    }];
}


- (void)invalidateTimer{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}


#pragma mark - 到达目的地后弹窗

- (void)zx_reachDestination{


    for (int i=0; i < 3; i++) {
        [NSThread sleepForTimeInterval:0.8];
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    
    
    self.endDetailsImageView.image = IMAGENAMED(@"canClick");
    self.endDetailsButton.userInteractionEnabled = YES;
    
    [self zx_reachDestinationWindowIsFirst:YES];
}

//目的地弹窗
- (void)zx_reachDestinationWindowIsFirst:(BOOL)isFirst{
    
    //隐藏XIB元素
    [self zx_xibElementIsHidden:YES];
    
    //弹窗
//    ZXMapNavResultsView *view = [[ZXMapNavResultsView alloc] initWithFrame:CGRectMake(0, 0, WGNumScreenWidth(),  WGNumScreenHeight())];
//    view.delegate = self;
//    [view zx_openResultslnglatModel:self.openResultsModel IsFirst:isFirst];
//
//    [self.sheetVC dissmisAlertVc];
//    self.sheetVC = [WGGeneralAlertController alertControllerWithCustomView:view];
//    [self.sheetVC showToCurrentVc];
    
    //TODO: 修复
    self.detailsView.hidden = YES;
    ZXMapNavResultsGreenView *greenView = [[ZXMapNavResultsGreenView alloc] initWithFrame:CGRectMake(0, 0, WGNumScreenWidth(),  WGNumScreenHeight()) withOpenResultsModel:self.openResultsModel];
    greenView.delegate = self;
    self.sheetVC = [WGGeneralAlertController alertControllerWithCustomView:greenView];
    [self.sheetVC showToCurrentVc];
    
}

//隐藏 或 显示 界面元素
- (void)zx_xibElementIsHidden:(bool)isHidden{
    
    //xib界面元素
    self.topBgView.hidden = isHidden;
    self.routeRemianInfoView.hidden = isHidden;
    self.routeRemainInfoBgView.hidden = isHidden;
    self.rightTrafficBtn.hidden = isHidden;
    self.rightBrowserBtn.hidden = isHidden;
}

#pragma mark - ZXMapNavResultsViewDelegate
- (void)closeResultsView:(ZXMapNavResultsView *)resultsView{
    //显示XIB元素
//    [self zx_xibElementIsHidden:NO];
    [self.sheetVC dissmisAlertVc];
}

#pragma mark - ZXMapNavResultsGreenViewDelegate
- (void)closeResultsGreenView:(ZXMapNavResultsGreenView *)resultsGreenView{
    [self.sheetVC dissmisAlertVc];
    self.detailsView.hidden = NO;
}

#pragma mark - 首次进来提示弹窗
- (void)zx_fristEntryWindow{
    
    if ([kUserDefaultsIsFristEntryBoxTips isEqualToString:@"1"]) return;
    if (self.remainDistance < ProximityDistance && self.timer)  return;
    
    [self.sheetVC dissmisAlertVc];
    
    ZXMapFirstEntryTipsView *view = [[ZXMapFirstEntryTipsView alloc] initWithFrame:CGRectMake(0, 0, 257, 360) WithEntryTipsType:ZXTipsType_FristEntry];
    view.delegate = self;
    self.sheetVC = [WGGeneralAlertController alertControllerWithCustomView:view];
    [self.sheetVC showToCurrentVc];
    
}


#pragma mark - 退出导航提示弹窗
- (void)zx_exitNavWindow{

    [self.sheetVC dissmisAlertVc];
    ZXMapFirstEntryTipsView *view = [[ZXMapFirstEntryTipsView alloc] initWithFrame:CGRectMake(0, 0, 257, 340) WithEntryTipsType:ZXTipsType_CloseNavi];
    view.delegate = self;
    self.sheetVC = [WGGeneralAlertController alertControllerWithCustomView:view];
    [self.sheetVC showToCurrentVc];
}

#pragma mark - ZXMapFirstEntryTipsViewDelegate
//关闭弹窗
- (void)closeTipsView:(ZXMapFirstEntryTipsView *)tipsView{
    [self.sheetVC dissmisAlertVc];
}

//确定退出导航
- (void)sureTipsView:(ZXMapFirstEntryTipsView *)tipsView{
    [self.sheetVC dissmisAlertVc];
    [self zx_back];
}


#pragma mark - NetworkRequest
//盲盒到达
- (void)zx_reqApiArrivedBox{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict wg_safeSetObject:self.openResultsModel.boxid forKey:@"boxid"];
    
    WEAKSELF;
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiArrivedBox Parameter:dict success:^(NSDictionary * _Nonnull resultDic) {
        STRONGSELF;
        [WGUIManager wg_hideHUD];
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}


@end

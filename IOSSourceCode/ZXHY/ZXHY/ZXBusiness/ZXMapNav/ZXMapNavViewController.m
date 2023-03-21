//
//  ZXMapNavViewController.m
//  ZXHY
//
//  Created by Bern Lin on 2021/11/15.
//

#import "ZXMapNavViewController.h"
#import "ZXOpenResultsModel.h"
#import <AMapNaviKit/AMapNaviKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface ZXMapNavViewController ()
<
AMapLocationManagerDelegate,
AMapNaviDriveViewDelegate,
AMapNaviDriveManagerDelegate,
AMapNaviDriveDataRepresentable
>

@property (nonatomic, strong) ZXOpenResultsModel *openResultsModel;

//顶部信息
@property (weak, nonatomic) IBOutlet UIView *topInfoView;
@property (weak, nonatomic) IBOutlet UILabel *placeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeDetailsLabel;
@property (weak, nonatomic) IBOutlet UIButton *exitButton;
@property (weak, nonatomic) IBOutlet UIImageView *turnRoadImageView;
@property (weak, nonatomic) IBOutlet UILabel *nextTurnRoadDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextTurnRoadInfoLabel;

//底部信息
@property (weak, nonatomic) IBOutlet UIView *destinationView;
@property (weak, nonatomic) IBOutlet UIView *destinationRedView;
@property (weak, nonatomic) IBOutlet UIView *destinationClickBgView;
@property (weak, nonatomic) IBOutlet UIImageView *destinationClickImageView;
@property (weak, nonatomic) IBOutlet UIButton *destinationClickButton;
@property (weak, nonatomic) IBOutlet UILabel *destinationLabel;

//其他点击按钮
@property (weak, nonatomic) IBOutlet UIButton *currentLocationButton;
@property (weak, nonatomic) IBOutlet UIButton *otherNavButton;

//真实相差终点距离
@property (nonatomic, assign)  NSInteger remainTerminalDistance;

//定位
@property (nonatomic, strong) AMapLocationManager  *locationManager;

//起点 、终点 坐标
@property (nonatomic, strong) AMapNaviPoint *startPoint;
@property (nonatomic, strong) AMapNaviPoint *endPoint;

//驾车导航 、步行导航
@property (nonatomic, strong) AMapNaviDriveView *driveView;
@property (nonatomic, strong) AMapNaviWalkView  *walkView;

@end

@implementation ZXMapNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //初始化XIB
    [self zx_initializationXIB];
    
    //开启定位
//    [self.locationManager startUpdatingLocation];
    
    //驾驶导航
    [self zx_initDriveView];
    
    
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(39.989612,116.480972);
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(39.990347,116.480441);
    BOOL isContains = MACircleContainsCoordinate(location, center, 200);
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
//    self.navigationView.alpha = 0;
    self.navigationController.toolbarHidden = YES;
}

- (void)dealloc {
    
    

    BOOL success = [AMapNaviDriveManager destroyInstance];
    NSLog(@"单例是否销毁成功 : %d",success);
}


#pragma mark - Initialization
//传入模型
- (void)zx_openResultslnglatModel:(ZXOpenResultsModel *)openResultsModel{
    self.openResultsModel = openResultsModel;
}

//初始化XIB及数据
- (void)zx_initializationXIB{
    
    self.topInfoView.layer.cornerRadius = 20;
    
    self.exitButton.layer.cornerRadius = 15;
    self.exitButton.layer.borderColor = WGRGBAlpha(255, 255, 255, 0.3).CGColor;
    self.exitButton.layer.borderWidth = 0.7;
    
    self.destinationRedView.alpha = 0;
    self.destinationRedView.layer.cornerRadius = 50;
   
    self.destinationView.layer.cornerRadius = 40;
    self.destinationClickBgView.layer.cornerRadius = 22;
    self.destinationClickImageView.layer.cornerRadius = 20;
    
    //当前位置按钮
    self.currentLocationButton.layer.cornerRadius = 5;
    self.currentLocationButton.backgroundColor = UIColor.whiteColor;
    self.currentLocationButton.layer.shadowColor = WGRGBAlpha(0, 0, 0, 0.3).CGColor;
    self.currentLocationButton.layer.shadowOffset = CGSizeMake(0,4);
    self.currentLocationButton.layer.shadowRadius = 6;
    self.currentLocationButton.layer.shadowOpacity = 1;
    
    //其他导航按钮
    self.otherNavButton.layer.cornerRadius = 5;
    self.otherNavButton.backgroundColor = UIColor.whiteColor;
    self.otherNavButton.layer.shadowColor = WGRGBAlpha(0, 0, 0, 0.3).CGColor;
    self.otherNavButton.layer.shadowOffset = CGSizeMake(0,4);
    self.otherNavButton.layer.shadowRadius = 6;
    self.otherNavButton.layer.shadowOpacity = 1;
    
    //数据
    self.placeNameLabel.text = self.openResultsModel.buildName;
    self.placeDetailsLabel.text = self.openResultsModel.address;
}


#pragma mark - Private Method
//关闭按钮
- (IBAction)exitAction:(id)sender {
    
    [[AMapNaviDriveManager sharedInstance] stopNavi];
    [[AMapNaviDriveManager sharedInstance] removeDataRepresentative:self.driveView];
    [[AMapNaviDriveManager sharedInstance] removeDataRepresentative:self];
    [[AMapNaviDriveManager sharedInstance] setDelegate:nil];

    [self.navigationController popToRootViewControllerAnimated:YES];
    
    //TODO: 修复
//    [[AppDelegate wg_sharedDelegate].tabBarController zx_reqApiCheckBeingBox];
    
}

//当前位置
- (IBAction)currentLocationAction:(id)sender {
    
}

//其他导航
- (IBAction)otherNaviAction:(id)sender {
    
}

//停止定位
- (void)zx_stopSerialLocation{
    //销毁代理
    [self.locationManager setDelegate:nil];
    //停止定位
    [self.locationManager stopUpdatingLocation];
}


//步行导航View
- (void)zx_initWalkView{
    if (!self.walkView){
        
    }
}


//驾车导航View
- (void)zx_initDriveView{
    if (!self.driveView){
        
        self.driveView = [[AMapNaviDriveView alloc] initWithFrame:self.view.bounds];
        self.driveView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.driveView setDelegate:self];
        [self.driveView setShowCamera:NO];
        [self.driveView setShowVectorline:NO];
        [self.driveView setShowTrafficLights:NO];
        [self.driveView setShowGreyAfterPass:YES];
        [self.driveView setAutoZoomMapLevel:YES];
        [self.driveView setMapViewModeType:AMapNaviViewMapModeTypeNight];
        [self.driveView setTrackingMode:AMapNaviViewTrackingModeCarNorth];
        [self.driveView setAutoSwitchShowModeToCarPositionLocked:YES];
        [self.driveView setShowUIElements:NO];
        [self.driveView setShowTrafficBar:NO];
        [self.driveView setShowTrafficButton:NO];
        [self.driveView setLineWidth:5];
        [self.driveView setDashedLineGreyColor:UIColor.clearColor];
        [self.driveView setCarImage:[UIImage imageNamed:@"home"]];
        [self.view addSubview:self.driveView];
        [self.view sendSubviewToBack:self.driveView];
        
        
        //******************************自定义地图样式**********************************//
//        NSString *path = [NSString stringWithFormat:@"%@/style.data", [NSBundle mainBundle].bundlePath];
//        NSData *data = [NSData dataWithContentsOfFile:path];
//        MAMapCustomStyleOptions *options = [[MAMapCustomStyleOptions alloc] init];
//        options.styleData = data;
//        [self.driveView setCustomMapStyleOptions:options];
//        self.driveView.mapViewModeType = AMapNaviViewMapModeTypeCustom;
        
        
        //******************************DriveView 线路颜色改变**********************************//
//        self.driveView.normalTexture = [UIImage imageNamed:@"btn_38px"];
//        [self.driveView setStatusTextures:@{@(AMapNaviRouteStatusUnknow): [UIImage imageNamed:@"btn_38px"],
//                                                    @(AMapNaviRouteStatusSmooth): [UIImage imageNamed:@"btn_38px"],
//                                                    @(AMapNaviRouteStatusSlow): [UIImage imageNamed:@"btn_38px"],
//                                                    @(AMapNaviRouteStatusJam): [UIImage imageNamed:@"btn_38px"],
//                                                    @(AMapNaviRouteStatusSeriousJam): [UIImage imageNamed:@"btn_38px"],}];

        
        
        
        //********************************AMapNaviDriveManager********************************//
        
        //请在 dealloc 函数中执行 [AMapNaviDriveManager destroyInstance] 来销毁单例
        [[AMapNaviDriveManager sharedInstance] setDelegate:self];
        [[AMapNaviDriveManager sharedInstance] setIsUseInternalTTS:YES];
//        [[AMapNaviDriveManager sharedInstance] setAllowsBackgroundLocationUpdates:NO];
        [[AMapNaviDriveManager sharedInstance] setPausesLocationUpdatesAutomatically:NO];
        
        //将driveView添加为导航数据的Representative，使其可以接收到导航诱导数据
        [[AMapNaviDriveManager sharedInstance] addDataRepresentative:self.driveView];
        [[AMapNaviDriveManager sharedInstance] addDataRepresentative:self];
        
        //进行路径规划
        self.startPoint = [AMapNaviPoint locationWithLatitude:39.993135 longitude:116.474175];
        self.endPoint   = [AMapNaviPoint locationWithLatitude:39.908791 longitude:116.321257];
        [[AMapNaviDriveManager sharedInstance] calculateDriveRouteWithStartPoints:@[self.startPoint]
                                                    endPoints:@[self.endPoint]
                                                    wayPoints:nil
                                              drivingStrategy:AMapNaviDrivingStrategySingleDefault];
        
    }
}


//导航关闭
- (void)zx_naviClose{
    //停止驾车导航
    [[AMapNaviDriveManager sharedInstance] stopNavi];
    [[AMapNaviDriveManager sharedInstance] removeDataRepresentative:self.driveView];
    [[AMapNaviDriveManager sharedInstance] removeDataRepresentative:self];
}


//距离单位换算
- (NSString *)zx_unitConversionWithDistance:(NSInteger)remainDistance{
    if (remainDistance < 0) return nil;
    
    if (remainDistance >= 1000) {
        CGFloat kiloMeter = remainDistance / 1000.0;
        return [NSString stringWithFormat:@"%.1f km", kiloMeter];
    }else{
        return [NSString stringWithFormat:@"%ld m", (long)remainDistance];
    }
}


//
- (NSString *)normalizedRemainDistance:(NSInteger)remainDistance{
    self.remainTerminalDistance = remainDistance;
    if (remainDistance < 0);
    return nil;
    
}


#pragma mark - AMapLocationManagerDelegate （定位）
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{
    
    if (location) [self zx_stopSerialLocation];//停止定位
    
    //定位结果
    self.startPoint = [AMapNaviPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    self.endPoint   = [AMapNaviPoint locationWithLatitude:[self.openResultsModel.lnglat.lat floatValue] longitude:[self.openResultsModel.lnglat.lng floatValue]];
        
    
    //距离是否大于3公里
    if ([self.openResultsModel.navigationlist.distance intValue] > 3000){
        //驾驶导航
//        [self zx_initDriveView];
        
    }else{
        //步行导航
//        [self zx_startWalkNavi];
    }
   
}


#pragma mark - AMapNaviDriveViewDelegate (驾车导航View)
#pragma mark - AMapNaviDriveManagerDelegate (驾车Manager)
//计算路线成功
- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager{
    NSLog(@"\n\n\nonCalculateRouteSuccess----计算路线成功\n\n\n");
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

#pragma mark - AMapNaviDriveDataRepresentable (驾车诱导信息)
//转向图标
- (void)driveManager:(AMapNaviDriveManager *)driveManager updateTurnIconImage:(UIImage *)turnIconImage turnIconType:(AMapNaviIconType)turnIconType {
    if (turnIconImage) {
        self.turnRoadImageView.image = turnIconImage;
    }
}

//诱导信息
- (void)driveManager:(AMapNaviDriveManager *)driveManager updateNaviInfo:(AMapNaviInfo *)naviInfo {
    if (!naviInfo) return;
    
    //顶部信息还有距离单位换算
    self.nextTurnRoadDistanceLabel.text = [NSString stringWithFormat:@"%@",[self zx_unitConversionWithDistance:naviInfo.segmentRemainDistance]];
    
    //底部信息处理
    NSString *remainStr = [self zx_unitConversionWithDistance:naviInfo.routeRemainDistance];
    self.destinationLabel.text = [NSString stringWithFormat:@"%@ %@",remainStr,@"        "];
}


#pragma mark - layz

//定位
- (AMapLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc] init];
        [self.locationManager setDelegate:self];
    }
    return _locationManager;
}
@end

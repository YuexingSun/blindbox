//
//  ZXNavViewController+TravelManner.m
//  ZXHY
//
//  Created by Bern Lin on 2022/4/7.
//

#import "ZXNavViewController+TravelManner.h"
#import "ZXTerminalAnnotationView.h"


#define TravelDistance 3000
#define NavLineWidth 5
#define CarImage @"NavCar"
#define CustomMapStyle @"BlindBoxMap"

@interface ZXNavViewController (TravelManner)

//驾车导航
@property (nonatomic, strong) AMapNaviDriveView *driveView;

//步行导航
@property (nonatomic, strong) AMapNaviWalkView *walkView;

//终点标注视图
@property (nonatomic, strong)  ZXTerminalAnnotationView *terminalAnnotationView;

//当前自己地理位置信息
@property (nonatomic, strong) AMapNaviLocation *naviLocation;

@end

@implementation ZXNavViewController (TravelManner)


#pragma mark - 路线规划
- (void)zx_calculateRouteWithPlanrWithResultsModel:(ZXOpenResultsModel *)openResultsModel ParentlistModel:(ZXBlindBoxViewParentlistModel *)parentlistModel{
    
    self.openResultsModel = openResultsModel;
    self.parentlistModel = parentlistModel;
    
    
    self.endPoint = [AMapNaviPoint locationWithLatitude:[self.openResultsModel.lnglat.lat floatValue] longitude:[self.openResultsModel.lnglat.lng floatValue]];
    
    AMapNaviPOIInfo *startPOIInfo = [[AMapNaviPOIInfo alloc] init];
    AMapNaviPOIInfo *endPOIInfo = [[AMapNaviPOIInfo alloc] init];
    endPOIInfo.locPoint = self.endPoint;
    
    
    //开始计算路途 --- 并推荐出行路线及方式
    WEAKSELF;
    [[AMapNaviDriveManager sharedInstance] independentCalculateDriveRouteWithStartPOIInfo:startPOIInfo endPOIInfo:endPOIInfo wayPOIInfos:nil drivingStrategy:AMapNaviDrivingStrategyMultipleDefault callback:^(AMapNaviRouteGroup * _Nullable routeGroup, NSError * _Nullable error) {
        STRONGSELF;
        
        if (error.code == AMapNaviCalcRouteStateCLAuthorizationStatusDenied || error.code == AMapNaviCalcRouteStateCLAuthorizationReducedAccuracy ){
            
            //权限开启定位
            [ZXMapNavManager  zx_openLocationPermissions];
            
            return;
        }
        
   
         //获取起点坐标
         self.openResultsModel.startPoint = routeGroup.naviRoute.routeStartPoint;
         self.startPoint = routeGroup.naviRoute.routeStartPoint;
        
        //出行方式
        if (routeGroup.naviRoute.routeLength > TravelDistance){
            //驾车
            self.openResultsModel.currentNavType = ZXCurrentNavType_Drive;
            [self zx_startDriveNav];
        }else{
            //步行
            self.openResultsModel.currentNavType = ZXCurrentNavType_Walk;
            [self zx_startWalkNav];
        }
        
       
    }];
}


#pragma mark - 驾车出行导航

//驾车相关设置
- (void)zx_startDriveNav{
    
    AMapNaviDriveView *driveView = [[AMapNaviDriveView alloc] initWithFrame:self.view.bounds];
    driveView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    driveView.delegate = self;
    driveView.showUIElements = NO;
    driveView.showTrafficButton = NO;
    driveView.showTrafficBar = NO;
    driveView.lineWidth = NavLineWidth;
    driveView.showGreyAfterPass = YES;
    driveView.dashedLineGreyColor = UIColor.clearColor;
    driveView.autoZoomMapLevel = YES;
    driveView.autoSwitchShowModeToCarPositionLocked = YES;
    driveView.showCamera = NO;
    driveView.showVectorline = NO;
    driveView.showTrafficLights = NO;
    [driveView setCarImage:IMAGENAMED(CarImage)];
    [driveView setEndPointImage:IMAGENAMED(@"clearImage")];
    [driveView setCarCompassImage:IMAGENAMED(@"clearImage")];
    driveView.trackingMode = AMapNaviViewTrackingModeCarNorth;
    driveView.logoCenter = CGPointMake(driveView.logoCenter.x + 2, driveView.logoCenter.y + 60);
    
    //导航光线
    [driveView setStatusTextures:@{@(AMapNaviRouteStatusUnknow): [UIImage imageNamed:@"btn_38px"],
                                                @(AMapNaviRouteStatusSmooth): [UIImage imageNamed:@"btn_38px"],
                                                @(AMapNaviRouteStatusSlow): [UIImage imageNamed:@"btn_38px"],
                                                @(AMapNaviRouteStatusJam): [UIImage imageNamed:@"btn_38px"],
                                                @(AMapNaviRouteStatusSeriousJam): [UIImage imageNamed:@"btn_38px"],}];
    
    //自定义地图样式
    NSString *path = [NSString stringWithFormat:@"%@/%@.data", [NSBundle mainBundle].bundlePath ,CustomMapStyle];
    NSData *data = [NSData dataWithContentsOfFile:path];
    MAMapCustomStyleOptions *options = [[MAMapCustomStyleOptions alloc] init];
    options.styleData = data;
    [driveView setCustomMapStyleOptions:options];
    driveView.mapViewModeType = AMapNaviViewMapModeTypeCustom;
    

    
    //添加到View
    self.driveView = driveView;
    [self.view addSubview:driveView];
    [self.view sendSubviewToBack:driveView];
    
    //获取地图
    self.navMapView = [driveView valueForKeyPath:@"naviMapView.internalMapView"];
    //添加终点标记
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(self.endPoint.latitude, self.endPoint.longitude);
    self.navMapView.delegate = self;
    [self.navMapView addAnnotation:pointAnnotation];
    
    
    //代理
    //driveManager 请在 dealloc 函数中执行 [AMapNaviDriveManager destroyInstance] 来销毁单例
    [[AMapNaviDriveManager sharedInstance] setDelegate:self];
    [[AMapNaviDriveManager sharedInstance] setIsUseInternalTTS:NO];
    [[AMapNaviDriveManager sharedInstance] setAllowsBackgroundLocationUpdates:YES];
    [[AMapNaviDriveManager sharedInstance] setPausesLocationUpdatesAutomatically:NO];
    
    //将self 、driveView、trafficBarView 添加为导航数据的Representative，使其可以接收到导航诱导数据
    [[AMapNaviDriveManager sharedInstance] addDataRepresentative:driveView];
    [[AMapNaviDriveManager sharedInstance] addDataRepresentative:self];
    
    //算路
    [[AMapNaviDriveManager sharedInstance] calculateDriveRouteWithStartPoints:@[self.startPoint]
                                                                    endPoints:@[self.endPoint]
                                                                    wayPoints:nil
                                                              drivingStrategy:AMapNaviDrivingStrategySingleDefault];
}



#pragma mark  AMapNaviDriveManager （驾车路线规划、到达终点）
//计算路线成功
- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager {
    NSLog(@"onCalculateRouteSuccess");
    
    //算路成功后开始导航
    [[AMapNaviDriveManager sharedInstance] startGPSNavi];
    
}

//模拟到导航到达目的地回调
- (void)driveManagerDidEndEmulatorNavi:(AMapNaviDriveManager *)driveManager{
    NSLog(@"\n\n\n🤯模拟到导航到达目的地回调🤯\n\n\n");
}

//实时导航到导航到达目的地回调
- (void)driveManagerOnArrivedDestination:(AMapNaviDriveManager *)driveManager{
    NSLog(@"\n\n\n🚗实时导航到导航到达目的地回调🚗\n\n\n");
}


#pragma mark  AMapNaviDriveDataRepresentable （驾车路况信息）
//驾车导航路况信息
- (void)driveManager:(AMapNaviDriveManager *)driveManager updateNaviInfo:(AMapNaviInfo *)naviInfo {
    if (!naviInfo) return;
    
    //更新视图
    [self zx_updateViewWithNaviInfo:naviInfo];
}

//转向图标
- (void)driveManager:(AMapNaviDriveManager *)driveManager updateTurnIconImage:(UIImage *)turnIconImage turnIconType:(AMapNaviIconType)turnIconType {
    if (!turnIconImage) return;
}

//获取当前自己地理位置信息
- (void)driveManager:(AMapNaviDriveManager *)driveManager updateNaviLocation:(nullable AMapNaviLocation *)naviLocation{
    self.naviLocation = naviLocation;
}

#pragma mark  AMapNaviDriveViewDelegate（驾车视图代理）
//驾车导航界面白天黑夜模式切换后的回调函数
- (void)driveView:(AMapNaviDriveView *)driveView didChangeDayNightType:(BOOL)showStandardNightType {
    NSLog(@"didChangeDayNightType:%ld", (long)showStandardNightType);
}

//导航界面显示模式改变后的回调函数
- (void)driveView:(AMapNaviDriveView *)driveView didChangeShowMode:(AMapNaviDriveViewShowMode)showMode {

}





#pragma mark - 步行出行导航
//步行相关设置
- (void)zx_startWalkNav{
    
    AMapNaviWalkView *walkView = [[AMapNaviWalkView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    walkView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    walkView.showSensorHeading = YES;
    walkView.lineWidth = NavLineWidth;
    walkView.showGreyAfterPass = YES;
    walkView.showBrowseRouteButton = YES;
    
    
    walkView.delegate = self;
    [walkView setCarImage:IMAGENAMED(CarImage)];
    [walkView setEndPointImage:IMAGENAMED(@"clearImage")];
    [walkView setCarCompassImage:IMAGENAMED(@"clearImage")];
    walkView.mapViewModeType = AMapNaviViewMapModeTypeDay;
    walkView.showUIElements = NO;
    walkView.showTurnArrow = YES;
    
   
    //导航光线
    walkView.normalTexture = [UIImage imageNamed:@"btn_38px"];;
    
    //自定义地图样式
    NSString *path = [NSString stringWithFormat:@"%@/%@.data", [NSBundle mainBundle].bundlePath ,CustomMapStyle];
    NSData *data = [NSData dataWithContentsOfFile:path];
    MAMapCustomStyleOptions *options = [[MAMapCustomStyleOptions alloc] init];
    options.styleData = data;
    [walkView setCustomMapStyleOptions:options];
    walkView.mapViewModeType = AMapNaviViewMapModeTypeCustom;
    
    //添加
    self.walkView = walkView;
    [self.view addSubview:walkView];
    [self.view sendSubviewToBack:walkView];
    
    //获取地图
    self.navMapView = [walkView valueForKeyPath:@"naviMapView.internalMapView"];
    //添加终点标记
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(self.endPoint.latitude, self.endPoint.longitude);
    self.navMapView.delegate = self;
    [self.navMapView addAnnotation:pointAnnotation];
    
    //代理
    //walkManager 请在 dealloc 函数中执行 [AMapNaviDriveManager destroyInstance] 来销毁单例
    [[AMapNaviWalkManager sharedInstance] setDelegate:self];
    [[AMapNaviWalkManager sharedInstance] setIsUseInternalTTS:NO];
    
    //将self 、walkView、trafficBarView 添加为导航数据的Representative，使其可以接收到导航诱导数据
    [[AMapNaviWalkManager sharedInstance] addDataRepresentative:walkView];
    [[AMapNaviWalkManager sharedInstance] addDataRepresentative:self];

    //算路
    [[AMapNaviWalkManager sharedInstance] calculateWalkRouteWithStartPoints:@[self.startPoint] endPoints:@[self.endPoint]];
    
}


#pragma mark  AMapNaviWalkManager （步行路线规划、到达终点）
//计算路线成功
- (void)walkManagerOnCalculateRouteSuccess:(AMapNaviWalkManager *)walkManager{
    NSLog(@"onCalculateRouteSuccess");
    //算路成功后开始导航
    [[AMapNaviWalkManager sharedInstance] startGPSNavi];
}

//模拟导航到达目的地停止导航后的回调函数
- (void)walkManagerDidEndEmulatorNavi:(AMapNaviWalkManager *)walkManager{
    NSLog(@"\n\n\n🤯模拟到导航到达目的地回调🤯\n\n\n");
}

//导航到达目的地后的回调函数
- (void)walkManagerOnArrivedDestination:(AMapNaviWalkManager *)walkManager{
    NSLog(@"\n\n\n🚗实时导航到导航到达目的地回调🚗\n\n\n");
}



#pragma mark  AMapNaviWalkDataRepresentable（步行路况信息）
//步行导航路况信息
- (void)walkManager:(AMapNaviWalkManager *)walkManager updateNaviInfo:(nullable AMapNaviInfo *)naviInfo {
    if (!naviInfo) return;
    
    //更新视图
    [self zx_updateViewWithNaviInfo:naviInfo];
}


//获取当前自己地理位置信息
- (void)walkManager:(AMapNaviWalkManager *)walkManager updateNaviLocation:(nullable AMapNaviLocation *)naviLocation{
    self.naviLocation = naviLocation;
    
}


#pragma mark  AMapNaviWalkViewDelegate（步行视图代理）
//导航界面白天黑夜模式切换后的回调函数.
- (void)walkView:(AMapNaviWalkView *)walkView didChangeDayNightType:(BOOL)showStandardNightType{
    NSLog(@"didChangeDayNightType:%ld", (long)showStandardNightType);
    
}




#pragma mark - MAMapViewDelegate  (地图)
// (自定义标注图标)
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    
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
    }

}




#pragma mark - Private Method
//获取路况信息更新视图
- (void)zx_updateViewWithNaviInfo:(AMapNaviInfo *)naviInfo{
    //终点标注视图
    [self.terminalAnnotationView zx_updateNaviInfo:naviInfo];
}





#pragma mark - setter & getter

//openModel
- (ZXOpenResultsModel *)openResultsModel{
    
    ZXOpenResultsModel *_openResultsModel = objc_getAssociatedObject(self, @selector(openResultsModel));
    
    if (!_openResultsModel) {
        _openResultsModel = [ZXOpenResultsModel new];
        objc_setAssociatedObject(self, @selector(openResultsModel), _openResultsModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return _openResultsModel;
}

- (void)setOpenResultsModel:(ZXOpenResultsModel *)openResultsModel{
    objc_setAssociatedObject(self, @selector(openResultsModel), openResultsModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


//parentlistModel
- (ZXBlindBoxViewParentlistModel *)parentlistModel{
    
    ZXBlindBoxViewParentlistModel *_parentlistModel = objc_getAssociatedObject(self, @selector(parentlistModel));
    
    if (!_parentlistModel) {
        _parentlistModel = [ZXBlindBoxViewParentlistModel new];
        objc_setAssociatedObject(self, @selector(parentlistModel), _parentlistModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return _parentlistModel;
}

- (void)setParentlistModel:(ZXBlindBoxViewParentlistModel *)parentlistModel{
    objc_setAssociatedObject(self, @selector(parentlistModel), parentlistModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


//startPoint
- (AMapNaviPoint *)startPoint{
    AMapNaviPoint *_startPoint = objc_getAssociatedObject(self, @selector(startPoint));
    
    if (!_startPoint) {
        _startPoint = [AMapNaviPoint new];
        objc_setAssociatedObject(self, @selector(startPoint), _startPoint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return _startPoint;
}

- (void)setStartPoint:(AMapNaviPoint *)startPoint{
    objc_setAssociatedObject(self, @selector(startPoint), startPoint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


//endPoint
- (AMapNaviPoint *)endPoint{
    AMapNaviPoint *_endPoint = objc_getAssociatedObject(self, @selector(endPoint));
    
    if (!_endPoint) {
        _endPoint = [AMapNaviPoint new];
        objc_setAssociatedObject(self, @selector(endPoint), _endPoint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return _endPoint;
}

- (void)setEndPoint:(AMapNaviPoint *)endPoint{
    objc_setAssociatedObject(self, @selector(endPoint), endPoint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


//terminalAnnotationView

- (ZXTerminalAnnotationView *)terminalAnnotationView {
    
    ZXTerminalAnnotationView *_terminalAnnotationView = objc_getAssociatedObject(self, @selector(terminalAnnotationView));
    
    if (!_terminalAnnotationView) {
        _terminalAnnotationView = [ZXTerminalAnnotationView new];
        objc_setAssociatedObject(self, @selector(terminalAnnotationView), _terminalAnnotationView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return _terminalAnnotationView;
}

- (void)setTerminalAnnotationView:(ZXTerminalAnnotationView *)terminalAnnotationView{
    objc_setAssociatedObject(self, @selector(terminalAnnotationView), terminalAnnotationView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


//mapView
- (MAMapView *)navMapView{
    
    MAMapView *_navMapView = objc_getAssociatedObject(self, @selector(navMapView));
    
    if (!_navMapView){
        _navMapView = [MAMapView new];
        
        objc_setAssociatedObject(self, @selector(navMapView), _navMapView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return _navMapView;
}

- (void)setNavMapView:(MAMapView *)navMapView{
    objc_setAssociatedObject(self, @selector(navMapView), navMapView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


//naviLocation
- (AMapNaviLocation *)naviLocation{
    AMapNaviLocation *_naviLocation = objc_getAssociatedObject(self, @selector(naviLocation));
    
    if (!_naviLocation){
        _naviLocation = [AMapNaviLocation new];
        
        objc_setAssociatedObject(self, @selector(naviLocation), _naviLocation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return _naviLocation;
}


-(void)setNaviLocation:(AMapNaviLocation *)naviLocation{
    objc_setAssociatedObject(self, @selector(naviLocation), naviLocation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



//driveView
- (AMapNaviDriveView *)driveView{
    
    AMapNaviDriveView *_driveView = objc_getAssociatedObject(self, @selector(driveView));
    
    if (!_driveView){
        
        _driveView = [[AMapNaviDriveView alloc] initWithFrame:self.view.bounds];

        objc_setAssociatedObject(self, @selector(driveView), _driveView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return _driveView;
}

- (void)setDriveView:(AMapNaviDriveView *)driveView{
    objc_setAssociatedObject(self, @selector(driveView), driveView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


//walkView
- (AMapNaviWalkView *)walkView{
    
    AMapNaviWalkView *_walkView = objc_getAssociatedObject(self, @selector(walkView));
    
    if (!_walkView){
        
        _walkView = [[AMapNaviWalkView alloc] initWithFrame:self.view.bounds];

        objc_setAssociatedObject(self, @selector(walkView), _walkView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return _walkView;
}

- (void)setWalkView:(AMapNaviWalkView *)walkView{
    objc_setAssociatedObject(self, @selector(walkView), walkView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - DEllOC
- (void)dealloc {
    
    NSLog(@"\n🤯--%s--🤯",__func__);
    
   
    if (self.openResultsModel.currentNavType == ZXCurrentNavType_Drive){
        BOOL successDrive = [AMapNaviDriveManager destroyInstance];
        NSLog(@"\n🚗--单例是否销毁成功 :%d--🚗",successDrive);
    }else{
        
        [[AMapNaviWalkManager sharedInstance] stopNavi];
        [[AMapNaviWalkManager sharedInstance] removeDataRepresentative:self.walkView];
        [[AMapNaviWalkManager sharedInstance] removeDataRepresentative:self];
        [[AMapNaviWalkManager sharedInstance] setDelegate:nil];
        
        
        BOOL successWalk = [AMapNaviWalkManager destroyInstance];
        NSLog(@"\n🚶‍♀️--单例是否销毁成功 :%d--🚶‍♀️",successWalk);
    }
    
}


@end

//
//  ZXHomeLocationDetailsViewController.m
//  ZXHY
//
//  Created by Bern Lin on 2022/2/28.
//

#import "ZXHomeLocationDetailsViewController.h"
#import "ZXStartView.h"
#import "ZXHomeModel.h"
#import <AMapNaviKit/AMapNaviKit.h>
#import <AMapLocationKit/AMapLocationKit.h>


//自定义地图
#define CustomMapStyle @"BlindBoxMap"


@interface ZXHomeLocationDetailsViewController ()
<MAMapViewDelegate>

//地图
@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) ZXHomeListModel *listModel;

@property (nonatomic, strong) UILabel       *titleLabel;
@property (nonatomic, strong) UILabel       *addressLabel;
@property (nonatomic, strong) ZXStartView   *startView;
@property (nonatomic, strong) UILabel       *disanceLabel;

@end

@implementation ZXHomeLocationDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self zx_initializationMap];
    
    [self zx_initializationUI];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
}


#pragma mark - Initialization

//初始化UI
- (void)zx_initializationUI{
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = UIColor.whiteColor;
    topView.layer.cornerRadius = 5;
    topView.layer.masksToBounds = YES;
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavigationBarHeight+20);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
    }];
    
 
    self.titleLabel = [UILabel labelWithFont:kFontSemibold(16) TextAlignment:NSTextAlignmentLeft TextColor:UIColor.blackColor TextStr:self.listModel.location.address NumberOfLines:2];
    [topView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(topView).offset(15);
        make.right.equalTo(topView).offset(-15);
    }];
    
    self.addressLabel = [UILabel labelWithFont:kFontSemibold(12) TextAlignment:NSTextAlignmentLeft TextColor:WGGrayColor(102) TextStr:self.listModel.location.detailaddress NumberOfLines:0];
    [topView addSubview:self.addressLabel];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.left.right.equalTo(self.titleLabel).offset(0);
        make.bottom.equalTo(topView.mas_bottom).offset(-35);
    }];
    
    
    self.startView = [ZXStartView new];
    [self.startView zx_scores:self.listModel.location.point WithType:ZXStartType_Info];
    [topView addSubview:self.startView ];
    [self.startView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressLabel.mas_bottom).offset(10);
        make.left.equalTo(self.titleLabel).offset(0);
        make.width.offset(85);
        make.height.offset(15);
    }];
    
    self.disanceLabel = [UILabel labelWithFont:kFont(12) TextAlignment:NSTextAlignmentLeft TextColor:WGGrayColor(153) TextStr:@"距离你 1.2km" NumberOfLines:1];
    [topView addSubview:self.disanceLabel];
    [self.disanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.startView);
        make.left.equalTo(self.startView.mas_right).offset(10);
        make.right.equalTo(topView).offset(-15);
    }];
    
    
}


//初始化Map
- (void)zx_initializationMap{
    
    [self.view addSubview:self.mapView];
    
//    39.99188446 ,116.46706996;
    
    //添加标注
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake( [self.listModel.location.lat floatValue], [self.listModel.location.lng floatValue]);
    pointAnnotation.title = self.listModel.location.address;
    pointAnnotation.subtitle = self.listModel.location.detailaddress;
    [self.mapView addAnnotation:pointAnnotation];
    
//    [self.mapView showAnnotations:self.mapView.annotations  animated:YES];
}

#pragma mark - Private Method
//模型赋值
- (void)zx_setHomeListModel:(ZXHomeListModel *)listModel{
    self.listModel = listModel;
    if (!listModel) return;;
    
}


#pragma mark - MAMapViewDelegate (地图代理)

// 定位失败后，会调用此函数
- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    //设置提示提醒用户打开定位服务
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"允许定位提示" message:@"请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:nil];
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

//标注
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        return nil;
    }
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= NO;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = NO;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorRed;
        return annotationView;
    }
    return nil;
}

//用户位置
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{

    if (updatingLocation){
        
        MAMapPoint startPoint = MAMapPointForCoordinate(CLLocationCoordinate2DMake(userLocation.coordinate.latitude,userLocation.coordinate.longitude));
        
        MAMapPoint endPoint = MAMapPointForCoordinate(CLLocationCoordinate2DMake([self.listModel.location.lat floatValue], [self.listModel.location.lng floatValue]));
        
        //计算距离
        CLLocationDistance distance = MAMetersBetweenMapPoints(startPoint,endPoint);
      
        NSString *mainStr = @"";
        
        if (distance >= 1000) {
            CGFloat kiloMeter = distance / 1000.0;
            mainStr =  [NSString stringWithFormat:@"距离你 %.1fkm", kiloMeter];
        } else {
            mainStr = [NSString stringWithFormat:@"距离你 %ldm", (long)distance];
        }
        self.disanceLabel.text = mainStr;
    }
}


#pragma mark - Dealloc
- (void)dealloc{
   
//    self.mapView.renderringDisabled = NO;
//    [self.mapView removeFromSuperview];
//    self.mapView = nil;
//    self.mapView.delegate = nil;
    [self.view removeFromSuperview];
    NSLog(@"\nself.mapView------%@",self.mapView);
    
}

#pragma mark - layz
- (MAMapView *)mapView{
    if (!_mapView){
        
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, WGNumScreenWidth(), WGNumScreenHeight() - kNavigationBarHeight)];
        
        
        _mapView.delegate = self;
        _mapView.rotateCameraEnabled= YES;   //是否支持camera旋转, 默认YES

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

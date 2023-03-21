//
//  ZXOpenBlindBoxViewController.m
//  ZXHY
//
//  Created by Bern Mac on 7/30/21.
//

#import "ZXOpenBlindBoxViewController.h"
#import "ZXOpenResultsViewController.h"
#import "ZXopenResultsSelectViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ZXOpenBlindBoxViewController ()
<CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerViewCenterY;
@property (weak, nonatomic) IBOutlet UIView *tipsView;
@property (weak, nonatomic) IBOutlet UIButton *openButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (weak, nonatomic) IBOutlet UILabel *moodLabel;
@property (weak, nonatomic) IBOutlet UILabel *budgetTipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceTipsLabel;

@property (nonatomic, strong) NSString  *moodTipsStr;
@property (nonatomic, strong) NSString  *budgetTipsStr;
@property (nonatomic, strong) NSString  *distanceTipsStr;
@property (nonatomic, strong) NSDictionary  *resultDic;
@property (nonatomic, strong) NSMutableArray *questList;
@property (nonatomic, strong) NSString *typeId;

//获取地理位置
@property (nonatomic, strong) CLLocationManager  *locationManager;
@property (nonatomic, strong) NSString*strlatitude;//经度
@property (nonatomic, strong) NSString*strlongitude;//纬度


@end

@implementation ZXOpenBlindBoxViewController

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationView.alpha = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self zx_initializationXIB];
    
    [self zx_startLocation];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];

}


#pragma mark - Initialization UI
//初始化XIB
- (void)zx_initializationXIB{
    
    self.tipsView.layer.cornerRadius = 15;
    self.tipsView.clipsToBounds = NO;
    self.tipsView.layer.shadowColor =  WGHEXAlpha(@"828282", 0.25).CGColor;
    self.tipsView.layer.shadowOffset = CGSizeMake(0,4);
    self.tipsView.layer.shadowRadius = 3;
    self.tipsView.layer.shadowOpacity = 1;
    
    [self.openButton wg_setLayerRoundedCornersWithRadius:24];
    NSArray * colors = @[WGRGBColor(255, 89, 158),WGRGBColor(255, 69, 69)];
    [self.openButton wg_backgroundGradientHorizontalColors:colors];
    self.openButton.userInteractionEnabled = NO;
    
    self.closeButton.layer.cornerRadius = 24;
    self.closeButton.layer.borderWidth = 2;
    self.closeButton.layer.borderColor = WGRGBColor(255, 89, 158).CGColor;
    
    [self.budgetTipsLabel wg_setLayerRoundedCornersWithRadius:12.5];
    [self.distanceTipsLabel wg_setLayerRoundedCornersWithRadius:12.5];
    
    self.moodLabel.text = self.moodTipsStr;
    self.budgetTipsLabel.text = [NSString stringWithFormat:@" %@      ",self.budgetTipsStr];
    self.distanceTipsLabel.text =  [NSString stringWithFormat:@" %@      ",self.distanceTipsStr];
    

}


#pragma mark - Private Method

//开启按钮响应
- (IBAction)openAction:(UIButton *)sender {

    self.openButton.userInteractionEnabled = NO;
    [self zx_reqApiGetBox];

}

//关闭按钮响应
- (IBAction)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//获取盒子信息
- (void)zx_getBoxDataWithMood:(NSString *)mood Budget:(NSString *)budget Distance:(NSString *)distance QuestList:(NSMutableArray *)questList{
//    mood
    self.moodTipsStr = mood;
    self.budgetTipsStr = budget;
    self.distanceTipsStr = distance;
    self.questList = questList;
    
}

//获取问答数据
- (void)zx_reqApiGetBoxWithTypeId:(NSString *)typeId{
    self.typeId = typeId;
}


//开始定位
- (void)zx_startLocation{
    
    //判断定位功能是否打开
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager requestWhenInUseAuthorization];
        
        //设置寻址精度
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 5.0;
        [self.locationManager startUpdatingLocation];
    }
}

#pragma mark - CoreLocation Delegate (定位代理)
//定位失败后调用此代理方法
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    //设置提示提醒用户打开定位服务
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"允许定位提示" message:@"请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:nil];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [[WGUIManager wg_currentIndexNavController] presentViewController:alert animated:YES completion:nil];
    
    self.openButton.userInteractionEnabled = NO;
}

//定位成功后则执行此代理方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    [self.locationManager stopUpdatingHeading];
    //旧址
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    //打印当前的经度与纬度
    NSLog(@"%f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    
    self.strlatitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
    self.strlongitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
    [self.locationManager stopUpdatingLocation];
    
    self.openButton.userInteractionEnabled = YES;
    
    //反地理编码
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error){
        
        NSLog(@"反地理编码");
        NSLog(@"反地理编码%ld",placemarks.count);
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];
           
            NSString *localityStr = placeMark.locality;
            if (localityStr) {
                localityStr = @"无法定位当前城市";
            }
            /*看需求定义一个全局变量来接收赋值*/
            NSLog(@"城市----%@",placeMark.country);//当前国家
            NSLog(@"城市%@",localityStr);//当前的城市
            NSLog(@"%@",placeMark.subLocality);//当前的位置
            NSLog(@"%@",placeMark.thoroughfare);//当前街道
            NSLog(@"%@",placeMark.name);//具体地址
            
        }
    }];
    
}



#pragma mark - NetworkRequest

//提交勾选
- (void)zx_reqApiGetBox{
   
    [WGUIManager wg_showHUD];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict wg_safeSetObject:self.typeId forKey:@"typeid"];
    [dict wg_safeSetObject:self.strlongitude forKey:@"lng"];
    [dict wg_safeSetObject:self.strlatitude forKey:@"lat"];
    [dict wg_safeSetObject:[self.questList wg_modelWithJSON] forKey:@"jsonstr"];
    
    
    WEAKSELF;
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiGetBox Parameter:dict success:^(NSDictionary * _Nonnull resultDic) {
        STRONGSELF;
        
        [WGUIManager wg_hideHUD];
        
        ZXopenResultsSelectViewController *resultsViewController = [ZXopenResultsSelectViewController new];
        [resultsViewController zx_getBlindBox:resultDic];
        [self.navigationController pushViewController:resultsViewController animated:YES];
        
        self.openButton.userInteractionEnabled = YES;
    } failure:^(NSError * _Nonnull error) {
        self.openButton.userInteractionEnabled = YES;
        
    }];
}

@end

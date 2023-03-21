//
//  ZXMapNavOtherMapTableViewCell.m
//  ZXHY
//
//  Created by Bern Lin on 2022/1/14.
//

typedef NS_ENUM(NSUInteger, ZXMapNavOtherMap) {
    ZXMapNavOtherMap_Gaode, //高德
    ZXMapNavOtherMap_Baidu, //百度
    ZXMapNavOtherMap_Apple, //苹果
};

#import "ZXMapNavOtherMapTableViewCell.h"
#import "ZXOpenResultsModel.h"
#import "ZXLocationTransFormTool.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MKMapItem.h>//用于苹果自带地图
#import <MapKit/MKTypes.h>//用于苹果自带地图


@interface ZXMapNavOtherMapTableViewCell()

@property (nonatomic, strong) ZXOpenResultsModel  *openResultsModel;


@end


@implementation ZXMapNavOtherMapTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)wg_cellIdentifier{
    return @"ZXMapNavOtherMapTableViewCell";
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self setupUI];
    }
    return self;
}

#pragma mark - Private Method
//设置UI
- (void)setupUI{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = UIColor.clearColor;
    self.contentView.backgroundColor = UIColor.clearColor;
    
    [self zx_systemHasMap];
    
}



//判断系统有什么导航软件并布局
- (void)zx_systemHasMap{
    
    NSMutableArray *mapArr = [NSMutableArray array];
    NSArray *imageArr = @[@"gaodeNav",@"baiduNav",@"appleNav"];
    NSArray *strArr = @[@"高德地图",@"百度地图",@"Apple 地图"];
    
    
    //高德地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://map/"]]) {
        
        [mapArr wg_safeAddObject:@(ZXMapNavOtherMap_Gaode)];
    }
    
    //百度地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://map/"]]) {
        [mapArr wg_safeAddObject:@(ZXMapNavOtherMap_Baidu)];
    }
    
    //苹果地图
    [mapArr wg_safeAddObject:@(ZXMapNavOtherMap_Apple)];
    
    for (int i = 0; i < mapArr.count; i++){
        
        ZXMapNavOtherMap mapType =  (ZXMapNavOtherMap)[[mapArr wg_safeObjectAtIndex:i] integerValue];
        
        UIImageView *imgView = [UIImageView wg_imageViewWithImageNamed:[imageArr wg_safeObjectAtIndex:mapType]];
        imgView.frame = CGRectMake(32 + i * (64 + 18), 15, 64, 64);
        [self.contentView addSubview:imgView];
        
        
        UILabel *label = [UILabel labelWithFont:kFont(12) TextAlignment:NSTextAlignmentCenter TextColor:WGGrayColor(102) TextStr:[strArr wg_safeObjectAtIndex:mapType] NumberOfLines:1];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(imgView.mas_bottom).offset(5);
            make.centerX.mas_equalTo(imgView);
            make.height.offset(18);
        }];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = mapType;
        button.adjustsImageWhenHighlighted = NO;
        [button addTarget:self action:@selector(mapAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(imgView);
            make.bottom.mas_equalTo(label.mas_bottom);
        }];
    }
    
}


//按钮响应
- (void)mapAction:(UIButton *)sender{
    
    //处理坐标
    CLLocationCoordinate2D currentCoord = CLLocationCoordinate2DMake(self.openResultsModel.startPoint.latitude, self.openResultsModel.startPoint.longitude);

    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([self.openResultsModel.lnglat.lat floatValue] ,[self.openResultsModel.lnglat.lng floatValue]);
    
    
    ZXMapNavOtherMap mapType = sender.tag;
    
    
//    ZXMapNavOtherMap_Gaode, //高德
//    ZXMapNavOtherMap_Baidu, //百度
//    ZXMapNavOtherMap_Apple, //苹果
    
    //苹果地图
    if (mapType == ZXMapNavOtherMap_Apple){
        //起点
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        ZXLocationTransFormTool *locationTransFormToolEnd = [[ZXLocationTransFormTool alloc] initWithLatitude:coord.latitude andLongitude:coord.longitude ];
        
        //终点
        CLLocationCoordinate2D desCorrdinate = CLLocationCoordinate2DMake(locationTransFormToolEnd.latitude, locationTransFormToolEnd.longitude);
        
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:desCorrdinate addressDictionary:nil]];
        
        //默认驾车

        [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
        launchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
        MKLaunchOptionsMapTypeKey:[NSNumber numberWithInteger:MKMapTypeStandard],
        MKLaunchOptionsShowsTrafficKey:[NSNumber numberWithBool:YES]}];
        
        return;
    }
    
    
    NSString *urlString = @"";
    //高德
    if (mapType == ZXMapNavOtherMap_Gaode){
        
        //坐标转换
        ZXLocationTransFormTool *locationTransFormTool = [[[ZXLocationTransFormTool alloc] initWithLatitude:currentCoord.latitude andLongitude:currentCoord.longitude] transformFromGDToGPS];
        
        ZXLocationTransFormTool *locationTransFormToolEnd = [[ZXLocationTransFormTool alloc] initWithLatitude:coord.latitude andLongitude:coord.longitude];
        
        
        NSString *gaodeParameterFormat = @"iosamap://path?sourceApplication=applicationName&sid=BGVIS1&slat=%lf&slon=%lf&sname=我的位置&did=BGVIS2&dlat=%lf&dlon=%lf&dname=%@&dev=0&m=0&t=0";
        
        
        urlString = [[NSString stringWithFormat:
                                gaodeParameterFormat,
                                locationTransFormTool.latitude,
                                locationTransFormTool.longitude,
                                locationTransFormToolEnd.latitude,
                                locationTransFormToolEnd.longitude,
                                @"终点"]
        stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        
    }
    
    
    //百度
    else if (mapType == ZXMapNavOtherMap_Baidu){
        //坐标转换
        ZXLocationTransFormTool *locationTransFormTool = [[[ZXLocationTransFormTool alloc] initWithLatitude:currentCoord.latitude andLongitude:currentCoord.longitude] transformFromGDToBD];


        ZXLocationTransFormTool *locationTransFormToolEnd = [[[ZXLocationTransFormTool alloc] initWithLatitude:coord.latitude andLongitude:coord.longitude] transformFromGDToBD];
        
        

    NSString *baiduParameterFormat = @"baidumap://map/direction?origin=latlng:%f,%f|name:我的位置&destination=latlng:%f,%f|name:终点&mode=driving";

    urlString = [[NSString stringWithFormat:
                            baiduParameterFormat,
                            locationTransFormTool.latitude,//用户当前的位置
                            locationTransFormTool.longitude,//用户当前的位置
                            locationTransFormToolEnd.latitude,
                            locationTransFormToolEnd.longitude]
                           stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    if (@available(iOS 10.0, *)){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{UIApplicationOpenURLOptionUniversalLinksOnly : @NO} completionHandler:NULL];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
    
    
    
}


//数据
- (void)zx_openResultsModel:(ZXOpenResultsModel *)openResultsModel{
    self.openResultsModel = openResultsModel;
}

@end

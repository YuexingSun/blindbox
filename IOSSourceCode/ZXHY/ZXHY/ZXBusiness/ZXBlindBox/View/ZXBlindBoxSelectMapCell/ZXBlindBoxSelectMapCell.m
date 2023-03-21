//
//  ZXBlindBoxSelectMapCell.m
//  ZXHY
//
//  Created by Bern Mac on 9/29/21.
//

#import "ZXBlindBoxSelectMapCell.h"
#import <AMapNaviKit/AMapNaviKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "ZXBlindBoxSelectViewModel.h"



#define kButtonViewTag(i) ((UIButton *)[self.contentView viewWithTag:i])

@interface ZXBlindBoxSelectMapCell ()
<MAMapViewDelegate>
@property (nonatomic, strong) UILabel  *titleLabel;

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) MACircle *mapViewCircle;
@property (nonatomic, assign) double  radius;


@property (nonatomic, strong) ZXBlindBoxSelectViewModel  *blindBoxSelectViewModel;

@end

@implementation ZXBlindBoxSelectMapCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (NSString *)wg_cellIdentifier{
    return @"ZXBlindBoxSelectMapCellID";
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self setupUI];
    }
    return self;
}

//设置UI
- (void)setupUI{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = UIColor.clearColor;
    self.backgroundColor = UIColor.clearColor;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, WGNumScreenWidth() - 20, 25)];
    titleLabel.textColor = kMainTitleColor;
    titleLabel.numberOfLines = 1;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.text = @"距离时长";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    //初始化地图
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(15, 90, WGNumScreenWidth() - 30, 250)];
    [self.mapView wg_setRoundedCornersWithRadius:15];
    self.mapView.delegate = self;
    self.mapView.rotateCameraEnabled= NO;    //NO表示禁用倾斜手势，YES表示开启
    self.mapView.scrollEnabled = NO;    //NO表示禁用滑动手势，YES表示开启
    self.mapView.zoomEnabled = NO;    //NO表示禁用缩放手势，YES表示开启
    self.mapView.rotateEnabled= NO;    //NO表示禁用旋转手势，YES表示开启
    [self.mapView setZoomLevel:15.4 animated:YES];
    //如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    
    //构造圆
    self.radius = 500;
    self.mapViewCircle = [MACircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(self.mapView.userLocation.location.coordinate.latitude,self.mapView.userLocation.location.coordinate.longitude) radius:self.radius];

    //在地图上添加圆
    [self.mapView addOverlay: self.mapViewCircle];
    
    
    //距离选项
    UIView *distanceView = [[UIView alloc] initWithFrame:CGRectMake(15, _mapView.mj_y + _mapView.mj_h + 15, WGNumScreenWidth() - 30, 40)];
    distanceView.backgroundColor = WGGrayColor(243);
    [distanceView wg_setRoundedCornersWithRadius:20];
    [self.contentView addSubview:distanceView];
    
    NSArray *content = @[@"步行可达",@"使用交通工具",@"比较远也行"];
    for (int i = 0 ; i < content.count; i++){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = UIColor.clearColor;
        button.titleLabel.font = kFont(14);
        [button setTitleColor:WGGrayColor(127) forState:UIControlStateNormal];
        [button setTitle:content[i] forState:UIControlStateNormal];
        if (i == 0){
            button.backgroundColor = WGRGBColor(255, 217, 232);
            button.titleLabel.font = kFontSemibold(14);
            [button setTitleColor:WGRGBColor(255, 82, 128) forState:UIControlStateNormal];
        }
        button.frame = CGRectMake((distanceView.mj_w /3) * i, 0, distanceView.mj_w /3, distanceView.mj_h);
        [distanceView addSubview:button];
        button.tag = 8000 + i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        //分割线
        if (i != 0){
            UIView *lineView = [UIView new];
            lineView.backgroundColor = WGGrayColor(214);
            lineView.frame = CGRectMake((distanceView.mj_w /3) * i, 8, 0.5, distanceView.mj_h - 16);
            [distanceView addSubview:lineView];
        }
        
        
    }

        
}
  

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.contentView addSubview:self.mapView];
}



#pragma mark - MAMapViewDelegate
-(MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay{
    if ([overlay isKindOfClass:[MACircle class]])
        {
            MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];
            
            circleRenderer.lineWidth    = 2.f;
            circleRenderer.strokeColor  = WGRGBAlpha(0, 163, 255, 1);
            circleRenderer.fillColor    = WGRGBAlpha(0, 163, 255, 0.3);
            return circleRenderer;
        }
        return nil;
}


- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    

    if (!updatingLocation){
        [self.mapViewCircle setCircleWithCenterCoordinate:CLLocationCoordinate2DMake(self.mapView.userLocation.location.coordinate.latitude,self.mapView.userLocation.location.coordinate.longitude) radius:self.radius];
        
    }

}

- (void)mapViewDidStopLocatingUser:(MAMapView *)mapView{
    
    
}



#pragma mark - 私有方法
- (void)buttonAction:(UIButton *)sender{

    for (int i = 0 ; i < 3; i++){
        kButtonViewTag(8000+i).backgroundColor = UIColor.clearColor;
        kButtonViewTag(8000+i).titleLabel.font = kFont(14);
        [kButtonViewTag(8000+i) setTitleColor:WGGrayColor(127) forState:UIControlStateNormal];
    }
    
    
    kButtonViewTag(sender.tag).backgroundColor = WGRGBColor(255, 217, 232);
    kButtonViewTag(sender.tag).titleLabel.font = kFontSemibold(14);
    [kButtonViewTag(sender.tag) setTitleColor:WGRGBColor(255, 82, 128) forState:UIControlStateNormal];
    
    
    
    if (sender.tag == 8000){
        self.radius = 500;
        [self.mapView setZoomLevel:15.4 animated:YES];
    }
    else if (sender.tag == 8001){
        self.radius = 3000;
        [self.mapView setZoomLevel:12.8 animated:YES];
    }
    else if (sender.tag == 8002){
        self.radius = 10000;
        [self.mapView setZoomLevel:11.0 animated:YES];
    }
    
    [self.mapViewCircle setCircleWithCenterCoordinate:CLLocationCoordinate2DMake(self.mapView.userLocation.location.coordinate.latitude,self.mapView.userLocation.location.coordinate.longitude) radius:self.radius];
    
    //当前距离赋值
    for (ZXBlindBoxSelectViewItemlistModel *itemlistModel in self.blindBoxSelectViewModel.itemlist){
        itemlistModel.select = NO;
    }
    ZXBlindBoxSelectViewItemlistModel *itemlistModel = [self.blindBoxSelectViewModel.itemlist wg_safeObjectAtIndex:sender.tag - 8000];
    itemlistModel.select = YES;
}

//数据赋值
- (void)zx_setBlindBoxSelectViewModel:(ZXBlindBoxSelectViewModel *)blindBoxSelectViewModel{
    if (!blindBoxSelectViewModel) return;
    
    self.blindBoxSelectViewModel = blindBoxSelectViewModel;
    
    self.titleLabel.text = self.blindBoxSelectViewModel.title;

}


- (void)dealloc{
    NSLog(@"ZXBlindBoxSelectMapCell---------delloc");
}
@end

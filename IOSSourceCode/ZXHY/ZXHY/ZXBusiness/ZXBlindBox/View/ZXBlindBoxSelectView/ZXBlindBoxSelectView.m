//
//  ZXBlindBoxSelectView.m
//  ZXHY
//
//  Created by Bern Mac on 7/29/21.
//

#import "ZXBlindBoxSelectView.h"
#import "ZXBlindBoxSelectBudgetCell.h"
#import "ZXBlindBoxSelectDistanceTimeCell.h"
#import "ZXBlindBoxSelectActivityCell.h"
#import "ZXBlindBoxSelectMapCell.h"
#import "ZXBlindBoxSelectViewModel.h"
#import <CoreLocation/CoreLocation.h>


typedef NS_ENUM(NSInteger, ZXBlindBoxSelectViewPage) {
    ZXBlindBoxSelectViewPage_First,
    ZXBlindBoxSelectViewPage_Second
};

@interface ZXBlindBoxSelectView()
<
UITableViewDelegate,
UITableViewDataSource,
CLLocationManagerDelegate,
ZXBlindBoxSelectBudgetCellDelegate
>

//盲盒类型ID
@property (nonatomic, strong) NSString  *typeId;

@property (nonatomic, strong) UIScrollView  *mainScrollView;

@property (nonatomic, strong) WGBaseTableView            *tableView;
@property (nonatomic, strong) WGBaseTableView            *secondTableView;
@property (nonatomic, strong) UIButton                   *sureButton;
@property (nonatomic, strong) UIButton                   *cancelButton;
@property (nonatomic, strong) NSMutableArray             *dataList;
@property (nonatomic, strong) NSMutableArray             *questList;
@property (nonatomic, strong) NSMutableDictionary        *budgetDisanceDic;

@property (nonatomic, strong) ZXBlindBoxSelectViewMainModel *mainModel;

//记录选中人数model
@property (nonatomic, strong)  ZXBlindBoxSelectViewItemlistModel    *selectNumberModel;

//记录当前页数
@property (nonatomic, assign) ZXBlindBoxSelectViewPage  currentPage;

//获取地理位置
@property (nonatomic, strong) CLLocationManager  *locationManager;
@property (nonatomic, strong) NSString*strlatitude;//经度
@property (nonatomic, strong) NSString*strlongitude;//纬度

@end


@implementation ZXBlindBoxSelectView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setLayout];
        [self zx_startLocation];
    }
    return self;
}


- (void)setLayout{
    self.backgroundColor = WGGrayColor(255);
    [self wg_setRoundedCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) radius:16];
    
    UIImageView *backImageView = [UIImageView wg_imageViewWithImageNamed:@"BlindSelectBackImage"];
    [self addSubview:backImageView];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
    
    [self addSubview:self.sureButton];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-40);
        make.centerX.equalTo(self);
        make.left.equalTo(self.mas_left).offset(60);
        make.right.equalTo(self.mas_right).offset(-60);
        make.height.offset(50);
    }];
    [self.sureButton layoutIfNeeded];
    self.sureButton.layer.shadowColor = WGHEXAlpha(@"FF0000", 0.25).CGColor;
    self.sureButton.layer.shadowOffset = CGSizeMake(0,4);
    self.sureButton.layer.shadowRadius = 3;
    self.sureButton.layer.shadowOpacity = 1;
    self.sureButton.layer.cornerRadius = 25;
    self.sureButton.clipsToBounds = NO;
//    NSArray * colors = @[WGRGBAlpha(248, 110, 151, 1),WGRGBAlpha(235, 83, 83, 1)];
//    [self.sureButton wg_backgroundGradientHorizontalColors:colors];
//    [self.sureButton wg_setLayerRoundedCornersWithRadius:25];

    
    [self addSubview:self.mainScrollView];
    [self.mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.sureButton.mas_top).offset(-10);
    }];
    
    
    [self addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(20);
        make.height.width.offset(25);
    }];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.tableView.frame = CGRectMake(0, 0, WGNumScreenWidth(), self.mainScrollView.mj_h);
    [self.mainScrollView addSubview:self.tableView];
    
    self.secondTableView.frame = CGRectMake(WGNumScreenWidth(), 0, WGNumScreenWidth(), self.mainScrollView.mj_h);
    [self.mainScrollView addSubview:self.secondTableView];
}


#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.tableView){
        return self.mainModel.pagenum;
    }else{
        return self.dataList.count - self.mainModel.pagenum;
    }
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger index = 0;
    if (tableView == self.tableView){
        index = indexPath.row;
    }else{
        index = indexPath.row + self.mainModel.pagenum;
    }
    
    ZXBlindBoxSelectViewModel *model = [self.dataList wg_safeObjectAtIndex:index];
    
    if ([model.type isEqualToString:@"tag"]){
        ZXBlindBoxSelectBudgetCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZXBlindBoxSelectBudgetCell wg_cellIdentifier]];
        [cell zx_setBlindBoxSelectViewModel:model];
        if ([model.ID intValue] == 4){
            cell.delegate = self;
        }
        return cell;
        
    }else if ([model.type isEqualToString:@"range"]){

        ZXBlindBoxSelectMapCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZXBlindBoxSelectMapCell wg_cellIdentifier]];
        [cell zx_setBlindBoxSelectViewModel:model];
        return cell;
        
    }else if ([model.type isEqualToString:@"image"]){
        ZXBlindBoxSelectActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZXBlindBoxSelectActivityCell wg_cellIdentifier] forIndexPath:indexPath];
        [cell zx_setBlindBoxSelectViewModel:model NumberModel:self.selectNumberModel];
        return cell;
    }
    
    UITableViewCell *cell = [UITableViewCell new];
    cell.backgroundColor = UIColor.clearColor;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger index = 0;
    if (tableView == self.tableView){
        index = indexPath.row;
    }else{
        index = indexPath.row + self.mainModel.pagenum;
    }
    
    ZXBlindBoxSelectViewModel *model = [self.dataList wg_safeObjectAtIndex:index];
    if ([model.type isEqualToString:@"tag"]){
        if (model.itemlist.count > 3){
            return 220;
        }
        return 170;
    }else if ([model.type isEqualToString:@"range"]){
        return 400;
    }else if ([model.type isEqualToString:@"image"]){
        return 550;
    }
    return 0.1f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}


#pragma mark - ZXBlindBoxSelectBudgetCellDelegate
//选中人数回调
- (void)selectBudgetCell:(ZXBlindBoxSelectBudgetCell *)view BlindBoxSelectViewItemlistModel:(ZXBlindBoxSelectViewItemlistModel *)itemlistModel{
    self.selectNumberModel = itemlistModel;
    [self.tableView reloadData];
}


#pragma mark - CoreLocation Delegate (定位代理)
//定位失败后调用此代理方法
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
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
        if(self.delegate && [self.delegate respondsToSelector:@selector(blindBoxSelectView: SelectorWithCancel:)]){
            [self.delegate blindBoxSelectView:self SelectorWithCancel:self.cancelButton];
        }
    }];
    
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [[WGUIManager wg_topViewController] presentViewController:alert animated:YES completion:nil];
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
//获取问答数据
- (void)zx_reqApiGetBoxQuesListWithTypeId:(NSString *)typeId{
   
    self.typeId = typeId;
    
    NSDictionary *dict = @{@"typeid":typeId?:@""};
  
    [WGUIManager wg_showHUD];
    
    WEAKSELF;
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiGetBoxQuesList Parameter:dict success:^(NSDictionary * _Nonnull resultDic) {
        STRONGSELF;
        [WGUIManager wg_hideHUD];
        
        self.mainModel = [ZXBlindBoxSelectViewMainModel wg_objectWithDictionary:[resultDic wg_safeObjectForKey:@"data"]];
        
        self.dataList = self.mainModel.list.mutableCopy;
        
        //初始化选中值
        for (ZXBlindBoxSelectViewModel *blindBoxSelectViewModel in self.dataList){
            
            
            
            for (int i = 0; i < blindBoxSelectViewModel.itemlist.count; i++){
                
                ZXBlindBoxSelectViewItemlistModel *itemlistModel = [blindBoxSelectViewModel.itemlist wg_safeObjectAtIndex:i];
                
                if (itemlistModel.isdefault == 1){
                    itemlistModel.select = YES;
                    blindBoxSelectViewModel.selectIndex = i;
                    
                    //默认选中人数的model
                    if ([blindBoxSelectViewModel.ID intValue] == 4){
                        self.selectNumberModel = itemlistModel;
                    }
                }
               
            }
        }

        
        
        [self.tableView reloadData];
        [self.secondTableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {

        
    }];
}

#pragma mark - Private Method
//整理当前勾选
- (void)zx_currentCheck{
    
    self.questList = [NSMutableArray array];
    self.budgetDisanceDic = [NSMutableDictionary dictionary];
    
    for (ZXBlindBoxSelectViewModel *selectViewModel in self.dataList){
       
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        for (ZXBlindBoxSelectViewItemlistModel *itemlistModel in selectViewModel.itemlist){
            if (itemlistModel.select){
                [dict wg_safeSetObject:selectViewModel.ID forKey:@"quesid"];
                [dict wg_safeSetObject:itemlistModel.itemid forKey:@"ans"];
                
                
                //获取当前勾选文本
                if ([selectViewModel.ID intValue] == 1){
                    [self.budgetDisanceDic wg_safeSetObject:itemlistModel.itemname forKey:@"budget"];
                }else if ([selectViewModel.ID intValue] == 2){
                    [self.budgetDisanceDic wg_safeSetObject:itemlistModel.itemname forKey:@"disance"];
                }else if ([selectViewModel.ID intValue] == 3){
                    [self.budgetDisanceDic wg_safeSetObject:itemlistModel.itemname forKey:@"mood"];
                }
            }
        }
        [self.questList wg_safeAddObject:dict];
    }
    
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


//确定响应
- (void)sureAction:(UIButton *)sender{

    if (self.currentPage == ZXBlindBoxSelectViewPage_First){
        
        [self.mainScrollView setContentOffset:CGPointMake(WGNumScreenWidth()*1, 0) animated:YES];
        
    }else if(self.currentPage == ZXBlindBoxSelectViewPage_Second){
        //整理勾选
        [self zx_currentCheck];


        if(self.delegate && [self.delegate respondsToSelector:@selector(blindBoxSelectView: SelectorWithSure: CurrentBudgetDisance:QuestList:)]){
            [self.delegate blindBoxSelectView:self SelectorWithSure:self.sureButton CurrentBudgetDisance:self.budgetDisanceDic QuestList:self.questList];
        }
    }
    
    self.currentPage = ZXBlindBoxSelectViewPage_Second;
    
    [self accordingToAction];
}


//取消响应
- (void)cancelAction:(UIButton *)sender{

    //取消
    if (self.currentPage == ZXBlindBoxSelectViewPage_First){
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(blindBoxSelectView: SelectorWithCancel:)]){
            [self.delegate blindBoxSelectView:self SelectorWithCancel:sender];
        }
        
    }else if(self.currentPage == ZXBlindBoxSelectViewPage_Second){
       
        [self.mainScrollView setContentOffset:CGPointMake(WGNumScreenWidth()*0, 0) animated:YES];
    }
    
    self.currentPage = ZXBlindBoxSelectViewPage_First;
    
    [self accordingToAction];
}

//根据当前页执行操作
- (void)accordingToAction{
    
    if (self.currentPage == ZXBlindBoxSelectViewPage_First){
        
        [self.cancelButton setImage:IMAGENAMED(@"close") forState:UIControlStateNormal];
        
    }else if(self.currentPage == ZXBlindBoxSelectViewPage_Second){
        
        [self.cancelButton setImage:IMAGENAMED(@"icon_nav_back") forState:UIControlStateNormal];
        
    }
}


#pragma mark - 懒加载

- (WGBaseTableView *)tableView{
    if (!_tableView){
        _tableView = [[WGBaseTableView alloc] initWithFrame:CGRectZero];
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        //
        [_tableView registerClass:[ZXBlindBoxSelectBudgetCell class] forCellReuseIdentifier:[ZXBlindBoxSelectBudgetCell wg_cellIdentifier]];
        [_tableView registerNib:[UINib nibWithNibName:@"ZXBlindBoxSelectDistanceTimeCell" bundle:nil] forCellReuseIdentifier:[ZXBlindBoxSelectDistanceTimeCell wg_cellIdentifier]];
        [_tableView registerNib:[UINib nibWithNibName:@"ZXBlindBoxSelectActivityCell" bundle:nil] forCellReuseIdentifier:[ZXBlindBoxSelectActivityCell wg_cellIdentifier]];
        [_tableView registerClass:[ZXBlindBoxSelectMapCell class] forCellReuseIdentifier:[ZXBlindBoxSelectMapCell wg_cellIdentifier]];
    }
    return _tableView;
}


- (WGBaseTableView *)secondTableView{
    
    if (!_secondTableView){
        _secondTableView = [[WGBaseTableView alloc] initWithFrame:CGRectZero];
        _secondTableView.backgroundColor = UIColor.clearColor;
        _secondTableView.delegate = self;
        _secondTableView.dataSource = self;
        _secondTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        //
        [_secondTableView registerClass:[ZXBlindBoxSelectBudgetCell class] forCellReuseIdentifier:[ZXBlindBoxSelectBudgetCell wg_cellIdentifier]];
        [_secondTableView registerNib:[UINib nibWithNibName:@"ZXBlindBoxSelectDistanceTimeCell" bundle:nil] forCellReuseIdentifier:[ZXBlindBoxSelectDistanceTimeCell wg_cellIdentifier]];
        [_secondTableView registerNib:[UINib nibWithNibName:@"ZXBlindBoxSelectActivityCell" bundle:nil] forCellReuseIdentifier:[ZXBlindBoxSelectActivityCell wg_cellIdentifier]];
        [_secondTableView registerClass:[ZXBlindBoxSelectMapCell class] forCellReuseIdentifier:[ZXBlindBoxSelectMapCell wg_cellIdentifier]];
    }
    
    return _secondTableView;
}

- (UIButton *)sureButton{
    if (!_sureButton){
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
        [_sureButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_sureButton setTitleColor:WGGrayColor(255) forState:UIControlStateNormal];
        [_sureButton setBackgroundImage:IMAGENAMED(@"button") forState:UIControlStateNormal];
        [_sureButton addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

- (UIButton *)cancelButton{
    if (!_cancelButton){
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setImage:IMAGENAMED(@"close") forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (NSMutableArray *)dataList{
    if (!_dataList){
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}


- (UIScrollView *)mainScrollView{
    
    if(!_mainScrollView){
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.contentSize = CGSizeMake(WGNumScreenWidth() * 2,0);
        _mainScrollView.delegate = self;
        _mainScrollView.backgroundColor = [UIColor clearColor];
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        _mainScrollView.bounces = NO;
        _mainScrollView.scrollEnabled = NO;
    }
    return _mainScrollView;
}

@end

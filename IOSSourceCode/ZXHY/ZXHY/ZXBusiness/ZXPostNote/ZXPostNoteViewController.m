//
//  ZXPostNoteViewController.m
//  ZXHY
//
//  Created by Bern Lin on 2021/12/24.
//

#import "ZXPostNoteViewController.h"
#import "WGCSImageCenter.h"
#import "ZXPostNoteTextView.h"
#import "ZXHomeManager.h"
#import "ZXSearchLocationView.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import "ZXHomeModel.h"
#import <Photos/PHObject.h>


#define TextFieldLimit 24

@interface ZXPostNoteViewController ()
<
UITextFieldDelegate,
UIScrollViewDelegate,
AMapLocationManagerDelegate,
ZXSearchLocationViewDelegate
>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) WGCSImageCenter *imageCenter;
@property (nonatomic, strong) UIView *imageSelectView;
@property (nonatomic, strong) UITextField *titleTextField;
@property (nonatomic, strong) UIView  *oneLineView;


//选中图片数组
@property (nonatomic, strong) NSArray  <UIImage *>*selectedPhotos;

//内容
@property (nonatomic, strong) ZXPostNoteTextView  *contentTextView;
@property (nonatomic, strong) UIView  *twoLineView;

//地点
@property (nonatomic, strong) UIView  *locationView;
@property (nonatomic, strong) UIImageView *locationLogoView;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UIButton  *locationButton;

//定位
@property (nonatomic, strong) AMapLocationManager  *locationManager;
@property(nonatomic,assign) CLLocationCoordinate2D currentCoordinate;
@property (nonatomic, assign) bool  isLocationSucceed;

//选中位置
@property(nonatomic,strong) AMapPOI *selectCoordinatePOI;

@property (nonatomic, strong) WGGeneralSheetController *sheetVc;

//文章id （编辑状态有，写笔记没有）
@property (nonatomic, strong) NSString  *typeId;

@end

@implementation ZXPostNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.wg_mainTitle = @"写笔记";
    
    self.navigationView.delegate = self;
    [self.navigationView wg_setRightBtnWithText:@"保存" textColor:WGRGBColor(248, 110,151) btnTag:1];
    
    [self zx_initSubView];
    
    //开启定位
    [self zx_setAMapLocationManager];
    
    //键盘通知
    [WGNotification addObserver:self selector:@selector(keyboardFrameDidChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}
    

#pragma mark - initSubView
- (void)zx_initSubView{
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, WGNumScreenWidth(), WGNumScreenHeight() - kNavBarHeight)];
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = WGGrayColor(239);
    [self.view addSubview:self.scrollView];
    
    
    self.imageCenter = [[WGCSImageCenter alloc] init];
    UIView *imageSelectView = [self.imageCenter getImageCollectionViewWithFrame:CGRectMake(15, 20, WGNumScreenWidth() - 30, 85.0)];
    imageSelectView.backgroundColor = UIColor.clearColor;
    [self.scrollView addSubview:imageSelectView];
    self.imageSelectView = imageSelectView;
    WEAKSELF
    self.imageCenter.heightChangeBlock = ^(CGFloat heigth) {
        STRONGSELF
        [self changeImageCollectionViewHeight:heigth];
    };
    
    self.imageCenter.imageChangeCallback = ^(NSArray<UIImage *> * _Nullable photos) {
        STRONGSELF
        self.selectedPhotos = photos;
    };
    
    //标题
    self.titleTextField = [self generatorSubViewTextFieldWithFrame:CGRectMake(15, imageSelectView.mj_h + 20, WGNumScreenWidth() - 30, 45) placeholder:@"输入标题"];
    [self.scrollView addSubview:self.titleTextField];
    self.oneLineView = [self zx_setLineViewWithFrame:CGRectMake(self.titleTextField.mj_x, self.titleTextField.mj_h + self.titleTextField.mj_y + 0.5 , WGNumScreenWidth() - 15, 1)];
    [self.scrollView addSubview:self.oneLineView];
    
   
    //正文
    self.contentTextView = [[ZXPostNoteTextView alloc] initWithFrame:CGRectMake(10.5, self.oneLineView.mj_h + self.oneLineView.mj_y + 10,  WGNumScreenWidth() - 30, 185)];
    [self.scrollView addSubview:self.contentTextView];
    self.twoLineView = [self zx_setLineViewWithFrame:CGRectMake(self.titleTextField.mj_x, self.contentTextView.mj_h + self.contentTextView.mj_y + 0.5 , WGNumScreenWidth() - 15, 1)];
    [self.scrollView addSubview:self.twoLineView];
    
    
    //地点
    self.locationView = [[UIView alloc] initWithFrame:CGRectMake(15, self.twoLineView.mj_y + 1 , WGNumScreenWidth() - 15, 45)];
    self.locationView.backgroundColor = UIColor.clearColor;
    
    
    UIImageView *locationLogoView = [UIImageView wg_imageViewWithImageNamed:@"homeLocationGray"];
    locationLogoView.frame = CGRectMake(0, 6.5, 32, 32);
    [self.locationView addSubview:locationLogoView];
    self.locationLogoView = locationLogoView;
    
    UILabel *locationLabel = [UILabel labelWithFont: kFontMedium(15) TextAlignment:NSTextAlignmentLeft TextColor:WGGrayColor(153) TextStr:@"添加地点" NumberOfLines:1];
    locationLabel.frame = CGRectMake(32, 10, self.locationView.mj_w - 40, 25);
    [self.locationView addSubview:locationLabel];
    self.locationLabel = locationLabel;
    
    
    UIButton *locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    locationButton.adjustsImageWhenHighlighted = NO;
    [locationButton addTarget:self action:@selector(locationAction:) forControlEvents:UIControlEventTouchUpInside];
    locationButton.frame = CGRectMake(0, 0,self.locationView.mj_w,  self.locationView.mj_h);
    self.locationButton = locationButton;
    [self.locationView addSubview:locationButton];
    
    UIView *lineView = [self zx_setLineViewWithFrame:CGRectMake(0, 44 , self.locationView.mj_w, 1)];
    [self.locationView addSubview:lineView];
    
    
    [self.scrollView addSubview:self.locationView];
    
   
    self.scrollView.contentSize = CGSizeMake(WGNumScreenWidth(), WGNumScreenHeight());
}


#pragma mark - WGNavigationViewDelegate
- (void)navigationViewRightBtnClick:(WGNavigationView *)navigationView btnTag:(NSInteger)btnTag{
    //保存
    
    [self.view endEditing:YES];
    
    if (btnTag == 1){
        if (!self.titleTextField.text.length){
            [WGUIManager wg_hideHUDWithText:@"标题为空"];
            return;
        }
        
        if (!self.contentTextView.text.length){
            [WGUIManager wg_hideHUDWithText:@"内容为空"];
            return;
        }
        
        if (!self.selectedPhotos.count){
            [WGUIManager wg_hideHUDWithText:@"图片为空"];
            return;
        }
        
        UIButton *saveButton = [self.navigationView wg_getRightBtnWithBtnTag:btnTag];
        saveButton.userInteractionEnabled = NO;
        
        NSString *lng = @"";
        NSString *lat = @"";
        NSString *address = @"";
        NSString *detailaddress = @"";
        NSString *ponit = @"4.5";
        
        if (!([self.selectCoordinatePOI.uid isEqualToString:@"不显示地点"])){
            lng = [NSString stringWithFormat:@"%f",self.selectCoordinatePOI.location.longitude];
            lat = [NSString stringWithFormat:@"%f",self.selectCoordinatePOI.location.latitude];
            address = self.selectCoordinatePOI.name;
            detailaddress = [NSString stringWithFormat:@"%@%@%@",self.selectCoordinatePOI.city,self.selectCoordinatePOI.district,self.selectCoordinatePOI.address];
        }
        
        NSMutableArray *imageList = [NSMutableArray arrayWithArray:self.selectedPhotos];
        
        WEAKSELF;
        [WGUIManager wg_showHUD];
        [ZXHomeManager zx_reqApiInfomationCreateInfoWithTypeId:self.typeId Title:self.titleTextField.text Content:self.contentTextView.text Address:address Lng:lng Lat:lat Detailaddress:detailaddress ImgList:imageList  Point:ponit SuccessBlock:^(NSDictionary * _Nonnull dic) {
                  
            STRONGSELF;
            
            //通知首页刷新
            [WGNotification postNotificationName:ZXNotificationMacro_Home object:nil];
            
            //发布了笔记
            [WGNotification postNotificationName:ZXNotificationMacro_PostOrDeleteNote object:nil];
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
                [WGUIManager wg_hideHUD];
                saveButton.userInteractionEnabled = YES;
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            });
            
            } ErrorBlock:^(NSError * _Nonnull error) {
                saveButton.userInteractionEnabled = YES;
        }];
        
        
    }
}


#pragma mark - Private Method

//开始定位
- (void)zx_setAMapLocationManager{
    
    //判断定位功能是否打开
    if (!self.locationManager) {
        self.locationManager = [[AMapLocationManager alloc] init];
        [self.locationManager setDelegate:self];
        [self.locationManager startUpdatingLocation];
    }
}

//关闭键盘
- (void)dismissKeyBoard:(UITapGestureRecognizer *)gestureRecognizer{
    [self.view endEditing:YES];
}

//图片控制器高度变化
- (void)changeImageCollectionViewHeight:(CGFloat)height{
    
    self.titleTextField.mj_y = self.imageSelectView.mj_y +  self.imageSelectView.mj_h + 20;
    self.oneLineView.mj_y = self.titleTextField.mj_h + self.titleTextField.mj_y + 0.5 ;
    
    self.contentTextView.mj_y = self.oneLineView.mj_h + self.oneLineView.mj_y + 10;
    self.twoLineView.mj_y = self.contentTextView.mj_h + self.contentTextView.mj_y + 0.5 ;
    
    self.locationView.mj_y = self.twoLineView.mj_y + 1 ;
                         
    self.scrollView.contentSize = CGSizeMake(WGNumScreenWidth(),self.scrollView.mj_h + height);
    
}

//UITextField统一初始化
- (UITextField *)generatorSubViewTextFieldWithFrame:(CGRect)frame placeholder:(NSString *)placeholder
{
    UIColor *placeholderColor = WGGrayColor(153);
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.delegate = self;
    textField.font = kFontSemibold(16);
    textField.textColor = WGGrayColor(51);
    textField.clearButtonMode = UITextFieldViewModeAlways;
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:placeholder attributes:
        @{NSForegroundColorAttributeName:placeholderColor,
                     NSFontAttributeName:kFontMedium(16)
             }];
    textField.attributedPlaceholder = attrString;
    
    [textField addTarget:self action:@selector(zx_textFieldEditingLimit:) forControlEvents:(UIControlEventEditingChanged)];
    
    return textField;
}

//线统一初始化
-(UIView *)zx_setLineViewWithFrame:(CGRect)frame{
    
    UIView *lineView = [[UIView alloc] initWithFrame:frame];
    lineView.backgroundColor = WGGrayColor(221);
    return lineView;
}

// UITextField 字数限制
- (void)zx_textFieldEditingLimit:(UITextField *)textField{
    
    // 键盘输入模式
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"]) {
        // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (textField.text.length >= TextFieldLimit) {
                textField.text = [textField.text substringToIndex:TextFieldLimit];
                [WGUIManager wg_hideHUDWithText:@"不能超过24个字哦"];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (textField.text.length >= TextFieldLimit) {
            textField.text = [textField.text substringToIndex:TextFieldLimit];
        }
    }

}


//地点按钮响应
- (void)locationAction:(UIButton *)sender{
    [self.view endEditing:YES];
    
    if (!self.isLocationSucceed){
        [self locationError];
        return;
    }
    
    ZXSearchLocationView *searchLocationView = [[ZXSearchLocationView alloc] initWithFrame:CGRectMake(0, 0, WGNumScreenWidth(), WGNumScreenHeight()) withCurrentCoordinate:self.currentCoordinate];
    searchLocationView.delegate = self;
    self.sheetVc = [WGGeneralSheetController  sheetControllerWithCustomView:searchLocationView];
    [self.sheetVc showToCurrentVc];
}

#pragma mark - ZXSearchLocationViewDelegate
//关闭
- (void)zx_closeSearchLocationView:(ZXSearchLocationView *)locationView{
    [self.sheetVc dissmissSheetVc];
}

//选中的地理位置
- (void)zx_selectSearchLocationView:(ZXSearchLocationView *)locationView AMapPOI:(AMapPOI *)mapPOI{
    
    
    [self.sheetVc dissmissSheetVc];
    self.selectCoordinatePOI = mapPOI;
    
    if ( ([mapPOI.uid isEqualToString:@"不显示地点"])){
        self.locationLogoView.image = IMAGENAMED(@"homeLocationGray");
        self.locationLabel.text = @"添加地点";
        self.locationLabel.textColor = WGGrayColor(153);
    }else{

        self.locationLogoView.image = IMAGENAMED(@"homeLocation");
        self.locationLabel.text = mapPOI.name;
        self.locationLabel.textColor =  WGGrayColor(51);
    }
    
   
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}



#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}


#pragma mark - notification 监听键盘高度变化
- (void)keyboardFrameDidChange:(NSNotification *)notice {
    
    if (self.titleTextField.editing) return;
    
    NSDictionary * userInfo = notice.userInfo;
    NSValue * endFrameValue = [userInfo wg_safeObjectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect endFrame = endFrameValue.CGRectValue;
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect rect= [self.twoLineView convertRect: self.twoLineView.bounds toView:self.view];
        
        if (endFrame.origin.y >= rect.origin.y ){
            return;
        } else {
            [self.scrollView setContentOffset:CGPointMake(0,  self.scrollView.contentOffset.y + (rect.origin.y - endFrame.origin.y)+0) animated:YES];
            
            
        }
       
       
    }];
}


#pragma mark - AMapLocationManagerDelegate （定位）
//定位错误
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error{
    self.isLocationSucceed = NO;
    [self locationError];
}


//成功定位
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{
    
    NSLog(@"定位成功");
    //停止定位
    if (location) {
        //销毁代理
        [self.locationManager setDelegate:nil];
        //停止定位
        [self.locationManager stopUpdatingLocation];
    }
    
    //定位结果(当前经纬度)
    self.isLocationSucceed = YES;
    self.currentCoordinate = location.coordinate;
    
}



//定位错误弹窗
- (void)locationError{
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


//编辑进入
- (void)zx_editNoteWithHomeListModel:(ZXHomeListModel *)listModel{
    
    [self viewDidLoad];
    
    
    self.wg_mainTitle = @"编辑笔记";
    
    //文章id
    self.typeId = listModel.typeId;
    
    //标题
    self.titleTextField.text = listModel.title;
    
    //内容处理
    self.contentTextView.text = listModel.content;
    
    //地点处理
    if (kIsEmptyString(listModel.location.address) || kIsEmptyString(listModel.location.lat) ){
        self.locationLogoView.image = IMAGENAMED(@"homeLocationGray");
        self.locationLabel.text = @"添加地点";
        self.locationLabel.textColor = WGGrayColor(153);
    }else{

        self.locationLogoView.image = IMAGENAMED(@"homeLocation");
        self.locationLabel.text = listModel.location.address;
        self.locationLabel.textColor =  WGGrayColor(51);
        
        self.selectCoordinatePOI.location.longitude = [listModel.location.lng doubleValue];
        self.selectCoordinatePOI.location.latitude = [listModel.location.lat doubleValue];
        self.selectCoordinatePOI.name = listModel.location.address;
    }
    
    
    //处理图片
    NSMutableArray *imgList = [NSMutableArray array];
    for (NSString *str in listModel.bannerlist){
       
        [[UIImageView new] wg_setImageWithURL:[NSURL URLWithString:str] completed:^(UIImage *image, NSError *error, WGImageCacheType cacheType, NSURL *imageURL) {
            [imgList wg_safeAddObject:image];
        }];
        
    }
    self.selectedPhotos = [NSArray arrayWithArray:imgList];
    [self.imageCenter zx_incoming:imgList];
    
}

@end

//
//  ZXSetProfileViewController.m
//  ZXHY
//
//  Created by Bern Lin on 2022/1/4.
//

#import "ZXSetProfileViewController.h"
#import "ZXMineSetManager.h"
#import "ZXMineModel.h"
#import "TZImagePickerController.h"
#import "ZXMineIconSelectView.h"
#import "ZXMineSetAgeSelectView.h"
#import "ZXMineSetSexSelectView.h"



@interface ZXSetProfileViewController ()
<
WGNavigationViewDelegate,
ZXMineIconSelectViewDelegate,
ZXMineSetAgeSelectViewDelegate,
ZXMineSetSexSelectViewDelegate,
TZImagePickerControllerDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>

@property (nonatomic, strong) WGGeneralSheetController  *sheetVc;
@property (nonatomic, strong) ZXMineModel *mineModel;
@property (nonatomic, strong) ZXMineUserProfileModel  *userProfileModel;
@property (nonatomic, strong) UIButton  *iconView;
@property (nonatomic, strong) UIImage *iconImage;
@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UILabel  *ageLabel;
@property (nonatomic, strong) UILabel  *sexLabel;

@end

@implementation ZXSetProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self zx_initializationUI];
    
    // 收键盘
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyBoard:)];
    [self.view addGestureRecognizer:singleTap];
}

#pragma mark - Initialization UI
//初始化UI
- (void)zx_initializationUI{
    
    self.view.backgroundColor = WGGrayColor(239);
    
    self.wg_mainTitle = @"编辑个人资料";
    [self.navigationView wg_setTitleColor:UIColor.blackColor];
    self.navigationView.backgroundColor = [UIColor clearColor];

    self.navigationView.delegate = self;
    [self.navigationView wg_setRightBtnWithText:@"保存" textColor:WGRGBColor(248, 110,151) btnTag:1];
    
    
    self.iconView = [UIButton buttonWithType:UIButtonTypeCustom];
    self.iconView.adjustsImageWhenDisabled = NO;
    self.iconView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconView.layer.cornerRadius = 48;
    self.iconView.layer.masksToBounds = YES;
    [self.iconView addTarget:self action:@selector(iconClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navigationView.mas_bottom).offset(30);
        make.centerX.mas_equalTo(self.view);
        make.width.height.offset(96);
    }];
    [self.iconView wg_setImageWithURL:[NSURL URLWithString:self.userProfileModel.headimg] forState:UIControlStateNormal placeholderImage:nil];
    
    UIImageView *logoView = [UIImageView wg_imageViewWithImageNamed:@"setIconLogo"];
    [self.view addSubview:logoView];
    [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(self.iconView);
        make.width.height.offset(32);
    }];
    
    UIView *whiteView = [UIView new];
    whiteView.backgroundColor = UIColor.whiteColor;
    whiteView.layer.cornerRadius = 12;
    whiteView.layer.masksToBounds = YES;
    [self.view addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconView.mas_bottom).offset(30);
        make.left.mas_equalTo(self.view.mas_left).offset(15);
        make.right.mas_equalTo(self.view.mas_right).offset(-15);
        make.height.offset(135);
    }];
    
    NSArray *titleArr = @[@"昵称",@"年龄",@"性别"];
    for (int i= 0; i<titleArr.count; i++){
        //title
        UILabel *label  = [UILabel labelWithFont:kFontSemibold(16) TextAlignment:NSTextAlignmentLeft TextColor:WGGrayColor(153) TextStr:[titleArr wg_safeObjectAtIndex:i] NumberOfLines:1];
        label.frame = CGRectMake(20, 12.5 + i *(45), 50, 20);
        [whiteView addSubview:label];
        //line
        UIView *lineView = [UIView new];
        lineView.backgroundColor = WGGrayColor(238);
        lineView.frame = CGRectMake(20, i *(45), (WGNumScreenWidth() -30) - 35, 1);
        if (i != 0){
            [whiteView addSubview:lineView];
        }
        
        //
        if (i == 0){
            self.nameTF = [[UITextField alloc] initWithFrame:CGRectZero];
            self.nameTF.clearButtonMode = UITextFieldViewModeAlways;
            self.nameTF.placeholder = self.userProfileModel.nickname;
            self.nameTF.font = kFontSemibold(16);
            [self.nameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            [whiteView addSubview:self.nameTF];
            [self.nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(label.mas_right).offset(40);
                make.right.mas_equalTo(whiteView.mas_right).offset(-15);
                make.centerY.mas_equalTo(label);
                make.height.offset(30);
            }];
        }
        
        else{
            UILabel *infoLabel = [UILabel labelWithFont:kFontSemibold(16) TextAlignment:NSTextAlignmentLeft TextColor:WGGrayColor(51) TextStr:[titleArr wg_safeObjectAtIndex:i] NumberOfLines:1];
            [whiteView addSubview:infoLabel];
            [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(label.mas_right).offset(40);
                make.right.mas_equalTo(whiteView.mas_right).offset(-15);
                make.centerY.mas_equalTo(label);
                make.height.offset(30);
            }];
            
            UIButton *clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
            clickButton.adjustsImageWhenDisabled = NO;
            clickButton.tag = i;
            [clickButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
            [whiteView addSubview:clickButton];
            [clickButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(label);
                make.right.mas_equalTo(whiteView);
                make.centerY.mas_equalTo(label);
                make.height.offset(45);
            }];
            
            if (i == 1){
                self.ageLabel = infoLabel;
                self.ageLabel.text = self.userProfileModel.age;
            }
            
            if (i == 2){
                self.sexLabel = infoLabel;
                if ([self.userProfileModel.sex intValue] == 0){
                    self.sexLabel.text = @"女";
                }else{
                    self.sexLabel.text = @"男";
                }
            }
            
            
        }
        
    }
}

#pragma mark - WGNavigationViewDelegate
- (void)navigationViewRightBtnClick:(WGNavigationView *)navigationView btnTag:(NSInteger)btnTag{
    if (btnTag == 1){
        
        [WGUIManager wg_showHUD];
        
        NSString *sexStr = @"0";
        if ([self.sexLabel.text isEqualToString:@"男"]){
            sexStr = @"1";
        }
        
        
        [[ZXMineSetManager shareNetworkManager] zx_setMineIcon:self.iconImage NickName:self.nameTF.text Age:self.ageLabel.text Sex:sexStr Completion:^(NSString * _Nonnull imageUrl) {
            

            if (self.iconImage){
                self.mineModel.memberinfo.avatar = imageUrl;
                self.userProfileModel.headimg = imageUrl;
            }
           
            if (self.nameTF.text.length > 0 ) {
                self.mineModel.memberinfo.nickname = self.nameTF.text;
                self.userProfileModel.nickname = self.nameTF.text;
            }
            
            self.userProfileModel.age = self.ageLabel.text;
            
            self.userProfileModel.sex = ([self.sexLabel.text isEqualToString:@"男"]) ? @"1" :  @"0";
            
            [WGNotification postNotificationName:ZXNotificationMacro_MineSet object:nil];
            [WGUIManager wg_hideHUDWithText:@"修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    }
}


#pragma mark - Private Method
//数据赋值
- (void)zx_setMineModel:(ZXMineModel *)mineModel UserProfileMdoel:(ZXMineUserProfileModel *)userProfileModel{
    self.mineModel = mineModel;
    self.userProfileModel = userProfileModel;
}

//关闭键盘
- (void)dismissKeyBoard:(UITapGestureRecognizer *)gestureRecognizer{
    [self.view endEditing:YES];
}

//头像
- (void)iconClick{
    ZXMineIconSelectView *view = [[ZXMineIconSelectView alloc] initWithFrame:CGRectMake(0, 0, WGNumScreenWidth(), 200)];
   view.delegate = self;
   self.sheetVc = [WGGeneralSheetController  sheetControllerWithCustomView:view];
   [self.sheetVc showToCurrentVc];
}

//年龄和性别按钮点击
- (void)clickAction:(UIButton *)sender{
    if (sender.tag == 1){
        //年龄
        ZXMineSetAgeSelectView *view = [[ZXMineSetAgeSelectView alloc] initWithFrame:CGRectMake(0, 0, WGNumScreenWidth(), 300)];
        view.delegate = self;
        self.sheetVc = [WGGeneralSheetController  sheetControllerWithCustomView:view];
        [self.sheetVc showToCurrentVc];
        
    } else if (sender.tag == 2){
        //性别
        ZXMineSetSexSelectView *view = [[ZXMineSetSexSelectView alloc] initWithFrame:CGRectMake(0, 0, WGNumScreenWidth(), 300)];
        view.delegate = self;
        self.sheetVc = [WGGeneralSheetController  sheetControllerWithCustomView:view];
        [self.sheetVc showToCurrentVc];
    }
}

//输入框改变响应
- (void)textFieldDidChange:(UITextField *)textField{
   
    //名字长度限制
    if (textField == self.nameTF) {
        [self zx_nameStrLimit:self.nameTF];
    }

}

//名字长度限制
- (void)zx_nameStrLimit:(UITextField *)textField{
    
    // 键盘输入模式
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"]) {
        // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (textField.text.length >= 8) {
                textField.text = [textField.text substringToIndex:8];
                [WGUIManager wg_hideHUDWithText:@"字数不能超过8位"];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (textField.text.length >= 8) {
            textField.text = [textField.text substringToIndex:8];
            [WGUIManager wg_hideHUDWithText:@"字数不能超过8位"];
        }
    }

}

//相机
- (void)pushImagePickerController {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *imagePickerVc = [[UIImagePickerController alloc] init];
        imagePickerVc.sourceType = sourceType;
        imagePickerVc.delegate = self;
        //设置拍照后的图片可被编辑
//        imagePickerVc.allowsEditing = YES;

        [self presentViewController:imagePickerVc animated:YES completion:nil];
        
    } else {
        [WGUIManager wg_hideHUDWithText:@"该设备不支持拍照"];
        WGLog(@"模拟器中无法打开照相机,请在真机中使用");
    }

}

//相册  TZImagePickerControlle (图片选择器)
- (void)pushTZImagePickerController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    
    imagePickerVc.naviBgColor = [UIColor whiteColor];
    imagePickerVc.iconThemeColor = [UIColor wg_colorWithHexString:@"#FF435D"];
    imagePickerVc.oKButtonTitleColorNormal = [UIColor wg_colorWithHexString:@"#FF435D"];
    imagePickerVc.oKButtonTitleColorDisabled = [UIColor wg_colorWithHexString:@"#FF435D"];
    imagePickerVc.photoNumberIconImage =IMAGENAMED(@"icon_select_bgImage.png");
    imagePickerVc.photoOriginSelImage = IMAGENAMED(@"icon_select_bgImage.png");
    imagePickerVc.statusBarStyle = UIStatusBarStyleDefault;
    imagePickerVc.barItemTextColor = [UIColor wg_colorWithHexString:@"#FF435D"];
    imagePickerVc.naviTitleColor = [UIColor wg_colorWithHexString:@"#FF435D"];
    // 设置是否显示图片序号
    imagePickerVc.showSelectedIndex = NO;
    // 是否可以选择视频
    imagePickerVc.allowPickingVideo = NO;
    
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = YES;
    imagePickerVc.needCircleCrop = YES;
    imagePickerVc.cropRect = CGRectMake(0, (WGNumScreenHeight()  -  WGNumScreenWidth()) /2, WGNumScreenWidth(), WGNumScreenWidth());
    
    
    //到这里为止
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


#pragma mark - ZXMineIconSelectViewDelegate (头像选择方式View代理)

//取消 响应
- (void)closeIconSelectViewView:(ZXMineIconSelectView *)tipsView{
    [self.sheetVc dissmissSheetVc];
}

//拍摄 响应
- (void)theShootIconSelectViewView:(ZXMineIconSelectView *)tipsView{
    
    [self.sheetVc dissmisSheetVcAnimated:YES completion:^{
        [self pushImagePickerController];
    }];
}

//相册 响应
- (void)photoAlbumIconSelectViewView:(ZXMineIconSelectView *)tipsView{
    [self.sheetVc dissmisSheetVcAnimated:YES completion:^{
        [self pushTZImagePickerController];
    }];
    
}

#pragma mark - TZImagePickerControllerDelegate（图片浏览器代理）
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    NSLog(@"cancel");
}


- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    
    self.iconImage = [UIImage new];
    if (!kArrayIsEmpty(photos))  self.iconImage = [photos wg_safeObjectAtIndex:0];
    [self.iconView setImage:self.iconImage forState:UIControlStateNormal];
}


#pragma mark - ZXMineSetAgeSelectViewDelegate(年龄选择代理)
//取消 响应
- (void)closeAgeSelectView:(ZXMineSetAgeSelectView *)tipsView{
    [self.sheetVc dissmissSheetVc];
}

//确定 响应
- (void)sureAgeSelectView:(ZXMineSetAgeSelectView *)tipsView DateOfBirth:(NSString *)str{
    [self.sheetVc dissmissSheetVc];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy.MM"];
    //生日
    NSDate *birthDay = [dateFormatter dateFromString:str];
    
    //当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *currentDate = [dateFormatter dateFromString:currentDateStr];
    NSTimeInterval time=[currentDate timeIntervalSinceDate:birthDay];
    int age = ((int)time)/(3600*24*365);    
    self.ageLabel.text = [NSString stringWithFormat:@"%d",age];
}

#pragma mark - ZXMineSetSexSelectViewDelegate(性别选择代理)
//取消 响应
- (void)closeSexSelectView:(ZXMineSetSexSelectView *)sexView{
    [self.sheetVc dissmissSheetVc];
}

//确定 响应
- (void)sureSexSelectView:(ZXMineSetSexSelectView *)sexView SelectStr:(NSString *)str{
    [self.sheetVc dissmissSheetVc];
    self.sexLabel.text = str;
}

@end

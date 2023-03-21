//
//  ZXSetMobileViewController.m
//  ZXHY
//
//  Created by Bern Lin on 2022/1/4.
//

#import "ZXSetMobileViewController.h"
#import "ZXMineSetManager.h"
#import "ZXMineModel.h"
#import "ZXValidationManager.h"
#import "ZXHumanMachineCertificationView.h"

@interface ZXSetMobileViewController ()
<
UITextFieldDelegate,
ZXHumanMachineCertificationViewDelegate
>

@property (nonatomic, strong) ZXMineModel *mineModel;
@property (nonatomic, strong) ZXMineUserProfileModel  *userProfileModel;
@property (nonatomic, strong) ZXHumanMachineCertificationModel *certificationModel;

@property (nonatomic, strong) UILabel  *mobileLabel;
@property (nonatomic, strong) UITextField *phoneNumTF;
@property (nonatomic, strong) UITextField *codeNumTF;
@property (nonatomic, strong) UIButton *getCodeButton;

@end

@implementation ZXSetMobileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self zx_initializationUI];
    
    // 收键盘
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyBoard:)];
    [self.view addGestureRecognizer:singleTap];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self zx_refreshWithTimeBlock];
    
}

#pragma mark - Initialization UI
//初始化UI
- (void)zx_initializationUI{
    
    self.view.backgroundColor = WGGrayColor(239);
    
    self.wg_mainTitle = @"编辑个人资料";
    [self.navigationView wg_setTitleColor:UIColor.blackColor];
    self.navigationView.backgroundColor = [UIColor clearColor];

    self.navigationView.delegate = self;
    [self.navigationView wg_setRightBtnWithText:@"保存" textColor:WGRGBAlpha(248, 110,151, 0.5) btnTag:1];
//     WGRGBColor(248, 110,151) btnTag:1];
    
    
    //原手机号
    UILabel *mobileTitleLabel = [UILabel labelWithFont:kFontMedium(14) TextAlignment:NSTextAlignmentLeft TextColor:WGGrayColor(153) TextStr:@"原手机号" NumberOfLines:1];
    mobileTitleLabel.frame = CGRectMake(20, kNavBarHeight + 20, 100, 20);
    [self.view addSubview:mobileTitleLabel];
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(15, mobileTitleLabel.mj_y + mobileTitleLabel.mj_h + 10, WGNumScreenWidth() - 30, 45)];
    whiteView.backgroundColor = UIColor.whiteColor;
    whiteView.layer.cornerRadius = 12;
    whiteView.layer.masksToBounds = YES;
    [self.view addSubview:whiteView];
    
    self.mobileLabel = [UILabel labelWithFont:kFontSemibold(16) TextAlignment:NSTextAlignmentLeft TextColor:WGGrayColor(153) TextStr:self.userProfileModel.mob NumberOfLines:1];
    self.mobileLabel.frame = CGRectMake(20, 10, whiteView.mj_w - 30, 25);
    [whiteView addSubview:self.mobileLabel];
    
    
    //新手机号
    UILabel *newMobileTitleLabel = [UILabel labelWithFont:kFontMedium(14) TextAlignment:NSTextAlignmentLeft TextColor:WGGrayColor(153) TextStr:@"新手机号" NumberOfLines:1];
    newMobileTitleLabel.frame = CGRectMake(mobileTitleLabel.mj_x, whiteView.mj_h + whiteView.mj_y + 25, mobileTitleLabel.mj_w, 20);
    [self.view addSubview:newMobileTitleLabel];
    
    UIView *newWhiteView = [[UIView alloc] initWithFrame:CGRectMake(15, newMobileTitleLabel.mj_y + mobileTitleLabel.mj_h + 10, WGNumScreenWidth() - 30, 90)];
    newWhiteView.backgroundColor = UIColor.whiteColor;
    newWhiteView.layer.cornerRadius = 12;
    newWhiteView.layer.masksToBounds = YES;
    [self.view addSubview:newWhiteView];
    
    //手机号
    self.phoneNumTF = [[UITextField alloc] initWithFrame:CGRectZero];
    self.phoneNumTF.clearButtonMode = UITextFieldViewModeAlways;
    self.phoneNumTF.placeholder = @"请输入手机号";
    self.phoneNumTF.font = kFontSemibold(16);
    [self.phoneNumTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [newWhiteView addSubview:self.phoneNumTF];
    [self.phoneNumTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(newWhiteView.mas_left).offset(20);
        make.right.mas_equalTo(newWhiteView.mas_right).offset(-10);
        make.top.mas_equalTo(newWhiteView);
        make.height.offset(45);
    }];
    
    //line
    UIView *lineView = [UIView new];
    lineView.backgroundColor = WGGrayColor(238);
    [newWhiteView addSubview:lineView];
    lineView.frame = CGRectMake(20, 45, (WGNumScreenWidth() -30) - 35, 1);
    
    //获取验证码
    self.getCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.getCodeButton.adjustsImageWhenDisabled = NO;
    self.getCodeButton.titleLabel.font = kFontSemibold(14);
    [self.getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.getCodeButton setTitleColor:WGRGBAlpha(255, 89, 159,0.5) forState:UIControlStateNormal];
    [self.getCodeButton addTarget:self action:@selector(getCodeClick) forControlEvents:UIControlEventTouchUpInside];
    [newWhiteView addSubview:self.getCodeButton];
    [self.getCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(newWhiteView.mas_right).offset(-5);
        make.top.mas_equalTo(lineView.mas_bottom);
        make.height.offset(44);
        make.width.offset(100);
    }];
    
    
    //验证码
    self.codeNumTF = [[UITextField alloc] initWithFrame:CGRectZero];
    self.codeNumTF.placeholder = @"验证码";
    self.codeNumTF.font = kFontSemibold(16);
    [self.codeNumTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [newWhiteView addSubview:self.codeNumTF];
    [self.codeNumTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(newWhiteView.mas_left).offset(20);
        make.right.mas_equalTo(self.getCodeButton.mas_left).offset(-10);
        make.top.mas_equalTo(lineView.mas_bottom);
        make.height.offset(45);
    }];
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


//获取验证码
- (void)getCodeClick{
    [self.view endEditing:YES];
    if (self.phoneNumTF.text.length != 11) {
        [WGUIManager wg_hideHUDWithText:@"请输入正确手机号！"];
        return;
    }
    
    ZXHumanMachineCertificationView *view = [[ZXHumanMachineCertificationView alloc] initWithFrame:CGRectMake(0, 0, WGNumScreenWidth(), WGNumScreenHeight())];
    view.delegate = self;
    [self.view addSubview:view];
}


//手机输入框改变响应
- (void)textFieldDidChange:(UITextField *)textField{
   
    if (textField.text.length >= 11 && textField == self.phoneNumTF) {
        textField.text = [textField.text substringToIndex:11];
    }

    if (self.phoneNumTF.text.length == 11 && ![ZXValidationManager shareValidationManager].countDownTimer){
        [self.getCodeButton setTitleColor:WGRGBAlpha(255, 89, 159,1) forState:UIControlStateNormal];
    } else if ([ZXValidationManager shareValidationManager].countDownTimer){
        [self.getCodeButton setTitleColor:WGGrayColor(205) forState:UIControlStateNormal];
    }else{
        [self.getCodeButton setTitleColor:WGRGBAlpha(255, 89, 159,0.5) forState:UIControlStateNormal];
    }
    
    if (self.phoneNumTF.text.length == 11 && self.codeNumTF.text.length >= 5) {
        [self.navigationView wg_setRightBtnWithText:@"保存" textColor:WGRGBAlpha(248, 110,151, 1) btnTag:1];
    }else{
        [self.navigationView wg_setRightBtnWithText:@"保存" textColor:WGRGBAlpha(248, 110,151, 0.5) btnTag:1];
    }
}


// 验证码倒计时
- (void)zx_countDown{
    
    if (![ZXValidationManager shareValidationManager].countDownTimer){
        [[ZXValidationManager shareValidationManager] zx_countDownTimeOut:60];
    }
    
    [self zx_refreshWithTimeBlock];
    
}

//接收到倒计时刷新UI
- (void)zx_refreshWithTimeBlock{
    WEAKSELF;
    [ZXValidationManager shareValidationManager].timeBlock = ^(NSInteger timeout) {
        STRONGSELF;
        NSLog(@"\n\n\nlogin-----%ld\n\n\n",timeout);
        
        if(timeout <= 0){
            self.getCodeButton.userInteractionEnabled = YES;
            [self.getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
            [self.getCodeButton setTitleColor:WGRGBColor(255, 89, 159) forState:UIControlStateNormal];
            [self textFieldDidChange:self.phoneNumTF];

        } else {

            self.getCodeButton.userInteractionEnabled = NO;
            NSString *timerStr = [NSString stringWithFormat:@"重新获取(%ld)",timeout];
            [self.getCodeButton setTitleColor:WGGrayColor(205) forState:UIControlStateNormal];
            [self.getCodeButton setTitle:timerStr forState:UIControlStateNormal];
        }
    };
}

#pragma mark - ZXHumanMachineCertificationViewDelegate
- (void)closeCertificationView:(ZXHumanMachineCertificationView *)certificationView{

}

- (void)successfulCertificationView:(ZXHumanMachineCertificationView *)certificationView withHumanMachineCertificationModel:(ZXHumanMachineCertificationModel *)certificationModel{
    
    self.certificationModel = certificationModel;

    [self zx_reqApiGetSMSCode];
}


#pragma mark - WGNavigationViewDelegate
- (void)navigationViewRightBtnClick:(WGNavigationView *)navigationView btnTag:(NSInteger)btnTag{
    if (btnTag == 1){
        
        if (self.phoneNumTF.text.length != 11) {
            [WGUIManager wg_hideHUDWithText:@"请输入正确手机号！"];
            return;
        }
        if (self.codeNumTF.text.length <= 5) {
            [WGUIManager wg_hideHUDWithText:@"请输入正确验证码！"];
            return;
        }
        
        [self zx_reqApiResetPhoneBySMSCode];
    }
}


#pragma mark - NetworkRequest

//获取验证码
- (void)zx_reqApiGetSMSCode{
    
    self.getCodeButton.userInteractionEnabled = NO;
   
    
    [WGUIManager wg_showHUD];
    
    WEAKSELF;
    [[ZXNetworkManager shareNetworkManager] zx_reqApiGetLoginSMSCodeWithPhoneNum:self.phoneNumTF.text Ticket:self.certificationModel.ticket Randstr:self.certificationModel.randstr Success:^(NSDictionary * _Nonnull resultDic) {
        
        STRONGSELF;
        [WGUIManager wg_hideHUD];
        [self zx_countDown];
        
    } Failure:^(NSError * _Nonnull error) {
        self.getCodeButton.userInteractionEnabled = YES;
    }];
}

- (void)zx_reqApiResetPhoneBySMSCode{

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict wg_safeSetObject:self.phoneNumTF.text forKey:@"phone"];
    [dict wg_safeSetObject:self.codeNumTF.text forKey:@"code"];
    WEAKSELF;
    
    [WGUIManager wg_showHUD];
    
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiResetPhoneBySMSCode Parameter:dict success:^(NSDictionary * _Nonnull resultDic) {
        STRONGSELF;
        [WGUIManager wg_hideHUD];
        //关闭计时器
        [[ZXValidationManager shareValidationManager] zx_closeAndDestroyed];
        

        self.userProfileModel.mob = self.phoneNumTF.text;
        [WGNotification postNotificationName:ZXNotificationMacro_MineSet object:nil];
        [WGUIManager wg_hideHUDWithText:@"修改成功"];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError * _Nonnull error) {
        self.codeNumTF.text = @"";
    }];
    
    
}

@end

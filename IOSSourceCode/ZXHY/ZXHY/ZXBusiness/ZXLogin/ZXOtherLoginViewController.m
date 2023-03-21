//
//  ZXOtherLoginViewController.m
//  ZXHY
//
//  Created by Bern Mac on 8/9/21.
//

#import "ZXOtherLoginViewController.h"
#import "ZXValidationManager.h"

#import "ZXValidationCodeModel.h"
#import "ZXPersonalInformationViewController.h"

#import "ZXHumanMachineCertificationView.h"



@interface ZXOtherLoginViewController ()
<
UITextFieldDelegate,
ZXHumanMachineCertificationViewDelegate
>

@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UITextField *codeNumTF;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (nonatomic, strong) WGGeneralAlertController *alertVc;
@property (nonatomic, strong) ZXHumanMachineCertificationModel *certificationModel;

@end

@implementation ZXOtherLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化XIB
    [self zx_initializationXIB];
    
    // 收键盘
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyBoard:)];
    [self.view addGestureRecognizer:singleTap];
    

}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 
    [self.navigationView wg_setIsBack:NO];
    
    [self zx_refreshWithTimeBlock];
    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}

#pragma mark - Initialization UI
//初始化XIB
- (void)zx_initializationXIB{
    
    self.loginButton.userInteractionEnabled = NO;
    self.loginButton.backgroundColor = WGGrayColor(207);
    [self.loginButton wg_setLayerRoundedCornersWithRadius:25];
    
    
    self.phoneNumTF.delegate = self;
    self.phoneNumTF.clearButtonMode = UITextFieldViewModeAlways;
    [self.phoneNumTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.codeNumTF.delegate = self;
    [self.codeNumTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}




#pragma mark - Private Method

//获取验证码
- (IBAction)getCodeAction:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    if (self.phoneNumTF.text.length != 11) {
        [WGUIManager wg_hideHUDWithText:@"请输入正确手机号！"];
        return;
    }
    
    ZXHumanMachineCertificationView *view = [[ZXHumanMachineCertificationView alloc] initWithFrame:CGRectMake(0, 0, WGNumScreenWidth(), WGNumScreenHeight())];
    view.delegate = self;
    [self.view addSubview:view];
}

- (IBAction)loginAction:(UIButton *)sender {
    [self zx_reqApiLoginBySMSCode:self.codeNumTF.text];
}


//关闭键盘
- (void)dismissKeyBoard:(UITapGestureRecognizer *)gestureRecognizer{
    [self.view endEditing:YES];
}

//手机输入框改变响应
- (void)textFieldDidChange:(UITextField *)textField{
   
    if (textField.text.length >= 11) {
        textField.text = [textField.text substringToIndex:11];
    }
    
    if (self.phoneNumTF.text.length == 11 && self.codeNumTF.text.length > 0) {
        self.loginButton.userInteractionEnabled = YES;
        self.loginButton.backgroundColor = UIColor.clearColor;
        [self.loginButton setBackgroundImage:IMAGENAMED(@"button") forState:UIControlStateNormal];
    }else{
        self.loginButton.userInteractionEnabled = NO;
        self.loginButton.backgroundColor = WGGrayColor(207);
        [self.loginButton setBackgroundImage:IMAGENAMED(@"") forState:UIControlStateNormal];
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


//通过短信验证码 注册或登录
- (void)zx_reqApiLoginBySMSCode:(NSString *)code{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict wg_safeSetObject:self.phoneNumTF.text forKey:@"phone"];
    [dict wg_safeSetObject:code forKey:@"code"];
    
    WEAKSELF;
    
    [WGUIManager wg_showHUD];
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiLoginBySMSCode Parameter:dict success:^(NSDictionary * _Nonnull resultDic) {
        STRONGSELF;
        [WGUIManager wg_hideHUD];
        
        ZXValidationCodeModel *codeModel = [ZXValidationCodeModel wg_objectWithDictionary:resultDic[@"data"]];
        
        
        [ZXPersonalDataManager shareNetworkManager].zx_token = codeModel.token;
        [ZXPersonalDataManager shareNetworkManager].zx_isNew = [NSString stringWithFormat:@"%ld",codeModel.isnew];
        
        [[ZXValidationManager shareValidationManager] zx_closeAndDestroyed];

        
        if (codeModel.isnew){
            NSLog(@"\n是新用户");
            ZXPersonalInformationViewController *vc = [ZXPersonalInformationViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            NSLog(@"\n不是新用户");
            
            [[AppDelegate wg_sharedDelegate] zx_loginAction];
        }
        
    
    } failure:^(NSError * _Nonnull error) {
    }];
}





#pragma mark - ZXHumanMachineCertificationViewDelegate
- (void)closeCertificationView:(ZXHumanMachineCertificationView *)certificationView{
    [self.alertVc dissmisAlertVc];
}

- (void)successfulCertificationView:(ZXHumanMachineCertificationView *)certificationView withHumanMachineCertificationModel:(ZXHumanMachineCertificationModel *)certificationModel{
    
    self.certificationModel = certificationModel;
    
    [self zx_reqApiGetSMSCode];
}




@end

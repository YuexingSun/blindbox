//
//  ZXLoginViewController.m
//  ZXHY
//
//  Created by Bern Mac on 8/24/21.
//

#import "ZXLoginViewController.h"
#import "JVERIFICATIONService.h"
#import "ZXLoginModel.h"
#import "ZXValidationCodeModel.h"
#import "ZXPersonalInformationViewController.h"
#import "ZXOtherLoginViewController.h"

@interface ZXLoginViewController ()

@property (nonatomic, strong) ZXLoginModel *loginModel;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *otherPhoneButton;

@end

@implementation ZXLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self zx_initializationXIB];
    
    [self customWindow];
    
    [self loginClick:nil];

}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    self.navigationView.alpha = 0;
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    self.navigationView.alpha = 1;
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    NSArray * colors = @[WGRGBColor(248, 109, 148),WGRGBColor(237, 86, 88)];
    [self.loginButton wg_backgroundGradientHorizontalColors:colors];
}


#pragma mark - Initialization UI
//初始化XIB
- (void)zx_initializationXIB{
    [self.loginButton wg_setLayerRoundedCornersWithRadius:25];
   
    
}

- (void)customWindow{
    JVUIConfig *config = [[JVUIConfig alloc] init];
    config.navCustom = YES;
    
    config.autoLayout = YES;
    config.modalTransitionStyle =  UIModalTransitionStyleCrossDissolve;
    config.agreementNavReturnImage = [UIImage imageNamed:@"close"];

    //弹框
    config.showWindow = NO;
    

    config.windowBackgroundAlpha = 0.3;
    config.windowCornerRadius = 6;

    config.sloganTextColor = UIColor.clearColor;
//    config.privacyComponents = @[@""];
    
    
    
    CGFloat windowW = WGNumScreenWidth();
    CGFloat windowH = WGNumScreenHeight();
    JVLayoutConstraint *windowConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    JVLayoutConstraint *windowConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];

    JVLayoutConstraint *windowConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:windowW];
    JVLayoutConstraint *windowConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:windowH];
    config.windowConstraints = @[windowConstraintY,windowConstraintH,windowConstraintX,windowConstraintW];
    
    JVLayoutConstraint *windowConstraintW1 = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:480];
    JVLayoutConstraint *windowConstraintH1 = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:250];

    
    config.windowHorizontalConstraints =@[windowConstraintY,windowConstraintH1,windowConstraintX,windowConstraintW1];
    
    //弹窗close按钮
    UIImage *window_close_nor_image = [UIImage imageNamed:@"close_icon"];
    UIImage *window_close_hig_image = [UIImage imageNamed:@"close_icon"];
    if (window_close_nor_image && window_close_hig_image) {
        config.windowCloseBtnImgs = @[window_close_nor_image, window_close_hig_image];
    }
    CGFloat windowCloseBtnWidth = 30;
    CGFloat windowCloseBtnHeight = 30;
    JVLayoutConstraint *windowCloseBtnConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeRight multiplier:1 constant:-5];
    JVLayoutConstraint *windowCloseBtnConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeTop multiplier:1 constant:5];
    JVLayoutConstraint *windowCloseBtnConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:windowCloseBtnWidth];
    JVLayoutConstraint *windowCloseBtnConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:windowCloseBtnHeight];
    config.windowCloseBtnConstraints = @[windowCloseBtnConstraintX,windowCloseBtnConstraintY,windowCloseBtnConstraintW,windowCloseBtnConstraintH];
    
    
    //logo
    config.logoImg = [UIImage imageNamed:@""];
    config.logoHidden = YES;
    CGFloat logoWidth = 105;
    CGFloat logoHeight = 26;
    JVLayoutConstraint *logoConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    JVLayoutConstraint *logoConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeTop multiplier:1 constant:40];
    JVLayoutConstraint *logoConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:logoWidth];
    JVLayoutConstraint *logoConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:logoHeight];
    config.logoConstraints = @[logoConstraintX,logoConstraintY,logoConstraintW,logoConstraintH];
    
    JVLayoutConstraint *logoConstraintLeft = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeLeft multiplier:1 constant:16];
    
    JVLayoutConstraint *logoConstraintTop = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeTop multiplier:1 constant:11];
    
    config.logoHorizontalConstraints = @[logoConstraintLeft,logoConstraintTop,logoConstraintW,logoConstraintH];
    
    
    //号码栏
    config.numberFont = kFontMedium(25);
    JVLayoutConstraint *numberConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    
    JVLayoutConstraint *numberConstraintY = [JVLayoutConstraint constraintWithAttribute: NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeTop multiplier:1 constant:WGNumScreenHeight()/2 - 80];

    JVLayoutConstraint *numberConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:28];
    JVLayoutConstraint *numberConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:WGNumScreenWidth()];

    config.numberConstraints = @[numberConstraintX,numberConstraintY,numberConstraintH,numberConstraintW];
    config.numberHorizontalConstraints = @[numberConstraintX,numberConstraintY,numberConstraintH,numberConstraintW];
    
    
    //slogan展示
    JVLayoutConstraint *sloganConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    JVLayoutConstraint *sloganConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNumber attribute:NSLayoutAttributeBottom   multiplier:1 constant:4];
    JVLayoutConstraint *sloganConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:17];
    JVLayoutConstraint *sloganConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:200];

    config.sloganConstraints = @[sloganConstraintX,sloganConstraintY,sloganConstraintW,sloganConstraintH];
    
    
    
    //登录按钮
    UIImage *login_nor_image = [UIImage imageNamed:@"button"];
    UIImage *login_dis_image = [UIImage imageNamed:@"button"];
    UIImage *login_hig_image = [UIImage imageNamed:@"button"];
    if (login_nor_image && login_dis_image && login_hig_image) {
        config.logBtnImgs = @[login_nor_image, login_dis_image, login_hig_image];
    }
    config.logBtnText = @"本机号码一键登录";
    config.logBtnFont = kFontMedium(16);
    CGFloat loginButtonWidth = WGNumScreenWidth() - 80;
    CGFloat loginButtonHeight = 48;
    
    JVLayoutConstraint *loginConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    
    JVLayoutConstraint *loginConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNumber attribute:NSLayoutAttributeBottom multiplier:1 constant:30];
    
    JVLayoutConstraint *loginConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:loginButtonWidth];
    
    JVLayoutConstraint *loginConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:loginButtonHeight];
    
    JVLayoutConstraint *loginConstraintY1 = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSlogan attribute:NSLayoutAttributeBottom multiplier:1 constant:13];
    config.logBtnConstraints = @[loginConstraintX,loginConstraintY,loginConstraintW,loginConstraintH];
    config.logBtnHorizontalConstraints = @[loginConstraintX,loginConstraintY1,loginConstraintW,loginConstraintH];
    
    
    //勾选框
    config.checkViewHidden = YES;
    
    
    //协议页导航栏背景颜色
    
    UIColor *navTextColor = WGGrayColor(0);
//    WGRGBColor(255, 89, 159);
    UIFont  *navTextFont  = [UIFont wg_boldFontWithSize:17.0f];
    
    config.agreementNavBackgroundColor = UIColor.whiteColor;
    config.agreementNavTextColor = navTextColor;
    config.agreementNavTextFont = navTextFont;
    
    
    //隐私
    config.privacyState = YES;
    config.privacyShowBookSymbol = YES;
    config.privacyTextFontSize = 14;
    config.privacyTextAlignment = NSTextAlignmentCenter;
    config.appPrivacyColor = @[kMainTitleColor,WGRGBColor(255, 89, 159)];
    
    NSAttributedString *agreementNavtext1 = [[NSAttributedString alloc]initWithString:@"服务条款" attributes:@{NSForegroundColorAttributeName:navTextColor,NSFontAttributeName:navTextFont}];;
    NSAttributedString *agreementNavtext2 = [[NSAttributedString alloc]initWithString:@"隐私政策" attributes:@{NSForegroundColorAttributeName:navTextColor,NSFontAttributeName:navTextFont}];;
   
    config.appPrivacys = @[
        @"选择任意方式注册或登录，意味着你同意我们的",//头部文字
        @[@" 和 ",@"服务条款",PrivacyURL,agreementNavtext1],
        @[@" 和 ",@"隐私政策",ServeURL,agreementNavtext2],
        @"。"
    ];
    
    
    JVLayoutConstraint *privacyConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    JVLayoutConstraint *privacyConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemLogin attribute:NSLayoutAttributeBottom multiplier:1 constant:loginButtonHeight + 50];
    JVLayoutConstraint *privacyConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:loginButtonWidth];
    JVLayoutConstraint *privacyConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:80];
   
    config.privacyConstraints = @[privacyConstraintX,privacyConstraintY,privacyConstraintH,privacyConstraintW];
    
    
    
    //loading
    JVLayoutConstraint *loadingConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    JVLayoutConstraint *loadingConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    JVLayoutConstraint *loadingConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:30];
    JVLayoutConstraint *loadingConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:30];
    config.loadingConstraints = @[loadingConstraintX,loadingConstraintY,loadingConstraintW,loadingConstraintH];
    
    
    config.authPageBackgroundImage = IMAGENAMED(@"loginBack");
    
    
    [JVERIFICATIONService customUIWithConfig:config customViews:^(UIView *customAreaView) {
        
        UIImageView *honeImageView = [UIImageView wg_imageViewWithImageNamed:@"loginLogo"];
        [customAreaView addSubview:honeImageView];
        [honeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(customAreaView.mas_top).offset((IS_IPHONE_X_SER)? 120: 100);
            make.width.height.offset((IS_IPHONE_X_SER)? 100: 88);
            make.centerX.mas_equalTo(customAreaView);
        }];
        [honeImageView layoutIfNeeded];
        [honeImageView wg_setBorderWithCornerRadius:8 borderWidth:2 borderColor:WGRGBColor(255, 124, 128) type:UIRectCornerAllCorners];
        
        UILabel *titleLabel = [UILabel labelWithFont:kFontSemibold(18) TextAlignment:NSTextAlignmentCenter TextColor:WGRGBColor(255, 124, 128) TextStr:@"知行盒一" NumberOfLines:1];
       [customAreaView addSubview:titleLabel];
       [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.mas_equalTo(honeImageView.mas_bottom).offset(15);
           make.left.mas_equalTo(customAreaView).offset(40);
           make.right.mas_equalTo(customAreaView.mas_right).offset(-40);
           make.height.offset(25);
       }];
        
//
        UIButton *otherPhoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        otherPhoneButton.titleLabel.font = kFontMedium(16);
        [otherPhoneButton setTitle:@"其他手机号码登录" forState:UIControlStateNormal];
        [otherPhoneButton setTitleColor:WGRGBColor(255, 89, 159) forState:UIControlStateNormal];
        [otherPhoneButton setBackgroundImage:IMAGENAMED(@"ohterButtonBack") forState:UIControlStateNormal];
        [otherPhoneButton addTarget:self action:@selector(otherLogin:) forControlEvents:UIControlEventTouchUpInside];
        [customAreaView addSubview:otherPhoneButton];
        [otherPhoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(customAreaView).offset(48 + 25);
            make.centerX.mas_equalTo(customAreaView);
            make.width.offset(loginButtonWidth);
            make.height.offset(loginButtonHeight);
        }];
        
//        UILabel *label = [UILabel labelWithFont:kFontMedium(14) TextAlignment:NSTextAlignmentCenter TextColor:kMainTitleColor  TextStr:@"选择任意方式注册或登录，意味着你同意我们的 服务条款 和 隐私政策。" NumberOfLines:2];
//        [customAreaView addSubview:label];
//        [label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(otherPhoneButton.mas_bottom).offset(30);
//            make.width.offset(300);
//            make.centerX.mas_equalTo(customAreaView);
//        }];

    }];
    
}

#pragma mark - Private Method

- (IBAction)loginClick:(UIButton *)sender {
    [WGUIManager wg_showHUD];
   

    [JVERIFICATIONService preLogin:5000 completion:^(NSDictionary *result) {
        NSLog(@"\n\n\nresult-----%@",result);
        
        if ([result[@"code"] integerValue] != 7000){
            [AppDelegate wg_sharedDelegate].window.rootViewController = [[WGBaseNavigationController alloc] initWithRootViewController:[[ZXOtherLoginViewController alloc] init]];
            [WGUIManager wg_hideHUD];
        
            return;;
        }
        
        
        [JVERIFICATIONService getAuthorizationWithController:self hide:YES completion:^(NSDictionary *result) {
            
            [WGUIManager wg_hideHUD];
            self.loginModel = [ZXLoginModel wg_objectWithDictionary:result];
            [self zx_reqApiLoginByMob];

        } actionBlock:^(NSInteger type, NSString *content) {
            [WGUIManager wg_hideHUD];

        }];
        
    }];
    
    
}


- (IBAction)otherLogin:(UIButton *)sender {
    
    ZXOtherLoginViewController * vc = [ZXOtherLoginViewController new];
    [[WGUIManager wg_topViewController].navigationController pushViewController:vc animated:YES];
}




#pragma mark - NetworkRequest

//一键登录
- (void)zx_reqApiLoginByMob{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict wg_safeSetObject:self.loginModel.loginToken forKey:@"code"];
    
   
    WEAKSELF;
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiLoginByMob Parameter:dict success:^(NSDictionary * _Nonnull resultDic) {
        STRONGSELF;
        [WGUIManager wg_hideHUD];
        ZXValidationCodeModel *codeModel = [ZXValidationCodeModel wg_objectWithDictionary:resultDic[@"data"]];
        [ZXPersonalDataManager shareNetworkManager].zx_token = codeModel.token;
        [ZXPersonalDataManager shareNetworkManager].zx_isNew = [NSString stringWithFormat:@"%ld",codeModel.isnew];
        
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


@end

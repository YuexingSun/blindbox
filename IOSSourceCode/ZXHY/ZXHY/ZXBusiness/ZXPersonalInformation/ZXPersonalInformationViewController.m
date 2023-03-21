//
//  ZXPersonalInformationViewController.m
//  ZXHY
//
//  Created by Bern Mac on 8/11/21.
//

#import "ZXPersonalInformationViewController.h"
#import "ZXPersonalPreferenceViewController.h"

@interface ZXPersonalInformationViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UILabel *nameTipsLabel;

@property (weak, nonatomic) IBOutlet UITextField *ageTF;

@property (weak, nonatomic) IBOutlet UIView *genderView;
@property (weak, nonatomic) IBOutlet UIButton *manButton;
@property (weak, nonatomic) IBOutlet UIButton *womanButton;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (nonatomic, strong) NSString  *tokenStr;


@end

@implementation ZXPersonalInformationViewController

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
    
    self.navigationView.alpha = 0;
    self.navigationController.navigationBar.hidden  = YES;
    
}


#pragma mark - Initialization UI
//初始化XIB
- (void)zx_initializationXIB{
    
//    self.genderView.layer.cornerRadius = 20;
//    self.genderView.backgroundColor = WGGrayColor(207);
    
    self.nextButton.userInteractionEnabled = NO;
    [self.nextButton setTitleColor:WGGrayColor(187) forState:UIControlStateNormal];
    [self.nextButton wg_setRoundedCornersWithRadius:25];
    

    self.nameTF.tag = 2000;
    self.ageTF.tag = 2001;
    self.nameTF.clearButtonMode = UITextFieldViewModeAlways;
    [self.nameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.ageTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
}


#pragma mark - Private Method


//下一步
- (IBAction)nextAction:(UIButton *)sender {
    
    //提交新用户基本信息
    [self zx_reqApiSubmitNewUserBaseData];
}

- (IBAction)manAction:(UIButton *)sender {
    
    sender.selected =  YES;
    
    if (sender.selected){
        self.womanButton.selected = NO;
        [self textFieldDidChange:self.ageTF];
    }
}

- (IBAction)womanAction:(UIButton *)sender {
    
    sender.selected = YES;
    
    if (sender.selected){
        self.manButton.selected = NO;
        [self textFieldDidChange:self.ageTF];
    }
}


//输入框改变响应
- (void)textFieldDidChange:(UITextField *)textField{
   
    //名字长度限制
    if (textField == self.nameTF) {
        
        [self zx_nameStrLimit:self.nameTF];
    }
    
    
    if (self.ageTF.text.length >= 3) {
        self.ageTF.text = [self.ageTF.text substringToIndex:3];
    }
    
    
    //下一步按钮是否可以点击
    if (self.nameTF.text.length > 0 && self.ageTF.text.length > 0 && (self.manButton.selected || self.womanButton.selected)) {
        self.nextButton.userInteractionEnabled = YES;
        [self.nextButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        NSArray * colors = @[[UIColor wg_colorWithHexString:@"#FF599E"],[UIColor wg_colorWithHexString:@"#FF4545"]];
        [self.nextButton wg_backgroundGradientHorizontalColors:colors];
    }else{
        self.nextButton.userInteractionEnabled = NO;
        [self.nextButton setTitleColor:WGGrayColor(187) forState:UIControlStateNormal];
        NSArray * colors = @[WGGrayColor(243),WGGrayColor(243)];
        [self.nextButton wg_backgroundGradientHorizontalColors:colors];
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
        }
    }
    
    //限制文本提示
    self.nameTipsLabel.hidden = (textField.text.length > 8) ? NO : YES;
   
}



//关闭键盘
- (void)dismissKeyBoard:(UITapGestureRecognizer *)gestureRecognizer{
    [self.view endEditing:YES];
}





#pragma mark - NetworkRequest

//提交新用户基本信息
- (void)zx_reqApiSubmitNewUserBaseData{
    
    self.nextButton.userInteractionEnabled = NO;
    
    NSString *sex = [NSString stringWithFormat:@"%d",self.manButton.selected];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict wg_safeSetObject:self.nameTF.text forKey:@"name"];
    [dict wg_safeSetObject:self.ageTF.text forKey:@"age"];
    [dict wg_safeSetObject:sex forKey:@"sex"];
    
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiSubmitNewUserBaseData Parameter:dict success:^(NSDictionary * _Nonnull resultDic) {
        
        self.nextButton.userInteractionEnabled = YES;
        
        ZXPersonalPreferenceViewController *vc = [ZXPersonalPreferenceViewController new];
        [self.navigationController pushViewController:vc animated:YES];
        
    } failure:^(NSError * _Nonnull error) {
        
        self.nextButton.userInteractionEnabled = YES;
        
    }];
}

@end

//
//  ZXMineSetNickNameViewController.m
//  ZXHY
//
//  Created by Bern Mac on 9/24/21.
//

#import "ZXMineSetNickNameViewController.h"
#import "ZXMineSetManager.h"
#import "ZXMineModel.h"

@interface ZXMineSetNickNameViewController ()
<
WGNavigationViewDelegate
>
@property (nonatomic, strong) ZXMineModel *mineModel;
@property (nonatomic, strong) ZXMineUserProfileModel *userProfileModel;

@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UILabel  *limitLabel;

@end

@implementation ZXMineSetNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self zx_initializationUI];
}

#pragma mark - Initialization UI
//初始化UI
- (void)zx_initializationUI{
    
    self.view.backgroundColor = WGGrayColor(255);
    
    self.wg_mainTitle = @"设置昵称";
    [self.navigationView wg_setTitleColor:UIColor.blackColor];
    self.navigationView.backgroundColor = [UIColor whiteColor];
    self.navigationView.delegate = self;
    [self.navigationView wg_setRightBtnWithText:@"保存" textColor:WGRGBAlpha(0, 0, 0, 0.25) btnTag:3];
    
    self.nameTF = [[UITextField alloc] initWithFrame:CGRectZero];
    self.nameTF.clearButtonMode = UITextFieldViewModeAlways;
    self.nameTF.placeholder = self.userProfileModel.nickname;
    [self.nameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.nameTF];
    [self.nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(15);
        make.right.mas_equalTo(self.view.mas_right).offset(-15);
        make.top.mas_equalTo(self.view.mas_top).offset(kNavBarHeight+45);
        make.height.offset(30);
    }];
    
    UIView *lineVeiw = [[UIView alloc] initWithFrame:CGRectZero];
    lineVeiw.backgroundColor = WGGrayColor(202);
    [self.view addSubview:lineVeiw];
    [lineVeiw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.nameTF);
        make.top.mas_equalTo(self.nameTF.mas_bottom);
        make.height.offset(0.5);
    }];
    
    self.limitLabel = [UILabel labelWithFont:kFont(15) TextAlignment:NSTextAlignmentRight TextColor:WGRGBAlpha(0, 0, 0, 0.45) TextStr:@"0/8" NumberOfLines:1];
    [self.view addSubview:self.limitLabel];
    [self.limitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(lineVeiw);
        make.top.mas_equalTo(lineVeiw.mas_bottom);
        make.height.offset(20);
        make.width.offset(100);
    }];
    
    // 收键盘
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyBoard:)];
    [self.view addGestureRecognizer:singleTap];
    
}


#pragma mark - WGNavigationViewDelegate
- (void)navigationViewRightBtnClick:(WGNavigationView *)navigationView btnTag:(NSInteger)btnTag{
    
    if (btnTag == 3){
        if (self.nameTF.text.length > 0 ) {
            
            [[ZXMineSetManager shareNetworkManager] zx_setMineType:ZXMineSetType_nickName Value:self.nameTF.text Completion:^{
                
                [WGUIManager wg_hideHUDWithText:@"修改成功"];
                self.mineModel.memberinfo.nickname = self.nameTF.text;
                self.userProfileModel.nickname = self.nameTF.text;
                [WGNotification postNotificationName:ZXNotificationMacro_MineSet object:nil];
                [self.navigationController popViewControllerAnimated:YES];
                
            }];
            
            
        }else{
            return;;
        }
       
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


//输入框改变响应
- (void)textFieldDidChange:(UITextField *)textField{
   
    //名字长度限制
    if (textField == self.nameTF) {
        
        [self zx_nameStrLimit:self.nameTF];
        
    }

    //保存按钮是否可以点击
    [self.navigationView wg_setRightBtnWithText:@"保存" textColor:(self.nameTF.text.length > 0) ? WGRGBAlpha(255, 74, 128, 1):WGRGBAlpha(0, 0, 0, 0.25) btnTag:3];
    

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
            self.limitLabel.text = [NSString stringWithFormat:@"%ld/8",textField.text.length];
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

}

@end

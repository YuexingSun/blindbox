//
//  ZXMineSetAboutViewController.m
//  ZXHY
//
//  Created by Bern Mac on 9/27/21.
//

#import "ZXMineSetAboutViewController.h"
#import "ZXWebViewViewController.h"
#import "ZXMineModel.h"
#import<StoreKit/StoreKit.h>

@interface ZXMineSetAboutViewController ()

@property (nonatomic, strong) UILabel  *wechatLabel;

@property (nonatomic, strong) ZXMineModel  *mineModel;
@end

@implementation ZXMineSetAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self zx_initializationUI];
}


#pragma mark - Initialization UI
//初始化UI
- (void)zx_initializationUI{
    
    self.view.backgroundColor = WGGrayColor(239);
    
    self.wg_mainTitle = @"关于我们";
    [self.navigationView wg_setTitleColor:UIColor.blackColor];
    self.navigationView.backgroundColor = [UIColor clearColor];
    self.navigationView.delegate = self;
    
    
//    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, WGNumScreenWidth(), 245)];
//    backView.backgroundColor = UIColor.whiteColor;
//    [self.view addSubview:backView];
//
//    UIImageView *aboutIogo = [UIImageView wg_imageViewWithImageNamed:@"aboutIogo"];
//    [backView addSubview:aboutIogo];
//    [aboutIogo mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(backView);
//        make.top.mas_equalTo(backView).offset(45);
//        make.height.width.offset(110);
//    }];
//
//    //获取版本号
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    NSString *verionStr = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//    NSString *app_Version = [NSString stringWithFormat:@"版本号：%@",verionStr];
//
//    UILabel *versionLabel = [UILabel labelWithFont:kFontMedium(15) TextAlignment:NSTextAlignmentCenter TextColor:WGRGBAlpha(0, 0, 0, 0.75) TextStr:app_Version NumberOfLines:1];
//    [backView addSubview:versionLabel];
//    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(backView.mas_left).offset(15);
//        make.right.mas_equalTo(backView.mas_right).offset(-15);
//        make.top.mas_equalTo(aboutIogo.mas_bottom).offset(12);
//        make.height.offset(20.5);
//    }];
    
    
    
    //服务条框
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(15, kNavBarHeight + 25, WGNumScreenWidth() - 30, 100.5)];
    bottomView.backgroundColor = UIColor.whiteColor;
    bottomView.layer.cornerRadius = 12;
    bottomView.layer.masksToBounds = YES;
    [self.view addSubview:bottomView];
    
    
    UIView *lineVeiw = [[UIView alloc] initWithFrame:CGRectMake(15, 50, bottomView.mj_w - 30, 0.5)];
    lineVeiw.backgroundColor = WGGrayColor(235);
    [bottomView addSubview:lineVeiw];
   
    
    UILabel *privacyLabel = [UILabel labelWithFont:kFontSemibold(16) TextAlignment:NSTextAlignmentLeft TextColor:UIColor.blackColor TextStr:@"服务条款" NumberOfLines:1];
    [bottomView addSubview:privacyLabel];
    [privacyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(bottomView).offset(15);
        make.height.offset(20);
        make.width.offset(100);
    }];
    
    UILabel *updateLabel = [UILabel labelWithFont:kFontSemibold(16) TextAlignment:NSTextAlignmentLeft TextColor:UIColor.blackColor TextStr:@"隐私协议" NumberOfLines:1];
    [bottomView addSubview:updateLabel];
    [updateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(privacyLabel);
        make.top.mas_equalTo(lineVeiw.mas_bottom).offset(15);
        make.height.offset(20);
        make.width.offset(100);
    }];

    
    UIImageView *rightImageView1 = [UIImageView wg_imageViewWithImageNamed:@"arrow_Right"];
    [bottomView addSubview:rightImageView1];
    [rightImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(bottomView.mas_right).offset(-15);
        make.centerY.mas_equalTo(privacyLabel);
        make.height.offset(17);
        make.width.offset(10);
    }];
    
    UIImageView *rightImageView2 = [UIImageView wg_imageViewWithImageNamed:@"arrow_Right"];
    [bottomView addSubview:rightImageView2];
    [rightImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(bottomView.mas_right).offset(-15);
        make.centerY.mas_equalTo(updateLabel);
        make.height.offset(17);
        make.width.offset(10);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.adjustsImageWhenHighlighted = NO;
    button.backgroundColor = UIColor.clearColor;
    button.tag = 1;
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(bottomView);
        make.bottom.mas_equalTo(lineVeiw.mas_top);
    }];
    
    UIButton *buttonTwo = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonTwo.adjustsImageWhenHighlighted = NO;
    buttonTwo.backgroundColor = UIColor.clearColor;
    buttonTwo.tag = 2;
    [buttonTwo addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:buttonTwo];
    [buttonTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(bottomView);
        make.top.mas_equalTo(lineVeiw.mas_bottom);
    }];
    
    
    
    //鼓励一下
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(15, bottomView.mj_h + bottomView.mj_y + 30, WGNumScreenWidth() - 30, 45)];
    whiteView.backgroundColor = UIColor.whiteColor;
    whiteView.layer.cornerRadius = 12;
    whiteView.layer.masksToBounds = YES;
    [self.view addSubview:whiteView];
    
    UILabel *encourageLabel = [UILabel labelWithFont:kFontSemibold(16) TextAlignment:NSTextAlignmentLeft TextColor:UIColor.blackColor TextStr:@"鼓励一下" NumberOfLines:1];
    [whiteView addSubview:encourageLabel];
    [encourageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(whiteView).offset(15);
        make.centerY.mas_equalTo(whiteView);
        make.height.offset(20);
        make.width.offset(100);
    }];
    
    UIImageView *rightImageView3 = [UIImageView wg_imageViewWithImageNamed:@"arrow_Right"];
    [whiteView addSubview:rightImageView3];
    [rightImageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(whiteView.mas_right).offset(-15);
        make.centerY.mas_equalTo(encourageLabel);
        make.height.offset(17);
        make.width.offset(10);
    }];
    
    UIButton *buttonThree = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonThree.adjustsImageWhenHighlighted = NO;
    buttonThree.backgroundColor = UIColor.clearColor;
    buttonThree.tag = 3;
    [buttonThree addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:buttonThree];
    [buttonThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(whiteView);
    }];
    
    
    //微信客服
    UIView *whiteView2 = [[UIView alloc] initWithFrame:CGRectMake(15, whiteView.mj_h + whiteView.mj_y + 30, WGNumScreenWidth() - 30, 45)];
    whiteView2.backgroundColor = UIColor.whiteColor;
    whiteView2.layer.cornerRadius = 12;
    whiteView2.layer.masksToBounds = YES;
    [self.view addSubview:whiteView2];
    
    UILabel *cLabel = [UILabel labelWithFont:kFontSemibold(16) TextAlignment:NSTextAlignmentLeft TextColor:UIColor.blackColor TextStr:@"微信客服" NumberOfLines:1];
    [whiteView2 addSubview:cLabel];
    [cLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(whiteView2).offset(15);
        make.centerY.mas_equalTo(whiteView2);
        make.height.offset(20);
        make.width.offset(80);
    }];
    
    UIImageView *rightImageView4 = [UIImageView wg_imageViewWithImageNamed:@"arrow_Right"];
    [whiteView2 addSubview:rightImageView4];
    [rightImageView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(whiteView2.mas_right).offset(-15);
        make.centerY.mas_equalTo(cLabel);
        make.height.offset(17);
        make.width.offset(10);
    }];
    
    UIButton *buttonFour = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonFour.adjustsImageWhenHighlighted = NO;
    buttonFour.backgroundColor = UIColor.clearColor;
    buttonFour.tag = 4;
    [buttonFour addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView2 addSubview:buttonFour];
    [buttonFour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(whiteView2);
    }];
    
    
   self.wechatLabel = [UILabel labelWithFont:kFontSemibold(16) TextAlignment:NSTextAlignmentRight TextColor:WGGrayColor(153) TextStr:self.mineModel.servicewechat NumberOfLines:1];
    [whiteView2 addSubview:self.wechatLabel];
    [self.wechatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cLabel.mas_right).offset(5);
        make.right.mas_equalTo(rightImageView4.mas_left).offset(-5);
        make.centerY.mas_equalTo(cLabel);
        make.height.offset(20);
    }];
    
}


#pragma mark - Private Method
//按钮响应
- (void)buttonAction:(UIButton *)sender{
    
    NSString *urlSrt = @"";
    NSString *titleSrt = @"";
    
    if (sender.tag == 1){
        urlSrt = (NSString *)ServeURL;
        titleSrt = @"服务条款";
        ZXWebViewViewController *vc = [ZXWebViewViewController new];
        vc.webViewURL = urlSrt;
        vc.webViewTitle = titleSrt;
        [self.navigationController pushViewController: vc animated:YES];
    }
    else if (sender.tag == 2){
        urlSrt = (NSString *)PrivacyURL;
        titleSrt = @"隐私协议";
        ZXWebViewViewController *vc = [ZXWebViewViewController new];
        vc.webViewURL = urlSrt;
        vc.webViewTitle = titleSrt;
        [self.navigationController pushViewController: vc animated:YES];
    }
    
    else if (sender.tag == 3){
        [SKStoreReviewController requestReview];
    }
    
    else if (sender.tag == 4){
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [NSString stringWithFormat:@"%@",self.wechatLabel.text];
        [WGUIManager wg_hideHUDWithText:@"复制成功"];
    }
    
}


//数据赋值
- (void)zx_setMineModel:(ZXMineModel *)mineModel{
    self.mineModel = mineModel;
   
}

@end

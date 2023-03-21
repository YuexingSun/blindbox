//
//  ZXMineSetAgeViewController.m
//  ZXHY
//
//  Created by Bern Mac on 9/28/21.
//

#import "ZXMineSetAgeViewController.h"
#import "ZXMineSetAgeSelectView.h"
#import "ZXMineSetManager.h"



@interface ZXMineSetAgeViewController ()
<ZXMineSetAgeSelectViewDelegate>

@property (nonatomic, strong) WGGeneralSheetController  *sheetVc;

@property (nonatomic, strong)     UILabel *titleLabel;

@end

@implementation ZXMineSetAgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self zx_initializationUI];
    
    [self zx_selectView];
}

#pragma mark - Initialization UI
//初始化UI
- (void)zx_initializationUI{
    
    self.view.backgroundColor = WGGrayColor(255);
    
    self.wg_mainTitle = @"设置年龄";
    [self.navigationView wg_setTitleColor:UIColor.blackColor];
    self.navigationView.backgroundColor = [UIColor whiteColor];
    self.navigationView.delegate = self;
    
   
    UILabel *titleLabel = [UILabel labelWithFont:kFontMedium(18) TextAlignment:NSTextAlignmentLeft TextColor:WGRGBAlpha(0, 0, 0, 0.75) TextStr:@"" NumberOfLines:1];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(15);
        make.right.mas_equalTo(self.view.mas_right).offset(-15);
        make.top.mas_equalTo(self.view).offset(kNavBarHeight + 25);
        make.height.offset(20.5);
    }];
    self.titleLabel = titleLabel;
    
    UIButton *setAgeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [setAgeButton addTarget:self action:@selector(setAgeButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:setAgeButton];
    [setAgeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(titleLabel);
    }];
    
    
    
    
    UIView *lineVeiw = [[UIView alloc] initWithFrame:CGRectZero];
    lineVeiw.backgroundColor = WGGrayColor(202);
    [self.view addSubview:lineVeiw];
    [lineVeiw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(15);
        make.right.mas_equalTo(self.view.mas_right).offset(-15);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(15);
        make.height.offset(0.5);
    }];
    
    
    
}

- (void)setAgeButton:(UIButton *)sender{
    [self zx_selectView];
}

- (void)zx_selectView{
    ZXMineSetAgeSelectView *view = [[ZXMineSetAgeSelectView alloc] initWithFrame:CGRectMake(0, 0, WGNumScreenWidth(), 300)];
    view.delegate = self;
    self.sheetVc = [WGGeneralSheetController  sheetControllerWithCustomView:view];
    [self.sheetVc showToCurrentVc];
}

#pragma mark - ZXMineSetAgeSelectViewDelegate
//取消 响应
- (void)closeAgeSelectView:(ZXMineSetAgeSelectView *)tipsView{
    [self.sheetVc dissmissSheetVc];
}

//确定 响应
- (void)sureAgeSelectView:(ZXMineSetAgeSelectView *)tipsView DateOfBirth:(NSString *)str{
    [self.sheetVc dissmissSheetVc];
    self.titleLabel.text = str;
    
    [[ZXMineSetManager shareNetworkManager] zx_setMineType:ZXMineSetType_Age Value:str Completion:^{
        [WGUIManager wg_hideHUDWithText:@"修改成功"];
    }];
}
@end

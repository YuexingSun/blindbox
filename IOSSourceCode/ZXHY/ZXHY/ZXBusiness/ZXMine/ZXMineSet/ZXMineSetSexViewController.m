//
//  ZXMineSetSexViewController.m
//  ZXHY
//
//  Created by Bern Mac on 9/24/21.
//

#import "ZXMineSetSexViewController.h"
#import "ZXMineSetManager.h"

@interface ZXMineSetSexViewController ()


@property (nonatomic, strong) UIImageView *manSelectImageView;
@property (nonatomic, strong) UIImageView *womanSelectImageView;

@property (nonatomic, strong) UIButton  *manButton;
@property (nonatomic, strong) UIButton  *womanButton;

@end

@implementation ZXMineSetSexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self zx_initializationUI];
}


#pragma mark - Initialization UI
//初始化UI
- (void)zx_initializationUI{
    
    self.view.backgroundColor = WGGrayColor(245);
    
    self.wg_mainTitle = @"性别";
    [self.navigationView wg_setTitleColor:UIColor.blackColor];
    self.navigationView.backgroundColor = [UIColor whiteColor];
    self.navigationView.delegate = self;
    [self.navigationView wg_setRightBtnWithText:@"保存" textColor:WGRGBAlpha(0, 0, 0, 0.25) btnTag:4];

    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavBarHeight + 10, WGNumScreenWidth(), 100.5)];
    backView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:backView];
    
    
    UIView *lineVeiw = [[UIView alloc] initWithFrame:CGRectZero];
    lineVeiw.backgroundColor = WGGrayColor(235);
    [backView addSubview:lineVeiw];
    [lineVeiw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backView).offset(15);
        make.right.mas_equalTo(backView.mas_right).offset(-15);
        make.centerY.mas_equalTo(backView);
        make.height.offset(0.5);
    }];
    
    UILabel *manLabel = [UILabel labelWithFont:kFont(16) TextAlignment:NSTextAlignmentLeft TextColor:UIColor.blackColor TextStr:@"男" NumberOfLines:1];
    UILabel *woManLabel = [UILabel labelWithFont:kFont(16) TextAlignment:NSTextAlignmentLeft TextColor:UIColor.blackColor TextStr:@"女" NumberOfLines:1];
    
    self.manSelectImageView = [UIImageView wg_imageViewWithImageNamed:@"sexSelect"];
    self.manSelectImageView.hidden = YES;
    
    self.womanSelectImageView = [UIImageView wg_imageViewWithImageNamed:@"sexSelect"];
    self.womanSelectImageView.hidden = YES;
    
    [backView addSubview:manLabel];
    [manLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(backView).offset(15);
        make.height.offset(20);
        make.width.offset(100);
    }];
    
    [backView addSubview:woManLabel];
    [woManLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backView).offset(15);
        make.top.mas_equalTo(lineVeiw.mas_bottom).offset(15);
        make.height.offset(20);
        make.width.offset(100);
    }];
    
    [backView addSubview:self.manSelectImageView];
    [self.manSelectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(backView.mas_right).offset(-15);
        make.centerY.mas_equalTo(manLabel);
        make.height.offset(15);
        make.width.offset(20);
    }];
    
    [backView addSubview: self.womanSelectImageView];
    [ self.womanSelectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(backView.mas_right).offset(-15);
        make.centerY.mas_equalTo(woManLabel);
        make.height.offset(15);
        make.width.offset(20);
    }];
    
    self.manButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.manButton.tag = 1;
    [self.manButton addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:self.manButton];
    [self.manButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(backView);
        make.bottom.mas_equalTo(lineVeiw.mas_top);
    }];
    
    self.womanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.womanButton.tag = 2;
    [self.womanButton addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:self.womanButton];
    [self.womanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(backView);
        make.top.mas_equalTo(lineVeiw.mas_bottom);
    }];
    
}

#pragma mark - WGNavigationViewDelegate
- (void)navigationViewRightBtnClick:(WGNavigationView *)navigationView btnTag:(NSInteger)btnTag{
    
    if (btnTag == 4){
        if (!self.manButton.selected && !self.womanButton.selected) return;
        
        NSString *sexStr = (self.manButton.selected) ? @"1": @"0";
        [[ZXMineSetManager shareNetworkManager] zx_setMineType:ZXMineSetType_Sex Value:sexStr Completion:^{
            [WGUIManager wg_hideHUDWithText:@"修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    }

}


#pragma mark - Private Method

//选中响应
- (void)selectAction:(UIButton *)sender{
    sender.selected = YES;
    
    if (self.manButton == sender){
        self.manSelectImageView.hidden = NO;
        self.womanSelectImageView.hidden = YES;
        self.womanButton.selected = NO;
    }
    
    if (self.womanButton == sender){
        self.manSelectImageView.hidden = YES;
        self.womanSelectImageView.hidden = NO;
        self.manButton.selected = NO;
    }
    
    
    [self.navigationView wg_setRightBtnWithText:@"保存" textColor:WGRGBAlpha(255, 74, 128, 1) btnTag:4];
}

@end

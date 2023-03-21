//
//  ZXMineSetNoticeViewController.m
//  ZXHY
//
//  Created by Bern Mac on 9/27/21.
//

#import "ZXMineSetNoticeViewController.h"

@interface ZXMineSetNoticeViewController ()

@end

@implementation ZXMineSetNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self zx_initializationUI];
}


#pragma mark - Initialization UI
//初始化UI
- (void)zx_initializationUI{
    
    self.view.backgroundColor = WGGrayColor(255);
    
    self.wg_mainTitle = @"推送通知设置";
    [self.navigationView wg_setTitleColor:UIColor.blackColor];
    self.navigationView.backgroundColor = [UIColor whiteColor];
    self.navigationView.delegate = self;
    
   
    UILabel *titleLabel = [UILabel labelWithFont:kFont(16) TextAlignment:NSTextAlignmentLeft TextColor:WGRGBAlpha(0, 0, 0, 0.75) TextStr:@"推送通知已开启" NumberOfLines:1];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(15);
        make.top.mas_equalTo(self.view).offset(kNavBarHeight + 25);
        make.height.offset(20.5);
        make.width.offset(120.5);
    }];
    
    
    UISwitch * switchButton = [[UISwitch alloc]init];
    switchButton.on = NO;
    [switchButton addTarget:self
                   action:@selector(switchButtonClicked:)
         forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:switchButton];
    [switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(titleLabel);
        make.right.mas_equalTo(self.view.mas_right).offset(-15);
        make.height.offset(30);
        make.width.offset(50);
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
    
    
    UILabel *infoLabel = [UILabel labelWithFont:kFont(14) TextAlignment:NSTextAlignmentLeft TextColor:WGRGBAlpha(0, 0, 0, 0.5) TextStr:@"允许知行盒一向您发送通知，可及时了解最新活动，行程变化。" NumberOfLines:2];
    [self.view addSubview:infoLabel];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(15);
        make.top.mas_equalTo(lineVeiw.mas_bottom).offset(15);
    }];
}


//按钮切换
- (void)switchButtonClicked:(UISwitch *)sender{
    
}

@end

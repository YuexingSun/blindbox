//
//  ZXMineSetViewController.m
//  ZXHY
//
//  Created by Bern Mac on 9/23/21.
//

#import "ZXMineSetViewController.h"
#import "ZXMineSetManager.h"
#import "TZImagePickerController.h"
#import "ZXMineSetHeaderTableViewCell.h"
#import "ZXMineSetTableViewCell.h"
#import "ZXMineModel.h"
#import <AssetsLibrary/AssetsLibrary.h>

#import "ZXMineSetNickNameViewController.h"
#import "ZXMineSetSexViewController.h"
#import "ZXLogoutTipsView.h"
#import "ZXMineIconSelectView.h"
#import "ZXMineSetNoticeViewController.h"
#import "ZXMineSetAgeViewController.h"
#import "ZXMineSetAboutViewController.h"
#import "ZXSetProfileViewController.h"
#import "ZXSetMobileViewController.h"
#import "ZXPersonalPreferenceViewController.h"


@interface ZXMineSetViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
ZXLogoutTipsViewDelegate,
ZXMineIconSelectViewDelegate,
TZImagePickerControllerDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>


@property (nonatomic, strong) WGBaseTableView   *tableView;
@property (nonatomic, strong) NSMutableArray    *dataList;
@property (nonatomic, strong) ZXMineModel  *mineModel;
@property (nonatomic, strong) ZXMineUserProfileModel  *userProfileModel;

@property (nonatomic, strong) WGGeneralAlertController *alertVc;
@property (nonatomic, strong) WGGeneralSheetController *sheetVc;

@end

@implementation ZXMineSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self zx_initializationUI];
    
    [WGNotification addObserver:self selector:@selector(reloadNoti:) name:ZXNotificationMacro_MineSet object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - Initialization UI
//初始化UI
- (void)zx_initializationUI{
    
    self.view.backgroundColor = WGGrayColor(239);
    
    self.wg_mainTitle = @"设置";
    [self.navigationView wg_setTitleColor:UIColor.blackColor];
    self.navigationView.backgroundColor = [UIColor clearColor];

    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavBarHeight);
        make.bottom.left.right.equalTo(self.view);
    }];
    
}

#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    NSMutableArray *tempArr = [self.dataList wg_safeObjectAtIndex:section];
    return tempArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray *tempArr = [self.dataList wg_safeObjectAtIndex:indexPath.section];
    NSNumber *num = [tempArr wg_safeObjectAtIndex:indexPath.row];
    ZXMineSetType mineSetType = [num integerValue];
    
    if (mineSetType == ZXMineSetType_Icon){
        ZXMineSetHeaderTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:[ZXMineSetHeaderTableViewCell wg_cellIdentifier]];
        [cell zx_setDataWithMineSetType:mineSetType UserProfileModel:self.userProfileModel];
        return cell;
    }
    
    ZXMineSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZXMineSetTableViewCell wg_cellIdentifier]];
    [cell zx_setDataWithMineSetType:mineSetType UserProfileModel:self.userProfileModel];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *tempArr = [self.dataList wg_safeObjectAtIndex:indexPath.section];
    NSNumber *num = [tempArr wg_safeObjectAtIndex:indexPath.row];
    ZXMineSetType mineSetType = [num integerValue];
    switch (mineSetType) {
        case ZXMineSetType_Icon:
            return 95;
        break;
            
        default:
            return 45;
        break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    NSMutableArray *tempArr = [self.dataList wg_safeObjectAtIndex:indexPath.section];
    NSNumber *num = [tempArr wg_safeObjectAtIndex:indexPath.row];
    ZXMineSetType mineSetType = [num integerValue];
    
    switch (mineSetType) {
        case ZXMineSetType_Icon:
        {
            ZXSetProfileViewController *vc = [ZXSetProfileViewController new];
            [vc zx_setMineModel:self.mineModel UserProfileMdoel:self.userProfileModel];
            [self.navigationController pushViewController:vc animated:YES];
        }
        break;
            
        case ZXMineSetType_Interest:
        {
            ZXPersonalPreferenceViewController *vc = [ZXPersonalPreferenceViewController new];
            vc.enterType = 2;
            [self.navigationController pushViewController:vc animated:YES];
        }
        break;
        
        case ZXMineSetType_nickName:
        {
            ZXMineSetNickNameViewController *vc = [ZXMineSetNickNameViewController new];
            [vc zx_setMineModel:self.mineModel UserProfileMdoel:self.userProfileModel];
            [self.navigationController pushViewController:vc animated:YES];
        }
        break;
            
        case ZXMineSetType_Mobile:
        {
            ZXSetMobileViewController *vc = [ZXSetMobileViewController new];
            [vc zx_setMineModel:self.mineModel UserProfileMdoel:self.userProfileModel];
            [self.navigationController pushViewController:vc animated:YES];
        }
        break;
            
        case ZXMineSetType_Age:
        {
            ZXMineSetAgeViewController *vc = [ZXMineSetAgeViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
        break;
            
        case ZXMineSetType_Sex:
        {
            ZXMineSetSexViewController *vc = [ZXMineSetSexViewController new];
//            [vc zx_setMineModel:self.mineModel UserProfileMdoel:self.userProfileModel];
            [self.navigationController pushViewController:vc animated:YES];
        }
        break;
            
        case ZXMineSetType_Hobbies:
        {
            
        }
        break;
            
        case ZXMineSetType_Notice:
        {
//            ZXMineSetNoticeViewController *vc = [ZXMineSetNoticeViewController new];
//            [self.navigationController pushViewController:vc animated:YES];
        }
        break;
            
        case ZXMineSetType_Cancellation:
        {
            
        }
        break;
            
        case ZXMineSetType_About:
        {
            ZXMineSetAboutViewController *vc = [ZXMineSetAboutViewController new];
            [vc zx_setMineModel:self.mineModel];
            [self.navigationController pushViewController:vc animated:YES];
        }
        break;
            
        case ZXMineSetType_Exit:
        {
            ZXLogoutTipsView *view = [[ZXLogoutTipsView alloc] initWithFrame:CGRectMake(0, 0, 300, 130) TipsTitle: @"是否退出账号？" Content:@"" SureButtonTitle:@"退出登录"];
            view.delegate = self;
            self.alertVc = [WGGeneralAlertController alertControllerWithCustomView:view];
            [self.alertVc showToCurrentVc];

        }
        break;
            
        default:
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WGNumScreenWidth(), 40)];
    view.backgroundColor = UIColor.clearColor;
    
    UILabel *titleLabel = [UILabel labelWithFont:kFontMedium(14) TextAlignment:NSTextAlignmentLeft TextColor:WGGrayColor(153) TextStr:@"" NumberOfLines:1];
    titleLabel.frame = CGRectMake(24, 45 - 28, 100, 20);
    [view addSubview:titleLabel];
    if (section == 0){
        titleLabel.text = @"个人资料";
    }else if (section == 2){
        titleLabel.text = @"账号";
    }else if (section == 3){
        titleLabel.text = @"设置";
    }
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0 || section == 2 || section == 3){
        return 45;
    } else if (section == 4){
        return 45;
    }
    
    return 10;
}


#pragma mark - ZXLogoutTipsViewDelegate

//取消退出登陆 响应
- (void)closeTipsView:(ZXLogoutTipsView *)tipsView{
    [self.alertVc dissmisAlertVc];
}

//确定退出登陆 响应
- (void)sureTipsView:(ZXLogoutTipsView *)tipsView{
    [self.alertVc dissmisAlertVc];
    
    //退出登陆
    [[AppDelegate wg_sharedDelegate] zx_logoutActionIsRequest:YES];
    
}





#pragma mark - Private Method

//数据赋值
- (void)zx_setMineModel:(ZXMineModel *)mineModel UserProfileMdoel:(ZXMineUserProfileModel *)userProfileModel{
    self.mineModel = mineModel;
    self.userProfileModel = userProfileModel;
    [self.tableView reloadData];
}

//刷新通知
- (void)reloadNoti:(NSNotification *)notice{
   
    if(notice) {
        [self.tableView reloadData];
    }
    
}


#pragma mark - NetworkRequest


#pragma mark - layz
- (WGBaseTableView *)tableView{
    if (!_tableView){
        _tableView = [[WGBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[ZXMineSetHeaderTableViewCell class] forCellReuseIdentifier:[ZXMineSetHeaderTableViewCell wg_cellIdentifier]];
        [_tableView registerClass:[ZXMineSetTableViewCell class] forCellReuseIdentifier:[ZXMineSetTableViewCell wg_cellIdentifier]];
        
        

    }
    return _tableView;
}


- (NSMutableArray *)dataList{
    if (!_dataList){
        
        NSArray *sectionOneList = @[
            @(ZXMineSetType_Icon),
        ];
        
        NSArray *sectionTwoList = @[
            @(ZXMineSetType_Interest),
        ];
        
        NSArray *sectionThreeList = @[
            @(ZXMineSetType_Mobile),
            @(ZXMineSetType_Wechat)
        ];
        
        
        NSArray *sectionFourList = @[
            @(ZXMineSetType_Notice),
            @(ZXMineSetType_About)
        ];
        
        
        NSArray *sectionFiveList = @[
            @(ZXMineSetType_Exit)
        ];
        
        _dataList = [NSMutableArray arrayWithObjects:sectionOneList,sectionTwoList,sectionThreeList,sectionFourList,sectionFiveList, nil];
    }
    return _dataList;
}


#pragma mark - DEllOC
- (void)dealloc {
    
    NSLog(@"\n🤯--%s--🤯",__func__);
    
    
}


@end

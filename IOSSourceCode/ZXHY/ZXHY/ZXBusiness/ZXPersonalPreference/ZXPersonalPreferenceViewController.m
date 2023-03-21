//
//  ZXPersonalPreferenceViewController.m
//  ZXHY
//
//  Created by Bern Mac on 8/11/21.
//

#import "ZXPersonalPreferenceViewController.h"
#import "ZXPersonalPreferenceTableViewCell.h"
#import "ZXBlindBoxSelectViewModel.h"


@interface ZXPersonalPreferenceViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet WGBaseTableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (nonatomic, strong) NSMutableArray  *dataList;

@end

@implementation ZXPersonalPreferenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self zx_initializationXIB];
    [self zx_initializationTableView];
    [self zx_reqApiGetNewUserFormData];
    
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationView.alpha = 0;
    self.navigationController.navigationBar.hidden  = YES;
    
}


#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    ZXPersonalPreferenceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZXPersonalPreferenceTableViewCell wg_cellIdentifier] forIndexPath:indexPath];
    
    ZXBlindBoxSelectViewModel *model = [self.dataList wg_safeObjectAtIndex:indexPath.row];
    [cell zx_setBlindBoxSelectViewModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

#pragma mark - Initialization UI
//初始化XIB
- (void)zx_initializationXIB{
    [self.doneButton wg_setRoundedCornersWithRadius:25];
    NSArray * colors = @[[UIColor wg_colorWithHexString:@"#FF599E"],[UIColor wg_colorWithHexString:@"#FF4545"]];
    [self.doneButton wg_backgroundGradientHorizontalColors:colors];
}

//初始化tableView
- (void)zx_initializationTableView{
    
    self.tableView .backgroundColor = UIColor.clearColor;
    self.tableView .delegate = self;
    self.tableView .dataSource = self;
    self.tableView .separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 130;
    [self.tableView registerNib:[UINib nibWithNibName:@"ZXPersonalPreferenceTableViewCell" bundle:nil] forCellReuseIdentifier:[ZXPersonalPreferenceTableViewCell wg_cellIdentifier]];

}


#pragma mark - NetworkRequest

//获取新用户表单问题
- (void)zx_reqApiGetNewUserFormData{
  
    WEAKSELF;
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiGetNewUserFormData Parameter:@{} success:^(NSDictionary * _Nonnull resultDic) {
        STRONGSELF;
        
        self.dataList = [ZXBlindBoxSelectViewModel wg_initObjectsWithOtherDictionary:[resultDic wg_safeObjectForKey:@"data"] key:@"queslist"];
        
        for (ZXBlindBoxSelectViewModel *blindBoxSelectViewModel in self.dataList){
            
            for (int i = 0; i < blindBoxSelectViewModel.itemlist.count; i++){
                ZXBlindBoxSelectViewItemlistModel *itemlistModel = [blindBoxSelectViewModel.itemlist wg_safeObjectAtIndex:i];
                if (i == 0){
                    itemlistModel.select = YES;
                }
            }
            
        }
       
        
        self.titleLabel.text = [NSString stringWithFormat:@"拖一下这 %ld 个东西",self.dataList.count];
        NSLog(@"=========%@",self.dataList);
        
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {

        
    }];
}

//提交新用户表单问题
- (void)zx_reqApiSubmitNewUserFormData{
    
    NSMutableArray *questList = [NSMutableArray array];
    
    for (ZXBlindBoxSelectViewModel *selectViewModel in self.dataList){
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        for (ZXBlindBoxSelectViewItemlistModel *itemlistModel in selectViewModel.itemlist){
            if (itemlistModel.select){
                [dict wg_safeSetObject:selectViewModel.ID forKey:@"quesid"];
                [dict wg_safeSetObject:itemlistModel.itemid forKey:@"ans"];
            }
        }
        [questList wg_safeAddObject:dict];
    }

    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict wg_safeSetObject:[questList wg_modelWithJSON] forKey:@"jsonstr"];
  
    WEAKSELF;
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiSubmitNewUserFormData Parameter:dict success:^(NSDictionary * _Nonnull resultDic) {
        STRONGSELF;
        
        if (self.enterType == 2){
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else{
            [[AppDelegate wg_sharedDelegate] zx_loginAction];
        }
        
        
    } failure:^(NSError * _Nonnull error) {

        
    }];
}

#pragma mark - Private Method

//完成按钮响应
- (IBAction)doneAction:(UIButton *)sender {
    
//     初始化对话框
//    UIAlertAction *okAction;
//    UIAlertAction *cancelAction;
//
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"提交后将无法修改\n确认提交吗？" preferredStyle:UIAlertControllerStyleAlert];
//    // 确定注销
//    okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
//        [self zx_reqApiSubmitNewUserFormData];
//    }];
//    cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//
//    [alert addAction:okAction];
//    [alert addAction:cancelAction];
//
//    // 弹出对话框
//    [self presentViewController:alert animated:true completion:nil];
    
    
    
    [self zx_reqApiSubmitNewUserFormData];
    
    [self :@"我是"];
}

- (void):(NSString *)str{
    
}

- (void) :(NSString *)str :(NSMutableSet *)str{
    
}

#pragma mark - lazy
- (NSMutableArray *)dataList{
    if (!_dataList){
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

@end

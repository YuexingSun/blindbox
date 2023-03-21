//
//  ZXBlindBoxConditionSelectView.m
//  ZXHY
//
//  Created by Bern Lin on 2021/11/18.
//

#import "ZXBlindBoxConditionSelectView.h"
#import "ZXBlindBoxSelectViewModel.h"
#import "ZXBlindBoxConditionSelectBudgetCell.h"
#import "ZXBlindBoxConditionSelectNumberCell.h"
#import "ZXBlindBoxConditionSelectMoodCell.h"

@interface ZXBlindBoxConditionSelectView()
<
UITableViewDelegate,
UITableViewDataSource,
ZXBlindBoxConditionSelectBudgetCellDelegate,
ZXBlindBoxConditionSelectNumberCellDelegate
>

//盲盒类型ID
@property (nonatomic, strong) NSString  *typeId;
@property (nonatomic, strong) WGBaseTableView  *tableView;
@property (nonatomic, strong) NSMutableArray         *dataList;
@property (nonatomic, strong) UIButton               *sureButton;
@property (nonatomic, strong) UIButton               *cancelButton;

//问答数组
@property (nonatomic, strong) NSMutableArray  *questList;
//人数选择model
@property (nonatomic, strong) ZXBlindBoxSelectViewItemlistModel *selectViewItemlistModel;

@end


@implementation ZXBlindBoxConditionSelectView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self zx_initializationUI];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.sureButton.layer.shadowColor = WGHEXAlpha(@"FF0000", 0.25).CGColor;
    self.sureButton.layer.shadowOffset = CGSizeMake(0,4);
    self.sureButton.layer.shadowRadius = 3;
    self.sureButton.layer.shadowOpacity = 1;
    self.sureButton.clipsToBounds = NO;
    [self.sureButton wg_setRoundedCornersWithRadius:25];
    NSArray * colors = @[WGRGBColor(255, 81, 206),WGRGBColor(255, 55, 95)];
    [self.sureButton wg_backgroundGradientHorizontalColors:colors];
}

#pragma mark - Initialization UI
- (void)zx_initializationUI{
    
    self.backgroundColor = WGGrayColor(255);
    [self wg_setRoundedCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) radius:16];
    
    //确定按钮
    [self addSubview:self.sureButton];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-40);
        make.left.equalTo(self.mas_centerX).offset(7.5);
        make.right.equalTo(self.mas_right).offset(-30);
        make.height.offset(50);
    }];
    
    
    //取消按钮
    self.cancelButton.layer.cornerRadius = 25;
    [self addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sureButton.mas_centerY);
        make.right.equalTo(self.mas_centerX).offset(-7.5);
        make.left.equalTo(self.mas_left).offset(30);
        make.height.offset(50);
    }];
    
    
    //Tableview
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self.sureButton.mas_top).offset(-5);
    }];
}


#pragma mark - Private Method
//确定响应
- (void)sureAction:(UIButton *)sender{
    
    [self zx_sortingQuestionAndAnswer];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(zx_sureBlindBoxConditionSelectView:QuestionArray:)]){
        [self.delegate zx_sureBlindBoxConditionSelectView:self  QuestionArray:self.questList];
    }
}

//取消响应
- (void)cancelAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(zx_closeBlindBoxConditionSelectView:)]){
        [self.delegate zx_closeBlindBoxConditionSelectView:self];
    }
}

//整理问答
- (void)zx_sortingQuestionAndAnswer{
    
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
    
    self.questList = questList;
    
}


#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZXBlindBoxSelectViewModel *model = [self.dataList wg_safeObjectAtIndex:indexPath.row];
    
    if ([model.type isEqualToString:@"tag"]){
       
        //预算Cell
        if ([model.ID intValue] == 1){
           
            ZXBlindBoxConditionSelectBudgetCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZXBlindBoxConditionSelectBudgetCell wg_cellIdentifier]];
            [cell zx_setBlindBoxSelectViewModel:model];
            return cell;
        }
        
        //人数Cell
        else if ([model.ID intValue] == 4){
            ZXBlindBoxConditionSelectNumberCell  *cell = [tableView dequeueReusableCellWithIdentifier:[ZXBlindBoxConditionSelectNumberCell wg_cellIdentifier]];
            [cell zx_setBlindBoxSelectViewModel:model];
            cell.delegate = self;
            return cell;
        }
        
    }
    
    //心情Cell
    else if ([model.type isEqualToString:@"image"]){
        ZXBlindBoxConditionSelectMoodCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZXBlindBoxConditionSelectMoodCell wg_cellIdentifier] forIndexPath:indexPath];
        [cell zx_setBlindBoxSelectViewModel:model NumberModel:self.selectViewItemlistModel];
        return cell;
    }
    
    
    
    UITableViewCell *cell = [UITableViewCell new];
    cell.backgroundColor = UIColor.clearColor;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZXBlindBoxSelectViewModel *model = [self.dataList wg_safeObjectAtIndex:indexPath.row];
    if ([model.type isEqualToString:@"tag"]){
        if ([model.ID intValue] == 4) return 70;
        if (model.itemlist.count > 3) return 200;
        return 170;
    }
    else if ([model.type isEqualToString:@"image"]){
        return (IS_IPHONE_X_SER) ? 178 : 150;
    }
    return 0.1f;
}


#pragma mark - ZXBlindBoxConditionSelectNumberCellDelegate
//出发选择model
- (void)zx_goSelectItemlistModel:(ZXBlindBoxSelectViewItemlistModel *)selectViewItemlistModel{
    self.selectViewItemlistModel = selectViewItemlistModel;
//    [self.tableView reloadData];
    
    NSInteger row = 0 ;
    for (int i = 0; i< self.dataList.count; i++){
        ZXBlindBoxSelectViewModel *model = [self.dataList wg_safeObjectAtIndex:i];
        if ([model.type isEqualToString:@"image"]){
            row = i;
        }
    }
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];

}

#pragma mark - NetworkRequest
//获取问答数据
- (void)zx_reqApiGetBoxQuesListWithTypeId:(NSString *)typeId{
   
    self.typeId = typeId;
    
    NSDictionary *dict = @{@"typeid":typeId?:@""};
  
    [WGUIManager wg_showHUD];
    
    WEAKSELF;
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiGetBoxQuesList Parameter:dict success:^(NSDictionary * _Nonnull resultDic) {
        STRONGSELF;
        [WGUIManager wg_hideHUD];
        
        ZXBlindBoxSelectViewMainModel *selectViewMainModel = [ZXBlindBoxSelectViewMainModel wg_objectWithDictionary:[resultDic wg_safeObjectForKey:@"data"]];
        
        self.dataList = selectViewMainModel.list.mutableCopy;
        
        //初始化选中值
        for (ZXBlindBoxSelectViewModel *blindBoxSelectViewModel in self.dataList){
            
            for (int i = 0; i < blindBoxSelectViewModel.itemlist.count; i++){
                
                ZXBlindBoxSelectViewItemlistModel *itemlistModel = [blindBoxSelectViewModel.itemlist wg_safeObjectAtIndex:i];
                
                if (itemlistModel.isdefault == 1){
                    itemlistModel.select = YES;
                    blindBoxSelectViewModel.selectIndex = i;
                    
                    //默认选中人数的model
                    if ([blindBoxSelectViewModel.ID intValue] == 4){
                        self.selectViewItemlistModel = itemlistModel;
                    }
                }
               
            }
        }

        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {

        
    }];
}


#pragma mark - layz
- (WGBaseTableView *)tableView{
    if (!_tableView){
        _tableView = [[WGBaseTableView alloc] initWithFrame:CGRectZero];
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.bounces = NO;
        
        [_tableView registerClass:[ZXBlindBoxConditionSelectBudgetCell class] forCellReuseIdentifier:[ZXBlindBoxConditionSelectBudgetCell wg_cellIdentifier]];
        [_tableView registerClass:[ZXBlindBoxConditionSelectNumberCell class] forCellReuseIdentifier:[ZXBlindBoxConditionSelectNumberCell wg_cellIdentifier]];
        [_tableView registerClass:[ZXBlindBoxConditionSelectMoodCell class] forCellReuseIdentifier:[ZXBlindBoxConditionSelectMoodCell wg_cellIdentifier]];
    
    }
    return _tableView;
}

- (UIButton *)sureButton{
    if (!_sureButton){
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton setTitleColor:WGGrayColor(255) forState:UIControlStateNormal];
        [_sureButton addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

- (UIButton *)cancelButton{
    if (!_cancelButton){
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.backgroundColor = WGRGBColor(229, 229, 234);
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:WGGrayColor(153) forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}


@end

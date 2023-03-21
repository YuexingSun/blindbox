//
//  ZXMapNavHelpView.m
//  ZXHY
//
//  Created by Bern Lin on 2021/12/7.
//

#import "ZXMapNavHelpView.h"
#import "ZXOpenResultsModel.h"
#import "ZXMapNavTelephoneTableViewCell.h"
#import "ZXMapNavOtherMapTableViewCell.h"


@interface ZXMapNavHelpView()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) WGBaseTableView  *tableView;
@property (nonatomic, strong) ZXOpenResultsModel *openResultsModel;
@property (nonatomic, strong) NSArray *phoneArr;

@end

@implementation ZXMapNavHelpView


- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        
        [self setLayout];
    }
    return self;
}


- (void)setLayout{
    
    self.backgroundColor =  UIColor.whiteColor;
    [self wg_setRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight radius:16];
    
    //取消
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.backgroundColor = UIColor.whiteColor;
    [cancelButton setImage:IMAGENAMED(@"blackClose") forState:UIControlStateNormal];
    cancelButton.tag = 3;
    [cancelButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.height.width.offset(35);
    }];
    
    //title
    UILabel *titleLabel = [UILabel labelWithFont:kFontSemibold(16) TextAlignment:NSTextAlignmentCenter TextColor:UIColor.blackColor TextStr:@"找不到目的地？" NumberOfLines:1];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.mas_top).offset(25);
        make.height.offset(25);
        make.width.offset(130);
    }];
    
    
    //Tableview
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.top.equalTo(titleLabel.mas_bottom).offset(5);
    }];
    
   
    
    
    UIView *selectView = [UIView new];
    selectView.backgroundColor = UIColor.whiteColor;
    [self addSubview:selectView];
    [selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(cancelButton);
        make.bottom.equalTo(cancelButton.mas_top).offset(-15);
        make.height.offset(100);
//        make.centerX.mas_equalTo(cancelButton);
//        make.width.offset(328);
    }];
    [selectView layoutIfNeeded];
    [selectView wg_setRoundedCornersWithRadius:10];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = WGGrayColor(238);
    [selectView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(selectView);
        make.left.right.mas_equalTo(selectView);
        make.height.offset(1);
    }];
    
//    UIButton *picturesButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    picturesButton.titleLabel.font = kFontMedium(16);
//    [picturesButton setTitle:@"使用第三方导航" forState:UIControlStateNormal];
//    [picturesButton setTitleColor:WGGrayColor(0) forState:UIControlStateNormal];
//    picturesButton.tag = NavHelpType_OtherNav;
//    [picturesButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:picturesButton];
//    [picturesButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.mas_equalTo(selectView);
//        make.bottom.mas_equalTo(lineView);
//    }];
//
//
//    UIButton *photoAlbumButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    photoAlbumButton.titleLabel.font = kFontMedium(16);
//    [photoAlbumButton setTitle:@"拨打店家电话" forState:UIControlStateNormal];
//    [photoAlbumButton setTitleColor:WGGrayColor(0) forState:UIControlStateNormal];
//    photoAlbumButton.tag = NavHelpType_Call;
//    [photoAlbumButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:photoAlbumButton];
//    [photoAlbumButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.left.right.mas_equalTo(selectView);
//        make.top.mas_equalTo(lineView);
//    }];
}


#pragma mark - Private Method
//按钮响应
- (void)buttonAction:(UIButton *)sender{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(zx_navHelpView:NavHelpType:)]){
        [self.delegate zx_navHelpView:self NavHelpType:sender.tag];
    }
    
}

//数据
- (void)zx_openResultsModel:(ZXOpenResultsModel *)openResultsModel{
    self.openResultsModel = openResultsModel;
    if (kObjectIsEmpty(self.openResultsModel)) return;;
    
    
    self.phoneArr = [NSArray array];
    if ([self.openResultsModel.mob containsString: @","]){
        self.phoneArr = [self.openResultsModel.mob componentsSeparatedByString:@","];
    } else if ([self.openResultsModel.mob containsString: @"，"]){
        self.phoneArr = [self.openResultsModel.mob componentsSeparatedByString:@"，"];
    }
    
    if (!self.phoneArr.count){
        self.phoneArr = @[self.openResultsModel.mob];
    }
    
    [self.tableView reloadData];
}


#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0){
        return self.phoneArr.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0){
       
        ZXMapNavTelephoneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZXMapNavTelephoneTableViewCell wg_cellIdentifier]];
        NSString *str = [self.phoneArr wg_safeObjectAtIndex:indexPath.row];
        cell.numberLabel.text = str;
        return cell;
        
    }else{
        ZXMapNavOtherMapTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:[ZXMapNavOtherMapTableViewCell wg_cellIdentifier]];
        [cell zx_openResultsModel:self.openResultsModel];
        return cell;
    }
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        return 55;
    }
    return 95;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0){
       
        NSString *phoneStr = [self.phoneArr wg_safeObjectAtIndex:indexPath.row];
        NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneStr];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
    }else{
        
       
        
        
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WGNumScreenWidth(), 55)];
    headerView.backgroundColor = UIColor.whiteColor;
    
    NSString *srt = (section == 0) ? @"电话联系店家" : @"使用第三方导航";
    
    //标题
    UILabel *titleLabel = [UILabel labelWithFont:kFontMedium(14) TextAlignment:NSTextAlignmentLeft TextColor:WGGrayColor(153) TextStr:srt NumberOfLines:1];
    titleLabel.frame = CGRectMake(32, 25, 150, 20);
    [headerView addSubview:titleLabel];
    
    //分割线
    UIView *lineVeiw = [UIView new];
    lineVeiw.backgroundColor = WGGrayColor(239);
    lineVeiw.frame = CGRectMake(32, 54, WGNumScreenWidth() - 64, 1);
    [headerView addSubview:lineVeiw];
    
    return headerView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 55;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}



#pragma mark - layz
- (WGBaseTableView *)tableView{
    if (!_tableView){
        _tableView = [[WGBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView registerClass:[ZXMapNavTelephoneTableViewCell class] forCellReuseIdentifier:[ZXMapNavTelephoneTableViewCell wg_cellIdentifier]];
        
        [_tableView registerClass:[ZXMapNavOtherMapTableViewCell class] forCellReuseIdentifier:[ZXMapNavOtherMapTableViewCell wg_cellIdentifier]];
        
//        [_tableView registerClass:[ZXBlindBoxConditionSelectMoodCell class] forCellReuseIdentifier:[ZXBlindBoxConditionSelectMoodCell wg_cellIdentifier]];
    
    }
    return _tableView;
}

@end

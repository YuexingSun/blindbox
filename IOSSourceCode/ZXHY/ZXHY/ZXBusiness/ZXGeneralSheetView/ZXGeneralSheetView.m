//
//  ZXGeneralSheetView.m
//  ZXHY
//
//  Created by Bern Lin on 2021/12/24.
//

#import "ZXGeneralSheetView.h"
#import "ZXGeneralSheetTableViewCell.h"



@interface ZXGeneralSheetView ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) WGBaseTableView  *tableView;
@property (nonatomic, strong) NSMutableArray  *dataSourceArray;
@property (nonatomic, strong) NSMutableArray  *dataColorArray;

@end

@implementation ZXGeneralSheetView


- (instancetype)initWithFrame:(CGRect)frame withDataSource:(NSMutableArray <NSString *>*)dataSourceArray DataColor:(NSMutableArray <UIColor *> *)dataColorArray{
    
    if(self = [super initWithFrame:frame]){
        
        self.dataSourceArray = dataSourceArray;
        self.dataColorArray = dataColorArray;
        [self setLayout];
    }
    return self;
}

- (void)setLayout{
    
    self.backgroundColor =  UIColor.clearColor;
    
    UIButton *bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bgButton.frame = CGRectMake(0, 0, WGNumScreenWidth(), WGNumScreenHeight());
    bgButton.backgroundColor = UIColor.clearColor;
    bgButton.tag = CancelTag;
    [bgButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bgButton];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.titleLabel.font = kFontMedium(16);
    cancelButton.backgroundColor = UIColor.whiteColor;
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:WGGrayColor(0) forState:UIControlStateNormal];
    cancelButton.tag = CancelTag;
    [cancelButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.frame = CGRectMake(25, WGNumScreenHeight() - (IS_IPHONE_X_SER ? 35.0f : 15.0f) - 58, WGNumScreenWidth() - 50, 58);
    [cancelButton wg_setRoundedCornersWithRadius:18];
    [self addSubview:cancelButton];
    
    
    CGFloat tableHeight = self.dataSourceArray.count * 58 ;
    if (tableHeight > ( WGNumScreenHeight() - 250)){
        tableHeight = ( WGNumScreenHeight() - 250);
    }
    self.tableView.frame = CGRectMake(25, WGNumScreenHeight() - tableHeight - cancelButton.mj_h  - (IS_IPHONE_X_SER ? 35.0f : 15.0f) - 10 , WGNumScreenWidth() - 50, tableHeight);
    [self addSubview:self.tableView];
    self.tableView.layer.cornerRadius = 18;
    self.tableView.layer.masksToBounds = YES;
    
    
  
    
}


#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZXGeneralSheetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZXGeneralSheetTableViewCell wg_cellIdentifier]];
    
    [cell zx_setLabelText:[self.dataSourceArray wg_safeObjectAtIndex:indexPath.row] TextColor:[self.dataColorArray wg_safeObjectAtIndex:indexPath.row] ];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 58;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.delegate && [self.delegate respondsToSelector:@selector(zx_generalSheetView:Index:)]){
            [self.delegate zx_generalSheetView:self Index:indexPath.row];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}



#pragma mark - Private Method
//按钮响应
- (void)buttonAction:(UIButton *)sender{
    
    //取消
    if (sender.tag == CancelTag){
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(zx_generalSheetView:Index:)]){
                [self.delegate zx_generalSheetView:self Index:sender.tag];
        }
        
    }
}




#pragma mark - layz

- (WGBaseTableView *)tableView{
    if (!_tableView){
        _tableView = [[WGBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = NO;
        
        [_tableView registerClass:[ZXGeneralSheetTableViewCell class] forCellReuseIdentifier:[ZXGeneralSheetTableViewCell wg_cellIdentifier]];

    }
    return _tableView;
}


@end

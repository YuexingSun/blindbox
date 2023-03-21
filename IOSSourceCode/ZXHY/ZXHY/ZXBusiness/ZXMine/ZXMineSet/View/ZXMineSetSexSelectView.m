//
//  ZXMineSetSexSelectView.m
//  ZXHY
//
//  Created by Bern Lin on 2022/1/4.
//

#import "ZXMineSetSexSelectView.h"

@interface ZXMineSetSexSelectView ()
<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray  *dataList;
@property (nonatomic, assign) NSInteger selectRow;
@property (nonatomic, strong) NSString  *selectStr;

@end

@implementation ZXMineSetSexSelectView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setLayout];
    }
    return self;
}

- (void)setLayout{
    
    self.backgroundColor =  UIColor.clearColor;
    
    UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WGNumScreenWidth(), 300)];
    selectView.backgroundColor = UIColor.whiteColor;
    [self addSubview:selectView];
    
    UIView *lineVeiw = [[UIView alloc] initWithFrame:CGRectZero];
    lineVeiw.backgroundColor = WGGrayColor(235);
    [selectView addSubview:lineVeiw];
    [lineVeiw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(selectView);
        make.top.mas_equalTo(selectView.mas_top).offset(50);
        make.height.offset(0.5);
    }];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.titleLabel.font = kFontMedium(16);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:WGGrayColor(179) forState:UIControlStateNormal];
    cancelButton.tag = 1;
    [cancelButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [selectView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(selectView).offset(15);
        make.width.offset(40);
        make.height.offset(20);
    }];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.titleLabel.font = kFontMedium(16);
    [sureButton setTitle:@"完成" forState:UIControlStateNormal];
    [sureButton setTitleColor:WGRGBColor(255,74,128) forState:UIControlStateNormal];
    sureButton.tag = 2;
    [sureButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [selectView addSubview:sureButton];
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(cancelButton);
        make.right.mas_equalTo(selectView.mas_right).offset(-15);
        make.width.offset(40);
        make.height.offset(20);
    }];
    
    UILabel *titleLabel = [UILabel labelWithFont:kFontSemibold(16) TextAlignment:NSTextAlignmentCenter TextColor:WGGrayColor(0) TextStr:@"选择性别" NumberOfLines:1];
    [selectView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(selectView);
        make.centerY.mas_equalTo(cancelButton);
        make.width.offset(100);
        make.height.offset(20);
    }];
    
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 51, WGNumScreenWidth(), 249)];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self addSubview:self.pickerView];
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineVeiw.mas_bottom);
        make.bottom.left.right.mas_equalTo(selectView);
    }];
}


#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dataList.count;
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 52;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.font = [UIFont boldSystemFontOfSize:17];
        pickerLabel.textColor = [UIColor wg_colorWithHexString:@"#3C3C3C"];
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        pickerLabel.text =  [self.dataList wg_safeObjectAtIndex:row];
    }
    
   
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.selectRow  = row;
}


#pragma mark - Private Method
//按钮点击
- (void)buttonAction:(UIButton *)sender{
    //取消
    if (sender.tag == 1){
        if(self.delegate && [self.delegate respondsToSelector:@selector(closeSexSelectView:)]){
            [self.delegate closeSexSelectView:self];
        }
    }
    
    //确定
    else if (sender.tag == 2){
        self.selectStr = [NSString stringWithFormat:@"%@",[self.dataList wg_safeObjectAtIndex:self.selectRow]];
        if(self.delegate && [self.delegate respondsToSelector:@selector(sureSexSelectView:SelectStr:)]){
            [self.delegate sureSexSelectView:self SelectStr:self.selectStr];
        }
    }
}

#pragma mark - layz
- (NSMutableArray *)dataList{
    if (!_dataList){
        _dataList = [NSMutableArray arrayWithObjects:@"男",@"女", nil];
    }
    return _dataList;
}

@end

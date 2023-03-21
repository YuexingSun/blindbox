//
//  ZXMineSetAgeSelectView.m
//  ZXHY
//
//  Created by Bern Mac on 9/28/21.
//

#import "ZXMineSetAgeSelectView.h"

@interface ZXMineSetAgeSelectView ()
<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) NSMutableArray  *yearList;
@property (nonatomic, strong) NSMutableArray  *monthList;

@property (nonatomic, assign) NSInteger yearRow;
@property (nonatomic, assign) NSInteger monthRow;

@property (nonatomic, strong) NSString  *birthStr;

@end

@implementation ZXMineSetAgeSelectView


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
    
    UILabel *titleLabel = [UILabel labelWithFont:kFontSemibold(16) TextAlignment:NSTextAlignmentCenter TextColor:WGGrayColor(0) TextStr:@"出生年月" NumberOfLines:1];
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
    
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

    if (component == 1){
        return self.monthList.count;
    }
    return self.yearList.count;
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 52;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel)
    {
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.font = [UIFont boldSystemFontOfSize:17];
        pickerLabel.textColor = [UIColor wg_colorWithHexString:@"#3C3C3C"];
        pickerLabel.textAlignment = NSTextAlignmentCenter;
    }
    
   
    if (component == 0){
        pickerLabel.text =  [self.yearList wg_safeObjectAtIndex:row];
    }else if (component == 1){
        pickerLabel.text =  [self.monthList wg_safeObjectAtIndex:row];
    }
    
   
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component == 0){
        self.yearRow  = row;
    }else if (component == 1){
        self.monthRow  = row;
    }
}


#pragma mark - 私有方法
- (void)buttonAction:(UIButton *)sender{
    if (sender.tag == 1){
        if(self.delegate && [self.delegate respondsToSelector:@selector(closeAgeSelectView:)]){
            [self.delegate closeAgeSelectView:self];
        }
    }
    
    else if (sender.tag == 2){
        self.birthStr = [NSString stringWithFormat:@"%@.%@",[self.yearList wg_safeObjectAtIndex:self.yearRow],[self.monthList wg_safeObjectAtIndex:self.monthRow]];
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(sureAgeSelectView:DateOfBirth:)]){
            [self.delegate sureAgeSelectView:self DateOfBirth:self.birthStr];
        }
    }
}


#pragma mark - layz
- (NSMutableArray *)yearList{
    if (!_yearList){
        _yearList = [NSMutableArray array];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy"];
        //获取当前年份
        NSString *yearStr = [dateFormatter stringFromDate:[NSDate date]];
        NSInteger year = [yearStr integerValue];
        
        for (NSInteger i = year; i >= 1960; i--){
            [_yearList wg_safeAddObject:[NSString stringWithFormat:@"%ld",i]];
        }
    }
    return _yearList;
}

- (NSMutableArray *)monthList{
    if (!_monthList){
        _monthList = [NSMutableArray array];
        
        //获取当前月份
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM"];
        NSString *monthStr = [dateFormatter stringFromDate:[NSDate date]];
        NSInteger month = [monthStr integerValue];
        NSLog(@"---%ld",month);
        
        for (int i = 0; i < 12; i++){
            [_monthList wg_safeAddObject:[NSString stringWithFormat:@"%d",i+1]];
        }
    }
    return _monthList;
}
@end

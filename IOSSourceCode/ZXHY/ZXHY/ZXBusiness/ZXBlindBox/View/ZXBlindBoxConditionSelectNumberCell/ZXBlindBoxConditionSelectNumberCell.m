//
//  ZXBlindBoxConditionSelectNumberCell.m
//  ZXHY
//
//  Created by Bern Lin on 2021/11/19.
//

#import "ZXBlindBoxConditionSelectNumberCell.h"
#import "ZXBlindBoxSelectViewModel.h"


@interface ZXBlindBoxConditionSelectNumberCell()

@property (nonatomic, strong) ZXBlindBoxSelectViewModel  *blindBoxSelectViewModel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton  *mySelfButton;
@property (nonatomic, strong) UIButton  *togetherButton;
//滑动View
@property (nonatomic, strong) UIView   *sliderView;

@end


@implementation ZXBlindBoxConditionSelectNumberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)wg_cellIdentifier{
    return @"ZXBlindBoxConditionSelectNumberCellID";
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self setupUI];
    }
    return self;
}


//设置UI
- (void)setupUI{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = UIColor.clearColor;
    self.backgroundColor = UIColor.clearColor;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 20, WGNumScreenWidth() - 50, 20)];
    titleLabel.textColor = kMainTitleColor;
    titleLabel.numberOfLines = 1;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.text = @"人均预算";
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    
    UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(WGNumScreenWidth() - 185, 10, 160, 40)];
    selectView.backgroundColor = WGGrayColor(244);
    selectView.layer.cornerRadius = 20;
    selectView.layer.masksToBounds = YES;
    [self.contentView addSubview:selectView];

    
    self.sliderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, selectView.mj_w/2, 40)];
    self.sliderView.backgroundColor = WGRGBColor(255, 82, 128);
    self.sliderView.layer.cornerRadius = 20;
    self.sliderView.layer.masksToBounds = YES;
    [selectView addSubview:self.sliderView];

    
    
    self.mySelfButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.mySelfButton.selected = YES;
    self.mySelfButton.backgroundColor = UIColor.clearColor;
    self.mySelfButton.titleLabel.font = kFontSemibold(16);
    [self.mySelfButton setTitle:@"自己去" forState:UIControlStateNormal];
    [self.mySelfButton setTitle:@"自己去" forState:UIControlStateSelected];
    [self.mySelfButton setTitleColor:WGGrayColor(172) forState:UIControlStateNormal];
    [self.mySelfButton setTitleColor:WGGrayColor(255) forState:UIControlStateSelected];
    [selectView addSubview:self.mySelfButton];
    [self.mySelfButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(selectView);
        make.right.equalTo(selectView.mas_centerX);
    }];
    self.mySelfButton.tag = 80001;
    [self.mySelfButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.togetherButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.togetherButton.backgroundColor = UIColor.clearColor;
    self.togetherButton.titleLabel.font = kFontSemibold(16);
    [self.togetherButton setTitle:@"一起去" forState:UIControlStateNormal];
    [self.togetherButton setTitle:@"一起去" forState:UIControlStateSelected];
    [self.togetherButton setTitleColor:WGGrayColor(172) forState:UIControlStateNormal];
    [self.togetherButton setTitleColor:WGGrayColor(255) forState:UIControlStateSelected];
    [selectView addSubview:self.togetherButton];
    [self.togetherButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(selectView);
        make.left.equalTo(selectView.mas_centerX);
    }];
    self.togetherButton.tag = 80002;
    [self.togetherButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
}



#pragma mark - Private Method
//按钮响应
- (void)buttonAction:(UIButton *)sender{
    
    for ( ZXBlindBoxSelectViewItemlistModel *itemlistModel in self.blindBoxSelectViewModel.itemlist){
        itemlistModel.select =NO;
    }
    ZXBlindBoxSelectViewItemlistModel *model = [self.blindBoxSelectViewModel.itemlist wg_safeObjectAtIndex:sender.tag - 80001];
    model.select = YES;
   
    
    sender.selected = YES;
    
    [UIView animateWithDuration:0.1 animations:^{
        
        if (sender.tag == 80001){
            self.togetherButton.selected = NO;
            self.sliderView.mj_x = 0;
            
        }else if (sender.tag == 80002){
            self.mySelfButton.selected = NO;
            self.sliderView.mj_x = 80;

        }
        
    }];
    
    //
    if (self.delegate && [self.delegate respondsToSelector:@selector(zx_goSelectItemlistModel:)]){
        [self.delegate zx_goSelectItemlistModel:model];
    }
    
}


#pragma mark - Private Method
//数据赋值
- (void)zx_setBlindBoxSelectViewModel:(ZXBlindBoxSelectViewModel *)blindBoxSelectViewModel{
    if (!blindBoxSelectViewModel) return;
    
    self.blindBoxSelectViewModel = blindBoxSelectViewModel;
    
    self.titleLabel.text = self.blindBoxSelectViewModel.title;
    
    if (self.blindBoxSelectViewModel.selectIndex == 0){
        [self buttonAction:self.mySelfButton];
    }else{
        [self buttonAction:self.togetherButton];
    }
}

@end

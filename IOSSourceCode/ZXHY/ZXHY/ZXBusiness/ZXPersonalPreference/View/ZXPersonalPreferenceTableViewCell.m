//
//  ZXPersonalPreferenceTableViewCell.m
//  ZXHY
//
//  Created by Bern Mac on 8/11/21.
//

#import "ZXPersonalPreferenceTableViewCell.h"
#import "ZXBlindBoxSelectViewModel.h"

#define sliderWidth (WGNumScreenWidth() - 100)

@interface ZXPersonalPreferenceTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@property (nonatomic, strong) ZXBlindBoxSelectViewModel  *blindBoxSelectViewModel;

@end

@implementation ZXPersonalPreferenceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = UIColor.clearColor;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)wg_cellIdentifier{
    return @"ZXPersonalPreferenceTableViewCellID";
}


- (void)layoutSubviews{
    [super layoutSubviews];
    [self initXib];
    
}

#pragma mark - Private Method
//初始化xib
- (void)initXib{

    [self.slider setMinimumValue:0];
    [self.slider setMaximumValue:sliderWidth];
    
    [self.slider setMinimumTrackTintColor:WGRGBAlpha(248, 109, 151, 1)];
    [self.slider setMaximumTrackTintColor:WGRGBAlpha(255, 237, 234, 1)];
    [self.slider setThumbImage:IMAGENAMED(@"ThumbImage") forState:UIControlStateNormal];
    [self.slider setThumbImage:IMAGENAMED(@"ThumbImage") forState:UIControlStateHighlighted];
    
    [self.slider setContinuous:NO];
    [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
}

//滑块改变
- (void)sliderValueChanged:(UISlider *)slidedr{
    
    NSInteger count = self.blindBoxSelectViewModel.itemlist.count;
    if (count <= 1){
        count = 1;
    }else{
        count = self.blindBoxSelectViewModel.itemlist.count - 1;
    }
    
   //每格宽度大小
    CGFloat gridWidth = sliderWidth/ count;
    //当前数值
    NSInteger currentNum = round (self.slider.value / gridWidth);

    self.blindBoxSelectViewModel.selectIndex = currentNum;
    [self.slider setValue:currentNum * gridWidth animated:YES];
    
    
    
    //当前距离赋值
    for (ZXBlindBoxSelectViewItemlistModel *itemlistModel in self.blindBoxSelectViewModel.itemlist){
        itemlistModel.select = NO;
    }

    ZXBlindBoxSelectViewItemlistModel *itemlistModel = [self.blindBoxSelectViewModel.itemlist wg_safeObjectAtIndex:currentNum];
    self.valueLabel.text = itemlistModel.itemname;
    itemlistModel.select = YES;
   
    
}


//数据赋值
- (void)zx_setBlindBoxSelectViewModel:(ZXBlindBoxSelectViewModel *)blindBoxSelectViewModel{
    
    if (!blindBoxSelectViewModel) return;
    
    self.blindBoxSelectViewModel = blindBoxSelectViewModel;
    
    self.titleLabel.text = blindBoxSelectViewModel.title;
    
    // 当前文本
    ZXBlindBoxSelectViewItemlistModel *itemlistModel =  [blindBoxSelectViewModel.itemlist wg_safeObjectAtIndex:blindBoxSelectViewModel.selectIndex];
    self.valueLabel.text = itemlistModel.itemname;
    
    [self initXib];
    
    //每格宽度大小
    NSInteger count = self.blindBoxSelectViewModel.itemlist.count;
    if (count <= 1){
        count = 1;
    }else{
        count = self.blindBoxSelectViewModel.itemlist.count - 1;
    }
     CGFloat gridWidth = sliderWidth / count;
     [self.slider setValue:blindBoxSelectViewModel.selectIndex * gridWidth animated:NO];

    

}

@end

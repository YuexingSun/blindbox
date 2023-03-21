//
//  ZXBlindBoxSelectDistanceTimeCell.m
//  ZXHY
//
//  Created by Bern Mac on 8/3/21.
//

#import "ZXBlindBoxSelectDistanceTimeCell.h"
#import "ZXBlindBoxSelectViewModel.h"
#define sliderWidth (WGNumScreenWidth() - 60)

@interface ZXBlindBoxSelectDistanceTimeCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISlider *distanceSlider;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (nonatomic, strong) ZXBlindBoxSelectViewModel  *blindBoxSelectViewModel;

@end

@implementation ZXBlindBoxSelectDistanceTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLabel.textColor = kMainTitleColor;
    self.distanceLabel.textColor = kMainTitleColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)wg_cellIdentifier{
    return @"ZXBlindBoxSelectDistanceTimeCellID";
}



#pragma mark - Private Method
//初始化xib
- (void)initXib{
   
    self.distanceSlider.minimumValue = 0;
    self.distanceSlider.maximumValue = sliderWidth;
    
    [self.distanceSlider setMinimumTrackTintColor:WGRGBAlpha(248, 109, 151, 1)];
    [self.distanceSlider setMaximumTrackTintColor:WGRGBAlpha(255, 237, 234, 1)];
    [self.distanceSlider setThumbImage:IMAGENAMED(@"ThumbImage") forState:UIControlStateNormal];
    [self.distanceSlider setThumbImage:IMAGENAMED(@"ThumbImage") forState:UIControlStateHighlighted];
    
    [self.distanceSlider setContinuous:NO];
    [self.distanceSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
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
    CGFloat gridWidth = sliderWidth / count;
    //当前数值
    NSInteger currentNum = round (self.distanceSlider.value / gridWidth);
    
    [self.distanceSlider setValue:currentNum * gridWidth animated:YES];
    
    
    //当前距离赋值
    for (ZXBlindBoxSelectViewItemlistModel *itemlistModel in self.blindBoxSelectViewModel.itemlist){
        itemlistModel.select = NO;
    }
    ZXBlindBoxSelectViewItemlistModel *itemlistModel = [self.blindBoxSelectViewModel.itemlist wg_safeObjectAtIndex:currentNum];
    self.distanceLabel.text = itemlistModel.itemname;
    itemlistModel.select = YES;
   
    
}

//数据赋值
- (void)zx_setBlindBoxSelectViewModel:(ZXBlindBoxSelectViewModel *)blindBoxSelectViewModel{
    if (!blindBoxSelectViewModel) return;
    
    self.blindBoxSelectViewModel = blindBoxSelectViewModel;
    
    self.titleLabel.text = self.blindBoxSelectViewModel.title;
    
    ZXBlindBoxSelectViewItemlistModel *itemlistModel =  [blindBoxSelectViewModel.itemlist wg_safeObjectAtIndex:blindBoxSelectViewModel.selectIndex];
    self.distanceLabel.text = itemlistModel.itemname;
    
    
    [self initXib];

    
    //每格宽度大小
    NSInteger count = self.blindBoxSelectViewModel.itemlist.count;
    if (count <= 1){
        count = 1;
    }else{
        count = self.blindBoxSelectViewModel.itemlist.count - 1;
    }
     CGFloat gridWidth = sliderWidth / count;
     [self.distanceSlider setValue:blindBoxSelectViewModel.selectIndex * gridWidth animated:NO];
}


@end

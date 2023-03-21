//
//  ZXBlindBoxConditionSelectMoodCollectionViewCell.m
//  ZXHY
//
//  Created by Bern Lin on 2021/11/23.
//

#import "ZXBlindBoxConditionSelectMoodCollectionViewCell.h"
#import "ZXBlindBoxSelectViewModel.h"


@interface ZXBlindBoxConditionSelectMoodCollectionViewCell()

@property (nonatomic, strong) UIImageView  *imageView;
@property (nonatomic,strong) UILabel *brandNameLabel;

@end



@implementation ZXBlindBoxConditionSelectMoodCollectionViewCell

+ (NSString *)wg_cellIdentifier{
    return @"ZXBlindBoxConditionSelectMoodCollectionViewCellID";
}


- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        
        self.backgroundColor = UIColor.clearColor;
        self.contentView.backgroundColor = UIColor.clearColor;
        
        self.imageView = [UIImageView wg_imageViewWithImageNamed:@"mood"];
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self.contentView);
            make.left.mas_equalTo(self.contentView.mas_left).offset(10);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        }];
        

    }
    return self;
}



#pragma mark - Private Method
//数据赋值
- (void)zx_setBlindBoxSelectViewItemlistModel:(ZXBlindBoxSelectViewItemlistModel *)blindBoxSelectViewItemlistModel{
    if (!blindBoxSelectViewItemlistModel) return;
    
    NSString *imageName = @"";
    if (blindBoxSelectViewItemlistModel.select){
        imageName = blindBoxSelectViewItemlistModel.itemselpic;
    } else {
        imageName = blindBoxSelectViewItemlistModel.itempic;
    }
    
    [self.imageView wg_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:IMAGENAMED(@"placeholderImage")];

}
@end

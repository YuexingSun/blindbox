//
//  ZXBlindBoxBootPageCollectionViewCell.m
//  ZXHY
//
//  Created by Bern Lin on 2022/1/11.
//

#import "ZXBlindBoxBootPageCollectionViewCell.h"

@implementation ZXBlindBoxBootPageCollectionViewCell


+ (NSString *)wg_cellIdentifier{
    return @"ZXBlindBoxBootPageCollectionViewCell";
}

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        
        self.backgroundColor = UIColor.clearColor;
        self.contentView.backgroundColor = UIColor.clearColor;
        
        [self zx_initializationUI];
    }
    return self;
}


#pragma mark - Initialization UI
//初始化UI
- (void)zx_initializationUI{
    UIImageView *imageBgView =  [UIImageView wg_imageViewWithImageNamed:@""];
    imageBgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:imageBgView];
    [imageBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
    self.imgView = imageBgView;
    
}
@end

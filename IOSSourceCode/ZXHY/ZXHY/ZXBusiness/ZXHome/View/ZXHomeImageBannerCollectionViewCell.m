//
//  ZXHomeImageBannerCollectionViewCell.m
//  ZXHY
//
//  Created by Bern Lin on 2021/12/21.
//

#import "ZXHomeImageBannerCollectionViewCell.h"

@implementation ZXHomeImageBannerCollectionViewCell

+ (NSString *)wg_cellIdentifier{
    
    return @"ZXHomeImageBannerCollectionViewCell";
}


- (instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        
        [self wg_setupUI];
    }
    return self;
}



- (void)wg_setupUI{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    UIImageView *bgView = [UIImageView wg_imageViewWithImageNamed:@"clearImage"];
    bgView.contentMode = UIViewContentModeScaleAspectFill;
    bgView.clipsToBounds = YES;
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self);
    }];
    self.bgView =  bgView;
}
@end

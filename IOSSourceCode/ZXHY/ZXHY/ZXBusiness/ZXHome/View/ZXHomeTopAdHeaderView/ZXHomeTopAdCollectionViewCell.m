//
//  ZXHomeTopAdCollectionViewCell.m
//  ZXHY
//
//  Created by Bern Lin on 2022/3/8.
//

#import "ZXHomeTopAdCollectionViewCell.h"
#import "ZXHomeAdModel.h"


@interface ZXHomeTopAdCollectionViewCell()

@property (nonatomic,strong) UIImageView *brandImageView;

@end


@implementation ZXHomeTopAdCollectionViewCell

+ (NSString *)wg_cellIdentifier{
    return @"ZXHomeTopAdCollectionViewCell";
}


- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        
        self.backgroundColor = UIColor.clearColor;
        
        [self zx_setUI];
        
        
    }
    return self;
}


- (void)zx_setUI{
    self.brandImageView = [UIImageView wg_imageViewWithImageNamed:@"mo"];
    self.brandImageView.layer.cornerRadius = 8;
    self.brandImageView.layer.masksToBounds = YES;
    self.brandImageView.backgroundColor = UIColor.whiteColor;
    self.brandImageView.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:self.brandImageView];
    [self.brandImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.left.equalTo(self.contentView.mas_left).offset(5);
        make.right.equalTo(self.contentView.mas_right).offset(-5);
    }];
    
}

- (void)zx_typeImage:(UIImage *)img {
    self.brandImageView.image = img;
}



- (void)zx_homeTopAdModel:(ZXHomeAdModel *)adModel{
    [self.brandImageView wg_setImageWithURLString:adModel.pic failImage:IMAGENAMED(@"placeholderImage")];
}



@end

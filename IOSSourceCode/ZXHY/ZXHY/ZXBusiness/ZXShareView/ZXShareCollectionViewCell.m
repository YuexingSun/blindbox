//
//  ZXShareCollectionViewCell.m
//  ZXHY
//
//  Created by Bern Lin on 2021/12/23.
//

#import "ZXShareCollectionViewCell.h"

@interface ZXShareCollectionViewCell()

@property (nonatomic,strong) UIImageView *brandImageView;
@property (nonatomic,strong) UILabel *brandNameLabel;

@end


@implementation ZXShareCollectionViewCell

+ (NSString *)wg_cellIdentifier{
    return @"ZXShareCollectionViewCell";
}

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        
        self.backgroundColor = UIColor.clearColor;
        
        [self zx_setUI];
        
        
    }
    return self;
}

- (void)zx_setUI{
    
    
    self.brandImageView = [UIImageView wg_imageViewWithImageNamed:@"ManSelect"];
    self.brandImageView.backgroundColor = UIColor.clearColor;
    [self.contentView addSubview:self.brandImageView];
    [self.brandImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(15);
        make.centerX.mas_equalTo(self.contentView);
        make.width.height.offset(65);
    }];
    
    
    self.brandNameLabel = [[UILabel alloc]init];
    self.brandNameLabel.font = kFontSemibold(15);
    self.brandNameLabel.numberOfLines = 1;
    self.brandNameLabel.textAlignment = NSTextAlignmentCenter;
    self.brandNameLabel.textColor = WGGrayColor(102);
    [self.contentView addSubview:self.brandNameLabel];
    [self.brandNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.brandImageView.mas_bottom).offset(8);
        make.left.mas_equalTo(self.contentView).offset(5);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-5);
    }];
}


- (void)zx_typeImage:(UIImage *)img typeTitle:(NSString *)titStr{
    
    self.brandImageView.image = img;
    self.brandNameLabel.text = titStr;
}

@end

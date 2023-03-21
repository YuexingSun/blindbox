//
//  ZXSearchCollectionViewCell.m
//  ZXHY
//
//  Created by Bern Lin on 2022/1/5.
//

#import "ZXSearchCollectionViewCell.h"

@interface ZXSearchCollectionViewCell()

@property (nonatomic,strong) UIImageView *brandImageView;
@property (nonatomic,strong) UILabel *brandNameLabel;

@end

@implementation ZXSearchCollectionViewCell


+ (NSString *)wg_cellIdentifier{
    return @"ZXSearchCollectionViewCell";
}


- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        
        self.backgroundColor = UIColor.clearColor;
        
        [self zx_setUI];
        
        
    }
    return self;
}

- (void)zx_setUI{
    
    self.backgroundColor = UIColor.clearColor;
    self.contentView.backgroundColor = UIColor.clearColor;
    
    
    self.brandImageView = [UIImageView wg_imageViewWithImageNamed:@"ManSelect"];
    self.brandImageView.backgroundColor = UIColor.clearColor;
    self.brandImageView.layer.cornerRadius = 8;
    self.brandImageView.layer.masksToBounds = YES;
    self.brandImageView.frame = CGRectMake(5, 15, self.frame.size.width - 10, 205);
    [self.contentView addSubview:self.brandImageView];
    [self.brandImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(15);
        make.left.mas_equalTo(self.contentView).offset(15);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-50);
    }];
    
    self.brandNameLabel = [[UILabel alloc]init];
    self.brandNameLabel.font = kFontSemibold(14);
    self.brandNameLabel.numberOfLines = 2;
    self.brandNameLabel.textAlignment = NSTextAlignmentLeft;
    self.brandNameLabel.textColor = WGGrayColor(51);
    [self.contentView addSubview:self.brandNameLabel];
    [self.brandNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.brandImageView.mas_bottom).offset(8);
        make.left.mas_equalTo(self.contentView).offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
//        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-8);
//        make.height.offset(45);
    }];
}

- (void)zx_typeImage:(UIImage *)img typeTitle:(NSString *)titStr{
    
    self.brandImageView.image = img;
    self.brandNameLabel.text = titStr;
}


@end

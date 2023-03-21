//
//  ZXBlindBoxSelectActivityCollectionViewCell.m
//  ZXHY
//
//  Created by Bern Mac on 8/24/21.
//

#import "ZXBlindBoxSelectActivityCollectionViewCell.h"
#import "ZXBlindBoxSelectViewModel.h"


@interface ZXBlindBoxSelectActivityCollectionViewCell()

@property (nonatomic, strong) UIImageView  *imageView;
@property (nonatomic,strong) UILabel *brandNameLabel;

@end

@implementation ZXBlindBoxSelectActivityCollectionViewCell

+ (NSString *)wg_cellIdentifier{
    return @"ZXBlindBoxSelectActivityCollectionViewCellID";
}


- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        
        self.backgroundColor = UIColor.clearColor;
        self.contentView.backgroundColor = UIColor.clearColor;
        
        self.imageView = [UIImageView wg_imageViewWithImageNamed:@"BoxBackground"];
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self.contentView);
            make.top.mas_equalTo(self.contentView).offset(10);
//            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-50);
            
        }];
        
        
//        self.brandNameLabel = [[UILabel alloc]init];
//        self.brandNameLabel.font = kFontBold(14);
//        self.brandNameLabel.numberOfLines = 2;
//        self.brandNameLabel.textAlignment = NSTextAlignmentCenter;
//        self.brandNameLabel.textColor = kMainTitleColor;
//        [self.contentView addSubview:self.brandNameLabel];
//        [self.brandNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.imageView.mas_bottom).offset(10);
//            make.left.mas_equalTo(self.imageView.mas_left).offset(5);
//            make.right.mas_equalTo(self.imageView.mas_right).offset(-5);
//            make.height.offset(20);
//        }];
        

    }
    return self;
}

#pragma mark - Private Method
//数据赋值
- (void)zx_setBlindBoxSelectViewItemlistModel:(ZXBlindBoxSelectViewItemlistModel *)blindBoxSelectViewItemlistModel{
    if (!blindBoxSelectViewItemlistModel) return;
    
    [self.imageView wg_setImageWithURL:[NSURL URLWithString:blindBoxSelectViewItemlistModel.itempic]];
    self.brandNameLabel.text = blindBoxSelectViewItemlistModel.itemname;
    

//    self.imageView.alpha = (blindBoxSelectViewItemlistModel.select) ? 1 : 0.5;
    
//    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.contentView).offset((blindBoxSelectViewItemlistModel.select) ? 10 : 55);
//        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset((blindBoxSelectViewItemlistModel.select) ? -5 : -50);
//    }];
    

}

@end

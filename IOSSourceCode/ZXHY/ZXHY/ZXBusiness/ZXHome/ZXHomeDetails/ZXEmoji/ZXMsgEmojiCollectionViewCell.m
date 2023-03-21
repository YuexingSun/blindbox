//
//  ZXMsgEmojiCollectionViewCell.m
//  ZXHY
//
//  Created by Bern Lin on 2022/2/23.
//

#import "ZXMsgEmojiCollectionViewCell.h"

@interface ZXMsgEmojiCollectionViewCell()

@property (nonatomic,strong) UIImageView *brandImageView;

@end


@implementation ZXMsgEmojiCollectionViewCell

+ (NSString *)wg_cellIdentifier{
    return @"ZXMsgEmojiCollectionViewCell";
}

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        
        self.backgroundColor = UIColor.clearColor;
        
        [self zx_setUI];
        
        
    }
    return self;
}

- (void)zx_setUI{
    self.brandImageView = [UIImageView wg_imageViewWithImageNamed:@"emoji-001"];
    self.brandImageView.backgroundColor = UIColor.clearColor;
    [self.contentView addSubview:self.brandImageView];
    [self.brandImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(self.contentView);
    }];
    
}

- (void)zx_typeImage:(UIImage *)img {
    self.brandImageView.image = img;
}



@end

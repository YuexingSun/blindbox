//
//  WGImageCollectionViewCell.m
//  Yunhuoyouxuan
//
//  Created by Apple on 2020/12/3.
//  Copyright © 2020 apple. All rights reserved.
//

#import "WGImageCollectionViewCell.h"

@interface WGImageCollectionViewCell()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *deleteBtn;

@end

@implementation WGImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _imageView = [[UIImageView alloc] init];
        _imageView.userInteractionEnabled = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
//        _imageView.clipsToBounds = YES;
        _imageView.layer.cornerRadius = 4.0;
        _imageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_imageView];
        
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage wg_imageNamed:@"mine_com_clear_solid_black_3"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_deleteBtn];
        
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(10.0);
            make.right.equalTo(self.contentView).offset(-6.0);
        }];
        [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self.contentView);
            make.width.height.mas_equalTo(20.0);
        }];
        
    }
    return self;
}

- (void)deleteBtnClick
{
    if (self.deleteCallback) {
        self.deleteCallback();
    }
}

- (void)setBgImage:(UIImage *)bgImage
{
    _bgImage = bgImage;
    self.imageView.image = bgImage;
}

- (void)setDeleteBtnHidden:(BOOL)deleteBtnHidden
{
    _deleteBtnHidden = deleteBtnHidden;
    _deleteBtn.hidden = deleteBtnHidden;
}

@end

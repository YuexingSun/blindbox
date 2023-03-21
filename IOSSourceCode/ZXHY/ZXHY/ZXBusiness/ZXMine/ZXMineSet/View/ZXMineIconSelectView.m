//
//  ZXMineIconSelectView.m
//  ZXHY
//
//  Created by Bern Mac on 9/26/21.
//

#import "ZXMineIconSelectView.h"

@implementation ZXMineIconSelectView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setLayout];
//        [self zx_startLocation];
    }
    return self;
}


- (void)setLayout{
    
    self.backgroundColor =  UIColor.clearColor;
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.titleLabel.font = kFontMedium(16);
    cancelButton.backgroundColor = UIColor.whiteColor;
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:WGGrayColor(0) forState:UIControlStateNormal];
    cancelButton.tag = 0;
    [cancelButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(25);
        make.right.mas_equalTo(self.mas_right).offset(-25);
        make.bottom.mas_equalTo(self.mas_bottom).offset( (IS_IPHONE_X_SER ? -35.0f : -15.0f));
        make.height.offset(50);
//        make.centerX.mas_equalTo(self);
//        make.width.offset(328);
    }];
    [cancelButton layoutIfNeeded];
    [cancelButton wg_setRoundedCornersWithRadius:10];
    
    
    UIView *selectView = [UIView new];
    selectView.backgroundColor = UIColor.whiteColor;
    [self addSubview:selectView];
    [selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(cancelButton);
        make.bottom.equalTo(cancelButton.mas_top).offset(-15);
        make.height.offset(100);
//        make.centerX.mas_equalTo(cancelButton);
//        make.width.offset(328);
    }];
    [selectView layoutIfNeeded];
    [selectView wg_setRoundedCornersWithRadius:10];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = WGGrayColor(238);
    [selectView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(selectView);
        make.left.right.mas_equalTo(selectView);
        make.height.offset(1);
    }];
    
    UIButton *picturesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    picturesButton.titleLabel.font = kFontMedium(16);
    [picturesButton setTitle:@"拍照" forState:UIControlStateNormal];
    [picturesButton setTitleColor:WGGrayColor(0) forState:UIControlStateNormal];
    picturesButton.tag = 1;
    [picturesButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:picturesButton];
    [picturesButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(selectView);
        make.bottom.mas_equalTo(lineView);
    }];
    
    
    UIButton *photoAlbumButton = [UIButton buttonWithType:UIButtonTypeCustom];
    photoAlbumButton.titleLabel.font = kFontMedium(16);
    [photoAlbumButton setTitle:@"从相册中获取" forState:UIControlStateNormal];
    [photoAlbumButton setTitleColor:WGGrayColor(0) forState:UIControlStateNormal];
    photoAlbumButton.tag = 2;
    [photoAlbumButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:photoAlbumButton];
    [photoAlbumButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(selectView);
        make.top.mas_equalTo(lineView);
    }];
}

//按钮响应
- (void)buttonAction:(UIButton *)sender{
    
    if (sender.tag == 0){
        if(self.delegate && [self.delegate respondsToSelector:@selector(closeIconSelectViewView:)]){
            [self.delegate closeIconSelectViewView:self];
        }
    }
    
    else if (sender.tag == 1){
        if(self.delegate && [self.delegate respondsToSelector:@selector(theShootIconSelectViewView:)]){
            [self.delegate theShootIconSelectViewView:self];
        }
    }
    
    else if (sender.tag == 2){
        if(self.delegate && [self.delegate respondsToSelector:@selector(photoAlbumIconSelectViewView:)]){
            [self.delegate photoAlbumIconSelectViewView:self];
        }
    }
    
}


@end

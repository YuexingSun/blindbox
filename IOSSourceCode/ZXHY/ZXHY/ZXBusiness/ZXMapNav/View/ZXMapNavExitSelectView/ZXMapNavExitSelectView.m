//
//  ZXMapNavExitSelectView.m
//  ZXHY
//
//  Created by Bern Lin on 2021/12/7.
//

#import "ZXMapNavExitSelectView.h"

@interface ZXMapNavExitSelectView ()

@property (nonatomic, strong) NSString  *boxId;

@end

@implementation ZXMapNavExitSelectView

- (instancetype)initWithFrame:(CGRect)frame withBoxId:(NSString *)boxId{
    if(self = [super initWithFrame:frame]){
        
        self.boxId = boxId;
        [self setLayout];
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
    cancelButton.tag = 3;
    [cancelButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(25);
        make.right.mas_equalTo(self.mas_right).offset(-25);
        make.bottom.mas_equalTo(self.mas_bottom).offset( (IS_IPHONE_X_SER ? -35.0f : -15.0f));
        make.height.offset(50);
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
    [picturesButton setTitle:@"退出导航并关闭行程" forState:UIControlStateNormal];
    [picturesButton setTitleColor:WGGrayColor(0) forState:UIControlStateNormal];
    picturesButton.tag = NavExitType_ExitAndCancelBox;
    [picturesButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:picturesButton];
    [picturesButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(selectView);
        make.bottom.mas_equalTo(lineView);
    }];
    
    
    UIButton *photoAlbumButton = [UIButton buttonWithType:UIButtonTypeCustom];
    photoAlbumButton.titleLabel.font = kFontMedium(16);
    [photoAlbumButton setTitle:@"退出导航" forState:UIControlStateNormal];
    [photoAlbumButton setTitleColor:WGGrayColor(0) forState:UIControlStateNormal];
    photoAlbumButton.tag = NavExitType_Exit;
    [photoAlbumButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:photoAlbumButton];
    [photoAlbumButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(selectView);
        make.top.mas_equalTo(lineView);
    }];
}


//按钮响应
- (void)buttonAction:(UIButton *)sender{
    
    if (sender.tag == NavExitType_ExitAndCancelBox){
        [self zx_reqApiCancel];
    }else if (sender.tag == NavExitType_Exit){
        [WGNotification postNotificationName:ZXNotificationMacro_ExitNav object:nil];
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(zx_exitSelectView:NavExitType:)]){
            [self.delegate zx_exitSelectView:self NavExitType:sender.tag];
    }
    
}


#pragma mark - NetworkRequest
//终止行程
- (void)zx_reqApiCancel{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict wg_safeSetObject:self.boxId forKey:@"boxid"];
    
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiCancelBox Parameter:dict success:^(NSDictionary * _Nonnull resultDic) {
        [WGUIManager wg_hideHUD];

        
        [WGNotification postNotificationName:ZXNotificationMacro_ExitNav object:nil];
        
    } failure:^(NSError * _Nonnull error) {
        
        
    }];

}



@end

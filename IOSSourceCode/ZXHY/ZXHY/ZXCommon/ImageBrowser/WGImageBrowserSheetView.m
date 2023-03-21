//
//  WGImageBrowserSheetView.m
//  Yunhuoyouxuan
//
//  Created by admin on 2020/11/15.
//  Copyright © 2020 apple. All rights reserved.
//

#import "WGImageBrowserSheetView.h"
#import "UIColor+WGExtension.h"

#import "NSNumber+WGExtension.h"
#import "NSString+WGExtension.h"
#import "UIView+WGExtension.h"
#import "WGMacro.h"

@interface WGImageBrowserSheetView()

@property (nonatomic, assign) WGImageBrowserSheetBtnType browserSheetBtnType;

@property (nonatomic, strong) UIView *sheetView;

@end

@implementation WGImageBrowserSheetView

static CGFloat const animateDuration = 0.35f;

- (instancetype)initWithBrowserSheetBtnType:(WGImageBrowserSheetBtnType)browserSheetBtnType
{
    if(self = [super initWithFrame:CGRectMake(0, 0, WGNumScreenWidth(), WGNumScreenHeight())]){
        _browserSheetBtnType = browserSheetBtnType;
        if(!(browserSheetBtnType & WGImageBrowserSheetBtnTypeSysWx) &&
           !(browserSheetBtnType & WGImageBrowserSheetBtnTypeSysSave)){
            [self setupUI];
        }
    }
    return self;
}

- (void)setupUI{
    
    self.backgroundColor = [UIColor clearColor];
    self.hidden = YES;
    
    CGFloat safeAreaBottom = .0f;
    
    if (@available(iOS 11, *)) {
        safeAreaBottom = [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom;
    }
    
    self.sheetView = [[UIView alloc] initWithFrame:CGRectMake(0, WGNumScreenHeight(), WGNumScreenWidth(), 197.f + safeAreaBottom)];
    self.sheetView.backgroundColor = [UIColor wg_colorWithHexString:@"#F8F8F8"];
    [self.sheetView wg_setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:16];
    [self addSubview:self.sheetView];
    
    NSInteger btnCount = 0;
    if(self.browserSheetBtnType & WGImageBrowserSheetBtnTypeWx){
        btnCount ++;
    }
    if(self.browserSheetBtnType & WGImageBrowserSheetBtnTypeSave){
        btnCount ++;
    }
    
    CGFloat btnX = 70.f;
    CGFloat btnWidth = (WGNumScreenWidth()-3*btnX)/2.0;
    CGFloat btnY = 24.f;
    CGFloat btnHeight = 85.f;
    
    if(self.browserSheetBtnType & WGImageBrowserSheetBtnTypeWx) {
        
        UIView *btnView = [self createBtnViewWithFrame:CGRectMake(btnX, btnY, btnWidth, btnHeight)
                                               imgName:@"image_browser_wechart"
                                              btnTitle:WGLocalizedString(@"分享微信好友")];
        [self.sheetView addSubview:btnView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareButtonDidClicked)];
        [btnView addGestureRecognizer:tap];
    }
    
    if(self.browserSheetBtnType & WGImageBrowserSheetBtnTypeSave){
        UIView *btnView = [self createBtnViewWithFrame:CGRectMake(btnX*btnCount+btnWidth*(btnCount-1), btnY, btnWidth, btnHeight)
                                               imgName:@"image_browser_save"
                                              btnTitle:WGLocalizedString(@"保存图片")];
        [self.sheetView addSubview:btnView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(saveButtonDidClicked)];
        [btnView addGestureRecognizer:tap];
    }
    
    CGFloat cancelBtnX = 16;
    CGFloat cancelBtnH = 40;
    CGFloat cancelBtnY = _sheetView.height-10-cancelBtnH-safeAreaBottom;
    CGFloat cancelBtnW = WGNumScreenWidth()-cancelBtnX*2;
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(cancelBtnX, cancelBtnY, cancelBtnW, cancelBtnH);
    cancelBtn.backgroundColor = [UIColor wg_colorWithHexString:@"#EEEEEE"];
    cancelBtn.layer.cornerRadius = 20;
    [cancelBtn setTitle:WGLocalizedString(@"取消") forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor wg_colorWithHexString:@"#3C3C3C"] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [cancelBtn addTarget:self action:@selector(cancelButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [_sheetView addSubview:cancelBtn];
}

- (UIView *)createBtnViewWithFrame:(CGRect)frame
                           imgName:(NSString *)imgName
                          btnTitle:(NSString *)btnTitle{
    
    UIView *btnView = [[UIView alloc] initWithFrame:frame];
    CGFloat btnWidth = frame.size.width;
    CGFloat imgBgViewWH = 52.f;
    CGFloat imgBgViewX = (btnWidth-imgBgViewWH)/2.0;
    UIView *imgBgView = [[UIView alloc] initWithFrame:CGRectMake(imgBgViewX, 0, imgBgViewWH, imgBgViewWH)];
    imgBgView.backgroundColor = [UIColor whiteColor];
    imgBgView.layer.cornerRadius = imgBgViewWH/2.0;
    imgBgView.layer.masksToBounds = YES;
    [btnView addSubview:imgBgView];
    
    CGFloat imgViewWH = 24;
    CGFloat imgViewX = (imgBgViewWH-imgViewWH)/2.0;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(imgViewX, imgViewX, imgViewWH, imgViewWH)];
    imgView.image = [UIImage imageNamed:imgName];
    imgView.layer.cornerRadius = imgViewWH/2.0;
    imgView.layer.masksToBounds = YES;
    [imgBgView addSubview:imgView];
    
    CGFloat btnLabelX = 0;
    CGFloat btnLabelWidth = btnWidth;
    CGFloat btnLabelHeight = 17;
    CGFloat btnLabelY = imgBgView.frame.origin.y+imgBgView.frame.size.height+18;
    UILabel *btnLabel = [[UILabel alloc] initWithFrame:CGRectMake(btnLabelX, btnLabelY, btnLabelWidth, btnLabelHeight)];
    btnLabel.text = btnTitle;
    btnLabel.font = [UIFont systemFontOfSize:12];
    btnLabel.textAlignment = NSTextAlignmentCenter;
    btnLabel.textColor = [UIColor wg_colorWithHexString:@"#3C3C3C"];
    [btnView addSubview:btnLabel];
    
    return btnView;
}

- (void)showToView:(UIView *)view topViewController:(UIViewController *)topViewController containerSize:(CGSize)containerSize
{
    
    if(!(self.browserSheetBtnType & WGImageBrowserSheetBtnTypeSysWx) &&
       !(self.browserSheetBtnType & WGImageBrowserSheetBtnTypeSysSave)){
        CGFloat height = containerSize.height;
        CGFloat width = containerSize.width;
        self.frame = CGRectMake(0, 0, width, height);
        self.hidden = NO;
        [UIView animateWithDuration:animateDuration animations:^{
            
            self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.35f];
            CGRect sheetViewFrame = self.sheetView.frame;
            sheetViewFrame.origin.y = height-self.sheetView.frame.size.height;
            self.sheetView.frame = sheetViewFrame;
        }];
        
        if (![view.subviews containsObject:self]) {
            [view addSubview:self];
        }
    }else{
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        if(self.browserSheetBtnType & WGImageBrowserSheetBtnTypeSysWx){
            WEAKSELF
            UIAlertAction *wxAction = [UIAlertAction actionWithTitle:@"分享微信好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                STRONGSELF
                [self shareButtonDidClicked];
            }];
            [alertVc addAction:wxAction];
        }
        
        if(self.browserSheetBtnType & WGImageBrowserSheetBtnTypeSysSave){
            WEAKSELF
            UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"保存图片到相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                STRONGSELF
                [self saveButtonDidClicked];
            }];
            [alertVc addAction:saveAction];
        }
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertVc addAction:cancelAction];
        [topViewController presentViewController:alertVc animated:YES completion:nil];
    }
}

- (void)hideSheetView {
    if (!self.superview) return;
    
    [UIView animateWithDuration:animateDuration animations:^{
        CGRect sheetViewFrame = self.sheetView.frame;
        sheetViewFrame.origin.y = self.frame.size.height;
        self.sheetView.frame = sheetViewFrame;
        self.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - touch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [touches.anyObject locationInView:self];
    if (!CGRectContainsPoint(self.sheetView.frame, point)) {
        [self hideSheetView];
    }
}

- (void)shareButtonDidClicked {
    
    if(self.shareToWeChat){
        self.shareToWeChat();
    }
    
    [self hideSheetView];
}

- (void)saveButtonDidClicked {
    
    if (self.saveToAlbum) {
        self.saveToAlbum();
    }
    
    [self hideSheetView];
}

- (void)cancelButtonDidClicked {
    [self hideSheetView];
}

@end

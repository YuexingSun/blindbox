//
//  WGImageBrowserHandler.m
//  Yunhuoyouxuan
//
//  Created by apple on 2021/5/12.
//  Copyright © 2021 广州微革网络科技有限公司（本内容仅限于广州微革网络科技有限公司内部传阅，禁止外泄以及用于其他的商业目的）. All rights reserved.
//

#import "WGImageBrowserToolViewHandler.h"
#import "WGImageBrowserTitleView.h"

#import <YBImageBrowser/YBIBVideoData.h>
#import <YBImageBrowser/YBIBUtilities.h>

#import "UIView+WGExtension.h"

@interface WGImageBrowserToolViewHandler()

@property(nonatomic, strong) WGImageBrowserTitleView *titleView;

@property(nonatomic, strong) WGImageBrowserSheetView *sheetView;

@property(nonatomic, assign) WGImageBrowserSheetBtnType type;

@property(nonatomic, assign) BOOL needSheetView;

@property(nonatomic, assign) BOOL needSaveButton;

@property(nonatomic, strong) UIButton *saveButton;

@end

@implementation WGImageBrowserToolViewHandler

- (instancetype)initWithSheetButtonType:(WGImageBrowserSheetBtnType)type {
    if (self = [super init]) {
        self.type = type;
        self.needSheetView = YES;
    }
    return self;
}

- (instancetype)initWithSaveButton {
    if (self = [super init]) {
        self.needSaveButton = YES;
    }
    return self;
}

#pragma mark - YBIBToolViewHandler

@synthesize yb_containerView = _yb_containerView;
@synthesize yb_containerSize = _yb_containerSize;
@synthesize yb_currentPage = _yb_currentPage;
@synthesize yb_totalPage = _yb_totalPage;
@synthesize yb_currentOrientation = _yb_currentOrientation;
@synthesize yb_currentData = _yb_currentData;

- (void)yb_containerViewIsReadied {
    if (_needSaveButton) {
        [self.yb_containerView addSubview:self.saveButton];
    } else {
        [self.yb_containerView addSubview:self.titleView];
    }
    [self layoutWithExpectOrientation:self.yb_currentOrientation()];
}

- (void)yb_pageChanged {
    
    NSInteger pageIndex = self.yb_currentPage();
    NSInteger totalPage = self.yb_totalPage();

    self.titleView.hidden = [_yb_currentData() isKindOfClass:YBIBVideoData.class];
    
    NSString *titleStr = [NSString stringWithFormat:@"%zd/%zd",pageIndex + 1, totalPage];
    [self.titleView setText:titleStr];
    UIEdgeInsets padding = YBIBPaddingByBrowserOrientation(self.yb_currentOrientation());
    CGSize size = self.yb_containerSize(self.yb_currentOrientation());
    [self.titleView updateLayout:size padding:padding];
}

- (void)yb_hide:(BOOL)hide {
    self.titleView.hidden = hide || [_yb_currentData() isKindOfClass:YBIBVideoData.class];
    if (self.needSheetView) {
        [self.sheetView hideSheetView];
    }
}

- (void)yb_respondsToLongPress {
    if (self.needSheetView) {
        [self.sheetView showToView:self.yb_containerView topViewController:[self topViewController] containerSize:self.yb_containerSize(self.yb_currentOrientation())];
    }
}

- (void)yb_orientationChangeAnimationWithExpectOrientation:(UIDeviceOrientation)orientation {
    [self layoutWithExpectOrientation:orientation];
}

- (void)layoutWithExpectOrientation:(UIDeviceOrientation)orientation {
    UIEdgeInsets padding = YBIBPaddingByBrowserOrientation(orientation);
    if (_needSaveButton) {
        CGSize size = self.yb_containerSize(orientation);
        self.saveButton.frame = CGRectMake(30 + padding.left, size.height - 70 - padding.bottom, 55, 30);
    } else {
        self.titleView.y = padding.top;
        CGSize size = self.yb_containerSize(orientation);
        [self.titleView updateLayout:size padding:padding];
    }
}

#pragma mark - private method

- (id)topViewController {
    UIViewController *resultVC;
    resultVC = [self findTopViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self findTopViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)findTopViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self findTopViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self findTopViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

- (void)saveImage {
    id<YBIBDataProtocol> data = self.yb_currentData();
    if ([data respondsToSelector:@selector(yb_saveToPhotoAlbum)]) {
        [data yb_saveToPhotoAlbum];
    }
}

#pragma mark - setter & getter

- (WGImageBrowserTitleView *)titleView {
    if (!_titleView) {
        CGSize size = self.yb_containerSize(self.yb_currentOrientation());
        _titleView = [[WGImageBrowserTitleView alloc] initWithFrame:CGRectMake(0, 8, size.width, 44)];
        _titleView.userInteractionEnabled = NO;
    }
    return _titleView;
}

- (WGImageBrowserSheetView *)sheetView {
    if (!_sheetView) {
        _sheetView = [[WGImageBrowserSheetView alloc] initWithBrowserSheetBtnType:self.type];
        __weak typeof(self) wSelf = self;
        _sheetView.shareToWeChat = ^{
            __strong typeof(wSelf) self = wSelf;
            if (!self) return;
            id<YBIBDataProtocol> data = self.yb_currentData();
            if (self.shareToWeChat && [data isKindOfClass:YBIBImageData.class]) {
                YBIBImageData *imageData = (YBIBImageData *)data;
                self.shareToWeChat(imageData.imageURL, imageData.image ? imageData.image() : nil);
            } else if (self.shareToWeChat && [data isKindOfClass:YBIBVideoData.class]) {
                YBIBVideoData *videoData = (YBIBVideoData *)data;
                self.shareToWeChat(videoData.videoURL, nil);
            }
        };
        _sheetView.saveToAlbum = ^{
            __strong typeof(wSelf) self = wSelf;
            if (!self) return;
            id<YBIBDataProtocol> data = self.yb_currentData();
            if ([data respondsToSelector:@selector(yb_saveToPhotoAlbum)]) {
                [data yb_saveToPhotoAlbum];
            }
        };
    }
    return _sheetView;
}

- (UIButton *)saveButton {
    if (!_saveButton) {
        // 2.保存按钮
        UIButton *saveButton = [[UIButton alloc] init];
        [saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        saveButton.layer.borderWidth = 0.1;
        saveButton.layer.borderColor = [UIColor whiteColor].CGColor;
        saveButton.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.3f];
        saveButton.layer.cornerRadius = 2;
        saveButton.clipsToBounds = YES;
        [saveButton addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
        _saveButton = saveButton;
    }
    return _saveButton;
}

@end

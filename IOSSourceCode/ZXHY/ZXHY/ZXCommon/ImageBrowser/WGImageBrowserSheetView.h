//
//  WGImageBrowserSheetView.h
//  Yunhuoyouxuan
//
//  Created by admin on 2020/11/15.
//  Copyright © 2020 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBImageBrowser.h"

typedef NS_OPTIONS(NSUInteger, WGImageBrowserSheetBtnType) {
    WGImageBrowserSheetBtnTypeNone      =       0,
    WGImageBrowserSheetBtnTypeWx        =       1 << 0,     //微信（自定义）
    WGImageBrowserSheetBtnTypeSave      =       1 << 1,     //保存（自定义）
    WGImageBrowserSheetBtnTypeSysWx     =       1 << 2,     //微信（系统）
    WGImageBrowserSheetBtnTypeSysSave   =       1 << 3,     //保存（系统）
};

@interface WGImageBrowserSheetView : UIView

- (instancetype)initWithBrowserSheetBtnType:(WGImageBrowserSheetBtnType)browserSheetBtnType;

- (void)showToView:(UIView *)view topViewController:(UIViewController *)topViewController containerSize:(CGSize)containerSize;

- (void)hideSheetView;

@property (nonatomic, copy) void(^saveToAlbum)(void);

@property (nonatomic, copy) void(^shareToWeChat)(void);

@end

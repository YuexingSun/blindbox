//
//  WGImageBrowser.h
//  Yunhuoyouxuan
//
//  Created by admin on 2020/11/15.
//  Copyright © 2020 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WGImageBrowserSheetView.h"

#import "WGImageBrowserToolViewHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface WGImageBrowser : NSObject

/// 视频播放器
/// @param videoUrlArr 视频链接数组
/// @param index 当前下标
/// @param browserSheetBtnType 分享类型
+ (WGImageBrowserToolViewHandler *)wg_showImageBrowserWithVideoUrlArr:(NSArray <NSString *>*)videoUrlArr
                                                                index:(NSInteger)index
                                                 sheetViewButtonsType:(WGImageBrowserSheetBtnType)browserSheetBtnType;

/// 展示图片浏览器
/// @param images 图片数组（UIImage类型）或者图片URL数组（NSString类型或者NSURL类型）
/// @param index 首张展示的图片的下标
/// @return WGImageBrowser
+ (WGImageBrowserToolViewHandler *)wg_showImageBrowserWithImages:(NSArray *)images
                                                           index:(NSInteger)index;

/// 展示单张图片
/// @param imageUrl 图片链接
+ (void)wg_showNormalImageBrowserWithSingleImage:(NSString *)imageUrl;

/// 展示图片浏览器
/// @param images 图片数组（UIImage类型）或者图片URL数组（NSString类型或者NSURL类型）
/// @param index 第一次要展示的数组图片下标
/// @param delegate 代理
/// @param sourceObjects 图片缩略图所展示的view或者layer数组
/// @return WGImageBrowser
+ (WGImageBrowserToolViewHandler *)wg_showImageBrowserWithImages:(NSArray *)images
                                        index:(NSInteger)index
                                     delegate:(id<YBImageBrowserDelegate> _Nullable)delegate
                                sourceObjects:(NSArray<id> * _Nullable)sourceObjects;

/// 展示图片浏览器
/// @param images 图片数组（UIImage类型）或者图片URL数组（NSString类型或者NSURL类型）
/// @param index 第一次要展示的数组图片下标
/// @param delegate 代理
/// @param sourceObjects 图片缩略图所展示的view或者layer数组
/// @param browserSheetBtnType 如果想添加“分享到微信”、“保存到相册”功能需调用该方法，允许两个功能同时拥有
/// @return WGImageBrowser
+ (WGImageBrowserToolViewHandler *)wg_showImageBrowserWithImages:(NSArray *)images
                                        index:(NSInteger)index
                                     delegate:(id<YBImageBrowserDelegate> _Nullable)delegate
                                sourceObjects:(NSArray<id> * _Nullable)sourceObjects
                         sheetViewButtonsType:(WGImageBrowserSheetBtnType)browserSheetBtnType;

@end

NS_ASSUME_NONNULL_END

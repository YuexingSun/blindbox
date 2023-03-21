//
//  WGImageBrowser.m
//  Yunhuoyouxuan
//
//  Created by admin on 2020/11/15.
//  Copyright © 2020 apple. All rights reserved.
//

#import "WGImageBrowser.h"

//#import "WGImageBrowseCellData.h"
//#import "WGVideoBrowseCellData.h"
#import "WGVideoBrowseCellData.h"
#import <YBImageBrowser/YBIBImageData.h>
#import "NSArray+WGSafe.h"

@interface WGImageBrowser()

@property (nonatomic, copy) void(^shareToWXBlock)(NSString *imgUrl, UIImage *img);

@end

@implementation WGImageBrowser

- (void)dealloc{
    
//    WGLog(@"WGImageBrowser的析构函数");
}

//https://sms.bravat.com/avi/CRM/EIH_INSTALL_SERVICE_AVI/66971.mp4
+ (WGImageBrowserToolViewHandler *)wg_showImageBrowserWithVideoUrlArr:(NSArray <NSString *>*)videoUrlArr
                                                                index:(NSInteger)index
                                                 sheetViewButtonsType:(WGImageBrowserSheetBtnType)browserSheetBtnType
{
    if(!videoUrlArr.count) return nil;
    NSMutableArray *muCellDataArr = [NSMutableArray array];
    for (NSString *urlStr in videoUrlArr) {
        WGVideoBrowseCellData *cellData = [[WGVideoBrowseCellData alloc] init];
        cellData.videoURL = [NSURL URLWithString:urlStr];
        cellData.autoPlayCount = 1;
        [muCellDataArr addObject:cellData];
    }
    
    YBImageBrowser *browser = [self generateBrowserWithCurrentPage:index dataSource:muCellDataArr delegate:nil showHideType:YBIBTransitionTypeFade sheetViewButtonsType:browserSheetBtnType];
    [browser show];
    
    return browser.toolViewHandlers.firstObject;
}

+ (WGImageBrowserToolViewHandler *)wg_showImageBrowserWithImages:(NSArray *)images index:(NSInteger)index
{
    return [self wg_showImageBrowserWithImages:images index:index delegate:nil sourceObjects:nil];
}

+ (void)wg_showNormalImageBrowserWithSingleImage:(NSString *)imageUrl {
    if(imageUrl.length == 0) return;
    YBIBImageData *cellData = [[YBIBImageData alloc] init];
    cellData.imageURL = [NSURL URLWithString:imageUrl];
    
    YBImageBrowser *browser = [self generateBrowserWithCurrentPage:0 dataSource:@[cellData] delegate:nil showHideType:YBIBTransitionTypeFade sheetViewButtonsType:WGImageBrowserSheetBtnTypeNone];
    WGImageBrowserToolViewHandler *handler = [[WGImageBrowserToolViewHandler alloc] initWithSaveButton];
    browser.toolViewHandlers = @[handler];
    [browser show];

}

+ (WGImageBrowserToolViewHandler *)wg_showImageBrowserWithImages:(NSArray *)images
                                        index:(NSInteger)index
                                     delegate:(id<YBImageBrowserDelegate>)delegate
                                sourceObjects:(NSArray<id> *)sourceObjects {
    return [self wg_showImageBrowserWithImages:images index:index delegate:delegate sourceObjects:sourceObjects sheetViewButtonsType:WGImageBrowserSheetBtnTypeNone];
}

+ (WGImageBrowserToolViewHandler *)wg_showImageBrowserWithImages:(NSArray *)images
                                                           index:(NSInteger)index
                                                        delegate:(id<YBImageBrowserDelegate>)delegate
                                                   sourceObjects:(NSArray<id> *)sourceObjects
                                            sheetViewButtonsType:(WGImageBrowserSheetBtnType)browserSheetBtnType
{
    if(!images.count) return nil;
    NSMutableArray *muCellDataArr = [NSMutableArray array];
    for(int i = 0 ; i < images.count ; i++){
        id obj = [images wg_safeObjectAtIndex:i];
        YBIBImageData *cellData = [[YBIBImageData alloc] init];
        if ([obj isKindOfClass:NSString.class]) {
            cellData.imageURL = [NSURL URLWithString:obj];
        } else if ([obj isKindOfClass:NSURL.class]) {
            cellData.imageURL = obj;
        } else if ([obj isKindOfClass:UIImage.class]) {
            cellData.image = ^UIImage * _Nullable{
                return obj;
            };
        }
//        cellData.image.preloadAllAnimatedImageFrames = YES;
        if(sourceObjects && sourceObjects.count > i){
            cellData.projectiveView = [sourceObjects wg_safeObjectAtIndex:i];
        }
        [muCellDataArr addObject:cellData];
    }
    YBImageBrowser *browser = [self generateBrowserWithCurrentPage:index dataSource:muCellDataArr delegate:delegate showHideType:sourceObjects.count > 0 ? YBIBTransitionTypeCoherent : YBIBTransitionTypeFade sheetViewButtonsType:browserSheetBtnType];
    [browser show];
    
    return browser.toolViewHandlers.firstObject;
}

+ (YBImageBrowser *)generateBrowserWithCurrentPage:(NSInteger)currentPage dataSource:(NSArray *)dataSource delegate:(id<YBImageBrowserDelegate>)delegate showHideType:(YBIBTransitionType)showHideType sheetViewButtonsType:(WGImageBrowserSheetBtnType)browserSheetBtnType
{
    YBImageBrowser *browser = [YBImageBrowser new];
    
    browser.dataSourceArray = dataSource;
    browser.defaultAnimatedTransition.showType = showHideType;
    browser.defaultAnimatedTransition.hideType = showHideType;
    browser.defaultAnimatedTransition.showDuration = 0.35;
    browser.defaultAnimatedTransition.hideDuration = 0.35;
    if (browserSheetBtnType != WGImageBrowserSheetBtnTypeNone) {
        WGImageBrowserToolViewHandler *handler = [[WGImageBrowserToolViewHandler alloc] initWithSheetButtonType:browserSheetBtnType];
        browser.toolViewHandlers = @[handler];
    } else {
        browser.toolViewHandlers = @[[WGImageBrowserToolViewHandler new]];
    }
    browser.currentPage = currentPage;
    browser.delegate = delegate;
    return browser;
}


@end


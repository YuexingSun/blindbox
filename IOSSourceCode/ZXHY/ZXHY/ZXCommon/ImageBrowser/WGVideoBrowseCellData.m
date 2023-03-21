//
//  WGVideoBrowseCellData.m
//  Yunhuoyouxuan
//
//  Created by admin on 2020/12/12.
//  Copyright © 2020 apple. All rights reserved.
//

#import "WGVideoBrowseCellData.h"
#import "WGVideoBrowseCell.h"

@implementation WGVideoBrowseCellData

#pragma mark - <YBIBDataProtocol>

- (Class)yb_classOfCell {
    return WGVideoBrowseCell.class;
}
//
//- (void)setDownloading:(BOOL)downloading {
//    _downloading = downloading;
//    if (downloading) {
//        [self.delegate yb_videoData:self downloadingWithProgress:0];
//    } else {
//        [self.delegate yb_finishDownloadingForData:self];
//    }
//}
//
//- (void)setLoadingAVAssetFromPHAsset:(BOOL)loadingAVAssetFromPHAsset {
//    _loadingAVAssetFromPHAsset = loadingAVAssetFromPHAsset;
//    if (loadingAVAssetFromPHAsset) {
//        [self.delegate yb_startLoadingAVAssetFromPHAssetForData:self];
//    } else {
//        [self.delegate yb_finishLoadingAVAssetFromPHAssetForData:self];
//    }
//}
//
//- (void)setLoadingFirstFrame:(BOOL)loadingFirstFrame {
//    _loadingFirstFrame = loadingFirstFrame;
//    if (loadingFirstFrame) {
//        [self.delegate yb_startLoadingFirstFrameForData:self];
//    } else {
//        [self.delegate yb_finishLoadingFirstFrameForData:self];
//    }
//}
//
//@synthesize delegate = _delegate;
//- (void)setDelegate:(id<YBIBVideoDataDelegate>)delegate {
//    _delegate = delegate;
//    if (delegate) {
//        [self loadData];
//    }
//}
//- (id<YBIBVideoDataDelegate>)delegate {
//    // Stop sending data to the '_delegate' if it is transiting.
//    return self.yb_isHideTransitioning() ? nil : _delegate;
//}
@end

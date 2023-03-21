//
//  WGImagePickerManager.m
//  Yunhuoyouxuan
//
//  Created by Apple on 2020/12/3.
//  Copyright © 2020 apple. All rights reserved.
//

#import "WGImagePickerManager.h"
#import "TZImagePickerController.h"
#import "WGColorFontDefine.h"
//#import "WGUIManager.h"

static NSMutableDictionary *dict;
static NSInteger imagePickerKey = 1;

@interface WGImagePickerManager()<UINavigationControllerDelegate,TZImagePickerControllerDelegate>

@property (nonatomic, copy) MGImagePickerCallback imagePickerCallback;
@property (nonatomic, assign) NSInteger selfKey;

@end

@implementation WGImagePickerManager

- (void)presentImagePickerWithCallback:(MGImagePickerCallback)callback
{
    if (callback) {
        if (!dict) {
            dict = [NSMutableDictionary dictionary];
        }
        imagePickerKey++;
        self.selfKey = imagePickerKey;
        [dict wg_safeSetObject:self forKey:@(self.selfKey)];
    }
    
    self.imagePickerCallback = callback;
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:self.maxImagesCount?self.maxImagesCount:5 columnNumber:5 delegate:self pushPhotoPickerVc:YES];
    
    imagePickerVc.naviBgColor = [UIColor whiteColor];
    imagePickerVc.iconThemeColor = kBrandColor;
    imagePickerVc.oKButtonTitleColorNormal = kBrandColor;
    imagePickerVc.oKButtonTitleColorDisabled = kBrandColor;
    imagePickerVc.photoNumberIconImage = [UIImage wg_imageNamed:@"icon_select_bgImage.png"];
    imagePickerVc.photoOriginSelImage = [UIImage wg_imageNamed:@"icon_select_bgImage.png"];
//    imagePickerVc.photoWidth = 1000;
//    imagePickerVc.photoPreviewMaxWidth = 10000;

    
    imagePickerVc.isSelectOriginalPhoto = self.isSelectOriginalPhoto;
    
    if (self.selectedAssets) {
        imagePickerVc.selectedAssets = _selectedAssets;// 目前已经选中的图片数组
    }
    
    imagePickerVc.statusBarStyle = UIStatusBarStyleDefault;
    imagePickerVc.barItemTextColor = kBrandColor;
    imagePickerVc.naviTitleColor = kBrandColor;
    
    // 设置是否显示图片序号
    imagePickerVc.showSelectedIndex = YES;
    // 是否可以选择视频
    imagePickerVc.allowPickingVideo = NO;
    
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [[WGUIManager wg_topViewController] presentViewController:imagePickerVc animated:YES completion:nil];
    
    
}

- (void)removeSelf
{
    WGImagePickerManager *manager = [dict wg_safeObjectForKey:@(self.selfKey)];
    if (manager) {
        [dict wg_safeRemoveObjectForKey:@(self.selfKey)];
    }
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    
    if (self.imagePickerCallback) {
        self.imagePickerCallback(photos,assets,isSelectOriginalPhoto);
    }
    
    [self removeSelf];
}

- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker
{
    [self removeSelf];
}

@end

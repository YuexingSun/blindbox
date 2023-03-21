//
//  WGCSImageCenter.m
//  Yunhuoyouxuan
//
//  Created by Apple on 2020/12/3.
//  Copyright © 2020 apple. All rights reserved.
//

#import "WGCSImageCenter.h"
#import "WGImagePickerManager.h"
#import <Photos/Photos.h>
#import <Photos/PHObject.h>
#import <Photos/PhotosTypes.h>

@interface WGCSImageCenter()

@property (nonatomic, strong) WGImageCollectionView *imageCollectionView;
@property (nonatomic, strong) NSMutableArray *selectedPhotos;
@property (nonatomic, strong) NSMutableArray *selectedAssets;
@property (nonatomic, assign) BOOL isSelectOriginalPhoto;

@end

@implementation WGCSImageCenter

- (void)changeImageCollectionViewHeight:(CGFloat)height
{
    CGRect imageCollectionViewFrame = self.imageCollectionView.frame;
    imageCollectionViewFrame.size.height = height;
    self.imageCollectionView.frame = imageCollectionViewFrame;
    
    if (self.heightChangeBlock) {
        self.heightChangeBlock(height);
    }
}

- (void)deleteImageWithIndex:(NSInteger)index
{
    if (index < self.selectedPhotos.count) {
        [self.selectedPhotos wg_safeRemoveObjectAtIndex:index];
        [self.selectedAssets wg_safeRemoveObjectAtIndex:index];
        [self imageChange];
    }
}

- (void)addImage
{
    WGImagePickerManager *manager = [[WGImagePickerManager alloc] init];
    manager.isSelectOriginalPhoto = self.isSelectOriginalPhoto;
    manager.selectedAssets = self.selectedAssets;
    manager.maxImagesCount = 9;
    WEAKSELF
    [manager presentImagePickerWithCallback:^(NSArray<UIImage *> * _Nullable photos, NSArray * _Nullable assets, BOOL isSelectOriginalPhoto) {
        STRONGSELF
        self.isSelectOriginalPhoto = isSelectOriginalPhoto;
        self.selectedPhotos = [NSMutableArray arrayWithArray:photos];
        self.selectedAssets = [NSMutableArray arrayWithArray:assets];
        [self imageChange];
    }];
}

- (void)imageChange
{
    self.imageCollectionView.selectedPhotos = self.selectedPhotos;
    if (self.imageChangeCallback) {
        self.imageChangeCallback(self.selectedPhotos);
    }
}


#pragma mark - public
- (UIView *)getImageCollectionViewWithFrame:(CGRect)frame
{
    self.imageCollectionView = [[WGImageCollectionView alloc] initWithFrame:frame];
    [self changeImageCollectionViewHeight:[self.imageCollectionView getImageCollectionViewHeight]];
    
    WEAKSELF
    self.imageCollectionView.heightChangeBlock = ^(CGFloat heigth) {
        [weakSelf changeImageCollectionViewHeight:heigth];
    };
    
    self.imageCollectionView.addImageBlock = ^(){
        [weakSelf addImage];
    };
    
    self.imageCollectionView.deleteImageBlock = ^(NSInteger index) {
        [weakSelf deleteImageWithIndex:index];
    };
    
    return self.imageCollectionView;
}


- (CGFloat)getImageCollectionViewHeight
{
    
    return self.imageCollectionView.frame.size.height;
}

//传入已有图片数组
- (void)zx_incoming:(NSArray *)imgList{
    self.selectedPhotos = [NSMutableArray arrayWithArray:imgList];
//    self.selectedAssets = [NSMutableArray arrayWithArray:assets];
    
    NSMutableArray *assetsList  = [NSMutableArray array];

    for (UIImage *image in imgList){
        
        __block NSString *assetId = nil;
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                
            // 保存相片到相机胶卷，并返回标识

               assetId= [PHAssetCreationRequest  creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
            
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                
                if(success){
                    // 根据标识获得相片对象
                    PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetId] options:nil].lastObject;
                    [assetsList wg_safeAddObject:asset];
            }
               
        }];
    }
    
    self.selectedAssets = assetsList;
    [self imageChange];
}

@end

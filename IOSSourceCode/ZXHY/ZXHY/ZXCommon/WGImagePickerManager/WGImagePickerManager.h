//
//  WGImagePickerManager.h
//  Yunhuoyouxuan
//
//  Created by Apple on 2020/12/3.
//  Copyright © 2020 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^MGImagePickerCallback)(NSArray<UIImage *> * _Nullable photos, NSArray * _Nullable assets, BOOL isSelectOriginalPhoto);

NS_ASSUME_NONNULL_BEGIN

@interface WGImagePickerManager : NSObject

@property (nonatomic, assign) BOOL isSelectOriginalPhoto;
@property (nonatomic, strong) NSMutableArray *selectedAssets;
@property (nonatomic, assign) NSInteger maxImagesCount;//默认是5个

- (void)presentImagePickerWithCallback:(MGImagePickerCallback)callback;

@end

NS_ASSUME_NONNULL_END

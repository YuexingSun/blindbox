//
//  WGImageCollectionViewCell.h
//  Yunhuoyouxuan
//
//  Created by Apple on 2020/12/3.
//  Copyright © 2020 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WGImageCollectionViewCellID @"WGImageCollectionViewCellID"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ImageDeleteCallBack)(void);

@interface WGImageCollectionViewCell : UICollectionViewCell


@property (nonatomic, strong) UIImage *bgImage;
@property (nonatomic, assign) BOOL deleteBtnHidden;
@property (nonatomic, copy) ImageDeleteCallBack deleteCallback;

@end

NS_ASSUME_NONNULL_END

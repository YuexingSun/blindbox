//
//  WGImageCollectionView.h
//  Yunhuoyouxuan
//
//  Created by Apple on 2020/12/3.
//  Copyright © 2020 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ImageCollectionViewAddImage)(void);
typedef void(^ImageCollectionViewDeleteImage)(NSInteger index);
typedef void(^ImageCollectionViewHeightChange)(CGFloat heigth);

@interface WGImageCollectionView : UIView

@property (nonatomic, assign) CGFloat cellVerticalGap;//cell竖直方向之间的距离，默认为2.0
@property (nonatomic, assign) CGFloat cellHorizontalGap;//cell横向之间的距离，默认为7.0
@property (nonatomic, assign) NSInteger maxCellNum;//最大展示cell的数量，默认为5
@property (nonatomic, assign) NSInteger cellHorizontalNum;//横向展示cell的数量，默认为4

@property (nonatomic, strong) NSMutableArray *selectedPhotos;

@property (nonatomic, copy) ImageCollectionViewAddImage addImageBlock;
@property (nonatomic, copy) ImageCollectionViewDeleteImage deleteImageBlock;
@property (nonatomic, copy) ImageCollectionViewHeightChange heightChangeBlock;

- (CGFloat)getImageCollectionViewHeight;
- (void)zx_CollectionViewReload;


@end

NS_ASSUME_NONNULL_END

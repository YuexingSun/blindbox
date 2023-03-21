//
//  WGCSImageCenter.h
//  Yunhuoyouxuan
//
//  Created by Apple on 2020/12/3.
//  Copyright © 2020 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WGImageCollectionView.h"

typedef void(^CSImageChangeCallback)(NSArray<UIImage *> * _Nullable photos);

NS_ASSUME_NONNULL_BEGIN

@interface WGCSImageCenter : NSObject

@property (nonatomic, copy) ImageCollectionViewHeightChange heightChangeBlock;
@property (nonatomic, copy) CSImageChangeCallback imageChangeCallback;

- (UIView *)getImageCollectionViewWithFrame:(CGRect)frame;//注：celloection的底部距离cell有6的空白距离
- (CGFloat)getImageCollectionViewHeight;

//传入已有图片数组
- (void)zx_incoming:(NSArray *)imgList;

@end

NS_ASSUME_NONNULL_END

//
//  WGTabBarModel.h
//  Yunhuoyouxuan
//
//  Created by Bern on 2021/4/28.
//  Copyright © 2021 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WGTabBarType) {
    WGTabBarType_Home,
    WGTabBarType_Box,
    WGTabBarType_Me,
};

@interface WGTabBarModel : NSObject

/** 名称 */
@property(nonatomic, strong) NSString *tabName;

/** 标签图片(未选中) */
@property(nonatomic, strong) NSString *tabImgNormal;

/** 标签图片(选中) */
@property(nonatomic, strong) NSString *tabImgSelected;

/** 是否选中 */
@property(nonatomic, assign) BOOL isSelected;

/** 是否需要大图 */
@property(nonatomic, assign) BOOL showBigImage;

/** 未读数 大于0 才展示 */
@property(nonatomic, strong) NSString *bagdeValue;

/** 动画图片 */
@property(nonatomic, strong) NSString *animationStr;

/** 类型 */
@property(nonatomic, assign) WGTabBarType tabType;


@end

NS_ASSUME_NONNULL_END

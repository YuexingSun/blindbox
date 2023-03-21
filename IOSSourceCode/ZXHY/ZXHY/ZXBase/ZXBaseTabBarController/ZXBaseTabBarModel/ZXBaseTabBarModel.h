//
//  ZXBaseTabBarModel.h
//  ZXHY
//
//  Created by Bern Lin on 2021/11/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXBaseTabBarModel : NSObject

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


@end

NS_ASSUME_NONNULL_END

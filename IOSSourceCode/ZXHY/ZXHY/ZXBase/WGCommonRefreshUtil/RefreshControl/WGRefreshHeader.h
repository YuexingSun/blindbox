//
//  WGRefreshHeader.h
//  WG_Common
//
//  Created by apple on 2021/5/21.
//  Copyright © 2021 广州微革网络科技有限公司（本内容仅限于广州微革网络科技有限公司内部传阅，禁止外泄以及用于其他的商业目的）. All rights reserved.
//

#import "MJRefreshHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface WGRefreshHeader : MJRefreshHeader

/// 是否使用亮色的前景色
@property (nonatomic, assign) BOOL isLight;

/// 在header刷新控件的顶部添加一个logo
- (void)addLogoImage:(BOOL)show;

/// 品牌logo
@property(nonatomic, strong, readonly) UILabel *logoLabel;

@end

NS_ASSUME_NONNULL_END

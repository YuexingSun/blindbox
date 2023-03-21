//
//  MJRefreshFooter+WGRefresh.h
//  WG_Common
//
//  Created by apple on 2021/5/26.
//  Copyright © 2021 广州微革网络科技有限公司（本内容仅限于广州微革网络科技有限公司内部传阅，禁止外泄以及用于其他的商业目的）. All rights reserved.
//

#import <MJRefresh/MJRefreshFooter.h>

NS_ASSUME_NONNULL_BEGIN

static MJRefreshState MJRefreshStateBadNetwork = 6;

static MJRefreshState MJRefreshStateNoMoreDataWithLogo = 7;

@interface MJRefreshFooter (WGRefresh)

- (void)endRefreshingWithBadNetwork;

- (void)endRefreshingWithNoMoreDataLogo;

@end

NS_ASSUME_NONNULL_END

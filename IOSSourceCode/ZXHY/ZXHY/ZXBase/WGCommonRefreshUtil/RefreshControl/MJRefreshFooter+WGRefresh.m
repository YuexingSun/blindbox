//
//  MJRefreshFooter+WGRefresh.m
//  WG_Common
//
//  Created by apple on 2021/5/26.
//  Copyright © 2021 广州微革网络科技有限公司（本内容仅限于广州微革网络科技有限公司内部传阅，禁止外泄以及用于其他的商业目的）. All rights reserved.
//

#import "MJRefreshFooter+WGRefresh.h"

@implementation MJRefreshFooter (WGRefresh)

#pragma mark - Publish method

- (void)endRefreshingWithBadNetwork
{
    MJRefreshDispatchAsyncOnMainQueue(self.state = MJRefreshStateBadNetwork;)
}

- (void)endRefreshingWithNoMoreDataLogo
{
    MJRefreshDispatchAsyncOnMainQueue(self.state = MJRefreshStateNoMoreDataWithLogo;)
}


@end

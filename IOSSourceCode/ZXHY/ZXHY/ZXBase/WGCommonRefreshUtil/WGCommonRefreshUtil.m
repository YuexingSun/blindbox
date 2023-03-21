//
//  WGHeaderRefreshUtil.m
//  Yunhuoyouxuan
//
//  Created by 廖其进 on 2021/1/24.
//  Copyright © 2021 apple. All rights reserved.
//

#import "WGCommonRefreshUtil.h"

#import "WGRefreshHeader.h"
#import "WGRefreshFooter.h"

#import "WGRefreshClassifyHeader.h"
#import "WGRefreshClassifyFooter.h"

@implementation WGCommonRefreshUtil

#pragma mark - Header
/**************************** 下拉加载更多 ******************************/
+ (void)configSkipRefreshInScrollView:(UIScrollView *)scrollView
                               target:(id)target
                               action:(SEL)action{
    
    if([scrollView.mj_header isKindOfClass:WGRefreshClassifyHeader.class]){
        [scrollView.mj_header setRefreshingTarget:target refreshingAction:action];
        [self wg_resetSkipHeaderStateTitleWithHeader:(WGRefreshClassifyHeader* )scrollView.mj_header];
        return;
    }
    // 下拉刷新
    // 上拉加载
    if (scrollView.mj_header) {
        [scrollView.mj_header endRefreshing];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        WGRefreshClassifyHeader *header = [WGRefreshClassifyHeader headerWithRefreshingTarget:target refreshingAction:action];
        [self wg_resetSkipHeaderStateTitleWithHeader:header];
        scrollView.mj_header = header;
    });
}

+ (void)configRefreshInScrollView:(UIScrollView *)tableView
                           target:(id)target
                           action:(SEL)action
                headerRefreshType:(WGCommonHeaderRefreshType)headerRefreshType
{
    [self configRefreshInScrollView:tableView target:target action:action headerRefreshType:headerRefreshType showLogo:NO];
}

+ (void)configRefreshInScrollView:(UIScrollView *)scrollView
                           target:(id)target
                           action:(SEL)action
                headerRefreshType:(WGCommonHeaderRefreshType)headerRefreshType
                         showLogo:(BOOL)showLogo
{
    [self configRefreshInScrollView:scrollView target:target action:action headerRefreshType:headerRefreshType transparent:NO showLogo:showLogo];
}

+ (void)configRefreshInScrollView:(UIScrollView *)scrollView
                           target:(id)target
                           action:(SEL)action
                headerRefreshType:(WGCommonHeaderRefreshType)headerRefreshType
                      transparent:(BOOL)transparent {
    [self configRefreshInScrollView:scrollView target:target action:action headerRefreshType:headerRefreshType transparent:transparent showLogo:NO];
}

+ (void)configRefreshInScrollView:(UIScrollView *)scrollView
                           target:(id)target
                           action:(SEL)action
                headerRefreshType:(WGCommonHeaderRefreshType)headerRefreshType
                      transparent:(BOOL)transparent
                         showLogo:(BOOL)showLogo {
    // 下拉刷新
    if ([scrollView.mj_header isKindOfClass:[WGRefreshHeader class]]) {
        [scrollView.mj_header setRefreshingTarget:target refreshingAction:action];
        [self wg_resetHeaderStateTitleWithHeader:(WGRefreshHeader *)scrollView.mj_header headerRefreshType:headerRefreshType showLogo:showLogo];
        return;
    }
    if (scrollView.mj_header) {
        [scrollView.mj_header endRefreshing];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        WGRefreshHeader *header = [WGRefreshHeader headerWithRefreshingTarget:target refreshingAction:action];
        [self wg_resetHeaderStateTitleWithHeader:header headerRefreshType:headerRefreshType showLogo:showLogo];
        scrollView.mj_header = header;
        scrollView.contentOffset = CGPointZero;
        for (UIView *view in header.subviews) {
            if (view != header.logoLabel) {
                view.hidden = transparent;
            }
        }
    });
}

+ (void)wg_resetHeaderStateTitleWithHeader:(WGRefreshHeader *)header
                         headerRefreshType:(WGCommonHeaderRefreshType)headerRefreshType
                                  showLogo:(BOOL)showLogo {
    
    if(!header || ![header isKindOfClass:WGRefreshHeader.class]) return;
    header.hidden = NO;
    header.automaticallyChangeAlpha = NO;
    if (showLogo) {
        [header addLogoImage:YES];
    } else {
        [header addLogoImage:NO];
    }
    header.isLight = headerRefreshType == WGCommonHeaderRefreshTypeWhite;
}

+ (void)wg_resetSkipHeaderStateTitleWithHeader:(WGRefreshClassifyHeader *)header {
    if(!header) return;
    header.hidden = NO;
    for (UIView *subview in header.subviews) {
        subview.hidden = NO;
    }
    header.automaticallyChangeAlpha = NO;
}

#pragma mark - footer

/********************************* 上拉加载更多 **********************************/
+ (void)configLoadMoreSkipInScrollView:(UIScrollView *)scrollView target:(id)target action:(SEL)action{
    
    if([scrollView.mj_footer isKindOfClass:WGRefreshClassifyFooter.class]){
        [scrollView.mj_footer setRefreshingTarget:target refreshingAction:action];
        [self wg_resetFooterStateWithFooter:(WGRefreshClassifyFooter *)scrollView.mj_footer scrollView:scrollView];
        return;
    }
    // 上拉加载
    if (scrollView.mj_footer) {
        [scrollView.mj_footer endRefreshing];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        WGRefreshClassifyFooter *footer = [WGRefreshClassifyFooter footerWithRefreshingTarget:target refreshingAction:action];
        [self wg_resetFooterStateWithFooter:footer scrollView:scrollView];
        scrollView.mj_footer = footer;
    });
}

+ (void)configLoadMoreInScrollView:(UIScrollView *)scrollView target:(id)target action:(SEL)action {
    
    if([scrollView.mj_footer isKindOfClass:WGRefreshFooter.class]) {
        [scrollView.mj_footer setRefreshingTarget:target refreshingAction:action];
        [self wg_resetFooterStateWithFooter:(WGRefreshFooter *)scrollView.mj_footer scrollView:scrollView];
        return;
    }
    // 上拉加载
    if (scrollView.mj_footer) {
        [scrollView.mj_footer endRefreshing];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        WGRefreshFooter *footer = [WGRefreshFooter footerWithRefreshingTarget:target refreshingAction:action];
        [self wg_resetFooterStateWithFooter:footer scrollView:scrollView];
        scrollView.mj_footer = footer;
    });
}

+ (void)wg_resetFooterStateWithFooter:(MJRefreshFooter *)footer scrollView:(UIScrollView *)scrollView {
    footer.hidden = NO;
}

@end

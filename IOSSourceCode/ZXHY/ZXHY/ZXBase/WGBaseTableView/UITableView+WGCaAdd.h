//
//  UITableView+WGCaAdd.h
//  Yunhuoyouxuan
//
//  Created by 刘俊腾 on 2020/12/2.
//  Copyright © 2020 apple. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class WGEmptyView;

@interface UITableView (WGCaAdd)


//MARK:当前页面首个Cell位于section位置
- (NSInteger)wg_getFirstVisibleCellSection;

- (CGPoint)wg_rectWithIndexPathSection:(NSInteger)section fixOffsetY:(CGFloat)fixOffsetY;

@end

NS_ASSUME_NONNULL_END

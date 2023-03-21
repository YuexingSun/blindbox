//
//  UITableView+WGCaAdd.m
//  Yunhuoyouxuan
//
//  Created by 刘俊腾 on 2020/12/2.
//  Copyright © 2020 apple. All rights reserved.
//

#import "UITableView+WGCaAdd.h"w



@implementation UITableView (WGCaAdd)


- (NSInteger)wg_getFirstVisibleCellSection
{
    NSArray <UITableViewCell *> *cellArray = [self visibleCells];
    NSInteger nowSection = -1;
    if ([cellArray count])
    {
        UITableViewCell *cell = [cellArray firstObject];
        NSIndexPath *indexPath = [self indexPathForCell:cell];
        nowSection = indexPath.section;
    }

    return nowSection;
}


- (CGPoint)wg_rectWithIndexPathSection:(NSInteger)section fixOffsetY:(CGFloat)fixOffsetY
{
    CGRect rect = [self rectForSection:section];
    CGPoint point = rect.origin;
    point.y += fixOffsetY;
    return point;
}

@end

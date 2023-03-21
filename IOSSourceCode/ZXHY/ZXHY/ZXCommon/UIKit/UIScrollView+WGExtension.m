//
//  UIScrollView+WGCaAdd.m
//  Yunhuoyouxuan
//
//  Created by 刘俊腾 on 2020/12/2.
//  Copyright © 2020 apple. All rights reserved.
//

#import "UIScrollView+WGExtension.h"

@implementation UIScrollView (WGExtension)

- (CGFloat)wg_alphaWhenScroll
{
    CGFloat offsetY = self.contentOffset.y;
    CGFloat alpha = offsetY * 1 / 136.0;
    if (alpha >= 1)
    {
        alpha = 1;
    }
    return alpha;
}

@end

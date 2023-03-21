//
//  WGBadgeButton.m
//  Yunhuoyouxuan
//
//  Created by 刘俊腾 on 2020/11/16.
//  Copyright © 2020 apple. All rights reserved.
//

#import "WGBadgeButton.h"
#import "WGBadgeView.h"


@implementation WGBadgeButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _wg_badgeView = [[WGBadgeView alloc] initWithFrame:CGRectZero];
        [self addSubview:_wg_badgeView];
    }
    return self;
}

- (void)setWg_badgeCount:(NSString *)wg_badgeCount
{
    _wg_badgeCount = wg_badgeCount;
    [_wg_badgeView wg_adjustFrameWithQuantity:_wg_badgeCount offsetY:-2 superViewFrame:self.frame isForBarButtonItem:YES];
}

@end

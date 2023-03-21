//
//  WGBaseView.m
//  Yunhuoyouxuan
//
//  Created by 刘俊腾 on 2020/10/8.
//  Copyright © 2020 apple. All rights reserved.
//

#import "WGBaseView.h"

@implementation WGBaseView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self initSubviews];
        [self makeConstraintsForSubviews];
    }
    return self;
}

- (void)initSubviews { }

- (void)makeConstraintsForSubviews { }


@end

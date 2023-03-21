//
//  WGCollectionViewCell.m
//  Yunhuoyouxuan
//
//  Created by apple on 2020/8/17.
//  Copyright © 2020 apple. All rights reserved.
//

#import "WGBaseCollectionViewCell.h"

@implementation WGBaseCollectionViewCell

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

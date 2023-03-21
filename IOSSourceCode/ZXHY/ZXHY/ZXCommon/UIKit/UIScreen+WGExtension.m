//
//  UIScreen+WGExtension.m
//  WG_Common
//
//  Created by apple on 2021/6/1.
//  Copyright © 2021 广州微革网络科技有限公司（本内容仅限于广州微革网络科技有限公司内部传阅，禁止外泄以及用于其他的商业目的）. All rights reserved.
//

#import "UIScreen+WGExtension.h"

@implementation UIScreen (WGExtension)

+ (UIEdgeInsets)safeAreaEdgeInsets {
    static UIEdgeInsets safeAreaEdgeInsets;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 11, *)) { safeAreaEdgeInsets = [UIApplication sharedApplication].keyWindow.safeAreaInsets; }
    });
    return safeAreaEdgeInsets;
}

+ (CGFloat)safeAreaTop {
    return [UIScreen safeAreaEdgeInsets].top;
}

+ (CGFloat)safeAreaLeft {
    return [UIScreen safeAreaEdgeInsets].left;
}

+ (CGFloat)safeAreaBottom {
    return [UIScreen safeAreaEdgeInsets].bottom;
}

+ (CGFloat)safeAreaRight {
    return [UIScreen safeAreaEdgeInsets].right;
}


@end

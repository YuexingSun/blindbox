//
//  YYAnimatedImageView+Extension.m
//  Yunhuoyouxuan
//
//  Created by admin on 2020/11/11.
//  Copyright © 2020 apple. All rights reserved.
//

#import "YYAnimatedImageView+Extension.h"
#import <objc/runtime.h>

@implementation YYAnimatedImageView (Extension)

+(void)load
{
    Method method1 = class_getInstanceMethod(self, @selector(displayLayer:));
    Method method2 = class_getInstanceMethod(self, @selector(dx_displayLayer:));
    method_exchangeImplementations(method1, method2);
}

-(void)dx_displayLayer:(CALayer *)layer {
    
    //通过变量名称获取类中的实例成员变量
    Ivar ivar = class_getInstanceVariable(self.class, "_curFrame");
    UIImage *_curFrame = object_getIvar(self, ivar);

    if (_curFrame) {
        layer.contents = (__bridge id)_curFrame.CGImage;
    } else {
        if (@available(iOS 14.0, *)) {
            [super displayLayer:layer];
        }
    }
}

@end

//
//  CALayer+WGCaAdd.h
//  Yunhuoyouxuan
//
//  Created by liaoqijin on 2021/4/21.
//  Copyright © 2021 apple. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (WGExtension)

//虚线框
+ (CALayer *)wg_drawDashRect:(CGRect)rect
                lineColor:(UIColor *)color
             cornerRadius:(CGFloat)radius
                     dash:(NSArray<NSNumber *>*)dash
                lineWidth:(CGFloat)lineWidth;

//虚线
+ (CALayer *)wg_drawDashLine:(CGRect)rect
                lineColor:(UIColor *)color
                horizonal:(BOOL)isHorizonal
                     dash:(NSArray<NSNumber *>*)dash
                lineWidth:(CGFloat)lineWidth;

//添加分割线
+ (CALayer *)wg_addLine:(CGRect)rect lineColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END

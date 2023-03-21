//
//  CALayer+WGCaAdd.m
//  Yunhuoyouxuan
//
//  Created by liaoqijin on 2021/4/21.
//  Copyright © 2021 apple. All rights reserved.
//

#import "CALayer+WGExtension.h"

@implementation CALayer (WGExtension)

//虚线框
+ (CALayer *)wg_drawDashRect:(CGRect)rect
                lineColor:(UIColor *)color
             cornerRadius:(CGFloat)radius
                     dash:(NSArray<NSNumber *>*)dash
                lineWidth:(CGFloat)lineWidth{
  
  CAShapeLayer *borderLayer = [CAShapeLayer layer];
  borderLayer.frame = rect;
  borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:borderLayer.bounds cornerRadius:radius].CGPath;
  borderLayer.lineWidth = lineWidth;
  borderLayer.lineDashPattern = dash;
  borderLayer.fillColor = [UIColor clearColor].CGColor;
  borderLayer.strokeColor = color.CGColor;
  return borderLayer;
}

//虚线
+ (CALayer *)wg_drawDashLine:(CGRect)rect
                lineColor:(UIColor *)color
                horizonal:(BOOL)isHorizonal
                     dash:(NSArray<NSNumber *>*)dash
                lineWidth:(CGFloat)lineWidth{
  
  CAShapeLayer *borderLayer = [CAShapeLayer layer];
  borderLayer.frame = rect;
  borderLayer.lineWidth = lineWidth;
  borderLayer.lineDashPattern = dash;
  borderLayer.fillColor = [UIColor clearColor].CGColor;
  borderLayer.strokeColor = color.CGColor;
  borderLayer.lineJoin = kCALineJoinRound;
  
  CGMutablePathRef path = CGPathCreateMutable();
  if (isHorizonal) {
    CGPathMoveToPoint(path, NULL, 0, rect.size.height);
    CGPathAddLineToPoint(path, NULL,CGRectGetWidth(rect), rect.size.height);
  } else {
    CGPathMoveToPoint(path, NULL, rect.size.width, 0);
    CGPathAddLineToPoint(path, NULL, rect.size.width, CGRectGetHeight(rect));
  }
  borderLayer.path = path;
  CGPathRelease(path);
  return borderLayer;
}

//添加分割线
+ (CALayer *)wg_addLine:(CGRect)rect lineColor:(UIColor *)color{
  CALayer *layer = [CALayer layer];
  layer.frame = rect;
  layer.backgroundColor = color.CGColor;
  return layer;
}


@end

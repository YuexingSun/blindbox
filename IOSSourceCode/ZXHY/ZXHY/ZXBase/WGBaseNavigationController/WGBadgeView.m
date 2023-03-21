//
//  WGBadgeView.m
//  Yunhuoyouxuan
//
//  Created by 刘俊腾 on 2020/10/14.
//  Copyright © 2020 apple. All rights reserved.
//

#import "WGBadgeView.h"

#import "UIColor+WGExtension.h"
#import "NSString+WGExtension.h"

const CGFloat WGNumBadgeSizeLength = 18;
const NSInteger WGTagBadgeView = 111116;

@implementation WGBadgeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor wg_colorWithHexString:@"#FF445E"];
        self.tag = WGTagBadgeView;
        [self wg_initTextLabel];
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)wg_initTextLabel
{
    if (!_wg_textLabel)
    {
        _wg_textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _wg_textLabel.backgroundColor = [UIColor clearColor];
        _wg_textLabel.font = [UIFont systemFontOfSize:11];
        _wg_textLabel.textColor = UIColor.whiteColor;
        _wg_textLabel.textAlignment = NSTextAlignmentCenter;
    }
    if (![self.subviews containsObject:_wg_textLabel])
    {
        [self addSubview:_wg_textLabel];
    }
}

- (void)setWg_text:(NSString *)wg_text
{
    if (![wg_text wg_isNumberInteger])
    {
        self.hidden = NO;
        _wg_text = wg_text;
    }
    else
    {
        if ([wg_text integerValue] > 99)
        {
            _wg_text = @"99+";
        }
        else
        {
            _wg_text = wg_text;
        }
        
        if (![_wg_text length] ||
            ([wg_text integerValue] <= 0))
        {
            self.hidden = YES;
        }
        else
        {
            self.hidden = NO;
        }
    }
    _wg_textLabel.text = _wg_text;
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _wg_textLabel.frame = self.bounds;
}

- (void)sizeToFit
{
    [super sizeToFit];
    [_wg_textLabel sizeToFit];
    
    NSString *text = _wg_textLabel.text;
    
    CGFloat textLabelWidth = _wg_textLabel.frame.size.width + 8;
    CGFloat width = WGNumBadgeSizeLength;
    if ([text length] > 1)
    {
        width = textLabelWidth;
    }
    
    CGRect frame = self.frame;
    frame.size.width = width;
    frame.size.height = WGNumBadgeSizeLength;
    self.frame = frame;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.frame.size.height / 2;
    self.layer.borderWidth = 1;
    self.layer.borderColor = UIColor.whiteColor.CGColor;
}

- (void)wg_adjustFrameWithQuantity:(NSString *)quantity offsetY:(CGFloat)offsetY superViewFrame:(CGRect)superViewFrame
{
    [self wg_adjustFrameWithQuantity:quantity offsetY:offsetY superViewFrame:superViewFrame isForBarButtonItem:NO];
}

- (void)wg_adjustFrameWithQuantity:(NSString *)quantity offsetY:(CGFloat)offsetY superViewFrame:(CGRect)superViewFrame isForBarButtonItem:(BOOL)isForBarButtonItem
{
    [self wg_adjustFrameWithQuantity:quantity offsetX:0 offsetY:offsetY superViewFrame:superViewFrame isForBarButtonItem:isForBarButtonItem];
}

- (void)wg_adjustFrameWithQuantity:(NSString *)quantity offsetX:(CGFloat)offsetX offsetY:(CGFloat)offsetY superViewFrame:(CGRect)superViewFrame isForBarButtonItem:(BOOL)isForBarButtonItem
{
    self.wg_text = quantity;
    [self sizeToFit];

    CGFloat percentX = (1 + 0.53) / 3;
    CGFloat x = ceilf(percentX * superViewFrame.size.width);
    if (isForBarButtonItem &&
        ([_wg_text length] > 2))
    {
        x = superViewFrame.size.width + 12 - self.frame.size.width;
    }
    x = x - ceilf(offsetX);
    
    CGFloat y = ceilf(offsetY);
    self.frame = CGRectMake(x, y, self.frame.size.width, self.frame.size.height);
}

- (void)wg_adjustSubView:(UITabBar *)tabbar index:(NSInteger)index num:(NSString *)num{
    
    self.wg_text = num;
    
    self.hidden = NO;
    if (![_wg_text length] || [_wg_text isEqualToString:@"0"]){
        self.hidden = YES;
    } else {
        [self sizeToFit];
        CGFloat width  = tabbar.frame.size.width / tabbar.items.count;
        self.frame  = CGRectMake(index * width + (width /2) , 0, self.frame.size.width, self.frame.size.height);

        [self.superview bringSubviewToFront:self];
    }
}


- (void)wg_setBagdeValues:(NSString *)values{
    
    self.wg_text = values;
    
    self.hidden = NO;
    if (![_wg_text length] || [_wg_text isEqualToString:@"0"]){
        self.hidden = YES;
    } else {
        [self sizeToFit];
        [self.superview bringSubviewToFront:self];
    }
}

@end

//
//  WGBaseTableView.m
//  Yunhuoyouxuan
//
//  Created by 刘俊腾 on 2020/10/7.
//  Copyright © 2020 apple. All rights reserved.
//

#import "WGBaseTableView.h"


#import "UITableView+WGCaAdd.h"


@implementation WGBaseTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        [self setBackgroundColor:WGClrCommonBackground()];
        [self wg_addObserver];
    }
    return self;
}

- (void)wg_addObserver
{
    
}

- (void)dealloc
{
    [WGNotification removeObserver:self];
}

- (void)wg_initBaseTableViewEmptyViewWithImageName:(NSString *)imageName tips:(NSString *)tips reloadDataText:(NSString *)reloadDataText
{
    _wg_needEmptyView = YES;
}

- (void)wg_initBaseTableViewLogoEmptyViewWithImageName:(NSString *)imageName tips:(NSString *)tips reloadDataText:(NSString *)reloadDataText
{
    _wg_needEmptyView = YES;
}

- (void)reloadData
{
    [super reloadData];
    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"MAMapView"]) {
        return NO;      //关闭手势
    }
    return YES;
}



////允许多个手势
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return YES;
//}
@end

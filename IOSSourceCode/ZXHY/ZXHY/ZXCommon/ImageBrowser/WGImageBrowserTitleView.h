//
//  WGImageBrowserToolsView.h
//  Yunhuoyouxuan
//
//  Created by admin on 2020/11/15.
//  Copyright © 2020 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WGImageBrowserTitleView : UIView

@property (nonatomic, copy) void(^titleViewCloseBlock)(void);

- (void)setText:(NSString *)text;

- (void)updateLayout:(CGSize)size padding:(UIEdgeInsets)padding;

@end

NS_ASSUME_NONNULL_END

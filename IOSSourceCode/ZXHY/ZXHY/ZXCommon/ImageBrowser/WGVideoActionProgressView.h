//
//  WGVideoActionProgressView.h
//  Yunhuoyouxuan
//
//  Created by admin on 2020/12/12.
//  Copyright © 2020 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WGVideoActionProgressView : UIView

- (void)setPlayerProgress:(CGFloat)playerProgress;

- (void)setLoadedProgress:(CGFloat)loadedProgress;

@end

NS_ASSUME_NONNULL_END

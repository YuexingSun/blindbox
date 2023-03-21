//
//  ZXMapNavViewController.h
//  ZXHY
//
//  Created by Bern Lin on 2021/11/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZXOpenResultsModel;

@interface ZXMapNavViewController : UIViewController

//传入模型
- (void)zx_openResultslnglatModel:(ZXOpenResultsModel *)openResultsModel;

@end

NS_ASSUME_NONNULL_END

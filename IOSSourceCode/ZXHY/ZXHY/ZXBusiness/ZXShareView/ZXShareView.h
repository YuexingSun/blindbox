//
//  ZXShareView.h
//  ZXHY
//
//  Created by Bern Lin on 2021/12/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZXShareView;

@protocol ZXShareViewDelegate <NSObject>

//关闭分享页
- (void)zx_closeShareView:(ZXShareView *)shareView;

//选中Item
- (void)zx_shareView:(ZXShareView *)shareView SelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ZXShareView : UIView

@property (nonatomic, weak) id <ZXShareViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

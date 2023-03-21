//
//  ZXHomeTopAdHeaderView.h
//  ZXHY
//
//  Created by Bern Lin on 2022/3/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZXHomeTopAdHeaderView;

@protocol ZXHomeTopAdHeaderViewDelegate <NSObject>

//高度返回
- (void)homeTopAdHeaderView:(ZXHomeTopAdHeaderView *)topAdHeaderView returnViewHeight:(CGFloat)viewHeight;

@end

@interface ZXHomeTopAdHeaderView : UIView

@property (nonatomic, weak) id  <ZXHomeTopAdHeaderViewDelegate> delegate;;

@end

NS_ASSUME_NONNULL_END

//
//  WGScrollPageView.h
//  Yunhuoyouxuan
//
//  Created by admin on 2020/11/5.
//  Copyright © 2020 apple. All rights reserved.
//

#import "WGBaseView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, WGScrollPageViewStyle) {
    WGScrollPageViewStyleCenterShow,
    WGScrollPageViewStyleLeftShow
};
@protocol WGScrollPageViewDelegate <NSObject>

- (void)scrollToItemIndex:(NSInteger)index selectItemController:(UIViewController *)selectItemController;

@end

@interface WGScrollPageView : WGBaseView

@property (nonatomic, strong) UIView *itemHeaderView;

@property (nonatomic, copy) void(^itemBtBlock)(NSInteger index);

@property (nonatomic, weak) id<WGScrollPageViewDelegate> delegate;

@property (nonatomic, assign) BOOL showAllTitle;//展示全部title的字符串
@property (nonatomic, assign) CGFloat titleFontSize;
@property (nonatomic, strong) UIColor *titleSelectedColor;
@property (nonatomic, strong) UIColor *titleNormalColor;
@property (nonatomic, assign) WGScrollPageViewStyle scrollPageViewStyle;



- (instancetype)initWithFrame:(CGRect)frame
                    andRootVc:(UIViewController *)rootVc
                  andTitleArr:(NSArray<NSString *> *)titleArr
                     andVcArr:(NSArray<UIViewController *> *)vcArr
                        style:(WGScrollPageViewStyle)showStyle;


- (void)setTitleFont:(UIFont *)font;

- (void)scrollToPageIndex:(NSInteger)pageIndex;

- (NSArray<UIViewController *>*)getChildVcArr;

- (void)setHideTopLineView:(BOOL)hide;//是否隐藏底部灰色分割线

- (UIButton *)getItemButtonIndex:(NSInteger)index;

- (void)refreshScrollPageView;//设置完showAllTitle、titleFontSize、titleSelectedColor、titleNormalColor等参数后，需要调这个接口刷新

@end

NS_ASSUME_NONNULL_END














//
//  WGBaseTabBar.m
//  Yunhuoyouxuan
//
//  Created by Bern on 2021/4/28.
//  Copyright © 2021 apple. All rights reserved.
//

#import "WGBaseTabBar.h"
#import "WGTabBarItem.h"
#import "WGTabBarModel.h"



@interface WGBaseTabBar()

@property (nonatomic, strong) NSMutableArray *tabbarItemArr;
@property (nonatomic, strong) UIView *tabbarBgView;
//@property (nonatomic, strong) WGTarBarItem *lasSelectedTabbarItem;

@end

@implementation WGBaseTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (NSMutableArray *)tabbarItemArr{
    if (!_tabbarItemArr){
        _tabbarItemArr = [NSMutableArray array];
    }
    return _tabbarItemArr;
}


#pragma mark - 赋值tabbarArray
- (void)setTabbarArray:(NSArray<WGTabBarModel *> *)tabbarArray{
    if (!tabbarArray.count) return;
    
    _tabbarArray = tabbarArray;
    
    CGFloat tabbarItemW = WGNumScreenWidth()/tabbarArray.count;
    CGFloat tabbarItemH = self.frame.size.height;
    for (int i = 0; i < tabbarArray.count; i++) {
        WGTabBarModel *tabBarModel = [tabbarArray wg_safeObjectAtIndex:i];
        
        WGTabBarItem *tabbarItem = [[WGTabBarItem alloc] initWithFrame: CGRectMake(i * tabbarItemW, 0, tabbarItemW, tabbarItemH)];
        tabbarItem.tabBarModel = tabBarModel;
        tabbarItem.tag = i;
        [self addSubview:tabbarItem];
       
        //添加点击事件
        [tabbarItem addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabBarItemTap:)]];
        [self.tabbarItemArr addObject:tabbarItem];
    }

}

#pragma mark - 点击事件
- (void)tabBarItemTap:(UITapGestureRecognizer *)recognizer{
    
    WGTabBarItem *tabbarItem = (WGTabBarItem *)recognizer.view;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(wgtabBar:didSelectItem:)]) {
        [self.delegate wgtabBar:self didSelectItem:tabbarItem.tabBarModel];
    }
    
    for (int i = 0; i < self.tabbarArray.count; i++){
        WGTabBarModel *tabBarModel = [self.tabbarArray wg_safeObjectAtIndex:i];
        tabBarModel.isSelected = NO;
        if (tabbarItem.tabBarModel.tabType == tabBarModel.tabType){
            tabBarModel.isSelected = YES;
        }
        
        WGTabBarItem *tabbarListItem = [self.tabbarItemArr wg_safeObjectAtIndex:i];
        tabbarListItem.tabBarModel   = tabBarModel;
    }
}


#pragma mark - 选中的Item
- (void)setSelectedTabType:(WGTabBarType)selectedTabType{
    
    for (int i = 0; i < self.tabbarArray.count; i++){
        WGTabBarModel *tabBarModel = [self.tabbarArray wg_safeObjectAtIndex:i];
        tabBarModel.isSelected = NO;
        if (selectedTabType == tabBarModel.tabType){
            tabBarModel.isSelected = YES;
        }
        
        WGTabBarItem *tabbarListItem = [self.tabbarItemArr wg_safeObjectAtIndex:i];
        tabbarListItem.tabBarModel   = tabBarModel;
    }
}


@end








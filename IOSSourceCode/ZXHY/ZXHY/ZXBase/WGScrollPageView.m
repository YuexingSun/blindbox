//
//  WGScrollPageView.m
//  Yunhuoyouxuan
//
//  Created by admin on 2020/11/5.
//  Copyright © 2020 apple. All rights reserved.
//

#import "WGScrollPageView.h"
 

@interface WGScrollPageView()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *titleArr;

@property (nonatomic, strong) NSArray<UIViewController *> *vcArr;

@property (nonatomic, strong) UIScrollView *itemScrollView;
@property (nonatomic, strong) UIView *itemScrollLineView;
@property (nonatomic, strong) NSMutableArray *muItemButtonArr;

@property (nonatomic, strong) UIView *topGrayLineView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, weak) UIViewController *rootVc;

@property (nonatomic, weak) UIViewController *currentShowVc;

@end

static CGFloat const itemHeight = 44;
static CGFloat const beyondCount = 5;

@implementation WGScrollPageView

- (instancetype)initWithFrame:(CGRect)frame
                    andRootVc:(UIViewController *)rootVc
                  andTitleArr:(NSArray<NSString *> *)titleArr
                     andVcArr:(NSArray<UIViewController *> *)vcArr style:(WGScrollPageViewStyle)showStyle {
    
    if(self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, WGNumScreenWidth(), frame.size.height)]){
        
        _titleArr = [titleArr copy];
        _vcArr = [vcArr copy];
        _rootVc = rootVc;
        _scrollPageViewStyle = showStyle;
        [self setupUI];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
//    self.scrollView.frame = CGRectMake(0, itemHeight, WGNumScreenWidth(), self.frame.size.height-itemHeight);
}

- (void)setupUI{
    
    if(!self.titleArr.count || !self.vcArr.count) return;
    [self addSubview:self.itemHeaderView];
    [self addSubview:self.scrollView];
}

#pragma mark Lazy
- (UIScrollView *)itemScrollView{
    
    if(!_itemScrollView){
        
        CGFloat width = WGNumScreenWidth();
        CGFloat itemWidth;
        if (_scrollPageViewStyle == WGScrollPageViewStyleCenterShow) {
             itemWidth = width/self.titleArr.count;
        }else{
             itemWidth = 80;
        }
        
        if(self.titleArr.count > beyondCount){
            itemWidth = width/beyondCount;
        }
        
        _itemScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, itemHeight)];
        _itemScrollView.backgroundColor = [UIColor clearColor];
        _itemScrollView.contentSize = CGSizeMake(itemWidth*self.titleArr.count, 0);
        _itemScrollView.delegate = self;
        _itemScrollView.showsVerticalScrollIndicator = NO;
        _itemScrollView.showsHorizontalScrollIndicator = NO;
        if(self.titleArr.count > beyondCount){
            
            _itemScrollView.bounces = YES;
        }else{
            
            _itemScrollView.bounces = NO;
        }
        
        [self.muItemButtonArr removeAllObjects];
        
        for(int i = 0; i < self.titleArr.count; i++){
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:[self.titleArr wg_safeObjectAtIndex:i] forState:UIControlStateNormal];
            button.frame = CGRectMake(itemWidth*i, 0, itemWidth, itemHeight);
            [button setTitleColor:[UIColor wg_colorWithHexString:@"#ABABAB"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor wg_colorWithHexString:@"#3C3C3C"] forState:UIControlStateSelected];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            button.tag = 9091+i;
            [button addTarget:self action:@selector(itemBtClick:) forControlEvents:UIControlEventTouchUpInside];
            [_itemScrollView addSubview:button];
            if(i == 0) button.selected = YES;
            [self.muItemButtonArr wg_safeAddObject:button];
        }
    }
    return _itemScrollView;
}

- (NSMutableArray *)muItemButtonArr{
    
    if(!_muItemButtonArr){
        _muItemButtonArr = [NSMutableArray array];
    }
    return _muItemButtonArr;
}

- (UIView *)itemHeaderView{
    
    if(!_itemHeaderView){
        _itemHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WGNumScreenWidth(), itemHeight)];
        _itemHeaderView.backgroundColor = [UIColor clearColor];
        [_itemHeaderView addSubview:self.itemScrollView];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, itemHeight-0.4, WGNumScreenWidth(), 0.4)];
        lineView.backgroundColor = [UIColor wg_colorWithHexString:@"#ABABAB"];
        [_itemHeaderView addSubview:lineView];
        _topGrayLineView = lineView;
        
        [self.itemScrollView addSubview:self.itemScrollLineView];
        
    }
    return _itemHeaderView;
}

- (UIView *)itemScrollLineView{
    
    if(!_itemScrollLineView){
        
        CGFloat itemWidth = WGNumScreenWidth()/self.titleArr.count;
        CGFloat lineWidth = 24;
        CGFloat lineHeight = 4;
        _itemScrollLineView = [[UIView alloc] initWithFrame:CGRectMake((itemWidth-lineWidth)/2.0, itemHeight-lineHeight-4, lineWidth, lineHeight)];
        _itemScrollLineView.backgroundColor = [UIColor wg_colorWithHexString:@"#FF445E"];
        _itemScrollLineView.layer.cornerRadius = 2;
    }
    return _itemScrollLineView;
}

- (UIScrollView *)scrollView{
    
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, itemHeight, WGNumScreenWidth(), self.frame.size.height-itemHeight)];
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(WGNumScreenWidth()*self.titleArr.count, 0);
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        UIViewController *firstVc = [self.vcArr firstObject];
        firstVc.view.frame = CGRectMake(0, 0, WGNumScreenWidth(), self.frame.size.height-itemHeight);
        [self.rootVc addChildViewController:firstVc];
        [self.scrollView addSubview:firstVc.view];
        [firstVc didMoveToParentViewController:self.rootVc];
        _currentShowVc = firstVc;
        
    }
    return _scrollView;
}

- (void)addChildVCIndex:(NSInteger)index{
    
    UIViewController *childVc = [self.vcArr wg_safeObjectAtIndex:index];
    BOOL isExist = NO;
    for (UIViewController *vc in self.rootVc.childViewControllers) {
        
        if(childVc == vc){
            isExist = YES;
            break;
        }
    }
    
    if(!isExist){
        
        [self.rootVc addChildViewController:childVc];
        childVc.view.frame = CGRectMake(WGNumScreenWidth()*index, 0, WGNumScreenWidth(), self.frame.size.height-itemHeight);
        [self.scrollView addSubview:childVc.view];
        [childVc didMoveToParentViewController:self.rootVc];
    }
    
    if(self.delegate &&
       [self.delegate respondsToSelector:@selector(scrollToItemIndex:selectItemController:)] &&
       childVc != _currentShowVc){
        [self.delegate scrollToItemIndex:index selectItemController:childVc];
    }
    _currentShowVc = childVc;
}

- (void)scrollToPageIndex:(NSInteger)pageIndex{
    
    if(pageIndex >= self.muItemButtonArr.count || pageIndex < 0) return;
    UIButton *button = [self.muItemButtonArr wg_safeObjectAtIndex:pageIndex];
    [self itemBtClick:button];
}

- (NSArray<UIViewController *> *)getChildVcArr{
    
    return self.vcArr;
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if(scrollView == self.scrollView){
        CGFloat px = scrollView.contentOffset.x;
        NSInteger index = px / WGNumScreenWidth();
        [self addChildVCIndex:index];
        [self setSelectedIndex:index];
    }
}

#pragma mark - onClick
- (void)itemBtClick:(UIButton *)button{
    
    WGLog(@"%ld",button.tag);
    NSInteger index = button.tag - 9091;
    [self.scrollView setContentOffset:CGPointMake(WGNumScreenWidth()*index, 0)];
    [self addChildVCIndex:index];
    [self setSelectedIndex:index];
    if(self.itemBtBlock) self.itemBtBlock(index);
}

- (void)setSelectedIndex:(NSInteger)index{
    
    for (UIButton *button in self.muItemButtonArr) {
        
        button.selected = NO;
    }
    UIButton *button = [self.muItemButtonArr wg_safeObjectAtIndex:index];
    button.selected = YES;
    
    CGFloat width = WGNumScreenWidth();
    CGFloat itemWidth;
    if (_scrollPageViewStyle == WGScrollPageViewStyleCenterShow) {
         itemWidth = width/self.titleArr.count;
    }else{
         itemWidth = 80;
    }
    if(self.titleArr.count > beyondCount){
        itemWidth = width/beyondCount;
    }
    
    
    if (self.showAllTitle) {
        [UIView animateWithDuration:0.2 animations:^{
            self.itemScrollLineView.center = CGPointMake(button.center.x, self.itemScrollLineView.center.y);
        }];
        
        if (self.itemScrollView.bounces) {
            CGFloat leftGap = (WGNumScreenWidth() - button.frame.size.width) * 0.5;
            CGFloat contentOffsetX = button.frame.origin.x - leftGap;
            if (contentOffsetX + WGNumScreenWidth() > self.itemScrollView.contentSize.width) {
                contentOffsetX = self.itemScrollView.contentSize.width - WGNumScreenWidth();
            } else if(contentOffsetX < 0) {
                contentOffsetX = 0;
            }
            
            [self.itemScrollView setContentOffset:CGPointMake(contentOffsetX, 0) animated:YES];
        }
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            
            CGRect rect = self.itemScrollLineView.frame;
            rect.origin.x = itemWidth*(index+1)-(itemWidth-rect.size.width)/2.0-rect.size.width;
            self.itemScrollLineView.frame = rect;
        }];
        
        if(self.titleArr.count > beyondCount && index >= beyondCount-1){
            
            if(index < self.titleArr.count-1){
                
                [self.itemScrollView setContentOffset:CGPointMake(itemWidth*(index-3), 0) animated:YES];
            }else if(index == self.titleArr.count-1 && self.itemScrollView.contentOffset.x == 0){
                
                [self.itemScrollView setContentOffset:CGPointMake(itemWidth*(index-4), 0) animated:YES];
            }
        }else{
            
            [self.itemScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
}

#pragma mark - out
- (void)setTitleFont:(UIFont *)font{
    
    if(!self.muItemButtonArr.count || !font) return;
    for (UIButton *button in self.muItemButtonArr) {
        button.titleLabel.font = font;
    }
}

- (void)setHideTopLineView:(BOOL)hide{
    
    self.topGrayLineView.hidden = hide;
}

- (void)setItemHeaderViewBackGroundColor:(UIColor *)backGroundColor{
    
    self.itemHeaderView.backgroundColor = backGroundColor;
}

- (UIButton *)getItemButtonIndex:(NSInteger)index{
    
    if(index >= _muItemButtonArr.count) return nil;
    return [_muItemButtonArr wg_safeObjectAtIndex:index];
}

- (void)refreshScrollPageView
{
    CGFloat buttonX = 0;
    CGFloat buttonW = 0;
    
    for (int i = 0; i< self.muItemButtonArr.count; i++) {
        NSString *title = [self.titleArr wg_safeObjectAtIndex:i];
        UIButton *button = [self.muItemButtonArr wg_safeObjectAtIndex:i];
        
        if (self.titleFontSize) {
            button.titleLabel.font = [UIFont systemFontOfSize:self.titleFontSize];
        }
        
        if (self.titleSelectedColor) {
            [button setTitleColor:self.titleSelectedColor forState:UIControlStateSelected];
        }
        
        if (self.titleNormalColor) {
            [button setTitleColor:self.titleNormalColor forState:UIControlStateNormal];
        }
        
        if (self.showAllTitle) {
            buttonW = [title widthForFont:button.titleLabel.font] + 24.0;
            
            CGRect frame = button.frame;
            frame.origin.x = buttonX;
            frame.size.width = buttonW;
            button.frame = frame;
            
            buttonX += buttonW;
            
            if (i == self.muItemButtonArr.count - 1) {
                _itemScrollView.contentSize = CGSizeMake(buttonX, 0);
                
                if(buttonX > WGNumScreenWidth()){
                    _itemScrollView.bounces = YES;
                }else{
                    _itemScrollView.bounces = NO;
                }
            }
            
            if (i == 0) {
                self.itemScrollLineView.center = CGPointMake(button.center.x, self.itemScrollLineView.center.y);
            }
        }
    }
}

@end

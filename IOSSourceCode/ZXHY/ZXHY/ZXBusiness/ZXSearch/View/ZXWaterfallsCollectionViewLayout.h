//
//  ZXWaterfallsCollectionViewLayout.h
//  ZXHY
//
//  Created by Bern Lin on 2022/1/5.
//

#import <UIKit/UIKit.h>

@class ZXWaterfallsCollectionViewLayout;

NS_ASSUME_NONNULL_BEGIN

@protocol ZXWaterfallsCollectionViewLayoutDelegate <NSObject>

@required

//计算item高度的代理方法，将item的高度与indexPath传递给外界
- (CGFloat)zx_waterfallLayout:(ZXWaterfallsCollectionViewLayout *)waterfallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath;

//计算header高度的代理方法，将header的高度与indexPath传递给外界
- (CGSize)zx_waterfallLayout:(ZXWaterfallsCollectionViewLayout *)waterfallLayout HeaderViewSizeAtIndexPath:(NSIndexPath *)indexPath;

//计算footer高度的代理方法，将header的高度与indexPath传递给外界
- (CGSize)zx_waterfallLayout:(ZXWaterfallsCollectionViewLayout *)waterfallLayout FooterViewSizeAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ZXWaterfallsCollectionViewLayout : UICollectionViewLayout

//总列数，默认是2
@property (nonatomic, assign) NSInteger columnCount;

//列间距，默认是0
@property (nonatomic, assign) NSInteger columnSpacing;

//行间距，默认是0
@property (nonatomic, assign) NSInteger rowSpacing;

//section到collectionView的边距 ，默认是（0，0，0，0）
@property (nonatomic, assign) UIEdgeInsets sectionInset;


//同时设置列间距，行间距，sectionInset
- (void)setColumnSpacing:(NSInteger)columnSpacing rowSpacing:(NSInteger)rowSepacing sectionInset:(UIEdgeInsets)sectionInset;



/**
 以下代理属性与block属性二选一，用来设置每一个item的高度
 会将item的宽度与indexPath传递给外界
 如果两个都设置，block的优先级高，即代理无效
 */

//代理，用来计算item的高度
@property (nonatomic, weak) id<ZXWaterfallsCollectionViewLayoutDelegate> delegate;


#pragma mark- 构造方法
+ (instancetype)zx_waterFallLayoutWithColumnCount:(NSInteger)columnCount;
- (instancetype)initWithColumnCount:(NSInteger)columnCount;

@end

NS_ASSUME_NONNULL_END

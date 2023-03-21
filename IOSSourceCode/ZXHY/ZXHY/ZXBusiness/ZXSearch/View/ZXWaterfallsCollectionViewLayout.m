//
//  ZXWaterfallsCollectionViewLayout.m
//  ZXHY
//
//  Created by Bern Lin on 2022/1/5.
//

#import "ZXWaterfallsCollectionViewLayout.h"

@interface ZXWaterfallsCollectionViewLayout()

//用来记录多组组头加起来的高度
@property (nonatomic, assign) CGFloat  mutableSectionMaxHeight;
//用来记录多组组尾加起来的高度
@property (nonatomic, assign) CGFloat  sectionFooterHeight;

//用来记录每一列的最大y值
@property (nonatomic, strong) NSMutableDictionary *maxYDic;
//保存每一个item的attributes
@property (nonatomic, strong) NSMutableArray *attributesArray;

@end

@implementation ZXWaterfallsCollectionViewLayout

#pragma mark-  构造方法
- (instancetype)init {
    if (self = [super init]) {
        self.columnCount = 2;
    }
    return self;
}

- (instancetype)initWithColumnCount:(NSInteger)columnCount{
    
    if (self = [super init]) {
        self.columnCount = columnCount;
    }
    return self;
}


+ (instancetype)zx_waterFallLayoutWithColumnCount:(NSInteger)columnCount {
    return [[self alloc] initWithColumnCount:columnCount];
}

#pragma mark - Private Method
//同时设置列间距，行间距，sectionInset
- (void)setColumnSpacing:(NSInteger)columnSpacing rowSpacing:(NSInteger)rowSepacing sectionInset:(UIEdgeInsets)sectionInset{
    self.columnSpacing = columnSpacing;
    self.rowSpacing = rowSepacing;
    self.sectionInset = sectionInset;
}


#pragma mark- Layout
//布局前的准备工作
- (void)prepareLayout {
    
    [super prepareLayout];
    
    [self.attributesArray removeAllObjects];
    
    //初始化字典，有几列就有几个键值对，key为列，value为列的最大y值，初始值为上内边距
    for (int i = 0; i < self.columnCount; i++) {
        self.maxYDic[@(i)] = @(self.sectionInset.top);
    }

   

    //根据collectionView获取总共有多少个Header
//    NSInteger headerCount = self.collectionView.numberOfSections;
//    for (int i = 0; i < headerCount; i++) {
//
//
//    }
    
    //头部视图
    UICollectionViewLayoutAttributes * layoutHeader = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
     [self.attributesArray addObject:layoutHeader];
    
    //尾部部视图
    UICollectionViewLayoutAttributes * layoutFooter = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
     [self.attributesArray addObject:layoutFooter];
    
    
    
    
    //根据collectionView获取总共有多少个item
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    //为每一个item创建一个attributes并存入数组
    for (int i = 0; i < itemCount; i++) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [self.attributesArray addObject:attributes];
    }
    
    
}

//计算collectionView的contentSize
- (CGSize)collectionViewContentSize {
    
    __block NSNumber *maxIndex = @0;
   
    [self.maxYDic enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSNumber *obj, BOOL *stop) {
        if ([self.maxYDic[maxIndex] floatValue] < obj.floatValue) {
            maxIndex = key;
        }
    }];
    
    //包括段头headerView的高度
//       return CGSizeMake(0, [self.maxYDict[maxColumn] floatValue] + self.sectionInset.bottom + self.headerReferenceSize.height );
    
    //collectionView的contentSize.height就等于最长列的最大y值+下内边距
    return CGSizeMake(0, [self.maxYDic[maxIndex] floatValue] + self.sectionInset.bottom + self.mutableSectionMaxHeight + self.sectionFooterHeight);
}



- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    //根据indexPath获取item的attributes
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //获取collectionView的宽度
    CGFloat collectionViewWidth = self.collectionView.frame.size.width;
    
    //item的宽度 = (collectionView的宽度 - 内边距与列间距) / 列数
    CGFloat itemWidth = (collectionViewWidth - self.sectionInset.left - self.sectionInset.right - (self.columnCount - 1) * self.columnSpacing) / self.columnCount;
    
    CGFloat itemHeight = 0;
    //获取item的高度，由外界计算得到
    if ([self.delegate respondsToSelector:@selector(zx_waterfallLayout:itemHeightForWidth:atIndexPath:)]){
        itemHeight = [self.delegate zx_waterfallLayout:self itemHeightForWidth:itemWidth atIndexPath:indexPath];
    }
    
    
    //找出最短的那一列
    __block NSNumber *minIndex = @0;
    [self.maxYDic enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSNumber *obj, BOOL *stop) {
        if ([self.maxYDic[minIndex] floatValue] > obj.floatValue) {
            minIndex = key;
        }
    }];
    
    //根据最短列的列数计算item的x值
    CGFloat itemX = self.sectionInset.left + (self.columnSpacing + itemWidth) * minIndex.integerValue;
    
    //item的y值 = 最短列的最大y值 + 行间距
    CGFloat itemY = [self.maxYDic[minIndex] floatValue] + self.rowSpacing;
    
    //设置attributes的frame (Y 更改为组头高度 + 原本itemY )
    attributes.frame = CGRectMake(itemX, self.mutableSectionMaxHeight + itemY, itemWidth, itemHeight);
    
    //更新字典中的最大y值
    self.maxYDic[minIndex] = @(itemY + itemHeight);
//    @(CGRectGetMaxY(attributes.frame));
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    
    //如果Header UICollectionElementKindSectionHeader
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]){
    
        
        //根据indexPath获取item的attributes
        UICollectionViewLayoutAttributes *headerAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
        
        CGSize size = CGSizeZero;
        
        //获取Headdr的size，由外界计算得到
        if ([self.delegate respondsToSelector:@selector(zx_waterfallLayout:HeaderViewSizeAtIndexPath:)]){
            size = [self.delegate zx_waterfallLayout:self HeaderViewSizeAtIndexPath:indexPath];
        }
        
        //设置attributes的frame
        headerAttributes.frame = CGRectMake(0, 0, size.width, size.height);
    
        //更新mutableSectionMaxHeight
        self.mutableSectionMaxHeight = size.height;
        
        return headerAttributes;
        
    }
    
    //如果Header UICollectionElementKindSectionHeader
    else if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]){
        //根据indexPath获取item的attributes
        UICollectionViewLayoutAttributes *footerAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:indexPath];
        
        CGSize size = CGSizeZero;
        
        //获取Headdr的size，由外界计算得到
        if ([self.delegate respondsToSelector:@selector(zx_waterfallLayout:HeaderViewSizeAtIndexPath:)]){
            size = [self.delegate zx_waterfallLayout:self FooterViewSizeAtIndexPath:indexPath];
        }
        
        //遍历字典，找出最长的那一列
        __block NSNumber *maxIndex = @0;
        [self.maxYDic enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSNumber *obj, BOOL *stop) {
            if ([self.maxYDic[maxIndex] floatValue] < obj.floatValue) {
                maxIndex = key;
            }
        }];
 
        //设置attributes的frame
        footerAttributes.frame = CGRectMake(0, self.mutableSectionMaxHeight + [self.maxYDic[maxIndex] floatValue] + self.sectionInset.bottom, size.width, size.height);
    
        //更新mutableSectionMaxHeight
        self.sectionFooterHeight = size.height;
        
        return footerAttributes;
        
        
    }
    
    
    return  nil;
}




//返回rect范围内item的attributes
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attributesArray;
}




#pragma mark - Lazy
- (NSMutableDictionary *)maxYDic {
    if (!_maxYDic) {
        _maxYDic = [[NSMutableDictionary alloc] init];
    }
    return _maxYDic;
}

- (NSMutableArray *)attributesArray {
    if (!_attributesArray) {
        _attributesArray = [NSMutableArray array];
    }
    return _attributesArray;
}


@end

//
//  ZXBlindBoxSelectActivityCell.m
//  ZXHY
//
//  Created by Bern Mac on 8/3/21.
//

#import "ZXBlindBoxSelectActivityCell.h"
#import "ZXBlindBoxSelectViewModel.h"
#import "ZXCollectionViewLateralFlowLayout.h"
#import "ZXBlindBoxSelectActivityCollectionViewCell.h"
#import "ZXBannerViewFlowLayout.h"

//居中卡片宽度与据屏幕宽度比例
static CGFloat const CardWidthScale = 0.6f;
static CGFloat const CardHeightScale = 1.0f;

//contentView高度
#define CollectionViewHeight 495

@interface ZXBlindBoxSelectActivityCell()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ZXBlindBoxSelectViewModel  *blindBoxSelectViewModel;

//拖动开始、拖动结束
@property (nonatomic, assign) CGFloat  dragStartX;
@property (nonatomic, assign) CGFloat  dragEndX;
@property (nonatomic, assign) NSInteger  currentIndex;

@end

@implementation ZXBlindBoxSelectActivityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self zx_initializationXIB];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)wg_cellIdentifier{
    return @"ZXBlindBoxSelectActivityCellID";
}



#pragma mark - Initialization UI

//初始化XIB
- (void)zx_initializationXIB{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = UIColor.clearColor;
    self.backgroundColor = UIColor.clearColor;
    
    self.titleLabel.textColor = kMainTitleColor;

    
    self.collectionView.frame = CGRectMake(0, 35, WGNumScreenWidth(), CollectionViewHeight);
    [self.contentView addSubview:self.collectionView];
}


#pragma mark - Private Method

//数据赋值
- (void)zx_setBlindBoxSelectViewModel:(ZXBlindBoxSelectViewModel *)blindBoxSelectViewModel NumberModel:(ZXBlindBoxSelectViewItemlistModel *)selectViewItemlistModel{
    if (!blindBoxSelectViewModel) return;
    
    self.blindBoxSelectViewModel = blindBoxSelectViewModel;
    self.titleLabel.text = blindBoxSelectViewModel.title;
    
    
//    selectViewItemlistModel.imglistname
    
    
    NSMutableArray *list = [NSMutableArray array];
    NSMutableArray * arr = [self.blindBoxSelectViewModel.itemdict wg_safeObjectForKey: selectViewItemlistModel.imglistname];
    for (NSDictionary *dic in arr){
        ZXBlindBoxSelectViewItemlistModel *itemlistModel = [ZXBlindBoxSelectViewItemlistModel wg_objectWithDictionary:dic];
        if (itemlistModel.isdefault == 1){
            itemlistModel.select = YES;
        }
        [list addObject:itemlistModel];
    }
    
    self.blindBoxSelectViewModel.itemlist = [NSArray arrayWithArray:list];
   
    [self.collectionView reloadData];
    
    _currentIndex = 0;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];


}


//卡片宽度
- (CGFloat)cellWidth{
    return WGNumScreenWidth() * CardWidthScale;
}

//卡片间隔
- (CGFloat)cellMargin{
    return (WGNumScreenWidth() - [self cellWidth]) / 4;
}

//设置左右缩进
- (CGFloat)collectionInset{
    
    return WGNumScreenWidth() / 2.0f - [self cellWidth] / 2.0f;
}

//配置cell居中
- (void)fixCellToCenter{
    //最小滚动距离
    float dragMiniDistance = WGNumScreenWidth() / 20.0f;
    
    if (self.dragStartX -  self.dragEndX >= dragMiniDistance) {
        _currentIndex -= 1;//向右
    }else if(self.dragEndX - self.dragStartX >= dragMiniDistance){
        _currentIndex += 1;//向左
    }
    
    NSInteger maxIndex = [self.collectionView numberOfItemsInSection:0] - 1;
    _currentIndex = _currentIndex <= 0 ? 0 : _currentIndex;
    _currentIndex = _currentIndex >= maxIndex ? maxIndex : _currentIndex;
    
    [self scrollToCenter];
}

//滑动到中间
- (void)scrollToCenter {
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    
    for (ZXBlindBoxSelectViewItemlistModel *itemlistModel in self.blindBoxSelectViewModel.itemlist){
        itemlistModel.select = NO;
    }
    
    ZXBlindBoxSelectViewItemlistModel *itemlistModel = [self.blindBoxSelectViewModel.itemlist wg_safeObjectAtIndex:_currentIndex];
    itemlistModel.select = !itemlistModel.select;

}


#pragma mark - UICollectionViewDataSource

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, [self collectionInset], 0, [self collectionInset]);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.blindBoxSelectViewModel.itemlist.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ZXBlindBoxSelectActivityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ZXBlindBoxSelectActivityCollectionViewCell wg_cellIdentifier] forIndexPath:indexPath];
    
    ZXBlindBoxSelectViewItemlistModel *itemlistModel = [self.blindBoxSelectViewModel.itemlist wg_safeObjectAtIndex:indexPath.row];
    
    [cell zx_setBlindBoxSelectViewItemlistModel:itemlistModel];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
   
}

#pragma mark - UIScrollViewDelegate
//手指拖动开始
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.dragStartX = scrollView.contentOffset.x;
}

//手指拖动停止
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    self.dragEndX = scrollView.contentOffset.x;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fixCellToCenter];
    });
    
}


#pragma mark - lazy

- (UICollectionView *)collectionView{
    if(!_collectionView){
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = CGSizeMake(WGNumScreenWidth() - 140, 500);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        ZXBannerViewFlowLayout *flowLayout = [[ZXBannerViewFlowLayout alloc] init];
        [flowLayout setItemSize:CGSizeMake([self cellWidth],  CollectionViewHeight * CardHeightScale)];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [flowLayout setMinimumLineSpacing:[self cellMargin]];

        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.clearColor;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView setUserInteractionEnabled:YES];
        
        [_collectionView registerClass:[ZXBlindBoxSelectActivityCollectionViewCell class] forCellWithReuseIdentifier:[ZXBlindBoxSelectActivityCollectionViewCell wg_cellIdentifier]];
    }
    return _collectionView;
}
@end

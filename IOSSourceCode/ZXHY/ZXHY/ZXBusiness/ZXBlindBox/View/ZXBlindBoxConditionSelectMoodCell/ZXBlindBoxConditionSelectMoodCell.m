//
//  ZXBlindBoxConditionSelectMoodCell.m
//  ZXHY
//
//  Created by Bern Lin on 2021/11/22.
//

#import "ZXBlindBoxConditionSelectMoodCell.h"
#import "ZXBannerViewFlowLayout.h"
#import "ZXBlindBoxConditionSelectMoodCollectionViewCell.h"
#import "ZXBlindBoxSelectViewModel.h"

#define collectionW  (WGNumScreenWidth() -  140)
#define collectionH  ((122 * collectionW) / 195) - 20


@interface ZXBlindBoxConditionSelectMoodCell()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property (nonatomic, strong) ZXBlindBoxSelectViewModel  *blindBoxSelectViewModel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic,strong) UIPageControl      *pageControl;

//拖动开始、拖动结束的x坐标
@property (nonatomic, assign) CGFloat  dragStartX;
@property (nonatomic, assign) CGFloat  dragEndX;
//当前选中Index
@property (nonatomic, assign) NSInteger  currentIndex;

@end



@implementation ZXBlindBoxConditionSelectMoodCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)wg_cellIdentifier{
    return @"ZXBlindBoxConditionSelectMoodCellID";
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self setupUI];
    }
    return self;
}

#pragma mark - Initialization UI
//设置UI
- (void)setupUI{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = UIColor.clearColor;
    self.backgroundColor = UIColor.clearColor;
    
    
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(15);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-20);
    }];
    
    [self.contentView addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.collectionView.mas_bottom);
        make.left.right.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
    }];
}


#pragma mark - Private Method

//数据赋值
- (void)zx_setBlindBoxSelectViewModel:(ZXBlindBoxSelectViewModel *)blindBoxSelectViewModel NumberModel:(ZXBlindBoxSelectViewItemlistModel *)selectViewItemlistModel{
    if (!blindBoxSelectViewModel) return;
    
    self.blindBoxSelectViewModel = blindBoxSelectViewModel;
    
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

    self.pageControl.numberOfPages =  self.blindBoxSelectViewModel.itemlist.count;
    
    [self.collectionView reloadData];
}

//数据赋值
- (void)zx_setBlindBoxSelectViewModel:(ZXBlindBoxSelectViewModel *)blindBoxSelectViewModel DataList:(NSMutableArray *)dataList{
    if (!blindBoxSelectViewModel) return;
    
    self.blindBoxSelectViewModel = blindBoxSelectViewModel;
    
    NSMutableArray *list = [NSMutableArray array];
    
    NSMutableArray * arr = [self.blindBoxSelectViewModel.itemdict wg_safeObjectForKey: @"imagelist1"];
    
    
    for ( ZXBlindBoxSelectViewModel *model in dataList){
        if ([model.ID intValue] == 4){
            for ( ZXBlindBoxSelectViewItemlistModel *itemlistModel in model.itemlist){
                if (itemlistModel.select){
                    arr = [self.blindBoxSelectViewModel.itemdict wg_safeObjectForKey: itemlistModel.imglistname];
                                          
                }
            }
       }
    }
    
   
    for (NSDictionary *dic in arr){
        ZXBlindBoxSelectViewItemlistModel *itemlistModel = [ZXBlindBoxSelectViewItemlistModel wg_objectWithDictionary:dic];
        if (itemlistModel.isdefault == 1){
            itemlistModel.select = YES;
        }
        [list addObject:itemlistModel];
    }
    
    self.blindBoxSelectViewModel.itemlist = [NSArray arrayWithArray:list];

    self.pageControl.numberOfPages =  self.blindBoxSelectViewModel.itemlist.count;
    
    [self.collectionView reloadData];
}


//拖拽结束后
- (void)zx_endDragCalculate{
    
    //最小滚动距离
    float dragMiniDistance = WGNumScreenWidth()/ 20.0f;
    
    if (self.dragStartX -  self.dragEndX >= dragMiniDistance) {
        self.currentIndex -= 1;//向右
    }else if(self.dragEndX - self.dragStartX >= dragMiniDistance){
        self.currentIndex += 1;//向左
    }
    
    //最大最小处理
    NSInteger maxIndex = self.blindBoxSelectViewModel.itemlist.count - 1;
    self.currentIndex = self.currentIndex <= 0 ? 0 : self.currentIndex;
    self.currentIndex = self.currentIndex >= maxIndex ? maxIndex : self.currentIndex;
    
    //选中
    for (ZXBlindBoxSelectViewItemlistModel *blindBoxSelectViewModel in self.blindBoxSelectViewModel.itemlist){
        blindBoxSelectViewModel.select = NO;
    }
    ZXBlindBoxSelectViewItemlistModel *blindBoxSelectViewModel = [self.blindBoxSelectViewModel.itemlist wg_safeObjectAtIndex:self.currentIndex];
    blindBoxSelectViewModel.select = YES;
    [self.collectionView reloadData];
    
    //滑动到对应的items
    self.pageControl.currentPage = self.currentIndex;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}


#pragma mark - UICollectionViewDataSource

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0,WGNumScreenWidth() - 115);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.blindBoxSelectViewModel.itemlist.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ZXBlindBoxSelectViewItemlistModel *blindBoxSelectViewModel = [self.blindBoxSelectViewModel.itemlist wg_safeObjectAtIndex:indexPath.row];
    
    ZXBlindBoxConditionSelectMoodCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ZXBlindBoxConditionSelectMoodCollectionViewCell wg_cellIdentifier] forIndexPath:indexPath];
    
    [cell zx_setBlindBoxSelectViewItemlistModel:blindBoxSelectViewModel];
    
    return cell;

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //选中
    for (ZXBlindBoxSelectViewItemlistModel *blindBoxSelectViewModel in self.blindBoxSelectViewModel.itemlist){
        blindBoxSelectViewModel.select = NO;
    }
    ZXBlindBoxSelectViewItemlistModel *blindBoxSelectViewModel = [self.blindBoxSelectViewModel.itemlist wg_safeObjectAtIndex:indexPath.row];
    blindBoxSelectViewModel.select = YES;
    [self.collectionView reloadData];
    
    //滑动到对应的items
    self.pageControl.currentPage = self.currentIndex = indexPath.row;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
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
        [self zx_endDragCalculate];
    });
    
}

#pragma mark - lazy

- (UICollectionView *)collectionView{
    if(!_collectionView){
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = CGSizeMake(collectionW , collectionH);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.clearColor;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView setUserInteractionEnabled:YES];
        [_collectionView registerClass:[ZXBlindBoxConditionSelectMoodCollectionViewCell class] forCellWithReuseIdentifier:[ZXBlindBoxConditionSelectMoodCollectionViewCell wg_cellIdentifier]];
    }
    return _collectionView;
}


- (UIPageControl *)pageControl{
    if (!_pageControl){
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    }
    return _pageControl;
}

@end

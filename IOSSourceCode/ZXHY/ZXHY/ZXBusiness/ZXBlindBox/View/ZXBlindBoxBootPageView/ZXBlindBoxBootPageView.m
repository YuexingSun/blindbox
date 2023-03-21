//
//  ZXBlindBoxBootPageView.m
//  ZXHY
//
//  Created by Bern Lin on 2022/1/11.
//

#import "ZXBlindBoxBootPageView.h"
#import "ZXBlindBoxBootPageCollectionViewCell.h"

@interface ZXBlindBoxBootPageView ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>


@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray  *dataArr;
@property (nonatomic, assign) NSInteger  currentIndex;

//拖动开始、拖动结束的x坐标
@property (nonatomic, assign) CGFloat  dragStartX;
@property (nonatomic, assign) CGFloat  dragEndX;

@end



@implementation ZXBlindBoxBootPageView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        [self setupUI];
    }
    
    return self;
}

#pragma mark - Initialization UI

- (void)setupUI{
    
    self.backgroundColor = UIColor.clearColor;
    
    self.collectionView.frame = self.frame;
    [self addSubview:self.collectionView];
    
    self.currentIndex = 0;
    
    self.dataArr = @[@"BlindBoxBootPageOne",@"BlindBoxBootPageTwo",@"BlindBoxBootPageThree"];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZXBlindBoxBootPageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ZXBlindBoxBootPageCollectionViewCell wg_cellIdentifier] forIndexPath:indexPath];
    
    NSString *imgStr = [self.dataArr wg_safeObjectAtIndex:indexPath.row];
    cell.imgView.image = IMAGENAMED(imgStr);
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.currentIndex++;
    
    if (self.currentIndex > self.dataArr.count - 1){
        
        self.currentIndex = self.dataArr.count - 1;
        
        //设置缓存
        ZX_SetUserDefaultsIsFristEntryBoxTips(@"1");
        
        //关闭弹窗
        if (self.delegate && [self.delegate respondsToSelector:@selector(zx_closeBlindBoxBootPageView:)]){
            [self.delegate zx_closeBlindBoxBootPageView:self];
        }
    }
    
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
        //最小滚动距离
        float dragMiniDistance = WGNumScreenWidth()/ 20.0f;
        
        if (self.dragStartX -  self.dragEndX >= dragMiniDistance) {
            self.currentIndex -= 1;//向右
        }else if(self.dragEndX - self.dragStartX >= dragMiniDistance){
            self.currentIndex += 1;//向左
        }
        
        //最大最小处理
        NSInteger maxIndex = self.dataArr.count - 1;
        self.currentIndex = self.currentIndex <= 0 ? 0 : self.currentIndex;
        self.currentIndex = self.currentIndex >= maxIndex ? maxIndex : self.currentIndex;
    });
    
}

#pragma mark - lazy
- (UICollectionView *)collectionView{
    if(!_collectionView){
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(WGNumScreenWidth(), WGNumScreenHeight());
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;

        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.pagingEnabled = YES;
        

        [_collectionView registerClass:[ZXBlindBoxBootPageCollectionViewCell class] forCellWithReuseIdentifier:[ZXBlindBoxBootPageCollectionViewCell wg_cellIdentifier]];
       
    }
    return _collectionView;
}

@end

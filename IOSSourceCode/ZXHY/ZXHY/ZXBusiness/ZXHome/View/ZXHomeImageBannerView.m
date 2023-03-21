//
//  ZXHomeImageBannerView.m
//  ZXHY
//
//  Created by Bern Lin on 2021/12/21.
//

#import "ZXHomeImageBannerView.h"
#import "ZXHomeImageBannerPageControl.h"
#import "ZXHomeImageBannerCollectionViewCell.h"
#import "WGImageBrowser.h"
#import "ZXHomeModel.h"

@interface ZXHomeImageBannerView ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
YBImageBrowserDelegate
>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger  dataSourceCount;
@property (nonatomic, assign) ZXBannerType  bannerType;
@property(nonatomic,strong) UIPageControl      *pageControl;

//拖动开始、拖动结束的x坐标、当前选中Index
@property (nonatomic, assign) CGFloat  dragStartX;
@property (nonatomic, assign) CGFloat  dragEndX;
@property (nonatomic, assign) NSInteger  currentIndex;

//数据
@property (nonatomic, strong) ZXHomeListModel *listModel;

@end


@implementation ZXHomeImageBannerView

- (instancetype)initWithFrame:(CGRect)frame withBannerType:(ZXBannerType)bannerType{
    
    if(self = [super initWithFrame:frame]){
        
        self.backgroundColor = [UIColor clearColor];
        self.bannerType = bannerType;
        [self setupUI];
    }
    
    return self;
}


#pragma mark - Initialization UI

- (void)setupUI{
    
    self.backgroundColor = UIColor.clearColor;
    
    //首页banner布局
    if (self.bannerType == ZXBannerType_Home){
        self.collectionView.frame = self.frame;
        [self addSubview:self.collectionView];
    }
    
    //详情页banner布局
    else if (self.bannerType == ZXBannerType_Details){
        
        CGFloat pageControlH = 40;
        
        self.collectionView.frame = self.frame;
        self.collectionView.mj_h -= pageControlH;
        [self addSubview:self.collectionView];
        
        self.pageControl.frame = CGRectMake(0, self.mj_h - pageControlH, self.mj_w, pageControlH);
        [self addSubview:self.pageControl];
        
    }
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.listModel.bannerlist.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    
    ZXHomeImageBannerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ZXHomeImageBannerCollectionViewCell wg_cellIdentifier] forIndexPath:indexPath];
    
    NSString *imgStr = [self.listModel.bannerlist wg_safeObjectAtIndex:indexPath.row];
    imgStr = [imgStr  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    if (self.bannerType == ZXBannerType_Home){
        cell.bgView.backgroundColor = WGGrayColor(239);
        cell.bgView.contentMode = UIViewContentModeScaleAspectFill;
        
        [cell.bgView wg_setImageWithURLString:imgStr loadingColor:WGGrayColor(239) failImage:IMAGENAMED(@"placeholderImage")];
        
//        [cell.bgView zx_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:IMAGENAMED(@"") failImage:IMAGENAMED(@"placeholderImage")];
    }
   
    else if (self.bannerType == ZXBannerType_Details){
        cell.bgView.backgroundColor = WGGrayColor(255);
        
        [cell.bgView sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:IMAGENAMED(@"placeholderImage")completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image){
                if (image.size.height >= WGNumScreenHeight()){
                    cell.bgView.contentMode = UIViewContentModeScaleAspectFill;
                }else{
                    cell.bgView.contentMode = UIViewContentModeScaleAspectFit;
                }
            }
        }];
    }
    
   
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    

    
    
    NSMutableArray *imageArr = [NSMutableArray array];
    
    for  (NSString *str in self.listModel.bannerlist){
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WGNumScreenWidth(), WGNumScreenWidth())];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [imgView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:IMAGENAMED(@"placeholderImage")];
        [imageArr addObject:imgView];
    }
    
    [WGImageBrowser wg_showImageBrowserWithImages:self.listModel.bannerlist
                                            index:indexPath.row
                                         delegate:self
                                    sourceObjects:imageArr
                             sheetViewButtonsType:WGImageBrowserSheetBtnTypeSysSave];
}


- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    NSIndexPath *cunrrentIndexPath = [[self.collectionView indexPathsForVisibleItems] firstObject];
    self.pageControl.currentPage = cunrrentIndexPath.row;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self zx_computeSizeForItemAtIndexPath:indexPath];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (self.bannerType == ZXBannerType_Home){
        return 5;
    }
    else if (self.bannerType == ZXBannerType_Details){
        return 0.f;
    }
    return 0.1f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    if (self.bannerType == ZXBannerType_Home){
        return 5;
    }
    else if (self.bannerType == ZXBannerType_Details){
        return 0.f;
    }
    return 0.1f;
}



#pragma mark - YBImageBrowserDelegate
- (void)yb_imageBrowser:(YBImageBrowser *)imageBrowser pageChanged:(NSInteger)page data:(id<YBIBDataProtocol>)data {
    
    [self.collectionView setContentOffset:CGPointMake(page * self.collectionView.mj_w, 0) animated:NO];
    
    self.pageControl.currentPage = page;
}


#pragma mark - Private Method
//计算Items大小
- (CGSize)zx_computeSizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //如果为详情页
    if (self.bannerType == ZXBannerType_Details){
        return CGSizeMake( self.collectionView.mj_w, self.collectionView.mj_h);
    }
    
    //==========以下是如果为首页==========
    //2
    if (self.dataSourceCount == 2){
        
        CGFloat H = (self.mj_h);
        CGFloat W = (self.mj_w - 5) / 2;
        CGFloat h = (self.mj_h);
        CGFloat w = (self.mj_w - 5) - W;
        
        if (indexPath.row == 0 ){
            return CGSizeMake( W, H);
        } else{
            return CGSizeMake( w, h);
        }
    }
    
    //3
    if (self.dataSourceCount == 3){
        
        CGFloat H = (self.mj_h);
        CGFloat W = (self.mj_w) - 175;
        CGFloat h = (self.mj_h - 5) / 2;
        CGFloat w = (self.mj_w - 5) - W;
        
        if (indexPath.row == 0 ){
            return CGSizeMake( W, H);
        } else{
            return CGSizeMake( w, h);
        }
    }
    
    //4
    if (self.dataSourceCount == 4){
        
        CGFloat H = (self.mj_h);
        CGFloat W = (self.mj_w) - 150;
        CGFloat h = (self.mj_h - 10.1) / 3;
        CGFloat w = (self.mj_w - 5) - W;
        
        if (indexPath.row == 0 ){
            return CGSizeMake( W, H);
        } else{
            return CGSizeMake( w, h);
        }
    }
    
    //5
    if (self.dataSourceCount == 5){
        
        CGFloat H = (self.mj_h - 5) / 2;
        CGFloat W = (self.mj_w) - 150;
        CGFloat h = (self.mj_h - 10.1) / 3;
        CGFloat w = (self.mj_w - 5) - W;
        
        if (indexPath.row == 0 || indexPath.row == 1){
            return CGSizeMake( W, H);
        } else{
            return CGSizeMake( w, h);
        }
        
    }
    
    return CGSizeMake( self.mj_w, self.mj_h);
}

//数据赋值
- (void)zx_setListModel:(ZXHomeListModel *)listModel{
    self.listModel = listModel;
    
    self.dataSourceCount = listModel.bannerlist.count;
    if (self.bannerType == ZXBannerType_Home){
        if (self.listModel.bannerlist.count >= 5){
            self.dataSourceCount = 5;
        }
    }
    self.pageControl.numberOfPages = self.dataSourceCount;
    [self.collectionView reloadData];
}


#pragma mark - lazy
- (UICollectionView *)collectionView{
    if(!_collectionView){
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.pagingEnabled = YES;
        
        [_collectionView registerClass:[ZXHomeImageBannerCollectionViewCell class] forCellWithReuseIdentifier:[ZXHomeImageBannerCollectionViewCell wg_cellIdentifier]];
    }
    return _collectionView;
}

- (UIPageControl *)pageControl{
    if (!_pageControl){
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.currentPage = 0;
        _pageControl.pageIndicatorTintColor = WGGrayColor(196);
        _pageControl.currentPageIndicatorTintColor = WGRGBColor(255, 82, 128);
    }
    return _pageControl;
}

@end

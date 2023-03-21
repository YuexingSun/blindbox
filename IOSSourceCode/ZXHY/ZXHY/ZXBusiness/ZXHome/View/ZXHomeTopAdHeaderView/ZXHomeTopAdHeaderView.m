//
//  ZXHomeTopAdHeaderView.m
//  ZXHY
//
//  Created by Bern Lin on 2022/3/8.
//

#import "ZXHomeTopAdHeaderView.h"
#import "ZXHomeTopAdCollectionViewCell.h"
#import "ZXHomeAdModel.h"
#import "ZXHomeDetailsViewController.h"
#import "ZXWebViewViewController.h"


@interface ZXHomeTopAdHeaderView ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) NSMutableArray *adList;


@end

@implementation ZXHomeTopAdHeaderView


- (instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        
        [self setupUI];
        
        [self zx_reqApiInfomationGetBannerList];
    }
    
    return self;
}

#pragma mark - Initialization UI

- (void)setupUI{
    
    self.backgroundColor = UIColor.clearColor;
    
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(7);
        make.right.equalTo(self.mas_right).offset(-7);
        make.top.equalTo(self.mas_top).offset(0.1);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
    
    }];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.adList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ZXHomeTopAdCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ZXHomeTopAdCollectionViewCell wg_cellIdentifier] forIndexPath:indexPath];
   
    ZXHomeAdModel *adModel = [self.adList wg_safeObjectAtIndex:indexPath.row];
   
    [cell zx_homeTopAdModel:adModel];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZXHomeAdModel *adModel = [self.adList wg_safeObjectAtIndex:indexPath.row];
    
    if ([adModel.targettype isEqualToString:@"box"]){
        
        [[AppDelegate wg_sharedDelegate].tabBarController changeToSelectedIndex:WGTabBarType_Box];
    }
    else if ([adModel.targettype isEqualToString:@"detail"]){
        
        if (!adModel.param.length) return;;
        
        ZXHomeDetailsViewController *vc = [ZXHomeDetailsViewController new];
        [vc zx_setTypeIdToRequest:adModel.param];
        [[WGUIManager wg_currentIndexNavTopController].navigationController pushViewController:vc animated:YES];
        
    }
    else if ([adModel.targettype isEqualToString:@"h5"]){
        
        if (!adModel.param.length) return;;
        
        ZXWebViewViewController *vc = [ZXWebViewViewController new];
        vc.webViewURL = adModel.param;
        vc.webViewTitle = @"";
        [[WGUIManager wg_currentIndexNavTopController].navigationController pushViewController: vc animated:YES];
    }
    else if ([adModel.targettype isEqualToString:@"none"]){
        
    }
}





#pragma mark - NetworkRequest
//获取首页信息流列表
- (void)zx_reqApiInfomationGetBannerList{
    
    WEAKSELF;
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiInfomationGetBannerList Parameter:@{} success:^(NSDictionary * _Nonnull resultDic) {
        STRONGSELF;
        
        ZXHomeTopAdModel *topAdModel = [ZXHomeTopAdModel wg_objectWithDictionary:[resultDic wg_safeObjectForKey:@"data"]];
        
        self.adList = [NSMutableArray arrayWithArray:topAdModel.list];

        [self.collectionView reloadData];
        
        //高度计算
        [self selfHeightWithAdList];
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - Private Method
//高度计算
- (void)selfHeightWithAdList{
    
    CGFloat selfHeight = 0;
    CGFloat sizeWidth  = 0;
    CGFloat sizeHeight  = 0;
    
    if (!self.adList.count) selfHeight =  0 ;
    
    else if (self.adList.count == 1){
        sizeWidth  = (WGNumScreenWidth() - 14);
        sizeHeight = ((sizeWidth * 100) / 260);
        selfHeight = sizeHeight;
    }
    
    else if (self.adList.count > 1){
        NSInteger rows = ceilf(self.adList.count / 2.0);
        sizeWidth  = (WGNumScreenWidth() - 14) /2;
        sizeHeight = ((sizeWidth * 100) / 170);
        selfHeight = sizeHeight * rows;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeTopAdHeaderView:returnViewHeight:)]){
        [self.delegate homeTopAdHeaderView:self returnViewHeight:selfHeight];
    }
    
    self.layout.itemSize = CGSizeMake(sizeWidth, sizeHeight);
}


#pragma mark - lazy

- (UICollectionView *)collectionView{
    if(!_collectionView){
        
        CGFloat width  = (WGNumScreenWidth() - 14) / 2;
        CGFloat height = 130;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = CGSizeMake( width, height);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.layout = layout;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        [_collectionView registerClass:[ZXHomeTopAdCollectionViewCell class] forCellWithReuseIdentifier:[ZXHomeTopAdCollectionViewCell wg_cellIdentifier]];
    }
    return _collectionView;
}




@end

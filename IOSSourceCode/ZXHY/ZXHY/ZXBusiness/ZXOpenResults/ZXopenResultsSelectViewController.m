//
//  ZXopenResultsSelectViewController.m
//  ZXHY
//
//  Created by Bern Mac on 8/31/21.
//

#import "ZXopenResultsSelectViewController.h"
#import "CustomUIViewController.h"
#import "ZXStartView.h"
#import "ZXOpenResultsModel.h"
#import "ZXCollectionViewLateralFlowLayout.h"
#import "ZXBannerViewFlowLayout.h"
#import "ZXopenResultsSelectCollectionViewCell.h"
#import "ZXOpenResultsCollectionViewCell.h"

//居中卡片宽度与据屏幕宽度比例
static CGFloat const CardWidthScale = 0.6f;
static CGFloat const CardHeightScale = 1.0f;
//contentView高度
#define CollectionViewHeight self.collectionView.mj_h

@interface ZXopenResultsSelectViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
ZXOpenResultsCollectionViewCellDelegate
>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionHeight;

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *consumptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *newnessLabel;
@property (weak, nonatomic) IBOutlet UILabel *mystiqueLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *consumptionValueLabel;
@property (weak, nonatomic) IBOutlet UIView *newnessValueView;
@property (weak, nonatomic) IBOutlet UIView *mystiqueValueView;
@property (nonatomic, strong) ZXStartView  *newnessStartValueView;
@property (nonatomic, strong) ZXStartView  *mystiqueStartValueView;

@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (nonatomic, strong) NSMutableArray  *boxDataList;
@property (nonatomic, strong) ZXOpenResultsModel *resultsModel;
@property (nonatomic, strong) NSString  *boxid;
@property (nonatomic, assign) NSInteger  selectBoxIndex;

@property (nonatomic, strong) NSString  *currentBoxId;

//拖动开始、拖动结束
@property (nonatomic, assign) CGFloat  dragStartX;
@property (nonatomic, assign) CGFloat  dragEndX;
@property (nonatomic, assign) NSInteger  currentIndex;

@end

@implementation ZXopenResultsSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self zx_setCollectionView];
    
    [self zx_initializationXIB];
    
   
    
//    [self zx_initWtihData];
}


-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationView.alpha = 0;
    self.navigationController.navigationBar.hidden  = YES;
    
    //禁止返回
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
}



#pragma mark - Initialization UI
//初始化XIB
- (void)zx_initializationXIB{
    
    self.backgroundView.layer.cornerRadius = 15;
    
    [self.goButton wg_setLayerRoundedCornersWithRadius:24];
    NSArray * colors = @[WGRGBColor(248, 109, 148),WGRGBColor(237, 86, 88)];
    [self.goButton wg_backgroundGradientHorizontalColors:colors];
    
    [self.backButton wg_setLayerRoundedCornersWithRadius:24];


    self.newnessStartValueView = [ZXStartView new];
    [self.newnessValueView addSubview:self.newnessStartValueView ];
    [self.newnessStartValueView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(self.newnessValueView);
        make.width.offset(85);
    }];
    
    
    self.mystiqueStartValueView = [ZXStartView new];
    [self.mystiqueValueView addSubview:self.mystiqueStartValueView ];
    [self.mystiqueStartValueView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(self.mystiqueValueView);
        make.width.offset(85);
    }];
    
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:self.resultsModel.pic] placeholderImage:nil];
}


//设置CollectionView
- (void)zx_setCollectionView{

    CGFloat itemWidth = WGNumScreenWidth() - 60;
    CGFloat collectionHeight = (IS_IPHONE_X_SER) ? 500 :440;
    
    self.collectionHeight.constant = collectionHeight + 20;
   
    ZXCollectionViewLateralFlowLayout *layout = [[ZXCollectionViewLateralFlowLayout alloc] init];
    layout.size =   CGSizeMake(itemWidth, collectionHeight);
    layout.row = 1;
    layout.column = 3;
    layout.columnSpacing = 0;
    layout.rowSpacing = 0;
    layout.pageWidth = itemWidth* 3 + 16;
    
    
    
    ZXBannerViewFlowLayout *flowLayout = [[ZXBannerViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake([self cellWidth],  collectionHeight * CardHeightScale)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumLineSpacing:[self cellMargin]];
    
//    WGNumScreenWidth() 295;
    
    [self.collectionView setCollectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;

    [self.collectionView registerNib:[UINib nibWithNibName:@"ZXopenResultsSelectCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:[ZXopenResultsSelectCollectionViewCell wg_cellIdentifier]];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZXOpenResultsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:[ZXOpenResultsCollectionViewCell wg_cellIdentifier]];
    
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.boxDataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    ZXopenResultsSelectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ZXopenResultsSelectCollectionViewCell wg_cellIdentifier] forIndexPath:indexPath];
//
//    ZXOpenResultsModel *resultsModel = [self.boxDataList wg_safeObjectAtIndex:indexPath.row];
//
//    [cell zx_setDataWithResultModel:resultsModel ForItemAtIndexPath:indexPath];
//
//    return cell;
    
    
    ZXOpenResultsModel *resultsModel = [self.boxDataList wg_safeObjectAtIndex:indexPath.row];
   
    ZXOpenResultsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ZXOpenResultsCollectionViewCell wg_cellIdentifier] forIndexPath:indexPath];

    cell.delegate = self;
    [cell zx_setDataWithResultModel:resultsModel ForItemAtIndexPath:indexPath];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    _currentIndex = indexPath.row;
    [self scrollToCenter];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, [self collectionInset], 0, [self collectionInset]);
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


#pragma mark - ZXOpenResultsCollectionViewCellDelegate
//马上启程回调
- (void)OpenResultsCollectionViewCell:(ZXOpenResultsCollectionViewCell *)view OpenResultsModel:(ZXOpenResultsModel *)resultsModel{
    self.resultsModel = resultsModel;
    
    if (!resultsModel){
        [WGUIManager wg_hideHUDWithText:@"启程失败"];
        return;
    }
    [self zx_reqApiStartBox];
    
    CustomUIViewController *vc = [CustomUIViewController new];
    [vc zx_openResultslnglatModel:self.resultsModel ParentlistModel:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - Private Method

//马上起程
- (IBAction)goAction:(UIButton *)sender {
    
    
}

//终止行程
- (IBAction)backAction:(UIButton *)sender {
    [self ZX_ReqApiCancel];
}

//进行中数据传入
- (void)zx_getBeingBox:(NSString *)boxid{
    [self ZX_ReqApiGetBoxDetail:boxid];
}

//获取盒子信息
- (void)zx_getBlindBox:(NSDictionary *)resultDic{
    
    self.boxDataList = [ZXOpenResultsModel wg_initObjectsWithOtherDictionary:resultDic key:@"data"];
    NSLog(@"zx_getBlindBox-----%@",self.boxDataList);
    
    
    ZXOpenResultsModel *resultsModel = [self.boxDataList wg_safeObjectAtIndex:0];
    resultsModel.selectBox = YES;
    self.resultsModel = resultsModel;
    self.currentBoxId = resultsModel.boxid;
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:self.resultsModel.pic] placeholderImage:nil];
    
    _currentIndex = 0;

    [self.collectionView reloadData];
    
}


//数据赋值
- (void)zx_initWtihData{
    self.titleLabel.text = self.resultsModel.title;
    
    ZXOpenResultsItemsModel *itemsModel = [self.resultsModel.items wg_safeObjectAtIndex:0];
    self.distanceLabel.text = [NSString stringWithFormat:@"%@",itemsModel.item];
    self.distanceValueLabel.text = [NSString stringWithFormat:@"%@",itemsModel.value];
    
    ZXOpenResultsItemsModel *itemsModel1 = [self.resultsModel.items wg_safeObjectAtIndex:1];
    self.consumptionLabel.text = [NSString stringWithFormat:@"%@",itemsModel1.item];
    self.consumptionValueLabel.text = [NSString stringWithFormat:@"%@",itemsModel1.value];
    
    ZXOpenResultsItemsModel *itemsModel2 = [self.resultsModel.items wg_safeObjectAtIndex:2];
    self.mystiqueLabel.text = [NSString stringWithFormat:@"%@",itemsModel2.item];
    [self.newnessStartValueView zx_scores:itemsModel2.value WithType:ZXStartType_Info];
    
    ZXOpenResultsItemsModel *itemsModel3 = [self.resultsModel.items wg_safeObjectAtIndex:3];
    self.newnessLabel.text = [NSString stringWithFormat:@"%@",itemsModel3.item];
    [self.mystiqueStartValueView zx_scores:itemsModel3.value WithType:ZXStartType_Info];
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

    ZXOpenResultsModel *resultsModel = [self.boxDataList wg_safeObjectAtIndex:_currentIndex];
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:resultsModel.pic] placeholderImage:nil];
    
}

//卡片宽度
- (CGFloat)cellWidth{
    return WGNumScreenWidth() - 80;
}

//卡片间隔
- (CGFloat)cellMargin{
    return 10;
//    (WGNumScreenWidth() - [self cellWidth]) / 4;
}

//设置左右缩进
- (CGFloat)collectionInset{
    
    return WGNumScreenWidth() / 2.0f - [self cellWidth] / 2.0f;
}



#pragma mark - NetworkRequest

//起程盲盒
- (void)zx_reqApiStartBox{
   
    
    NSDictionary *dict = @{
        @"boxid":self.resultsModel.boxid?:@"",
        @"indexid":@( self.resultsModel.selectIndex)
    };
  
    WEAKSELF;
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiStartBox Parameter:dict success:^(NSDictionary * _Nonnull resultDic) {
        STRONGSELF;
        
        
    } failure:^(NSError * _Nonnull error) {

        
    }];
}

//获取盲盒信息
- (void)ZX_ReqApiGetBoxDetail:(NSString *)boxid{
    
    self.currentBoxId = boxid;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict wg_safeSetObject:boxid forKey:@"boxid"];
    
    [WGUIManager wg_showHUD];
    WEAKSELF;
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiGetBoxDetail Parameter:dict success:^(NSDictionary * _Nonnull resultDic) {
        [WGUIManager wg_hideHUD];
        STRONGSELF;
        [self zx_getBlindBox:resultDic];
        
//        [self zx_initWtihData];
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}


//终止行程
- (void)ZX_ReqApiCancel{
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict wg_safeSetObject:self.currentBoxId forKey:@"boxid"];
    
    [WGUIManager wg_showHUD];
    WEAKSELF;
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiCancelBox Parameter:dict success:^(NSDictionary * _Nonnull resultDic) {
        [WGUIManager wg_hideHUD];
        STRONGSELF;
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        //TODO: 修复
//        [[AppDelegate wg_sharedDelegate].tabBarController zx_reqApiCheckBeingBox];
    } failure:^(NSError * _Nonnull error) {
        
        
    }];

}

@end

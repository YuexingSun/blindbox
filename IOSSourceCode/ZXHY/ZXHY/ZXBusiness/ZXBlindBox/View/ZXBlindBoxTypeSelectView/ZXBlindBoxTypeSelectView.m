//
//  ZXBlindBoxTypeSelectView.m
//  ZXHY
//
//  Created by Bern Lin on 2021/11/23.
//

#import "ZXBlindBoxTypeSelectView.h"
#import "ZXBlindBoxTypeSelectCollectionViewCell.h"
#import "ZXBannerViewFlowLayout.h"
#import "ZXBlindBoxViewModel.h"
#import "ZXOpenResultsModel.h"
#import "CustomUIViewController.h"
#import "ZXNavViewController.h"

//居中卡片宽度与据屏幕宽度比例
#define CollectionViewHeight IS_IPHONE_X_SER ? 470 : 440
#define CardWidthScale 0.75f
#define CardHeightScale 1.0f


@interface ZXBlindBoxTypeSelectView()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property (nonatomic, strong) ZXBlindBoxViewParentlistModel  *parentlistModel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton         *goButton;
@property (nonatomic, strong) UIImageView      *tipsImageView;

//拖动开始、拖动结束
@property (nonatomic, assign) CGFloat  dragStartX;
@property (nonatomic, assign) CGFloat  dragEndX;
@property (nonatomic, assign) NSInteger  currentIndex;

@end

@implementation ZXBlindBoxTypeSelectView


- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self zx_initializationUI];
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.goButton.layer.shadowColor = WGHEXAlpha(@"FF0000", 0.25).CGColor;
    self.goButton.layer.shadowOffset = CGSizeMake(0,4);
    self.goButton.layer.shadowRadius = 3;
    self.goButton.layer.shadowOpacity = 1;
    self.goButton.clipsToBounds = NO;
    [self.goButton wg_setRoundedCornersWithRadius:25];
    NSArray * colors = @[WGRGBColor(255, 81, 206),WGRGBColor(255, 55, 95)];
    [self.goButton wg_backgroundGradientHorizontalColors:colors];
    
}

#pragma mark - Initialization UI
- (void)zx_initializationUI{
    
    self.backgroundColor = UIColor.clearColor;
    
    //取消按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self);
      
    }];
    
    
    //collectionView
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self).offset(-50);
        make.left.right.mas_equalTo(self);
        make.height.offset(CollectionViewHeight);
    }];
    
    
    //出发按钮
    [self addSubview:self.goButton];
    [self.goButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom).offset(20);
        make.left.equalTo(self.mas_left).offset(65);
        make.right.equalTo(self.mas_right).offset(-65);
        make.height.offset(50);
    }];
    
    
    //提示文本吧
    UIImageView *tipsImageView = [UIImageView wg_imageViewWithImageNamed:@"depleteBox"];
    [self addSubview:tipsImageView];
    [tipsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goButton.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.goButton);
        make.height.offset(35);
        make.width.offset(130);
    }];
    self.tipsImageView = tipsImageView;
    
}


#pragma mark - Private Method
//数据处理
- (void)zx_parentlistModel:(ZXBlindBoxViewParentlistModel *)parentlistModel{
    parentlistModel.isBegin = 0;
    self.parentlistModel = parentlistModel;

    self.currentIndex = parentlistModel.selectIndex;

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    });
}


//进行中据传入
- (void)zx_beginParentlistModel:(ZXBlindBoxViewParentlistModel *)parentlistModel{
    
    parentlistModel.isBegin = 1;
    
    self.parentlistModel = parentlistModel;
   
    [self.collectionView reloadData];
    
    [self.goButton setTitle:@"继续行程" forState:UIControlStateNormal];
    
    self.tipsImageView.hidden = YES;
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
}


//出发按钮响应
- (void)goAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(zx_goBlindBoxTypeSelectView:)]){
        [self.delegate zx_goBlindBoxTypeSelectView:self];
    }
    
    if (self.parentlistModel.childlist.count){
        [self zx_reqApiStartBox];
    }
    
}

//关闭按钮
- (void)cancelAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(zx_goBlindBoxTypeSelectView:)]){
        [self.delegate zx_goBlindBoxTypeSelectView:self];
    }
}

#pragma mark - UICollectionViewDataSource

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, [self collectionInset], 0, [self collectionInset]);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.parentlistModel.childlist.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ZXOpenResultsModel *openResultsModel = [self.parentlistModel.childlist wg_safeObjectAtIndex:indexPath.row];
    
    ZXBlindBoxTypeSelectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ZXBlindBoxTypeSelectCollectionViewCell wg_cellIdentifier] forIndexPath:indexPath];
    
    [cell zx_openResultsModel:openResultsModel AtIndex:indexPath.row];
    
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



#pragma mark - NetworkRequest
//起程盲盒
- (void)zx_reqApiStartBox{
   
    ZXOpenResultsModel *openResultsModel = [self.parentlistModel.childlist wg_safeObjectAtIndex:self.currentIndex];
    
    NSDictionary *dict = @{
        @"boxid":openResultsModel.boxid?:@"",
        @"indexid":@(openResultsModel.indexid)
    };
  
    WEAKSELF;
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiStartBox Parameter:dict success:^(NSDictionary * _Nonnull resultDic) {
        STRONGSELF;
       
        
        if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)) {

            //定位功能可用
            //TODO: 替换地图
            CustomUIViewController *vc = [CustomUIViewController new];
            [vc zx_openResultslnglatModel:openResultsModel ParentlistModel:self.parentlistModel];
            [[WGUIManager wg_currentIndexNavController] pushViewController:vc animated:YES];
            
            
//            ZXNavViewController *vc = [[ZXNavViewController alloc] init];
//            [vc zx_enterNavControllerWithResultsModel:openResultsModel ParentlistModel:self.parentlistModel];
//            vc.hidesBottomBarWhenPushed = YES;
//            [[WGUIManager wg_currentIndexNavController] pushViewController:vc animated:YES];

        }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {

            //定位不能用
            //设置提示提醒用户打开定位服务
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"允许定位提示" message:@"请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]){
                    [[UIApplication sharedApplication] openURL:url];
                }
            }];

            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alert addAction:okAction];
            [alert addAction:cancelAction];
            [[WGUIManager wg_topViewController] presentViewController:alert animated:YES completion:nil];
            return;;

        }
        
        
        
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [WGNotification postNotificationName:ZXNotificationMacro_BlindBox object:nil];
        });
        
        
    } failure:^(NSError * _Nonnull error) {

        
    }];
}




#pragma mark - lazy

- (UICollectionView *)collectionView{
    if(!_collectionView){
        
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
        
        [_collectionView registerClass:[ZXBlindBoxTypeSelectCollectionViewCell class] forCellWithReuseIdentifier:[ZXBlindBoxTypeSelectCollectionViewCell wg_cellIdentifier]];
    }
    return _collectionView;
}

- (UIButton *)goButton{
    if (!_goButton){
        _goButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _goButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
        [_goButton setTitle:@"出发" forState:UIControlStateNormal];
        [_goButton setTitleColor:WGGrayColor(255) forState:UIControlStateNormal];
        [_goButton addTarget:self action:@selector(goAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goButton;
}

@end

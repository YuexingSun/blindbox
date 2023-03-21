//
//  ZXBlindBoxFloatTagView.m
//  ZXHY
//
//  Created by Bern Lin on 2022/1/11.
//

#import "ZXBlindBoxFloatTagView.h"
#import "ZXBlindBoxConditionSelectBudgetCollectionViewCell.h"
#import "ZXCollectionViewLateralFlowLayout.h"
#import "ZXBlindBoxFloatTagModel.h"
#import "ZXBlindBoxViewController.h"

@interface ZXBlindBoxFloatTagView ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) ZXBlindBoxFloatTagModel *floatTagModel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionView *bottomCollectionView;

@property (nonatomic, assign) NSInteger  countIndex;

@property (nonatomic, strong) NSTimer *topTimer;
@property (nonatomic, strong) NSTimer *bottomTimer;

//开始经纬度
@property (nonatomic, assign) CLLocationCoordinate2D starPoint;

@property (nonatomic, strong) UIView  *selectView;

@end

@implementation ZXBlindBoxFloatTagView


- (instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        [self setupUI];
   
    }
    
    return self;
}


//弹幕
- (void)setupUI{
    
    self.backgroundColor = UIColor.clearColor;
    
    self.collectionView.frame = self.bounds;
    self.collectionView.mj_h = self.bounds.size.height/ 2;
    [self addSubview:self.collectionView];
    
    self.bottomCollectionView.frame = self.bounds;
    self.bottomCollectionView.mj_y = self.collectionView.mj_h;
    self.bottomCollectionView.mj_h = self.bounds.size.height/ 2;
    [self addSubview:self.bottomCollectionView];
    

}

//选中后的view
- (void)zx_initSelectView{
//    self.selectView =
}


#pragma mark - Private Method
//开启定时器轮播
- (void)zx_resumeTimerRunloopIsTop:(BOOL)isTop{
    
    if (!self.floatTagModel.catelist.count) return;;
    
    __block CGFloat topCollectionX = self.collectionView.contentOffset.x;
    __block CGFloat bottomCollectionX = self.bottomCollectionView.contentOffset.x;
    
    WEAKSELF
    
    if (isTop){
        self.topTimer = [NSTimer wg_scheduledTimerWithTimeInterval:0.02 block:^{
            STRONGSELF
            
            [self.collectionView setContentOffset:CGPointMake(topCollectionX++, 0)];
            NSLog(@"topCollectionX --- %f",topCollectionX);
            
            //如果当前不是 ZXBlindBoxViewController 自动关闭所有定时器
            if (![[WGUIManager wg_currentIndexNavTopController] isKindOfClass:[ZXBlindBoxViewController class]]){
                [self zx_pauseAllTimerRunloop];
            }
            
        } repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.topTimer forMode:NSRunLoopCommonModes];
    }
    else{
        self.bottomTimer = [NSTimer wg_scheduledTimerWithTimeInterval:0.03 block:^{
            STRONGSELF
            
            [self.bottomCollectionView setContentOffset:CGPointMake(bottomCollectionX++, 0)];
            NSLog(@"bottomCollectionX --- %f",bottomCollectionX);
            
        } repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:self.bottomTimer forMode:NSRunLoopCommonModes];
    }
    
    
    
}

//停止定时器轮播
- (void)zx_pauseTimerRunloopIsTop:(BOOL)isTop{
    
    if (isTop){
        if (self.topTimer){
            [self.topTimer invalidate];
            self.topTimer = nil;
        }
    }else{
        if (self.bottomTimer){
            [self.bottomTimer invalidate];
            self.bottomTimer = nil;
        }
    }
    
}


//暂停所有定时器
- (void)zx_pauseAllTimerRunloop{
    if (self.topTimer){
        [self.topTimer invalidate];
        self.topTimer = nil;
    }
    if (self.bottomTimer){
        [self.bottomTimer invalidate];
        self.bottomTimer = nil;
    }
}

//开始所有定时器
- (void)zx_resumeAllTimerRunloop{
    [self zx_resumeTimerRunloopIsTop:YES];
    [self zx_resumeTimerRunloopIsTop:NO];
}


//传入位置坐标
- (void)zx_inputStartPoint:(CLLocationCoordinate2D )starPoint{
    self.starPoint = starPoint;
    [self zx_reqApiGetBoxCateTypes];
}






#pragma mark - UIScrollViewDelegate
//手指拖动开始
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self zx_pauseTimerRunloopIsTop:(scrollView == self.collectionView)];
}

//手指拖动停止
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (!decelerate){
        NSLog(@"-----%f",scrollView.contentOffset.x);
        [self zx_resumeTimerRunloopIsTop:(scrollView == self.collectionView)];
    }
    
}

//手指滑块
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"-----%f",scrollView.contentOffset.x);
    [self zx_resumeTimerRunloopIsTop:(scrollView == self.collectionView)];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.countIndex;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZXBlindBoxConditionSelectBudgetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ZXBlindBoxConditionSelectBudgetCollectionViewCell wg_cellIdentifier] forIndexPath:indexPath];
    
    NSInteger index = indexPath.row % self.floatTagModel.catelist.count;
    
    ZXBlindBoxFloatTagCatelistModel *model = [self.floatTagModel.catelist wg_safeObjectAtIndex:index];
    
    int x = arc4random() % self.floatTagModel.colorlist.count;
    ZXBlindBoxFloatTagColorListModel *colorModel = [self.floatTagModel.colorlist wg_safeObjectAtIndex:x];
    
    cell.brandNameLabel.text = model.title;
    
    cell.brandNameLabel.textColor = WGHEXColor(colorModel.txtcolor);
    cell.brandNameLabel.backgroundColor = WGHEXColor(colorModel.bgcolor);
    cell.brandNameLabel.layer.borderColor = WGHEXColor(colorModel.linecolor).CGColor;
    cell.brandNameLabel.layer.borderWidth = 0.8;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.row % self.floatTagModel.catelist.count;
    
    ZXBlindBoxFloatTagCatelistModel *model = [self.floatTagModel.catelist wg_safeObjectAtIndex:index];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(zx_blindBoxFloatTagView:didSelectItemAtCateId:)]){
        [self.delegate zx_blindBoxFloatTagView:self didSelectItemAtCateId:model.cateid];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger index = indexPath.row % self.floatTagModel.catelist.count;
    
    ZXBlindBoxFloatTagCatelistModel *model = [self.floatTagModel.catelist wg_safeObjectAtIndex:index];
    
    return  CGSizeMake(model.itemWidh, 40);
}

#pragma mark - NetworkRequest

//获取可选分类
- (void)zx_reqApiGetBoxCateTypes{
        
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic wg_safeSetObject:@(self.starPoint.longitude) forKey:@"lng"];
    [dic wg_safeSetObject:@(self.starPoint.latitude) forKey:@"lat"];
    
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiGetBoxCateTypes Parameter:dic success:^(NSDictionary * _Nonnull resultDic) {
        
       
        
        
        __block NSInteger timeout = 10;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t countDownTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        //每秒执行
        dispatch_source_set_timer(countDownTimer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC,  0);
        WEAKSELF;
        dispatch_source_set_event_handler(countDownTimer, ^{
            STRONGSELF;
            if(timeout <= 0){
                
                //  当倒计时结束时
                dispatch_source_cancel(countDownTimer);
                
                //回到主线程刷新UIe
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self.floatTagModel = [ZXBlindBoxFloatTagModel wg_objectWithDictionary:[resultDic wg_safeObjectForKey:@"data"]];
                
                    if (self.floatTagModel.catelist.count == 0) return;;
                    
                    for (ZXBlindBoxFloatTagCatelistModel *model in self.floatTagModel.catelist){
                        CGFloat width = [model.title widthOfStringFont:kFontSemibold(16) height:40] + 40;
                        model.itemWidh = width;
                    }
                    
                    self.countIndex = self.floatTagModel.catelist.count * 10000;
                    
                    [self.collectionView reloadData];
                    [self.bottomCollectionView reloadData];
                    
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem: ceilf(self.countIndex / 2) inSection:0];
                    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];

                    NSIndexPath *indexPathB = [NSIndexPath indexPathForItem: ceilf(self.countIndex / 4) inSection:0];
                    [self.bottomCollectionView scrollToItemAtIndexPath:indexPathB atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
                    
                    [self zx_resumeAllTimerRunloop];
                    
                });
                
                
            } else {
                
                timeout--;
            }
            
            
            
        });
        
        dispatch_resume(countDownTimer);
        
       
        
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}



#pragma mark - lazy
//static NSString * const wg_footerIdentifier = @"wg_footerIdentifier";
- (UICollectionView *)collectionView{
    if(!_collectionView){
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;

        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        [_collectionView registerClass:[ZXBlindBoxConditionSelectBudgetCollectionViewCell class] forCellWithReuseIdentifier:[ZXBlindBoxConditionSelectBudgetCollectionViewCell wg_cellIdentifier]];
    }
    return _collectionView;
}

- (UICollectionView *)bottomCollectionView{
    if(!_bottomCollectionView){
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;

        
        _bottomCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _bottomCollectionView.delegate = self;
        _bottomCollectionView.dataSource = self;
        _bottomCollectionView.backgroundColor = [UIColor clearColor];
        _bottomCollectionView.showsVerticalScrollIndicator = NO;
        _bottomCollectionView.showsHorizontalScrollIndicator = NO;
        
        [_bottomCollectionView registerClass:[ZXBlindBoxConditionSelectBudgetCollectionViewCell class] forCellWithReuseIdentifier:[ZXBlindBoxConditionSelectBudgetCollectionViewCell wg_cellIdentifier]];
    }
    return _bottomCollectionView;
}


@end

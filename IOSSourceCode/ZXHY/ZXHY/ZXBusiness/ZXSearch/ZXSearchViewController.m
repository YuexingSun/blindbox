//
//  ZXSearchViewController.m
//  ZXHY
//
//  Created by Bern Lin on 2021/12/20.
//

#import "ZXSearchViewController.h"
#import "ZXSearchCollectionViewCell.h"
#import "ZXWaterfallsCollectionViewLayout.h"
#import "ZXHomeModel.h"
#import "ZXHomeDetailsViewController.h"


@interface ZXSearchViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
ZXWaterfallsCollectionViewLayoutDelegate,
UITextFieldDelegate
>

@property (nonatomic, strong) UITextField *searchBarTextField;
@property (nonatomic, strong) NSMutableArray  *searchList;
@property (nonatomic, strong) UICollectionView  *collectionView;
//数据
@property (nonatomic, strong) NSString  *currentPage;
@property (nonatomic, strong) NSMutableArray  *sourceList;
@property (nonatomic, strong) ZXHomeModel *homeModel;

//无数据或无网络展示
@property (nonatomic, strong) UIImageView *tipsView;
@property (nonatomic, strong) UIButton  *reloadButton;

@end

@implementation ZXSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self zx_initializationUI];
    
//    [self restartLoadData];
    
}


#pragma mark - Initialization
//初始化UI
- (void)zx_initializationUI{
    
    self.view.backgroundColor = WGGrayColor(239);
    
    [self.navigationView wg_setIsBack:NO];

    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0,0, WGNumScreenWidth(), kNavBarHeight)];
    titleView.backgroundColor = UIColor.whiteColor;
    
    //进入编辑状态
    [self.searchBarTextField becomeFirstResponder];
    [titleView addSubview:self.searchBarTextField];
    
    //取消按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.titleLabel.font = kFontBold(16);
    cancelButton.frame = CGRectMake(titleView.frame.size.width - 60, kNavBarHeight - 37, 60, 32);
    [cancelButton setTitleColor:WGGrayColor(102) forState:UIControlStateNormal];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.clipsToBounds = YES;
    [cancelButton addTarget:self action:@selector(zx_back:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:cancelButton];
    [self.navigationView addSubview:titleView];
    
    
    
    //无网络或者找不到 SearchNoNetwork  SearchNothing
    self.tipsView = [UIImageView wg_imageViewWithImageNamed:@"SearchNothing"];
    self.tipsView.hidden = YES;
    [self.view addSubview:self.tipsView];
    [self.tipsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-120);
        make.width.offset(160);
        make.height.offset(160);
    }];
   
    self.reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.reloadButton.hidden = YES;
    self.reloadButton.adjustsImageWhenHighlighted = NO;
    self.reloadButton.layer.cornerRadius = 22;
    self.reloadButton.layer.borderColor = WGRGBColor(248, 110, 151).CGColor;
    self.reloadButton.layer.borderWidth = 1;
    self.reloadButton.layer.masksToBounds = YES;
    self.reloadButton.titleLabel.font = kFontMedium(16);
    [self.reloadButton setTitle:@"重新加载" forState:UIControlStateNormal];
    [self.reloadButton setTitleColor:WGRGBColor(248, 110, 151) forState:UIControlStateNormal];
    [self.reloadButton addTarget:self action:@selector(reloadAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.reloadButton];
    [self.reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tipsView);
        make.top.equalTo(self.tipsView.mas_bottom).offset(15);
        make.width.offset(130);
        make.height.offset(44);
    }];
    
    
    
    //collectionView
    self.collectionView.frame = CGRectMake(5, kNavBarHeight, WGNumScreenWidth() - 10, WGNumScreenHeight() - kNavBarHeight - (IS_IPHONE_X_SER ? 20 : 2));
    [self.view addSubview:self.collectionView];
}




#pragma mark - Private Method
//返回
- (void)zx_back:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

// UITextField 改变搜索
- (void)zx_textFieldEditingChanged:(UITextField *)textField{
    
    // 键盘输入模式
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"]) {
        // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行搜索
        if (!position) {
            
//            [self restartLoadData];
           
        }
        // 有高亮选择的字符串，则暂不对文字进行搜索
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        
    }

}


//重新加载
- (void)reloadAction{
    [WGUIManager wg_showHUD];
    [self restartLoadData];
}

//下拉刷新
- (void)restartLoadData{
    
    self.currentPage = @"1";
    self.sourceList  = [NSMutableArray array];
    
    [self zx_reqApiInfomationGetSearchList];
}

//上拉加载
- (void)loadMore{
    
    if ([self.currentPage isEqualToString:self.homeModel.totalpage] || [self.homeModel.totalpage intValue] == 0) return;
    
    self.currentPage = [NSString stringWithFormat:@"%d", [self.currentPage intValue] + 1];
    
    [self zx_reqApiInfomationGetSearchList];
}



#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [WGUIManager wg_showHUD];
    [self restartLoadData];
    return  YES;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.sourceList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    
    
    ZXSearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ZXSearchCollectionViewCell wg_cellIdentifier] forIndexPath:indexPath];
    
    ZXHomeListModel *listModel = [self.sourceList wg_safeObjectAtIndex:indexPath.row];
    
    [cell zx_typeImage:listModel.bannerImg typeTitle:listModel.title];
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ZXHomeListModel *listModel = [self.sourceList wg_safeObjectAtIndex:indexPath.row];
    ZXHomeDetailsViewController *vc = [ZXHomeDetailsViewController new];
    [vc zx_setTypeIdToRequest:listModel.typeId];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - ZXWaterfallsCollectionViewLayoutDelegate
- (CGFloat)zx_waterfallLayout:(ZXWaterfallsCollectionViewLayout *)waterfallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath;{
    //根据图片的原始尺寸，及显示宽度，等比例缩放来计算显示高度
    
    ZXHomeListModel *listModel = [self.sourceList wg_safeObjectAtIndex:indexPath.row];
    CGFloat itemHeight = listModel.bannerImg.size.height / listModel.bannerImg.size.width * itemWidth;
        
    return itemHeight + 50;
}
    



#pragma mark - NetworkRequest
//获取首页信息流搜索列表
- (void)zx_reqApiInfomationGetSearchList{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic wg_safeSetObject:self.searchBarTextField.text forKey:@"title"];
    [dic wg_safeSetObject:self.currentPage forKey:@"page"];
    [dic wg_safeSetObject:@"10" forKey:@"limit"];
    
    
    WEAKSELF;
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiInfomationGetSearchList Parameter:dic success:^(NSDictionary * _Nonnull resultDic) {
        STRONGSELF;
        
        
    
        self.homeModel = [ZXHomeModel wg_objectWithDictionary:[resultDic wg_safeObjectForKey:@"data"]];
        
        for (ZXHomeListModel *listModel in self.homeModel.list){
            
            [[UIImageView new] wg_setImageWithURL:[NSURL URLWithString:listModel.banner] completed:^(UIImage *image, NSError *error, WGImageCacheType cacheType, NSURL *imageURL) {
                listModel.bannerImg = image;
                [self.sourceList wg_safeAddObject:listModel];
            }];
        }
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [WGUIManager wg_hideHUD];
            
            self.collectionView.mj_footer.hidden = ([self.currentPage isEqualToString:self.homeModel.totalpage] || [self.homeModel.totalpage intValue] == 0);
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
            [self.collectionView reloadData];
            
            
            self.tipsView.hidden = self.sourceList.count;
            self.reloadButton.hidden = YES;
            self.collectionView.hidden = !self.sourceList.count;
            self.tipsView.image = IMAGENAMED(@"SearchNothing");
            [self.tipsView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(160);
            }];
        });
        
       
        
    } failure:^(NSError * _Nonnull error) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        
        self.collectionView.hidden = YES;
        self.tipsView.hidden = NO;
        self.reloadButton.hidden = NO;
        self.tipsView.image = IMAGENAMED(@"SearchNoNetwork");
        [self.tipsView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(130);
        }];
        
    }];
}



#pragma mark - layz
- (UITextField *)searchBarTextField{

    if(!_searchBarTextField){
        
        _searchBarTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, kNavBarHeight - 37, WGNumScreenWidth() -70 - 16, 32)];
        _searchBarTextField.tintColor = UIColor.blackColor;
        _searchBarTextField.backgroundColor =  WGGrayColor(239);
        _searchBarTextField.layer.cornerRadius = 16;
        _searchBarTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" 搜索文章" attributes:@{NSForegroundColorAttributeName: WGGrayColor(153),NSFontAttributeName:kFontMedium(14)}];
        
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _searchBarTextField.frame.size.height, _searchBarTextField.frame.size.height)];
        UIImageView * searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7, 18, 18)];
        searchImageView.image = IMAGENAMED(@"search");
        searchImageView.contentMode = UIViewContentModeScaleAspectFit;
        [leftView addSubview:searchImageView];
        _searchBarTextField.leftView = leftView;
        
        _searchBarTextField.leftViewMode = UITextFieldViewModeAlways;
        _searchBarTextField.rightViewMode = UITextFieldViewModeAlways;
        _searchBarTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchBarTextField.clipsToBounds = YES;
        _searchBarTextField.textColor = [UIColor blackColor];
        _searchBarTextField.delegate = self;
        _searchBarTextField.returnKeyType = UIReturnKeySearch;
        _searchBarTextField.font = kFontMedium(15);
        
        _searchBarTextField.delegate = self;
        
        [_searchBarTextField addTarget:self action:@selector(zx_textFieldEditingChanged:) forControlEvents:(UIControlEventEditingChanged)];
       
    }
    return _searchBarTextField;
}


- (UICollectionView *)collectionView{
    if(!_collectionView){

        //创建瀑布流布局
        ZXWaterfallsCollectionViewLayout *waterfallLayout = [ZXWaterfallsCollectionViewLayout zx_waterFallLayoutWithColumnCount:2];
        waterfallLayout.delegate = self;

        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:waterfallLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.clearColor;
        _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;

        
        [_collectionView registerClass:[ZXSearchCollectionViewCell class] forCellWithReuseIdentifier:[ZXSearchCollectionViewCell wg_cellIdentifier]];
        
        [WGCommonRefreshUtil configRefreshInScrollView:_collectionView target:self action:@selector(restartLoadData) headerRefreshType:WGCommonHeaderRefreshTypeRed];
        [WGCommonRefreshUtil configLoadMoreInScrollView:_collectionView target:self action:@selector(loadMore)];
    }
    return _collectionView;
}


@end

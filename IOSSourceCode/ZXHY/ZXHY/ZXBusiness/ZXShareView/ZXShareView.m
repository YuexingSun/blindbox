//
//  ZXShareView.m
//  ZXHY
//
//  Created by Bern Lin on 2021/12/23.
//

#import "ZXShareView.h"
#import "ZXCollectionViewLateralFlowLayout.h"
#import "ZXShareCollectionViewCell.h"

@interface ZXShareView()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *typeImageList;
@property (nonatomic, strong) NSArray *typeTitleList;

@end

@implementation ZXShareView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        
        [self setupUI];
        [self zx_dataSource];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
   
}


#pragma mark - Initialization UI

- (void)setupUI{
    
    self.backgroundColor = WGGrayColor(255);
    [self wg_setRoundedCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) radius:16];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 15, WGNumScreenWidth() - 50, 20)];
    titleLabel.textColor = WGGrayColor(102);
    titleLabel.numberOfLines = 1;
    titleLabel.font = kFontSemibold(15);
    titleLabel.text = @"分享这篇文章";
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setImage:IMAGENAMED(@"close") forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.frame = CGRectMake(WGNumScreenWidth() - 50, 7.5, 35, 35);
    [self addSubview:cancelButton];
    
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(25, 51, WGNumScreenWidth() - 50, 1)];
    lineView.backgroundColor = WGGrayColor(238);
    [self addSubview:lineView];
    
    
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.right.equalTo(self.mas_right).offset(-20);
        make.top.mas_equalTo(lineView.mas_bottom).offset(10);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
    
    }];
    
}

#pragma mark - Private Method
//数据源初始化
- (void)zx_dataSource{
   self.typeImageList = @[@"weChat",@"weChatCircle",@"shareLink",@"report"];
    self.typeTitleList = @[@"微信",@"朋友圈",@"复制链接",@"举报"];
    
    [self.collectionView reloadData];
    
}



#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.typeImageList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ZXShareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ZXShareCollectionViewCell wg_cellIdentifier] forIndexPath:indexPath];
    
    NSString *imgStr = [self.typeImageList wg_safeObjectAtIndex:indexPath.row];
    [cell zx_typeImage:IMAGENAMED(imgStr) typeTitle:[self.typeTitleList wg_safeObjectAtIndex:indexPath.row]];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(zx_shareView:SelectItemAtIndexPath:)]){
        [self.delegate zx_shareView:self SelectItemAtIndexPath:indexPath];
    }
}


#pragma mark - lazy
//static NSString * const wg_footerIdentifier = @"wg_footerIdentifier";
- (UICollectionView *)collectionView{
    if(!_collectionView){
        
        ZXCollectionViewLateralFlowLayout *layout = [[ZXCollectionViewLateralFlowLayout alloc] init];
        layout.size =   CGSizeMake((WGNumScreenWidth() -30) / 4 , 110);
        layout.row = 2;
        layout.column = 4;
        layout.columnSpacing = 0;
        layout.rowSpacing = 10;
        layout.pageWidth = WGNumScreenWidth() -40;

        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        [_collectionView registerClass:[ZXShareCollectionViewCell class] forCellWithReuseIdentifier:[ZXShareCollectionViewCell wg_cellIdentifier]];
    }
    return _collectionView;
}


//取消响应
- (void)cancelAction:(UIButton *)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(zx_closeShareView:)]){
        [self.delegate zx_closeShareView:self];
    }
}


@end

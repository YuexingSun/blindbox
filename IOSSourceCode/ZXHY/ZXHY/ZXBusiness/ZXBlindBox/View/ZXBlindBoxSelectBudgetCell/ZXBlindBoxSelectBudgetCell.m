//
//  ZXBlindBoxSelectBudgetCell.m
//  ZXHY
//
//  Created by Bern Mac on 8/5/21.
//

#import "ZXBlindBoxSelectBudgetCell.h"
#import "ZXBlindBoxSelectHeaderCollectionViewCell.h"
#import "ZXBlindBoxSelectViewModel.h"
#import "ZXCollectionViewLateralFlowLayout.h"


@interface ZXBlindBoxSelectBudgetCell()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ZXBlindBoxSelectViewModel  *blindBoxSelectViewModel;

@end


@implementation ZXBlindBoxSelectBudgetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)wg_cellIdentifier{
    return @"ZXBlindBoxSelectBudgetCellID";
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self setupUI];
    }
    return self;
}


//设置UI
- (void)setupUI{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = UIColor.clearColor;
    self.backgroundColor = UIColor.clearColor;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, WGNumScreenWidth() - 20, 25)];
    titleLabel.textColor = kMainTitleColor;
    titleLabel.numberOfLines = 1;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.text = @"人均预算";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(30);
        make.height.offset(120);
    }];
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.blindBoxSelectViewModel.itemlist.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ZXBlindBoxSelectHeaderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ZXBlindBoxSelectHeaderCollectionViewCell wg_cellIdentifier] forIndexPath:indexPath];
    
    ZXBlindBoxSelectViewItemlistModel *itemlistModel = [self.blindBoxSelectViewModel.itemlist wg_safeObjectAtIndex:indexPath.row];
    
    [cell zx_setBlindBoxSelectViewItemlistModel:itemlistModel];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    for (ZXBlindBoxSelectViewItemlistModel *itemlistModel in self.blindBoxSelectViewModel.itemlist){
        itemlistModel.select = NO;
    }
    
    ZXBlindBoxSelectViewItemlistModel *itemlistModel = [self.blindBoxSelectViewModel.itemlist wg_safeObjectAtIndex:indexPath.row];
    itemlistModel.select = !itemlistModel.select;
    [collectionView reloadData];
    
    
    if ([self.blindBoxSelectViewModel.ID intValue] == 4){
        if(self.delegate && [self.delegate respondsToSelector:@selector(selectBudgetCell: BlindBoxSelectViewItemlistModel:)]){
            [self.delegate selectBudgetCell:self BlindBoxSelectViewItemlistModel:itemlistModel];
        }
    }
    
}


#pragma mark - UICollectionViewDelegateFlowLayout

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    return  CGSizeMake(WGNumScreenWidth() / 3 - 20, 50);
//}

#pragma mark - Private Method
//数据赋值
- (void)zx_setBlindBoxSelectViewModel:(ZXBlindBoxSelectViewModel *)blindBoxSelectViewModel{
    if (!blindBoxSelectViewModel) return;
    
    self.blindBoxSelectViewModel = blindBoxSelectViewModel;
    
    self.titleLabel.text = self.blindBoxSelectViewModel.title;
    
    [self.collectionView reloadData];
}


#pragma mark - lazy
//static NSString * const wg_footerIdentifier = @"wg_footerIdentifier";
- (UICollectionView *)collectionView{
    if(!_collectionView){
        
        ZXCollectionViewLateralFlowLayout *layout = [[ZXCollectionViewLateralFlowLayout alloc] init];
        layout.size =   CGSizeMake((WGNumScreenWidth() - 30 )/ 3 - 8, 50);
        layout.row = 2;
        layout.column = 3;
        layout.columnSpacing = 10;
        layout.rowSpacing = 8;
        layout.pageWidth = WGNumScreenWidth() - 30;

        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        [_collectionView registerClass:[ZXBlindBoxSelectHeaderCollectionViewCell class] forCellWithReuseIdentifier:[ZXBlindBoxSelectHeaderCollectionViewCell wg_cellIdentifier]];
    }
    return _collectionView;
}

@end

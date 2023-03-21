//
//  ZXMineAchievementCell.m
//  ZXHY
//
//  Created by Bern Mac on 8/28/21.
//

#import "ZXMineAchievementCell.h"
#import "ZXCollectionViewLateralFlowLayout.h"
#import "ZXBlindBoxSelectHeaderCollectionViewCell.h"
#import "ZXMineAchievementCollectionViewCell.h"
#import "ZXMineModel.h"


@interface ZXMineAchievementCell ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) ZXMineModel *mineModel;

@end

@implementation ZXMineAchievementCell



- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.bgView.layer.cornerRadius = 5;
    

    [self zx_setCollectionView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


#pragma mark - Private Method

+ (NSString *)wg_cellIdentifier{
    return @"ZXMineAchievementCellID";
}

//设置CollectionView
- (void)zx_setCollectionView{
   
    ZXCollectionViewLateralFlowLayout *layout = [[ZXCollectionViewLateralFlowLayout alloc] init];
    layout.size =   CGSizeMake((WGNumScreenWidth() - 30)/ 4, 130);
    layout.row = 2;
    layout.column = 4;
    layout.columnSpacing = 0;
    layout.rowSpacing = 0;
    layout.pageWidth = WGNumScreenWidth() - 30 ;
    
    [self.collectionView setCollectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    [self.collectionView registerClass:[ZXBlindBoxSelectHeaderCollectionViewCell class] forCellWithReuseIdentifier:[ZXBlindBoxSelectHeaderCollectionViewCell wg_cellIdentifier]];

    [self.collectionView registerNib:[UINib nibWithNibName:@"ZXMineAchievementCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:[ZXMineAchievementCollectionViewCell wg_cellIdentifier]];
}


//数据赋值
- (void)zx_dataWithMineModel:(ZXMineModel *)mineModel{
    self.mineModel = mineModel;
    [self.collectionView reloadData];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.mineModel.myachievelist.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ZXMineMyAchieveListModel *listModel = [self.mineModel.myachievelist wg_safeObjectAtIndex:indexPath.row];
    
    ZXMineAchievementCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ZXMineAchievementCollectionViewCell wg_cellIdentifier] forIndexPath:indexPath];
    
    [cell zx_dataWithMineMyAchieveListModel:listModel];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
}


@end

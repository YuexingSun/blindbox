//
//  WGImageCollectionView.m
//  Yunhuoyouxuan
//
//  Created by Apple on 2020/12/3.
//  Copyright © 2020 apple. All rights reserved.
//

#import "WGImageCollectionView.h"
#import "WGImageCollectionViewCell.h"
#import "WGImageBrowser.h"


@interface WGImageCollectionView()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, assign) CGFloat cellWidth;

@end

@implementation WGImageCollectionView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initProperty];
        [self initSubView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initProperty];
        [self initSubView];
    }
    return self;
}

- (void)initProperty
{
    self.cellVerticalGap = 3.0;
    self.cellHorizontalGap = 7.0;
    self.maxCellNum = 9;
    self.cellHorizontalNum = 3;
}

- (void)initSubView
{
    [self addSubview:self.collectionView];
    
    [self.collectionView reloadData];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;
    self.collectionView.mj_h += 5;
}


- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        CGFloat selfWith = self.frame.size.width ? self.frame.size.width : WGNumScreenWidth()-48.0;
        self.cellWidth = (selfWith - self.cellHorizontalGap * (self.cellHorizontalNum - 1))/self.cellHorizontalNum;
        _layout.itemSize = CGSizeMake(self.cellWidth, self.cellWidth);
        _layout.minimumInteritemSpacing = self.cellVerticalGap;
        _layout.minimumLineSpacing = self.cellHorizontalGap;
        [self.collectionView setCollectionViewLayout:_layout];
        
        [_collectionView registerClass:[WGImageCollectionViewCell class] forCellWithReuseIdentifier:WGImageCollectionViewCellID];
    }
    return _collectionView;
}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.selectedPhotos.count >= self.maxCellNum) {
        return self.selectedPhotos.count;
    }
    
    return self.selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WGImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WGImageCollectionViewCellID forIndexPath:indexPath];
    if (indexPath.item == self.selectedPhotos.count) {
        cell.bgImage = [UIImage wg_imageNamed:@"mine_upload-pictures"];
        cell.deleteBtnHidden = YES;
    } else {
        cell.bgImage = _selectedPhotos[indexPath.item];
        cell.deleteBtnHidden = NO;
        WEAKSELF
        cell.deleteCallback = ^(){
            STRONGSELF
            [self deleteImageWithIndex:indexPath.row];
        };
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [[WGUIManager wg_topViewController].view endEditing:YES];
    if (indexPath.item == self.selectedPhotos.count) {
        if (self.addImageBlock) {
            self.addImageBlock();
        }
    } else {  // 预览照片
        [WGImageBrowser wg_showImageBrowserWithImages:self.selectedPhotos index:indexPath.row];
    }
}


//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//
//    return [self zx_computeSizeForItemAtIndexPath:indexPath];
//}

#pragma mark - 事件交互
- (void)deleteImageWithIndex:(NSInteger)index
{
    if (self.deleteImageBlock) {
        self.deleteImageBlock(index);
    }
}

#pragma mark - public method
- (void)setSelectedPhotos:(NSMutableArray *)selectedPhotos
{
    _selectedPhotos = selectedPhotos;
    [_collectionView reloadData];
    
    if (self.heightChangeBlock) {
        CGFloat maxHeight = [self getImageCollectionViewHeight];
        self.heightChangeBlock(maxHeight);
    }
}

- (CGFloat)getImageCollectionViewHeight
{
    NSInteger lineNum = (NSInteger)([self collectionView:self.collectionView numberOfItemsInSection:0]/self.cellHorizontalNum);
    NSInteger notFullLine = (NSInteger)([self collectionView:self.collectionView numberOfItemsInSection:0]%self.cellHorizontalNum);
    CGFloat maxHeight = (self.cellWidth + self.cellVerticalGap) * (lineNum + (notFullLine ? 1 : 0)) - self.cellVerticalGap  + 6.0;
    return maxHeight;
}


- (void)zx_CollectionViewReload{
    [self.collectionView reloadData];
}
@end

//
//  ZXMsgEmojiView.m
//  ZXHY
//
//  Created by Bern Lin on 2022/2/23.
//

#import "ZXMsgEmojiView.h"
#import "ZXCollectionViewLateralFlowLayout.h"
#import "ZXMsgEmojiCollectionViewCell.h"
#import "ZXEmojiAttachment.h"

@interface ZXMsgEmojiView()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, strong) NSMutableArray *typeImageList;
@property(nonatomic, strong)  NSMutableArray *emojiAttachmentList;

@end

@implementation ZXMsgEmojiView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}


- (void)setupUI{
    
    self.backgroundColor = WGGrayColor(248);
    
    //数据处理
    self.typeImageList = [NSMutableArray array];
    self.emojiAttachmentList = [NSMutableArray array];
    
    for (int i = 1; i <= 20; i++){
        @autoreleasepool {
            
            NSString *str = [NSString stringWithFormat:@"emoji-%03d",i];
    
            [self.typeImageList wg_safeAddObject:str];
            
            ZXEmojiAttachment *emojiAttachment = [[ZXEmojiAttachment alloc] init];
            emojiAttachment.imageName = str;
            emojiAttachment.tagName = [NSString stringWithFormat:@"[%@]",str];
            [self.emojiAttachmentList wg_safeAddObject:emojiAttachment];
        };
    }
    
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(30);
        make.right.equalTo(self.mas_right).offset(-30);
        make.top.mas_equalTo(self.mas_top).offset(0.1);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-30);
    
    }];
    
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
    
    ZXMsgEmojiCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ZXMsgEmojiCollectionViewCell wg_cellIdentifier] forIndexPath:indexPath];
   
    NSString *str = [self.typeImageList wg_safeObjectAtIndex:indexPath.row];
   
    UIImage *image = IMAGENAMED(str);
   
    [cell zx_typeImage:image];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    ZXEmojiAttachment *emojiAttachment = [self.emojiAttachmentList wg_safeObjectAtIndex:indexPath.row];
    
 
    if(self.delegate && [self.delegate respondsToSelector:@selector(zx_selectEmojiView:SelectItemAtEmojiAttachment:)]){
        [self.delegate zx_selectEmojiView:self SelectItemAtEmojiAttachment:emojiAttachment];
    }
}


#pragma mark - lazy
//static NSString * const wg_footerIdentifier = @"wg_footerIdentifier";
- (UICollectionView *)collectionView{
    if(!_collectionView){
        
        CGFloat width = (WGNumScreenWidth() - 60) / 5 - 10;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = CGSizeMake( width, width);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        [_collectionView registerClass:[ZXMsgEmojiCollectionViewCell class] forCellWithReuseIdentifier:[ZXMsgEmojiCollectionViewCell wg_cellIdentifier]];
    }
    return _collectionView;
}


@end

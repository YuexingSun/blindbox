//
//  ZXMineAchievementCollectionViewCell.m
//  ZXHY
//
//  Created by Bern Mac on 8/29/21.
//

#import "ZXMineAchievementCollectionViewCell.h"
#import "ZXMineModel.h"


@interface ZXMineAchievementCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end


@implementation ZXMineAchievementCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - Private Method

+ (NSString *)wg_cellIdentifier{
    return @"ZXMineAchievementCollectionViewCellID";
}


//数据赋值
- (void)zx_dataWithMineMyAchieveListModel:(ZXMineMyAchieveListModel *)listModel;{
//    achieveid : 3
//   title : "成就名称",
//   pic : "http://a.png",
//   lightpic : "http://b.png",
//   islight : 0/1,
    
    NSString *imageStr = (listModel.islight == 1) ? listModel.lightpic: listModel.pic;
    [self.logoImageView wg_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:nil];
    
    self.nameLabel.text = listModel.title;
    
}

@end

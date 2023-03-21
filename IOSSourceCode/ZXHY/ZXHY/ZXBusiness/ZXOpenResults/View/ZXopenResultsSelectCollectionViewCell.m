//
//  ZXopenResultsSelectCollectionViewCell.m
//  ZXHY
//
//  Created by Bern Mac on 8/31/21.
//

#import "ZXopenResultsSelectCollectionViewCell.h"
#import "ZXOpenResultsModel.h"

@interface ZXopenResultsSelectCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *boxImageView;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;

@end

@implementation ZXopenResultsSelectCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (NSString *)wg_cellIdentifier{
    return @"ZXopenResultsSelectCollectionViewCellID";
}


- (void)zx_setDataWithResultModel:(ZXOpenResultsModel *)resultsModel ForItemAtIndexPath:(NSIndexPath *)indexPath{
 
    self.selectImageView.image = (resultsModel.selectBox)? IMAGENAMED(@"BoxSelect"): IMAGENAMED(@"BoxNotSelect");
    
    NSString *boxImageStr = @"";
    if (indexPath.row == 0){
        boxImageStr = @"BoxEat";
    }else if (indexPath.row == 1){
        boxImageStr = @"BoxGame";
    }else if (indexPath.row == 2){
        boxImageStr = @"BoxDrink";
    }
    
    self.boxImageView.image = IMAGENAMED(boxImageStr);
}

@end

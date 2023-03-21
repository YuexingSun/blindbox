//
//  ZXMineIsBeginCell.m
//  ZXHY
//
//  Created by Bern Mac on 8/27/21.
//

#import "ZXMineIsBeginCell.h"

@interface ZXMineIsBeginCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *goSeeButton;

@end

@implementation ZXMineIsBeginCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bgView.layer.cornerRadius = 5;
    self.goSeeButton.layer.cornerRadius = 15;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}


+ (NSString *)wg_cellIdentifier{
    return @"ZXMineIsBeginCellID";
}

- (IBAction)goSeeAction:(UIButton *)sender {
    [[AppDelegate wg_sharedDelegate].tabBarController changeToSelectedIndex:WGTabBarType_Box];
    
}

//数据赋值
- (void)zx_dataWithMineModel:(ZXMineModel *)mineModel{
    
}

@end

//
//  ZXMineInfoCell.m
//  ZXHY
//
//  Created by Bern Mac on 8/27/21.
//

#import "ZXMineInfoCell.h"
#import "ZXMineBoxViewController.h"
#import "ZXMyCollectionViewController.h"
#import "ZXMinePropsViewController.h"
#import "ZXMineModel.h"


@interface ZXMineInfoCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *boxNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *propsNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *boxButton;
@property (weak, nonatomic) IBOutlet UIButton *propsButton;

@end

@implementation ZXMineInfoCell

+ (NSString *)wg_cellIdentifier{
    return @"ZXMineInfoCellID";
}

- (void)awakeFromNib {
    [super awakeFromNib];

    self.bgView.layer.cornerRadius = 5;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)myBoxAction:(UIButton *)sender {
    
    ZXMineBoxViewController  *vc = [ZXMineBoxViewController new];
    [[WGUIManager wg_currentIndexNavTopController].navigationController pushViewController:vc animated:YES];
}

- (IBAction)myPropsAction:(UIButton *)sender {
    ZXMyCollectionViewController *vc = [ZXMyCollectionViewController new];
    [[WGUIManager wg_currentIndexNavTopController].navigationController pushViewController:vc animated:YES];
}



//数据赋值
- (void)zx_dataWithMineModel:(ZXMineModel *)mineModel{
    
    self.boxNumLabel.text = mineModel.myboxnum;
    
    self.propsNumLabel.text = mineModel.mypropsnum;
}


@end

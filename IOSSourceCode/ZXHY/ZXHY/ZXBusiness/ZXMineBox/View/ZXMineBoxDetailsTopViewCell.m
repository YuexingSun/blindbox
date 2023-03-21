//
//  ZXMineBoxDetailsViewCell.m
//  ZXHY
//
//  Created by Bern Mac on 8/30/21.
//

#import "ZXMineBoxDetailsTopViewCell.h"
#import "ZXOpenResultsModel.h"


@interface ZXMineBoxDetailsTopViewCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *destinationLabel;

@end

@implementation ZXMineBoxDetailsTopViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 5;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (NSString *)wg_cellIdentifier{
    return @"ZXMineBoxDetailsTopViewCellID";
}

//数据赋值
- (void)zx_dataWithMineBoxResultsModel:(ZXOpenResultsModel *)resultsModel{
    
    if (resultsModel.status == 4 || resultsModel.status == 5){
        self.statusLabel.text = @"已失效";
        self.statusTipLabel.text = @"用户主动终止行程/行程已超时";
        self.destinationLabel.text = @"未到达目的地";
    }else{
        self.statusLabel.text = @"已完成";
        self.statusTipLabel.text = @"恭喜！已走完整个行程";
        self.destinationLabel.text = @"已到达目的地";
    }
        
}


@end

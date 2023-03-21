//
//  ZXMineBoxListViewCell.m
//  ZXHY
//
//  Created by Bern Mac on 8/27/21.
//

#import "ZXMineBoxListViewCell.h"
#import "ZXMineBoxModel.h"

@interface ZXMineBoxListViewCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *boxNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusImgView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UIImageView *timeImgView;
@property (weak, nonatomic) IBOutlet UIImageView *locationImgView;


@end

@implementation ZXMineBoxListViewCell

+ (NSString *)wg_cellIdentifier{
    return @"ZXMineBoxListViewCellID";
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bgView.layer.cornerRadius = 5;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.statusLabel.hidden = YES;
    self.statusImgView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//数据赋值
- (void)zx_dataWithMineBoxModel:(ZXMineBoxListModel *)boxListModel{
    
    NSArray *list = @[@"待开启",@"进行中",@"待评价",@"已完成",@"已失效",@"已失效"];
    
    self.boxNameLabel.text = boxListModel.title;
    
   
    self.timeLabel.text = boxListModel.time;
    
    self.addressLabel.text = boxListModel.subtitle;
    
    
    self.statusLabel.hidden = YES;
    self.statusImgView.hidden = YES;

    switch (boxListModel.status) {
        case 1:
            self.statusLabel.hidden = NO;
            self.statusLabel.text = [list wg_safeObjectAtIndex:boxListModel.status];
           
            self.locationImgView.image = IMAGENAMED(@"MineBoxLocationBlue");
            self.timeImgView.image = IMAGENAMED(@"MineBoxTimeBlue");
            break;
            
        case 2:
            self.statusImgView.hidden = NO;
            self.statusImgView.image = IMAGENAMED(@"BoxStatusNotEvaluated");
            
            self.locationImgView.image = IMAGENAMED(@"MineBoxLocationYellow");
            self.timeImgView.image = IMAGENAMED(@"MineBoxTimeYellow");
            
            break;
        case 3:
            self.statusImgView.hidden = NO;
            self.statusImgView.image = IMAGENAMED(@"BoxStatusCompleted");
            
            self.locationImgView.image = IMAGENAMED(@"MineBoxLocationGreen");
            self.timeImgView.image = IMAGENAMED(@"MineBoxTimeGreen");
            
            break;
        case 4:
            
            self.statusImgView.hidden = NO;
            self.statusImgView.image = IMAGENAMED(@"BoxStatusExpired");
            
            self.locationImgView.image = IMAGENAMED(@"MineBoxLocationRed");
            self.timeImgView.image = IMAGENAMED(@"MineBoxTimeRed");
            
            break;
        case 5:
            self.statusImgView.hidden = NO;
            self.statusImgView.image = IMAGENAMED(@"BoxStatusExpired");
            
            self.locationImgView.image = IMAGENAMED(@"MineBoxLocationRed");
            self.timeImgView.image = IMAGENAMED(@"MineBoxTimeRed");
            break;
            
            
        default:
            break;
    }
    
}

@end

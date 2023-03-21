//
//  ZXGeneralSheetTableViewCell.m
//  ZXHY
//
//  Created by Bern Lin on 2021/12/24.
//

#import "ZXGeneralSheetTableViewCell.h"

@interface ZXGeneralSheetTableViewCell()

@property (nonatomic, strong)  UILabel *label;

@end

@implementation ZXGeneralSheetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)wg_cellIdentifier{
    return @"ZXGeneralSheetTableViewCell";
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self initSubView];
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
}


- (void)initSubView{
    
    self.backgroundColor = UIColor.whiteColor;
    self.contentView.backgroundColor = UIColor.clearColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    UILabel *label = [UILabel labelWithFont:kFontMedium(18) TextAlignment:NSTextAlignmentCenter TextColor:WGGrayColor(0) TextStr:@"" NumberOfLines:1];
    [self.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.mas_equalTo(self.contentView);
    }];
    self.label = label;
    
    //line
    UIView *lineView = [UIView new];
    lineView.backgroundColor = WGGrayColor(238);
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.mas_top).offset(-1);
        make.top.right.left.mas_equalTo(self);
        make.height.offset(1);
    }];
}


- (void)zx_setLabelText:(NSString *)text TextColor:(UIColor *)color{
    self.label.text = text;
    self.label.textColor = color;
}

@end

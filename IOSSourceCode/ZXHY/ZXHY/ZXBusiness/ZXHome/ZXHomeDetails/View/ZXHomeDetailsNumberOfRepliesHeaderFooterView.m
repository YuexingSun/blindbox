//
//  ZXHomeDetailsNumberOfRepliesHeaderFooterView.m
//  ZXHY
//
//  Created by Bern Lin on 2021/12/22.
//

#import "ZXHomeDetailsNumberOfRepliesHeaderFooterView.h"
#import "ZXHomeModel.h"
#import "ZXHomeDetailsCommentModel.h"


@interface ZXHomeDetailsNumberOfRepliesHeaderFooterView()

@property (nonatomic, strong)  UILabel *repliesLabel;

@end

@implementation ZXHomeDetailsNumberOfRepliesHeaderFooterView

+ (NSString *)wg_cellIdentifier{
    return @"ZXHomeDetailsNumberOfRepliesHeaderFooterView";
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initSubView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
}


- (void)initSubView{
    
    self.backgroundColor = UIColor.whiteColor;
    self.contentView.backgroundColor = UIColor.whiteColor;
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = WGGrayColor(238);
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.height.offset(1);
    }];
    
    //回复数
    self.repliesLabel = [UILabel labelWithFont:kFontMedium(14) TextAlignment:NSTextAlignmentLeft TextColor:WGGrayColor(153) TextStr:@"最新回复（共0条）" NumberOfLines:1];
    [self.contentView addSubview:self.repliesLabel];
    [self.repliesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.height.mas_equalTo(20);
    }];
}

- (void)zx_setDetailsCommentModel:(ZXHomeDetailsCommentModel *)commentModel{
    self.repliesLabel.text = [NSString stringWithFormat:@"最新回复（共%@条）" ,commentModel.totalnum];
}


@end

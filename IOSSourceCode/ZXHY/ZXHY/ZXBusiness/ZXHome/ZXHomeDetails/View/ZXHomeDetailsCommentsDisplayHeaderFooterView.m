//
//  ZXHomeDetailsCommentsDisplayHeaderFooterView.m
//  ZXHY
//
//  Created by Bern Lin on 2021/12/23.
//

#import "ZXHomeDetailsCommentsDisplayHeaderFooterView.h"
#import "ZXHomeDetailsCommentModel.h"

@interface ZXHomeDetailsCommentsDisplayHeaderFooterView()

@property (nonatomic, strong)  UILabel  *displayLabel;
@property (nonatomic, strong)  UIButton *displayButton;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) ZXHomeDetailsCommentListModel  *commentListModel;

@end


@implementation ZXHomeDetailsCommentsDisplayHeaderFooterView

+ (NSString *)wg_cellIdentifier{
    return @"ZXHomeDetailsCommentsDisplayHeaderFooterView";
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
    
    //展示
    self.displayLabel = [UILabel labelWithFont:kFontSemibold(14) TextAlignment:NSTextAlignmentLeft TextColor:WGRGBAlpha(248, 110, 151, 1) TextStr:@"展开 0 条回复" NumberOfLines:1];
    [self.contentView addSubview:self.displayLabel];
    [self.displayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView.mas_left).offset(95);
    }];
    
    //箭头
    UIImageView *arrowImageView = [UIImageView wg_imageViewWithImageNamed:@"homeDetailsDown"];
    [self.contentView addSubview:arrowImageView];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.displayLabel);
        make.left.mas_equalTo(self.displayLabel.mas_right).offset(0);
        make.width.height.offset(25);
    }];
    self.arrowImageView = arrowImageView;
    
    //按钮
    self.displayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.displayButton.adjustsImageWhenHighlighted = NO;
    [self.displayButton addTarget:self action:@selector(displayAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.displayButton];
    [self.displayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(self.contentView);
    }];
    
}

-(void)displayAction:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    
    self.commentListModel.isDisplayAll = sender.selected;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(zx_dispalyDisplayHeaderFooterView:)]){
        [self.delegate zx_dispalyDisplayHeaderFooterView:self];
    }
}

- (void)zx_setCommentListModel:(ZXHomeDetailsCommentListModel *)commentListModel{
    self.commentListModel = commentListModel;
    
    self.displayLabel.text = (self.commentListModel.isDisplayAll) ? @"收起回复" : [NSString stringWithFormat:@"展开 %ld 条回复",self.commentListModel.replylist.count - 2] ;
    
    self.displayButton.selected = self.commentListModel.isDisplayAll;
    
    self.arrowImageView.image = (self.commentListModel.isDisplayAll) ? IMAGENAMED(@"homeDetailsUp"): IMAGENAMED(@"homeDetailsDown");
    
    
}


@end

//
//  ZXHomeDetailsCommentsHeaderFooterView.m
//  ZXHY
//
//  Created by Bern Lin on 2021/12/22.
//

#import "ZXHomeDetailsCommentsHeaderFooterView.h"
#import "ZXHomeDetailsCommentModel.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ZXHomeTableViewCell.h"


@interface ZXHomeDetailsCommentsHeaderFooterView()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong)  UILabel *nameLabel;
@property (nonatomic, strong)  UILabel *replyLabel;
@property (nonatomic, strong)  UILabel *timeLabel;
@property (nonatomic, strong)  UIButton *clickButton;
@property (nonatomic, strong) ZXHomeDetailsCommentListModel *commentListModel;

@end

@implementation ZXHomeDetailsCommentsHeaderFooterView

+ (NSString *)wg_cellIdentifier{
    return @"ZXHomeDetailsCommentsHeaderFooterView";
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
    
    //头像
    UIImageView *iconView = [UIImageView wg_imageViewWithImageNamed:@"ManSelect"];
    [iconView wg_setLayerRoundedCornersWithRadius:16];
    [self.contentView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(12);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.width.height.offset(32);
    }];
    self.iconView = iconView;
    
    //名字
    UILabel *nameLabel = [UILabel labelWithFont:kFontSemibold(14) TextAlignment:NSTextAlignmentLeft TextColor:WGRGBAlpha(153, 153, 153, 0.8) TextStr:@"留言作者" NumberOfLines:1];
    [self.contentView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(iconView);
        make.left.mas_equalTo(iconView.mas_right).offset(8);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
    }];
    self.nameLabel = nameLabel;
    
    
    //时间
    UILabel *timeLabel = [UILabel labelWithFont:kFont(10) TextAlignment:NSTextAlignmentLeft TextColor:WGRGBAlpha(153, 153, 153, 0.8) TextStr:@"3分钟前" NumberOfLines:1];
    [self.contentView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-8);
        make.left.right.mas_equalTo(nameLabel);
        make.height.offset(15);
    }];
    self.timeLabel = timeLabel;
    
    
    //回复
    UILabel *replyLabel = [UILabel labelWithFont:kFontMedium(15) TextAlignment:NSTextAlignmentLeft TextColor:WGGrayColor(51) TextStr:@"" NumberOfLines:0];
    [self.contentView addSubview:replyLabel];             
    [replyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nameLabel.mas_bottom).offset(0);
        make.left.right.mas_equalTo(nameLabel);
        make.bottom.mas_equalTo(self.timeLabel.mas_top).offset(-5);
    }];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"" attributes: @{NSFontAttributeName: kFontMedium(15),NSForegroundColorAttributeName: WGGrayColor(51)}];
    replyLabel.attributedText = attributedString;
    self.replyLabel = replyLabel;
    
    
    //按钮
    self.clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.clickButton.userInteractionEnabled = NO;
    self.clickButton.adjustsImageWhenHighlighted = NO;
    [self.clickButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.clickButton];
    [self.clickButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(self.contentView);
    }];
    
    //按钮添加长按
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longClickAction:)];
    longPress.minimumPressDuration = 0.5;
    [self.clickButton addGestureRecognizer:longPress];
}

//按钮响应
-(void)clickAction:(UIButton *)sender{

    if (self.delegate && [self.delegate respondsToSelector:@selector(zx_clickCommentView:withCommentListModel:)]){
        [self.delegate zx_clickCommentView:self withCommentListModel:self.commentListModel];
    }
}

//长按响应
-(void)longClickAction:(UILongPressGestureRecognizer *)sender{

    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle: UIImpactFeedbackStyleMedium];
           [generator prepare];
           [generator impactOccurred];
    
    if ([sender state] == UIGestureRecognizerStateBegan){
        if (self.delegate && [self.delegate respondsToSelector:@selector(zx_longClickCommentView:withCommentListModel:)]){
            [self.delegate zx_longClickCommentView:self withCommentListModel:self.commentListModel];
        }
    }
    
}


//数据传入
- (void)zx_setCommentListModel:(ZXHomeDetailsCommentListModel *)commentListModel{
    
    
    self.commentListModel = commentListModel;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:commentListModel.avatar] placeholderImage:IMAGENAMED(@"placeholderImage")];
    
    self.nameLabel.text = commentListModel.nickname;
    
    self.replyLabel.attributedText =  [ZX_EmojiManager zx_emojiWithServerString:commentListModel.content];
//    commentListModel.content;
    
    self.timeLabel.text = [ZXHomeTableViewCell zx_compareCurrentTime:commentListModel.sendtime] ;
    
    self.clickButton.userInteractionEnabled = YES;
}



@end

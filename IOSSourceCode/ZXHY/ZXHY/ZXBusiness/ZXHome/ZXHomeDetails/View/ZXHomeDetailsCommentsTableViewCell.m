//
//  ZXHomeDetailsCommentsTableViewCell.m
//  ZXHY
//
//  Created by Bern Lin on 2021/12/22.
//

#import "ZXHomeDetailsCommentsTableViewCell.h"
#import "ZXHomeDetailsCommentModel.h"
#import "ZXHomeTableViewCell.h"

@interface ZXHomeDetailsCommentsTableViewCell()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong)  UILabel *nameLabel;
@property (nonatomic, strong)  UILabel *replyLabel;
@property (nonatomic, strong)  UILabel *timeLabel;
@property (nonatomic, strong) ZXHomeDetailsCommentReplyListModel *replyListModel;

@end

@implementation ZXHomeDetailsCommentsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (NSString *)wg_cellIdentifier{
    return @"ZXHomeDetailsCommentsTableViewCell";
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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    //头像
    UIImageView *iconView = [UIImageView wg_imageViewWithImageNamed:@"WomanSelect"];
    [iconView wg_setLayerRoundedCornersWithRadius:16];
    [self.contentView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(12);
        make.left.mas_equalTo(self.contentView.mas_left).offset(55);
        make.width.height.offset(32);
    }];
    self.iconView = iconView;
    
    //名字
    UILabel *nameLabel = [UILabel labelWithFont:kFontSemibold(14) TextAlignment:NSTextAlignmentLeft TextColor:WGRGBAlpha(153, 153, 153, 0.8) TextStr:@"二级留言作者" NumberOfLines:1];
    [self.contentView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(iconView);
        make.left.mas_equalTo(iconView.mas_right).offset(8);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.height.offset(15);
    }];
    self.nameLabel = nameLabel;
    
    
    //时间
    UILabel *timeLabel = [UILabel labelWithFont:kFont(10) TextAlignment:NSTextAlignmentLeft TextColor:WGRGBAlpha(153, 153, 153, 0.8) TextStr:@"" NumberOfLines:1];
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
    self.replyLabel = replyLabel;
    
    //按钮添加长按
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longClickAction:)];
    longPress.minimumPressDuration = 0.5;
    [self.contentView addGestureRecognizer:longPress];
}


//长按响应
-(void)longClickAction:(UILongPressGestureRecognizer *)sender{

    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle: UIImpactFeedbackStyleMedium];
           [generator prepare];
           [generator impactOccurred];
    
    if ([sender state] == UIGestureRecognizerStateBegan){
        NSLog(@"长按响应");
        if (self.delegate && [self.delegate respondsToSelector:@selector(zx_longClickCommentCell:withCommentListModel:)]){
            [self.delegate zx_longClickCommentCell:self withCommentListModel:self.replyListModel];
        }
    }
    
}



- (void)zx_setCommentReplyListModel:(ZXHomeDetailsCommentReplyListModel *)replyListModel{
    
    self.replyListModel = replyListModel;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:replyListModel.avatar] placeholderImage:IMAGENAMED(@"placeholderImage")];
    
    self.nameLabel.text = replyListModel.nickname;
    
    
//    self.replyLabel.text = replyListModel.content;
    self.replyLabel.attributedText = [ZX_EmojiManager zx_emojiWithServerString:replyListModel.content];
    
//    self.timeLabel.text = replyListModel.sendtime;
    self.timeLabel.text = [ZXHomeTableViewCell zx_compareCurrentTime:replyListModel.sendtime] ;
}


@end

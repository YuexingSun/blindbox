//
//  ZXHomeTableViewCell.m
//  ZXHY
//
//  Created by Bern Lin on 2021/12/20.
//

#import "ZXHomeTableViewCell.h"
#import "ZXHomeImageBannerView.h"
#import "ZXHomeModel.h"
#import "ZXHomeManager.h"
#import "ZXHomeDetailsContentHeaderFooterView.h"


@interface ZXHomeTableViewCell()

@property (nonatomic, strong) UIView  *shadowView;
@property (nonatomic, strong) UIView  *bgView;
@property (nonatomic, strong) ZXHomeImageBannerView  *bannerView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong)  UILabel *nameLabel;
@property (nonatomic, strong)  UILabel *titleLabel;
@property (nonatomic, strong)  UILabel *timeLabel;
@property (nonatomic, strong)  UILabel *contentLabel;
@property (nonatomic, strong) UIButton  *likeButton;
@property (nonatomic, strong)  UILabel *likeLabel;
@property (nonatomic, strong) UIButton *commentsButton;
@property (nonatomic, strong) UILabel *commentsLabel;
@property (nonatomic, strong) ZXHomeListModel *listModel;



@end

@implementation ZXHomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (NSString *)wg_cellIdentifier{
    return @"ZXHomeTableViewCellID";
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
    
    self.shadowView.layer.cornerRadius = 8;
    self.shadowView.layer.shadowColor = WGHEXAlpha(@"000000", 0.10).CGColor;
    self.shadowView.layer.shadowOffset = CGSizeMake(0,4);
    self.shadowView.layer.shadowRadius = 3;
    self.shadowView.layer.shadowOpacity = 1;
    self.shadowView.clipsToBounds = NO;
    
    self.bgView.layer.cornerRadius = 8;
    self.bgView.layer.masksToBounds = YES;
}


- (void)initSubView{
    
    self.backgroundColor = UIColor.clearColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //投影View
    self.shadowView = [UIView new];
    self.shadowView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:self.shadowView];
    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(15);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-5);
        make.left.mas_equalTo(self.contentView).offset(12);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-12);
        
    }];
    
    //背景
    UIView *bgView = [UIView new];
    bgView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(15);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-5);
        make.left.mas_equalTo(self.contentView).offset(12);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-12);
    }];
    self.bgView = bgView;
    
    
   
    //bannerView
    CGFloat W = (WGNumScreenWidth() - 24);
    CGFloat H = (W * 265) / 350;
    self.bannerView = [[ZXHomeImageBannerView alloc] initWithFrame:CGRectMake(0, 0, W, H) withBannerType:ZXBannerType_Home];
    self.bannerView.userInteractionEnabled = NO;
    [bgView addSubview:self.bannerView];
    
    
    
    //头像
    UIImageView *iconView = [UIImageView wg_imageViewWithImageNamed:@"ManSelect"];
    [iconView wg_setLayerRoundedCornersWithRadius:24];
    [iconView wg_setBorderColor:UIColor.whiteColor borderWidth:2.0];
    [bgView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bannerView.mas_bottom).offset(-15);
        make.left.mas_equalTo(bgView.mas_left).offset(15);
        make.width.height.offset(48);
    }];
    self.iconView = iconView;
    
    
    //名字
    UILabel *nameLabel = [UILabel labelWithFont:kFontSemibold(14) TextAlignment:NSTextAlignmentLeft TextColor:WGRGBAlpha(51, 51, 51, 0.8) TextStr:@"空手劈榴莲QAQ" NumberOfLines:1];
    [bgView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(iconView.mas_bottom).offset(-4);
        make.left.mas_equalTo(iconView.mas_right).offset(8);
        make.right.mas_equalTo(bgView.mas_right).offset(-10);
    }];
    self.nameLabel = nameLabel;
    
    
    //标题
    UILabel *titleLabel = [UILabel labelWithFont:kFontSemibold(18) TextAlignment:NSTextAlignmentLeft TextColor:WGGrayColor(51) TextStr:@"" NumberOfLines:2];
    [bgView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(iconView.mas_bottom).offset(10);
        make.left.mas_equalTo(iconView);
        make.right.mas_equalTo(bgView.mas_right).offset(-15);
    }];
    NSMutableAttributedString *titleAtString = [[NSMutableAttributedString alloc] initWithString:@"佛山探店｜这大概是佛山最京都的庭院下午茶 " attributes: @{NSFontAttributeName:kFontSemibold(18),NSForegroundColorAttributeName: WGGrayColor(51)}];
    titleLabel.attributedText = titleAtString;
    self.titleLabel = titleLabel;
    
    
    //时间
    UILabel *timeLabel = [UILabel labelWithFont:kFont(12) TextAlignment:NSTextAlignmentLeft TextColor:WGRGBAlpha(153, 153, 153, 0.8) TextStr:@"昨天 17:52" NumberOfLines:1];
    [bgView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(8);
        make.left.mas_equalTo(iconView);
        make.right.mas_equalTo(bgView.mas_right).offset(-15);
    }];
    self.timeLabel = timeLabel;
    
    
    
    //点赞
    UIButton *likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    likeButton.adjustsImageWhenHighlighted = NO;
    [likeButton setImage:IMAGENAMED(@"homeLike") forState:UIControlStateNormal];
    [likeButton setImage:IMAGENAMED(@"homeLikeSelect") forState:UIControlStateSelected];
    [likeButton addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:likeButton];
    [likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iconView);
        make.bottom.mas_equalTo(bgView.mas_bottom).offset(-20);
        make.width.height.offset(36);
    }];
    self.likeButton = likeButton;
    
    
    //点赞文本
    UILabel *likeLabel = [UILabel labelWithFont:kFontSemibold(14) TextAlignment:NSTextAlignmentLeft TextColor:WGGrayColor(153) TextStr:@"192" NumberOfLines:1];
    [bgView addSubview:likeLabel];
    [likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(likeButton);
        make.left.mas_equalTo(likeButton.mas_right).offset(8);
    }];
    self.likeLabel = likeLabel;
    
    //评论
    UIButton *commentsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commentsButton.adjustsImageWhenHighlighted = NO;
    [commentsButton setImage:IMAGENAMED(@"comments") forState:UIControlStateNormal];
    [commentsButton addTarget:self action:@selector(commentsAction:) forControlEvents:UIControlEventTouchUpInside];
    commentsButton.userInteractionEnabled = NO;
    [bgView addSubview:commentsButton];
    [commentsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(likeLabel.mas_right).offset(15);
        make.centerY.mas_equalTo(likeButton);
        make.width.height.offset(36);
    }];
    self.commentsButton = commentsButton;
    
    //评论文本
    UILabel *commentsLabel = [UILabel labelWithFont:kFontSemibold(14) TextAlignment:NSTextAlignmentLeft TextColor:WGGrayColor(153) TextStr:@"92" NumberOfLines:1];
    [bgView addSubview:commentsLabel];
    [commentsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(commentsButton);
        make.left.mas_equalTo(commentsButton.mas_right).offset(8);
    }];
    self.commentsLabel = commentsLabel;
    
    //介绍
    UILabel *contentLabel = [UILabel labelWithFont:kFont(16) TextAlignment:NSTextAlignmentLeft TextColor:WGGrayColor(51) TextStr:@"" NumberOfLines:0];
    [bgView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(timeLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(iconView);
        make.right.mas_equalTo(bgView.mas_right).offset(-15);
        make.bottom.mas_equalTo(likeButton.mas_top).offset(-20);
    }];
    self.contentLabel = contentLabel;
    
   
}


#pragma mark - Private Method
//点赞响应
- (void)likeAction:(UIButton *)sender{
    
    WEAKSELF;
    [ZXHomeManager zx_reqApiInfomationLikeArticleWithNoteId:self.listModel.typeId SuccessBlock:^(NSDictionary * _Nonnull dic) {
        STRONGSELF;
        
        self.listModel.isliked = !self.listModel.isliked;
        if (self.listModel.isliked){
            self.listModel.likenumber = [NSString stringWithFormat:@"%d",[self.listModel.likenumber intValue] + 1];
        }else{
            self.listModel.likenumber = [NSString stringWithFormat:@"%d",[self.listModel.likenumber intValue] - 1];
        }
        
        [self zx_setListModel:self.listModel];
        
    } ErrorBlock:^(NSError * _Nonnull error) {
        
    }];
}

//评论响应
- (void)commentsAction:(UIButton *)sender{
    
}

//计算高度
+ (CGFloat)zx_heightWithListModel:(ZXHomeListModel *)listModel{
    
    
    //计算Html
    NSString *str2 = listModel.title;
    CGFloat titleLabelH = [str2 heightOfStringFont:kFont(16) width:WGNumScreenWidth() - 60];
    
    
    //计算文本
    NSString *str = [listModel.content stringByReplacingOccurrencesOfString:@"\n"withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\r"withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\t"withString:@""];
    

    UILabel *tempLabel = [UILabel labelWithFont:kFont(16) TextAlignment:NSTextAlignmentLeft TextColor:WGGrayColor(51) TextStr:@"" NumberOfLines:0];
    tempLabel.attributedText = [ZXHomeDetailsContentHeaderFooterView attributedStringWithHTMLString:listModel.content];
    
    CGFloat tempLabelHeight = [tempLabel.attributedText boundingRectWithSize:CGSizeMake(WGNumScreenWidth() - 60, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
    
    CGFloat contentLabelH = tempLabelHeight;
    


    
    
    CGFloat W = (WGNumScreenWidth() - 24);
    CGFloat bannerViewH = (W * 265) / 350;
    
    CGFloat H = titleLabelH + contentLabelH + bannerViewH + 195;
    
    //屏幕最大可显示高度
    CGFloat displayH = WGNumScreenHeight() - 52  - [[AppDelegate wg_sharedDelegate].tabBarController zx_tabBarHeight];
    
    if (H > displayH){
        return displayH - ((IS_IPHONE_X_SER) ? 33 : 28);
    }
    
   
    
    return  H;
}

+ (NSString *)removeTheHtmlFromString:(NSString *)htmlString {
      NSScanner * scanner = [NSScanner scannerWithString:htmlString];
      NSString * text = nil;
      while([scanner isAtEnd]==NO) {
          //找到标签的起始位置
         [scanner scanUpToString:@"<" intoString:nil];
          //找到标签的结束位置
          [scanner scanUpToString:@">" intoString:&text];
          //替换字符
         htmlString = [htmlString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
     }
     return htmlString;
 }



- (void)zx_setListModel:(ZXHomeListModel *)listModel{
    
    if (kObjectIsEmpty(listModel)) return;;
    
    self.listModel = listModel;
    
    [self.bannerView zx_setListModel:listModel]; 
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:listModel.avatar] placeholderImage:IMAGENAMED(@"placeholderImage")];
    
    self.nameLabel.text = listModel.nickname;
    
    self.titleLabel.text = listModel.title;
    
    self.timeLabel.text = [ZXHomeTableViewCell zx_compareCurrentTime:listModel.sendtime] ;
    

    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8.0; // 设置行间距
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithData:[listModel.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedStr.length)];
    
    self.contentLabel.attributedText = attributedStr;
    self.contentLabel.font = kFont(16);
    
    
    
    self.likeButton.selected = listModel.isliked;
    
    self.likeLabel.text =  [self zx_unifiedDataForma:listModel.likenumber];
    self.commentsLabel.text = [self zx_unifiedDataForma:listModel.commentnumber];
}


#pragma mark - 点赞数、评论数 格式统一
- (NSString *)zx_unifiedDataForma:(NSString *)str{
    
    NSInteger remainData = [str integerValue];
    if (remainData >= 1000) {
        CGFloat count = floorf(remainData / 1000.0);
        return [NSString stringWithFormat:@"%.1fk", count];
    }else{
        return [NSString stringWithFormat:@"%ld", (long)remainData];
    }
}


#pragma mark - 时间 格式统一

/*
 * 需要传入的时间格式 2017-06-14 14:18:54
 */

// 和当前时间进行比较  输出字符串为（刚刚几个小时前 几天前 ）



+ (NSString *)zx_compareCurrentTime:(NSString *)str
{

    if (str.length == 0){
        return @"";
    }
    
    //把字符串转为NSdate

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *timeDate = [dateFormatter dateFromString:str];
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:timeDate];

    long temp = 0;

    NSString *result;

    if (timeInterval/60 < 1) {
        result = [NSString stringWithFormat:@"刚刚"];
    }

    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }

    else if((temp = temp/60) < 24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }

    else if((temp = temp/24) < 2){
        
        NSString *timeStr=[dateFormatter stringFromDate:timeDate];
        timeStr = [timeStr substringFromIndex:11];
        timeStr = [timeStr substringToIndex:timeStr.length - 3];
        result = [NSString stringWithFormat:@"昨天 %@",timeStr];
    }


    else{
        NSString *timeStr=[dateFormatter stringFromDate:timeDate];
        timeStr = [timeStr substringToIndex:timeStr.length - 3];
        result = [NSString stringWithFormat:@"%@",timeStr];

    }

    return  result;

}

@end

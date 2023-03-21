//
//  ZXHomeDetailsContentHeaderFooterView.m
//  ZXHY
//
//  Created by Bern Lin on 2021/12/22.
//

#import "ZXHomeDetailsContentHeaderFooterView.h"
#import "ZXHomeImageBannerView.h"
#import "ZXReachedNumView.h"
#import "ZXHomeModel.h"

#define BannerViewWidth WGNumScreenWidth()
#define BannerViewHight ((BannerViewWidth * 500) / 375) + 40
#define LocationViewHight 72
#define IconViewHight 32
#define TimeLabelHight 15

@interface ZXHomeDetailsContentHeaderFooterView()

@property (nonatomic, strong) ZXHomeListModel  *listModel;

@property (nonatomic, strong) UIView  *shadowView;
@property (nonatomic, strong) UIView  *bgView;
@property (nonatomic, strong) ZXHomeImageBannerView  *bannerView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong)  UILabel *nameLabel;
@property (nonatomic, strong)  UILabel *titleLabel;
@property (nonatomic, strong)  UILabel *timeLabel;
@property (nonatomic, strong)  UILabel *contentLabel;

//位置坐标View
@property (nonatomic, strong) UIView  *locationView;
@property (nonatomic, strong) UIImageView *locationLogoView;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) ZXReachedNumView *reachedView;//来过人数View


@end

@implementation ZXHomeDetailsContentHeaderFooterView

+ (NSString *)wg_cellIdentifier{
    return @"ZXHomeDetailsContentHeaderFooterView";
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
    
    self.locationView.layer.cornerRadius = 8;
    self.locationView.clipsToBounds = YES;
}


- (void)initSubView{
    
    self.backgroundColor = UIColor.clearColor;
    
    
    //背景
    UIView *bgView = [UIView new];
    bgView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(self.contentView);
    }];
    self.bgView = bgView;
    
    
    //bannerView
    self.bannerView = [[ZXHomeImageBannerView alloc] initWithFrame:CGRectMake(0, 0, BannerViewWidth, BannerViewHight) withBannerType:ZXBannerType_Details];
    [bgView addSubview:self.bannerView];
    
    
    
    //标题
    UILabel *titleLabel = [UILabel labelWithFont:kFontSemibold(18) TextAlignment:NSTextAlignmentLeft TextColor:WGGrayColor(51) TextStr:@"" NumberOfLines:2];
    [bgView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bannerView.mas_bottom).offset(5);
        make.left.mas_equalTo(bgView.mas_left).offset(15);
        make.right.mas_equalTo(bgView.mas_right).offset(-15);
    }];
    NSMutableAttributedString *titleAtString = [[NSMutableAttributedString alloc] initWithString:@"佛山探店｜这大概是佛山最京都的庭院下午茶 " attributes: @{NSFontAttributeName:kFontSemibold(18),NSForegroundColorAttributeName: WGGrayColor(51)}];
    titleLabel.attributedText = titleAtString;
    self.titleLabel = titleLabel;
    
    
    //头像
    UIImageView *iconView = [UIImageView wg_imageViewWithImageNamed:@"ManSelect"];
    [iconView wg_setLayerRoundedCornersWithRadius:16];
    [bgView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(12);
        make.left.mas_equalTo(titleLabel);
        make.width.height.offset(IconViewHight);
    }];
    self.iconView = iconView;
    
    
    //名字
    UILabel *nameLabel = [UILabel labelWithFont:kFontSemibold(14) TextAlignment:NSTextAlignmentLeft TextColor:WGRGBAlpha(51, 51, 51, 0.8) TextStr:@"空手劈榴莲QAQ" NumberOfLines:1];
    [bgView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(iconView);
        make.left.mas_equalTo(iconView.mas_right).offset(8);
        make.right.mas_equalTo(bgView.mas_right).offset(-10);
    }];
    self.nameLabel = nameLabel;
    
    
   
    //时间
    UILabel *timeLabel = [UILabel labelWithFont:kFont(12) TextAlignment:NSTextAlignmentLeft TextColor:WGRGBAlpha(153, 153, 153, 0.8) TextStr:@"昨天 17:52" NumberOfLines:1];
    [bgView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(iconView.mas_bottom).offset(8);
        make.left.mas_equalTo(iconView);
        make.right.mas_equalTo(bgView.mas_right).offset(-15);
        make.height.offset(TimeLabelHight);
    }];
    self.timeLabel = timeLabel;
    

    

    //位置信息
    self.locationView = [UIView new];
    self.locationView.backgroundColor = WGGrayColor(238);
    [bgView addSubview:self.locationView];
    [self.locationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bgView.mas_left).offset(15);
        make.right.mas_equalTo(bgView.mas_right).offset(-15);
        make.bottom.mas_equalTo(bgView.mas_bottom).offset(-30);
        make.height.offset(LocationViewHight);
    }];
    
    self.locationLogoView = [UIImageView wg_imageViewWithImageNamed:@"homeLocation"];
    [self.locationView addSubview:self.locationLogoView];
    [self.locationLogoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.locationView.mas_left).offset(8);
        make.centerY.mas_equalTo(self.locationView);
        make.height.width.offset(32);
    }];
    
    //来过人数View
    self.reachedView  = [ZXReachedNumView new];
    [self.locationView addSubview:self.reachedView];
    [self.reachedView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.locationView.mas_bottom).offset(-15);
        make.right.mas_equalTo(self.locationView.mas_right).offset(-12);
        make.width.mas_equalTo(110);
        make.height.offset(25);
    }];
    
    
    UILabel *comesLabel = [UILabel labelWithFont:kFontSemibold(12) TextAlignment:NSTextAlignmentRight TextColor:WGGrayColor(153) TextStr:@"TA们最近去过" NumberOfLines:1];
    [self.locationView addSubview:comesLabel];
    [comesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.reachedView.mas_top);
        make.right.left.mas_equalTo(self.reachedView);
        make.height.offset(15);
    }];
    
    //地点
    self.locationLabel = [UILabel labelWithFont:kFontSemibold(14) TextAlignment:NSTextAlignmentLeft TextColor:WGRGBColor(248, 110, 151) TextStr:@"" NumberOfLines:0];
    [self.locationView addSubview:self.locationLabel];
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.locationView);
        make.left.mas_equalTo(self.locationLogoView.mas_right).offset(0);
        make.right.mas_equalTo(self.reachedView.mas_left).offset(-10);
    }];
    
    //位置信息按钮
    UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    locationBtn.adjustsImageWhenHighlighted = NO;
    [locationBtn addTarget:self action:@selector(locationClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.locationView addSubview:locationBtn];
    [locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(self.locationView);
    }];
    
    
    
    //介绍
    UILabel *contentLabel = [UILabel labelWithFont:kFont(16) TextAlignment:NSTextAlignmentLeft TextColor:WGGrayColor(51) TextStr:@"" NumberOfLines:0];
    [bgView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(timeLabel.mas_bottom).offset(12);
        make.left.mas_equalTo(iconView);
        make.right.mas_equalTo(bgView.mas_right).offset(-15);
//        make.bottom.mas_equalTo(self.locationView.mas_top).offset(-45);
    }];
    self.contentLabel = contentLabel;
}

#pragma mark - Private Method

//模型赋值
- (void)zx_setListModel:(ZXHomeListModel *)listModel{
    
    if (kObjectIsEmpty(listModel)) return;;
    
    self.listModel = listModel;
    
    [self.bannerView zx_setListModel:listModel];
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:listModel.avatar] placeholderImage:IMAGENAMED(@"placeholderImage")];
    
    self.nameLabel.text = listModel.nickname;
    
    self.titleLabel.text = listModel.title;
    
    self.timeLabel.text = listModel.sendtime;
    


    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8.0; // 设置行间距
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithData:[listModel.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedStr.length)];
    
    self.contentLabel.attributedText = attributedStr;
    self.contentLabel.font = kFont(16);
    
    
    self.locationLabel.text = listModel.location.address;
    NSMutableArray *arr = [NSMutableArray arrayWithArray:listModel.gotavatarlist];
    [self.reachedView zx_homeDetailsViewWithImageUrlList:arr];
    
    if ((kIsEmptyString(listModel.location.address))){
        self.locationView.hidden = YES;
    }
    
}

//计算高度
+ (CGFloat)zx_heightWithListModel:(ZXHomeListModel *)listModel{
    
    BannerViewHight;
    LocationViewHight;
    IconViewHight ;
    TimeLabelHight;
    
    //计算标题
    CGFloat titleLabelH = [listModel.title heightOfStringFont:kFontSemibold(18) width:WGNumScreenWidth() - 30] + 15;
    
   
    //计算文本
    NSString *str = [listModel.content stringByReplacingOccurrencesOfString:@"\n"withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\r"withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\t"withString:@""];
    
    UILabel *tempLabel = [UILabel labelWithFont:kFont(16) TextAlignment:NSTextAlignmentLeft TextColor:WGGrayColor(51) TextStr:@"" NumberOfLines:0];
    tempLabel.attributedText = [ZXHomeDetailsContentHeaderFooterView attributedStringWithHTMLString:listModel.content];

    CGFloat tempLabelHeight = [tempLabel.attributedText boundingRectWithSize:CGSizeMake(WGNumScreenWidth() - 30, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;

    
    CGFloat contentLabelH = tempLabelHeight;

    
    if ((kIsEmptyString(listModel.location.address))){
        return BannerViewHight + titleLabelH + IconViewHight + TimeLabelHight + contentLabelH  + 105 ;
    }

    return BannerViewHight + titleLabelH + IconViewHight + TimeLabelHight + contentLabelH +  LocationViewHight + 105;
}

//富文本转换
+ (NSMutableAttributedString *)attributedStringWithHTMLString:(NSString *)htmlString{

    NSDictionary *options = @{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,

    NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding) };

    NSData *data = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableAttributedString * mutableAttributedStr =  [[NSMutableAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 8.0;
    
    
    [mutableAttributedStr addAttribute:NSFontAttributeName value:kFont(16) range:NSMakeRange(0, mutableAttributedStr.length)];
    [mutableAttributedStr addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, mutableAttributedStr.length)];
   
    return mutableAttributedStr;

}


//位置信息按钮点击
- (void)locationClick:(UIButton *)sender{
   
    //地理位置点击
    if (self.delegate && [self.delegate respondsToSelector:@selector(zx_didLoactionDetailsContentView:withListModel:)]){
        [self.delegate zx_didLoactionDetailsContentView:self withListModel:self.listModel];
    }
}

@end

//
//  ZXTerminalAnnotationView.m
//  ZXHY
//
//  Created by Bern Lin on 2021/12/3.
//

#import "ZXTerminalAnnotationView.h"
#import "ZXOpenResultsModel.h"


#define kCalloutWidth       80.0
#define kCalloutHeight      95.0

#define kArrorHeight        10

#define kPortraitMargin     5
#define kPortraitWidth      70
#define kPortraitHeight     50

#define kTitleWidth         120
#define kTitleHeight        20


@interface ZXTerminalAnnotationView ()

@property (nonatomic, strong) ZXOpenResultsModel *openResultsModel;

@property (nonatomic, strong) UIImageView *unionImageView;
@property (nonatomic, strong) UIImageView *portraitView;
@property (nonatomic, strong) UIImageView *typeLogoImageView;
@property (nonatomic, strong) UILabel   *infoLabel;

@end


@implementation ZXTerminalAnnotationView


- (id)initWithAnnotation:(id <MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self){
        [self zx_initializationUI];
    }
    return self;
}


#pragma mark - Initialization UI
- (void)zx_initializationUI{
    
    self.backgroundColor = UIColor.clearColor;
    
    
    UIImageView *unionImageView = [UIImageView wg_imageViewWithImageNamed:@"Union"];
//    [[ alloc] initWithFrame:CGRectZero];
//    unionImageView.image = IMAGENAMED(@"Union");
    [self addSubview:unionImageView];
    [unionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.mas_top);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(160);
        
    }];
    self.unionImageView = unionImageView;
    
    UIImageView*typeLogo = [[UIImageView alloc] initWithFrame:CGRectZero];
    typeLogo.image = IMAGENAMED(@"driveLogo");
    [self.unionImageView addSubview:typeLogo];
    [typeLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.unionImageView).offset(10);
        make.left.mas_equalTo(self.unionImageView).offset(15);
        make.height.width.mas_equalTo(25);
    }];
    self.typeLogoImageView = typeLogo;
    
    
    UILabel *infoLabel = [UILabel labelWithFont:kFontSemibold(16) TextAlignment:NSTextAlignmentLeft TextColor:UIColor.whiteColor TextStr:@"10 分钟" NumberOfLines:1];
    [unionImageView addSubview:infoLabel];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(typeLogo);
        make.left.mas_equalTo(typeLogo.mas_right).offset(7);
        make.right.mas_equalTo(unionImageView.mas_right).offset(-3);
    }];
    self.infoLabel = infoLabel;
    
    
    //背景图
    UIImageView *bgImageView = [UIImageView wg_imageViewWithImageNamed:@"recommendBg"];
    [self addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(unionImageView.mas_bottom).offset(10);
        make.height.mas_equalTo(kCalloutHeight);
        make.width.mas_equalTo(kCalloutWidth);
    }];
    
    //商户图
    self.portraitView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 67, 67)];
    self.portraitView.backgroundColor = UIColor.grayColor;
    self.portraitView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f , CGRectGetWidth(self.bounds) / 2.f);
    self.portraitView.layer.cornerRadius = 34;
    self.portraitView.layer.masksToBounds = YES;
    [self addSubview:self.portraitView];
    
    [self.portraitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgImageView);
        make.top.mas_equalTo(bgImageView).offset(6);
        make.width.height.mas_equalTo(68);
    }];
    

}


#pragma mark - Private Method
//获取数据信息
- (void)zx_openResultsModel:(ZXOpenResultsModel *)openResultsModel{
    
    self.openResultsModel = openResultsModel;
    
    [self.portraitView sd_setImageWithURL:[NSURL URLWithString:openResultsModel.pic] placeholderImage:nil];
    
    NSString *imageStr = (self.openResultsModel.currentNavType == ZXCurrentNavType_Walk) ? @"walkLogo" :  @"driveLogo";
    self.typeLogoImageView.image = IMAGENAMED(imageStr);
    
    
    
}

//道路信息
- (void)zx_updateNaviInfo:(AMapNaviInfo *)naviInfo{
    
    NSString *typeStr = (self.openResultsModel.currentNavType == ZXCurrentNavType_Walk) ? @"步行" : @"驾车";
    
    self.infoLabel.text = [NSString stringWithFormat:@"%@ %@",typeStr ,[self normalizedRemainTime:naviInfo.routeRemainTime]];
}


//时间转换
- (NSString *)normalizedRemainTime:(NSInteger)remainTime {
    if (remainTime < 0) {
        return nil;
    }
    
    if (remainTime < 60) {
        return [NSString stringWithFormat:@"< 1分钟"];
    } else if (remainTime >= 60 && remainTime < 60*60) {
        return [NSString stringWithFormat:@"%ld分钟", (long)remainTime/60];
    } else {
        NSInteger hours = remainTime / 60 / 60;
        NSInteger minute = remainTime / 60 % 60;
        if (minute == 0) {
            return [NSString stringWithFormat:@"%ld小时", (long)hours];
        } else {
            return [NSString stringWithFormat:@"%ld小时%ld分钟", (long)hours, (long)minute];
        }
    }
}


@end

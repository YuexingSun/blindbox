//
//  ZXMapMeAnnotationView.m
//  ZXHY
//
//  Created by Bern Lin on 2021/12/8.
//

#import "ZXMapMeAnnotationView.h"
#import "ZXBlindBoxViewModel.h"


#define kWidth       65.0
#define kHeight      65.0

@interface ZXMapMeAnnotationView ()

@property (nonatomic, strong) UIImageView *headingImageView;
@property (nonatomic, strong) UIImageView *emoImageView;


@end

@implementation ZXMapMeAnnotationView


- (id)initWithAnnotation:(id <MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self){
        
        [self zx_initializationUI];
        
        self.alpha = 0;
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 1;
            
        }];
        
    }
    return self;
}


#pragma mark - Initialization UI
- (void)zx_initializationUI{
    
    self.bounds = CGRectMake(0.f, 0.f, kWidth, kHeight);
    self.backgroundColor = UIColor.clearColor;
    
    
    //Heading图
    self.headingImageView = [UIImageView wg_imageViewWithImageNamed:@"NavHeading"];
    [self addSubview:self.headingImageView];
    [self.headingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.mas_top);
        make.height.mas_equalTo(kHeight);
        make.width.mas_equalTo(kWidth);
    }];
    
    //EMoj 图
    self.emoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.emoImageView.image = IMAGENAMED(@"NavMode");
    self.emoImageView.backgroundColor = UIColor.clearColor;
    self.emoImageView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f , CGRectGetWidth(self.bounds) / 2.f);
    [self addSubview:self.emoImageView];
    [self.emoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.headingImageView);
        make.centerY.mas_equalTo(self.headingImageView);
        make.width.height.mas_equalTo(30);
    }];
}

//方向数据
- (void)setHeading:(CLHeading *)heading{
    
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(heading.trueHeading * (M_PI / 180.0f));
    self.headingImageView.transform = endAngle;
}

//数据传入
- (void)zx_blindBoxViewModel:(ZXBlindBoxViewModel *)blindBoxViewModel{
    [self.emoImageView sd_setImageWithURL:[NSURL URLWithString:blindBoxViewModel.heartimg] placeholderImage:IMAGENAMED(@"NavHeading")];
}

@end

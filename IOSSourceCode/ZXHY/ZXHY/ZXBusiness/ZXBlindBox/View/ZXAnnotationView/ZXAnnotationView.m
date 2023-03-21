//
//  ZXAnnotationView.m
//  ZXHY
//
//  Created by Bern Lin on 2021/11/26.
//

#import "ZXAnnotationView.h"

#define kCalloutWidth       80.0
#define kCalloutHeight      95.0


@interface ZXAnnotationView ()

@property (nonatomic, strong) UIImageView *unionImageView;
@property (nonatomic, strong) UIImageView *portraitView;
@property (nonatomic, strong) UIImageView *typeLogoImageView;
@property (nonatomic, strong) UILabel   *infoLabel;
@property (nonatomic, strong) UIImageView *bgImageView;


@end

@implementation ZXAnnotationView





- (id)initWithAnnotation:(id <MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self){
        [self zx_initializationUI];
    }
    return self;
}

#pragma mark - Initialization UI
- (void)zx_initializationUI{
    
    self.bounds = CGRectMake(0.f, 0.f, kCalloutWidth, kCalloutHeight);
    self.backgroundColor = UIColor.clearColor;
    
    
    //背景图
    UIImageView *bgImageView = [UIImageView wg_imageViewWithImageNamed:@"recommendBg"];
    [self addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.mas_top);
        make.height.mas_equalTo(kCalloutHeight);
        make.width.mas_equalTo(kCalloutWidth);
    }];
    self.bgImageView = bgImageView;
    
    //商户图
    self.portraitView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 67, 67)];
    self.portraitView.backgroundColor = UIColor.clearColor;
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


- (void)zx_openResultsModel:(ZXOpenResultsModel *)openResultsModel{
    if (kObjectIsEmpty(openResultsModel)) return;

//    [self.portraitView sd_setImageWithURL:[NSURL URLWithString:openResultsModel.pic] placeholderImage:nil];
    
    
    [self.portraitView wg_setImageWithURL:[NSURL URLWithString:openResultsModel.pic] placeholderImage:nil completed:^(UIImage *image, NSError *error, WGImageCacheType cacheType, NSURL *imageURL) {

//        NSData *imgData = [[ZXNetworkManager shareNetworkManager] dataCompressedImageToLimitSizeOfKB:100 image:image];
//        UIImage *img = [UIImage imageWithData:imgData];
        
        
        NSData *imgData = UIImageJPEGRepresentation(image,1);
        UIImage *img = [UIImage imageWithData:imgData];
        
        NSUInteger lengthAfter = [imgData length] /1024;
        NSLog(@"压缩前大小imageData = %zdK，size %@",lengthAfter, NSStringFromCGSize(img.size));
        
        imgData = [[ZXNetworkManager shareNetworkManager]  compressBySizeWithMaxLength:100 * 1024 withImageData:imgData img:img];
        img = [UIImage imageWithData:imgData];
        
        NSUInteger length = [imgData length] /1024;
        NSLog(@"压缩后大小imageData = %zdK，size %@",length, NSStringFromCGSize(img.size));
        self.portraitView.image = img;
    }];
    
    
    self.bgImageView.alpha = 0;
    self.bgImageView.mj_y = kCalloutHeight / 2;
    
    self.portraitView.alpha = 0;
    self.portraitView.mj_y = kCalloutHeight / 2 + 6;
    
    [UIView animateWithDuration:0.6 animations:^{
        
        self.bgImageView.alpha = 1;
        self.bgImageView.mj_y = 0;
        
        self.portraitView.alpha = 1;
        self.portraitView.mj_y = 6;
    }];

}

@end

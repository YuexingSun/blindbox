//
//  ZXHomdAdView.m
//  ZXHY
//
//  Created by Bern Lin on 2022/3/2.
//

#import "ZXHomdAdView.h"
#import "ZXHomeAdModel.h"
#import "ZXHomeDetailsViewController.h"
#import "ZXWebViewViewController.h"

@interface ZXHomdAdView ()

@property (nonatomic, strong) UIImageView  *imageView;
@property (nonatomic, strong) UIButton  *cancelButton;
@property (nonatomic, strong) ZXHomeAdModel  *adModel;

@end

@implementation ZXHomdAdView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        
        [self setupUI];
       
    }
    
    return self;
}

#pragma mark - Initialization UI

- (void)setupUI{
    
    self.backgroundColor = UIColor.clearColor;
    
    //    UIViewContentModeScaleAspectFill
    self.imageView =  [[UIImageView alloc] initWithFrame:CGRectZero];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
        make.width.height.offset(WGNumScreenWidth() - 30);
    }];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    self.cancelButton.adjustsImageWhenHighlighted = NO;
    [self.cancelButton setImage:IMAGENAMED(@"AdCancel") forState:UIControlStateNormal];
    [self addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imageView);
        make.top.equalTo(self.imageView.mas_bottom).offset(40);
        make.width.height.offset(48);
    }];
}




//按钮响应
- (void)cancelAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(closeHomdAdView:)]){
        [self.delegate closeHomdAdView:self];
    }
    
    if (self.closeAdViewBlock){
        self.closeAdViewBlock();
    }
}


- (void)zx_homeAdModel:(ZXHomeAdModel *)adModel{
    self.adModel = adModel;
    
    if (!adModel) return;
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:adModel.pic]];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
   
    WEAKSELF;
    [self.imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        
        STRONGSELF;
        
        CGFloat width = WGNumScreenWidth() - 50;
        CGFloat height = (width * image.size.height) / image.size.width;
        
        if (height + 120 > WGNumScreenHeight()){
            height =  WGNumScreenHeight() - 250;
            width = (image.size.width * height) /image.size.height;
        }
        
 
        self.imageView.image = image;
       
        [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(width);
            make.height.offset(height);
        }];
        
        
        
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        STRONGSELF;
        self.imageView.image = nil;
        
    }];
    
    
    //添加打印事件
    [self.imageView addTouchGusture:^(UITapGestureRecognizer *tap) {
        STRONGSELF;
        
        [self cancelAction];
        
        NSLog(@"\n 当前type -- %@ param -- %@",adModel.targettype,adModel.param);
        
        if ([adModel.targettype isEqualToString:@"box"]){
            
            [[AppDelegate wg_sharedDelegate].tabBarController changeToSelectedIndex:WGTabBarType_Box];
        }
        else if ([adModel.targettype isEqualToString:@"detail"]){
            
            if (!adModel.param.length) return;;
            
            ZXHomeDetailsViewController *vc = [ZXHomeDetailsViewController new];
            [vc zx_setTypeIdToRequest:adModel.param];
            [[WGUIManager wg_currentIndexNavTopController].navigationController pushViewController:vc animated:YES];
            
        }
        else if ([adModel.targettype isEqualToString:@"h5"]){
            
            if (!adModel.param.length) return;;
            
            ZXWebViewViewController *vc = [ZXWebViewViewController new];
            vc.webViewURL = adModel.param;
            vc.webViewTitle = @"";
            [[WGUIManager wg_currentIndexNavTopController].navigationController pushViewController: vc animated:YES];
        }
        else if ([adModel.targettype isEqualToString:@"none"]){
            
        }
        
    }];
}
@end

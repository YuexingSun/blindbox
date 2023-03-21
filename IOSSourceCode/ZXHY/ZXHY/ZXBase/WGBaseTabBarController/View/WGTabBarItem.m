//
//  WGTabBarItem.m
//  Yunhuoyouxuan
//
//  Created by Bern on 2021/4/28.
//  Copyright © 2021 apple. All rights reserved.
//

#import "WGTabBarItem.h"
#import "WGTabBarModel.h"
#import <Lottie/Lottie.h>

@interface WGTabBarItem ()

@property(nonatomic, strong) NSString *selectImage;
@property(nonatomic, strong) NSString *normalImage;
@property(nonatomic, strong) NSString *title;

@property(nonatomic, assign) BOOL isSelected;
@property(nonatomic, assign) BOOL showBigImage;
@property (nonatomic, strong) UIImageView *bigImageView;
@property (nonatomic, strong) UIImageView *normalImageView;
@property (nonatomic, strong) UILabel     *titleLabel;

//点击动画
@property(nonatomic, strong) LOTAnimationView *animationView;



@end

@implementation WGTabBarItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    self.normalImageView = [[UIImageView alloc] init];
    [self addSubview:self.normalImageView];
    
    self.bigImageView = [[UIImageView alloc] init];
    [self addSubview:self.bigImageView];
    
    self.titleLabel = [UILabel labelWithFont:kFontMedium(10)
                               TextAlignment:NSTextAlignmentCenter
                                   TextColor:WGGrayColor(60)
                                     TextStr:@""
                               NumberOfLines:1];
    [self addSubview:self.titleLabel];

    
    self.animationView = [LOTAnimationView animationNamed:@""];
    self.animationView.animationSpeed = 1.7f;
    self.animationView.hidden = YES;
    [self addSubview:self.animationView];
    
  
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).mas_offset(35.0);
        make.height.mas_equalTo(11.0);
        make.left.equalTo(self).mas_offset(5.0);
        make.right.equalTo(self).mas_offset(-5.0);
    }];

    [self.normalImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.titleLabel.mas_top).mas_offset(-2.0);
        make.width.height.mas_equalTo(26.0);
        make.centerX.equalTo(self);
    }];

    [self.bigImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.normalImageView);
        make.width.height.mas_equalTo(50.0);
        make.centerX.equalTo(self);
    }];


    [self.animationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.left.right.equalTo(self.normalImageView);
    }];

}

- (void)wg_setIsSelected:(BOOL)isSelected{
    
    if (isSelected) {
        if (self.showBigImage) {
            self.bigImageView.hidden = NO;
            self.normalImageView.hidden = YES;
            self.bigImageView.image = [UIImage imageNamed:self.selectImage];
        } else {
            self.bigImageView.hidden = YES;
            self.normalImageView.hidden = NO;
            self.normalImageView.image = [UIImage imageNamed:self.selectImage];
        }
        
        self.titleLabel.textColor = kMainTitleColor;
        
        
    } else {
        self.bigImageView.hidden = YES;
        self.normalImageView.hidden = NO;
        self.normalImageView.image = [UIImage imageNamed:self.normalImage];
        
        self.titleLabel.textColor = kMainTitleAlphaColor;
    }
}


- (void)setTabBarModel:(WGTabBarModel *)tabBarModel{
    if (kObjectIsEmpty(tabBarModel)) return;
    
    _tabBarModel = tabBarModel;
    
    self.titleLabel.text = tabBarModel.tabName;
    self.normalImage     = tabBarModel.tabImgNormal;
    self.selectImage     = tabBarModel.tabImgSelected;
    self.showBigImage    = tabBarModel.showBigImage;
    [self wg_setIsSelected:tabBarModel.isSelected];
    

    //点击动画效果
    if (tabBarModel.isSelected && !kIsEmptyString(tabBarModel.animationStr)){
        self.normalImageView.hidden = YES;
        self.animationView.hidden = NO;
        
        [self.animationView setAnimationNamed:tabBarModel.animationStr];
        [self.animationView playFromProgress:0 toProgress:0.3 withCompletion:^(BOOL animationFinished) {
            
        }];
        
    }
    
}


@end

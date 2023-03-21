//
//  ZXMapNavResultsAnimationView.m
//  ZXHY
//
//  Created by Bern Mac on 9/14/21.
//

#import "ZXMapNavResultsAnimationView.h"
#import <Lottie/Lottie.h>



@interface ZXMapNavResultsAnimationView()

//动画
@property(nonatomic, strong) LOTAnimationView *animationView;

@end

@implementation ZXMapNavResultsAnimationView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}


- (void)setupUI{
    
    self.animationView = [LOTAnimationView animationNamed:@"data"];
    self.animationView.animationSpeed = 1.2f;
    [self addSubview:self.animationView];
    
    [self.animationView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.top.left.right.equalTo(self);
        make.centerX.centerY.equalTo(self);
        make.width.height.mas_equalTo(350.0);
    }];
    
    [self.animationView playFromProgress:0 toProgress:0.7 withCompletion:^(BOOL animationFinished) {

        
    }];
}

@end

//
//  ZXHitTestView.m
//  ZXHY
//
//  Created by Bern Lin on 2022/4/6.
//

#import "ZXHitTestView.h"

@interface ZXHitTestView ()

@property (nonatomic, strong) UIButton   *blueButton;
@property (nonatomic, strong) UIView *greenView;

@end

@implementation ZXHitTestView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        
        [self initWithUI];
    }
    return  self;
}

#pragma mark - InitWithUI

- (void)initWithUI{
    
    self.blueButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 400, WGNumScreenWidth(), 80)];
    self.blueButton.backgroundColor = UIColor.blueColor;
    [self.blueButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.blueButton];
    
    
    UIView *greenView = [[UIView alloc] initWithFrame:CGRectMake(30, 200, WGNumScreenWidth() - 60, 400)];
    greenView.backgroundColor = UIColor.greenColor;
    greenView.alpha = 0.8;
    [greenView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(greenViewTap:)]];
    [self addSubview:greenView];
    self.greenView = greenView;
    
    
}

#pragma mark - Private Method
//buttonAction
- (void)buttonAction{
    NSLog(@"\n\n------%s\n\n",__func__);
    
    NSLog(@"\n\n====按钮响应了====\n\n");
}

//GreenView
- (void)greenViewTap:(UITapGestureRecognizer *)recognizer{
    NSLog(@"\n\n------%s\n\n",__func__);
    
    NSLog(@"\n\n====GreenView响应了====\n\n");
    
}


#pragma mark - HitTest

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    CGPoint btnP = [self convertPoint:point toView:self.blueButton];
    CGPoint greenViewP = [self convertPoint:point toView:self.greenView];
    
    if ([self.blueButton pointInside:btnP withEvent:event]) {
        return self.blueButton;
    }
    else if ([self.greenView pointInside:greenViewP withEvent:event]){
        return self.greenView;
    }
    else{
        return [super hitTest:point withEvent:event];
    }
    
    return self;
}


//-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
//
//    NSLog(@"%s",__func__);
//
//    return YES;
//}



@end

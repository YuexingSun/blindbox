//
//  ZXMineBoxStatisticsCirqueView.m
//  ZXHY
//
//  Created by Bern Mac on 1/4/22.
//

#import "ZXMineBoxStatisticsCirqueView.h"

#define toRad(angle) (angle * M_PI / 180)

@interface ZXMineBoxStatisticsCirqueView ()

//中心
@property (nonatomic, assign) CGPoint centerPoint;

//开始角度
@property (nonatomic, assign) CGFloat startAngle;

//开始和结束角度数组
@property (nonatomic, strong) NSMutableArray *startAngleArray;
@property (nonatomic, strong) NSMutableArray *endAngleArray;

//开始和持续时间数组
@property (nonatomic, strong) NSMutableArray *timeStartArray;
@property (nonatomic, strong) NSMutableArray *durationArray;

@end



@implementation ZXMineBoxStatisticsCirqueView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.startAngle = toRad(-90);
        self.totalDuration = 1.5f;
        
        [self zx_initializationUI];
    }
    
    return self;
}

//开始
- (void)strokePath {
    [self removeAllSubLayers];
    
    [self zx_isNeedAnimation];
    
    bool isD = YES;
    for (NSString *str in self.valueArray){
        if  (![str isEqualToString:@"0"]){
            isD = NO;
            break;
        }
        
    }
    if (isD){
        [self zx_firtdrawEachPie];
    }
}


#pragma mark - Initialization UI
//初始化UI
- (void)zx_initializationUI{
    
    self.backgroundColor = UIColor.clearColor;
    
    self.centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    self.radius = 50;

}

//先画背景圆
- (void)zx_firtdrawEachPie{
   
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.centerPoint radius:self.radius startAngle:0 endAngle:2*M_PI clockwise:YES];
    CAShapeLayer *shapeLayer = [CAShapeLayer new];
    shapeLayer.path = [path CGPath];
    shapeLayer.lineWidth = 20;
    shapeLayer.strokeColor = WGGrayColor(204).CGColor;
    shapeLayer.fillColor = [UIColor whiteColor].CGColor;
    [self.layer addSublayer:shapeLayer];
}


//数据赋值
- (void)setValueArray:(NSMutableArray *)valueArray {
    _valueArray = valueArray;
    
    //计算开始和持续时间数组
    self.timeStartArray = [NSMutableArray array];
    self.durationArray = [NSMutableArray array];
    
    CGFloat startTime = 0.5f;
    [self.timeStartArray  addObject:[NSNumber numberWithFloat:startTime]];
    
    for (NSInteger i=0; i<valueArray.count; i++) {
        self.durationArray[i] = [NSNumber numberWithFloat:[valueArray[i] floatValue] * self.totalDuration];
        startTime += [valueArray[i] floatValue] * self.totalDuration;
        [self.timeStartArray  addObject:[NSNumber numberWithFloat:startTime]];
    }
    //计算开始和结束角度数组
    self.startAngleArray = [NSMutableArray array];
    self.endAngleArray = [NSMutableArray array];
    
    CGFloat startAngle = self.startAngle, endAngle;
    
    for (NSInteger i=0; i<valueArray.count; i++) {
        [self.startAngleArray  addObject:[NSNumber numberWithFloat:startAngle]];
        endAngle = startAngle + [self.valueArray[i] floatValue] * 2 * M_PI;
        [self.endAngleArray  addObject:[NSNumber numberWithFloat:endAngle]];
        startAngle = endAngle;
    }
}


#pragma mark - Private Method
//是否需要动画
- (void)zx_isNeedAnimation{
    
    for (NSInteger i = 0; i < self.valueArray.count; i++) {
        if (self.isShowAnimation) {
            NSDictionary * userInfo = @{@"index":@(i)};
            NSTimer * timer = [NSTimer timerWithTimeInterval:[self.timeStartArray[i] floatValue] target:self selector:@selector(timerAction:) userInfo:userInfo repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        }else {
            [self drawEachPieWithIndex:i];
        }
    }
}

//定时器
- (void)timerAction:(NSTimer *)sender{
    NSInteger index = [[sender.userInfo objectForKey:@"index"] integerValue];
    [self drawEachPieWithIndex:index];
    
    [sender invalidate];
    sender = nil;
}

//开始绘制
- (void)drawEachPieWithIndex:(NSInteger)index {
    CGFloat startAngle = [self.startAngleArray[index] floatValue];
    CGFloat endAngle = [self.endAngleArray[index] floatValue];
   
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.centerPoint radius:self.radius startAngle:startAngle endAngle:endAngle  clockwise:YES];
    CAShapeLayer *shapeLayer = [CAShapeLayer new];
    shapeLayer.path = [path CGPath];
    shapeLayer.lineWidth = [self.lineWidthArray[index] floatValue];
//    self.lineWidth;
//    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.strokeColor = ((UIColor *)self.colorArray[index]).CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    
    if (self.isShowAnimation) {
        [shapeLayer addAnimation:[self animationWithDuration:[self.durationArray[index] floatValue]] forKey:nil];
    }
    [self.layer addSublayer:shapeLayer];
    
}

//动画
- (CABasicAnimation *)animationWithDuration:(CGFloat)duraton {
    CABasicAnimation * fillAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    fillAnimation.duration = duraton;
    fillAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    fillAnimation.fillMode = kCAFillModeForwards;
    fillAnimation.removedOnCompletion = NO;
    fillAnimation.fromValue = @(0.f);
    fillAnimation.toValue = @(1.f);
    return fillAnimation;
}


//清空layer
- (void)removeAllSubLayers{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    
    NSArray * subviews = [NSArray arrayWithArray:self.subviews];
    for (UIView * view in subviews) {
        [view removeFromSuperview];
    }
    
    NSArray * subLayers = [NSArray arrayWithArray:self.layer.sublayers];
    for (CALayer * layer in subLayers) {
        [layer removeAllAnimations];
        [layer removeFromSuperlayer];
    }
}


@end

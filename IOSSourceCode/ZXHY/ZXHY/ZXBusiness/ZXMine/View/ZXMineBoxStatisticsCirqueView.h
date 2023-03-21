//
//  ZXMineBoxStatisticsCirqueView.h
//  ZXHY
//
//  Created by Bern Mac on 1/4/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXMineBoxStatisticsCirqueView : UIView

@property (nonatomic, strong) NSMutableArray *valueArray;
@property (nonatomic, strong) NSMutableArray *colorArray;
@property (nonatomic, strong) NSMutableArray *lineWidthArray;

//动画时间
@property (nonatomic, assign) CGFloat totalDuration;
//直径
@property (nonatomic, assign) CGFloat radius;

@property (nonatomic, assign, getter=isShowAnimation) BOOL showAnimation;

//开始绘制
- (void)strokePath;
@end

NS_ASSUME_NONNULL_END

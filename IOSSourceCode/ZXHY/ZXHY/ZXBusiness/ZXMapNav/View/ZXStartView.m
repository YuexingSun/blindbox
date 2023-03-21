//
//  ZXStartView.m
//  ZXHY
//
//  Created by Bern Mac on 8/26/21.
//

#import "ZXStartView.h"
#import "ZXOpenResultsModel.h"

@interface ZXStartView()

@property (nonatomic, assign) ZXStartType startType;
@property (nonatomic, strong) NSString  *scores;
@property (nonatomic, strong) ZXOpenResultsModel  *openResultsModel;

@end

@implementation ZXStartView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {

        
    }
    return self;
}

- (void)zx_setUI{
    
    self.backgroundColor = UIColor.whiteColor;
    
    NSArray *startList = [NSArray array];
    
    
    
    if (self.startType == ZXStartType_Info){
        startList = @[@"NoStar",@"HalfStar",@"Star"];
    }else if (self.startType == ZXStartType_Point){
        startList = @[@"pinkNot",@"pinkHalf",@"pinkStart"];
    }
    
    
    NSArray *array = [self.scores componentsSeparatedByString:@"."];
    NSString *fristStr = [array wg_safeObjectAtIndex:0];
    NSString *secondStr = [array wg_safeObjectAtIndex:1];
    
    
    NSInteger count = 5;
    
    for (int i = 0 ; i < count; i++){
        
        NSString *imageStr = @"";
        if (i + 1 <= [fristStr intValue]){
            imageStr = [startList wg_safeObjectAtIndex:2];
        }else if ([secondStr intValue] > 0 && i == [fristStr intValue]){
            imageStr = [startList wg_safeObjectAtIndex:1];
        }else{
            imageStr = [startList wg_safeObjectAtIndex:0];
        }
        
        UIImageView *imageView = [UIImageView wg_imageViewWithImageNamed:imageStr];
        
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.left.mas_equalTo(0 + 17*i);
            make.height.width.offset(15);
        }];
    
    }
}



- (void)zx_scores:(NSString *)scores WithType:(ZXStartType)startType{
    
    self.scores = scores;
    
    self.startType = startType;
    
    [self zx_setUI];
}

@end

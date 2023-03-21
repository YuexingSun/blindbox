//
//  ZXMineBlindBoxStatisticsTableViewCell.m
//  ZXHY
//
//  Created by Bern Mac on 1/4/22.
//

#import "ZXMineBlindBoxStatisticsTableViewCell.h"
#import "ZXMineBoxStatisticsCirqueView.h"
#import "ZXMineModel.h"


@interface ZXMineBlindBoxStatisticsTableViewCell ()

@property (nonatomic, strong) ZXMineBoxStatisticsCirqueView *cirqueView;
@property (nonatomic, strong) UILabel  *boxNumLabel;
@property (nonatomic, strong) UILabel  *dinnerLabel;
@property (nonatomic, strong) UILabel  *playLabel;
@property (nonatomic, strong) UILabel  *snackLabel;
@property (nonatomic, strong) ZXMineModel *mineModel;

@end


@implementation ZXMineBlindBoxStatisticsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

+ (NSString *)wg_cellIdentifier{
    return @"ZXMineBlindBoxStatisticsTableViewCell";
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self zx_initializationUI];
    }
    return self;
}

//- (instancetype)initWithFrame:(CGRect)frame{
//    self = [self initWithFrame:frame];
//    if (self){
//        [self zx_initializationUI];
//    }
//    return self;
//}


#pragma mark - Initialization UI
//初始化UI
- (void)zx_initializationUI{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = UIColor.clearColor;
    self.contentView.backgroundColor = UIColor.clearColor;
    
    UIView *bgView = [UIView new];
    bgView.backgroundColor = UIColor.whiteColor;
    bgView.layer.cornerRadius = 12;
    bgView.layer.masksToBounds = YES;
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-8);
    }];

    UILabel *titleLabel = [UILabel labelWithFont:kFontSemibold(15) TextAlignment:NSTextAlignmentLeft TextColor:WGGrayColor(153) TextStr:@"最近七天开盒统计" NumberOfLines:1];
    [bgView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgView).offset(20);
        make.left.mas_equalTo(bgView).offset(25);
        make.width.offset(150);
        make.height.offset(20);
    }];
    
    
    //圆环
    ZXMineBoxStatisticsCirqueView *cirqueView = [[ZXMineBoxStatisticsCirqueView alloc] initWithFrame:CGRectMake(30, 65, 110, 110 )];
    
    cirqueView.valueArray = [NSMutableArray arrayWithObjects:@"0.49", @"0.01", @"0.19", @"0.01", @"0.29", @"0.01", nil];
    
    cirqueView .colorArray = [NSMutableArray arrayWithObjects:WGRGBColor(133, 132, 253),[UIColor whiteColor],WGRGBColor(242, 153, 242),[UIColor whiteColor],WGRGBColor(255, 195, 104), [UIColor whiteColor], nil];
    
    cirqueView.lineWidthArray = [NSMutableArray arrayWithObjects:@"11", @"11", @"15", @"15",@"18", @"18",  nil];
    
    cirqueView.showAnimation = YES;
//    [cirqueView strokePath];
    [bgView addSubview:cirqueView];
    self.cirqueView = cirqueView;
    
    
    //开盒总数
     UILabel *boxTitleLabel = [UILabel labelWithFont:kFontMedium(12) TextAlignment:NSTextAlignmentCenter TextColor:WGGrayColor(153) TextStr:@"开盒" NumberOfLines:1];
    [bgView addSubview:boxTitleLabel];
    [boxTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(cirqueView);
        make.centerY.mas_equalTo(cirqueView.mas_centerY).offset(-15);
        make.width.offset(50);
        make.height.offset(20);
    }];
    
    
    self.boxNumLabel = [UILabel labelWithFont:kFontSemibold(28) TextAlignment:NSTextAlignmentCenter TextColor:WGGrayColor(68) TextStr:@"6" NumberOfLines:1];
    [bgView addSubview:self.boxNumLabel];
    [self.boxNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(cirqueView);
        make.centerY.mas_equalTo(cirqueView.mas_centerY).offset(10);
        make.width.offset(50);
        make.height.offset(30);
    }];
    
    
    
    //数据列表
    NSArray *arr = @[WGRGBColor(255, 195, 104),WGRGBColor(133, 132, 253),WGRGBColor(242, 153, 242)];
    NSArray *titleArr = @[@"正餐",@"玩乐",@"小吃"];
    
    for (int i = 0 ; i < 3; i++){
        UIView *view = [UIView new];
        view.layer.cornerRadius = 1;
        view.layer.masksToBounds = YES;
        view.backgroundColor = [arr wg_safeObjectAtIndex:i];
        [bgView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(cirqueView.mas_top).offset(15 + i*(12 + 12 + 15));
            make.left.mas_equalTo(cirqueView.mas_right).offset(50);
            make.width.offset(5);
            make.height.offset(12);
        }];
        
        
        UILabel *titileLabel = [UILabel labelWithFont:kFontSemibold(12) TextAlignment:NSTextAlignmentLeft TextColor:WGGrayColor(102) TextStr:[titleArr wg_safeObjectAtIndex:i] NumberOfLines:1];
        [bgView addSubview:titileLabel];
        [titileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(view);
            make.left.mas_equalTo(view.mas_right).offset(10);
            make.width.offset(50);
            make.height.offset(20);
        }];
        
        
        UILabel *infoLabel = [UILabel labelWithFont:kFontSemibold(20) TextAlignment:NSTextAlignmentRight TextColor:WGGrayColor(51) TextStr:@"4" NumberOfLines:1];
        [bgView addSubview:infoLabel];
        [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(titileLabel);
            make.left.mas_equalTo(titileLabel.mas_right).offset(5);
            make.right.mas_equalTo(bgView.mas_right).offset(-30);
            make.height.offset(20);
        }];
        if (i == 0){
           self.dinnerLabel = infoLabel;
        }else if (i == 1){
            self.playLabel = infoLabel;
        }else if (i == 2){
            self.snackLabel = infoLabel;
        }
        
        
        //虚线
        CAShapeLayer *shapeLayer = [self setBorderWithView:bgView BorderColor:WGRGBColor(204, 204, 204) BorderWidth:1 LineWidth:3 LineSpace:2 StartPoint:CGPointMake(190,107 + i *(12 + 12 + 15)) EndPoint:CGPointMake(WGNumScreenWidth() - 60,107 + i *(12 + 12 + 15))];
        [shapeLayer setStrokeColor:[WGGrayColor(153) CGColor]];
    }
    
}

#pragma mark - 绘制虚线
- (CAShapeLayer* )setBorderWithView:(UIView *)view BorderColor:(UIColor *)borderColor BorderWidth:(CGFloat)borderWidth LineWidth:(CGFloat)lineWidth LineSpace:(CGFloat)lineSpace StartPoint:(CGPoint)startPotin EndPoint:(CGPoint)endPotin{

    CAShapeLayer*shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:self.bounds];
    [shapeLayer setPosition:self.center];
    [shapeLayer setFillColor:[[UIColor clearColor]CGColor]];
    [shapeLayer setStrokeColor:[borderColor CGColor]];
    //设置虚线的宽度
    [shapeLayer setLineWidth:borderWidth];
    [shapeLayer setLineJoin:kCALineJoinRound];
    // 线的宽度 //每条线的间距
    [shapeLayer setLineDashPattern:
    [NSArray arrayWithObjects:[NSNumber numberWithInt:lineWidth],
    [NSNumber numberWithInt:lineSpace],nil]];
    CGMutablePathRef path =CGPathCreateMutable();
    // endPotin.x, endPotin.y代表的是虚线最终点坐标
    CGPathMoveToPoint(path,NULL,endPotin.x,endPotin.y);
    //startPotin.x,startPotin.y代表初始坐标的x，y
    CGPathAddLineToPoint(path,NULL,startPotin.x,startPotin.y);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    [view.layer addSublayer:shapeLayer];
    [self layoutIfNeeded];
    [view layoutIfNeeded];
    return shapeLayer;
}



//数据赋值
- (void)zx_dataWithMineModel:(ZXMineModel *)mineModel{
    
    self.mineModel = mineModel;
    self.boxNumLabel.text = mineModel.last7days.boxnumber;
    
    
    NSString *dinner = @"0";
    NSString *dinnerGap = @"0";
    UIColor *dinnerColor = WGRGBColor(255, 195, 104);
    
    NSString *play = @"0";
    NSString *playGap = @"0";
    UIColor *playColor =  WGRGBColor(133, 132, 253);
    
    NSString *snack = @"0";
    NSString *snackGap = @"0";
    UIColor *snackColor = WGRGBColor(242, 153, 242);
   
    
    
    for (ZXMineLastSevenDaysCatelistModel *cateModel in mineModel.last7days.catelist){
        
        if ([cateModel.cateid intValue] == 1 ){
            self.dinnerLabel.text = cateModel.number;
            if ([cateModel.number intValue] > 0){
                double aa = ([cateModel.number doubleValue] /  [mineModel.last7days.boxnumber doubleValue]) - 0.01 ;
                dinner = [NSString stringWithFormat:@"%0.2f",aa];
                dinnerGap = @"0.01";
            }
        }
        
        if ([cateModel.cateid intValue] == 2){
            self.playLabel.text = cateModel.number;
            
            if ([cateModel.number intValue] > 0){
                double aa = ([cateModel.number doubleValue] /  [mineModel.last7days.boxnumber doubleValue]) - 0.01 ;
                play = [NSString stringWithFormat:@"%0.2f",aa];
                playGap = @"0.01";
            }
           
        }
        
        if ([cateModel.cateid intValue] == 3){
            self.snackLabel.text = cateModel.number;
            
            if ([cateModel.number intValue] > 0){
                double aa = ([cateModel.number doubleValue] /  [mineModel.last7days.boxnumber doubleValue]) - 0.01 ;
                snack = [NSString stringWithFormat:@"%0.2f",aa];
                snackGap = @"0.01";
            }
            
        }
    }
    
    
    if ([dinnerGap isEqualToString:@"0"] && [snackGap isEqualToString:@"0"]){
        play = [NSString stringWithFormat:@"%0.2f",[play doubleValue] + 0.01];
        playGap = @"0";
    }
    if ([dinnerGap isEqualToString:@"0"] && [playGap isEqualToString:@"0"]){
        snack = [NSString stringWithFormat:@"%0.2f",[snack doubleValue] + 0.01];
        snackGap = @"0";
    }
    if ([snackGap isEqualToString:@"0"] && [playGap isEqualToString:@"0"]){
        dinner = [NSString stringWithFormat:@"%0.2f",[dinner doubleValue] + 0.01];
        dinnerGap = @"0";
    }
    
    
    
    NSLog(@"-%@-%@-%@",dinner,play,snack);
    
    self.cirqueView.valueArray = [NSMutableArray arrayWithObjects:play, playGap, snack, snackGap, dinner, dinnerGap, nil];
    
    self.cirqueView .colorArray = [NSMutableArray arrayWithObjects:playColor,[UIColor whiteColor],snackColor,[UIColor whiteColor],dinnerColor, [UIColor whiteColor], nil];
    
    [self.cirqueView strokePath];
}


@end

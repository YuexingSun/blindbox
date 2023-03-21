//
//  ZXMapNavDetailsView.m
//  ZXHY
//
//  Created by Bern Lin on 2021/12/1.
//

#import "ZXMapNavDetailsView.h"
#import "ZXValidationManager.h"
#import "ZXMapNavManager.h"
#import "ZXOpenResultsModel.h"
#import "ZXBlindBoxViewModel.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ZXMapNavExitSelectView.h"
#import <Lottie/Lottie.h>



@interface ZXMapNavDetailsView()
<ZXMapNavExitSelectViewDelegate>

@property (nonatomic, strong) WGGeneralSheetController *sheetVc;

@property (nonatomic, strong) ZXOpenResultsModel *openResultsModel;
@property (nonatomic, strong) AMapNaviPoint *startPoint;

@property (nonatomic, strong) UIView  *bgView;
@property (nonatomic, strong) UILabel *topInfoLabel;

//倒计时
@property (nonatomic, strong) UILabel *countDownLabel;
@property(nonatomic, strong) LOTAnimationView *animationView;//动画

@property (nonatomic, strong) UILabel *readyLabel;
@property (nonatomic, strong) UIButton  *closeButton;
@property (nonatomic, strong) UIButton  *displayButton;
@property (nonatomic, strong) UIButton  *otherNavButton;
@property (nonatomic, strong) UIImageView  *navImageView;
//当前路段剩余距离
@property (nonatomic, strong) UILabel  *remainDistanceLabel;
//下一路线名称
@property (nonatomic, strong) UILabel  *roadLabel;

@end

@implementation ZXMapNavDetailsView


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self zx_countdownView];
    }
    
    return self;
}

#pragma mark - Initialization UI
- (void)zx_countdownView{
    
    self.backgroundColor = UIColor.clearColor;
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.mj_w, self.mj_h)];
    NSArray * colors = @[WGRGBColor(0, 0, 0),WGRGBColor(0, 0, 0)];
    [self.bgView wg_backgroundGradientVerticalColors:colors];
    self.bgView.alpha = 0.6;
    [self addSubview:self.bgView];
    
    UILabel *topInfoLabel = [UILabel labelWithFont:kFont(20) TextAlignment:NSTextAlignmentLeft TextColor:UIColor.whiteColor TextStr:@"请先前往 \n  附近" NumberOfLines:4];
    [self addSubview:topInfoLabel];
    [topInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(55);
        make.left.mas_equalTo(self.mas_left).offset(20);
        make.right.mas_equalTo(self.mas_right).offset(-20);
    }];
    self.topInfoLabel = topInfoLabel;
    
    //当前路段剩余距离
    self.remainDistanceLabel = [UILabel labelWithFont:kFontSemibold(36) TextAlignment:NSTextAlignmentLeft TextColor:UIColor.whiteColor TextStr:@"0m 进入" NumberOfLines:1];
    [self addSubview:self.remainDistanceLabel];
    [self.remainDistanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topInfoLabel.mas_bottom).offset(10);
        make.left.right.mas_equalTo(self.topInfoLabel);
    }];
    
    //下一路线名称
    self.roadLabel = [UILabel labelWithFont:kFontSemibold(36) TextAlignment:NSTextAlignmentLeft TextColor:UIColor.whiteColor TextStr:@"" NumberOfLines:2];
    [self addSubview:self.roadLabel];
    [self.roadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.remainDistanceLabel.mas_bottom);
        make.left.right.mas_equalTo(self.topInfoLabel);
    }];
    

    UILabel *countDownLabel = [UILabel labelWithFont:kFontMedium(195) TextAlignment:NSTextAlignmentCenter TextColor:UIColor.whiteColor TextStr:@"3" NumberOfLines:1];
    [self addSubview:countDownLabel];
    [countDownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(self);
        make.left.right.mas_equalTo(topInfoLabel);
        make.height.offset(195);
    }];
    self.countDownLabel = countDownLabel;
    
    
    //动画
    self.animationView = [LOTAnimationView animationNamed:@"navCountdown"];
    self.animationView.animationSpeed = 1.0f;
    self.animationView.loopAnimation = NO;
    [self addSubview:self.animationView];
    [self.animationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(self);
        make.width.height.offset((IS_IPHONE_X_SER) ? 350.0 : 280);
    }];
    
    
    
    UILabel *readyLabel = [UILabel labelWithFont:kFontSemibold(24) TextAlignment:NSTextAlignmentCenter TextColor:UIColor.whiteColor TextStr:@"准备出发" NumberOfLines:1];
    [self addSubview:readyLabel];
    [readyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.animationView.mas_top).offset(30);
        make.left.right.mas_equalTo(topInfoLabel);
    }];
    self.readyLabel = readyLabel;
    
    //其他图层按钮
    self.displayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.displayButton setImage:IMAGENAMED(@"Exclude") forState:UIControlStateNormal];
    self.displayButton.tag = 40002;
    [self addSubview:self.displayButton];
    [self.displayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-44);
        make.width.height.offset(65);
    }];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
   //长按时间
    longPress.minimumPressDuration = 0.2;
    [self.displayButton addGestureRecognizer:longPress];
    
    
    //关闭按钮
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeButton setImage:IMAGENAMED(@"NavCloseGray") forState:UIControlStateNormal];
    self.closeButton.tag = 40001;
    [self.closeButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.width.height.equalTo(self.displayButton);
        make.right.equalTo(self.displayButton.mas_left).offset(-45);
    }];
    
    //其他导航按钮
    self.otherNavButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.otherNavButton setImage:IMAGENAMED(@"otherNavGray") forState:UIControlStateNormal];
    self.otherNavButton.tag = 40003;
    [self.otherNavButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.otherNavButton];
    [self.otherNavButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.width.height.equalTo(self.displayButton);
        make.left.equalTo(self.displayButton.mas_right).offset(45);
    }];
    
    
    //导航图标
    self.navImageView = [UIImageView wg_imageViewWithImageNamed:@""];
    self.navImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.navImageView];
    [self.navImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(self);
        make.width.height.offset(200);
    }];
    
   
}


#pragma mark - Private Method
//倒计时前后处理
- (void)zx_isBeforeTheCountdown:(BOOL)isBefore{
    
    self.readyLabel.hidden = !isBefore;
    
    self.countDownLabel.hidden = YES;
    self.animationView.hidden = !isBefore;
    
    self.navImageView.hidden = isBefore;
    self.closeButton.hidden = isBefore;
    self.otherNavButton.hidden = isBefore;
    self.displayButton.hidden = isBefore;
    self.remainDistanceLabel.hidden = isBefore;
    self.roadLabel.hidden = isBefore;
    
    //文本处理
    NSInteger topInfoLabelFont = 20;
    NSInteger topInfoLabelattributedFont = 28;
    
    NSString *mainStr =  [NSString stringWithFormat:@"请先前往 \n%@ \n%@",self.openResultsModel.buildName,self.openResultsModel.address];
    if (isBefore){
        topInfoLabelFont = 20;
        topInfoLabelattributedFont = 28;
        mainStr =  [NSString stringWithFormat:@"请先前往 \n%@",self.openResultsModel.buildName];
    }else{
        topInfoLabelFont = 15;
        topInfoLabelattributedFont = 16;
        mainStr = [NSString stringWithFormat:@"请先前往 %@\n",self.openResultsModel.buildName];
    }
    
    self.topInfoLabel.font = kFont(topInfoLabelFont);
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:mainStr];
    NSRange range = [[attributedString string] rangeOfString:self.openResultsModel.buildName];
    [attributedString addAttribute:NSFontAttributeName value:kFontSemibold(topInfoLabelattributedFont) range:range];
    
    if ([mainStr containsString:@"附近"]){
        NSRange nearlyRange = [[attributedString string] rangeOfString:@"附近"];
        [attributedString addAttribute:NSFontAttributeName value:kFont(topInfoLabelFont) range:nearlyRange];
        [attributedString replaceCharactersInRange:nearlyRange withString:@" 附近"];
    }
    
    
    self.topInfoLabel.attributedText = attributedString;
}

//接收到倒计时刷新UI
- (void)zx_refreshWithTimeBlock{
    WEAKSELF;
    [ZXValidationManager shareValidationManager].timeBlock = ^(NSInteger timeout) {
        STRONGSELF;
        if(timeout <= 0){
            
            [[ZXValidationManager shareValidationManager] zx_closeAndDestroyed];
            
//            NSArray * colors = @[WGRGBColor(0, 0, 0),WGRGBColor(0, 0, 0)];
//            [self.bgView wg_backgroundGradientVerticalColors:colors];
            
            //倒计时前后处理
            [self zx_isBeforeTheCountdown:NO];
           
        } else {
            NSString *timerStr = [NSString stringWithFormat:@"%ld",timeout];
            self.countDownLabel.text = timerStr;
            
            
        }
    };
}


//按钮响应
- (void)buttonAction:(UIButton *)sender{
    //关闭
    if (sender.tag == 40001){
//        [WGNotification postNotificationName:ZXNotificationMacro_ExitNav object:nil];
        
        ZXMapNavExitSelectView *view = [[ZXMapNavExitSelectView alloc] initWithFrame:CGRectMake(0, 0, WGNumScreenWidth(), 200) withBoxId:self.openResultsModel.boxid];
        view.delegate = self;
        self.sheetVc = [WGGeneralSheetController  sheetControllerWithCustomView:view];
        [self.sheetVc showToCurrentVc];
    }
    //其他导航
    else if(sender.tag == 40003){
        
        CLLocationCoordinate2D startCllo = CLLocationCoordinate2DMake(self.startPoint.latitude, self.startPoint.longitude);
        
        CLLocationCoordinate2D endCllo = CLLocationCoordinate2DMake([self.openResultsModel.lnglat.lat floatValue] ,[self.openResultsModel.lnglat.lng floatValue]);

        UIAlertController *actionSheet = [ZXMapNavManager  getInstalledMapAppWithEndLocation:endCllo currentLocation:startCllo];
        [[WGUIManager wg_currentIndexNavTopController] presentViewController:actionSheet animated:YES completion:nil];
        
    }
}

//长按响应
-(void)longPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        self.hidden = YES;
    }else if ([gestureRecognizer state] == UIGestureRecognizerStateEnded){
        self.hidden = NO;
    }
   
}


//转向图标
- (void)zx_setTurnIconImage:(UIImage  *)turnIconImage{
    if (turnIconImage) {
        self.navImageView.image = turnIconImage;
    }
}


//数据
- (void)zx_openResultslnglatModel:(ZXOpenResultsModel *)openResultsModel ParentlistModel:(ZXBlindBoxViewParentlistModel *)parentlistModel{
    
    if (kObjectIsEmpty(openResultsModel)) {
        self.otherNavButton.userInteractionEnabled = NO;
        return;
    }
    
    self.openResultsModel = openResultsModel;
    self.startPoint = parentlistModel.startPoint;
    
    self.otherNavButton.userInteractionEnabled = YES;
    

    if (parentlistModel.isBegin == 1){
        [self zx_isBeforeTheCountdown:NO];
    }else{
        //倒计时前后处理
        [self zx_isBeforeTheCountdown:YES];
        
        [self.animationView playWithCompletion:^(BOOL animationFinished) {
            if (animationFinished){
                //倒计时后处理
                [self zx_isBeforeTheCountdown:NO];
            }
        }];
    }
   
    
}

//距离下个街道的剩余距离处理
- (void)zx_updateNaviInfo:(AMapNaviInfo *)naviInfo{
    
    NSString *mainStr = @"";
    
    if (naviInfo.segmentRemainDistance < 0) {
        return;
    }
    
    if (naviInfo.segmentRemainDistance >= 1000) {
        CGFloat kiloMeter = naviInfo.segmentRemainDistance / 1000.0;
        mainStr =  [NSString stringWithFormat:@"%.1fkm 进入", kiloMeter];
    } else {
        mainStr = [NSString stringWithFormat:@"%ldm 进入", (long)naviInfo.segmentRemainDistance];
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:mainStr];
    NSRange range = [[attributedString string] rangeOfString:@"进入"];
    [attributedString addAttribute:NSFontAttributeName value:kFontSemibold(16) range:range];
    self.remainDistanceLabel.attributedText = attributedString;
    
    self.roadLabel.text = naviInfo.nextRoadName;
}


#pragma mark - ZXMapNavExitSelectViewDelegate
- (void)zx_exitSelectView:(ZXMapNavExitSelectView *)exitSelectView NavExitType:(NavExitType)navExitType{
    [self.sheetVc dissmissSheetVc];
}


@end

//
//  ZXMapNavEvaluationViewCell.m
//  ZXHY
//
//  Created by Bern Lin on 2021/11/4.
//

#import "ZXMapNavEvaluationViewCell.h"
#import "ZXOpenResultsModel.h"
#import "ZXMapNavEvaluationView.h"

@interface ZXMapNavEvaluationViewCell ()
<ZXMapNavEvaluationViewDelegate>

@property (nonatomic, strong) ZXOpenResultsModel *openResultsModel;
@property (nonatomic, strong) UIButton *satisfiedButton;
@property (nonatomic, strong) UIButton *notSatisfiedButton;
@property (nonatomic, strong) UIView  *satisfiedView;
@property (nonatomic, strong) UIView  *noSatisfiedView;
@property (nonatomic, strong) WGGeneralSheetController *sheetVc;
@property (nonatomic, strong) ZXMapNavEvaluationView *evaluationView;

@end

@implementation ZXMapNavEvaluationViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)wg_cellIdentifier{
    return @"ZXMapNavEvaluationViewCellID";
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self setupUI];
    }
    return self;
}

#pragma mark - Private Method
//设置UI
- (void)setupUI{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = UIColor.clearColor;

    self.contentView.backgroundColor = UIColor.clearColor;
    
    
    UIView *bgView = [UIView new];
    bgView.layer.cornerRadius = 5;
    bgView.layer.masksToBounds = YES;
    bgView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView).offset(10);
    }];
    
    
    UIImageView *bgImageView = [UIImageView wg_imageViewWithImageNamed:@"MapNavEvaluation"];
    bgImageView.frame = CGRectMake(0, 0, self.contentView.mj_w, 40);
    [bgView addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(bgView);
        make.height.offset(40);
    }];
    
    
    UILabel *tipsLabel = [UILabel labelWithFont:kFontMedium(18) TextAlignment:NSTextAlignmentLeft TextColor:WGRGBColor(255, 57, 152) TextStr:@"您对本次行程满意吗？" NumberOfLines:1];
    [bgView addSubview:tipsLabel];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bgImageView);
        make.left.mas_equalTo(bgView).offset(15);
        make.height.offset(25);
    }];
    

    UIImageView *evaluationLuckImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, bgImageView.mj_h, 140, 22)];
    evaluationLuckImageView.image = [UIImage imageNamed:@"EvaluationLuck"];
    [bgView addSubview:evaluationLuckImageView];
    [evaluationLuckImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgImageView.mas_bottom);
        make.left.mas_equalTo(tipsLabel);
        make.height.offset(22);
        make.width.offset(140);
    }];
    
    

    //满意
    UIButton *satisfiedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    satisfiedButton.layer.cornerRadius = 8;
    satisfiedButton.layer.masksToBounds = YES;
    satisfiedButton.backgroundColor = WGGrayColor(245);
    satisfiedButton.contentMode = UIViewContentModeScaleAspectFill;
    [satisfiedButton setImageEdgeInsets:UIEdgeInsetsMake(5, 25, 5, 85)];
    
    satisfiedButton.titleLabel.font = kFontMedium(16);
    [satisfiedButton setTitle:@"满意" forState:UIControlStateNormal];
    [satisfiedButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [satisfiedButton setTitleColor:WGRGBColor(255, 121, 45) forState:UIControlStateSelected];
    [satisfiedButton setImage:IMAGENAMED(@"Satisfied") forState:UIControlStateNormal];
    [satisfiedButton setImage:IMAGENAMED(@"SatisfiedSelect") forState:UIControlStateSelected];
    [satisfiedButton addTarget:self action:@selector(satisfiedAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:satisfiedButton];
    [satisfiedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(evaluationLuckImageView.mas_bottom).offset(10);
        make.right.mas_equalTo(bgView.mas_centerX).offset(-15);
        make.height.offset(46);
        make.width.offset(148);
    }];
    self.satisfiedButton = satisfiedButton;

    
    //不满意
    UIButton *notSatisfiedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    notSatisfiedButton.layer.cornerRadius = 8;
    notSatisfiedButton.layer.masksToBounds = YES;
    notSatisfiedButton.backgroundColor = WGGrayColor(245);
    notSatisfiedButton.contentMode = UIViewContentModeScaleAspectFill;
    [notSatisfiedButton setImageEdgeInsets:UIEdgeInsetsMake(5, 25, 5, 85)];
    
    notSatisfiedButton.titleLabel.font = kFontMedium(16);
    [notSatisfiedButton setTitle:@"不满意" forState:UIControlStateNormal];
    [notSatisfiedButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [notSatisfiedButton setTitleColor:WGRGBColor(255, 121, 45) forState:UIControlStateSelected];
    [notSatisfiedButton setImage:IMAGENAMED(@"notSatisfied") forState:UIControlStateNormal];
    [notSatisfiedButton setImage:IMAGENAMED(@"notSatisfiedSelect") forState:UIControlStateSelected];
    [notSatisfiedButton addTarget:self action:@selector(notSatisfiedAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:notSatisfiedButton];
    [notSatisfiedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(satisfiedButton);
        make.left.mas_equalTo(bgView.mas_centerX).offset(15);
        make.height.offset(46);
        make.width.offset(148);
    }];
    self.notSatisfiedButton = notSatisfiedButton;
    
  
}



#pragma mark - Private Method

//满意按钮
- (void)satisfiedAction:(UIButton *)sender{
        
    if (sender.selected == NO){
        sender.selected = YES;
        sender.backgroundColor = WGRGBColor(255, 246, 232);
        
        self.notSatisfiedButton.selected = NO;
        self.notSatisfiedButton.backgroundColor = WGGrayColor(245);
    }
    
    //评价弹窗
    [self zx_evaluationViewWithIsSatisfied:YES];
}

//不满意
- (void)notSatisfiedAction:(UIButton *)sender{
    
    if (sender.selected == NO){
        sender.selected = YES;
        sender.backgroundColor = WGRGBColor(255, 246, 232);
        
        self.satisfiedButton.selected = NO;
        self.satisfiedButton.backgroundColor = WGGrayColor(245);
    }
    
    //评价弹窗
    [self zx_evaluationViewWithIsSatisfied:NO];
}

//评价弹窗
- (void)zx_evaluationViewWithIsSatisfied:(BOOL)isSatisfied{
    
    CGFloat H = ceil(CGRectGetHeight(UIScreen.mainScreen.bounds) * .35f);
    if (isSatisfied){
        H = ceil(CGRectGetHeight(UIScreen.mainScreen.bounds) * .35f);
    }else{
        H = ceil(CGRectGetHeight(UIScreen.mainScreen.bounds) * .55f);
    }
    
    ZXMapNavEvaluationView *evaluationView  = [[ZXMapNavEvaluationView alloc] initWithFrame:CGRectMake(0, 0, WGNumScreenWidth(), H)];
    evaluationView.delegate = self;
    [evaluationView zx_openResultsModel:self.openResultsModel];
    self.evaluationView = evaluationView;
    [evaluationView zx_isSatisfied:(BOOL)isSatisfied];
    
    self.sheetVc = [WGGeneralSheetController sheetControllerWithCustomView:evaluationView];
    [self.sheetVc showToCurrentVc];
}


//数据赋值
- (void)zx_openResultsModel:(ZXOpenResultsModel *)openResultsModel{
    
    self.openResultsModel = openResultsModel;
}



#pragma mark - ZXMapNavEvaluationViewDelegate

- (void)mapNavEvaluationView:(ZXMapNavEvaluationView *)evaluationView SelectorWithEvaluation:(UIButton *)sender{
    
    if (sender.tag == CancelButton ){
        [self.sheetVc dissmissSheetVc];
        return;
    }else if (sender.tag == SubmitButton){
        [self.sheetVc dissmissSheetVc];
        [WGNotification postNotificationName:ZXNotificationMacro_ExitNav object:nil];
        return;
    }
    
    
    
    CGFloat Y = 0;
    CGFloat H = 0;
    
    if (sender.tag == SatisfiedButtonTag){
        Y = WGNumScreenHeight() - ceil(CGRectGetHeight(UIScreen.mainScreen.bounds) * .35f);
        H = ceil(CGRectGetHeight(UIScreen.mainScreen.bounds) * .35f);

    }else if (sender.tag == NotSatisfiedButtonTag){
        Y = WGNumScreenHeight() - ceil(CGRectGetHeight(UIScreen.mainScreen.bounds) * .55f);
        H = ceil(CGRectGetHeight(UIScreen.mainScreen.bounds) * .55f);
    }

    
    [UIView animateWithDuration:0.3 animations:^{
        self.evaluationView.mj_h =  H;
        self.evaluationView.mj_y =  Y;
    }];
    
    
    
}



#pragma mark - NetworkRequest
//盲盒到达后评价请求
- (void)zx_reqApiFinishBoxIslike:(NSString *)islike{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict wg_safeSetObject:self.openResultsModel.boxid forKey:@"boxid"];
    [dict wg_safeSetObject:islike forKey:@"islike"];
    
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiFinishBox Parameter:dict success:^(NSDictionary * _Nonnull resultDic) {
        [WGUIManager wg_hideHUD];
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

@end

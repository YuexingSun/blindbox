//
//  ZXMapNavResultsView.m
//  ZXHY
//
//  Created by Bern Mac on 8/9/21.
//

#import "ZXMapNavResultsView.h"
#import "ZXOpenResultsModel.h"
#import "ZXStartView.h"
#import "ZXReachedNumView.h"
#import <Lottie/Lottie.h>
#import "ZXMapNavResultsheaderViewCell.h"
#import "ZXMapNavEvaluationViewCell.h"

@interface ZXMapNavResultsView()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) UILabel  *titleLabel;
@property (nonatomic, strong) UILabel  *infoLabel;

@property (nonatomic, strong) UIView *infoView;;
@property (nonatomic, strong) UIImageView  *infoImageView;
@property (nonatomic, strong) UILabel  *infoNameLabel;
@property (nonatomic, strong) UILabel  *infoAddressLabel;
@property (nonatomic, strong) UIView  *infoArrivedBgView;
@property (nonatomic, strong) UILabel  *infoArrivedtextLabel;
@property (nonatomic, strong) ZXStartView  *startView;
@property (nonatomic, strong) ZXReachedNumView *reachedView;

@property (nonatomic, strong) UIButton *satisfiedButton;
@property (nonatomic, strong) UIButton *notSatisfiedButton;

@property (nonatomic, strong) ZXOpenResultsModel *openResultsModel;

//动画
@property(nonatomic, strong) LOTAnimationView *animationView;

//tableView
@property (nonatomic, strong) WGBaseTableView            *tableView;

@end

@implementation ZXMapNavResultsView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        
    }
    return self;
}

#pragma mark - Initialization UI

//动画UI
- (void)setupAnimationUI{
    
    self.animationView = [LOTAnimationView animationNamed:@"data"];
    self.animationView.animationSpeed = 1.0f;
    [self addSubview:self.animationView];
    [self.animationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
        make.width.height.mas_equalTo(250.0);
    }];
    
    [self.animationView playFromProgress:0 toProgress:0.6 withCompletion:^(BOOL animationFinished) {
        
        self.animationView.hidden = YES;
        
        [self reCodeUI];
        
        [self data];
        
    }];
}


//重新定制UI
- (void)reCodeUI{
    
    //关闭按钮
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:IMAGENAMED(@"navClose") forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(15);
        make.top.mas_equalTo(self).offset(kNavBarHeight - 15);
        make.width.height.offset(40);
    }];
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(closeButton.mas_bottom).offset(50);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-20);
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.right.mas_equalTo(self.mas_right).offset(-15);
    }];
    
}

#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0){
        ZXMapNavResultsheaderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZXMapNavResultsheaderViewCell wg_cellIdentifier]];
        [cell zx_openResultsModel:self.openResultsModel];
        return cell;
    }else{
        ZXMapNavEvaluationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZXMapNavEvaluationViewCell wg_cellIdentifier]];
        [cell zx_openResultsModel:self.openResultsModel];
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0){
        return UITableViewAutomaticDimension;
    }else{
        return 155;
    }
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{
    return 500;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}




#pragma mark - 传入数据
//传入数据
- (void)zx_openResultslnglatModel:(ZXOpenResultsModel *)openResultsModel IsFirst:(BOOL)isFirst{
    self.openResultsModel = openResultsModel;
    
    if (isFirst){
        [self setupAnimationUI];
    }else{
        
        [self reCodeUI];
        [self data];
    }
    
    
}

- (void)data{
    self.infoNameLabel.text = self.openResultsModel.realname;

    self.infoAddressLabel.text = self.openResultsModel.address;
    
    [self.infoImageView wg_setImageWithURL:[NSURL URLWithString:self.openResultsModel.logo] placeholderImage:nil];
    
    self.infoArrivedtextLabel.text = self.openResultsModel.arrivedtext;
    [self zx_attributedText];
    
    //
    [self.startView zx_scores:self.openResultsModel.point WithType:ZXStartType_Point];
    [self.reachedView zx_resultsheaderViewOpenResultsModel:self.openResultsModel];
    
    //圆角
    [self.infoView  layoutIfNeeded];
    [self.infoView  wg_setRoundedCornersWithRadius:5];
}


//遍历特殊文本
- (void)zx_attributedText{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self.openResultsModel.arrivedtext];
    
    for (int i = 0; i < self.openResultsModel.arrivedvarlist.count; i++){
        
        NSString *placeStr =  [NSString stringWithFormat:@" %@ ",[self.openResultsModel.arrivedvarlist wg_safeObjectAtIndex:i]];
        
        NSString *str = [NSString stringWithFormat:@"{{SJTL%d}}",i + 1];
        
        if ([self.openResultsModel.arrivedtext containsString:str]){
           
            NSRange range = [[attributedString string] rangeOfString:str];
            [attributedString addAttribute:NSForegroundColorAttributeName value:WGHEXColor(self.openResultsModel.colorlist.varcolor) range:range];
            [attributedString addAttribute:NSFontAttributeName value:kFontSemibold(16) range:range];
            [attributedString replaceCharactersInRange:range withString:placeStr];
            
        }
        
        
    }
    self.infoArrivedtextLabel.attributedText = attributedString;
    
}

#pragma mark - Private Method
//关闭按钮
- (void)closeAction:(UIButton *)sender{
        
    if(self.delegate && [self.delegate respondsToSelector:@selector(closeResultsView:)]){
        [self.delegate closeResultsView:self];
    }
}

//满意按钮
- (void)satisfiedAction:(UIButton *)sender{
        
    if (sender.selected == NO){
        sender.selected = YES;
        self.notSatisfiedButton.selected = NO;
    }
    [self zx_reqApiFinishBoxIslike:@"1"];
}

//不满意
- (void)notSatisfiedAction:(UIButton *)sender{
    
    if (sender.selected == NO){
        sender.selected = YES;
        self.satisfiedButton.selected = NO;
    }
    [self zx_reqApiFinishBoxIslike:@"2"];
}


#pragma mark - NetworkRequest
//盲盒到达后评价
- (void)zx_reqApiFinishBoxIslike:(NSString *)islike{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict wg_safeSetObject:self.openResultsModel.boxid forKey:@"boxid"];
    [dict wg_safeSetObject:islike forKey:@"islike"];
    
   
    WEAKSELF;
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiFinishBox Parameter:dict success:^(NSDictionary * _Nonnull resultDic) {
        STRONGSELF;
        [WGUIManager wg_hideHUD];
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}



#pragma mark - 懒加载

- (WGBaseTableView *)tableView{
    if (!_tableView){
        _tableView = [[WGBaseTableView alloc] initWithFrame:CGRectZero];
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[ZXMapNavResultsheaderViewCell class] forCellReuseIdentifier:[ZXMapNavResultsheaderViewCell wg_cellIdentifier]];
        [_tableView registerClass:[ZXMapNavEvaluationViewCell class] forCellReuseIdentifier:[ZXMapNavEvaluationViewCell wg_cellIdentifier]];
        
    }
    return _tableView;
}

@end



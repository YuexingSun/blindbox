//
//  ZXMapNavEvaluationView.m
//  ZXHY
//
//  Created by Bern Lin on 2021/11/8.
//

#import "ZXMapNavEvaluationView.h"
#import "ZXCollectionViewLateralFlowLayout.h"
#import "ZXMineBoxDetailsEvaluationCollectionViewCell.h"
#import "ZXBlindBoxSelectViewModel.h"
#import "ZXOpenResultsModel.h"
#import <Lottie/Lottie.h>

@interface ZXMapNavEvaluationView()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) ZXOpenResultsModel  *resultModel;
@property (nonatomic, strong) UIButton       *cancelButton;
@property (nonatomic, strong) UIButton       *satisfiedButton;
@property (nonatomic, strong) UIButton       *notSatisfiedButton;
@property (nonatomic, strong) UIButton       *submitButton;
@property (nonatomic, strong) UILabel        *tipsLabel;
@property (nonatomic, strong) UILabel        *evaluationTitleLabel;
@property (nonatomic, strong) UILabel        *satisfiedLabel;
@property (nonatomic, strong) UILabel        *notSatisfiedLabel;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray  *selectList;

//动画
@property(nonatomic, strong) LOTAnimationView *animationView;

@end

@implementation ZXMapNavEvaluationView


- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self zx_reloadLayout];
    }
    return self;
}

#pragma mark - Private Method

//传入Model ，BoxId
- (void)zx_openResultsModel:(ZXOpenResultsModel *)openResultsModel{
    self.resultModel = openResultsModel;
    
//    self.resultModel.activityinfo = 0;
    
    
    //活动
    [self zx_hasActivityinfo];
}

//初始化UI
- (void)zx_reloadLayout{
    self.backgroundColor = WGGrayColor(255);
    [self wg_setRoundedCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) radius:16];
    
    //关闭按钮
    [self addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.width.offset(25);
    }];
    
    //标题
    [self addSubview:self.evaluationTitleLabel];
    [self.evaluationTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(24);
        make.left.mas_equalTo(self).offset(40);
        make.right.mas_equalTo(self.cancelButton.mas_left).offset(0);
        make.height.offset(20);
    }];
    
    //满意按钮
    [self addSubview:self.satisfiedButton];
    [self.satisfiedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.evaluationTitleLabel.mas_bottom).offset(30);
        make.centerX.mas_equalTo(self).offset(80);
        make.height.width.offset(50);
    }];
    
    //不满意按钮
    [self addSubview:self.notSatisfiedButton];
    [self.notSatisfiedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.satisfiedButton);
        make.centerX.mas_equalTo(self).offset(-80);
        make.height.width.offset(50);
    }];
    
    
    //满意文本
    [self addSubview:self.satisfiedLabel];
    [self.satisfiedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.satisfiedButton.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.satisfiedButton);
        make.height.offset(20);
        make.width.offset(50);
    }];
    
    
    //不满意文本
    [self addSubview:self.notSatisfiedLabel];
    [self.notSatisfiedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.satisfiedLabel);
        make.centerX.mas_equalTo(self.notSatisfiedButton);
        make.height.offset(20);
        make.width.offset(50);
    }];
    
    
    //提示文本
    [self addSubview:self.tipsLabel];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.satisfiedLabel.mas_bottom).offset(20);
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.height.offset(20);
    }];
    
    
    //动画
    self.animationView = [LOTAnimationView animationNamed:@"ActivityButton"];
    self.animationView.animationSpeed = 1.0f;
    self.animationView.loopAnimation = YES;
    self.animationView.hidden = YES;
    [self.animationView play];
    [self addSubview:self.animationView];
    [self.animationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-20);
        make.height.offset(55);
        make.width.offset(255);
    }];
    
    
    //提交评价
    [self addSubview:self.submitButton];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-20);
        make.height.offset(48);
        make.width.offset(250);
    }];
    [self layoutIfNeeded];
    [self.submitButton setTitleColor:WGGrayColor(255) forState:UIControlStateNormal];
    NSArray * colors = @[WGRGBAlpha(255, 89, 158, 1),WGRGBAlpha(255, 69, 69, 1)];
    [self.submitButton wg_backgroundGradientHorizontalColors:colors];
    
    
    
   
    
   //活动
    [self zx_hasActivityinfo];

    //collectionView
    [self addSubview: self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(50);
        make.right.equalTo(self.mas_right).offset(-50);
        make.bottom.mas_equalTo(self.submitButton.mas_top).offset(-25);
        make.top.mas_equalTo(self.tipsLabel.mas_bottom).offset(15);
    }];
}


#pragma mark - 按钮响应

//取消响应
- (void)cancelAction:(UIButton *)sender{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(mapNavEvaluationView: SelectorWithEvaluation:)]){
        [self.delegate mapNavEvaluationView:self SelectorWithEvaluation:sender];
    }
}

//满意按钮响应
- (void)satisfiedAction:(UIButton *)sender{
        
    self.satisfiedButton.selected = YES;
    self.notSatisfiedButton.selected = NO;
    self.tipsLabel.hidden = NO;
    self.tipsLabel.text = @"“感谢支持，我们会继续努力”";
    
    //collectionView
    self.collectionView.hidden = YES;
    for (int i = 0; i< self.selectList.count ;i++){
        ZXBlindBoxSelectViewItemlistModel *itemlistModel = [self.selectList wg_safeObjectAtIndex:i];
        itemlistModel.select = (i == 0) ? YES : NO;
    }
    [self.collectionView reloadData];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(mapNavEvaluationView: SelectorWithEvaluation:)]){
        [self.delegate mapNavEvaluationView:self SelectorWithEvaluation:self.satisfiedButton];
    }
    
}

//不满意按钮响应
- (void)notSatisfiedAction:(UIButton *)sender{
   
    self.notSatisfiedButton.selected = YES;
    self.satisfiedButton.selected = NO;
    self.tipsLabel.hidden = NO;
    self.tipsLabel.text = @"“体验不好，以下哪方面使您不满意”";
    self.submitButton.hidden = NO;
    
    //collectionView
    self.collectionView.hidden = NO;

    
    if(self.delegate && [self.delegate respondsToSelector:@selector(mapNavEvaluationView: SelectorWithEvaluation:)]){
        [self.delegate mapNavEvaluationView:self SelectorWithEvaluation:self.notSatisfiedButton];
    }
    
    //重新刷新UI
    [self zx_reloadLayout];
}


//提交评价响应
- (void)submitAction:(UIButton *)sender{
    
    if (self.satisfiedButton.selected){
        [self zx_reqApiEnjoyBox:@""];
    }else if (self.notSatisfiedButton.selected){
        
        NSString *str = @"";
        for (ZXBlindBoxSelectViewItemlistModel *itemlistModel in self.selectList){
            NSString *tempStr = (str.length) ? @"|" : @"";
            if (itemlistModel.select){
                str = [NSString stringWithFormat:@"%@%@%@",str,tempStr,itemlistModel.itemname];
            }
        }
        
        [self zx_reqApiEnjoyBox:str];
    }
    
}
 

//是否满意
- (void)zx_isSatisfied:(BOOL)isSatisfied{
    
    if (isSatisfied){
        [self satisfiedAction:self.satisfiedButton];
    }else{
        [self notSatisfiedAction:self.notSatisfiedButton];
    }
}

//如果有活动
- (void)zx_hasActivityinfo{
    //有活动
    if (self.resultModel.activityinfo){
       
        self.animationView.hidden = NO;
        
        //提交按钮
        self.submitButton.backgroundColor = UIColor.clearColor;
        [self.submitButton setTitle:@"" forState:UIControlStateNormal];
        [self.submitButton setTitleColor:UIColor.clearColor forState:UIControlStateNormal];
        [self layoutIfNeeded];
        NSArray * colors = @[UIColor.clearColor,UIColor.clearColor];
        [self.submitButton wg_backgroundGradientHorizontalColors:colors];
    }
}

#pragma mark - NetworkRequest
//评价盲盒
- (void)zx_reqApiEnjoyBox:(NSString *)contentStr{
    
    NSString *isLike = (self.satisfiedButton.selected) ? @"1" : @"2";
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict wg_safeSetObject:self.resultModel.boxid forKey:@"boxid"];
    [dict wg_safeSetObject:contentStr forKey:@"content"];
    [dict wg_safeSetObject:isLike forKey:@"islike"];
    
    [WGUIManager wg_showHUD];
    WEAKSELF;
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiEnjoyBox Parameter:dict success:^(NSDictionary * _Nonnull resultDic) {
        STRONGSELF;
        [WGUIManager wg_hideHUD];
        
        //关闭代理
        if(self.delegate && [self.delegate respondsToSelector:@selector(mapNavEvaluationView: SelectorWithEvaluation:)]){
            [self.delegate mapNavEvaluationView:self SelectorWithEvaluation:self.submitButton];
        }
        
        
      
        
    } failure:^(NSError * _Nonnull error) {
        [WGUIManager wg_hideHUD];
    }];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.selectList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ZXMineBoxDetailsEvaluationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ZXMineBoxDetailsEvaluationCollectionViewCell wg_cellIdentifier] forIndexPath:indexPath];
    
    ZXBlindBoxSelectViewItemlistModel *itemlistModel = [self.selectList wg_safeObjectAtIndex:indexPath.row];
    
    [cell zx_setBlindBoxSelectViewItemlistModel:itemlistModel];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZXBlindBoxSelectViewItemlistModel *itemlistModel = [self.selectList wg_safeObjectAtIndex:indexPath.row];
    
    itemlistModel.select = !itemlistModel.select;
    
    [collectionView reloadData];
}


#pragma mark - 懒加载

//关闭按钮
- (UIButton *)cancelButton{
    if (!_cancelButton){
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setImage:IMAGENAMED(@"close") forState:UIControlStateNormal];
        _cancelButton.tag = CancelButton;
        [_cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}


//满意按钮
- (UIButton *)satisfiedButton{
    if (!_satisfiedButton){
        _satisfiedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_satisfiedButton setImage:IMAGENAMED(@"Satisfied") forState:UIControlStateNormal];
        [_satisfiedButton setImage:IMAGENAMED(@"SatisfiedSelect") forState:UIControlStateSelected];
        _satisfiedButton.tag = SatisfiedButtonTag;
        [_satisfiedButton addTarget:self action:@selector(satisfiedAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _satisfiedButton;
}


//不满意按钮
- (UIButton *)notSatisfiedButton{
    if (!_notSatisfiedButton){
        _notSatisfiedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_notSatisfiedButton setImage:IMAGENAMED(@"notSatisfied") forState:UIControlStateNormal];
        [_notSatisfiedButton setImage:IMAGENAMED(@"notSatisfiedSelect") forState:UIControlStateSelected];
        _notSatisfiedButton.tag = NotSatisfiedButtonTag;
        [_notSatisfiedButton addTarget:self action:@selector(notSatisfiedAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _notSatisfiedButton;
}

//提交评价按钮
- (UIButton *)submitButton{
    if (!_submitButton){
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitButton wg_setLayerRoundedCornersWithRadius:24];
        _submitButton.layer.cornerRadius = 24;
        _submitButton.layer.masksToBounds = YES;
        
        _submitButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
        [_submitButton setTitle:@"提交评价" forState:UIControlStateNormal];
        [_submitButton setTitleColor:WGGrayColor(184) forState:UIControlStateNormal];
        _submitButton.backgroundColor = WGGrayColor(231);
        _submitButton.tag = SubmitButton;
        [_submitButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _submitButton;
}

//标题文本
- (UILabel *)evaluationTitleLabel{
    if (!_evaluationTitleLabel){
        _evaluationTitleLabel= [UILabel labelWithFont:kFontSemibold(16) TextAlignment:NSTextAlignmentCenter TextColor:UIColor.blackColor TextStr:@"您对此次盲盒的内容满意吗？" NumberOfLines:1];
    }
    return _evaluationTitleLabel;
}


//提示文本
- (UILabel *)tipsLabel{
    if (!_tipsLabel){
        _tipsLabel = [UILabel labelWithFont:kFontMedium(16) TextAlignment:NSTextAlignmentCenter TextColor:UIColor.blackColor TextStr:@"“感谢支持，我们会继续努力”" NumberOfLines:1];
        _tipsLabel.hidden = YES;
    }
    return _tipsLabel;
}

//满意文本
- (UILabel *)satisfiedLabel{
    if (!_satisfiedLabel){
        _satisfiedLabel = [UILabel labelWithFont:kFontMedium(15) TextAlignment:NSTextAlignmentCenter TextColor:UIColor.blackColor TextStr:@"满意" NumberOfLines:1];
    }
    return _satisfiedLabel;
}

//不满意文本
- (UILabel *)notSatisfiedLabel{
    if (!_notSatisfiedLabel){
        _notSatisfiedLabel = [UILabel labelWithFont:kFontMedium(15) TextAlignment:NSTextAlignmentCenter TextColor:UIColor.blackColor TextStr:@"不满意" NumberOfLines:1];
    }
    return _notSatisfiedLabel;
}

//collectionView
- (UICollectionView *)collectionView{
    if(!_collectionView){
        
        ZXCollectionViewLateralFlowLayout *layout = [[ZXCollectionViewLateralFlowLayout alloc] init];
        layout.size = CGSizeMake((self.mj_w - 100) / 2 -10 ,50);
        layout.row = 3;
        layout.column = 2;
        layout.columnSpacing = 10;
        layout.rowSpacing = 8;
        layout.pageWidth = self.mj_w - 100;

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.hidden = YES;
        
        [_collectionView registerClass:[ZXMineBoxDetailsEvaluationCollectionViewCell class] forCellWithReuseIdentifier:[ZXMineBoxDetailsEvaluationCollectionViewCell wg_cellIdentifier]];
    }
    return _collectionView;
}

-(NSMutableArray *)selectList{
    if (!_selectList){
        
        _selectList = [NSMutableArray array];
        
        NSArray *arr = @[@"以前来过",@"不喜欢这个地方",@"导航不清晰",@"太好猜",@"时间不准确",@"找不到店"];
        
        for (int i = 0; i< arr.count ;i++){
            
            NSString *str = [arr wg_safeObjectAtIndex:i];
            ZXBlindBoxSelectViewItemlistModel *itemlistModel = [ZXBlindBoxSelectViewItemlistModel new];
            itemlistModel.itemname = str;
            itemlistModel.select = (i == 0)? YES:NO;
            [_selectList wg_safeAddObject:itemlistModel];
        }

    }
    return _selectList;;
}


@end

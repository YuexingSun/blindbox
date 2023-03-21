//
//  ZXMineBoxDetailsEvaluationCell.m
//  ZXHY
//
//  Created by Bern Mac on 8/30/21.
//

#import "ZXMineBoxDetailsEvaluationCell.h"
#import "ZXOpenResultsModel.h"
#import "ZXCollectionViewLateralFlowLayout.h"
#import "ZXMineBoxDetailsEvaluationCollectionViewCell.h"
#import "ZXBlindBoxSelectViewModel.h"


@interface ZXMineBoxDetailsEvaluationCell ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UIView *evaluationView;
@property (nonatomic, strong)  UIImageView *backImageView;

@property (nonatomic, strong) UIButton *satisfiedButton;
@property (nonatomic, strong) UIButton *notSatisfiedButton;
@property (nonatomic, strong) UIButton *checkReviewsButton;
@property (nonatomic, strong) UIButton *submitButton;

@property (nonatomic, strong) UILabel *satisfiedLabel;
@property (nonatomic, strong) UILabel *notSatisfiedLabel;

@property (nonatomic, strong) UILabel  *satisfiedTipsLabel;

@property (nonatomic, strong) ZXOpenResultsModel *resultsModel;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray  *selectList;
@end

@implementation ZXMineBoxDetailsEvaluationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)wg_cellIdentifier{
    return @"ZXMineBoxDetailsEvaluationCellID";
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self initSubView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.backImageView.layer.cornerRadius = 8;
    self.backImageView.clipsToBounds = YES;
    
    self.evaluationView.clipsToBounds = NO;
    self.evaluationView.layer.shadowColor =  WGHEXAlpha(@"828282", 0.25).CGColor;
    self.evaluationView.layer.shadowOffset = CGSizeMake(0,4);
    self.evaluationView.layer.shadowRadius = 3;
    self.evaluationView.layer.shadowOpacity = 1;
}

- (void)initSubView{
    
    self.backgroundColor = UIColor.clearColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *evaluationView = [UIView new];
    evaluationView.backgroundColor = UIColor.clearColor;
    [self.contentView addSubview:evaluationView];
    [evaluationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(5);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-5);
        make.left.mas_equalTo(self.contentView).offset(15);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
    }];
    self.evaluationView = evaluationView;
   
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    backImageView.image = [UIImage imageNamed:@"otherLoginBack"];
    [evaluationView addSubview:backImageView];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(evaluationView);
    }];
    self.backImageView = backImageView;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.image = [UIImage imageNamed:@"EvaluationLuck"];
    [evaluationView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(evaluationView).offset(15);
        make.left.mas_equalTo(evaluationView).offset(15);
        make.width.offset(140);
        make.height.offset(22);
    }];
    
    
    UILabel *evaluationTitleLabel = [UILabel labelWithFont:kFontSemibold(16) TextAlignment:NSTextAlignmentLeft TextColor:UIColor.blackColor TextStr:@"您对此次盲盒的内容满意吗？" NumberOfLines:1];
    [evaluationView addSubview:evaluationTitleLabel];
    [evaluationTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageView.mas_bottom).offset(10);
        make.left.mas_equalTo(evaluationView).offset(15);
        make.right.mas_equalTo(evaluationView.mas_right).offset(-15);
        make.height.offset(20);
    }];
    
    
    UIButton *satisfiedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [satisfiedButton setImage:IMAGENAMED(@"Satisfied") forState:UIControlStateNormal];
    [satisfiedButton setImage:IMAGENAMED(@"SatisfiedSelect") forState:UIControlStateSelected];
    [satisfiedButton addTarget:self action:@selector(satisfiedAction:) forControlEvents:UIControlEventTouchUpInside];
    [evaluationView addSubview:satisfiedButton];
    [satisfiedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(evaluationTitleLabel.mas_bottom).offset(25);
        make.centerX.mas_equalTo(evaluationView).offset(80);
        make.height.width.offset(50);
    }];
    self.satisfiedButton = satisfiedButton;


    UIButton *notSatisfiedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [notSatisfiedButton setImage:IMAGENAMED(@"notSatisfied") forState:UIControlStateNormal];
    [notSatisfiedButton setImage:IMAGENAMED(@"notSatisfiedSelect") forState:UIControlStateSelected];
    [notSatisfiedButton addTarget:self action:@selector(notSatisfiedAction:) forControlEvents:UIControlEventTouchUpInside];
    [evaluationView addSubview:notSatisfiedButton];
    [notSatisfiedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(satisfiedButton);
        make.centerX.mas_equalTo(evaluationView).offset(-80);
        make.height.width.offset(50);
    }];
    self.notSatisfiedButton = notSatisfiedButton;
    
    
    UILabel *satisfiedLabel = [UILabel labelWithFont:kFontMedium(15) TextAlignment:NSTextAlignmentCenter TextColor:UIColor.blackColor TextStr:@"满意" NumberOfLines:1];
    [evaluationView addSubview:satisfiedLabel];
    [satisfiedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(satisfiedButton.mas_bottom).offset(10);
        make.centerX.mas_equalTo(satisfiedButton);
        make.height.offset(20);
        make.width.offset(50);
    }];
    self.satisfiedLabel = satisfiedLabel;
    
    
    
    UILabel *notSatisfiedLabel = [UILabel labelWithFont:kFontMedium(15) TextAlignment:NSTextAlignmentCenter TextColor:UIColor.blackColor TextStr:@"不满意" NumberOfLines:1];
    [evaluationView addSubview:notSatisfiedLabel];
    [notSatisfiedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(satisfiedLabel);
        make.centerX.mas_equalTo(notSatisfiedButton);
        make.height.offset(20);
        make.width.offset(50);
    }];
    self.notSatisfiedLabel = notSatisfiedLabel;
    
    
    
    //=====================================//
    
    //满意提示文本
    self.satisfiedTipsLabel = [UILabel labelWithFont:kFontMedium(16) TextAlignment:NSTextAlignmentCenter TextColor:UIColor.blackColor TextStr:@"“感谢支持，我们会继续努力”" NumberOfLines:1];
    [evaluationView addSubview:self.satisfiedTipsLabel];
    [self.satisfiedTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(satisfiedLabel.mas_bottom).offset(25);
        make.left.mas_equalTo(evaluationView.mas_left).offset(10);
        make.right.mas_equalTo(evaluationView.mas_right).offset(-10);
        make.height.offset(20);
    }];
    self.satisfiedTipsLabel.hidden = YES;
    
    
    
    //不满意查看评价
    self.checkReviewsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.checkReviewsButton.titleLabel.font = kFont(15);
    [self.checkReviewsButton setTitle:@"查看评价" forState:UIControlStateNormal];
    [self.checkReviewsButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [self.checkReviewsButton setImage:IMAGENAMED(@"down") forState:UIControlStateNormal];
    [self.checkReviewsButton addTarget:self action:@selector(checkReviewsAction:) forControlEvents:UIControlEventTouchUpInside];
    self.checkReviewsButton.hidden = YES;
    [evaluationView addSubview:self.checkReviewsButton];
    [self.checkReviewsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(evaluationView.mas_bottom).offset(-20);
        make.left.mas_equalTo(evaluationView.mas_left).offset(10);
        make.right.mas_equalTo(evaluationView.mas_right).offset(-10);
        make.height.offset(20);
    }];
    [self.checkReviewsButton wg_setImagePosition:WGImagePositionStyleRight spacing:3];
    
    
    //提交评价
    self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    [ self.submitButton setTitle:@"提交评价" forState:UIControlStateNormal];
    [ self.submitButton setTitleColor:WGGrayColor(255) forState:UIControlStateNormal];
    [ self.submitButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    self.submitButton.hidden = YES;
    [evaluationView addSubview:self.submitButton];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(evaluationView);
        make.bottom.mas_equalTo(evaluationView.mas_bottom).offset(-20);
        make.height.offset(48);
        make.width.offset(255);
    }];
    [self.submitButton layoutIfNeeded];
    NSArray * colors = @[WGRGBAlpha(248, 110, 151, 1),WGRGBAlpha(235, 83, 83, 1)];
    [self.submitButton wg_backgroundGradientHorizontalColors:colors];
    [self.submitButton wg_setLayerRoundedCornersWithRadius:24];
    
    
    
    //不满意选择
    self.collectionView.hidden = YES;
    [evaluationView addSubview: self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(evaluationView.mas_left).offset(50);
        make.right.equalTo(evaluationView.mas_right).offset(-50);
        make.bottom.mas_equalTo(evaluationView.mas_bottom).offset(-70);
        make.top.mas_equalTo(satisfiedLabel.mas_bottom).offset(60);
    }];
   
}


//数据赋值
- (void)zx_dataWithMineBoxResultsModel:(ZXOpenResultsModel *)resultsModel{
    
    self.resultsModel = resultsModel;
   
    if (resultsModel.islike == 0){

        self.notSatisfiedButton.userInteractionEnabled = YES;
        self.satisfiedButton.userInteractionEnabled = YES;
        
    }else{
        
        [self zx_reloadUI];
        
    }
    
}


//按钮布局
- (void)zx_reloadUI{
    
    self.notSatisfiedButton.userInteractionEnabled = NO;
    self.satisfiedButton.userInteractionEnabled = NO;
    

    if (self.resultsModel.islike == 1){
        
        self.notSatisfiedButton.selected = NO;
        self.satisfiedButton.selected = YES;
        self.satisfiedTipsLabel.hidden = NO;
        self.notSatisfiedButton.hidden = YES;
        self.satisfiedButton.hidden = NO;
        self.notSatisfiedLabel.hidden = YES;
        self.checkReviewsButton.hidden = YES;
        self.submitButton.hidden = YES;
        
        [self.satisfiedButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.evaluationView);
        }];
        
    }else if (self.resultsModel.islike == 2){
        
        self.notSatisfiedButton.selected = YES;
        self.satisfiedButton.selected = NO;
        self.satisfiedTipsLabel.hidden = YES;
        self.satisfiedButton.hidden = YES;
        self.notSatisfiedButton.hidden = NO;
        self.satisfiedLabel.hidden = YES;
       
        self.submitButton.hidden = YES;
        self.collectionView.hidden = NO;
        
        [self.notSatisfiedButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.evaluationView);
        }];
        
        
        if (self.resultsModel.mycommentlist.count){
            self.checkReviewsButton.hidden = NO;
            self.selectList = [NSMutableArray array];
            for (int i = 0; i< self.resultsModel.mycommentlist.count ;i++){
                NSString *str = [self.resultsModel.mycommentlist wg_safeObjectAtIndex:i];
                ZXBlindBoxSelectViewItemlistModel *itemlistModel = [ZXBlindBoxSelectViewItemlistModel new];
                itemlistModel.itemname = str;
                itemlistModel.select = NO;
                [self.selectList wg_safeAddObject:itemlistModel];
            }
            [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.satisfiedLabel.mas_bottom).offset(20);
            }];
            [self.collectionView reloadData];
            
        }else{
            self.checkReviewsButton.hidden = YES;
            self.checkReviewsButton.hidden = YES;
            self.satisfiedButton.selected = NO;
            self.satisfiedTipsLabel.hidden = NO;
            self.satisfiedTipsLabel.text = @"“体验不好，以下哪方面使您不满意”";
            self.submitButton.hidden = NO;
        }

        
    }
   
    
}

#pragma mark - Private Method

//满意按钮响应
- (void)satisfiedAction:(UIButton *)sender{
        
    sender.selected = YES;
    self.notSatisfiedButton.selected = NO;
    self.satisfiedTipsLabel.hidden = NO;
    self.satisfiedTipsLabel.text = @"“感谢支持，我们会继续努力”";
    self.submitButton.hidden = NO;
    self.collectionView.hidden = YES;
    
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(satisfied:)]){
        [self.delegate satisfied:self];
    }
}

//不满意按钮响应
- (void)notSatisfiedAction:(UIButton *)sender{
    
    sender.selected = YES;
    self.checkReviewsButton.hidden = YES;
    self.satisfiedButton.selected = NO;
    self.satisfiedTipsLabel.hidden = NO;
    self.satisfiedTipsLabel.text = @"“体验不好，以下哪方面使您不满意”";
    self.submitButton.hidden = NO;
    self.collectionView.hidden = NO;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(notSatisfied:)]){
        [self.delegate notSatisfied:self];
    }
}

//提交评价响应
- (void)submitAction:(UIButton *)sender{
    
    if (self.satisfiedButton.selected){
        [self zx_reqApiEnjoyBox:@""];
    }else{
        
        NSString *str = @"";
        for (ZXBlindBoxSelectViewItemlistModel *itemlistModel in self.selectList){
            
            if (itemlistModel.select){
                NSString *tempStr = (str.length) ? @"|" : @"";
                str = [NSString stringWithFormat:@"%@%@%@",str,tempStr,itemlistModel.itemname];
            }
        }
        
        [self zx_reqApiEnjoyBox:str];
    }
    
}


//查看评价按钮响应
- (void)checkReviewsAction:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    
    if (sender.selected){
        [self.checkReviewsButton setTitle:@"收起评价" forState:UIControlStateNormal];
        [self.checkReviewsButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [self.checkReviewsButton setImage:IMAGENAMED(@"up") forState:UIControlStateNormal];
    }else{
        [self.checkReviewsButton setTitle:@"查看评价" forState:UIControlStateNormal];
        [self.checkReviewsButton setImage:IMAGENAMED(@"down") forState:UIControlStateNormal];
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(checkReviewButton:WithCell:)]){
        [self.delegate checkReviewButton:sender WithCell:self];
    }
        
}


#pragma mark - NetworkRequest
//评价盲盒
- (void)zx_reqApiEnjoyBox:(NSString *)islike{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict wg_safeSetObject:self.resultsModel.boxid forKey:@"boxid"];
    [dict wg_safeSetObject:islike forKey:@"content"];
    
    [WGUIManager wg_showHUD];
    WEAKSELF;
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiEnjoyBox Parameter:dict success:^(NSDictionary * _Nonnull resultDic) {
        STRONGSELF;
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(completeEvaluationReload:)]){
            [self.delegate completeEvaluationReload:self];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
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
    
    if (self.resultsModel.status == 3) return;
    
    ZXBlindBoxSelectViewItemlistModel *itemlistModel = [self.selectList wg_safeObjectAtIndex:indexPath.row];
    
    itemlistModel.select = !itemlistModel.select;
    
    [collectionView reloadData];
}

#pragma mark - lazy
- (UICollectionView *)collectionView{
    if(!_collectionView){
        
        ZXCollectionViewLateralFlowLayout *layout = [[ZXCollectionViewLateralFlowLayout alloc] init];
        layout.size =   CGSizeMake((WGNumScreenWidth() - 130 )/2 - 10, 50);
        layout.row = 3;
        layout.column = 2;
        layout.columnSpacing = 10;
        layout.rowSpacing = 8;
        layout.pageWidth = WGNumScreenWidth() - 130;

        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
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

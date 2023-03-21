//
//  ZXMapNavResultGreenHeaderCell.m
//  ZXHY
//
//  Created by Bern Lin on 2021/12/2.
//

#import "ZXMapNavResultGreenHeaderCell.h"
#import "ZXReachedNumView.h"
#import <Lottie/Lottie.h>
#import "ZXOpenResultsModel.h"
#import "ZXMapNavHelpView.h"
#import "ZXMapNavManager.h"

@interface ZXMapNavResultGreenHeaderCell ()
<ZXMapNavHelpViewDelegate>

@property (nonatomic, strong) ZXOpenResultsModel *openResultsModel;

@property (nonatomic, strong) UILabel  *titleLabel;
@property (nonatomic, strong) UILabel  *loctionLabel;
@property(nonatomic, strong) LOTAnimationView *animationView;//动画
@property (nonatomic, strong) UIButton  *goOnButton;
@property (nonatomic, strong) UILabel  *infoLabel;
@property (nonatomic, strong) ZXReachedNumView *reachedView;//来过人数View

@property (nonatomic, strong) WGGeneralSheetController *sheetVc;
@end


@implementation ZXMapNavResultGreenHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)wg_cellIdentifier{
    return @"ZXMapNavResultGreenHeaderCellID";
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
    
    UILabel *tipsLabel = [UILabel labelWithFont:kFont(15) TextAlignment:NSTextAlignmentLeft TextColor:UIColor.whiteColor TextStr:@"将要到达目的地" NumberOfLines:1];
    [self.contentView addSubview:tipsLabel];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(10);
        make.left.mas_equalTo(self.contentView).offset(30);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-30);
        make.height.offset(20);
    }];
    
    //地点
    self.titleLabel = [UILabel labelWithFont:kFontSemibold(22) TextAlignment:NSTextAlignmentLeft TextColor:UIColor.whiteColor TextStr:@"悦行咖啡" NumberOfLines:3];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tipsLabel.mas_bottom).offset(20);
        make.left.right.mas_equalTo(tipsLabel);
    }];
    
    //位置logo
    UIImageView *locationLogo = [UIImageView wg_imageViewWithImageNamed:@"navResultLocation"];
    [self.contentView addSubview:locationLogo];
    [locationLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(tipsLabel);
        make.width.height.offset(20);
    }];
    
    //电话logo按钮
    UIButton *mobButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [mobButton setBackgroundImage:IMAGENAMED(@"navResultMob") forState:UIControlStateNormal];
    [mobButton addTarget:self action:@selector(mobAction:) forControlEvents:UIControlEventTouchUpInside];
    mobButton.hidden = YES;
    [self.contentView addSubview:mobButton];
    [mobButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(locationLogo);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
        make.width.height.offset(1);
    }];
    
    //位置文本
    self.loctionLabel = [UILabel labelWithFont:kFontMedium(16) TextAlignment:NSTextAlignmentLeft TextColor:WGRGBAlpha(255, 255, 255, 0.8) TextStr:@"天河南一路24号自编8号36铺" NumberOfLines:0];
    [self.contentView addSubview:self.loctionLabel];
    [self.loctionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(locationLogo);
        make.left.mas_equalTo(locationLogo.mas_right).offset(8);
        make.right.mas_equalTo(mobButton.mas_left).offset(-10);
    }];
    
    //分割线
    UIView *lineVeiw = [UIView new];
    lineVeiw.backgroundColor = UIColor.clearColor;
//    WGRGBAlpha(255, 255, 255, 0.2);
    [self.contentView addSubview:lineVeiw];
    [lineVeiw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.loctionLabel.mas_bottom).offset(25);
        make.left.mas_equalTo(self.contentView.mas_left).offset(35);
        make.right.mas_equalTo(self.contentView);
        make.height.offset(1);
    }];
    
    //动画
    self.animationView = [LOTAnimationView animationNamed:@"complete"];
    self.animationView.animationSpeed = 1.0f;
    self.animationView.loopAnimation = NO;
    [self.animationView play];
    [self.contentView addSubview:self.animationView];
    [self.animationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineVeiw.mas_bottom).offset(10);
        make.centerX.equalTo(self.contentView);
        make.width.height.offset(WGNumScreenWidth() - 60);
    }];
    
    //剩余距离提醒
//    UILabel *remainderLabel = [UILabel labelWithFont:kFont(18) TextAlignment:NSTextAlignmentCenter TextColor:UIColor.whiteColor TextStr:@"距离目的地仅剩 120 米" NumberOfLines:1];
//    [self.contentView addSubview:remainderLabel];
//    [remainderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.animationView.mas_bottom).offset(5);
//        make.left.right.mas_equalTo(tipsLabel);
//        make.height.offset(20);
//    }];
    
    //继续导航
//    self.goOnButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.goOnButton setBackgroundImage:IMAGENAMED(@"navHelp")  forState:UIControlStateNormal];
//    [self.goOnButton addTarget:self action:@selector(goonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:self.goOnButton];
//    [self.goOnButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(remainderLabel.mas_bottom).offset(15);
//        make.centerX.mas_equalTo(self.contentView);
//        make.width.offset(155);
//        make.height.offset(48);
//    }];
    
    
    //文案文本
    self.infoLabel = [UILabel labelWithFont:kFontMedium(18) TextAlignment:NSTextAlignmentLeft TextColor:UIColor.whiteColor TextStr:@"忽悠文案，忽悠文案忽悠文案。壹贰叁肆伍陆柒捌玖拾，壹贰叁肆伍陆柒捌玖拾。壹贰叁肆伍陆柒捌玖拾。" NumberOfLines:0];
    [self.contentView addSubview: self.infoLabel];
    [ self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(tipsLabel);
        make.top.mas_equalTo(self.animationView.mas_bottom).offset(30);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-15);
    }];
    
    //来过人数View
//    self.reachedView  = [ZXReachedNumView new];
//    [self.contentView addSubview:self.reachedView ];
//    [self.reachedView  mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.infoLabel.mas_bottom).offset(15);
//        make.right.mas_equalTo(self.contentView);
//        make.left.mas_equalTo(self.contentView).offset(10);
//        make.height.offset(70);
//    }];
  
}


#pragma mark - ZXMapNavHelpViewDelegate
- (void)zx_navHelpView:(ZXMapNavHelpView *)helpView NavHelpType:(NavHelpType)navHelpType{
    [self.sheetVc dissmisSheetVcCompletion:^{
        if (navHelpType == NavHelpType_OtherNav){
            CLLocationCoordinate2D startCllo = CLLocationCoordinate2DMake(self.openResultsModel.startPoint.latitude, self.openResultsModel.startPoint.longitude);
            
            CLLocationCoordinate2D endCllo = CLLocationCoordinate2DMake([self.openResultsModel.lnglat.lat floatValue] ,[self.openResultsModel.lnglat.lng floatValue]);

            UIAlertController *actionSheet = [ZXMapNavManager  getInstalledMapAppWithEndLocation:endCllo currentLocation:startCllo];
            [[WGUIManager wg_topViewController] presentViewController:actionSheet animated:YES completion:nil];
        }
        else if (navHelpType == NavHelpType_Call){
            [self mobAction:[UIButton new]];
        }
    }];
}

#pragma mark - Private Method
//电话按钮响应
- (void)mobAction:(UIButton *)sender{
    if (kObjectIsEmpty(self.openResultsModel)) return;
    
    NSArray *currentArr = [NSArray array];
    if ([self.openResultsModel.mob containsString: @","]){
        currentArr = [self.openResultsModel.mob componentsSeparatedByString:@","];
    } else if ([self.openResultsModel.mob containsString: @"，"]){
        currentArr = [self.openResultsModel.mob componentsSeparatedByString:@"，"];
    }
    
    
    if (!currentArr.count){
        
        NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.openResultsModel.mob];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
    } else {
        
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        for (NSString *str in currentArr){
            
            NSMutableString* telStr=[[NSMutableString alloc] initWithFormat:@"tel:%@",str];
            
            UIAlertAction *mobAction = [UIAlertAction actionWithTitle:str style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telStr]];
            }];
            
            [actionSheet addAction:mobAction];
        }
        //取消
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

            [actionSheet dismissViewControllerAnimated:YES completion:nil];

        }];
        [actionSheet addAction:actionCancel];
         
        [[WGUIManager wg_topViewController] presentViewController:actionSheet animated:YES completion:nil];
    }
   
    
}


//继续导航响应
- (void)goonAction:(UIButton *)sender{
    if (kObjectIsEmpty(self.openResultsModel)) return;;
    
    ZXMapNavHelpView *view = [[ZXMapNavHelpView alloc] initWithFrame:CGRectMake(0, 0, WGNumScreenWidth(), 480)];
    view.delegate = self;
    [view zx_openResultsModel:self.openResultsModel];
    self.sheetVc = [WGGeneralSheetController  sheetControllerWithCustomView:view];
    [self.sheetVc showToCurrentVc];
}


//数据
- (void)zx_openResultsModel:(ZXOpenResultsModel *)openResultsModel{
    self.openResultsModel = openResultsModel;
    if (kObjectIsEmpty(self.openResultsModel)) return;;
    
    self.titleLabel.text = self.openResultsModel.realname;
    self.loctionLabel.text = self.openResultsModel.address;
    
    self.infoLabel.text = self.openResultsModel.arrivedtext;
    [self zx_attributedText];
    
//    [self.reachedView zx_fitGreenViewOpenResultsModel:self.openResultsModel];
    
}

//遍历特殊文本
- (void)zx_attributedText{
    
    NSString *mainStr = self.openResultsModel.arrivedtext;

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:mainStr];
    
    for (int i = 0; i < self.openResultsModel.arrivedvarlist.count; i++){
        
        NSString *placeStr =  [NSString stringWithFormat:@" %@ ",[self.openResultsModel.arrivedvarlist wg_safeObjectAtIndex:i]];
        
        NSString *str = [NSString stringWithFormat:@"{{SJTL%d}}",i + 1];
        
        if ([mainStr containsString:str]){
           
            NSRange range = [[attributedString string] rangeOfString:str];
            [attributedString addAttribute:NSForegroundColorAttributeName value:WGHEXColor(self.openResultsModel.colorlist.textcolor) range:range];
            [attributedString addAttribute:NSFontAttributeName value:kFontSemibold(18) range:range];
            [attributedString replaceCharactersInRange:range withString:placeStr];
            
        }
        
    }
    self.infoLabel.attributedText = attributedString;
    
}

@end

//
//  ZXReachedNumView.m
//  ZXHY
//
//  Created by Bern Mac on 8/26/21.
//

#import "ZXReachedNumView.h"
#import "ZXOpenResultsModel.h"


@interface ZXReachedNumView()

@property (nonatomic, strong) UILabel  *reachedNumLabel;

@property (nonatomic, strong) ZXOpenResultsModel  *openResultsModel;

@end

@implementation ZXReachedNumView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        self.backgroundColor = UIColor.clearColor;
        
    }
    return self;
}


#pragma mark - 数据传入
//适配旧版导航结果页面
- (void)zx_resultsheaderViewOpenResultsModel:(ZXOpenResultsModel *)openResultsModel{
    self.openResultsModel = openResultsModel;
    [self zx_setUI];
}


//适配绿色导航结果页面
- (void)zx_fitGreenViewOpenResultsModel:(ZXOpenResultsModel *)openResultsModel{
    self.openResultsModel = openResultsModel;
    [self zx_setGreenUI];
}


//适配首页详情页面
- (void)zx_homeDetailsViewWithImageUrlList:(NSMutableArray *)imgList{

    [self zx_setHomeDetailsUI:imgList];
}


#pragma mark - 适配旧版导航结果页面
- (void)zx_setUI{
    
   
//    self.layer.cornerRadius = 5;
    
    NSInteger count = 5;
    
    if ( self.openResultsModel.gotlist.count >= 5){
        count = 5;
    }else{
        count = self.openResultsModel.gotlist.count;
    }
    
    NSMutableArray * xList = [NSMutableArray array];
    for (int i = 0 ; i < count; i++){
        NSInteger x =  (20 + 28 *i);
        [xList wg_safeAddObject:@(x)];
    }
    
    for (NSInteger i = xList.count - 1 ; i >= 0 ; i--){
        UIImageView *imageView = [UIImageView wg_imageViewWithImageNamed:@""];
        imageView.backgroundColor = UIColor.whiteColor;
        NSString *imageStr =  [self.openResultsModel.gotlist wg_safeObjectAtIndex:i];
        [imageView wg_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:nil];
        
        [self addSubview:imageView];
        NSInteger x = [[xList wg_safeObjectAtIndex:i] intValue];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.left.mas_equalTo(x);
            make.height.width.offset(36);
        }];
        
        [imageView layoutIfNeeded];
        imageView.layer.cornerRadius = 18;
        imageView.layer.masksToBounds = YES;
        [imageView wg_setBorderColor:WGRGBColor(112, 0, 255) borderWidth:1];
       
    }
    

    
    
    //多少人来过
    NSString *numStr = [NSString stringWithFormat:@"共 %@ 人来过",self.openResultsModel.gotnum];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:numStr];
    NSRange range = [[attributedString string] rangeOfString:self.openResultsModel.gotnum];
    [attributedString addAttribute:NSForegroundColorAttributeName value:WGRGBColor(255, 57, 152) range:range];
    
    self.reachedNumLabel = [UILabel labelWithFont:kFontMedium(14) TextAlignment:NSTextAlignmentLeft TextColor:kMainTitleColor TextStr:numStr NumberOfLines:1];
    self.reachedNumLabel.attributedText = attributedString;
    
    [self addSubview:self.reachedNumLabel];
    NSInteger x = [[xList wg_safeObjectAtIndex:xList.count - 1] intValue];
    [self.reachedNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(x + 32 + 15);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.height.offset(20);
    }];
}


#pragma mark - 适配绿色导航结果页面
- (void)zx_setGreenUI{
    
 
    NSInteger count = 5;
    
    if ( self.openResultsModel.gotlist.count >= 5){
        count = 5;
    }else{
        count = self.openResultsModel.gotlist.count;
    }
    
    NSMutableArray * xList = [NSMutableArray array];
    for (int i = 0 ; i < count; i++){
        NSInteger x =  (20 + 28 *i);
        [xList wg_safeAddObject:@(x)];
    }
    
    for (NSInteger i = xList.count - 1 ; i >= 0 ; i--){
        UIImageView *imageView = [UIImageView wg_imageViewWithImageNamed:@""];
        imageView.backgroundColor = UIColor.whiteColor;
        NSString *imageStr =  [self.openResultsModel.gotlist wg_safeObjectAtIndex:i];
        [imageView wg_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:nil];
        
        [self addSubview:imageView];
        NSInteger x = [[xList wg_safeObjectAtIndex:i] intValue];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.left.mas_equalTo(x);
            make.height.width.offset(36);
        }];
        
        [imageView layoutIfNeeded];
        imageView.layer.cornerRadius = 18;
        imageView.layer.masksToBounds = YES;

       
    }
    
    //多少人来过
    NSString *numStr = [NSString stringWithFormat:@"共 %@ 人来过",self.openResultsModel.gotnum];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:numStr];
    NSRange range = [[attributedString string] rangeOfString:self.openResultsModel.gotnum];
    [attributedString addAttribute:NSFontAttributeName value:kFontMedium(14) range:range];
    
    self.reachedNumLabel = [UILabel labelWithFont:kFont(14) TextAlignment:NSTextAlignmentLeft TextColor:UIColor.whiteColor TextStr:numStr NumberOfLines:1];
    self.reachedNumLabel.attributedText = attributedString;
    
    [self addSubview:self.reachedNumLabel];
    NSInteger x = [[xList wg_safeObjectAtIndex:xList.count - 1] intValue];
    [self.reachedNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(x + 32 + 15);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.height.offset(20);
    }];
}


#pragma mark - 适配首页详情页面
- (void)zx_setHomeDetailsUI:(NSMutableArray *)imgList{
    
    NSInteger count = 5;
    
   
    
    NSMutableArray * xList = [NSMutableArray array];
    for (int i = 0 ; i < count; i++){
        NSInteger x =  (20 + 17 *i);
        [xList wg_safeAddObject:@(x)];
    }
    
    for (NSInteger i = xList.count - 1 ; i >= 0 ; i--){
      
        UIImageView *imageView = [UIImageView wg_imageViewWithImageNamed:@""];
        imageView.backgroundColor = UIColor.lightGrayColor;
        NSString *imageStr =  [self.openResultsModel.gotlist wg_safeObjectAtIndex:i];
        [imageView wg_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:nil];
        
        [self addSubview:imageView];
        NSInteger x = [[xList wg_safeObjectAtIndex:i] intValue];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.left.mas_equalTo(x);
            make.height.width.offset(21);
        }];
        
//        [imageView layoutIfNeeded];
        imageView.layer.cornerRadius = 10.5f;
        imageView.layer.masksToBounds = YES;
        [imageView wg_setBorderColor:WGRGBColor(255, 255, 255) borderWidth:1.5];
        
        NSString *str = [imgList wg_safeObjectAtIndex:i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:IMAGENAMED(@"placeholderImage")];
       
    }
    


}

@end

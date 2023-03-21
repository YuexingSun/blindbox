//
//  ZXHomeDetailsBottomView.m
//  ZXHY
//
//  Created by Bern Lin on 2021/12/22.
//

#import "ZXHomeDetailsBottomView.h"
#import "ZXHomeModel.h"
#import "ZXHomeManager.h"
#import "ZXHomeTableViewCell.h"


@interface ZXHomeDetailsBottomView()

@property (nonatomic, strong) UIButton  *likeButton;
@property (nonatomic, strong)  UILabel *likeLabel;
@property (nonatomic, strong) UIButton *collectionButton;
@property (nonatomic, strong) UILabel *collectionLabel;
@property (nonatomic, strong) UIButton *commentsButton;
@property (nonatomic, strong) UILabel *commentsLabel;
@property (nonatomic, strong) UIButton  *remarkButton;
@property (nonatomic, strong) ZXHomeListModel *listModel;


@end

@implementation ZXHomeDetailsBottomView


- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        
        [self setupUI];
        
       
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.remarkButton.layer.cornerRadius = 18;
    self.remarkButton.layer.masksToBounds = YES;
    self.remarkButton.layer.borderColor = WGGrayColor(238).CGColor;
    self.remarkButton.layer.borderWidth = 1.5f;
    
}


#pragma mark - Initialization UI

- (void)setupUI{
    
    self.backgroundColor = WGGrayColor(248);
    
    CGFloat top = IS_IPHONE_X_SER ? 14 : 17;
    CGFloat WH = IS_IPHONE_X_SER ? 35 : 30;
    
    //点赞
    UIButton *likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    likeButton.adjustsImageWhenHighlighted = NO;
    [likeButton setImage:IMAGENAMED(@"homeLike") forState:UIControlStateNormal];
    [likeButton setImage:IMAGENAMED(@"homeLikeSelect") forState:UIControlStateSelected];
    [likeButton addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:likeButton];
    [likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.top.mas_equalTo(self.mas_top).offset(top);
        make.width.height.offset(WH);
    }];
    self.likeButton = likeButton;
    
    //点赞文本
    UILabel *likeLabel = [UILabel labelWithFont:kFontSemibold(14) TextAlignment:NSTextAlignmentLeft TextColor:WGGrayColor(153) TextStr:@"192" NumberOfLines:1];
    [self addSubview:likeLabel];
    [likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(likeButton);
        make.left.mas_equalTo(likeButton.mas_right).offset(8);
    }];
    self.likeLabel = likeLabel;
    
    
    //收藏
    UIButton *collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    collectionButton.adjustsImageWhenHighlighted = NO;
    [collectionButton setImage:IMAGENAMED(@"homeCollection") forState:UIControlStateNormal];
    [collectionButton setImage:IMAGENAMED(@"homeCollectionSelect") forState:UIControlStateSelected];
    [collectionButton addTarget:self action:@selector(collectionAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:collectionButton];
    [collectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(likeLabel.mas_right).offset(10);
        make.centerY.mas_equalTo(likeButton);
        make.width.height.offset(WH);
    }];
    self.collectionButton = collectionButton;
    
    //收藏文本
    UILabel *collectionLabel = [UILabel labelWithFont:kFontSemibold(14) TextAlignment:NSTextAlignmentLeft TextColor:WGGrayColor(153) TextStr:@"92" NumberOfLines:1];
    [self addSubview:collectionLabel];
    [collectionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(collectionButton);
        make.left.mas_equalTo(collectionButton.mas_right).offset(5);
    }];
    self.collectionLabel = collectionLabel;
    
    
    //评论
    UIButton *commentsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commentsButton.adjustsImageWhenHighlighted = NO;
    [commentsButton setImage:IMAGENAMED(@"comments") forState:UIControlStateNormal];
    [commentsButton addTarget:self action:@selector(commentsAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:commentsButton];
    [commentsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(collectionLabel.mas_right).offset(10);
        make.centerY.mas_equalTo(likeButton);
        make.width.height.offset(WH);
    }];
    self.commentsButton = commentsButton;
    
    //评论文本
    UILabel *commentsLabel = [UILabel labelWithFont:kFontSemibold(14) TextAlignment:NSTextAlignmentLeft TextColor:WGGrayColor(153) TextStr:@"92" NumberOfLines:1];
    [self addSubview:commentsLabel];
    [commentsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(commentsButton);
        make.left.mas_equalTo(commentsButton.mas_right).offset(5);
    }];
    self.commentsLabel = commentsLabel;
    
    
    //发言
    self.remarkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.remarkButton.backgroundColor = UIColor.whiteColor;
    self.remarkButton.adjustsImageWhenHighlighted = NO;
    self.remarkButton.titleLabel.font = kFontMedium(12);
    self.remarkButton.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 51);
    [self.remarkButton setTitle:@"讲两句？" forState:UIControlStateNormal];
    [self.remarkButton setTitleColor:WGGrayColor(221) forState:UIControlStateNormal];
    [self.remarkButton addTarget:self action:@selector(remarkAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.remarkButton];
    [self.remarkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(likeButton);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.width.offset(120);
        make.height.offset(36);
    }];
    
    
    //line
    UIView *lineView = [UIView new];
    lineView.backgroundColor = WGGrayColor(221);
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.mas_equalTo(self);
        make.height.offset(1);
    }];
    
    
    
}


#pragma mark - Private Method
//点赞响应
- (void)likeAction:(UIButton *)sender{
    
    WEAKSELF;
    [ZXHomeManager zx_reqApiInfomationLikeArticleWithNoteId:self.listModel.typeId SuccessBlock:^(NSDictionary * _Nonnull dic) {
        STRONGSELF;
        
        self.listModel.isliked = !self.listModel.isliked;
        if (self.listModel.isliked){
            self.listModel.likenumber = [NSString stringWithFormat:@"%d",[self.listModel.likenumber intValue] + 1];
        }else{
            self.listModel.likenumber = [NSString stringWithFormat:@"%d",[self.listModel.likenumber intValue] - 1];
        }
        
        [self zx_setListModel:self.listModel];
        
    } ErrorBlock:^(NSError * _Nonnull error) {
        
    }];
}

//收藏响应
- (void)collectionAction:(UIButton *)sender{
    
    WEAKSELF;
    [ZXHomeManager zx_reqApiInfomationLikeFavArticleWithNoteId:self.listModel.typeId SuccessBlock:^(NSDictionary * _Nonnull dic) {
        STRONGSELF;
        
        self.listModel.isfaved = !self.listModel.isfaved;
        
        if (self.listModel.isfaved){
            self.listModel.favnumber = [NSString stringWithFormat:@"%d",[self.listModel.favnumber intValue] + 1];
        }else{
            self.listModel.favnumber = [NSString stringWithFormat:@"%d",[self.listModel.favnumber intValue] - 1];
        }
        
        [self zx_setListModel:self.listModel];
        
    } ErrorBlock:^(NSError * _Nonnull error) {
        
    }];
}

//评论响应
- (void)commentsAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(zx_commentsDetailsBottomView:)]){
        [self.delegate zx_commentsDetailsBottomView:self];
    }
}

//讲俩句
- (void)remarkAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(zx_remarkCommentsDetailsBottomView:)]){
        [self.delegate zx_remarkCommentsDetailsBottomView:self];
    }
}


//数据接入
- (void)zx_setListModel:(ZXHomeListModel *)listModel{
    
    if (kObjectIsEmpty(listModel)) return;;
    
    self.listModel = listModel;
    self.likeButton.selected = listModel.isliked;
    self.likeLabel.text = listModel.likenumber;
    
    self.collectionButton.selected = listModel.isfaved;
    self.collectionLabel.text = listModel.favnumber;
    
    self.commentsLabel.text = listModel.commentnumber;
    
    self.listModel.cellHeight = [ZXHomeTableViewCell  zx_heightWithListModel:listModel];
    
    
    if (listModel.isOtherEnter){
        //发送给首页model
        [WGNotification postNotificationName:ZXNotificationMacro_HomeSupportCollectionComments object:self.listModel];
    }

    
}

@end

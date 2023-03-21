//
//  ZXHomeDetailsViewController.m
//  ZXHY
//
//  Created by Bern Lin on 2021/12/22.
//

#import "ZXHomeDetailsViewController.h"
#import "ZXHomeDetailsBottomView.h"
#import "ZXHomeDetailsContentHeaderFooterView.h"
#import "ZXHomeDetailsNumberOfRepliesHeaderFooterView.h"
#import "ZXHomeDetailsCommentsHeaderFooterView.h"
#import "ZXHomeDetailsCommentsTableViewCell.h"
#import "ZXHomeDetailsCommentsDisplayHeaderFooterView.h"
#import "ZXShareView.h"
#import "ZXGeneralSheetView.h"
#import "ZXLogoutTipsView.h"
#import "ZXReportWindowView.h"
#import "ZXPostNoteViewController.h"
#import "ZXHomeModel.h"
#import "ZXHomeDetailsCommentModel.h"
#import "ZXMsgInputView.h"
#import "ZXHomeManager.h"
#import "ZXHomeLocationDetailsViewController.h"


typedef NS_ENUM(NSUInteger, ZXDetailsSectionType) {
    ZXDetailsSectionType_Main,
    ZXDetailsSectionType_NumOfReplies,
    ZXDetailsSectionType_Comments,
};


typedef NS_ENUM(NSUInteger, ZXGeneralSheetViewDetailsType) {
    ZXGeneralSheetViewDetailsType_None,
    ZXGeneralSheetViewDetailsType_Notes,
    ZXGeneralSheetViewDetailsType_CommentsDelete,
    ZXGeneralSheetViewDetailsType_CommentsReport,
};


@interface ZXHomeDetailsViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
ZXShareViewDelegate,
ZXGeneralSheetViewDelegate,
ZXHomeDetailsBottomViewDelegate,
ZXHomeDetailsCommentsHeaderFooterViewDelegate,
ZXHomeDetailsCommentsDisplayHeaderFooterViewDelegate,
ZXHomeDetailsCommentsTableViewCellDelegate,
ZXLogoutTipsViewDelegate,
ZXReportWindowViewDelegate,
ZXMsgInputViewDelegate,
ZXHomeDetailsContentHeaderFooterViewDelegate
>


@property (nonatomic, strong) WGGeneralSheetController *sheetVc;
@property (nonatomic, strong) WGGeneralAlertController *alertVc;
@property (nonatomic, strong) ZXLogoutTipsView *tipsView;
@property (nonatomic, strong) ZXReportWindowView *reportWindowView;

@property (nonatomic, strong) WGBaseTableView           *tableView;
@property (nonatomic, strong) ZXHomeDetailsBottomView   *bottomView;
@property (nonatomic, strong) NSMutableArray  *dataSourceArray;

@property (nonatomic, strong) UIView  *tableFootView;

@property (nonatomic, strong) ZXHomeListModel *homeListModel;

@property (nonatomic, strong) NSString  *currentPage;
@property (nonatomic, strong) NSMutableArray  *sourceList;
@property (nonatomic, strong) ZXHomeDetailsCommentModel  *commentModel;

//讲俩句
@property (nonatomic, strong) ZXMsgInputView *msgInputView;

//键盘Y
@property (nonatomic, assign) CGFloat  keyboaryY;
//当前cell的rect
@property (nonatomic, assign) CGRect  currentCellRect;
@property (nonatomic, assign) CGPoint currentContentOffset;
//评论Id
@property (nonatomic, strong) NSString  *commentId;

@end

@implementation ZXHomeDetailsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self zx_setNavigationView];
    
    //监听键盘
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameDidChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
}


#pragma mark - Initialization UI

//设置Navigation
- (void)zx_setNavigationView{
    
    self.wg_mainTitle = @"";
    [self.navigationView wg_setTitleColor:UIColor.clearColor];
    self.navigationView.backgroundColor = [UIColor whiteColor];
    [self.view bringSubviewToFront:self.navigationView];
    self.navigationView.delegate = self;
    self.showCustomerNavView = YES;
    
    [self.navigationView wg_setRightBtnWithNormalImageName:@"homeShare" highlightedImageName:nil selectedImageName:nil btnTag:1];
    [self.navigationView wg_setRightBtnWithNormalImageName:@"" highlightedImageName:nil selectedImageName:nil btnTag:2];
    

}

- (void)zx_setNetworkForNavigationView{
    
    if (self.homeListModel.ismine){
        
        [self.navigationView wg_setRightBtnWithNormalImageName:@"homeShare" highlightedImageName:nil selectedImageName:nil btnTag:1];
         [self.navigationView wg_setRightBtnWithNormalImageName:@"homeMore" highlightedImageName:nil selectedImageName:nil btnTag:2];
    }else{
        [self.navigationView wg_setRightBtnWithNormalImageName:@"homeShare" highlightedImageName:nil selectedImageName:nil btnTag:1];
        [self.navigationView wg_setRightBtnWithNormalImageName:@"" highlightedImageName:nil selectedImageName:nil btnTag:2];
    }
}


//初始化UI
- (void)zx_initializationUI{
    
    self.view.backgroundColor = UIColor.whiteColor;

    self.bottomView = [[ZXHomeDetailsBottomView alloc] initWithFrame:CGRectMake(0, WGNumScreenHeight() - kNavBarHeight, WGNumScreenWidth(), kNavBarHeight)];
    self.bottomView.delegate = self;
    [self.bottomView zx_setListModel:self.homeListModel];
    [self.view addSubview:self.bottomView];
    
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavBarHeight);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    

    //输入框
    self.msgInputView = [[ZXMsgInputView alloc] initWithFrame:CGRectMake(0, WGNumScreenHeight(), WGNumScreenWidth(), 48.0)];
    self.msgInputView.backgroundColor = WGGrayColor(248);
    self.msgInputView.delegate = self;
    [self.view addSubview:self.msgInputView];

    

    
    
    
    //没有评论View
    self.tableFootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WGNumScreenWidth(), 180)];
    self.tableFootView.backgroundColor = UIColor.whiteColor;
    UIImageView *tipsImageView = [UIImageView wg_imageViewWithImageNamed:@"NotComment"];
    [self.tableFootView addSubview:tipsImageView];
    [tipsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableFootView).offset(20);
        make.centerX.equalTo(self.tableFootView);
        make.width.height.offset(120);
    }];
    
}


#pragma mark - WGNavigationViewDelegate
- (void)navigationViewRightBtnClick:(WGNavigationView *)navigationView btnTag:(NSInteger)btnTag{
    
    if (btnTag == 1){
        
        ZXShareView * shareView = [[ZXShareView alloc] initWithFrame:CGRectMake(0, 0, WGNumScreenWidth(), 260)];
        shareView.delegate = self;
        self.sheetVc = [WGGeneralSheetController  sheetControllerWithCustomView:shareView];
        [self.sheetVc showToCurrentVc];
        
        
    } else if (btnTag == 2) {
       
        if (self.homeListModel.ismine){
            NSMutableArray *sourceArray = [NSMutableArray arrayWithObjects:@"删除笔记",@"编辑笔记", nil];
            NSMutableArray *colorArray = [NSMutableArray arrayWithObjects:WGRGBColor(226, 78, 78),WGRGBColor(51, 51, 51),nil];
            [self zx_generalSheetViewWithSourceArray:sourceArray ColorArray:colorArray Type:ZXGeneralSheetViewDetailsType_Notes];
            
        }else{
            return;
        }

        
        
        
    }
}


#pragma mark - ZXShareViewDelegate
//关闭分享页
- (void)zx_closeShareView:(ZXShareView *)shareView{
    [self.sheetVc dissmissSheetVc];
}

//选中Item
- (void)zx_shareView:(ZXShareView *)shareView SelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.sheetVc dissmisSheetVcCompletion:^{
        
        if (indexPath.row == 0){
            
            //微信
            NSString *imageUrl = [self.homeListModel.bannerlist wg_safeObjectAtIndex:0];
            [[ZXShareManager sharedManager] zx_wechatSendTitle:self.homeListModel.title Content:self.homeListModel.content ImageUrl:imageUrl Link:self.homeListModel.h5url Scene:ZXShareScene_Session completion:^(BOOL success) {
            }];
            
        } else if (indexPath.row == 1){
    
            //朋友圈
            NSString *imageUrl = [self.homeListModel.bannerlist wg_safeObjectAtIndex:0];
            [[ZXShareManager sharedManager] zx_wechatSendTitle:self.homeListModel.title Content:self.homeListModel.content ImageUrl:imageUrl Link:self.homeListModel.h5url Scene:ZXShareScene_Timeline completion:^(BOOL success) {
            }];
            
            
        } else if (indexPath.row == 2){
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = [NSString stringWithFormat:@"%@",self.homeListModel.h5url];
            [WGUIManager wg_hideHUDWithText:@"复制成功"];
        } else if (indexPath.row == 3){
            self.reportWindowView = [[ZXReportWindowView alloc] initWithFrame:CGRectMake(0, 0, 300, 125)];
            self.reportWindowView.tag = 1;
            self.reportWindowView.delegate = self;
            self.alertVc = [WGGeneralAlertController alertControllerWithCustomView:self.reportWindowView];
            [self.alertVc showToCurrentVc];
            
        }
    }];
    
    
    
}

#pragma mark - ZXGeneralSheetViewDelegate
//通用SheetView
- (void)zx_generalSheetView:(ZXGeneralSheetView *)sheetView Index:(NSUInteger)index{
    
    [self.sheetVc dissmisSheetVcCompletion:^{
        //取消
        if (index == CancelTag) return;
        
        //笔记
        if (sheetView.sheetViewType == ZXGeneralSheetViewDetailsType_Notes){
            if (index == 0){
                
                [self zx_generalTipsViewWithTipsTitle:@"确定要删除笔记吗？"  Content:@"删除了无法恢复哦" SureButtonTitle: @"删除" Type:ZXGeneralSheetViewDetailsType_Notes];
                
            }
            else if (index == 1){
                ZXPostNoteViewController *vc = [[ZXPostNoteViewController alloc] init];
                [vc zx_editNoteWithHomeListModel:self.homeListModel];
                [self.navigationController pushViewController:vc animated:YES];
                
            }
        }
        
        //评论
        else if (sheetView.sheetViewType == ZXGeneralSheetViewDetailsType_CommentsDelete){

            [self zx_generalTipsViewWithTipsTitle:@"确定要删除评论吗？"  Content:@"删除了无法恢复哦" SureButtonTitle: @"删除" Type:ZXGeneralSheetViewDetailsType_CommentsDelete];
        }
        
        //举报
        else if (sheetView.sheetViewType == ZXGeneralSheetViewDetailsType_CommentsReport){
            //举报弹窗
            self.reportWindowView = [[ZXReportWindowView alloc] initWithFrame:CGRectMake(0, 0, 300, 125)];
            self.reportWindowView.delegate = self;
            self.alertVc = [WGGeneralAlertController alertControllerWithCustomView:self.reportWindowView];
            [self.alertVc showToCurrentVc];
        }
    }];
    
    
    
}



#pragma mark - ZXHomeDetailsBottomViewDelegate
//评论代理
- (void)zx_commentsDetailsBottomView:(ZXHomeDetailsBottomView *)detailsBottomView{
    
//    if (self.sourceList.count == 0){
//        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:NSNotFound inSection:ZXDetailsSectionType_Main] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//    }else{
//
//    }
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:NSNotFound inSection:ZXDetailsSectionType_NumOfReplies] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

//讲两句代理
- (void)zx_remarkCommentsDetailsBottomView:(ZXHomeDetailsBottomView *)detailsBottomView{
    self.commentId = @"";
    [self.msgInputView wg_becomeFirstResponder];
}

#pragma mark -  ZXLogoutTipsViewDelegate (是否确认删除)
//tipsView取消 响应
- (void)closeTipsView:(ZXLogoutTipsView *)tipsView{
    [self.alertVc dissmisAlertVc];
}

//tipsView确定 响应
- (void)sureTipsView:(ZXLogoutTipsView *)tipsView{
    [self.alertVc dissmisAlertVc];
    
    //笔记
    if (tipsView.tag == ZXGeneralSheetViewDetailsType_Notes){
        //确定删除笔记
        [self zx_reqApiInfomationDeleteInfo];
    }
    //评论
    else if (tipsView.tag == ZXGeneralSheetViewDetailsType_CommentsDelete){
        //确定删除评论
        [self zx_reqApiInfomationDeleteOrReport:ZXGeneralSheetViewDetailsType_CommentsDelete];
    }
}

#pragma mark -  ZXReportWindowViewDelegate (是否确认举报)
//取消 响应
- (void)closeReportWindowView:(ZXReportWindowView *)reportWindowView{
    [self.alertVc dissmisAlertVc];
}

//确定 响应
- (void)sureReportWindowView:(ZXReportWindowView *)reportWindowView{
    
    if (reportWindowView.tag == 1){
        WEAKSELF;
        [self.alertVc dissmisAlertVcWithCompletion:^{
            STRONGSELF;
            [ZXHomeManager  zx_reqApiInfomationReportInfoWithNoteId:self.homeListModel.typeId SuccessBlock:^(NSDictionary * _Nonnull dic) {

                [WGUIManager wg_hideHUDNetWorkErrorWithText:@"举报成功" imageName:@"CommentReport"];

            } ErrorBlock:^(NSError * _Nonnull error) {

            }];
        }];
    }else{
        WEAKSELF;
        [self.alertVc dissmisAlertVcWithCompletion:^{
            STRONGSELF;
            [self zx_reqApiInfomationDeleteOrReport:ZXGeneralSheetViewDetailsType_CommentsReport];
        }];
        
    }
    
}



#pragma mark - ZXMsgInputViewDelegate (评论输入View)
//发送代理
- (void)zx_sendMsgInputView:(ZXMsgInputView *)msgInputView MsgText:(NSString *)msgText{
    
    [self zx_reqApiInfomationCreateComment:msgText];
}


#pragma mark - ZXHomeDetailsContentHeaderFooterViewDelegate (详情页 - 地理位置点击)
//地理位置点击
- (void)zx_didLoactionDetailsContentView:(ZXHomeDetailsContentHeaderFooterView *)contentView withListModel:(ZXHomeListModel *)listModel{
    ZXHomeLocationDetailsViewController *vc = [ZXHomeLocationDetailsViewController new];
    [vc zx_setHomeListModel:listModel];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Private Method
//数据传入
- (void)zx_setListModel:(ZXHomeListModel *)listModel{
//    if (kObjectIsEmpty(listModel)) return;;
    
    self.homeListModel = listModel;
    
    //设置UI
    [self zx_initializationUI];
    
    //设置导航栏
    [self zx_setNetworkForNavigationView];
    
    //网络请求
    [self restartLoadData];

    [self.tableView reloadData];
    
}

//搜索页面进去id
- (void)zx_setTypeIdToRequest:(NSString *)typeId{
    
   
    [ZXHomeManager zx_reqApiInfomationGetDetailWithTypeId:typeId SuccessBlock:^(NSDictionary * _Nonnull dic) {
        
        ZXHomeListModel *listModel = [ZXHomeListModel wg_objectWithDictionary:[dic wg_safeObjectForKey:@"data"]];
        listModel.isOtherEnter = YES;
        [self zx_setListModel:listModel];
        
    } ErrorBlock:^(NSError * _Nonnull error) {
        
    }];
}


//下拉刷新
- (void)restartLoadData{
    
    self.currentPage = @"1";
    
    self.dataSourceArray = [NSMutableArray arrayWithObjects:@(ZXDetailsSectionType_Main),@(ZXDetailsSectionType_NumOfReplies), nil];
   
    self.sourceList  = [NSMutableArray array];
    
    [self zx_reqApiInfomationGetCommentList];
}

//上拉加载
- (void)loadMore{
    
    if ([self.currentPage isEqualToString:self.commentModel.totalpage] || [self.commentModel.totalpage intValue] == 0) return;
    
    self.currentPage = [NSString stringWithFormat:@"%d", [self.currentPage intValue] + 1];
    
    [self zx_reqApiInfomationGetCommentList];
}


//编辑通用数据弹窗
- (void)zx_generalSheetViewWithSourceArray:(NSMutableArray *)sourceArray ColorArray:(NSMutableArray *)colorArray Type:(ZXGeneralSheetViewDetailsType)type{
    
    ZXGeneralSheetView *view = [[ZXGeneralSheetView alloc] initWithFrame:CGRectMake(0, 0, WGNumScreenWidth(), WGNumScreenHeight()) withDataSource:sourceArray DataColor:colorArray];
    view.sheetViewType = type;
    view.delegate = self;
    self.sheetVc = [WGGeneralSheetController  sheetControllerWithCustomView:view];
    [self.sheetVc showToCurrentVc];
    
}

//编辑通用选择框
- (void)zx_generalTipsViewWithTipsTitle:(NSString *)title Content:(NSString *)content SureButtonTitle:(NSString *)sureButtonTitle Type:(ZXGeneralSheetViewDetailsType)type{
    
    self.tipsView = [[ZXLogoutTipsView alloc] initWithFrame:CGRectMake(0, 0, 300, 145) TipsTitle:title  Content:content SureButtonTitle:sureButtonTitle];
    self.tipsView.tag = type;
    self.tipsView.delegate = self;
    self.alertVc = [WGGeneralAlertController alertControllerWithCustomView:self.tipsView];
    [self.alertVc showToCurrentVc];
    
}

#pragma mark - scrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [UIView animateWithDuration:0.25 animations:^{
        self.msgInputView.top = WGNumScreenHeight();
        [self.msgInputView wg_resignFirstResponder];
    }];
}


#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.dataSourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSUInteger type = [[self.dataSourceArray wg_safeObjectAtIndex:section] intValue];

    if (type == ZXDetailsSectionType_Main || type == ZXDetailsSectionType_NumOfReplies){
        return 0;
    }
    
    if (type == ZXDetailsSectionType_Comments){
        
        NSInteger abs = section - type;
        NSInteger sourceIndex =  labs(abs);
        ZXHomeDetailsCommentListModel *commentListModel = [self.sourceList wg_safeObjectAtIndex:sourceIndex];
        
        
        if ( commentListModel.replylist.count > 2){
            if (commentListModel.isDisplayAll){
                return commentListModel.replylist.count;
            }else{
                return 2;
            }
        }
        
        return commentListModel.replylist.count;

    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSUInteger type = [[self.dataSourceArray wg_safeObjectAtIndex:indexPath.section] intValue];
    
    if (type == ZXDetailsSectionType_Comments){
        ZXHomeDetailsCommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZXHomeDetailsCommentsTableViewCell wg_cellIdentifier]];
        
        NSInteger abs = indexPath.section - type;
        NSInteger sourceIndex =  labs(abs);
        ZXHomeDetailsCommentListModel *commentListModel = [self.sourceList wg_safeObjectAtIndex:sourceIndex];
        ZXHomeDetailsCommentReplyListModel *replyListModel = [ZXHomeDetailsCommentReplyListModel new];
        if (commentListModel.isDisplayAll){
            replyListModel = [commentListModel.replylist wg_safeObjectAtIndex:indexPath.row];
        }else{
            replyListModel = [commentListModel.flashbackReplylist wg_safeObjectAtIndex:indexPath.row];
        }
        
        [cell zx_setCommentReplyListModel:replyListModel];
        cell.delegate = self;
        return cell;
    }
    

    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger type = [[self.dataSourceArray wg_safeObjectAtIndex:indexPath.section] intValue];
   
    if (type == ZXDetailsSectionType_Comments){
         
        NSInteger abs = indexPath.section - type;
        NSInteger sourceIndex =  labs(abs);
        ZXHomeDetailsCommentListModel *commentListModel = [self.sourceList wg_safeObjectAtIndex:sourceIndex];
        
        ZXHomeDetailsCommentReplyListModel *replyListModel = [ZXHomeDetailsCommentReplyListModel new];
        
        if (commentListModel.isDisplayAll){
            replyListModel = [commentListModel.replylist wg_safeObjectAtIndex:indexPath.row];
        }else{
            replyListModel = [commentListModel.flashbackReplylist wg_safeObjectAtIndex:indexPath.row];
        }
        
        return replyListModel.cellHeight;
    }
    
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSUInteger type = [[self.dataSourceArray wg_safeObjectAtIndex:indexPath.section] intValue];
    if (type == ZXDetailsSectionType_Comments){
        
        NSInteger abs = indexPath.section - type;
        NSInteger sourceIndex =  labs(abs);
        ZXHomeDetailsCommentListModel *commentListModel = [self.sourceList wg_safeObjectAtIndex:sourceIndex];
        [self zx_clickCommentView:[ZXHomeDetailsCommentsHeaderFooterView new] withCommentListModel:commentListModel];
        
        CGRect rectTableView = [tableView rectForRowAtIndexPath:indexPath];
        CGRect rectCell = [tableView convertRect:rectTableView toView:[tableView superview]];
        self.currentCellRect = rectCell;
        NSLog(@"cell.Rect --- %f",rectCell.origin.y);
        self.currentContentOffset = self.tableView.contentOffset;
        
    }

}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSUInteger type = [[self.dataSourceArray wg_safeObjectAtIndex:section] intValue];
    
    //主内容
    if (type == ZXDetailsSectionType_Main){
        ZXHomeDetailsContentHeaderFooterView *detailsContentHeaderFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[ZXHomeDetailsContentHeaderFooterView wg_cellIdentifier]];
        [detailsContentHeaderFooterView zx_setListModel:self.homeListModel];
        detailsContentHeaderFooterView.delegate = self;
        return detailsContentHeaderFooterView;
    }
    
    //回复数
    if (type == ZXDetailsSectionType_NumOfReplies){
        
        ZXHomeDetailsNumberOfRepliesHeaderFooterView *repliesHeaderFooterViewdetailsContentHeaderFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[ZXHomeDetailsNumberOfRepliesHeaderFooterView wg_cellIdentifier]];
        
        [repliesHeaderFooterViewdetailsContentHeaderFooterView zx_setDetailsCommentModel:self.commentModel];
        
        return repliesHeaderFooterViewdetailsContentHeaderFooterView;
    }
    
    //评论
    if (type == ZXDetailsSectionType_Comments){

        ZXHomeDetailsCommentsHeaderFooterView *commentsHeaderFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[ZXHomeDetailsCommentsHeaderFooterView wg_cellIdentifier]];
    
        
        NSInteger abs = section - type;
        NSInteger sourceIndex =  labs(abs);
        ZXHomeDetailsCommentListModel *commentListModel = [self.sourceList wg_safeObjectAtIndex:sourceIndex];

        [commentsHeaderFooterView zx_setCommentListModel:commentListModel];
        commentsHeaderFooterView.delegate = self;
        
        return commentsHeaderFooterView;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    NSUInteger type = [[self.dataSourceArray wg_safeObjectAtIndex:section] intValue];
    
    if (type == ZXDetailsSectionType_Main){
        return [ZXHomeDetailsContentHeaderFooterView zx_heightWithListModel:self.homeListModel];
    }
    
    if (type == ZXDetailsSectionType_NumOfReplies){
        return 40;
    }
    
    if (type == ZXDetailsSectionType_Comments){
        NSInteger abs = section - type;
        NSInteger sourceIndex =  labs(abs);
        ZXHomeDetailsCommentListModel *commentListModel = [self.sourceList wg_safeObjectAtIndex:sourceIndex];
        return commentListModel.headerHeight;
    }
    
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
   
    NSUInteger type = [[self.dataSourceArray wg_safeObjectAtIndex:section] intValue];
    
    //展示全部
    if (type == ZXDetailsSectionType_Comments){
    
        NSInteger abs = section - type;
        NSInteger sourceIndex =  labs(abs);
        ZXHomeDetailsCommentListModel *commentListModel = [self.sourceList wg_safeObjectAtIndex:sourceIndex];
        
        if (commentListModel.replylist.count <= 2){
            return nil;
        }
        
        ZXHomeDetailsCommentsDisplayHeaderFooterView *displayHeaderFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[ZXHomeDetailsCommentsDisplayHeaderFooterView wg_cellIdentifier]];

        displayHeaderFooterView.delegate = self;
        displayHeaderFooterView.tag = section;
        [displayHeaderFooterView zx_setCommentListModel:commentListModel];
        return displayHeaderFooterView;
    }
    
    return nil;

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    NSUInteger type = [[self.dataSourceArray wg_safeObjectAtIndex:section] intValue];
    
    if (type == ZXDetailsSectionType_Comments){
        NSInteger abs = section - type;
        NSInteger sourceIndex =  labs(abs);
        ZXHomeDetailsCommentListModel *commentListModel = [self.sourceList wg_safeObjectAtIndex:sourceIndex];
        if (commentListModel.replylist.count <= 2){
            return 0.01f;
        }
        return 40.1f;
    }
    return 0.01f;
}


#pragma mark - ZXHomeDetailsCommentsHeaderFooterViewDelegate
//点击评论
- (void)zx_clickCommentView:(ZXHomeDetailsCommentsHeaderFooterView *)CommentView withCommentListModel:(ZXHomeDetailsCommentListModel *)commentListModel{
    
    self.commentId = commentListModel.commentid;
    [self.msgInputView wg_becomeFirstResponder];
}

//长按删除或举报
- (void)zx_longClickCommentView:(ZXHomeDetailsCommentsHeaderFooterView *)CommentView withCommentListModel:(ZXHomeDetailsCommentListModel *)commentListModel{
    
    self.commentId = commentListModel.commentid;
    
    NSMutableArray *sourceArray = [NSMutableArray array];
    NSMutableArray *colorArray = [NSMutableArray array];
    ZXGeneralSheetViewDetailsType type = ZXGeneralSheetViewDetailsType_None;
    
    if (commentListModel.ismine){
        sourceArray = [NSMutableArray array];
        [sourceArray wg_safeAddObject:@"删除留言"];
        [colorArray wg_safeAddObject:WGRGBColor(226, 78, 78)];
        type = ZXGeneralSheetViewDetailsType_CommentsDelete;
    }else{
        sourceArray = [NSMutableArray array];
        [sourceArray wg_safeAddObject:@"举报"];
        [colorArray wg_safeAddObject:WGRGBColor(226, 78, 78)];
        type = ZXGeneralSheetViewDetailsType_CommentsReport;
    }
    
    [self zx_generalSheetViewWithSourceArray:sourceArray ColorArray:colorArray Type:type];
}

#pragma mark - ZXHomeDetailsCommentsTableViewCellDelegate
//长按删除或举报
- (void)zx_longClickCommentCell:(ZXHomeDetailsCommentsTableViewCell *)commentCell withCommentListModel:(ZXHomeDetailsCommentReplyListModel *)replyListModel{
    
    self.commentId = replyListModel.replyid;
    
    NSMutableArray *sourceArray = [NSMutableArray array];
    NSMutableArray *colorArray = [NSMutableArray array];
    ZXGeneralSheetViewDetailsType type = ZXGeneralSheetViewDetailsType_None;
    
    if (replyListModel.ismine){
        sourceArray = [NSMutableArray array];
        [sourceArray wg_safeAddObject:@"删除留言"];
        [colorArray wg_safeAddObject:WGRGBColor(226, 78, 78)];
        type = ZXGeneralSheetViewDetailsType_CommentsDelete;
    }else{
        sourceArray = [NSMutableArray array];
        [sourceArray wg_safeAddObject:@"举报"];
        [colorArray wg_safeAddObject:WGRGBColor(226, 78, 78)];
        type = ZXGeneralSheetViewDetailsType_CommentsReport;
    }
    
    [self zx_generalSheetViewWithSourceArray:sourceArray ColorArray:colorArray Type:type];
}


#pragma mark - ZXHomeDetailsCommentsDisplayHeaderFooterViewDelegate
//展示全部
- (void)zx_dispalyDisplayHeaderFooterView:(ZXHomeDetailsCommentsDisplayHeaderFooterView *)displayHeaderFooterView{

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        
    });
    

}



#pragma mark - NetworkRequest
//获取信息流评论列表
- (void)zx_reqApiInfomationGetCommentList{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic wg_safeSetObject:self.homeListModel.typeId forKey:@"id"];
    [dic wg_safeSetObject:self.currentPage forKey:@"page"];
    [dic wg_safeSetObject:@"10" forKey:@"limit"];
    
    WEAKSELF;
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiInfomationGetCommentList Parameter:dic success:^(NSDictionary * _Nonnull resultDic) {
        STRONGSELF;
        
        self.commentModel = [ZXHomeDetailsCommentModel wg_objectWithDictionary:[resultDic wg_safeObjectForKey:@"data"]];
        
        //赋值回首页和bottomView
        self.homeListModel.commentnumber = self.commentModel.totalnum;
        [self.bottomView zx_setListModel:self.homeListModel];
        
    
        //添加回复楼层
        for (ZXHomeDetailsCommentListModel *listModel in self.commentModel.list){
            
            [self.dataSourceArray wg_safeAddObject:@(ZXDetailsSectionType_Comments)];
            
            //计算一级评论高度
            listModel.headerHeight = [ZXHomeManager zx_computeCommentsHeightWithContent:listModel.content CommentLevel:ZXDetailsCommentLevel_One];
            
            //计算二级评论高度
            for ( ZXHomeDetailsCommentReplyListModel *replyListModel in listModel.replylist){
                
                
                replyListModel.cellHeight = [ZXHomeManager zx_computeCommentsHeightWithContent:replyListModel.content CommentLevel:ZXDetailsCommentLevel_Two];
            }
            
            
            
            //是否全部显示数据
            if (listModel.replylist.count <= 2){
                listModel.isDisplayAll = YES;
            }

            //倒序回复数组
            listModel.flashbackReplylist = [[listModel.replylist reverseObjectEnumerator] allObjects];
            
            //添加数据
            [self.sourceList wg_safeAddObject:listModel];
        }
        
        //是否有评论
        if (self.sourceList.count){
            self.tableView.tableFooterView = nil;
        }else{
            self.tableView.tableFooterView = self.tableFootView;
        }
        
        //最后一页
        self.tableView.mj_footer.hidden = ([self.currentPage isEqualToString:self.commentModel.totalpage] || [self.commentModel.totalpage intValue] == 0);
        
//
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
//        [self.tableView layoutIfNeeded];
        
    } failure:^(NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
}


//写评论
- (void)zx_reqApiInfomationCreateComment:(NSString *)content{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic wg_safeSetObject:self.homeListModel.typeId forKey:@"articleid"];
    [dic wg_safeSetObject:self.commentId forKey:@"commentid"];
    [dic wg_safeSetObject:content forKey:@"content"];
    
    WEAKSELF;
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiInfomationCreateComment Parameter:dic success:^(NSDictionary * _Nonnull resultDic) {
        STRONGSELF;
        
        [self restartLoadData];
        
    } failure:^(NSError * _Nonnull error) {
       
        
    }];
}


//删除笔记
- (void)zx_reqApiInfomationDeleteInfo{
    
    //禁止右滑返回
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
    
    [WGUIManager wg_showHUD];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic wg_safeSetObject:self.homeListModel.typeId forKey:@"id"];
    
    WEAKSELF;
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiInfomationDeleteInfo Parameter:dic success:^(NSDictionary * _Nonnull resultDic) {
        STRONGSELF;
        
        self.homeListModel = nil;
        
        [WGNotification postNotificationName:ZXNotificationMacro_Home object:nil];
        
        [WGNotification postNotificationName:ZXNotificationMacro_PostOrDeleteNote object:nil];
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
            [WGUIManager wg_hideHUDWithText:@"删除成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
        });
        
        
    } failure:^(NSError * _Nonnull error) {
       
        
    }];
}



//删除/举报 评论或回复
- (void)zx_reqApiInfomationDeleteOrReport:(ZXGeneralSheetViewDetailsType)type{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic wg_safeSetObject:self.commentId forKey:@"id"];
    
    NSString *urlStr = @"";
    if (type == ZXGeneralSheetViewDetailsType_CommentsReport){
        urlStr = ZX_ReqApiInfomationReportComment;
    }
    else if (type == ZXGeneralSheetViewDetailsType_CommentsDelete){
        urlStr = ZX_ReqApiInfomationDeleteComment;
    }
    
    WEAKSELF;
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:urlStr Parameter:dic success:^(NSDictionary * _Nonnull resultDic) {
        STRONGSELF;
        
        if (type == ZXGeneralSheetViewDetailsType_CommentsReport){
            [WGUIManager wg_hideHUDNetWorkErrorWithText:@"举报成功" imageName:@"CommentReport"];
        }
        else if (type == ZXGeneralSheetViewDetailsType_CommentsDelete){
            [self restartLoadData];
        }
       
        
        
    } failure:^(NSError * _Nonnull error) {
       
        
    }];
}






#pragma mark - layz

- (WGBaseTableView *)tableView{
    if (!_tableView){
        _tableView = [[WGBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = WGGrayColor(239);
        
    
        
       if (@available(iOS 11.0, *)) {
           _tableView.estimatedRowHeight = 0;
           _tableView.estimatedSectionHeaderHeight = 0;
           _tableView.estimatedSectionFooterHeight = 0;
           
       }
        
        [_tableView registerClass:[ZXHomeDetailsCommentsTableViewCell class] forCellReuseIdentifier:[ZXHomeDetailsCommentsTableViewCell wg_cellIdentifier]];
        [_tableView registerClass:[ZXHomeDetailsContentHeaderFooterView class] forHeaderFooterViewReuseIdentifier:[ZXHomeDetailsContentHeaderFooterView wg_cellIdentifier]];
        [_tableView registerClass:[ZXHomeDetailsNumberOfRepliesHeaderFooterView class] forHeaderFooterViewReuseIdentifier:[ZXHomeDetailsNumberOfRepliesHeaderFooterView wg_cellIdentifier]];
        [_tableView registerClass:[ZXHomeDetailsCommentsHeaderFooterView class] forHeaderFooterViewReuseIdentifier:[ZXHomeDetailsCommentsHeaderFooterView wg_cellIdentifier]];
        [_tableView registerClass:[ZXHomeDetailsCommentsDisplayHeaderFooterView class] forHeaderFooterViewReuseIdentifier:[ZXHomeDetailsCommentsDisplayHeaderFooterView wg_cellIdentifier]];
    
        
        [WGCommonRefreshUtil configRefreshInScrollView:self.tableView target:self action:@selector(restartLoadData) headerRefreshType:WGCommonHeaderRefreshTypeRed];
        [WGCommonRefreshUtil configLoadMoreInScrollView:self.tableView target:self action:@selector(loadMore)];
    }
    return _tableView;
}


@end

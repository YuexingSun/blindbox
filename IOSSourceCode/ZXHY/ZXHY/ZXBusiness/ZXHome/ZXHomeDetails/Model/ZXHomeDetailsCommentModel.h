//
//  ZXHomeDetailsCommentModel.h
//  ZXHY
//
//  Created by Bern Lin on 2021/12/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXHomeDetailsCommentModel : NSObject

@property (nonatomic, strong) NSString  *myavatar;
@property (nonatomic, strong) NSString  *mynickname;

@property (nonatomic, strong) NSArray   *list;
@property (nonatomic, strong) NSString  *totalnum;
@property (nonatomic, strong) NSString  *totalpage;
@property (nonatomic, strong) NSString  *currpage;

@end


@interface ZXHomeDetailsCommentListModel : NSObject

//commentid : "评论id",
//avatar : "评论人头像",
//nickname : "评论人昵称",
// content : "评论内容",
//sendtime : "2021-09-09 12:12:12"
//ismine : 0/1 //是否自己发的评价
//replylist : //回复列表

@property (nonatomic, strong) NSString  *commentid;
@property (nonatomic, strong) NSString  *avatar;
@property (nonatomic, strong) NSString  *nickname;
@property (nonatomic, strong) NSString  *content;
@property (nonatomic, strong) NSString  *sendtime;
@property (nonatomic, assign) bool  ismine;
@property (nonatomic, strong) NSArray  *replylist;
@property (nonatomic, strong) NSArray  *flashbackReplylist;
@property (nonatomic, assign) bool  isDisplayAll;
@property (nonatomic, assign) NSUInteger  displayCount;
//一级评论高度
@property (nonatomic, assign) CGFloat  headerHeight;

@end

@interface ZXHomeDetailsCommentReplyListModel : NSObject

//commentid : "评论id",
//replyid : "回复id",
//avatar : "回复人头像",
//nickname : "回复人昵称",
//content : "回复内容",
//sendtime : "2021-09-09 12:12:12"
//ismine : 0/1 //是否自己发的回复

@property (nonatomic, strong) NSString  *commentid;
@property (nonatomic, strong) NSString  *replyid;
@property (nonatomic, strong) NSString  *avatar;
@property (nonatomic, strong) NSString  *nickname;
@property (nonatomic, strong) NSString  *content;
@property (nonatomic, strong) NSString  *sendtime;
@property (nonatomic, assign) bool  ismine;

@property (nonatomic, assign) CGFloat  cellHeight;

@end

NS_ASSUME_NONNULL_END

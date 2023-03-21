//
//  ZXHomeManager.h
//  ZXHY
//
//  Created by Bern Lin on 2021/12/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXHomeManager : NSObject

typedef NS_ENUM(NSUInteger, ZXDetailsCommentLevel) {
    ZXDetailsCommentLevel_One,
    ZXDetailsCommentLevel_Two,
};


//计算评论高度
+ (CGFloat)zx_computeCommentsHeightWithContent:(NSString *)content CommentLevel:(ZXDetailsCommentLevel)commentLevel;

//详情页
+ (void)zx_reqApiInfomationGetDetailWithTypeId:(NSString *)typeId SuccessBlock:(void (^)(NSDictionary *dic))successBlock ErrorBlock:(void (^)(NSError *error))errorBlock;

//点赞
+ (void)zx_reqApiInfomationLikeArticleWithNoteId:(NSString *)noteId SuccessBlock:(void (^)(NSDictionary *dic))successBlock ErrorBlock:(void (^)(NSError *error))errorBlock;

//收藏
+ (void)zx_reqApiInfomationLikeFavArticleWithNoteId:(NSString *)noteId SuccessBlock:(void (^)(NSDictionary *dic))successBlock ErrorBlock:(void (^)(NSError *error))errorBlock;

//发布笔记
+ (void)zx_reqApiInfomationCreateInfoWithTypeId:(NSString *)typeId Title:(NSString *)title Content:(NSString *)content Address:(NSString *)address Lng:(NSString *)lng Lat:(NSString *)lat Detailaddress:(NSString *)detailaddress ImgList:(NSMutableArray <UIImage *>*)imgList Point:(NSString *)point SuccessBlock:(void (^)(NSDictionary *dic))successBlock ErrorBlock:(void (^)(NSError *error))errorBlock;

//举报文章
+ (void)zx_reqApiInfomationReportInfoWithNoteId:(NSString *)noteId SuccessBlock:(void (^)(NSDictionary *dic))successBlock ErrorBlock:(void (^)(NSError *error))errorBlock;


@end

NS_ASSUME_NONNULL_END

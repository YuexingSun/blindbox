//
//  ZXHomeManager.m
//  ZXHY
//
//  Created by Bern Lin on 2021/12/30.
//

#import "ZXHomeManager.h"
#import "ZXMineUploadImageModel.h"


@implementation ZXHomeManager

//计算详情评论高度
+ (CGFloat)zx_computeCommentsHeightWithContent:(NSString *)content CommentLevel:(ZXDetailsCommentLevel)commentLevel{
    CGFloat contentLabelH  = 0;
    CGFloat H = 65;
    
    
    NSDictionary *options = @{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
    NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding) };
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    
    UILabel *tempLabel = [UILabel labelWithFont:kFontMedium(15) TextAlignment:NSTextAlignmentLeft TextColor:WGGrayColor(51) TextStr:@"" NumberOfLines:0];
    
    NSMutableAttributedString *muAttString = [[NSMutableAttributedString alloc] initWithAttributedString:[ZX_EmojiManager zx_emojiWithServerString:content]];
    
    [muAttString addAttribute:NSDocumentTypeDocumentAttribute value:data range:NSMakeRange(0, muAttString.length)];
    
    [muAttString addAttribute:NSDocumentTypeDocumentOption value:options range:NSMakeRange(0, muAttString.length)];

    [muAttString addAttribute:NSFontAttributeName value:kFontMedium(15) range:NSMakeRange(0, muAttString.length)];
    
    tempLabel.attributedText = muAttString;
    
    if (commentLevel == ZXDetailsCommentLevel_One){
        
        CGFloat tempLabelHeight = [tempLabel.attributedText boundingRectWithSize:CGSizeMake(WGNumScreenWidth() - 80, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesDeviceMetrics context:nil].size.height;
        
        contentLabelH = tempLabelHeight;
    }

    if (commentLevel == ZXDetailsCommentLevel_Two){

        
        CGFloat tempLabelHeight = [tempLabel.attributedText boundingRectWithSize:CGSizeMake(WGNumScreenWidth() - 115, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesDeviceMetrics context:nil].size.height;
        
        contentLabelH = tempLabelHeight;
    }
    
    return H + contentLabelH;
}

//详情
+ (void)zx_reqApiInfomationGetDetailWithTypeId:(NSString *)typeId SuccessBlock:(void (^)(NSDictionary *dic))successBlock ErrorBlock:(void (^)(NSError *error))errorBlock{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic wg_safeSetObject:typeId forKey:@"id"];
    
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiInfomationGetDetail Parameter:dic success:^(NSDictionary * _Nonnull resultDic) {
    
        if (successBlock) {
            successBlock(resultDic);
        }
        
    } failure:^(NSError * _Nonnull error) {
        if (errorBlock) {
            errorBlock(error);
        }
    }];
}


//点赞
+ (void)zx_reqApiInfomationLikeArticleWithNoteId:(NSString *)noteId SuccessBlock:(void (^)(NSDictionary *dic))successBlock ErrorBlock:(void (^)(NSError *error))errorBlock{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic wg_safeSetObject:noteId forKey:@"id"];
    
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiInfomationLikeArticle Parameter:dic success:^(NSDictionary * _Nonnull resultDic) {
    
        
       
        if (successBlock) {
            successBlock(resultDic);
        }
        
    } failure:^(NSError * _Nonnull error) {
        if (errorBlock) {
            errorBlock(error);
        }
    }];
}

//收藏
+ (void)zx_reqApiInfomationLikeFavArticleWithNoteId:(NSString *)noteId SuccessBlock:(void (^)(NSDictionary *dic))successBlock ErrorBlock:(void (^)(NSError *error))errorBlock{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic wg_safeSetObject:noteId forKey:@"id"];
    
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiInfomationFavArticle Parameter:dic success:^(NSDictionary * _Nonnull resultDic) {
        
       
        if (successBlock) {
            successBlock(resultDic);
        }
        
    } failure:^(NSError * _Nonnull error) {
        if (errorBlock) {
            errorBlock(error);
        }
        
    }];
}


//发布笔记
+ (void)zx_reqApiInfomationCreateInfoWithTypeId:(NSString *)typeId Title:(NSString *)title Content:(NSString *)content Address:(NSString *)address Lng:(NSString *)lng Lat:(NSString *)lat Detailaddress:(NSString *)detailaddress ImgList:(NSMutableArray <UIImage *>*)imgList Point:(NSString *)point SuccessBlock:(void (^)(NSDictionary *dic))successBlock ErrorBlock:(void (^)(NSError *error))errorBlock{
    
    
    WEAKSELF;
    //上传图片
    [[ZXNetworkManager shareNetworkManager] zx_networkPOSTUploadImages:imgList ImageToLimitSizeOfKB:800 progress:^(id  _Nonnull uploadProgress) {
        
    } success:^(NSDictionary * _Nonnull resultDic) {
        STRONGSELF;
        
        ZXMineUploadImageModel *model = [ZXMineUploadImageModel wg_objectWithDictionary:[resultDic wg_safeObjectForKey:@"data"]];
        NSMutableArray *imgUrlList = [NSMutableArray arrayWithArray:model.urllist];
        
        [self zx_reqApiPostNoteWithTypeId:(NSString *)typeId Title:title Content:content Address:address Lng:lng Lat:lat Detailaddress:detailaddress  ImgList:imgUrlList  Point:point SuccessBlock:^(NSDictionary *dic) {
            
            if (successBlock) {
                successBlock(resultDic);
            }
            
        } ErrorBlock:^(NSError *error) {
            if (errorBlock) {
                errorBlock(error);
            }
        }];
        
    } failure:^(NSError * _Nonnull error) {
        if (errorBlock) {
            errorBlock(error);
        }
    }];
    
    
    
   
}

//发布正文
+ (void)zx_reqApiPostNoteWithTypeId:(NSString *)typeId Title:(NSString *)title Content:(NSString *)content Address:(NSString *)address Lng:(NSString *)lng Lat:(NSString *)lat Detailaddress:(NSString *)detailaddress  ImgList:(NSMutableArray *)imgList Point:(NSString *)point SuccessBlock:(void (^)(NSDictionary *dic))successBlock ErrorBlock:(void (^)(NSError *error))errorBlock{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic wg_safeSetObject:typeId forKey:@"id"];
    [dic wg_safeSetObject:title forKey:@"title"];
    [dic wg_safeSetObject:content forKey:@"content"];
    [dic wg_safeSetObject:address forKey:@"address"];
    [dic wg_safeSetObject:lng forKey:@"lng"];
    [dic wg_safeSetObject:lat forKey:@"lat"];
    [dic wg_safeSetObject:detailaddress forKey:@"detailaddress"];
    [dic wg_safeSetObject:imgList forKey:@"pic"];
    [dic wg_safeSetObject:point forKey:@"point"];
    
    
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiInfomationCreateInfo Parameter:dic success:^(NSDictionary * _Nonnull resultDic) {
        
       
        if (successBlock) {
            successBlock(dic);
        }
        
    } failure:^(NSError * _Nonnull error) {
        if (errorBlock) {
            errorBlock(error);
        }
        
    }];
}

//举报文章
+ (void)zx_reqApiInfomationReportInfoWithNoteId:(NSString *)noteId SuccessBlock:(void (^)(NSDictionary *dic))successBlock ErrorBlock:(void (^)(NSError *error))errorBlock{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic wg_safeSetObject:noteId forKey:@"id"];
    
    [[ZXNetworkManager shareNetworkManager] POSTWithURL:ZX_ReqApiInfomationReportInfo Parameter:dic success:^(NSDictionary * _Nonnull resultDic) {
       
        if (successBlock) {
            successBlock(dic);
        }
        
    } failure:^(NSError * _Nonnull error) {
        if (errorBlock) {
            errorBlock(error);
        }
    }];
}



@end

//
//  ZXHomeDetailsCommentModel.m
//  ZXHY
//
//  Created by Bern Lin on 2021/12/29.
//

#import "ZXHomeDetailsCommentModel.h"

@implementation ZXHomeDetailsCommentModel

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{
        @"list" : [ZXHomeDetailsCommentListModel class]
    };
}


@end


@implementation ZXHomeDetailsCommentListModel

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{
        @"replylist" : [ZXHomeDetailsCommentReplyListModel class]
    };
}


@end



@implementation ZXHomeDetailsCommentReplyListModel

@end

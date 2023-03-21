package com.zhixing.zxhy.repo

import com.tuanliu.common.net.ServiceCreator
import com.zhixing.zxhy.service.*
import retrofit2.http.Body

object ArticleDetailsRepo {

    //获取文章详情
    fun inforGetDetailData(inforDetailBody: InforDetailBody) =
        ServiceCreator.getService<ArticleDetailsService>().inforGetDetailData(inforDetailBody)

    //收藏 / 取消收藏
    fun informationFavActicle(inforFavActicleBody: InforFavActicleBody) =
        ServiceCreator.getService<ArticleDetailsService>().informationFavActicle(inforFavActicleBody)

    //点赞 / 取消点赞
    fun informationLikeArticle(informationLikeArticleBody: InforLikeArticleBody) =
        ServiceCreator.getService<ArticleDetailsService>().informationLikeArticle(informationLikeArticleBody)

    //获取评论列表
    fun inforGetCommentList(inforCommentListBody: InforCommentListBody) =
        ServiceCreator.getService<ArticleDetailsService>().inforGetCommentList(inforCommentListBody)

    //写评论
    fun inforCreateComment(createCommentBody: CreateCommentBody) =
        ServiceCreator.getService<ArticleDetailsService>().inforCreateComment(createCommentBody)

    //删除评论/回复
    fun inforDeleteComment(inforDeleteBody: InforDeleteBody) =
        ServiceCreator.getService<ArticleDetailsService>().inforDeleteComment(inforDeleteBody)

    //举报评论/回复
    fun inforReportComment(inforReportBody: InforReportBody) =
        ServiceCreator.getService<ArticleDetailsService>().inforReportComment(inforReportBody)

    //举报文章
    fun inforReportInfo(inforReportInfoBody: InforReportInfoBody) =
        ServiceCreator.getService<ArticleDetailsService>().inforReportInfo(inforReportInfoBody)

    //删除文章
    fun inforDeleteInfo(inforDeleteBody: InforDeleteBody) =
        ServiceCreator.getService<ArticleDetailsService>().inforDeleteInfo(inforDeleteBody)

}
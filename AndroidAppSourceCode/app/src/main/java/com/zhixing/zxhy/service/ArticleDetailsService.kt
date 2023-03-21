package com.zhixing.zxhy.service

import androidx.annotation.Keep
import com.google.gson.annotations.SerializedName
import com.zhixing.network.base.NetUrl
import com.zhixing.network.model.BaseResponse
import retrofit2.Call
import retrofit2.http.Body
import retrofit2.http.POST

interface ArticleDetailsService {

    //首页信息流详情
    @POST(NetUrl.INFORMATION_GET_DETAIL)
    fun inforGetDetailData(@Body inforDetailBody: InforDetailBody): Call<BaseResponse>

    //收藏 / 取消收藏
    @POST(NetUrl.INFORMATION_FAV_ARTICLE)
    fun informationFavActicle(@Body inforFavActicleBody: InforFavActicleBody): Call<BaseResponse>

    //点赞 / 取消点赞
    @POST(NetUrl.INFORMATION_LIKE_ARTICLE)
    fun informationLikeArticle(@Body informationLikeArticleBody: InforLikeArticleBody): Call<BaseResponse>

    //评论列表
    @POST(NetUrl.INFORMATION_GET_COMMENT_LIST)
    fun inforGetCommentList(@Body inforCommentListBody: InforCommentListBody): Call<BaseResponse>

    //写评论
    @POST(NetUrl.INFORMATION_CREATE_COMMENT)
    fun inforCreateComment(@Body createCommentBody: CreateCommentBody): Call<BaseResponse>

    //删除评论/回复
    @POST(NetUrl.INFORMATION_DELETE_COMMENT)
    fun inforDeleteComment(@Body inforDeleteBody: InforDeleteBody): Call<BaseResponse>

    //举报评论/回复
    @POST(NetUrl.INFORMATION_REPORT_COMMENT)
    fun inforReportComment(@Body inforReportBody: InforReportBody): Call<BaseResponse>

    //举报笔记
    @POST(NetUrl.INFORMATION_REPORT_INFO)
    fun inforReportInfo(@Body inforReportInfoBody: InforReportInfoBody): Call<BaseResponse>

    //删除笔记
    @POST(NetUrl.INFORMATION_DELETE_INFO)
    fun inforDeleteInfo(@Body inforDeleteBody: InforDeleteBody): Call<BaseResponse>

}

/**
 * 首页信息流详情
 */
@Keep
data class InforDetailBody(
    @SerializedName("id")
    val id: Int,
)

/**
 * 评论列表
 */
@Keep
data class InforCommentListBody(
    @SerializedName("id")
    val id: Int,
    @SerializedName("page")
    val page: Int,
    @SerializedName("limit")
    val limit: Int = 10,
)

/**
 * 写评论
 */
@Keep
data class CreateCommentBody(
    //文章id
    @SerializedName("articleid")
    val articleid: Int,
    //内容
    @SerializedName("content")
    val content: String,
    //给评论写评论
    @SerializedName("commentid")
    val commentid: Int?,
)

/**
 * 删除评论/回复
 */
@Keep
data class InforDeleteBody(
    @SerializedName("id")
    val id: Int,
)

/**
 * 举报评论/回复
 */
@Keep
data class InforReportBody(
    @SerializedName("id")
    val id: Int,
)

/**
 * 举报笔记
 */
@Keep
data class InforReportInfoBody(
    @SerializedName("id")
    val id: Int,
)

/**
 * 删除笔记
 */
@Keep
data class InforDeleteInfoBody(
    @SerializedName("id")
    val id: Int,
)
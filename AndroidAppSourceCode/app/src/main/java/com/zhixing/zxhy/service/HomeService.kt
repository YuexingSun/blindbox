package com.zhixing.zxhy.service

import androidx.annotation.Keep
import com.google.gson.annotations.SerializedName
import com.zhixing.network.base.NetUrl
import com.zhixing.network.model.BaseResponse
import retrofit2.Call
import retrofit2.http.Body
import retrofit2.http.POST

interface HomeService {

    //获取首页信息流弹出广告(大霸屏)
    @POST(NetUrl.INFORMATION_GET_POPUPPIC)
    fun getInformationPopupPic(@Body inforPopupPicBody: InforPopupPicBody): Call<BaseResponse>

    //获取首页信息流弹出广告(顶部广告)
    @POST(NetUrl.INFORMATION_GET_BANNERLIST)
    fun getInformationBannerList(@Body inforPopupPicBody: InforPopupPicBody): Call<BaseResponse>

    //获取客户端初始化信息
    @POST(NetUrl.GET_INIT_DATA)
    fun getInitData(): Call<BaseResponse>

    //获取首页信息流列表
    @POST(NetUrl.INFORMATION_GET_List)
    fun getInformationListData(@Body informationListBody: InformationListBody): Call<BaseResponse>

    //点赞 / 取消点赞
    @POST(NetUrl.INFORMATION_LIKE_ARTICLE)
    fun informationLikeArticle(@Body informationLikeArticleBody: InforLikeArticleBody): Call<BaseResponse>

}

/**
 * 广告 - 大霸屏的数据
 */
@Keep
data class InforPopupPicBody(
    @SerializedName("lat")
    val lat: Double? = null,
    @SerializedName("lng")
    val lng: Double? = null
)

/**
 * 获取首页信息流列表参数
 */
@Keep
data class InformationListBody(
    @SerializedName("lng")
    val lng: String?,
    @SerializedName("lat")
    val lat: String?,
    @SerializedName("page")
    val page: String?,
    @SerializedName("limit")
    val limit: Int = 5,
)

/**
 * 点赞/取消点赞
 */
@Keep
data class InforLikeArticleBody(
    @SerializedName("id")
    val id: Int,
)
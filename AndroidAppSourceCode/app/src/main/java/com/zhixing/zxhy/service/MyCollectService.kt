package com.zhixing.zxhy.service

import androidx.annotation.Keep
import com.google.gson.annotations.SerializedName
import com.zhixing.network.base.NetUrl
import com.zhixing.network.model.BaseResponse
import okhttp3.MultipartBody
import retrofit2.Call
import retrofit2.http.*

interface MyCollectService {

    //我收藏的文章
    @POST(NetUrl.INFORMATION_MY_FAVLIST)
    fun informationMyFavList(@Body inforMyFavListBody: InforMyFavListBody): Call<BaseResponse>

    //收藏 / 取消收藏
    @POST(NetUrl.INFORMATION_FAV_ARTICLE)
    fun informationFavActicle(@Body inforFavActicleBody: InforFavActicleBody): Call<BaseResponse>

}

/**
 * 获取首页信息流列表参数
 */
@Keep
data class InforMyFavListBody(
    @SerializedName("page")
    val page: String?,
    @SerializedName("limit")
    val limit: Int = 10,
)

/**
 * 收藏/取消收藏
 */
@Keep
data class InforFavActicleBody(
    @SerializedName("id")
    val id: Int,
)
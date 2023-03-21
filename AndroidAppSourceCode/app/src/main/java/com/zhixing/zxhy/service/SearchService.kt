package com.zhixing.zxhy.service

import androidx.annotation.Keep
import com.google.gson.annotations.SerializedName
import com.zhixing.network.base.NetUrl
import com.zhixing.network.model.BaseResponse
import retrofit2.Call
import retrofit2.http.Body
import retrofit2.http.POST

interface SearchService {

    //信息流搜索列表
    @POST(NetUrl.INFORMATION_SEARCH_LIST)
    fun inforSearchList(@Body searchListBody: SearchListBody): Call<BaseResponse>

}

/**
 * 信息流搜索列表body
 */
@Keep
data class SearchListBody(
    @SerializedName("title")
    val title: String,
    @SerializedName("page")
    val page: Int,
    @SerializedName("limit")
    val limit: Int = 10
)
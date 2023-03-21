package com.zhixing.zxhy.service

import androidx.annotation.Keep
import com.google.gson.annotations.SerializedName
import com.zhixing.network.base.NetUrl
import com.zhixing.network.model.BaseResponse
import retrofit2.Call
import retrofit2.http.Body
import retrofit2.http.POST

interface MeService {

    /**
     * 获取我的信息
     */
    @POST(NetUrl.User_GET_MY_DATA_LIST)
    fun getMyDataList(): Call<BaseResponse>

    //信息流搜索列表
    @POST(NetUrl.INFORMATION_MYINFO_LIST)
    fun inforMyInfoList(@Body myInfoListBody: MyInfoListBody): Call<BaseResponse>

}

/**
 * 我发布的文章列表body
 */
@Keep
data class MyInfoListBody(
    @SerializedName("page")
    val page: Int,
    @SerializedName("limit")
    val limit: Int = 10
)
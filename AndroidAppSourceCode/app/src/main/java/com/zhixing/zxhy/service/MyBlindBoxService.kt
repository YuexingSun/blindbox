package com.zhixing.zxhy.service

import androidx.annotation.Keep
import com.google.gson.annotations.SerializedName
import com.zhixing.network.base.NetUrl
import com.zhixing.network.model.BaseResponse
import retrofit2.Call
import retrofit2.http.Body
import retrofit2.http.Headers
import retrofit2.http.POST

interface MyBlindBoxService {

    //获取我的盲盒
    @POST(NetUrl.GET_MY_BOX_LIST)
    fun getMyBox(): Call<BaseResponse>

    //获取我的盲盒列表
    @Headers("Content-Type: application/json;charset=UTF-8")
    @POST(NetUrl.GET_MY_BOX_LIST)
    fun getMyBoxList(@Body myBoxListBody: MyBoxListBody): Call<BaseResponse>

}

/**
 * 获取我的盲盒列表参数
 */
@Keep
data class MyBoxListBody(
    @SerializedName("page")
    val page: String,
    @SerializedName("status")
    val status: String?
)
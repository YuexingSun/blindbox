package com.zhixing.zxhy.service

import com.google.gson.annotations.SerializedName
import com.zhixing.network.base.NetUrl
import com.zhixing.network.model.BaseResponse
import retrofit2.Call
import retrofit2.http.Body
import retrofit2.http.POST

interface BoxDetailService {

    //获取盲盒详情
    @POST(NetUrl.GET_BOX_DETAIL)
    fun getBoxDetail(@Body boxid: Boxid): Call<BaseResponse>

    //评价盲盒
    @POST(NetUrl.BOX_ENJOYBOX)
    fun getBoxEnjoyBox(@Body boxid: Boxid): Call<BaseResponse>

}

data class Boxid(
    //盲盒id
    @SerializedName("boxid")
    val boxid: Int,
    //当不满意时，此值为不满意的具体原因文字，如果多个，以竖线符号分隔
    @SerializedName("content")
    val content: String? = null
)
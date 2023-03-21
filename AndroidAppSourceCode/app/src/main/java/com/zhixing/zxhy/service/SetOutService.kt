package com.zhixing.zxhy.service

import com.google.gson.annotations.SerializedName
import com.zhixing.network.base.NetUrl
import com.zhixing.network.model.BaseResponse
import retrofit2.Call
import retrofit2.http.Body
import retrofit2.http.POST

interface SetOutService {

    //评价盲盒
    @POST(NetUrl.BOX_ENJOYBOX)
    fun getBoxEnjoyBox(@Body boxid: Boxid): Call<BaseResponse>

    //盲盒到达
    @POST(NetUrl.ARRIVED_BOX)
    fun arrivedBox(@Body boxid: Boxid): Call<BaseResponse>

    //中止盲盒
    @POST(NetUrl.BOX_CANCEL_BOX)
    fun boxCancelBox(@Body boxid: Boxid): Call<BaseResponse>

}
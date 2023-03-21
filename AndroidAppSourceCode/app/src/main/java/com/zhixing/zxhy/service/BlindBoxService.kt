package com.zhixing.zxhy.service

import androidx.annotation.Keep
import com.google.gson.annotations.SerializedName
import com.zhixing.network.base.NetUrl
import com.zhixing.network.model.BaseResponse
import com.zhixing.zxhy.view_model.BoxGetOneData
import com.zhixing.zxhy.view_model.StartBox
import retrofit2.Call
import retrofit2.http.Body
import retrofit2.http.POST

interface BlindBoxService {

    //获取盲盒待答问题
    @POST(NetUrl.GET_BOX_QUES_LIST)
    fun getBoxQuesList(@Body boxQuesListRequest: BoxQuesListRequest = BoxQuesListRequest(1)): Call<BaseResponse>

    //查询是否有未开启和进行中的盲盒
    @POST(NetUrl.BOX_CHECK_BEING_BOX)
    fun checkBeingBox(): Call<BaseResponse>

    //获取盲盒
    @POST(NetUrl.BOX_GET_ONE)
    fun boxGetOne(@Body boxGetOneData: BoxGetOneData): Call<BaseResponse>

    //获取盲盒详情
    @POST(NetUrl.GET_BOX_DETAIL)
    fun getBoxDetail(@Body boxid: Boxid): Call<BaseResponse>

    //开始一个盲盒
    @POST(NetUrl.START_BOX)
    fun startBox(@Body startBox: StartBox): Call<BaseResponse>

    //评价盲盒
    @POST(NetUrl.BOX_ENJOYBOX)
    fun getBoxEnjoyBox(@Body boxid: Boxid): Call<BaseResponse>

    //获取可选分类
    @POST(NetUrl.BOX_CATE_TYPES)
    fun getBoxCateTypes(@Body boxCateTypesBody: BoxCateTypesBody): Call<BaseResponse>

}

@Keep
data class BoxQuesListRequest(
    @SerializedName("typeid")
    val typeid: Int
)

/**
 * 可选分类body
 */
@Keep
data class BoxCateTypesBody(
    @SerializedName("lng")
    val lng: Double? = null,
    @SerializedName("lat")
    val lat: Double? = null
)
package com.zhixing.zxhy.service

import com.google.gson.annotations.SerializedName
import com.zhixing.network.base.NetUrl
import com.zhixing.network.model.BaseResponse
import retrofit2.Call
import retrofit2.http.Body
import retrofit2.http.Header
import retrofit2.http.Headers
import retrofit2.http.POST

interface PerfectDataOneService {

    /**
     * 提交新用户基本信息一
     */
    @Headers("Content-Type: application/json;charset=UTF-8")
    @POST(NetUrl.SUBMIT_BASE_DATA_ONE)
    fun submitBaseDataOne(
        @Header("token") token: String,
        @Body baseData: SubmitBaseDataOne
    ): Call<BaseResponse>

}

/**
 * 提交用户基本表单One
 */
data class SubmitBaseDataOne(
    @SerializedName("name")
    val name: String,
    //年龄 yyyy-MM
    @SerializedName("age")
    val age: String,
    //性别 1男生 0女生
    @SerializedName("sex")
    val sex: String
)
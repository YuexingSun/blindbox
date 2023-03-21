package com.zhixing.zxhy.service

import androidx.annotation.Keep
import com.google.gson.annotations.SerializedName
import com.zhixing.network.base.NetUrl
import com.zhixing.network.model.BaseResponse
import retrofit2.Call
import retrofit2.http.*

interface LoginMainService {

    @Headers("Content-Type: application/json;charset=UTF-8")
    @POST(NetUrl.LOGIN_BY_MOB)
    fun loginByMob(@Body loginByRequest: LoginByRequest): Call<BaseResponse>

}

@Keep
data class LoginByRequest(
    @SerializedName("code")
    val code: String
)
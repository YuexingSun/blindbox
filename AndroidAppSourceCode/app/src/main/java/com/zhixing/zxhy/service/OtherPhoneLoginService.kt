package com.zhixing.zxhy.service

import com.google.gson.annotations.SerializedName
import com.zhixing.network.base.NetUrl
import com.zhixing.network.model.BaseResponse
import retrofit2.Call
import retrofit2.http.Body
import retrofit2.http.Headers
import retrofit2.http.POST

interface OtherPhoneLoginService {

    @POST(NetUrl.GET_SAFE_SMSCODE)
    fun getSafeSmsCode(@Body safeCodeData: SafeCodeData): Call<BaseResponse>

    /**
     * 注册/登录-通过短信验证码
     */
    @Headers("Content-Type: application/json;charset=UTF-8")
    @POST(NetUrl.LOGIN_BY_SMS_CODE)
    fun getLoginBySmsCode(@Body loginBySmsCodeData: LoginBySmsCodeData): Call<BaseResponse>

}

data class SmsCodeData(
    @SerializedName("phone")
    val phone: String
)

data class LoginBySmsCodeData(
    @SerializedName("phone")
    val phone: String,
    @SerializedName("code")
    val code: String
)

data class SafeCodeData(
    @SerializedName("phone")
    val phone: String,
    @SerializedName("ticket")
    val ticket: String,
    @SerializedName("randstr")
    val randstr: String
)
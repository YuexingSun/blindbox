package com.zhixing.zxhy.service

import com.google.gson.annotations.SerializedName
import com.zhixing.network.base.NetUrl
import com.zhixing.network.model.BaseResponse
import retrofit2.Call
import retrofit2.http.Body
import retrofit2.http.Headers
import retrofit2.http.POST

interface SetUserProfileService {

    /**
     * 设置用户资料信息
     */
    @Headers("Content-Type: application/json;charset=UTF-8")
    @POST(NetUrl.SET_USER_PROFILE)
    fun setUserProfile(@Body dataChange: ChangeUserProfileData): Call<BaseResponse>

    /**
     * 修改手机号码
     */
    @Headers("Content-Type: application/json;charset=UTF-8")
    @POST(NetUrl.RESET_PHONE_BY_SMS_CODE)
    fun setUserNewPhone(@Body data: LoginBySmsCodeData): Call<BaseResponse>

}

/**
 * 用户资料信息
 */
data class ChangeUserProfileData(
    //头像
    @SerializedName("headimg")
    val headimg: String? = null,
    //昵称
    @SerializedName("nickname")
    val nickname: String? = null,
    //性别
    @SerializedName("sex")
    val sex: String? = null,
    //年龄
    @SerializedName("age")
    val age: String? = null,
    //通知开关
    @SerializedName("notifystatus")
    val notifystatus: String? = null
)
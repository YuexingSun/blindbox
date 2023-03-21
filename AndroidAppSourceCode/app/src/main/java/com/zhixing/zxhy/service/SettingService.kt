package com.zhixing.zxhy.service

import com.zhixing.network.base.NetUrl
import com.zhixing.network.model.BaseResponse
import okhttp3.MultipartBody
import retrofit2.Call
import retrofit2.http.*

interface SettingService {

    //获取用户资料信息
    @POST(NetUrl.GET_USER_PROFILE)
    fun getUserProfile(): Call<BaseResponse>

    //退出登录
    @POST(NetUrl.USER_LOGOUT)
    fun userLogout(): Call<BaseResponse>

}
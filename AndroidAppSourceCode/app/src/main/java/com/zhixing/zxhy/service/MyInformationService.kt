package com.zhixing.zxhy.service

import com.zhixing.network.base.NetUrl
import com.zhixing.network.model.BaseResponse
import okhttp3.MultipartBody
import retrofit2.Call
import retrofit2.http.*

interface MyInformationService {

    //获取用户资料信息
    @POST(NetUrl.GET_USER_PROFILE)
    fun getUserProfile(): Call<BaseResponse>

    //上传文件
    @Multipart
    @POST(NetUrl.UPLOAD_FILE)
    fun uploadFile(@Part file: MultipartBody.Part): Call<BaseResponse>

    /**
     * 设置用户资料信息
     */
    @Headers("Content-Type: application/json;charset=UTF-8")
    @POST(NetUrl.SET_USER_PROFILE)
    fun setUserProfile(@Body dataChange: ChangeUserProfileData): Call<BaseResponse>

}
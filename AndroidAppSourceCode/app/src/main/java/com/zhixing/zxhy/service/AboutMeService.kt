package com.zhixing.zxhy.service

import com.zhixing.network.base.NetUrl
import com.zhixing.network.model.BaseResponse
import retrofit2.Call
import retrofit2.http.Body
import retrofit2.http.POST

interface AboutMeService {

    //获取客户端初始化信息
    @POST(NetUrl.GET_INIT_DATA)
    fun getInitData(): Call<BaseResponse>

}
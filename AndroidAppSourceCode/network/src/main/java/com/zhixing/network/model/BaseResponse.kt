package com.zhixing.network.model

import androidx.annotation.Keep

/**
 * 服务器返回的数据基类
 */
@Keep
data class BaseResponse(

    //接口数据
    val data: Any?,

    //接口状态码
    val code: Int,

    //接口出错消息
    val msg: String = ""
)
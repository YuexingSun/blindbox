package com.zhixinhuixue.library.net.entity.base


/**
 * 服务器返回的数据基类
 * @author will
 */
data class ApiResponse<T>(
    /**
     * 接口数据
     */
    var data: T,
    /**
     * 接口状态码
     */
    var code: Int = -1,
    /**
     * 接口出错消息
     */
    var message: String = ""
)
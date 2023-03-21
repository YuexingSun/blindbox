package com.tuanliu.common.util

import com.tuanliu.common.net.CommonConstant
import okhttp3.Interceptor
import okhttp3.Response
import retrofit2.http.Headers
import java.io.IOException
import kotlin.jvm.Throws

/**
 * 自定义头部参数拦截器，传入heads
 */
class MyHeadInterceptor : Interceptor {

    @Throws(IOException::class)
    override fun intercept(chain: Interceptor.Chain): Response {
        val builder = chain.request().newBuilder()
        val token = SpUtilsMMKV.getString(CommonConstant.TOKEN) ?: ""
        if (token.isNotBlank()) {
            builder.addHeader("token", token)
        }
        builder.addHeader("device", "Android")
        return chain.proceed(builder.build())
    }

}
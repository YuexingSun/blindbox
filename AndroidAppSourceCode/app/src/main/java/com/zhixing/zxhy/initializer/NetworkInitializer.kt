package com.zhixing.zxhy.initializer

import android.content.Context
import android.util.Log
import androidx.startup.Initializer
import com.zhixing.network.base.NetUrl
import com.tuanliu.common.net.ServiceCreator
import rxhttp.RxHttpPlugins

class NetworkInitializer : Initializer<Boolean> {

    override fun create(context: Context): Boolean {
        Log.d("初始化", "初始化Retrofit2")
        ServiceCreator.initConfig(NetUrl.BASE_URL)

        Log.d("初始化", "初始化RxHttp")
        RxHttpPlugins.init(ServiceCreator.mOkClient)
        return true
    }

    override fun dependencies(): List<Class<out Initializer<*>>> {
        return listOf(TimberInitializer::class.java)
    }

}
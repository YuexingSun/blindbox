package com.zhixing.zxhy.initializer

import android.content.Context
import androidx.startup.Initializer
import com.tuanliu.common.base.appContext
import com.tuanliu.common.listener.KtxActivityLifecycleCallbacks
import timber.log.Timber

class AppLifecycleInitializer : Initializer<Boolean> {
    override fun create(context: Context): Boolean {
        Timber.v("初始化RxHttp")
        //注册全局的Activity生命周期管理
        appContext.registerActivityLifecycleCallbacks(KtxActivityLifecycleCallbacks())
        return true
    }

    override fun dependencies(): List<Class<out Initializer<*>>> {
        return listOf(TimberInitializer::class.java)
    }
}
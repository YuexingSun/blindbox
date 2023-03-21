package com.tuanliu.common.base

import android.app.Application
import android.content.Context
import android.util.Log
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.ViewModelStore
import androidx.lifecycle.ViewModelStoreOwner
import com.tuanliu.common.core.EventViewModel
import com.tuanliu.common.ext.currentProcessName
import com.zhixing.autosize.AutoSizeConfig

//全局上下文
val appContext: BaseApplication by lazy { BaseApplication.instance }

//界面通信ViewModel
val eventViewModel: EventViewModel by lazy { BaseApplication.eventInstance }

open class BaseApplication : Application(), ViewModelStoreOwner {

    companion object {
        lateinit var instance: BaseApplication
        lateinit var eventInstance: EventViewModel
    }

    private lateinit var mAppViewModelStore: ViewModelStore

    private var mFactory: ViewModelProvider.Factory? = null

    override fun attachBaseContext(base: Context?) {
        Log.v("BaseApplication", "attachBaseContext")
        super.attachBaseContext(base)
        instance = this
    }

    override fun onCreate() {
        super.onCreate()
        mAppViewModelStore = ViewModelStore()
        eventInstance = getAppViewModelProvider().get(EventViewModel::class.java)

        val processName = currentProcessName
        if (processName == packageName) {
            // 主进程初始化
            onMainProcessInit()
        } else {
            // 其他进程初始化
            processName?.let { onOtherProcessInit(it) }
        }

        /**
         * 是否屏蔽字体大小对AndroidAutoSize的影响
         */
        AutoSizeConfig.getInstance().isExcludeFontScale = true
    }

    open fun onMainProcessInit() {

    }

    /**
     * 其他进程初始化，[processName] 进程名
     */
    open fun onOtherProcessInit(processName: String) {}


    /**
     * 获取一个全局的ViewModel
     */
    fun getAppViewModelProvider(): ViewModelProvider {
        return ViewModelProvider(this, this.getAppFactory())
    }

    private fun getAppFactory(): ViewModelProvider.Factory {
        if (mFactory == null) {
            mFactory = ViewModelProvider.AndroidViewModelFactory.getInstance(this)
        }
        return mFactory as ViewModelProvider.Factory
    }

    override fun getViewModelStore(): ViewModelStore {
        return mAppViewModelStore
    }
}
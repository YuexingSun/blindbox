package com.zhixing.zxhy.initializer

import android.content.Context
import android.util.Log
import androidx.startup.Initializer
import com.zhixing.zxhy.BuildConfig
import timber.log.Timber
import timber.log.Timber.DebugTree

/**
 * Timber初始化
 * @author will
 */
class TimberInitializer : Initializer<Boolean> {

    override fun create(context: Context): Boolean {
        Log.v(TAG, "初始化Timber")
        if (BuildConfig.DEBUG) {
            val tree = DebugTree()
            Timber.plant(tree)
        }
        return BuildConfig.DEBUG
    }

    override fun dependencies(): List<Class<out Initializer<*>>> {
        return emptyList()
    }

    companion object {
        const val TAG: String = "TimberInitializer"
    }
}
package com.zhixing.zxhy.initializer

import android.content.Context
import androidx.startup.Initializer
import com.tencent.mmkv.MMKV
import timber.log.Timber

/**
 * MMKV初始化
 * @author will
 */
class MmkvInitializer : Initializer<String> {
    override fun create(context: Context): String {
        Timber.v("初始化MMKV")
        val rootDir: String = MMKV.initialize(context)
        Timber.v("MMKV初始化根目录: %s", rootDir)
        return rootDir
    }

    override fun dependencies(): List<Class<out Initializer<*>>> {
        return listOf(TimberInitializer::class.java)
    }
}
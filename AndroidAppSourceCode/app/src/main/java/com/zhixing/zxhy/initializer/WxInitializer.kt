package com.zhixing.zxhy.initializer

import android.content.Context
import android.view.Gravity
import androidx.startup.Initializer
import com.hjq.toast.ToastUtils
import com.zhixing.zxhy.R
import com.scwang.smart.refresh.footer.ClassicsFooter
import com.scwang.smart.refresh.header.ClassicsHeader
import com.scwang.smart.refresh.layout.SmartRefreshLayout
import com.tuanliu.common.base.appContext
import com.tuanliu.common.ext.getDimensionExt
import com.tuanliu.common.ext.px2dp
import com.zhixing.zxhy.WxApi
import timber.log.Timber

/**
 * 微信sdk初始化
 */
class WxInitializer : Initializer<Boolean> {
    override fun create(context: Context): Boolean {
        Timber.v("微信sdk初始化")
        WxApi.regToWx()
        return true
    }

    override fun dependencies(): List<Class<out Initializer<*>>> {
        return emptyList()
    }
}
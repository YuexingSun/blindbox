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
import timber.log.Timber

/**
 * 控件初始化
 */
class WidgetInitializer : Initializer<Boolean> {
    override fun create(context: Context): Boolean {
        Timber.v("SmartRefreshLayout初始化")
        // 设置全局的Header构建器
        Timber.v("设置全局的Header构建器")
        SmartRefreshLayout.setDefaultRefreshHeaderCreator { ctx, layout ->
            //全局设置主题颜色
            layout.setPrimaryColorsId(R.color.white)
            //.setTimeFormat(new DynamicTimeFormat("更新于 %s"));//指定为经典Header，默认是 贝塞尔雷达Header
            ClassicsHeader(ctx)
                    //是否显示时间
                .setEnableLastTime(false)
        }
        //设置全局的Footer构建器
        Timber.v("设置全局的Footer构建器")
        SmartRefreshLayout.setDefaultRefreshFooterCreator { ctx, layout ->
            layout.setPrimaryColorsId(R.color.white)
            //指定为经典Footer，默认是 BallPulseFooter
            ClassicsFooter(ctx).setDrawableSize(20f)
        }
        //初始化吐司 这个吐司必须要主线程中初始化
        Timber.v("初始化Toast")
        ToastUtils.init(appContext)
        ToastUtils.setGravity(
            Gravity.BOTTOM,
            0,
            px2dp(getDimensionExt(R.dimen.dp_100))
        )
        return true
    }

    override fun dependencies(): List<Class<out Initializer<*>>> {
        return listOf(TimberInitializer::class.java)
    }
}
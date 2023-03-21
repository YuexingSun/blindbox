package org.flower.l.library.immerBar

import android.app.Activity
import android.view.View
import com.gyf.immersionbar.ktx.immersionBar

/**
 * 状态栏/导航栏设置
 */
fun Activity.immersionBarInit(immerData: ImmerData, view: View? = null) {
    this.immersionBar {
        //状态栏/导航栏颜色
        if (immerData.tranStatusBar) transparentStatusBar()
        else statusBarColor(immerData.statusBarColor)
        if (immerData.tranNavigationBar) transparentNavigationBar()
        else {
            navigationBarColor(immerData.navigationBarColor)
            // 有导航栏的情况下，Activity是否全屏显示
            fullScreen(false)
        }

        if (!immerData.tranStatusBar && !immerData.tranNavigationBar)
            // 状态栏字体和导航栏内容自动变色，必须指定状态栏颜色和导航栏颜色才可以自动变色
            autoDarkModeEnable(true, 0.2f)

        //状态栏字体颜色
        statusBarDarkFont(immerData.statusBarDark)

        view?.apply {
            //顶部状态栏遮挡标题栏的问题
            statusBarView(this)
        }

        init()
    }
}
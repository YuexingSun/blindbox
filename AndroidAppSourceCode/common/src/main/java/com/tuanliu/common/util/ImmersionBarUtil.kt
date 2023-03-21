package com.tuanliu.common.util

import androidx.annotation.ColorRes
import androidx.fragment.app.Fragment
import com.gyf.immersionbar.ktx.immersionBar

object ImmersionBarUtil {

    /**
     * 改变导航栏颜色
     */
    fun Fragment.changeNaviColor(@ColorRes color: Int) {
        immersionBar {
            navigationBarColor(color)
        }
    }

}
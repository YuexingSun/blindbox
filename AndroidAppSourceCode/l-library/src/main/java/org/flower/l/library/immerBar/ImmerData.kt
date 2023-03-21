package org.flower.l.library.immerBar

import androidx.annotation.ColorRes
import org.flower.l.library.R

data class ImmerData(
    //是否透明状态栏
    val tranStatusBar: Boolean = false,
    //状态栏内容颜色 - 默认白色
    @ColorRes val statusBarColor: Int = R.color.white,
    //状态栏字体是否为深色
    val statusBarDark: Boolean = false,
    //是否透明导航栏
    val tranNavigationBar: Boolean = false,
    //导航栏颜色 - 默认白色
    @ColorRes val navigationBarColor: Int = R.color.white
)

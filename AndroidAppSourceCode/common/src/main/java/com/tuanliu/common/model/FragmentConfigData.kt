package com.tuanliu.common.model

import androidx.annotation.ColorRes
import com.tuanliu.common.R

/**
 * Fragment配置
 */
data class FragmentConfigData(
    //是否显示toolbar - 默认false不显示
    val showToolbar: Boolean = false,
    //是否透明状态栏
    val transparentStatusBar: Boolean = false,
    //状态栏内容颜色 - 默认黑色
    val statusBarMode: StatusBarMode = StatusBarMode.STATUS_BAR_MODE_DARK,
    //是否透明导航栏
    val transparentNavigationBar: Boolean = false,
    //导航栏颜色 - 默认白色
    @ColorRes val navigationBarColor: Int = R.color.colorWhite
)
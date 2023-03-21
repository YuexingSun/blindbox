package com.tuanliu.common.ext

import androidx.fragment.app.findFragment
import androidx.navigation.fragment.NavHostFragment.findNavController
import com.tuanliu.common.R
import com.tuanliu.common.customView.CustomToolBar

/**
 * 初始化有返回键的toolbar
 */
fun CustomToolBar.initBack(
    titleStr: String = "标题",
    endImg: Int? = null,
    strText: String? = null,
    backImg: Int = R.drawable.ic_back,
    defaultBackListener: Boolean = true,
    onBack: ((toolbar: CustomToolBar) -> Unit) ?= null,
): CustomToolBar {
    this.setCenterTitle(titleStr)
    this.setEndImage(endImg)
    this.setEndTextTitle(strText)
    this.getBaseToolBar().setNavigationIcon(backImg)
    if (defaultBackListener) {
        this.getBaseToolBar().setNavigationOnClickListener {
            if (onBack == null) {
                //默认的返回按钮的方法
                findNavController(it.findFragment()).navigateUp()
            } else onBack.invoke(this)
        }
    } else {
        this.getBaseToolBar().setNavigationOnClickListener {
            onBack?.invoke(this)
        }
    }
    return this
}




package com.tuanliu.common.ext

import android.os.Bundle
import android.view.View
import androidx.annotation.IdRes
import androidx.annotation.Nullable
import androidx.fragment.app.Fragment
import androidx.fragment.app.findFragment
import androidx.navigation.*
import androidx.navigation.fragment.NavHostFragment
import androidx.navigation.fragment.NavHostFragment.findNavController
import androidx.navigation.fragment.findNavController
import java.lang.Exception

val navOptions = NavOptions.Builder()
    //进入动画
    .setEnterAnim(com.tuanliu.common.R.anim.right_in)
    //退出动画
    .setExitAnim(com.tuanliu.common.R.anim.left_out)
    //弹出进入动画
    .setPopEnterAnim(com.tuanliu.common.R.anim.left_in)
    //弹出退出动画
    .setPopExitAnim(com.tuanliu.common.R.anim.right_out)
    .build()

/**
 * 扩展函数 带入场出场动画的跳转
 */
fun Fragment.animationNav(@IdRes resId: Int) {

    val controller = findNavController()
    val destination = controller.currentDestination
    val isNavOptions = destination?.getAction(resId)?.navOptions

    val navOptions = isNavOptions?.popUpTo?.let {
        NavOptions.Builder()
            //进入动画
            .setEnterAnim(com.tuanliu.common.R.anim.right_in)
            //退出动画
            .setExitAnim(com.tuanliu.common.R.anim.left_out)
            //弹出进入动画
            .setPopEnterAnim(com.tuanliu.common.R.anim.left_in)
            //弹出退出动画
            .setPopExitAnim(com.tuanliu.common.R.anim.right_out)
            .setPopUpTo(it, isNavOptions.isPopUpToInclusive)
            .build()
    }

    findNavController(this).navigate(resId, null, navOptions)
}

/**
 * 扩展函数 带入场出场动画的跳转
 */
fun Fragment.animationNav(@IdRes resId: Int, @Nullable args: Bundle) {

    val controller = findNavController()
    val destination = controller.currentDestination
    val isNavOptions = destination?.getAction(resId)?.navOptions

    val navOptions = isNavOptions?.popUpTo?.let {
        NavOptions.Builder()
            //进入动画
            .setEnterAnim(com.tuanliu.common.R.anim.right_in)
            //退出动画
            .setExitAnim(com.tuanliu.common.R.anim.left_out)
            //弹出进入动画
            .setPopEnterAnim(com.tuanliu.common.R.anim.left_in)
            //弹出退出动画
            .setPopExitAnim(com.tuanliu.common.R.anim.right_out)
            .setPopUpTo(it, isNavOptions.isPopUpToInclusive)
            .build()
    }

    findNavController(this).navigate(resId, args, navOptions)
}

/**
 * 扩展函数 带入场出场动画的跳转
 */
fun View.animationNav(@IdRes resId: Int) {

    val controller = findNavController(this.findFragment())
    val destination = controller.currentDestination
    val isNavOptions = destination?.getAction(resId)?.navOptions

    val navOptions = isNavOptions?.popUpTo?.let {
        NavOptions.Builder()
            //进入动画
            .setEnterAnim(com.tuanliu.common.R.anim.right_in)
            //退出动画
            .setExitAnim(com.tuanliu.common.R.anim.left_out)
            //弹出进入动画
            .setPopEnterAnim(com.tuanliu.common.R.anim.left_in)
            //弹出退出动画
            .setPopExitAnim(com.tuanliu.common.R.anim.right_out)
            .setPopUpTo(it, isNavOptions.isPopUpToInclusive)
            .build()
    }

    findNavController(this.findFragment()).navigate(resId, null, navOptions)

}

/**
 * 扩展函数 带入场出场动画的跳转
 */
fun View.animationNav(@IdRes resId: Int, @Nullable args: Bundle) {

    val controller = findNavController(this.findFragment())
    val destination = controller.currentDestination
    val isNavOptions = destination?.getAction(resId)?.navOptions

    val navOptions = isNavOptions?.popUpTo?.let {
        NavOptions.Builder()
            //进入动画
            .setEnterAnim(com.tuanliu.common.R.anim.right_in)
            //退出动画
            .setExitAnim(com.tuanliu.common.R.anim.left_out)
            //弹出进入动画
            .setPopEnterAnim(com.tuanliu.common.R.anim.left_in)
            //弹出退出动画
            .setPopExitAnim(com.tuanliu.common.R.anim.right_out)
            .setPopUpTo(it, isNavOptions.isPopUpToInclusive)
            .build()
    }

    findNavController(this.findFragment()).navigate(resId, args, navOptions)
}

var lastNavTime = 0L

/**
 * Navigation跳转简写 扩展函数
 */
fun Fragment.nav(): NavController {
    return NavHostFragment.findNavController(this)
}

fun nav(view: View): NavController {
    return Navigation.findNavController(view)
}

/**
 *  防止短时间内多次快速跳转Fragment出现的bug
 *  @param resId 跳转的action id
 *  @param bundle 传递的参数
 *  @param interval 多少毫秒内不可重复点击 默认0.5秒
 */
fun NavController.navigateAction(resId: Int, bundle: Bundle? = null, interval: Long = 500) {
    val currentTime = System.currentTimeMillis()
    if (currentTime >= lastNavTime + interval) {
        lastNavTime = currentTime
        try {
            navigate(resId, bundle)
        } catch (e: Exception) {
            //防止当fragment中action的duration设置为0时，连续点击两个不同的跳转会导致崩溃
        }
    }
}
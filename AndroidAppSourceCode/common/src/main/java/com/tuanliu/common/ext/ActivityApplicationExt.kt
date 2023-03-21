package com.tuanliu.common.ext

import android.annotation.SuppressLint
import android.app.Activity
import android.app.Application
import android.content.Context
import android.view.inputmethod.InputMethodManager
import java.lang.reflect.InvocationTargetException

/**
 * 通过反射拿到Application实例
 */
fun getApplicationByReflect(): Application {
    try {
        @SuppressLint("PrivateApi") val activityThread =
            Class.forName("android.app.ActivityThread")
        val thread = activityThread.getMethod("currentActivityThread").invoke(null)
        val app = activityThread.getMethod("getApplication").invoke(thread)
            ?: throw NullPointerException("u should init first")
        return app as Application
    } catch (e: NoSuchMethodException) {
        e.printStackTrace()
    } catch (e: IllegalAccessException) {
        e.printStackTrace()
    } catch (e: InvocationTargetException) {
        e.printStackTrace()
    } catch (e: ClassNotFoundException) {
        e.printStackTrace()
    }
    throw NullPointerException("u should init first")
}

/**
 * 隐藏输入面板
 *
 * @param activity
 * @return true 成功隐藏面板，false 没有隐藏面板或者没有面板可以隐藏
 */
fun Activity.hideSoftInputFromWindow(): Boolean {
    val imm = this.getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
    return imm.hideSoftInputFromWindow(this.window.decorView.windowToken, 0)
}
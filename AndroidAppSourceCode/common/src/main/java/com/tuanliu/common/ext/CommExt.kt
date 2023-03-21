package com.tuanliu.common.ext

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.content.res.Configuration
import android.graphics.drawable.Drawable
import android.net.Uri
import android.os.Bundle
import android.text.TextUtils
import android.view.MotionEvent
import android.view.View
import android.view.inputmethod.InputMethodManager
import android.widget.EditText
import androidx.annotation.NonNull
import androidx.core.content.ContextCompat
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.hjq.toast.ToastUtils
import com.tuanliu.common.base.appContext
import com.tuanliu.common.util.GsonUtils
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

fun Any?.toJsonStr(): String {
    return GsonUtils.toJson(this)
}

fun Any?.toast() {
    ToastUtils.show(this)
}

/**
 * 关闭键盘
 */
fun EditText.hideKeyboard() {
    val imm = appContext.getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
    imm.hideSoftInputFromWindow(
        this.windowToken,
        InputMethodManager.HIDE_IMPLICIT_ONLY
    )
}

/**
 * 打开键盘
 */
fun EditText.openKeyboard() {
    this.apply {
        isFocusable = true
        isFocusableInTouchMode = true
        requestFocus()
    }
    val inputManager =
        appContext.getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
    inputManager.showSoftInput(this, 0)
}

/**
 * 关闭键盘焦点
 */
fun Activity.hideOffKeyboard() {
    val imm = this.getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
    if (imm.isActive && this.currentFocus != null) {
        if (this.currentFocus?.windowToken != null) {
            imm.hideSoftInputFromWindow(
                this.currentFocus?.windowToken,
                InputMethodManager.HIDE_NOT_ALWAYS
            )
        }
    }
}

fun toStartActivity(@NonNull clz: Class<*>) {
    val intent = Intent(appContext, clz)
    intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
    appContext.startActivity(intent)
}

fun toStartActivity(@NonNull clz: Class<*>, @NonNull bundle: Bundle) {
    val intent = Intent(appContext, clz)
    intent.apply {
        putExtras(bundle)
        flags = Intent.FLAG_ACTIVITY_NEW_TASK
    }
    appContext.startActivity(intent)
}

fun toStartActivity(
    activity: Activity,
    @NonNull clz: Class<*>,
    code: Int,
    @NonNull bundle: Bundle
) {
    activity.startActivityForResult(Intent(appContext, clz).putExtras(bundle), code)
}

fun toStartActivity(
    fragment: Fragment,
    @NonNull clz: Class<*>,
    code: Int,
    @NonNull bundle: Bundle
) {
    fragment.startActivityForResult(Intent(appContext, clz).putExtras(bundle), code)
}

fun toStartActivity(activity: Activity, @NonNull intent: Intent, code: Int) {
    activity.startActivityForResult(intent, code)
}

fun toStartActivity(
    @NonNull type: Any,
    @NonNull clz: Class<*>,
    code: Int,
    @NonNull bundle: Bundle
) {
    if (type is Activity) {
        toStartActivity(type, clz, code, bundle)
    } else if (type is Fragment) {
        toStartActivity(type, clz, code, bundle)
    }
}

/**
 * 横竖屏
 */
fun isLandscape(context: Context) =
    context.resources.configuration.orientation == Configuration.ORIENTATION_LANDSCAPE

/**
 * 应用商店
 */
fun gotoStore() {
    val uri =
        Uri.parse("market://details?id=" + appContext.packageName)
    val goToMarket = Intent(Intent.ACTION_VIEW, uri)
    try {
        goToMarket.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        appContext.startActivity(goToMarket)
    } catch (ignored: ActivityNotFoundException) {
    }
}

/**
 * 显示软键盘
 * @param view
 */
fun showKeyboard(view: View) {
    if (view.requestFocus()) {
        val imm = view.context
            .getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
        imm.showSoftInput(view, InputMethodManager.SHOW_IMPLICIT)
    }
}

/**
 * 隐藏软键盘
 * @param view
 */
fun hintKeyBoards(view: View) {
    val manager = view.context
        .getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
    manager.hideSoftInputFromWindow(view.windowToken, 0)
}

/**
 * 判定当前是否需要隐藏
 */
fun isShouldHideKeyBord(v: View?, ev: MotionEvent): Boolean {
    if (v != null && v is EditText) {
        val l = intArrayOf(0, 0)
        v.getLocationInWindow(l)
        val left = l[0]
        val top = l[1]
        val bottom: Int = top + v.getHeight()
        val right: Int = left + v.getWidth()
        return !(ev.x > left && ev.x < right && ev.y > top && ev.y < bottom)
    }
    return false
}

/**
 * 字符串相等
 */
fun isEqualStr(value: String?, defaultValue: String?) =
    if (value.isNullOrEmpty() || defaultValue.isNullOrEmpty()) false else TextUtils.equals(
        value,
        defaultValue
    )

/**
 * Int类型相等
 *
 */
fun isEqualIntExt(value: Int, defaultValue: Int) = value == defaultValue

fun getDrawableExt(id: Int): Drawable? = ContextCompat.getDrawable(appContext, id)

fun getColorExt(id: Int): Int = ContextCompat.getColor(appContext, id)

fun getStringExt(id: Int) = appContext.resources.getString(id)

fun getStringArrayExt(id: Int): Array<String> = appContext.resources.getStringArray(id)

fun getIntArrayExt(id: Int) = appContext.resources.getIntArray(id)

fun getDimensionExt(id: Int) = appContext.resources.getDimension(id)



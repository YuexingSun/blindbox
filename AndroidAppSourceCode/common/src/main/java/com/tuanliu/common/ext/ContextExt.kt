package com.tuanliu.common.ext

import android.content.Context
import androidx.annotation.ColorRes
import androidx.annotation.DrawableRes
import androidx.core.content.ContextCompat

/**
 * 获取颜色资源
 */
fun Context.getResColor(@ColorRes color: Int): Int = ContextCompat.getColor(this, color)

/**
 * 获取资源
 */
fun Context.getDrawable(@DrawableRes drawable: Int) = ContextCompat.getDrawable(this, drawable)
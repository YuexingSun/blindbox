package com.tuanliu.common.util

import android.os.Build

/**
 * 以更加可读的方式提供Android系统版本号的判断方法。
 *
 */
object AndroidVersion {

    /**
     * 判断当前手机系统版本API是否是16及以上
     * @return 16及以上返回true，否则返回false
     */
    fun hasJellyBean(): Boolean {
        return Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN
    }

    /**
     * 判断当前手机系统版本API是否是17及以上
     * @return 17及以上返回true，否则返回false
     */
    fun hasJellyBeanMR1(): Boolean {
        return Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1
    }

    /**
     * 判断当前手机系统版本API是否是18及以上
     * @return 18及以上返回true，否则返回false
     */
    fun hasJellyBeanMR2(): Boolean {
        return Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR2
    }

    /**
     * 判断当前手机系统版本API是否是19及以上
     * @return 19及以上返回true，否则返回false
     */
    fun hasKitkat(): Boolean {
        return Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT
    }

    /**
     * 判断当前手机系统版本API是否是21及以上
     * @return 21及以上返回true，否则返回false
     */
    fun hasLollipop(): Boolean {
        return Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP
    }

    /**
     * 判断当前手机系统版本API是否是22及以上
     * @return 22及以上返回true，否则返回false
     */
    fun hasLollipopMR1(): Boolean {
        return Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP_MR1
    }

    /**
     * 判断当前手机系统版本API是否是23及以上
     * @return 23及以上返回true，否则返回false
     */
    fun hasMarshmallow(): Boolean {
        return Build.VERSION.SDK_INT >= Build.VERSION_CODES.M
    }

    /**
     * 判断当前手机系统版本API是否是24及以上
     * @return 24及以上返回true，否则返回false
     */
    fun hasNougat(): Boolean {
        return Build.VERSION.SDK_INT >= Build.VERSION_CODES.N
    }

    /**
     * 判断当前手机系统版本API是否是29及以上
     * @return 29及以上返回true，否则返回false
     */
    fun hasQ(): Boolean {
        return Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q
    }

    /**
     * 判断当前手机系统版本API是否是30及以上
     * @return 30及以上返回true，否则返回false
     */
    fun hasR(): Boolean {
        return Build.VERSION.SDK_INT >= Build.VERSION_CODES.R
    }

}
package com.tuanliu.common.ext

import android.text.SpannableStringBuilder
import android.text.Spanned
import android.text.style.RelativeSizeSpan
import java.util.regex.Pattern

/**
 * String的扩展函数
 */

//按照&格式分割String
fun String.splitSpring(): MutableList<String> = this.split("&").toMutableList()

//去掉所有空格
fun String.sqlitStringBlank(): String = this.replace("\\s".toRegex(), "")

/**
 * 判断手机号码格式是否正确
 */
fun String.isMobileNO1(): Boolean {
    val p = Pattern.compile("^(13[0-9]|14[57]|15[0-35-9]|17[6-8]|18[0-9])[0-9]{8}$")
    val m = p.matcher(this)
    return m.matches()
}

/**
 * 设置不同字体的大小
 * [str] 字符串
 * [start]第几位开始
 * [end]第几位结束
 * [zoom] 缩放比例
 */
fun String.differentTestSize(start: Int, end: Int, zoom: Float = 1f): SpannableStringBuilder {
    val spannableStringBuilder = SpannableStringBuilder(this)
    spannableStringBuilder.setSpan(
        RelativeSizeSpan(zoom),
        start,
        end,
        Spanned.SPAN_INCLUSIVE_EXCLUSIVE
    )
    return spannableStringBuilder
}

/**
 * 返回所有[child]的位置
 */
fun String.getChildIndexFromString(child: String): List<Int> {
    var startIndex = 0
    val ids = arrayListOf<Int>()
    while (this.indexOf(child, startIndex) != -1) {
        startIndex = this.indexOf(child, startIndex)
        ids += startIndex
        startIndex += child.length
    }
    return ids
}
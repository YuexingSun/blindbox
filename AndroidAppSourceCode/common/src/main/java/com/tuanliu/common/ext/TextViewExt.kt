package com.tuanliu.common.ext

import android.widget.TextView

/**
 * 获取文本
 */
fun TextView.textString(): String {
    return text.toString()
}

/**
 * 获取去除空字符串的文本
 */
fun TextView.textStringTrim(): String {
    return textString().trim()
}

/**
 * 文本是否为空
 */
fun TextView.isEmpty(): Boolean {
    return textString().isEmpty()
}

/**
 * 去空字符串后文本是否为空
 */
fun TextView.isTrimEmpty(): Boolean {
    return this.textStringTrim().isEmpty()
}
package com.tuanliu.common.ext

import java.text.ParsePosition
import java.text.SimpleDateFormat

/**
 * long转String
 */
fun Long.transToString(pattern: String = "yyyy-MM-dd HH:mm:ss"): String {
    return SimpleDateFormat(pattern).format(this)
}

/**
 * String转long
 */
fun String.transToTimeStamp(pattern: String = "yyyy-MM-dd HH:mm:ss"): Long {
    return SimpleDateFormat(pattern).parse(this, ParsePosition(0)).time
}
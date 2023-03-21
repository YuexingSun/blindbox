package com.tuanliu.common.ext

import java.text.DecimalFormat

/**
 * 智能判断是否显示小数位，最多显示2位
 * <br>eg:
 * <br>2.10 -> 2.1
 * <br>2.12 -> 2.12
 * <br>2.00 -> 2
 *
 * @return 数字对应的字符串
 */
fun Double.smartDecimal(): String {
    return DecimalFormat("#.##").format(this)
}
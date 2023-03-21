package com.zhixing.zxhy.util.databinding

object MyBlindBox {

    /**
     * 状态对应的文字
     */
    @JvmStatic
    fun boxStatus(status: Int?): String = when (status) {
        0, 1 -> "进行中"
        2, 3 -> "已完成"
        4, 5 -> "已失效"
        else -> ""
    }

}
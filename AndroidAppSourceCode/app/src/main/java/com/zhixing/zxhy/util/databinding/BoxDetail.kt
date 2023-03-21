package com.zhixing.zxhy.util.databinding

object BoxDetail {

    /**
     * 转换成Float显示星星
     */
    @JvmStatic
    fun AnyToFloat(any: Any?): Float {
        return any?.toString()?.toFloat() ?: 0.0f
    }

}
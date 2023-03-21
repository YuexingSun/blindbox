package com.zhixing.zxhy.util

/**
 * 阿里云图片处理
 */
object AliYunImage {

    /**
     * 等比缩放
     * [height] 图片高度
     */
    fun mfit(str: String, height: Int): String = "$str?x-oss-process=image/resize,h_$height,m_lfit"

    /**
     * 等比缩放，宽
     */
    fun mfitW(str: String, width: Int): String = "$str?x-oss-process=image/resize,w_$width,m_lfit"

}

/**
 * 等比缩放图片
 * [height] 高度
 * [width] 宽度
 * [limit_0] 不足的话就放大
 */
fun String.fillHW(height: Int, width: Int): String = "$this?x-oss-process=image/resize,m_fill,h_$height,w_$width,limit_0"
package com.zhixing.zxhy.util.databinding

import android.widget.ImageView
import androidx.databinding.BindingAdapter
import com.blankj.utilcode.constant.TimeConstants
import com.blankj.utilcode.util.TimeUtils
import com.tuanliu.common.ext.glideDefault
import java.math.RoundingMode
import java.text.DecimalFormat
import kotlin.math.absoluteValue

object Common {

    /**
     * int转换成str
     */
    @JvmStatic
    fun intToStr(i: Int = 0): String = i.toString()

    /**
     * 评论、点赞、收藏 数字格式优化
     */
    @JvmStatic
    fun intDispose(i: Int = 0): String {
        return when {
            i < 1000 -> "$i"
            else -> "${
                DecimalFormat("#.#").apply {
                    //这里不要四舍五入
                    roundingMode = RoundingMode.DOWN
                }.format(i / 1000.0)
            }k"
        }
    }

    /**
     * double转换成Float
     */
    @JvmStatic
    fun doubleToFloat(double: Double? = null): Float {
        return double?.toString()?.toFloat() ?: 0.0F
    }

    /**
     * 日期转换成所需要的时间
     */
    @JvmStatic
    fun dateTransition(times: String? = null): String {

        if (times == null) return ""

        val list = times.split(" ")
        return if (list.size == 2) {
            val timeDiffer = dateFormat(list[0], TimeConstants.DAY)
            //删除秒
            val time = list[1].substring(0, list[1].lastIndexOf(":"))

            when (timeDiffer) {
                //今天
                0 -> {
                    val hourTime = dateFormat(time, TimeConstants.HOUR, "HH:mm")
                    hourTime.let {
                        when (it) {
                            0 -> {
                                val minTime = dateFormat(time, TimeConstants.MIN, "HH:mm")
                                "${minTime.absoluteValue}分钟前"
                            }
                            else -> "${hourTime.absoluteValue}小时前"
                        }
                    }
                }
                -1 -> "昨天 $time"
                else -> "${list[0]} $time"
            }
        } else times
    }

    private fun dateFormat(time: String, conStants: Int, pattern: String = "yyyy-MM-dd"): Int {
        return TimeUtils.getTimeSpanByNow(
            time,
            TimeUtils.getSafeDateFormat(pattern),
            conStants
        ).toInt()
    }

    /**
     * 详情页内使用的 - 日期转换成所需要的时间
     */
    @JvmStatic
    fun detailsDate(times: String? = null): String {

        if (times == null) return ""

        val list = times.split(" ")
        //删除秒
        val time = list.getOrNull(1)?.substring(0, list[1].lastIndexOf(":")) ?: ""

        return "${list[0]} $time"
    }

    /**
     * 转换成Float显示星星
     */
    @JvmStatic
    fun AnyToFloat(any: Any?): Float {
        return any?.toString()?.toFloat() ?: 0.0f
    }

    /**
     * 图片加载
     */
    @BindingAdapter("imgUrl")
    @JvmStatic
    fun loadImage(imageView: ImageView, url: String?) {

        if (url == null || url == "") return

        imageView.glideDefault(
            imageView.context,
            url,
            showPlaceHolder = false
        )
    }

}
package com.zhixing.zxhy.util.databinding

import android.util.Log
import android.widget.ImageView
import androidx.databinding.BindingAdapter
import com.tuanliu.common.ext.glideDefault
import com.tuanliu.common.ext.transToString

object Setting {

    @JvmStatic
    fun dateToAge(str: String?): String {
        if (str == null) return ""
        val strList = str.split("-")
        val systemTime = System.currentTimeMillis()
        //拿到当前的年份
        val thisYear = systemTime.transToString("yyyy")
        //拿到当前的月份
        val thisMonth = systemTime.transToString("MM")
        var year: Int = 0
        if (strList.size >= 2) {
            year = thisYear.toInt() - strList[0].toInt()
            if (strList[1] < thisMonth) year--
        }
        return if (year == 0) "" else "${year}岁"
    }

}
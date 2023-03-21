package com.zhixing.zxhy.widget.chartCircleView

import android.os.Parcelable
import androidx.annotation.ColorRes
import kotlinx.parcelize.Parcelize

@Parcelize
data class ChartCircleItem(
    //值
    val value: Int,
    //颜色
    @ColorRes val color: Int,
): Parcelable
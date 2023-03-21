package com.zhixing.zxhy.util

import com.zhixing.zxhy.R

/**
 * 导航途中需要改变的内容
 */
class NavigationIngChange {

    /**
     * 导航过程中Icon的改变
     * [Int] drawableRes
     */
    fun naviIconChange(iconType: Int?): Int? {
        if (iconType == null) return null

        return when(iconType) {
            //左转
            2 -> R.mipmap.ic_naving_2
            //右转
            3 -> R.mipmap.ic_naving_3
            //左前方
            4 -> R.mipmap.ic_naving_4
            //右前方
            5 -> R.mipmap.ic_naving_5
            //左后方
            6 -> R.mipmap.ic_naving_6
            //右后方
            7 -> R.mipmap.ic_naving_7
            //左转掉头
            8 -> R.mipmap.ic_naving_8
            //直行
            9 -> R.mipmap.ic_naving_9
            //右转掉头
            19 -> R.mipmap.ic_naving_19
            //通过人行横道
            29 -> R.mipmap.ic_naving_29
            //通过天桥
            30 -> R.mipmap.ic_naving_30
            //通过地下通道
            31 -> R.mipmap.ic_naving_31
            else -> null
        }
    }

}
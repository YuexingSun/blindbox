package com.zhixing.zxhy.util.databinding

import android.widget.ImageView
import androidx.databinding.BindingAdapter
import com.tuanliu.common.ext.glideDefault
import com.zhixing.zxhy.view_model.MyData

object Me {

    /**
     * int转换成str
     */
    @JvmStatic
    fun intToStr(i: Int = 0): String = i.toString()

    /**
     * 升级进度
     */
    @JvmStatic
    fun progressNum(now: Int = 0, next: Int = 0): Int {
        if (next == 0) return 0
        return (1 - ((next - now) / next)) * 100
    }

    /**
     * 距离升级的点数
     */
    @JvmStatic
    fun acuteLevelNum(now: Int = 0, next: Int = 0): String = (next - now).toString()

    /**
     * 当前等级
     */
    @JvmStatic
    fun levelText(str: String): String {
        val string = str.replace("V", "")
        return "LEVEL $string"
    }

    /**
     * 成就图片加载
     */
    @BindingAdapter("madelImgUrl")
    @JvmStatic
    fun madelLoadImage(imageView: ImageView, myachievelist: MyData.Myachievelist) {
        imageView.glideDefault(
            imageView.context,
            if (myachievelist.islight == 1) myachievelist.lightpic else myachievelist.pic,
            showPlaceHolder = false
        )
    }

    /**
     * 成就是否获得
     */
    @JvmStatic
    fun madelIsLight(i: Int = 0): String = if (i == 0) "未获得" else "已获得"

}
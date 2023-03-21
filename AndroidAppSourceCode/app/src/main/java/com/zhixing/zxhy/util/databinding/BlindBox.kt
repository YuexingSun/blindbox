package com.zhixing.zxhy.util.databinding

import android.widget.ImageView
import androidx.databinding.BindingAdapter
import com.tuanliu.common.ext.glideDefault

object BlindBox {

    /**
     * 根据状态改变文字
     */
    @JvmStatic
    fun blindBoxStatus(int: Int): String = if (int == 0) "准备出行" else "敬请期待"

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
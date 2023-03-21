package com.zhixing.zxhy.util.recyclerView

import android.view.View
import androidx.viewpager2.widget.ViewPager2

/**
 * 中间放大两边缩小
 */
class ViewPageTransform(val viewpae2: ViewPager2) : ViewPager2.PageTransformer {

    private val default = 0.7f
    private val default_trans = 1.0f

    override fun transformPage(page: View, position: Float) {

        val offset: Float = 40 * position

        if (viewpae2.orientation == ViewPager2.ORIENTATION_HORIZONTAL) {
            page.translationX = if (isRtl1()) -offset else offset
        } else {
            page.translationY = offset
        }

        when {
            //左边的item
            position <= 0 -> {
                page.scaleX = 1 + position / 15
                page.scaleY = 1 + position / 15
                page.translationX = (0 - position) * default
                page.translationY = (0 - position) * default
            }
            //右边的item
            position <= 1 -> {
                page.scaleX = 1 - position / 15
                page.scaleY = 1 - position / 15
                page.translationX = (0 - position) * default
                page.translationY = (0 - position) * default
            }
            //表示左边/右边 的View 且已经看不到了
            else -> {
                page.scaleX = 1 - position / 15
                page.scaleY = 1 - position / 15
                page.translationX = default_trans
                page.translationY = default_trans
            }
        }
    }

    private fun isRtl1(): Boolean {
        return viewpae2.layoutDirection == 1
    }
}
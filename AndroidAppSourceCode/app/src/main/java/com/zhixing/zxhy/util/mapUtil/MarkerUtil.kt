package com.zhixing.zxhy.util.mapUtil

import com.amap.api.maps.model.Marker
import com.amap.api.maps.model.animation.Animation
import com.amap.api.maps.model.animation.ScaleAnimation

object MarkerUtil {


    /**
     * 缩放动画
     * [startScale] 起始大小
     * [endScale] 结束大小
     */
    fun setScaleAnima(
        marker: Marker,
        startScale: Float = 0.1f,
        endScale: Float = 1.0f,
        duration: Long = 1000
    ) {
        //缩放动画
        val animation = ScaleAnimation(startScale, endScale, startScale, endScale)
        animation.apply {
            //持续时间
            setDuration(duration)
            //重复次数 默认为0
            repeatCount = 0
            //动画执行后保持在最后一帧
            fillMode = Animation.FILL_MODE_FORWARDS
            //动画结束后从头播放
            repeatMode = Animation.RESTART
        }
        marker.setAnimation(animation)
        marker.startAnimation()
    }

}
package com.zhixing.zxhy.util.mapUtil

import android.content.Context
import com.amap.api.maps.AMap
import com.amap.api.maps.model.CustomMapStyleOptions
import com.tuanliu.common.util.FileUtils

object AMapUtil {

    /**
     * 设置地图样式
     */
    fun setAMapStyle(context: Context, aMap: AMap) {
        val style = FileUtils.getModelFilePath(context, "style.data")
        val extra = FileUtils.getModelFilePath(context, "style_extra.data")
        //设定地图离线样式
        aMap.setCustomMapStyle(
            CustomMapStyleOptions().setEnable(true).setStyleDataPath(style)
                .setStyleExtraPath(extra)
        )
    }

}
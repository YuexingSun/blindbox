package com.zhixing.zxhy.util.mapUtil
import com.amap.api.maps.model.LatLng
import com.amap.api.navi.model.NaviLatLng
import com.amap.api.services.core.LatLonPoint
import java.text.DecimalFormat

/**
 * 地图帮助类
 */
object MapUtil {
    /**
     * 把LatLng对象转化为LatLonPoint对象
     */
    fun convertToLatLonPoint(latLng: LatLng): LatLonPoint {
        return LatLonPoint(latLng.latitude, latLng.longitude)
    }

    /**
     * 把LatLng对象转化为NaviLatLng对象
     */
    fun convertToNaviLatLng(latLng: LatLng): NaviLatLng {
        return NaviLatLng(latLng.latitude, latLng.longitude)
    }

    /**
     * 把LatLonPoint对象转化为LatLon对象
     */
    fun convertToLatLng(latLonPoint: LatLonPoint): LatLng {
        return LatLng(latLonPoint.latitude, latLonPoint.longitude)
    }

    /**
     * 米转 米/公里
     */
    fun formatKM(d: Int): String {
        val df = DecimalFormat("0.0")
        return when {
            d <= 999 -> d.toString()
            d >= 1000 -> df.format(d / 1000.0)
            else -> d.toString()
        }
    }

    /**
     * 米转 米/公里 单位
     */
    fun formatKMUnit(d: Int): String {
        return when {
            d <= 999 -> "m"
            d >= 1000 -> "km"
            else -> "m"
        }
    }

    /**
     * 转换加带单位
     */
    fun formatKMFull(d: Int): String {
        val df = DecimalFormat("0.0")
        return when {
            d <= 999 -> "${d}米"
            d >= 1000 -> "${df.format(d / 1000.0)}公里"
            else -> "${d}米"
        }
    }

    /**
     * 转换成时间
     * [second] 单位秒
     */
    fun getFriendlyTime(second: Int): String {
        if (second > 3600) {
            val hour = second / 3600
            val miniate = second % 3600 / 60
            return hour.toString() + "小时" + miniate + "分钟"
        }
        if (second >= 60) {
            val miniate = second / 60
            return miniate.toString() + "分钟"
        }
        return second.toString() + "秒"
    }

    /**
     * 转换成有单位的距离
     * [lenMeter] 单位米
     */
    fun getFriendlyLength(lenMeter: Int): String {
        // 10 km
        if (lenMeter > 10000)
        {
            val dis = lenMeter / 1000
            return dis.toString() + ChString.Kilometer
        }
        if (lenMeter > 1000) {
            val dis = lenMeter.toFloat() / 1000
            val fnum = DecimalFormat("##0.0")
            val dstr = fnum.format(dis.toDouble())
            return dstr + ChString.Kilometer
        }
        if (lenMeter > 100) {
            val dis = lenMeter / 50 * 50
            return dis.toString() + ChString.Meter
        }
        var dis = lenMeter / 10 * 10
        if (dis == 0) {
            dis = 10
        }
        return dis.toString() + ChString.Meter
    }

    /**
     * 转换成有单位的距离
     * [lenMeter] 单位米
     */
    fun getFriendlyLengthB(lenMeter: Int): String {
        // 10 km
        if (lenMeter > 10000)
        {
            val dis = lenMeter / 1000
            return "${dis}km"
        }
        if (lenMeter > 1000) {
            val dis = lenMeter.toFloat() / 1000
            val fnum = DecimalFormat("##0.0")
            val dstr = fnum.format(dis.toDouble())
            return "${dstr}km"
        }
        if (lenMeter > 100) {
            val dis = lenMeter / 50 * 50
            return "${dis}m"
        }
        var dis = lenMeter / 10 * 10
        if (dis == 0) {
            dis = 10
        }
        return "${dis}m"
    }
}


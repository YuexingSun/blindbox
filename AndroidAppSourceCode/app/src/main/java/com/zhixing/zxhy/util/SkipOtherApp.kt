package com.zhixing.zxhy.util

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Intent
import android.net.Uri
import androidx.fragment.app.Fragment
import com.hjq.toast.ToastUtils

/**
 * 跳转到其他app
 */
object SkipOtherApp {

    /**
     * 前往高德地图
     * [targetName] 目标地址名称
     */
    fun goGeoDe(activity: Activity, targetName: String, lat: String, lng: String) {
        try {
            val uri = "amapuri://route/plan/?dlat=$lat&dlon=$lng&dname=$targetName&dev=0&t=0"
            val intent = Intent()
            intent.apply {
                addCategory("android.intent.category.DEFAULT")
                data = Uri.parse(uri)
                setPackage("com.autonavi.minimap")
            }
            activity.startActivity(intent)
        } catch (e: ActivityNotFoundException) {
            ToastUtils.show("请先安装高德地图")
        }
    }

    /**
     * 前往百度地图
     * [targetName] 目标地址名称
     */
    fun goBaiDu(activity: Activity, targetName: String, lat: String, lng: String) {
        try {
            val uri =
                "baidumap://map/direction?destination=name:$targetName|latlng:$lat,$lng&coord_type=bd09l&src=andr.baidu.知行盒一"
            val intent = Intent()
            intent.apply {
                addCategory("android.intent.category.DEFAULT")
                data = Uri.parse(uri)
                setPackage("com.baidu.BaiduMap")
            }
            activity.startActivity(intent)
        } catch (e: ActivityNotFoundException) {
            ToastUtils.show("请先安装百度地图")
        }
    }

    /**
     * 拨打电话
     */
    fun callPhone(fragment: Fragment, phone: String) {
        val intent = Intent(Intent.ACTION_DIAL)
        val uri = Uri.parse("tel:$phone")
        intent.data = uri
        fragment.startActivity(intent)
    }

}
package com.zhixing.zxhy.util.toPermission

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.location.LocationManager
import android.provider.Settings
import androidx.fragment.app.Fragment
import com.hjq.toast.ToastUtils

/**
 * 跳转到打开定位服务页面
 */
fun Activity.startLocationService() {
    val intent = Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS)
    startActivity(intent)
}

/**
 * 是否开启定位功能
 */
fun Fragment.requestLocation(isOpen: () -> Unit) {
    when (systemLocationServiceEnable(this.requireContext())) {
        true -> isOpen()
        else -> {
            ToastUtils.show("请开启定位服务后重试")
            this.requireActivity().startLocationService()
        }
    }
}

/**
 * 手机是否开启位置服务，如果没有开启那么所有app将不能使用定位功能
 */
private fun systemLocationServiceEnable(context: Context): Boolean {
    val locationManager = context.getSystemService(Context.LOCATION_SERVICE) as LocationManager
    val gps = locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)
    val network = locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER)
    return gps || network
}
package com.zhixing.zxhy.util.toPermission

import android.content.Context
import android.location.LocationManager
import androidx.fragment.app.Fragment
import com.hjq.permissions.OnPermissionCallback
import com.hjq.permissions.Permission
import com.hjq.permissions.XXPermissions
import com.hjq.toast.ToastUtils

/**
 * 查看地址页面需要的定位
 */
class CheckSitePermission(val fragment: Fragment) {

    //需要获取的权限
    private val permissionListA by lazy {
        listOf(
            Permission.ACCESS_COARSE_LOCATION,
            Permission.ACCESS_FINE_LOCATION
        )
    }

    /**
     * 查看权限是否获取
     */
    fun checkPermission(noOpen: (() -> Unit) ?= null, openLocation: () -> Unit) {
        XXPermissions.with(fragment).permission(permissionListA)
            .request(object : OnPermissionCallback {
                override fun onGranted(permissions: MutableList<String>?, all: Boolean) {
                    if (all) {
                        requestLocation {
                            openLocation()
                        }
                    } else {
                        noOpen?.invoke()
                        ToastUtils.show("有权限未通过，请手动授予权限。")
                    }
                }

                override fun onDenied(permissions: MutableList<String>?, never: Boolean) {
                    if (never)
                        ToastUtils.show("被永久拒绝授权，请手动授予权限")
                    else ToastUtils.show("获取部分权限失败")
                }
            })
    }

    /**
     * 是否开启定位功能
     */
    private fun requestLocation(isOpen: () -> Unit) {
        when (systemLocationServiceEnable(fragment.requireContext())) {
            true -> isOpen()
            else -> {
                ToastUtils.show("未开启定位服务")
                fragment.requireActivity().startLocationService()
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

}
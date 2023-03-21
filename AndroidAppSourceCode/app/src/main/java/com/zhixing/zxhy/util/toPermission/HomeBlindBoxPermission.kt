package com.zhixing.zxhy.util.toPermission

import android.os.Build
import androidx.fragment.app.Fragment
import com.hjq.permissions.OnPermissionCallback
import com.hjq.permissions.Permission
import com.hjq.permissions.XXPermissions
import com.hjq.toast.ToastUtils

/**
 * 盲盒页面需要的定位权限
 * 这里直接搜索是否开了定位服务
 */
class HomeGoBoxPermission(val fragment: Fragment) {

    //需要获取的权限
    private val permissionListA by lazy {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            listOf(
                Permission.ACCESS_COARSE_LOCATION,
                Permission.ACCESS_FINE_LOCATION,
            )
        } else {
            listOf(
                Permission.ACCESS_COARSE_LOCATION,
                Permission.ACCESS_FINE_LOCATION,
            )
        }
    }

    /**
     * 查看权限是否获取
     * [noPermission]无权限时的操作
     * 这里只有一个权限，要么全部成功要么全部失败
     */
    fun checkPermission(noPermission: (() -> Unit)? = null, openLocation: () -> Unit) {
        XXPermissions.with(fragment).permission(permissionListA)
            .request(object : OnPermissionCallback {
                override fun onGranted(permissions: MutableList<String>?, all: Boolean) {
                    fragment.requestLocation {
                        openLocation()
                    }
                }

                override fun onDenied(permissions: MutableList<String>?, never: Boolean) {
                    noPermission?.invoke()
                    ToastUtils.show("请手动开启定位权限")
                    XXPermissions.startPermissionActivity(fragment, permissions)
                }
            })
    }

}
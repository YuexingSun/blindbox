package com.zhixing.zxhy.util.toPermission

import androidx.fragment.app.Fragment
import com.hjq.permissions.OnPermissionCallback
import com.hjq.permissions.Permission
import com.hjq.permissions.XXPermissions
import com.hjq.toast.ToastUtils

/**
 * 下载apk时需要安装未知应用权限
 */
class InStallPermission(val fragment: Fragment) {

    //需要获取的权限
    private val permissionListA by lazy {
        listOf(
            Permission.REQUEST_INSTALL_PACKAGES
        )
    }

    /**
     * 查看权限是否获取
     * [noPermission]无权限时的操作
     */
    fun checkPermission(noPermission: () -> Unit = {}, openLocation: () -> Unit) {
        XXPermissions.with(fragment).permission(permissionListA)
            .request(object : OnPermissionCallback {
                override fun onGranted(permissions: MutableList<String>?, all: Boolean) {
                    if (all) {
                        openLocation()
                    } else {
                        ToastUtils.show("请开启安装未知应用权限。")
                        noPermission()
                    }
                }

                override fun onDenied(permissions: MutableList<String>?, never: Boolean) {
                    if (never)
                        ToastUtils.show("未开启安装未知应用权限，请手动授予权限")
                    else ToastUtils.show("获取安装未知应用权限失败")
                }
            })
    }

}
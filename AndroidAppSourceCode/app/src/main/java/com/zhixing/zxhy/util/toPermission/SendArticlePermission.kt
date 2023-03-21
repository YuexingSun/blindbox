package com.zhixing.zxhy.util.toPermission

import androidx.fragment.app.Fragment
import com.hjq.permissions.OnPermissionCallback
import com.hjq.permissions.Permission
import com.hjq.permissions.XXPermissions
import com.hjq.toast.ToastUtils

/**
 * 发送文章页面需要的权限
 */
class SendArticlePermission(val fragment: Fragment) {

    //需要获取的权限
    private val permissionListA by lazy {
        listOf(
            Permission.ACCESS_COARSE_LOCATION,
            Permission.ACCESS_FINE_LOCATION,
            Permission.WRITE_EXTERNAL_STORAGE,
            Permission.READ_EXTERNAL_STORAGE,
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
                        fragment.requestLocation {
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

}
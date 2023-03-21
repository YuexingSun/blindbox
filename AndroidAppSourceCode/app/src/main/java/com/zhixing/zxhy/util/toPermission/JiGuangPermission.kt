package com.zhixing.zxhy.util.toPermission

import android.content.Context
import android.os.Build
import androidx.fragment.app.Fragment
import com.hjq.permissions.OnPermissionCallback
import com.hjq.permissions.Permission
import com.hjq.permissions.XXPermissions

/**
 * 极光需要获取的权限
 */
class JiGuangPermission(val fragment: Fragment) {

    //需要获取的权限
    private val permissionListA by lazy {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            listOf(
                Permission.READ_PHONE_NUMBERS,
                Permission.WRITE_EXTERNAL_STORAGE,
                Permission.ACCESS_COARSE_LOCATION,
                Permission.ACCESS_FINE_LOCATION,
                Permission.READ_EXTERNAL_STORAGE,
            )
        } else {
            listOf(
                Permission.READ_PHONE_STATE,
                Permission.WRITE_EXTERNAL_STORAGE,
                Permission.ACCESS_COARSE_LOCATION,
                Permission.ACCESS_FINE_LOCATION,
                Permission.READ_EXTERNAL_STORAGE,
            )
        }
    }

    /**
     * 查看权限是否获取
     * [noPermission]无权限时的操作
     */
    fun checkPermission(noPermission: (() -> Unit)? = null, openLocation: () -> Unit) {
        XXPermissions.with(fragment).permission(permissionListA)
            .request(object : OnPermissionCallback {
                override fun onGranted(permissions: MutableList<String>?, all: Boolean) {
                    if (all) {
                        openLocation()
                    } else {
                        noPermission?.invoke()
                    }
                }

                override fun onDenied(permissions: MutableList<String>?, never: Boolean) {
                    if (permissions?.size ?: 0 == permissionListA.size) {
                        noPermission?.invoke()
                    }
                }
            })
    }

    /**
     * 是否已经获取了所需要的权限
     */
    fun isGrantedPermission(context: Context): Boolean {
        for (permission in permissionListA) {
            if (permission == Permission.ACCESS_COARSE_LOCATION || permission == Permission.ACCESS_FINE_LOCATION)
                break
            if (!XXPermissions.isGranted(context, permission)) return false
        }
        return true
    }

}
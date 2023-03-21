package com.tuanliu.common.util

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Build
import androidx.core.content.FileProvider
import java.io.File


/**
 * 安装app
 */
object InStallApp {

    /**
     * 安装app
     */
    fun install(activity: Activity, uri: Uri) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.N)
            startInstall(activity, uri)
        else
            start7Install(activity, uri)
    }

    /**
     * 安装app
     * 返回Intent
     */
    fun install(uri: Uri): Intent {
        return if (Build.VERSION.SDK_INT < Build.VERSION_CODES.N)
            startInstallReturnI(uri)
        else
            start7InstallReturnI(uri)
    }

    /**
     * 7.0以下安装应用
     */
    private fun startInstall(activity: Activity, uri: Uri) {
        val install = Intent(Intent.ACTION_VIEW)
        install.setDataAndType(uri, "application/vnd.android.package-archive")
        install.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        activity.startActivity(install)
    }

    /**
     * 7.0以下安装应用 返回Intent
     */
    private fun startInstallReturnI(uri: Uri): Intent {
        val install = Intent(Intent.ACTION_VIEW)
        install.setDataAndType(uri, "application/vnd.android.package-archive")
        install.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        return install
    }

    /**
     * 7.0及以上安装应用
     */
    private fun start7Install(activity: Activity, uri: Uri) {
        val install = Intent(Intent.ACTION_VIEW)
        install.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        install.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        install.setDataAndType(uri, "application/vnd.android.package-archive")
        activity.startActivity(install)
    }

    /**
     * 7.0及以上安装应用
     */
    private fun start7InstallReturnI(uri: Uri): Intent {
        val install = Intent(Intent.ACTION_VIEW)
        install.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        install.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        install.setDataAndType(uri, "application/vnd.android.package-archive")
        return install
    }

}
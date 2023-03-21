package com.zhixing.zxhy.util

import android.app.Activity
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import androidx.core.app.NotificationCompat
import com.tuanliu.common.base.appContext
import com.tuanliu.common.util.InStallApp
import com.zhixing.zxhy.R

/**
 * 下载进度通知栏
 */
class NotificationUtil(val activity: Activity) {

    val notificationManager =
        activity.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

    /**
     * 下载NotificationManager
     * [indeterminate] 进度条是否是不确定的
     */
    fun downLoadApkNoti(title: String, text: String, uri: Uri? = null, indeterminate: Boolean = true) {
        val intent = if (uri == null) {
            //打开app
            Intent(appContext, activity::class.java)
        } else {
            //apk安装页面
            InStallApp.install(uri)
        }
        val pendingIntent =
            PendingIntent.getActivity(appContext, 0, intent, 0)

        val channelId: String = createNotificationChannel(
            "my_channel_ID",
            "my_channel_NAME",
            NotificationManager.IMPORTANCE_HIGH
        )
        val notification: NotificationCompat.Builder =
            NotificationCompat.Builder(activity, channelId)
                .setContentTitle(title)
                .setContentText(text)
                .setContentIntent(pendingIntent)
                .setSmallIcon(R.mipmap.ic_app)
                //点击后自动取消通知
                .setAutoCancel(true)
                .setWhen(System.currentTimeMillis())
                //不确定的进度条
                .setProgress(100, 100, indeterminate)


        notificationManager.notify(16657, notification.build())
    }

    private fun createNotificationChannel(
        channelID: String,
        channelNAME: String,
        level: Int
    ): String {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val manager =
                activity.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            val channel = NotificationChannel(channelID, channelNAME, level)
            manager.createNotificationChannel(channel)
            channelID
        } else {
            channelID
        }
    }

}
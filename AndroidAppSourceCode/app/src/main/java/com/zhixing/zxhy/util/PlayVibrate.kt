package com.zhixing.zxhy.util

import android.content.Context
import android.media.AudioAttributes

import android.os.Vibrator
import java.lang.Exception

/**
 * 手机震动
 */
class PlayVibrate(context: Context) {

    private var mVibrator: Vibrator = context.getSystemService(Context.VIBRATOR_SERVICE) as Vibrator

    //开始时间 持续时间 连续震动的间隔时间
    private val patern = longArrayOf(0, 3000, 200)

    //后台震动的关键类
    private val audioAttributes: AudioAttributes = AudioAttributes.Builder()
        .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
        //key
        .setUsage(AudioAttributes.USAGE_ALARM)
        .build()

    /**
     * 手机震动
     * [isRepeat] 是否重复震动
     */
    fun playVibrate(isRepeat: Boolean) {
        try {
            /**
             * 适配android7.0以上版本的震动
             * 说明：如果发现5.0或6.0版本在app退到后台之后也无法震动，那么只需要改下方的Build.VERSION_CODES.N版本号即可
             */
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
//            val audioAttributes = AudioAttributes.Builder()
//                .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
//                .setUsage(AudioAttributes.USAGE_ALARM) //key
//                .build()
//            mVibrator.vibrate(patern, if (isRepeat) 1 else -1, audioAttributes)
//        } else {
//            mVibrator.vibrate(patern, if (isRepeat) 1 else -1)
//        }
            mVibrator.vibrate(patern, if (isRepeat) 1 else -1, audioAttributes)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    fun cancelVibrate() {
        mVibrator.cancel()
    }

}

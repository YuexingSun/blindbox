package com.tuanliu.common.util

import android.media.AudioManager

/**
 * 音量控制
 */
class VolumeUtil(private val mAudioManager: AudioManager) {

    /**
     * 设置音量
     * [isAdd] 是否是增加
     */
    fun setStreamVolume(isAdd: Boolean = true) {
        var currentVolume = getCurrentVolume()
        when (isAdd) {
            //增加
            true -> {
                val maxVolume = getMaxVolume()
                if (currentVolume < maxVolume)
                    currentVolume += 1
                else currentVolume = maxVolume
            }
            //减小
            false -> {
                if (currentVolume > 0)
                    currentVolume -= 1
                else currentVolume = 0
            }
        }

        /**
         * 设置系统媒体音量
         * setStreamVolume 直接设置音量
         * adjustStreamVolume 步长式设置音量，即10,20,30这样阶梯式
         *
         * 参数1：音量类型
         * 参数2：音量数值
         * 参数3：
         *      AudioManager.FLAG_SHOW_UI 调整音量时显示系统音量进度条 , 0 则不显示
         *      AudioManager.FLAG_ALLOW_RINGER_MODES 是否铃声模式
         *      AudioManager.FLAG_VIBRATE 是否震动模式
         *      AudioManager.FLAG_SHOW_VIBRATE_HINT 震动提示
         *      AudioManager.FLAG_SHOW_SILENT_HINT 静音提示
         *      AudioManager.FLAG_PLAY_SOUND 调整音量时播放声音
         */
        mAudioManager.setStreamVolume(
            AudioManager.STREAM_MUSIC,
            currentVolume,
            AudioManager.FLAG_SHOW_UI
        )
    }

    /**
     * 获取当前系统媒体音量
     * STREAM_VOICE_CALL 通话
     * STREAM_SYSTEM 系统
     * STREAM_RING 铃声
     * STREAM_MUSIC 媒体音量
     * STREAM_ALARM 闹钟
     * STREAM_NOTIFICATION 通知
     */
    private fun getCurrentVolume(): Int = mAudioManager.getStreamVolume(AudioManager.STREAM_MUSIC)

    /**
     * 获取系统最大音量
     */
    private fun getMaxVolume(): Int = mAudioManager.getStreamMaxVolume(AudioManager.STREAM_MUSIC)

    /**
     * ringerMode 音量模式
     * RINGER_MODE_NORMAL 正常
     * RINGER_MODE_SILENT 静音
     * RINGER_MODE_VIBRATE 震动
     */
    fun getVolumeMode() = mAudioManager.ringerMode

    /**
     * 音量逐渐递增
     *
     * 参数1：音量类型
     * 参数2：音量调整方向
     *      AudioManager.ADJUST_RAISE 音量逐渐递增
     *      AudioManager.ADJUST_LOWER 音量逐渐递减
     *      AudioManager.ADJUST_SAME 不变
     * 参数3：AudioManager.FLAG_SHOW_UI 调整音量时显示系统音量进度条，0 则不显示
     */
    private fun adjustRaise() {
        mAudioManager.adjustStreamVolume(
            AudioManager.STREAM_MUSIC,
            AudioManager.ADJUST_RAISE,
            AudioManager.FLAG_SHOW_UI
        )
    }

    /**
     * 音量逐渐递减
     */
    private fun adjustLower() {
        mAudioManager.adjustStreamVolume(
            AudioManager.STREAM_MUSIC,
            AudioManager.ADJUST_LOWER,
            AudioManager.FLAG_SHOW_UI
        )
    }

}
package com.tuanliu.common.util

import android.content.Context
import android.media.SoundPool
import androidx.annotation.RawRes

/**
 * 音效播放控制类
 */
class SoundPlayer(val context: Context) {

    companion object {
        //SoundPool对象中允许同时存在的最多的流的数量
        const val MAX_SOUNDS = 3
    }

    private val soundMap: HashMap<Int, Int> = hashMapOf()

    private val soundPool: SoundPool = SoundPool.Builder().setMaxStreams(MAX_SOUNDS).build()

    /**
     * 播放音频
     * [repeatTime] 0：循环一次 -1：一直循环 其他数字表示对应次数
     */
    fun play(@RawRes resId: Int, repeatTime: Int = 0) {
        val soundId = soundPool.load(context, resId, 1)
        //资源加载监听 成功后才播放
        soundPool.setOnLoadCompleteListener { soundP, _, _ ->
            //声音id 左声道0.0f-1.0f 右声道 播放优先级，0最低 循环模式 播放速度1正常 范围0-2
            val streamId = soundP.play(soundId, 1f, 1f, 1, repeatTime, 1f)
            soundMap[resId] = streamId
        }
    }

    /**
     * 暂停音频
     */
    fun pause(@RawRes resId: Int) {
        val streamId = soundMap[resId]
        streamId?.let {
            soundPool.pause(it)
        }
    }

    /**
     * 继续播放
     */
    fun resume(@RawRes resId: Int) {
        val streamId = soundMap[resId]
        streamId?.let {
            soundPool.resume(it)
        }
    }

    /**
     * 停止播放
     */
    fun stop(@RawRes resId: Int) {
        val streamId = soundMap[resId]
        streamId?.let {
            soundPool.stop(it)
        }
    }

    /**
     * 资源释放
     */
    fun release() {
        soundPool.autoPause()
        soundPool.release()
    }

}
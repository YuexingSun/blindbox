package com.zhixing.zxhy.ui.activity

import android.content.Context
import android.media.AudioManager
import android.os.Bundle
import android.view.KeyEvent
import androidx.navigation.fragment.findNavController
import com.blankj.utilcode.util.NetworkUtils
import com.hjq.toast.ToastUtils
import com.tuanliu.common.base.BaseViewModel
import com.zhixing.zxhy.R
import com.zhixing.zxhy.view_model.MainViewModel
import com.tuanliu.common.base.BaseVmActivity
import com.tuanliu.common.base.MainBottomData
import com.tuanliu.common.net.quitLogout
import com.tuanliu.common.util.VolumeUtil
import com.zhixing.network.model.NetConstant

/**
 * 主Activity
 */
class MainActivity : BaseVmActivity<MainViewModel>() {

    override val layoutId: Int = R.layout.activity_main

    //音频管理器
    private val mAudioManager: AudioManager by lazy {
        this.getSystemService(Context.AUDIO_SERVICE) as AudioManager
    }

    //音量控制
    private lateinit var volumeUtil: VolumeUtil

    override fun initView(savedInstanceState: Bundle?) {
        volumeUtil = VolumeUtil(mAudioManager)

        initCodeRequest()
        initShortCut()
        initNetWorkStatus()
    }

    /**
     * 错误码相关
     */
    private fun initCodeRequest() {
        BaseViewModel.codeRequest.observeInActivity(this) {
            when (it) {
                NetConstant.ERROR_CODE_10003 -> {
                    val fragment =
                        supportFragmentManager.fragments.getOrNull(0) ?: return@observeInActivity

                    ToastUtils.show("身份信息已过期，请重新登陆")
                    quitLogout()
                    fragment.findNavController().navigate(R.id.startFragment)
                }
                else -> {
                }
            }
        }
    }

    /**
     * 静态shortcut
     */
    private fun initShortCut() {
        intent.extras?.get("shortCutData")?.let {
            when (it.toString()) {
                //获取盲盒
                "BlindBox" -> BaseViewModel.skipNavMenu.value = MainBottomData.Box
            }
        }
    }

    //网络状态标识
    private var netWorkIsOk: Boolean = true

    /**
     * 注册网络状态监听
     */
    private fun initNetWorkStatus() {
        //判断网络是否连接
        netWorkIsOk = NetworkUtils.isConnected()
        NetworkUtils.registerNetworkStatusChangedListener(object :
            NetworkUtils.OnNetworkStatusChangedListener {
            override fun onDisconnected() {
                ToastUtils.show("当前网络不可用")
                netWorkIsOk = false
            }

            override fun onConnected(networkType: NetworkUtils.NetworkType?) {
                when (networkType) {
                    NetworkUtils.NetworkType.NETWORK_2G, NetworkUtils.NetworkType.NETWORK_3G, NetworkUtils.NetworkType.NETWORK_4G, NetworkUtils.NetworkType.NETWORK_5G, NetworkUtils.NetworkType.NETWORK_WIFI -> {
                        if (!netWorkIsOk) {
                            //更新用户信息
                            BaseViewModel.netWorkStatusChange.value =
                                System.currentTimeMillis().toString()
                            netWorkIsOk = true
                        }
                    }
                    else -> {
                    }
                }
            }
        })
    }

    override fun onKeyDown(keyCode: Int, event: KeyEvent?): Boolean {
        when (keyCode) {
            //音量+
            KeyEvent.KEYCODE_VOLUME_UP -> {
                volumeUtil.setStreamVolume()
                return true
            }
            //音量-
            KeyEvent.KEYCODE_VOLUME_DOWN -> {
                volumeUtil.setStreamVolume(false)
                return true
            }
        }
        return super.onKeyDown(keyCode, event)
    }

    override fun onDestroy() {
        super.onDestroy()
        //注销网络状态改变监听器
        NetworkUtils.unregisterNetworkStatusChangedListener(object :
            NetworkUtils.OnNetworkStatusChangedListener {
            override fun onDisconnected() {}
            override fun onConnected(networkType: NetworkUtils.NetworkType?) {}
        })
    }

}
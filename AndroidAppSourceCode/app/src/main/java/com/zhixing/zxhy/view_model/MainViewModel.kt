package com.zhixing.zxhy.view_model

import android.content.Context
import android.net.Uri
import android.util.Log
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import com.tuanliu.common.util.SingleLiveEvent
import com.tuanliu.common.base.BaseViewModel
import com.tuanliu.common.base.MainBottomData
import com.tuanliu.common.ext.currentActivity
import com.tuanliu.common.net.onBizError
import com.tuanliu.common.net.onBizOK
import com.tuanliu.common.net.onFailure
import com.tuanliu.common.net.onSuccess
import com.zhixing.network.ext.serverData
import com.zhixing.network.rxhttp.Android10DownloadFactory
import com.zhixing.zxhy.repo.HomeRepo
import com.zhixing.zxhy.util.NotificationUtil
import rxhttp.awaitResult
import rxhttp.toDownload
import rxhttp.wrapper.param.RxHttp

class MainViewModel: BaseViewModel() {

    private var isGetInitData = false

    //当前选择的bottom index
    val currentSelected = MutableLiveData(MainBottomData.Box)

    //状态栏改变
    val statusBarChange = SingleLiveEvent<Int>()

    //客户端初始化信息数据
    private val _initDataMutableLiveData = SingleLiveEvent<InitData>()
    val initDataLiveData: LiveData<InitData>
        get() = _initDataMutableLiveData

    /**
     * 获取客户端初始化信息
     */
    fun getInitData() = serverAwait {
        if (isGetInitData) return@serverAwait
        HomeRepo.getInitData().serverData().onSuccess {
            onBizError { code, message ->
                Log.e("xxx", "获取客户端初始化信息 接口异常 $code $message")
            }
            onBizOK<InitData> { _, data, _ ->
                isGetInitData = true
                _initDataMutableLiveData.postValue(data)
            }
        }.onFailure {
            Log.e("xxx", "获取客户端初始化信息 接口异常 $it")
        }
    }

    //弹窗显示过的版本
    var downLoadIsVisi: String = ""

    //apk下载进度
    val downApkProgress = MutableLiveData<Int>()

    //apk下载完成拿到的uri
    var apkUri = MutableLiveData<Uri>()

    /**
     * 下载最新apk
     * [url] 拿到的url下载链接
     */
    fun downLoadApk(context: Context) = serverAwait {

        val data = _initDataMutableLiveData.value?.versions?.android

        if (data?.url == "" || data?.url == null) return@serverAwait

        val newest = data.newest

        val notificationUtil = currentActivity?.let { NotificationUtil(it) }
        val notificationManager = notificationUtil?.notificationManager
        notificationUtil?.downLoadApkNoti("新版本：$newest", "更新包下载中...")

        val factory = Android10DownloadFactory(context, "$newest.apk")
        RxHttp.get(data.url)
            //append 是否支持断点续传
            .toDownload(factory) {
                //下载进度回调,0-100，仅在进度有更新时才会回调
                val currentProgress = it.progress
                //当前已下载的字节大小
//                val currentSize = it.currentSize
                //要下载的总字节大小
//                val totalSize = it.totalSize
                downApkProgress.postValue(currentProgress)
            }.awaitResult {
                apkUri.postValue(it)
                notificationManager?.cancelAll()
                notificationUtil?.downLoadApkNoti(
                    "新版本：${newest}",
                    "更新包下载完成，点击安装。",
                    it,
                    false
                )
            }.onFailure {
                Log.i("xxx", "下载apk异常 ${it.message}")
            }
    }

}
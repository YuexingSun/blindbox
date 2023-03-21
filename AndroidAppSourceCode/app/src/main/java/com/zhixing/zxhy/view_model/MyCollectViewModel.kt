package com.zhixing.zxhy.view_model

import android.util.Log
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import com.scwang.smart.refresh.layout.SmartRefreshLayout
import com.tuanliu.common.base.BaseViewModel
import com.tuanliu.common.net.onBizError
import com.tuanliu.common.net.onBizOK
import com.tuanliu.common.net.onFailure
import com.tuanliu.common.net.onSuccess
import com.tuanliu.common.util.SingleLiveEvent
import com.zhixing.network.ext.serverData
import com.zhixing.network.paging.ApiPagerResponse
import com.zhixing.zxhy.InforMyFavData
import com.zhixing.zxhy.repo.MyCollectRepo
import com.zhixing.zxhy.service.InforFavActicleBody
import com.zhixing.zxhy.service.InforMyFavListBody

class MyCollectViewModel : BaseViewModel() {

    //我收藏的文章列表
    private val _inforMyFavListLiveData = MutableLiveData<ApiPagerResponse<InforMyFavData>>()
    val inforMyFavListLiveData: LiveData<ApiPagerResponse<InforMyFavData>>
        get() = _inforMyFavListLiveData
    private var inforMyFavListPage: Int = 1

    /**
     * 获取我收藏的文章列表
     */
    fun getInforMyFavListData(
        smartRefreshLayout: SmartRefreshLayout,
        isRefresh: Boolean = true
    ) = serverAwait {

        if (isRefresh) inforMyFavListPage = 1

        MyCollectRepo.informationMyFavList(InforMyFavListBody(inforMyFavListPage.toString()))
            .serverData().onSuccess {
                onBizError { code, message ->
                    Log.e("xxx", "获取我收藏的文章列表 接口异常 $code $message")
                }
                onBizOK<ApiPagerResponse<InforMyFavData>> { _, data, _ ->
                    inforMyFavListPage++
                    _inforMyFavListLiveData.postValue(data)
                }
            }.onFailure(smartRefreshLayout, isRefresh) {
                Log.e("xxx", "获取我收藏的文章列表 接口异常 $it")
            }

    }

    //收藏 / 取消收藏
    private val _inforFavActicleLiveData = MutableLiveData<String>()
    val inforFavActicleLiveData: LiveData<String>
        get() = _inforFavActicleLiveData

    /**
     * 取消收藏
     * [id] 文章id
     */
    fun inforFavActicle(id: Int) = serverAwait {
        MyCollectRepo.informationFavActicle(InforFavActicleBody(id))
            .serverData().onSuccess {
                onBizError { code, message ->
                    Log.e("xxx", "取消收藏 接口异常 $code $message")
                }
                onBizOK<Any> { _, _, _ ->
                    _inforFavActicleLiveData.postValue(System.currentTimeMillis().toString())
                }
            }.onFailure {
                Log.e("xxx", "取消收藏 接口异常 $it")
            }
    }

}
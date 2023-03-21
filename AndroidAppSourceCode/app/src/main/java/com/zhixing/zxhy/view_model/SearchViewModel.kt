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
import com.zhixing.zxhy.InforSearchData
import com.zhixing.zxhy.repo.SearchRepo
import com.zhixing.zxhy.service.SearchListBody

class SearchViewModel : BaseViewModel() {

    //搜索的内容
    val searchContent = MutableLiveData<String>("")

    //信息流搜索列表数据
    private val _inforSearchListLD = SingleLiveEvent<ApiPagerResponse<InforSearchData>>()
    val inforSearchListLD: LiveData<ApiPagerResponse<InforSearchData>>
        get() = _inforSearchListLD
    private var searchPage = 1

    /**
     * 获取信息流搜索列表数据
     */
    fun inforSearchList(
        smartRefreshLayout: SmartRefreshLayout,
        isRefresh: Boolean = true
    ) = serverAwait {

        if (searchContent.value.toString() == "") return@serverAwait

        if (isRefresh) searchPage = 1

        SearchRepo.inforSearchList(SearchListBody(searchContent.value.toString(), searchPage))
            .serverData().onSuccess {
            onBizError { code, message ->
                Log.e("xxx", "获取信息流搜索列表数据 接口异常 $code $message")

            }
            onBizOK<ApiPagerResponse<InforSearchData>> { _, data, _ ->
                searchPage++
                _inforSearchListLD.postValue(data)
            }
        }.onFailure(smartRefreshLayout, isRefresh) {
            Log.e("xxx", "获取信息流搜索列表数据 接口异常 $it")
        }

    }

}
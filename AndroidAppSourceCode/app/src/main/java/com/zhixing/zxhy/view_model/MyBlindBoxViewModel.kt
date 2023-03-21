package com.zhixing.zxhy.view_model

import android.util.Log
import com.tuanliu.common.base.BaseViewModel
import androidx.annotation.Keep
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import com.tuanliu.common.net.onBizError
import com.tuanliu.common.net.onBizOK
import com.tuanliu.common.net.onFailure
import com.tuanliu.common.net.onSuccess
import com.zhixing.network.ext.serverData
import com.zhixing.network.paging.ApiPagerResponse
import com.zhixing.zxhy.repo.MyBlindBoxRepo
import com.google.gson.annotations.SerializedName
import com.scwang.smart.refresh.layout.SmartRefreshLayout
import com.zhixing.zxhy.service.MyBoxListBody


class MyBlindBoxViewModel : BaseViewModel() {

    //我的盲盒信息
    private val _getMyBoxLiveData = MutableLiveData<MyBlindBoxData>()
    val getMyBoxLiveData: LiveData<MyBlindBoxData>
        get() = _getMyBoxLiveData

    /**
     * 获取我的盲盒信息
     */
    fun getMyBoxData() = serverAwait {
        MyBlindBoxRepo.getMyBox().serverData().onSuccess {
            onBizError { code, message ->
                Log.e("xxx", "获取我的盲盒信息 接口异常 $code $message")
            }
            onBizOK<MyBlindBoxData> { _, data, _ ->
                _getMyBoxLiveData.postValue(data)
            }
        }.onFailure {
            Log.e("xxx", "获取我的盲盒信息 接口异常 $it")
        }
    }

    //我的盲盒列表信息
    private val _getMyBoxListLiveData = MutableLiveData<ApiPagerResponse<MyBlindBoxListData>>()
    val getMyBoxListLiveData: LiveData<ApiPagerResponse<MyBlindBoxListData>>
        get() = _getMyBoxListLiveData
    private var getMyBoxListPage: Int = 1

    /**
     * 获取我的盲盒列表信息
     * [page] 页码
     * [status] 已完成 - 2|3  已失效4|5  待评价-2
     * [requestError]
     */
    fun getMyBoxListData(
        smartRefreshLayout: SmartRefreshLayout,
        status: MyBlindBoxListStatus = MyBlindBoxListStatus.One,
        isRefresh: Boolean = true
    ) = serverAwait {

        if (isRefresh) getMyBoxListPage = 1

        MyBlindBoxRepo.getMyBoxList(MyBoxListBody(getMyBoxListPage.toString(), status.status))
            .serverData().onSuccess {
                onBizError(smartRefreshLayout, isRefresh) { code, message ->
                    Log.e("xxx", "获取我的盲盒列表信息 接口异常 $code $message")
                }
                onBizOK<ApiPagerResponse<MyBlindBoxListData>> { _, data, _ ->
                    getMyBoxListPage++
                    _getMyBoxListLiveData.postValue(data)
                }
            }.onFailure(smartRefreshLayout, isRefresh) {
                Log.e("xxx", "获取我的盲盒列表信息 接口异常 $it")
            }
    }

}

/**
 * 我的盲盒列表状态对应要传入的status
 */
enum class MyBlindBoxListStatus(val status: String?) {
    //全部
    One(null),

    //已完成
    Two("2|3"),

    //已失效
    Three("4|5"),

    //待评价
    Four("2")
}

/**
 * 我的盲盒
 */
@Keep
data class MyBlindBoxData(
    //盲盒满意度
    val myboxticketnum: Int = 0,
    //可开的盲盒数量
    val boxraisenum: Int = 0
)

/**
 * 我的盲盒列表
 */
@Keep
data class MyBlindBoxListData(
    //盲盒唯一id
    val boxid: Int,
    //状态 1进行中 2未评价 - 已完成 3已完成 45已失效
    val status: Int,
    //盲盒位置
    val subtitle: String?,
    //开盒时间
    val time: String?,
    //标题
    val title: String?
)
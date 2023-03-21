package com.zhixing.zxhy.view_model

import android.util.Log
import androidx.annotation.Keep
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import com.scwang.smart.refresh.layout.SmartRefreshLayout
import com.tuanliu.common.base.BaseViewModel
import com.tuanliu.common.net.*
import com.tuanliu.common.util.SingleLiveEvent
import com.zhixing.network.ext.serverData
import com.zhixing.network.paging.ApiPagerResponse
import com.zhixing.zxhy.InforBannerListData
import com.zhixing.zxhy.InforPopupPicData
import com.zhixing.zxhy.InformationData
import com.zhixing.zxhy.repo.HomeRepo
import com.zhixing.zxhy.service.InforLikeArticleBody
import com.zhixing.zxhy.service.InforPopupPicBody
import com.zhixing.zxhy.service.InformationListBody
import kotlinx.coroutines.delay

class HomeViewModel : BaseViewModel() {

    /**
     * 页面初始化
     */
    fun homeInit() = serverAwait {
        if (showAdvertisingAnyLayer()) {
            getInforPopupPicData()
        }
    }

    //首页信息流列表
    private val _informationListLiveData = MutableLiveData<ApiPagerResponse<InformationData>>()
    val informationListLiveData: LiveData<ApiPagerResponse<InformationData>>
        get() = _informationListLiveData
    private var informationListPage: Int = 1

    /**
     * 获取首页信息流列表
     */
    fun getInformationListData(
        smartRefreshLayout: SmartRefreshLayout,
        isRefresh: Boolean = true
    ) = serverAwait {
        if (isRefresh) informationListPage = 1

        HomeRepo.getInformationListData(
            InformationListBody(
                lng?.toString(),
                lat?.toString(),
                informationListPage.toString()
            )
        ).serverData().onSuccess {
            onBizError { code, message ->
                Log.e("xxx", "获取首页信息流列表 接口异常 $code $message")

            }
            onBizOK<ApiPagerResponse<InformationData>> { _, data, _ ->
                informationListPage++
                _informationListLiveData.postValue(data)
            }
        }.onFailure(smartRefreshLayout, isRefresh) {
            Log.e("xxx", "获取首页信息流列表 接口异常 $it")
        }
    }

    //点赞 / 取消点赞
    private val _inforLikeArticleLiveData = MutableLiveData<String>()
    val inforLikeArticleLiveData: LiveData<String>
        get() = _inforLikeArticleLiveData

    /**
     * 点赞 / 取消点赞
     * [id] 文章id
     */
    fun inforLikeArticle(id: Int) = serverAwait {
        HomeRepo.informationLikeArticle(InforLikeArticleBody(id))
            .serverData().onSuccess {
                onBizError { code, message ->
                    Log.e("xxx", "点赞 / 取消点赞 接口异常 $code $message")
                }
                onBizOK<Any> { _, _, _ ->
                    _inforLikeArticleLiveData.postValue(System.currentTimeMillis().toString())
                }
            }.onFailure {
                Log.e("xxx", "点赞 / 取消点赞 接口异常 $it")
            }
    }

    //首页信息流弹出广告(大霸屏)数据
    private val _inforPopupPicLD = SingleLiveEvent<InforPopupPicData>()
    val inforPopupPicLD: LiveData<InforPopupPicData>
        get() = _inforPopupPicLD

    /**
     * 获取首页信息流弹出广告(大霸屏)
     */
    private suspend fun getInforPopupPicData() = serverAwait {
        HomeRepo.getInformationPopupPic(InforPopupPicBody(lat, lng)).serverData().onSuccess {
            onBizError { code, message ->
                Log.e("xxx", "获取首页信息流弹出广告(大霸屏) 接口异常 $code $message")
            }
            onBizOK<InforPopupPicData> { _, data, _ ->
                _inforPopupPicLD.postValue(data)
            }
        }.onFailure {
            Log.e("xxx", "获取首页信息流弹出广告(大霸屏) 接口异常 $it")
        }
    }

    //首页信息流弹出广告(顶部广告)数据
    private val _inforBannerListLD = SingleLiveEvent<InforBannerListData>()
    val inforBannerListLd: LiveData<InforBannerListData>
        get() = _inforBannerListLD

    /**
     * 获取首页信息流弹出广告(顶部广告)
     */
    fun getInformationBannerList() = serverAwait {
        HomeRepo.getInformationBannerList(InforPopupPicBody(lat, lng)).serverData().onSuccess {
            onBizError { code, message ->
                Log.e("xxx", "获取首页信息流弹出广告(顶部广告) 接口异常 $code $message")
            }
            onBizOK<InforBannerListData> { _, data, _ ->
                _inforBannerListLD.postValue(data)
            }
        }.onFailure {
            Log.e("xxx", "获取首页信息流弹出广告(顶部广告) 接口异常 $it")
        }
    }

}

/**
 * 获取客户端初始化信息数据
 */
@Keep
data class InitData(
    val versions: Versions?,
    val indexshow: Indexshow,
) {
    @Keep
    data class Versions(
        val android: Android?,
    ) {
        @Keep
        data class Android(
            //0-不强制更新 1-强制更新
            val force: Int,
            //版本
            val newest: String?,
            //apk链接
            val url: String?
        )
    }

    @Keep
    data class Indexshow(
        /**
         * 1 - 显示现有ugc功能
         * 2 - 显示webview
         */
        val type: Int = 2,
        //如果type = 2，url为地址
        val url: String = ""
    )
}
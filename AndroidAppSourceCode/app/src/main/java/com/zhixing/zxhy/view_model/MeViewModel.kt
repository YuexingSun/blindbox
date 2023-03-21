package com.zhixing.zxhy.view_model

import android.util.Log
import com.tuanliu.common.base.BaseViewModel
import com.tuanliu.common.net.onBizError
import com.tuanliu.common.net.onBizOK
import com.tuanliu.common.net.onFailure
import com.tuanliu.common.net.onSuccess
import com.zhixing.network.ext.serverData
import com.zhixing.zxhy.repo.MeRepo
import androidx.annotation.Keep
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import com.scwang.smart.refresh.layout.SmartRefreshLayout
import com.tuanliu.common.util.SingleLiveEvent
import com.zhixing.network.paging.ApiPagerResponse
import com.zhixing.zxhy.MyInfoData
import com.zhixing.zxhy.service.MyInfoListBody

class MeViewModel : BaseViewModel() {

    //我的信息数据
    private val _myDataLiveData = MutableLiveData<MyData>()
    val myDataLiveData: LiveData<MyData>
        get() = _myDataLiveData


    /**
     * 获取我的信息
     */
    fun getMyDataList() = serverAwait {
        MeRepo.getMyDataList().serverData().onSuccess {
            onBizError { code, message ->
                Log.e("xxx", "获取我的信息 接口异常 $code $message")
            }
            onBizOK<MyData> { _, data, _ ->
                _myDataLiveData.postValue(data)
            }
        }.onFailure {
            Log.e("xxx", "获取我的信息 接口异常 $it")
        }
    }

    //我发布的笔记数据
    private val _myInfoListLD = SingleLiveEvent<ApiPagerResponse<MyInfoData>>()
    val myInfoListLD: LiveData<ApiPagerResponse<MyInfoData>>
        get() = _myInfoListLD
    private var myInfoPage = 1

    /**
     * 获取我发布的笔记
     */
    fun inforSearchList(
        smartRefreshLayout: SmartRefreshLayout,
        isRefresh: Boolean = true
    ) = serverAwait {

        if (isRefresh) myInfoPage = 1

        MeRepo.inforMyInfoList(MyInfoListBody(myInfoPage))
            .serverData().onSuccess {
                onBizError { code, message ->
                    Log.e("xxx", "获取我发布的笔记 接口异常 $code $message")

                }
                onBizOK<ApiPagerResponse<MyInfoData>> { _, data, _ ->
                    myInfoPage++
                    _myInfoListLD.postValue(data)
                }
            }.onFailure(smartRefreshLayout, isRefresh) {
                Log.e("xxx", "获取我发布的笔记 接口异常 $it")
            }

    }

}

/**
 * 我的信息数据
 */
@Keep
data class MyData(
    //会员相关信息
    val memberinfo: Memberinfo?,
    //成就列表
    val myachievelist: List<Myachievelist>?,
    //进行中的盲盒信息
    val mybeingboxlist: Mybeingboxlist?,
    //我的盲盒数量
    val myboxnum: Int,
    //我的道具数量
    val mypropsnum: Int,
    //近7天开盒数据
    val last7days: LastDayslist?
) {
    @Keep
    data class Memberinfo(
        //用户头像地址
        val avatar: String = "",
        //用户昵称或用户名
        val nickname: String = "",
        //当前所在等级名称
        val nowlevel: String?,
        //下一级的等级名称
        val nextlevel: String?,
        val levelpoint: Int,
        //下级所需的经验
        val nextlevelpoint: Int,
        //当前点数
        val nowpoint: Int
    )

    @Keep
    data class Myachievelist(
        //成就ID
        val achieveid: Int,
        //成就是否已点亮，1是，0未
        val islight: Int,
        //成就点亮后的图标
        val lightpic: String?,
        //成就未点亮时的图标
        val pic: String?,
        //成就名称
        val title: String?
    )

    @Keep
    data class Mybeingboxlist(
        //是否有进行中的盲盒，0没有，1有
        val beingbox: Int,
        //盲盒id
        val boxid: Int = 0,
        //盲盒当前状态 0-5
        val status: Int = 0
    )

    @Keep
    data class LastDayslist(
        val catelist: List<CateList>
    )

    @Keep
    data class CateList(
        //分类id
        val cateid: Int,
        //分类名称
        val catename: String = "",
        //开盒数量
        val number: Int
    )
}
package com.zhixing.zxhy.view_model

import android.util.Log
import androidx.lifecycle.LiveData
import com.tuanliu.common.base.BaseViewModel
import com.tuanliu.common.net.onBizError
import com.tuanliu.common.net.onBizOK
import com.tuanliu.common.net.onFailure
import com.tuanliu.common.net.onSuccess
import com.zhixing.network.ext.serverData
import androidx.annotation.Keep
import androidx.lifecycle.MutableLiveData
import com.tuanliu.common.util.SingleLiveEvent
import com.zhixing.zxhy.repo.HobbyRepo
import com.zhixing.zxhy.service.SetUserTagListData


class HobbyViewModel : BaseViewModel() {

    //key: 标签的id  value:0(无用)
    val tagMap = mutableMapOf<Int, Int>()

    //标签map的大小
    val tagMapLength = MutableLiveData<Int>(0)

    //用户标签信息
    private val _userTagLiveData = SingleLiveEvent<UserTagListData>()
    val userTagLiveData: LiveData<UserTagListData>
        get() = _userTagLiveData


    /**
     * 获取用户标签信息
     */
    fun getUserTagList() = serverAwait {
        HobbyRepo.getUserTagList().serverData().onSuccess {
            onBizError { code, message ->
                Log.e("xxx", "获取用户标签信息 接口异常 $code $message")
            }
            onBizOK<UserTagListData> { _, data, _ ->
                _userTagLiveData.postValue(data)
            }
        }.onFailure {
            Log.e("xxx", "获取用户标签信息 接口异常 $it")
        }
    }


    //设置用户标签信息
    private val _setUserTagLiveData = SingleLiveEvent<String>()
    val setUserTagLiveData: LiveData<String>
        get() = _setUserTagLiveData


    /**
     * 设置用户标签信息
     */
    fun setUserTagList() = serverAwait {

        val array = arrayListOf<Int>()

        for (map in tagMap) {
            array.add(map.key)
        }

        HobbyRepo.setUserTagList(SetUserTagListData(array.toTypedArray())).serverData().onSuccess {
            onBizError { code, message ->
                Log.e("xxx", "设置用户标签信息 接口异常 $code $message")
            }
            onBizOK<Any> { _, _, _ ->
                _setUserTagLiveData.postValue(System.currentTimeMillis().toString())
            }
        }.onFailure {
            Log.e("xxx", "设置用户标签信息 接口异常 $it")
        }
    }
}

/**
 * 用户标签信息
 */
@Keep
data class UserTagListData(
    val `data`: List<UserTag>?,
) {
    @Keep
    data class UserTag(
        val id: Int,
        val ischecked: Int,
        val name: String?
    )
}
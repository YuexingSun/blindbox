package com.zhixing.zxhy.view_model

import android.util.Log
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import com.amap.api.maps.model.LatLng
import com.amap.api.navi.model.NaviLatLng
import com.hjq.toast.ToastUtils
import com.tuanliu.common.base.BaseViewModel
import com.tuanliu.common.net.*
import com.tuanliu.common.util.SingleLiveEvent
import com.zhixing.network.ext.serverData
import com.zhixing.zxhy.repo.SetOutRepo
import com.zhixing.zxhy.service.Boxid
import com.zhixing.zxhy.util.mapUtil.MapUtil

class SetOutViewModel : BaseViewModel() {

    val boxGetOneLiveData = MutableLiveData<GetOneBoxData.Parentlist.Childlist>()
    var notCountDown = false

    //起点
    var mStartPoint: NaviLatLng? = null

    //终点
    val mEndPoint: NaviLatLng
        get() = MapUtil.convertToNaviLatLng(
            LatLng(
                boxGetOneLiveData.value?.lnglat?.lat ?: 0.0,
                boxGetOneLiveData.value?.lnglat?.lng ?: 0.0
            )
        )

    //不满意原因 选择的map数据
    val selectedMap = mutableMapOf<Int, String>()

    //是否满意 1-满意 2-不满意
    var isLike = 0

    //盲盒评价数据
    private val _enjoyBoxLiveData = SingleLiveEvent<String>()
    val enjoyBoxLiveData: LiveData<String>
        get() = _enjoyBoxLiveData

    //提交评价按钮 - 盲盒评价
    fun submitBtn() = serverAwait {

        val boxid = boxGetOneLiveData.value?.boxid ?: return@serverAwait

        if (isLike == 0) ToastUtils.show("请选择评价")

        val lotteryUrl =
            if (boxGetOneLiveData.value?.activityinfo == 1) boxGetOneLiveData.value?.url
                ?: "" else ""

        //满意
        val box = if (isLike == 1) {
            Boxid(boxid)
        } else {

            //如果没选不满意的原因
            if (selectedMap.isEmpty()) {
                ToastUtils.show("请至少选择一项原因")
                return@serverAwait
            }

            //不满意
            var str = ""
            for (map in selectedMap) {
                if (str == "") {
                    str = map.value
                    continue
                }

                str = "$str|${map.value}"
            }
            Boxid(boxid, str)
        }

        SetOutRepo.getBoxEnjoyBox(box).serverData().onSuccess {
            onBizError { code, message ->
                Log.e("xxx", "盲盒评价 接口异常 $code $message")
            }
            onBizOK<Any> { _, _, _ ->
                _enjoyBoxLiveData.postValue(lotteryUrl)
            }
        }.onFailure {
            Log.e("xxx", "盲盒评价 接口异常 $it")
        }.onExecute {
            isLike = 0
        }
    }

    //是否震动过了
    var isVibrate = false

    //盲盒到达数据
    private val _arrivedBoxData = SingleLiveEvent<String>()
    val arrivedBoxData: LiveData<String>
        get() = _arrivedBoxData

    /**
     * 盲盒到达
     */
    fun arrivedBox() = serverAwait {

        isVibrate = true

        val boxid = boxGetOneLiveData.value?.boxid ?: 0

        SetOutRepo.arrivedBox(Boxid(boxid)).serverData().onSuccess {
            onBizError { code, message ->
                Log.e("xxx", "盲盒到达 接口异常 $code $message")
                isVibrate = false
            }
            onBizOK<Any> { _, _, _ ->
                _arrivedBoxData.postValue(System.currentTimeMillis().toString())
            }
        }.onFailure {
            Log.e("xxx", "盲盒到达 接口异常 $it")
            isVibrate = false
        }
    }

    //中止盲盒
    private val _cancelBoxData = SingleLiveEvent<String>()
    val cancelBoxData: LiveData<String>
        get() = _cancelBoxData

    /**
     * 中止盲盒
     */
    fun boxCancelBox() = serverAwait {

        val boxid = Boxid(boxGetOneLiveData.value?.boxid ?: 0)

        SetOutRepo.boxCancelBox(boxid).serverData().onSuccess {
            onBizError { code, message ->
                Log.e("xxx", "中止盲盒 接口异常 $code $message")
            }
            onBizOK<Any> { _, _, _ ->
                //中止盲盒成功
                _cancelBoxData.postValue(System.currentTimeMillis().toString())
            }
        }.onFailure {
            Log.e("xxx", "中止盲盒 接口异常 $it")
        }
    }
}
package com.tuanliu.common.base

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.hjq.toast.ToastUtils
import com.kunminx.architecture.ui.callback.UnPeekLiveData
import com.linx.common.ext.addTo
import com.tuanliu.common.util.SingleLiveEvent
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch

abstract class BaseViewModel : ViewModel() {

    //job列表
    private val jobs: MutableList<Job> = mutableListOf<Job>()

    //标记网络loading状态
    val isLoading = MutableLiveData<Boolean>()

    protected fun serverAwait(block: suspend CoroutineScope.() -> Unit) = viewModelScope.launch {
        //协程启动之前
        isLoading.value = true
        block.invoke(this)
        //协程启动之后
        isLoading.value = false
    }.addTo(jobs)

    //取消全部协程
    override fun onCleared() {
        jobs.forEach { it.cancel() }
        super.onCleared()
    }

    /**
     * 全局的VideModel
     * 使用UnPeekLiveData，可以被多个观察者观察到并且消息被所有观察者消费完毕后才开始阻止倒灌
     * 需要是单例的对象，不然会被重新创建
     */
    companion object {

        //错误码
        val codeRequest = UnPeekLiveData<Int>()

        //跳转到某个菜单页面（主页）
        val skipNavMenu = SingleLiveEvent<MainBottomData>()

        //网络状态改变
        val netWorkStatusChange = UnPeekLiveData<String>()

        //刷新首页列表
        val updateHomeListLayout = SingleLiveEvent<String>()

        //更新用户信息
        val updateUserMessage = SingleLiveEvent<String>()

        //更新我的收藏列表
        val updateMyCollectList = SingleLiveEvent<String>()

        //查询是否有未开启和进行中的盲盒
        val updateCheckBeingBox = SingleLiveEvent<String>()

        var lat: Double? = null
        var lng: Double? = null
        // 保存定位
        fun saveLatLng(mLat: Double, mLng: Double) {
            lat = mLat
            lng = mLng
        }

        //开盲盒
        val openBoxGetOne = SingleLiveEvent<String>()
        //底部，中间，盒子按钮的状态
        val boxBtnStatus = SingleLiveEvent<BoxBtnStatus>()
        //显示/隐藏导航栏
        val isVisibleBottomNavi = SingleLiveEvent<Boolean>()

        /**
         * 改变底部，中间，盒子按钮的状态
         */
        fun setBoxBtnStatus(b: BoxBtnStatus) {
            if (b == BoxBtnStatus.RedRefreshIng && boxBtnStatus.value == BoxBtnStatus.RedRefreshIng) {
                ToastUtils.show("正在获取数据...")
                return
            }
            boxBtnStatus.postValue(b)
        }
    }

}

enum class MainBottomData(val index: Int) {
    //首页
    Home(1),

    //开盒
    Box(0),

    //我的
    Me(2)
}

/**
 * BottomNav按钮的状态
 */
enum class BoxBtnStatus(val status: Int) {
    //红色盒子
    RedBox(0),
    //红色旋转
    RedRefresh(1),
    //红色正在旋转 请求接口
    RedRefreshIng(2),
    //红色停止旋转
    RedRefreshStop(3)
}
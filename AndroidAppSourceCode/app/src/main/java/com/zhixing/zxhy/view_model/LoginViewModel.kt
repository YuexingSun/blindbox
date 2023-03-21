package com.zhixing.zxhy.view_model

import android.util.Log
import cn.jiguang.verifysdk.api.PrivacyBean
import com.tuanliu.common.base.BaseViewModel
import androidx.annotation.Keep
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import com.hjq.toast.ToastUtils
import com.tuanliu.common.net.*
import com.tuanliu.common.util.SingleLiveEvent
import com.tuanliu.common.util.SpUtilsMMKV
import com.zhixing.network.ext.serverData
import com.zhixing.zxhy.repo.LoginMainRepo
import com.zhixing.zxhy.service.LoginByRequest


/**
 * 登录的ViewModel
 */
class LoginViewModel : BaseViewModel() {

    val agreementList = mutableListOf(
        PrivacyBean(
            "《服务条款》",
            "https://h5.sjtuanliu.com/#/pages/service/service",
            "、"
        ),
        PrivacyBean(
            "《隐私协议》",
            "https://h5.sjtuanliu.com/#/pages/Privacy/Privacy",
            "和"
        )
    )

    //通过一键登录拿到的数据
    private val _loginByMobLiveData = SingleLiveEvent<LoginByMobData>()
    val loginByMobLiveData: LiveData<LoginByMobData>
        get() = _loginByMobLiveData

    /**
     * 注册/登录-通过一键登录
     */
    fun loginByMobData(loginByRequest: LoginByRequest) = serverAwait {
        LoginMainRepo.loginByMob(loginByRequest).serverData().onSuccess {
            onBizError { code, message ->
                Log.e("xxx", "注册/登录-通过一键登录 接口异常 $code $message")
            }
            onBizOK<LoginByMobData> { _, data, _ ->
                _loginByMobLiveData.postValue(data)
            }
        }.onFailure {
            Log.e("xxx", "注册/登录-通过一键登录 接口异常 $it")
        }
    }

}

@Keep
data class LoginByMobData(
    //0/1，是否新用户，1是新用户，0是老用户
    val isnew: Int,
    val token: String?
)
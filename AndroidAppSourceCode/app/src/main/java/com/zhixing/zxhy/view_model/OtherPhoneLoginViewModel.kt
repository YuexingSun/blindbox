package com.zhixing.zxhy.view_model

import android.util.Log
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import com.tuanliu.common.base.BaseViewModel
import com.tuanliu.common.net.*
import com.tuanliu.common.util.SingleLiveEvent
import com.tuanliu.common.util.SpUtilsMMKV
import com.zhixing.network.ext.serverData
import com.zhixing.zxhy.repo.OtherPhoneLoginRepo
import com.zhixing.zxhy.service.LoginBySmsCodeData
import com.zhixing.zxhy.service.SafeCodeData
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

class OtherPhoneLoginViewModel : BaseViewModel() {

    //手机号
    var phone = MutableLiveData<String>()

    //验证码
    val code = MutableLiveData<String>()

    //获取验证码按钮的文字
    val getCode = MutableLiveData<String>("获取验证码")

    //是否可以获取验证码
    val isGetCode = MutableLiveData<Boolean>(true)

    /**
     * 获取短信验证码-带安全验证
     */
    fun getSafeSmsCode(ticket: String, randstr: String) = serverAwait {

        if (phone.value?.length != 11) return@serverAwait

        if (isGetCode.value == false) return@serverAwait

        val safeCodeData = SafeCodeData(phone.value.toString(), ticket, randstr)

        OtherPhoneLoginRepo.getSafeSmsCode(safeCodeData).serverData().onSuccess {
            onBizError { code, message ->
                Log.e("xxx", "获取短信验证码-带安全验证 接口异常 $code $message")
                if (isGetCode.value == false) isGetCode.postValue(true)
            }
            onBizOK<Any> { _, _, _ ->
                launch(Dispatchers.IO) {
                    for (index in 60 downTo 0) {
                        when (index) {
                            0 -> {
                                getCode.postValue("获取验证码")
                                isGetCode.postValue(true)
                                break
                            }
                            60 -> {
                                getCode.postValue("重新获取($index)")
                                isGetCode.postValue(false)
                                //退出本次循环
                                continue
                            }
                            else -> {
                                delay(1000)
                                getCode.postValue("重新获取($index)")
                            }
                        }
                    }
                }
            }
        }.onFailure {
            Log.e("xxx", "获取短信验证码-带安全验证 接口异常 $it")
            if (isGetCode.value == false) isGetCode.postValue(true)
        }
    }

    //通过短信验证码拿到的信息
    private val _loginBySmsCodeLiveData = SingleLiveEvent<LoginByMobData>()
    val loginBySmsCodeLiveData: LiveData<LoginByMobData>
        get() = _loginBySmsCodeLiveData

    /**
     * 注册/登录-通过短信验证码
     */
    fun loginBySmsCode() = serverAwait {
        OtherPhoneLoginRepo.loginBySmsCode(
            LoginBySmsCodeData(phone.value.toString(), code.value.toString())
        ).serverData().onSuccess {
            onBizError { code, message ->
                Log.e("xxx", "注册/登录-通过短信验证码 接口异常 $code $message")
            }
            onBizOK<LoginByMobData> { _, data, _ ->
                //保存为临时token
                SpUtilsMMKV.put(CommonConstant.TEMPORARY_TOKEN, data?.token)
                _loginBySmsCodeLiveData.postValue(data)
            }
        }.onFailure {
            Log.e("xxx", "注册/登录-通过短信验证码 接口异常 $it")
        }
    }

}
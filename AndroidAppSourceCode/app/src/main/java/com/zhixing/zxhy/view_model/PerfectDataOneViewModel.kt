package com.zhixing.zxhy.view_model

import android.util.Log
import androidx.lifecycle.MutableLiveData
import com.hjq.toast.ToastUtils
import com.tuanliu.common.base.BaseViewModel
import com.tuanliu.common.net.*
import com.tuanliu.common.util.SpUtilsMMKV
import com.zhixing.network.ext.serverData
import com.zhixing.zxhy.repo.PerfectDataOneRepo
import com.zhixing.zxhy.service.SubmitBaseDataOne

class PerfectDataOneViewModel : BaseViewModel() {

    //用户名
    val userName = MutableLiveData<String>("")

    //用户生日
    val userDate = MutableLiveData<String>("")

    //-1 默认不选中 1-男生 0女生
    val gender = MutableLiveData<Int>(-1)

    /**
     * 性别点击事件 1-男生 0-女生
     */
    fun genderClick(genderNum: Int) {
        gender.value = genderNum
    }

    //跳转到下个页面
    val skipNextFragment = MutableLiveData<String>()

    /**
     * 提交新用户基本信息一
     */
    fun submitBaseDataOneData() = serverAwait {

        if (gender.value == -1) {
            ToastUtils.show("性别不能为空")
            return@serverAwait
        }

        val baseDataOne = SubmitBaseDataOne(
            userName.value ?: "",
            userDate.value.toString().replace(".", "-"),
            gender.value.toString()
        )

        //临时token
        val temporaryToken = SpUtilsMMKV.getString(CommonConstant.TEMPORARY_TOKEN) ?: ""

        PerfectDataOneRepo.submitBaseDataOne(temporaryToken, baseDataOne).serverData().onSuccess {
            onBizError { code, message ->
                Log.e("xxx", "提交新用户基本信息一 接口异常 $code $message")
            }
            onBizOK<Any> { _, _, _ ->
                //跳转到下个页面
                skipNextFragment.postValue(System.currentTimeMillis().toString())
            }
        }.onFailure {
            Log.e("xxx", "提交新用户基本信息一 接口异常 $it")
        }
    }

}
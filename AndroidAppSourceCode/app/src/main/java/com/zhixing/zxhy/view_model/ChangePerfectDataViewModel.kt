package com.zhixing.zxhy.view_model

import android.util.Log
import com.tuanliu.common.base.BaseViewModel
import androidx.lifecycle.MutableLiveData
import com.hjq.toast.ToastUtils
import com.tuanliu.common.net.*
import com.zhixing.network.ext.serverData
import com.zhixing.zxhy.repo.PerfectDataTwoRepo
import com.zhixing.zxhy.service.QuestionAnswerArray

class ChangePerfectDataViewModel : BaseViewModel() {

    //新用户表单问题列表
    val questionListData = MutableLiveData<QuestionData>()

    /**
     * 获取新用户表单问题
     */
    fun getNewUserFromData() = serverAwait {
        PerfectDataTwoRepo.getNewUserFromData().serverData().onSuccess {
            onBizError { code, message ->
                Log.e("xxx", "获取新用户表单问题 接口异常 $code $message")
            }
            onBizOK<QuestionData> { _, data, _ ->
                questionListData.postValue(data)
            }
        }.onFailure {
            Log.e("xxx", "获取新用户表单问题 接口异常 $it")
        }
    }

    //提交新用户信息二结果
    val submitBaseData = MutableLiveData<String>()

    /**
     * 提交新用户信息二
     */
    fun submitBaseDataTwoData(array: Array<QuestionAnswerArray.QuestionAnswerItem>) = serverAwait {

        val questionAnswerArray = QuestionAnswerArray(array)

        PerfectDataTwoRepo.submitBaseDataTwo(answer = questionAnswerArray).serverData().onSuccess {
            onBizError { code, message ->
                Log.e("xxx", "提交新用户信息二 接口异常 $code $message")
            }
            onBizOK<Any> { _, _, _ ->
                ToastUtils.show("修改成功")
                submitBaseData.postValue(System.currentTimeMillis().toString())
            }
        }.onFailure {
            Log.e("xxx", "提交新用户信息二 接口异常 $it")
        }
    }

}
package com.zhixing.zxhy.view_model

import android.util.Log
import com.tuanliu.common.base.BaseViewModel
import androidx.annotation.Keep
import androidx.lifecycle.MutableLiveData
import com.tuanliu.common.net.*
import com.tuanliu.common.util.SpUtilsMMKV
import com.zhixing.network.ext.serverData
import com.zhixing.zxhy.repo.PerfectDataTwoRepo
import com.zhixing.zxhy.service.QuestionAnswerArray

class PerfectDataTwoViewModel : BaseViewModel() {

    //临时token
    val token
        get() = SpUtilsMMKV.getString(CommonConstant.TEMPORARY_TOKEN) ?: ""

    //新用户表单问题列表
    val questionListData = MutableLiveData<QuestionData>()

    /**
     * 获取新用户表单问题
     */
    fun getNewUserFromData() = serverAwait {
        PerfectDataTwoRepo.getNewUserFromData(token).serverData().onSuccess {
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

        PerfectDataTwoRepo.submitBaseDataTwo(token, questionAnswerArray).serverData().onSuccess {
            onBizError { code, message ->
                Log.e("xxx", "提交新用户信息二 接口异常 $code $message")
            }
            onBizOK<Any> { _, _, _ ->
                SpUtilsMMKV.put(CommonConstant.TOKEN, token)
                SpUtilsMMKV.removeKey(CommonConstant.TEMPORARY_TOKEN)
                submitBaseData.postValue(System.currentTimeMillis().toString())
            }
        }.onFailure {
            Log.e("xxx", "提交新用户信息二 接口异常 $it")
        }
    }

}

/**
 * 新用户表单问题数据
 */
@Keep
data class QuestionData(
    val queslist: List<Queslist>?
) {
    @Keep
    data class Queslist(
        //问题的唯一ID
        val id: Int,
        //此值为可选择的范围列表
        val itemlist: List<Itemlist?>?,
        //问题的标题文字
        val title: String?,
        //选中的项的id
        val answer: Int? = -1,
        //选择框展示的类型 4：拖动条 2：按钮
        val type: Int = 4
    ) {
        @Keep
        data class Itemlist(
            //可选项的唯一ID
            val itemid: Int,
            //可选项的文字内容
            val itemname: String?
        )
    }
}
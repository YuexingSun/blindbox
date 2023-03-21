package com.zhixing.zxhy.repo

import com.tuanliu.common.net.ServiceCreator
import com.zhixing.zxhy.service.PerfectDataTwoService
import com.zhixing.zxhy.service.QuestionAnswerArray

object PerfectDataTwoRepo {

    /**
     * 获取新用户表单问题
     */
    fun getNewUserFromData(token: String? = null) =
        ServiceCreator.getService<PerfectDataTwoService>().getNewUserFromData(token)

    /**
     * 提交新用户信息二
     */
    fun submitBaseDataTwo(token: String? = null, answer: QuestionAnswerArray) =
        ServiceCreator.getService<PerfectDataTwoService>().submitBaseDataTwo(token, answer)

}
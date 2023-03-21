package com.zhixing.zxhy.repo

import com.tuanliu.common.net.ServiceCreator
import com.zhixing.zxhy.service.PerfectDataOneService
import com.zhixing.zxhy.service.SubmitBaseDataOne

object PerfectDataOneRepo {

    /**
     * 提交新用户基本信息一
     */
    fun submitBaseDataOne(token: String, baseDataOne: SubmitBaseDataOne) =
        ServiceCreator.getService<PerfectDataOneService>().submitBaseDataOne(token, baseDataOne)

}
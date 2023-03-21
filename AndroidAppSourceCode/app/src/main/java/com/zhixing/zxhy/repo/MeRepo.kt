package com.zhixing.zxhy.repo

import com.tuanliu.common.net.ServiceCreator
import com.zhixing.zxhy.service.MeService
import com.zhixing.zxhy.service.MyInfoListBody

object MeRepo {

    /**
     * 获取我的信息
     */
    fun getMyDataList() = ServiceCreator.getService<MeService>().getMyDataList()

    /**
     * 获取我发布的文章列表
     */
    fun inforMyInfoList(myInfoListBody: MyInfoListBody) = ServiceCreator.getService<MeService>().inforMyInfoList(myInfoListBody)

}
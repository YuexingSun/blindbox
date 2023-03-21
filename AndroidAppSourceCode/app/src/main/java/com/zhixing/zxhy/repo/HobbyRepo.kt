package com.zhixing.zxhy.repo

import com.tuanliu.common.net.ServiceCreator
import com.zhixing.zxhy.service.HobbyService
import com.zhixing.zxhy.service.SetUserTagListData
import retrofit2.http.Body

object HobbyRepo {

    //获取用户标签信息
    fun getUserTagList() = ServiceCreator.getService<HobbyService>().getUserTagList()

    //设置用户标签信息
    fun setUserTagList(setUserTagListData: SetUserTagListData) =
        ServiceCreator.getService<HobbyService>().setUserTagList(setUserTagListData)

}
package com.zhixing.zxhy.repo

import com.tuanliu.common.net.ServiceCreator
import com.zhixing.zxhy.service.MyBlindBoxService
import com.zhixing.zxhy.service.MyBoxListBody

object MyBlindBoxRepo {

    //获取我的盲盒
    fun getMyBox() = ServiceCreator.getService<MyBlindBoxService>().getMyBox()

    //获取我的盲盒列表
    fun getMyBoxList(myBoxListBody: MyBoxListBody) =
        ServiceCreator.getService<MyBlindBoxService>().getMyBoxList(myBoxListBody)

}
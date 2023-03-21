package com.zhixing.zxhy.repo

import com.tuanliu.common.net.ServiceCreator
import com.zhixing.zxhy.service.*

object AboutMeRepo {

    //获取客户端初始化信息
    fun getInitData() =
        ServiceCreator.getService<AboutMeService>().getInitData()

}
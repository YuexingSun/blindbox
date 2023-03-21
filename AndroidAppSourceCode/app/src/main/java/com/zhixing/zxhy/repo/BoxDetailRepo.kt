package com.zhixing.zxhy.repo

import com.tuanliu.common.net.ServiceCreator
import com.zhixing.zxhy.service.BoxDetailService
import com.zhixing.zxhy.service.Boxid

object BoxDetailRepo {

    //获取盲盒详情
    fun getBoxDetail(boxid: Boxid) = ServiceCreator.getService<BoxDetailService>().getBoxDetail(boxid)

    //盲盒评价
    fun getBoxEnjoyBox(boxid: Boxid) = ServiceCreator.getService<BoxDetailService>().getBoxEnjoyBox(boxid)

}
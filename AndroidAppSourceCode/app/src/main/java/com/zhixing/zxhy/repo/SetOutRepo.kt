package com.zhixing.zxhy.repo

import com.tuanliu.common.net.ServiceCreator
import com.zhixing.zxhy.service.Boxid
import com.zhixing.zxhy.service.SetOutService

object SetOutRepo {

    //盲盒评价
    fun getBoxEnjoyBox(boxid: Boxid) = ServiceCreator.getService<SetOutService>().getBoxEnjoyBox(boxid)

    //盲盒到达
    fun arrivedBox(boxid: Boxid) = ServiceCreator.getService<SetOutService>().arrivedBox(boxid)

    //中止盲盒
    fun boxCancelBox(boxid: Boxid) =
        ServiceCreator.getService<SetOutService>().boxCancelBox(boxid)

}
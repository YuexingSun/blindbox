package com.zhixing.zxhy.repo

import com.tuanliu.common.net.ServiceCreator
import com.zhixing.zxhy.service.*

object SearchRepo {

    //信息流搜索列表
    fun inforSearchList(searchListBody: SearchListBody) =
        ServiceCreator.getService<SearchService>().inforSearchList(searchListBody)

}
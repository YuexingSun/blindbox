package com.zhixing.zxhy.repo

import com.tuanliu.common.net.ServiceCreator
import com.zhixing.zxhy.service.*

object MyCollectRepo {

    //我收藏的文章
    fun informationMyFavList(inforMyFavListBody: InforMyFavListBody) =
        ServiceCreator.getService<MyCollectService>().informationMyFavList(inforMyFavListBody)

    //收藏 / 取消收藏
    fun informationFavActicle(inforFavActicleBody: InforFavActicleBody) =
        ServiceCreator.getService<MyCollectService>().informationFavActicle(inforFavActicleBody)

}
package com.zhixing.zxhy.repo

import com.tuanliu.common.net.ServiceCreator
import com.zhixing.zxhy.service.ArticleDetailsService
import com.zhixing.zxhy.service.InforCreateInfoBody
import com.zhixing.zxhy.service.InforDetailBody
import com.zhixing.zxhy.service.SendArticleService

object SendArticleRepo {

    /**
     * 写笔记或修改笔记
     */
    fun inforCreateInfo(inforCreateInfoBody: InforCreateInfoBody) =
        ServiceCreator.getService<SendArticleService>().inforCreateInfo(inforCreateInfoBody)

    //获取文章详情
    fun inforGetDetailData(inforDetailBody: InforDetailBody) =
        ServiceCreator.getService<SendArticleService>().inforGetDetailData(inforDetailBody)

}
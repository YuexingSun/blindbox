package com.zhixing.zxhy.repo

import com.tuanliu.common.net.ServiceCreator
import com.zhixing.zxhy.service.*

object HomeRepo {

    //获取首页信息流弹出广告(大霸屏)
    fun getInformationPopupPic(inforPopupPicBody: InforPopupPicBody) =
        ServiceCreator.getService<HomeService>().getInformationPopupPic(inforPopupPicBody)

    //获取首页信息流弹出广告(顶部广告)
    fun getInformationBannerList(inforPopupPicBody: InforPopupPicBody) =
        ServiceCreator.getService<HomeService>().getInformationBannerList(inforPopupPicBody)

    //获取客户端初始化信息
    fun getInitData() =
        ServiceCreator.getService<HomeService>().getInitData()

    //获取首页信息流列表
    fun getInformationListData(informationListBody: InformationListBody) =
        ServiceCreator.getService<HomeService>().getInformationListData(informationListBody)

    //点赞 / 取消点赞
    fun informationLikeArticle(informationLikeArticleBody: InforLikeArticleBody) =
        ServiceCreator.getService<HomeService>().informationLikeArticle(informationLikeArticleBody)

}
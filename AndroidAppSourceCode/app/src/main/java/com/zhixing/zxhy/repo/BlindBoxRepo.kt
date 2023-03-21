package com.zhixing.zxhy.repo

import com.tuanliu.common.net.ServiceCreator
import com.zhixing.zxhy.service.*
import com.zhixing.zxhy.view_model.BoxGetOneData
import com.zhixing.zxhy.view_model.StartBox

object BlindBoxRepo {

    //获取盲盒待答问题
    fun getBoxQuesList() =
        ServiceCreator.getService<BlindBoxService>().getBoxQuesList()

    //查询是否有未开启和进行中的盲盒
    fun checkBeingBox() =
        ServiceCreator.getService<BlindBoxService>().checkBeingBox()

    //获取盲盒
    fun boxGetOne(boxGetOneData: BoxGetOneData) =
        ServiceCreator.getService<BlindBoxService>().boxGetOne(boxGetOneData)

    //获取盲盒详情
    fun getBoxDetail(boxid: Boxid) = ServiceCreator.getService<BlindBoxService>().getBoxDetail(boxid)

    //开始一个盲盒
    fun startBox(startBox: StartBox) =
        ServiceCreator.getService<BlindBoxService>().startBox(startBox)

    //盲盒评价
    fun getBoxEnjoyBox(boxid: Boxid) = ServiceCreator.getService<BlindBoxService>().getBoxEnjoyBox(boxid)

    //可选分类
    fun getBoxCateTypes(boxCateTypesBody: BoxCateTypesBody) = ServiceCreator.getService<BlindBoxService>().getBoxCateTypes(boxCateTypesBody)



}
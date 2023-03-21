package com.zhixing.zxhy.repo

import com.tuanliu.common.net.ServiceCreator
import com.zhixing.zxhy.service.LoginMainService
import com.zhixing.zxhy.service.LoginByRequest

object LoginMainRepo {

    /**
     * 注册/登录-通过一键登录
     * [code] 极光的loginToken信息
     */
    fun loginByMob(loginByRequest: LoginByRequest) = ServiceCreator.getService<LoginMainService>().loginByMob(loginByRequest)

}
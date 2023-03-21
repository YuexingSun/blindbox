package com.zhixing.zxhy.repo

import com.tuanliu.common.net.ServiceCreator
import com.zhixing.zxhy.service.SetUserProfileService
import com.zhixing.zxhy.service.SettingService
import com.zhixing.zxhy.service.ChangeUserProfileData
import okhttp3.MultipartBody

object SettingRepo {

    //获取用户资料信息
    fun getUserProfile() = ServiceCreator.getService<SettingService>().getUserProfile()

    //退出登录
    fun userLogout() = ServiceCreator.getService<SettingService>().userLogout()

}
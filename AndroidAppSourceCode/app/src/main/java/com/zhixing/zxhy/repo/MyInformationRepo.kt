package com.zhixing.zxhy.repo

import com.tuanliu.common.net.ServiceCreator
import com.zhixing.zxhy.service.SetUserProfileService
import com.zhixing.zxhy.service.SettingService
import com.zhixing.zxhy.service.ChangeUserProfileData
import com.zhixing.zxhy.service.MyInformationService
import okhttp3.MultipartBody

object MyInformationRepo {

    //获取用户资料信息
    fun getUserProfile() = ServiceCreator.getService<MyInformationService>().getUserProfile()

    //上传文件
    fun uploadFile(file: MultipartBody.Part) =
        ServiceCreator.getService<MyInformationService>().uploadFile(file)

    /**
     * 设置用户资料信息
     */
    fun setUserProfile(dataChange: ChangeUserProfileData) =
        ServiceCreator.getService<MyInformationService>().setUserProfile(dataChange)

}
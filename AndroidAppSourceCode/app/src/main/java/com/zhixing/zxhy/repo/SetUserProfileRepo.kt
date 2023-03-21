package com.zhixing.zxhy.repo

import com.tuanliu.common.net.ServiceCreator
import com.zhixing.zxhy.service.LoginBySmsCodeData
import com.zhixing.zxhy.service.SetUserProfileService
import com.zhixing.zxhy.service.ChangeUserProfileData

object SetUserProfileRepo {

    /**
     * 设置用户资料信息
     */
    fun setUserProfile(dataChange: ChangeUserProfileData) =
        ServiceCreator.getService<SetUserProfileService>().setUserProfile(dataChange)

    /**
     * 修改手机号码
     */
    fun setUserNewPhone(data: LoginBySmsCodeData) =
        ServiceCreator.getService<SetUserProfileService>().setUserNewPhone(data)

}
package com.zhixing.zxhy.repo

import com.tuanliu.common.net.ServiceCreator
import com.zhixing.zxhy.service.LoginBySmsCodeData
import com.zhixing.zxhy.service.OtherPhoneLoginService
import com.zhixing.zxhy.service.SafeCodeData
import com.zhixing.zxhy.service.SmsCodeData

object OtherPhoneLoginRepo {

    /**
     * 获取短信验证码-带安全验证
     */
    fun getSafeSmsCode(safeCodeData: SafeCodeData) =
        ServiceCreator.getService<OtherPhoneLoginService>().getSafeSmsCode(safeCodeData)

    /**
     * 注册/登录-通过短信验证码
     */
    fun loginBySmsCode(loginBySmsCodeData: LoginBySmsCodeData) =
        ServiceCreator.getService<OtherPhoneLoginService>().getLoginBySmsCode(loginBySmsCodeData)

}
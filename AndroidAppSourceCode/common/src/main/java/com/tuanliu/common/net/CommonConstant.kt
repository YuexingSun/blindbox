package com.tuanliu.common.net

import com.blankj.utilcode.util.TimeUtils
import com.tuanliu.common.util.SpUtilsMMKV

/**
 * 描述　: 项目中的一些全局变量配置和相关的方法
 */
object CommonConstant {

    // 存放token
    const val TOKEN = "token"

    // 存放临时token 如果用户没有填完资料的话就不会转变为真正的token
    const val TEMPORARY_TOKEN = "temporary_token"

    // 是否同意协议
    const val AGREEMENT = "agreement"

    // 腾讯云验证码的CaptchaAppId
    const val TCAPTCHA_APPID = "2074698099"

    //是否显示过引导页 false true
    const val GUIDE_PAGE_HINT = "guide_page_hint"

    //大霸屏弹窗是否需要弹
    const val ADVERTISING_DATE = "advertising_date"

}

/**
 * 用户退出登陆需要执行的操作
 */
fun quitLogout() {
    //清空token
    SpUtilsMMKV.removeKey(CommonConstant.TOKEN)
    SpUtilsMMKV.removeKey(CommonConstant.TEMPORARY_TOKEN)
    SpUtilsMMKV.removeKey(CommonConstant.ADVERTISING_DATE)
}

/**
 * 大霸屏弹窗是否需要显示
 */
fun showAdvertisingAnyLayer(): Boolean {
    val spDate = SpUtilsMMKV.getString(CommonConstant.ADVERTISING_DATE) ?: "none"
    val nowDate = (TimeUtils.getSafeDateFormat("yyyy-MM-dd") ?: "").toString()
    return if (nowDate != spDate) {
        SpUtilsMMKV.put(CommonConstant.ADVERTISING_DATE, nowDate)
        true
    } else false
}

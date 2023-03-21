package com.zhixing.zxhy.util.databinding

object OtherPhoneLogin {

    /**
     * 获取验证码是否可以点击
     */
    @JvmStatic
    fun getCodeEnable(phoneLength: Int = 0, isGetCode: Boolean? = false): Boolean {
        return when(phoneLength){
            11 -> isGetCode == true
            else -> false
        }
    }

}
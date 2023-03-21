package com.zhixing.zxhy.util.databinding

object SetPhone {

    /**
     * 保存按钮是否可以点击
     */
    @JvmStatic
    fun saveIsEnable(phone: String?, code: String?): Boolean {
        if (phone == null || code == null) return false

        return phone.length == 11 && code.length == 6
    }

}
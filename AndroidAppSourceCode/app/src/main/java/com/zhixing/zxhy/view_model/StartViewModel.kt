package com.zhixing.zxhy.view_model

import com.tuanliu.common.base.BaseViewModel
import com.tuanliu.common.net.CommonConstant
import com.tuanliu.common.util.SpUtilsMMKV

class StartViewModel : BaseViewModel() {

    //是否同意了协议
    val isAgreement: Boolean
        get() = SpUtilsMMKV.getBoolean(CommonConstant.AGREEMENT) == true

}
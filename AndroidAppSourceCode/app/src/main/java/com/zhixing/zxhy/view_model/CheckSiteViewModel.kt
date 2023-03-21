package com.zhixing.zxhy.view_model

import androidx.lifecycle.MutableLiveData
import com.tuanliu.common.base.BaseViewModel
import com.zhixing.zxhy.CheckSiteData

class CheckSiteViewModel: BaseViewModel() {

    val checkSiteData = MutableLiveData(CheckSiteData())

}
package com.zhixing.zxhy.ui.fragment

import android.os.Bundle
import com.tuanliu.common.base.BaseDbFragment
import com.tuanliu.common.model.FragmentConfigData
import com.tuanliu.common.model.StatusBarMode
import com.zhixing.zxhy.databinding.FragmentMyPropIndexBinding
import com.zhixing.zxhy.view_model.MyCollectViewModel

/**
 * 已使用页面
 */
class PropTwoFragment :
    BaseDbFragment<MyCollectViewModel, FragmentMyPropIndexBinding>() {

    override fun initView(savedInstanceState: Bundle?) {
        mDataBind.TextViewA.text = "已使用"
    }

    override fun fragmentConfigInit(): FragmentConfigData =
        FragmentConfigData(
            false,
            transparentStatusBar = false,
            statusBarMode = StatusBarMode.STATUS_BAR_MODE_DARK,
            transparentNavigationBar = false
        )

}
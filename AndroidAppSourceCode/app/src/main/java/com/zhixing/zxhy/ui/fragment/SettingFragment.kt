package com.zhixing.zxhy.ui.fragment

import android.os.Bundle
import android.widget.TextView
import androidx.navigation.fragment.findNavController
import com.tuanliu.common.base.BaseDbFragment
import com.tuanliu.common.ext.animationNav
import com.tuanliu.common.ext.anyLayer
import com.tuanliu.common.ext.glideDefault
import com.tuanliu.common.model.FragmentConfigData
import com.tuanliu.common.model.StatusBarMode
import com.tuanliu.common.net.quitLogout
import com.tuanliu.common.util.BitmapUtil
import com.zhixing.zxhy.R
import com.zhixing.zxhy.databinding.FragmentSettingBinding
import com.zhixing.zxhy.util.AliYunImage
import com.zhixing.zxhy.view_model.SettingViewModel
import per.goweii.anylayer.Layer

/**
 * 设置页面
 */
class SettingFragment : BaseDbFragment<SettingViewModel, FragmentSettingBinding>() {

    override fun initView(savedInstanceState: Bundle?) {
        mDataBind.apply {
            vm = mViewModel

            //返回
            Back.setOnClickListener {
                findNavController().navigateUp()
            }
            //编辑个人资料页面
            MyInformation.setOnClickListener {
                animationNav(R.id.action_settingFragment_to_myInformationFragment)
            }
            //修改手机号
            PhoneConst.setOnClickListener {
                val bundle = Bundle().apply {
                    putString("Phone", mViewModel.userProfileLiveData.value?.mob.toString())
                }
                animationNav(R.id.action_settingFragment_to_setPhoneFragment, bundle)
            }
            //关于我们
            AboutUsConst.setOnClickListener {
                val bundle = Bundle().apply {
                    putString("WX_SERVICE", mViewModel.userProfileLiveData.value?.servicewechat)
                }
                animationNav(R.id.action_settingFragment_to_aboutMeFragment, bundle)
            }
            //退出登录
            QuitLogin.setOnClickListener {
                if (!quitAnyLayer.isShown) quitAnyLayer.show()
            }
            //兴趣偏好
            PreferConst.setOnClickListener {
                animationNav(R.id.action_settingFragment_to_changePerfectDataFragment)
            }
            //版本号
            VersionNum.text = "${BitmapUtil.packageCode(requireContext())}"
        }
    }

    override fun initNetRequest() {
        mViewModel.getUserProfile()
    }

    override fun initLiveData() {
        mViewModel.apply {

            //用户资料信息
            userProfileLiveData.observerKt { data ->
                mDataBind.AvatarImage.glideDefault(
                    requireContext(),
                    AliYunImage.mfit(data?.headimg.toString(), 150),
                    false
                )
            }

            //用户退出登录
            userLogoutLiveData.observerKt {
                quitLogout()
                findNavController().navigate(R.id.startFragment)
            }

        }
    }

    //退出登录弹窗
    private val quitAnyLayer by lazy {
        anyLayer(cancelable = true).contentView(R.layout.dialog_hint_one)
            .onClickToDismiss(Layer.OnClickListener { _, _ ->
            }, R.id.Cancel)
            .onClickToDismiss(Layer.OnClickListener { _, _ ->
                //退出登录
                mViewModel.userLogout()
            }, R.id.Confirm)
            .onInitialize { layer ->
                val title = layer.getView<TextView>(R.id.Title)
                title?.text = "是否退出账号？"
            }
    }

    override fun fragmentConfigInit(): FragmentConfigData =
        FragmentConfigData(
            false,
            transparentStatusBar = true,
            statusBarMode = StatusBarMode.STATUS_BAR_MODE_DARK,
            transparentNavigationBar = false,
            navigationBarColor = R.color.c_EF
        )

}
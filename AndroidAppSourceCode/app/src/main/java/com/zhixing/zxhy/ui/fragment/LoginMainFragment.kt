package com.zhixing.zxhy.ui.fragment

import cn.jiguang.verifysdk.api.*
import android.os.Bundle
import android.view.Gravity
import android.widget.Button
import android.widget.TextView
import com.hjq.toast.ToastUtils
import com.tuanliu.common.base.BaseDbFragment
import com.tuanliu.common.ext.animationNav
import com.tuanliu.common.model.FragmentConfigData
import com.tuanliu.common.model.StatusBarMode
import com.tuanliu.common.net.CommonConstant
import com.tuanliu.common.util.SpUtilsMMKV
import com.zhixing.zxhy.R
import com.zhixing.zxhy.databinding.FragmentLoginMainBinding
import com.zhixing.zxhy.view_model.LoginViewModel
import android.widget.RelativeLayout
import androidx.lifecycle.lifecycleScope
import androidx.navigation.fragment.findNavController
import com.blankj.utilcode.util.AppUtils
import com.blankj.utilcode.util.TimeUtils
import com.tuanliu.common.ext.dp2Pix
import com.tuanliu.common.ext.getResColor
import com.zhixing.zxhy.service.LoginByRequest
import com.zhixing.zxhy.util.toPermission.JiGuangPermission
import kotlinx.coroutines.launch


/**
 * 登录的首页
 */
class LoginMainFragment : BaseDbFragment<LoginViewModel, FragmentLoginMainBinding>() {

    companion object {
        //是否手动前往其他登录
        var goOtherLogin = false

        //当天是否已经在当前页面获取过权限，如果已经弹过窗就不再弹窗
        const val LOGIN_MAIN_GET_PERMISSION = "LOGIN_MAIN_GET_PERMISSION"
    }

    //控制页面的状态
    private var loginMainData: LoginMainData = LoginMainData.Start

    private var jiGuangPermission: JiGuangPermission =
        JiGuangPermission(this)

    //当天是否已经获取过当前页面的权限
    private val isGetPermission: Boolean
        get() {
            val nowDate = (TimeUtils.getSafeDateFormat("yyyy-MM-dd") ?: "").toString()
            val oldDate = SpUtilsMMKV.getString(LOGIN_MAIN_GET_PERMISSION) ?: ""
            return nowDate == oldDate
        }

    override fun initView(savedInstanceState: Bundle?) {
        initPermission()
    }

    override fun initNetRequest() {
        mViewModel.apply {
            //注册/登录-通过一键登录
            loginByMobLiveData.observerKt { data ->
                when (data?.isnew) {
                    //老用户，直接跳转到MainFragment
                    0 -> {
                        SpUtilsMMKV.put(CommonConstant.TOKEN, data.token)
                        findNavController().navigate(R.id.action_loginMainFragment_to_mainFragment)
                    }
                    //新用户,走资料完善流程
                    1 -> {
                        //保存为临时token
                        SpUtilsMMKV.put(CommonConstant.TEMPORARY_TOKEN, data.token)
                        findNavController().navigate(R.id.action_loginMainFragment_to_perfectDataOneFragment)
                    }
                }
            }
        }
    }

    /**
     * 初始化权限相关内容
     */
    private fun initPermission() {
        when (isGetPermission) {
            false -> {
                jiGuangPermission.checkPermission(
                    noPermission = {
                        skipOtherPhoneLoginNoBack()
                    }
                ) {
                    jVGetToken()
                }
                val nowDate = (TimeUtils.getSafeDateFormat("yyyy-MM-dd") ?: "").toString()
                SpUtilsMMKV.put(LOGIN_MAIN_GET_PERMISSION, nowDate)
            }
            true -> {
                when (jiGuangPermission.isGrantedPermission(requireContext())) {
                    false -> skipOtherPhoneLoginNoBack()
                    true -> jVGetToken()
                }
            }
        }
    }

    /**
     * 获取极光token
     */
    private fun jVGetToken() {
        JVerificationInterface.getToken(
            requireContext(), 6000
        ) { p0, _, _ ->
            when (p0) {
                //获取token成功 前往自动登录
                2000 -> {
                    controlAgreementUI()

                    jVerificationLoginAuth()
                }
                //正在获取token中，不操作
                2008 -> {
                }
                else -> {
                    ToastUtils.show("当前网络环境不支持使用一键登录，请手动获取验证码登录。${p0}")
                    skipOtherPhoneLoginNoBack()
                }
            }
        }
    }

    /**
     * 调用loginAuth方法加载登录页面
     */
    private fun jVerificationLoginAuth() {

        //极光登录设置
        val jVAuthSettings = LoginSettings().apply {
            //授权成功后自动关闭授权页
            isAutoFinish = false
            //超时时间
            timeout = 5000
            //todo 这里可以添加监听，loading
//            authPageEventListener = object : AuthPageEventListener() {
//                override fun onEvent(p0: Int, p1: String?) {}
//            }
        }

        JVerificationInterface.loginAuth(
            requireContext(), jVAuthSettings
        ) { code: Int, content: String, _: String? ->
            when (code) {
                //登录成功
                6000 -> {
                    loginMainData = LoginMainData.Success
                    JVerificationInterface.dismissLoginAuthActivity()
                    lifecycleScope.launch {
                        mViewModel.loginByMobData(LoginByRequest(content))
                    }
                }
                //用户取消获取loginToken （返回）
                6002 -> {
                    if (!goOtherLogin) {
                        loginMainData = LoginMainData.Finish
                        JVerificationInterface.dismissLoginAuthActivity()
                    } else goOtherLogin = false
                }
                else -> {
                    loginMainData = LoginMainData.Success
                    JVerificationInterface.dismissLoginAuthActivity()
                    ToastUtils.show("当前网络环境不支持使用一键登录，请手动获取验证码登录。${code}")
                    skipOtherPhoneLoginNoBack()
                }
            }
        }
    }

    /**
     * 跳转至手动登录页面
     * 这个页面出栈
     */
    private fun skipOtherPhoneLoginNoBack() {
        ToastUtils.show("未给予权限，请手动输入号码登录")
        loginMainData = LoginMainData.NoBack
        lifecycleScope.launch {
            //当前页面直接出栈，不返回
            val bundle = Bundle()
            bundle.putInt("isNotBack", 1)
            animationNav(R.id.action_loginMainFragment_to_otherPhoneLoginFragmentOne, bundle)
        }
    }

    /**
     * 跳转至手动登录页面
     * 这个页面不出栈
     */
    private fun skipOtherPhoneLogin() {
        goOtherLogin = true
        animationNav(R.id.action_loginMainFragment_to_otherPhoneLoginFragment)
    }

    /**
     * 自定义一键登录页面的UI
     */
    private fun controlAgreementUI() {

        val (appNameTv, otherPhoneLoginBtn) = initLayoutParams()

        val uiConfig = JVerifyUIConfig.Builder()
            //背景图
            .setAuthBGImgPath("bg_login_main")
            //隐藏导航栏
            .setNavHidden(true)
            //虚拟按键栏透明
            .setVirtualButtonTransparent(true)
            //状态栏透明
            .setStatusBarTransparent(true)
            //状态栏深色
            .setStatusBarDarkMode(true)
            //logo宽高
            .setLogoWidth(88)
            .setLogoHeight(88)
            //logo图片
            .setLogoImgPath("ic_login_app")
            //logo相对于标题栏的y轴偏移
            .setLogoOffsetY(143)
            //手机号码字体颜色
            .setNumberColor(R.color.c_BF000000)
            //手机号码字体大小
            .setNumberSize(24)
            //手机号码相对于标题栏的y轴偏移
            .setNumFieldOffsetY(336)
            //登录按钮文字
            .setLogBtnImgPath("ic_login_main_local")
            .setLogBtnText("本机号码一键登录")
            .setLogBtnTextSize(16)
            .setLogBtnOffsetY(399)
            .setLogBtnWidth(311)
            .setLogBtnHeight(48)
            .setLogBtnTextBold(true)
            //slogan隐藏
            .setSloganHidden(true)
            //隐私条款 默认选中
            .setPrivacyState(true)
            //居中
            .setPrivacyTextCenterGravity(true)
            .setPrivacyNameAndUrlBeanList(mViewModel.agreementList)
            .setPrivacyText("请选择任意方式注册或登录，意味着你同意我们的", "。")
            //加书名号
            .setPrivacyWithBookTitleMark(true)
            //隐藏隐私协议的checkbox
//            .setPrivacyCheckboxHidden(true)
            //离屏幕两边的距离
            .setPrivacyOffsetX(44)
            //y轴偏移 相对于导航栏下端
            .setPrivacyTopOffsetY(548)
            .setPrivacyTextSize(14)
            .setAppPrivacyColor(
                requireContext().getResColor(R.color.c_BF442C60),
                requireContext().getResColor(R.color.c_FF599F)
            )
            //知行盒一
            .addCustomView(appNameTv, false) { _, _ -> }
            //其他手机号码登录
            .addCustomView(otherPhoneLoginBtn, true) { _, _ ->
                skipOtherPhoneLogin()
            }
            .build()
        JVerificationInterface.setCustomUIWithConfig(uiConfig)
    }

    /**
     * 初始化两个放在一键登录页面的控件
     */
    private fun initLayoutParams(): Pair<TextView, Button> {
        //app名称
        val appNameTv = TextView(requireContext())
        appNameTv.apply {
            text = "知行盒一"
            setTextColor(requireContext().getResColor(R.color.c_FF7C80))
            textSize = 18f
            gravity = Gravity.CENTER
        }
        val mLayoutParams1 = RelativeLayout.LayoutParams(
            RelativeLayout.LayoutParams.MATCH_PARENT,
            RelativeLayout.LayoutParams.WRAP_CONTENT
        )
        mLayoutParams1.setMargins(0, dp2Pix(requireContext(), 246f), 0, 0)
        appNameTv.layoutParams = mLayoutParams1

        //其他手机号码登录button
        val otherPhoneLoginBtn = Button(requireContext())
        otherPhoneLoginBtn.apply {
            text = "其他手机号码登录"
            setBackgroundResource(R.mipmap.ic_login_main_text)
            textSize = 16f
            setTextColor(requireContext().getResColor(R.color.c_FF599F))
        }
        val mLayoutParams2 = RelativeLayout.LayoutParams(
            RelativeLayout.LayoutParams.MATCH_PARENT,
            RelativeLayout.LayoutParams.WRAP_CONTENT
        )
        mLayoutParams2.apply {
            setMargins(0, dp2Pix(requireContext(), 471f), 0, 0)
            marginStart = dp2Pix(requireContext(), 32f)
            marginEnd = dp2Pix(requireContext(), 32f)
        }
        otherPhoneLoginBtn.layoutParams = mLayoutParams2
        return Pair(appNameTv, otherPhoneLoginBtn)
    }

    override fun fragmentConfigInit(): FragmentConfigData =
        FragmentConfigData(
            false,
            transparentStatusBar = true,
            statusBarMode = StatusBarMode.STATUS_BAR_MODE_DARK,
            transparentNavigationBar = true
        )

    override fun onGetFocus(): Boolean = true

    override fun onResume() {
        super.onResume()

        when (loginMainData) {
            LoginMainData.Start -> {
            }
            LoginMainData.Success -> {
                return
            }
            LoginMainData.Finish -> {
                //关闭app
                AppUtils.exitApp()
                return
            }
            LoginMainData.NoBack -> {
                skipOtherPhoneLoginNoBack()
                return
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        JVerificationInterface.clearPreLoginCache()
    }

    enum class LoginMainData {
        Start,
        Finish,
        Success,
        NoBack,
    }

}
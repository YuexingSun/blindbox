package com.zhixing.zxhy.ui.fragment

import android.os.Bundle
import android.text.Editable
import android.text.TextWatcher
import android.view.Gravity
import androidx.navigation.fragment.findNavController
import com.hjq.toast.ToastUtils
import com.noober.background.drawable.DrawableCreator
import com.tencent.captchasdk.TCaptchaDialog
import com.tencent.captchasdk.TCaptchaVerifyListener
import com.tuanliu.common.base.BaseDbFragment
import com.tuanliu.common.ext.*
import com.tuanliu.common.model.FragmentConfigData
import com.tuanliu.common.model.StatusBarMode
import com.tuanliu.common.net.CommonConstant
import com.tuanliu.common.util.SpUtilsMMKV
import com.zhixing.zxhy.R
import com.zhixing.zxhy.databinding.FragmentOtherPhoneLoginBinding
import com.zhixing.zxhy.view_model.OtherPhoneLoginViewModel
import per.goweii.anylayer.widget.SwipeLayout

/**
 * 其他手机号码登录页面
 */
class OtherPhoneLoginFragment :
    BaseDbFragment<OtherPhoneLoginViewModel, FragmentOtherPhoneLoginBinding>() {

    //是否隐藏back按钮，如果是1的话就隐藏
    private val argument by lazy { arguments?.getInt("isNotBack") ?: 0 }

    //验证码弹窗 腾讯云验证码
    private var tCaptchaDialog: TCaptchaDialog? = null

    override fun initView(savedInstanceState: Bundle?) {

        mDataBind.apply {
            vm = mViewModel

            PhoneEdit.addTextChangedListener(phoneTextWatcher)
            mViewModel.showKeyboard(PhoneEdit)

            CodeEdit.addTextChangedListener(codeTextWatcher)

            if (argument == 1)
                Back.gone()
            else
                Back.setOnClickListener { findNavController().navigateUp() }

            //收不到验证码,点击弹出提示框
            NoCodeRemind.setOnClickListener { noCodeRemind.show() }

            //获取验证码
            GetCode.setOnClickListener {
                //拉起腾讯云验证码
                initTCaptchaDialog()
            }
        }

    }

    override fun initLiveData() {
        mViewModel.apply {

            code.observerKt {
                changeLoginButtonColor()
            }

            phone.observerKt {
                changeLoginButtonColor()
            }

            isGetCode.observerKt {
                //如果文字为获取验证码，控件就获取焦点
                if (it == false)
                    mViewModel.showKeyboard(mDataBind.CodeEdit)
            }

            //登录成功
            loginBySmsCodeLiveData.observerKt { data ->
                when (data?.isnew) {
                    //老用户，直接跳转到MainFragment
                    0 -> {
                        SpUtilsMMKV.put(CommonConstant.TOKEN, data.token)
                        findNavController().navigate(R.id.action_otherPhoneLoginFragment_to_mainFragment)
                    }
                    //新用户,走资料完善流程
                    1 -> animationNav(R.id.action_otherPhoneLoginFragment_to_perfectDataOneFragment)
                }
            }
        }
    }

    /**
     * 改变登录按钮的背景颜色和是否可以点击
     */
    private fun changeLoginButtonColor() {
        mViewModel.apply {
            when {
                //可以登录的颜色
                code.value?.length == 6 && phone.value?.length == 11 ->
                    mDataBind.Login.isEnabled = true
                //只在code == 5 / phone == 10的时候改变背景
                code.value?.length == 5 || phone.value?.length == 10 ->
                    mDataBind.Login.isEnabled = false
            }
        }
    }

    /**
     * 弹出腾讯云验证
     */
    private fun initTCaptchaDialog() {
        tCaptchaDialog = TCaptchaDialog(
            requireContext(),
            CommonConstant.TCAPTCHA_APPID,
            listener,
            null
        ).apply {
            //点击外部不可以dismiss
            setCancelable(false)
            //点击外部关闭弹出框
            setCanceledOnTouchOutside(true)
            show()
        }
    }

    //手机号码输入监听
    private val phoneTextWatcher by lazy {
        object : TextWatcher {
            override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {}

            override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {}

            //变化后
            override fun afterTextChanged(p0: Editable?) {
                mViewModel.phone.value = p0.toString()
            }
        }
    }

    //验证码输入监听
    private val codeTextWatcher by lazy {
        object : TextWatcher {
            override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {}

            override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {}

            //变化后
            override fun afterTextChanged(p0: Editable?) {
                mViewModel.code.value = p0.toString()
            }
        }
    }

    //收不到验证码弹框
    private val noCodeRemind by lazy {
        anyLayer(true).contentView(R.layout.dialog_no_code_remind)
            .gravity(Gravity.BOTTOM)
            .swipeDismiss(SwipeLayout.Direction.BOTTOM)
            .onClickToDismiss({ _, _ -> }, R.id.Cancel)
    }

    //腾讯云验证码回调事件
    private val listener by lazy {
        TCaptchaVerifyListener { jsonObject ->
            when (jsonObject.getInt("ret")) {
                0 -> {
                    //随机字符串
                    val randstr = jsonObject.getString("randstr")
                    //用户验证票据
                    val ticket = jsonObject.getString("ticket")
                    mViewModel.getSafeSmsCode(ticket, randstr)
                }
                -1001 -> {
                    ToastUtils.show("验证码弹窗加载错误 ${jsonObject.getString("info")}")
                }
                else -> {
                    ToastUtils.show("验证码弹窗关闭")
                }
            }
        }
    }

    override fun fragmentConfigInit(): FragmentConfigData =
        FragmentConfigData(
            false,
            transparentStatusBar = true,
            statusBarMode = StatusBarMode.STATUS_BAR_MODE_DARK,
            transparentNavigationBar = false
        )

    override fun onDestroy() {
        super.onDestroy()
        if (tCaptchaDialog?.isShowing == true) {
            tCaptchaDialog?.dismiss()
        }
        tCaptchaDialog?.cancel()
    }

}
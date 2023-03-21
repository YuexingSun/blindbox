package com.zhixing.zxhy.ui.fragment

import android.os.Bundle
import android.text.Editable
import android.text.TextWatcher
import android.view.Gravity
import android.view.View
import androidx.navigation.fragment.findNavController
import com.hjq.toast.ToastUtils
import com.noober.background.drawable.DrawableCreator
import com.tencent.captchasdk.TCaptchaDialog
import com.tencent.captchasdk.TCaptchaVerifyListener
import com.tuanliu.common.base.BaseDbFragment
import com.tuanliu.common.base.BaseViewModel.Companion.updateUserMessage
import com.tuanliu.common.ext.*
import com.tuanliu.common.model.FragmentConfigData
import com.tuanliu.common.model.StatusBarMode
import com.tuanliu.common.net.CommonConstant
import com.zhixing.zxhy.R
import com.zhixing.zxhy.databinding.FragmentSetPhoneBinding
import com.zhixing.zxhy.view_model.SetPhoneViewModel
import per.goweii.anylayer.widget.SwipeLayout

/**
 * 修改手机号码页面
 */
class SetPhoneFragment :
    BaseDbFragment<SetPhoneViewModel, FragmentSetPhoneBinding>() {

    //验证码弹窗 腾讯云验证码
    private var tCaptchaDialog: TCaptchaDialog? = null

    override fun initView(savedInstanceState: Bundle?) {
        mDataBind.apply {
            vm = mViewModel

            //返回
            Back.setOnClickListener {
                findNavController().navigateUp()
            }

            //原手机号
            mViewModel.formerPhone.value = arguments?.getString("Phone") ?: ""

            //获取验证码
            getCodeClick = View.OnClickListener {
                //拉起腾讯云验证码
                initTCaptchaDialog()
            }

            PhoneEdit.apply {
                addTextChangedListener(phoneTextWatcher)
                mViewModel.showKeyboard(this)
            }
            CodeEdit.addTextChangedListener(codeTextWatcher)
        }
    }

    override fun initLiveData() {
        mViewModel.apply {
            isGetCode.observerKt {
                //如果文字为获取验证码，控件就获取焦点
                if (it == false)
                    mViewModel.showKeyboard(mDataBind.CodeEdit)
            }

            //设置新的手机号
            newPhoneLiveData.observerKt { time ->
                ToastUtils.show("修改成功")
                updateUserMessage.value = time
                findNavController().navigateUp()
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
            transparentStatusBar = false,
            statusBarMode = StatusBarMode.STATUS_BAR_MODE_DARK,
            transparentNavigationBar = false,
            navigationBarColor = R.color.c_EF
        )

}
package com.zhixing.zxhy.ui.fragment

import android.animation.ObjectAnimator
import android.os.Bundle
import android.text.SpannableString
import android.text.Spanned
import android.text.TextPaint
import android.text.method.LinkMovementMethod
import android.text.style.ClickableSpan
import android.text.style.ForegroundColorSpan
import android.view.View
import androidx.navigation.fragment.findNavController
import com.hjq.toast.ToastUtils
import com.tuanliu.common.base.BaseDbFragment
import com.tuanliu.common.ext.*
import com.tuanliu.common.model.FragmentConfigData
import com.tuanliu.common.model.StatusBarMode
import com.zhixing.zxhy.R
import com.zhixing.zxhy.databinding.FragmentLoginVivoBinding
import com.zhixing.zxhy.util.rotationInfinite
import com.zhixing.zxhy.util.toPermission.JiGuangPermission
import com.zhixing.zxhy.view_model.NullViewModel

/**
 * 登录的页面——vivo专用，显示一个不是自己的一键登录页面
 */
class LoginVivoFragment : BaseDbFragment<NullViewModel, FragmentLoginVivoBinding>() {

    //anyLayer禁止点击(防止重复点击)
    private var banAnyLayerClick = false

    private lateinit var objectAnimator: ObjectAnimator

    private val jiGuangPermission = JiGuangPermission(this)

    override fun initView(savedInstanceState: Bundle?) {
        mDataBind.apply {
            initAgreementText()
            //一键登录
            LocalPhone.setOnClickListener {
                if (!AgCheck.isChecked) {
                    AgConst.shake(400, 4f, toX = 16f)
                    return@setOnClickListener
                }
                LoadingPhone.visible()
                LoginSelect.gone()
                objectAnimator = LoadingPhone.rotationInfinite()
                permissionInit()
            }
            //其他手机号码登录
            OtherPhone.setOnClickListener {
                if (!AgCheck.isChecked) {
                    AgConst.shake(400, 4f, toX = 16f)
                    return@setOnClickListener
                }
                animationNav(R.id.action_loginVivoFragment_to_otherPhoneLoginFragment)
            }
        }
    }

    /**
     * 初始化协议文本
     */
    private fun initAgreementText() {
        banAnyLayerClick = false
        val spannableInfo =
            SpannableString("选择任意方式注册或登录，意味着你同意《服务协议》和《隐私条款》并授权我们获取本机号码。")
        spannableInfo.setSpan(object : ClickableSpan() {
            override fun onClick(widget: View) {
                //如果已经前往下一个页面的话就不会触发点击事件
                if (!banAnyLayerClick) {
                    animationNav(R.id.action_loginVivoFragment_to_agreementFragment)
                    banAnyLayerClick = true
                }
            }

            override fun updateDrawState(ds: TextPaint) {
                //取消下划线
                ds.isUnderlineText = false
            }
        }, 18, 24, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE)
        spannableInfo.setSpan(
            ForegroundColorSpan(
                requireContext().getResColor(R.color.c_1C91E9)
            ), 18, 24, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE
        )
        spannableInfo.setSpan(object : ClickableSpan() {
            override fun onClick(widget: View) {
                //如果已经前往下一个页面的话就不会触发点击事件
                if (!banAnyLayerClick) {
                    val bundle = Bundle()
                    bundle.putBoolean("agreement", true)
                    animationNav(
                        R.id.action_loginVivoFragment_to_agreementFragment,
                        bundle
                    )
                    banAnyLayerClick = true
                }
            }

            override fun updateDrawState(ds: TextPaint) {
                //取消下划线
                ds.isUnderlineText = false
            }
        }, 25, 31, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE)
        spannableInfo.setSpan(
            ForegroundColorSpan(
                requireContext().getResColor(R.color.c_1C91E9)
            ), 25, 31, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE
        )
        mDataBind.AgText.movementMethod = LinkMovementMethod.getInstance()
        mDataBind.AgText.text = spannableInfo
    }

    /**
     * 权限处理
     */
    private fun permissionInit() {
        jiGuangPermission.checkPermission({
            animationNav(R.id.action_loginVivoFragment_to_otherPhoneLoginFragment)
        }) {
            ToastUtils.show("初始化一键登录中...")
            findNavController().navigate(R.id.action_loginVivoFragment_to_loginMainFragment)
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        objectAnimator.cancel()
    }

    override fun fragmentConfigInit(): FragmentConfigData =
        FragmentConfigData(
            false,
            transparentStatusBar = true,
            statusBarMode = StatusBarMode.STATUS_BAR_MODE_DARK,
            transparentNavigationBar = true
        )

    override fun onGetFocus(): Boolean = true

}
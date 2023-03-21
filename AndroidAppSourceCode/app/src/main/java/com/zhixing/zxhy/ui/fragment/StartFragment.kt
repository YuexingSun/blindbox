package com.zhixing.zxhy.ui.fragment

import android.os.Bundle
import android.text.SpannableString
import android.text.Spanned
import android.text.TextPaint
import android.text.method.LinkMovementMethod
import android.text.style.ClickableSpan
import android.text.style.ForegroundColorSpan
import android.view.View
import android.widget.TextView
import androidx.navigation.fragment.findNavController
import cn.jiguang.api.utils.JCollectionAuth
import cn.jiguang.verifysdk.api.JVerificationInterface
import com.blankj.utilcode.util.AppUtils
import com.blankj.utilcode.util.RomUtils
import com.hjq.toast.ToastUtils
import com.tuanliu.common.base.BaseDbFragment
import com.tuanliu.common.ext.animationNav
import com.tuanliu.common.ext.anyLayer
import com.tuanliu.common.ext.getResColor
import com.tuanliu.common.model.FragmentConfigData
import com.tuanliu.common.model.StatusBarMode
import com.tuanliu.common.net.CommonConstant
import com.tuanliu.common.util.SpUtilsMMKV
import com.zhixing.zxhy.R
import com.zhixing.zxhy.databinding.FragmentStartBinding
import com.zhixing.zxhy.util.toPermission.JiGuangPermission
import com.zhixing.zxhy.view_model.StartViewModel
import per.goweii.anylayer.Layer

/**
 * 启动页
 */
class StartFragment : BaseDbFragment<StartViewModel, FragmentStartBinding>() {

    //anyLayer禁止点击(防止重复点击)
    private var banAnyLayerClick = false

    //是否获取了手机号码权限
    private val isGetPermiss: Boolean
        get() = JiGuangPermission(this).isGrantedPermission(requireContext())

    override fun initView(savedInstanceState: Bundle?) {}

    override fun onResume() {
        super.onResume()
        banAnyLayerClick = false
        skipNextFragment()
    }

    /**
     * 做一些启动操作之后跳转到登录页面/MainFragment,由navigation出栈这个页面
     */
    private fun skipNextFragment() {
        when (SpUtilsMMKV.getString(CommonConstant.TOKEN)) {
            "" -> {
                if (anyLayer.isShown) return
                else if (!mViewModel.isAgreement) anyLayer.show()
                else initJg()
            }
            //跳转到首页
            else -> findNavController().navigate(R.id.action_startFragment_to_mainFragment)
        }
    }

    /**
     * 初始化极光
     */
    private fun initJg() {
        JCollectionAuth.setAuth(requireContext(), true)

        if (!JVerificationInterface.checkVerifyEnable(requireContext())) {
            ToastUtils.show("当前网络环境不支持使用一键登录，请手动获取验证码登录。")
            skipOtherPhoneLoginFragment()
            return
        }

        JVerificationInterface.init(requireContext(), 5000) { code: Int, _: String ->
            when (code) {
                //初始化成功
                8000 -> {
                    if (RomUtils.isVivo() && !isGetPermiss) {
                        //vivo且没有获取到权限
                        findNavController().navigate(R.id.action_startFragment_to_loginVivoFragment)
                    } else {
                        animationNav(R.id.action_startFragment_to_loginMainFragment)
                    }
                }
                else -> {
                    ToastUtils.show("一键登录初始化失败，请使用手动登录。")
                    skipOtherPhoneLoginFragment()
                }
            }
        }
    }

    /**
     * 跳转到其他手机号码登录页面
     */
    private fun skipOtherPhoneLoginFragment() {
        val bundle = Bundle()
        bundle.putInt("isNotBack", 1)
        animationNav(R.id.action_startFragment_to_otherPhoneLoginFragment, bundle)
    }

    //协议弹窗
    private
    val anyLayer by lazy {
        anyLayer().contentView(R.layout.dialog_login_main_agreement)
            .onClickToDismiss(Layer.OnClickListener { _, _ ->
                //关闭app
                AppUtils.exitApp()
            }, R.id.DialogNo)
            .onClickToDismiss(Layer.OnClickListener { _, _ ->
                //记录隐私弹窗同意标识
                SpUtilsMMKV.put(CommonConstant.AGREEMENT, true)
                initJg()
            }, R.id.DialogYes)
            //不拦截物理按键
            .interceptKeyEvent(false)
            .onInitialize { layer ->
                val textView = layer.getView<TextView>(R.id.TextViewA)
                val spannableInfo =
                    SpannableString("我们非常重视您的隐私保护和个人信息保护，特别提示您阅读并充分理解“隐私协议”和“服务条款”。\n我们会严格按照法律法规存储和使用您的个人信息，未经您同意，我们不会提供给任何第三方进行使用。\n您可以阅读和《隐私协议》和《服务条款》全文了解详细信息。如您同意，请点击“同意并进入”开始接受我们的服务。")
                spannableInfo.setSpan(object : ClickableSpan() {
                    override fun onClick(widget: View) {
                        //如果已经前往下一个页面的话就不会触发点击事件
                        if (!banAnyLayerClick) {
                            //关闭弹窗
                            layer.dismiss()
                            val bundle = Bundle()
                            bundle.putBoolean("agreement", true)
                            animationNav(
                                R.id.action_startFragment_to_agreementFragment,
                                bundle
                            )
                            banAnyLayerClick = true
                        }
                    }

                    override fun updateDrawState(ds: TextPaint) {
                        //取消下划线
                        ds.isUnderlineText = false
                    }
                }, 100, 106, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE)
                spannableInfo.setSpan(
                    ForegroundColorSpan(
                        requireContext().getResColor(R.color.c_1C91E9)
                    ), 100, 106, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE
                )
                spannableInfo.setSpan(object : ClickableSpan() {
                    override fun onClick(widget: View) {
                        //如果已经前往下一个页面的话就不会触发点击事件
                        if (!banAnyLayerClick) {
                            //关闭弹窗
                            layer.dismiss()
                            animationNav(R.id.action_startFragment_to_agreementFragment)
                            banAnyLayerClick = true
                        }
                    }

                    override fun updateDrawState(ds: TextPaint) {
                        //取消下划线
                        ds.isUnderlineText = false
                    }
                }, 107, 113, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE)
                spannableInfo.setSpan(
                    ForegroundColorSpan(
                        requireContext().getResColor(R.color.c_1C91E9)
                    ), 107, 113, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE
                )
                textView?.movementMethod = LinkMovementMethod.getInstance()
                textView?.text = spannableInfo
            }
    }

    override fun fragmentConfigInit(): FragmentConfigData =
        FragmentConfigData(
            false,
            statusBarMode = StatusBarMode.STATUS_BAR_MODE_LIGHT,
            transparentNavigationBar = true
        )

}
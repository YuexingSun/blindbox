package com.zhixing.zxhy.ui.fragment

import android.annotation.SuppressLint
import android.graphics.Bitmap
import android.os.Bundle
import android.webkit.WebView
import androidx.navigation.fragment.findNavController
import com.hjq.toast.ToastUtils
import com.tuanliu.common.base.BaseDbFragment
import com.tuanliu.common.ext.gone
import com.tuanliu.common.ext.initBack
import com.tuanliu.common.ext.visible
import com.tuanliu.common.model.FragmentConfigData
import com.tuanliu.common.model.StatusBarMode
import com.zhixing.zxhy.databinding.FragmentAgreementBinding
import com.zhixing.zxhy.view_model.AgreementViewModel
import org.flower.l.library.view.webview.BrowserView

/**
 * 隐私协议页面
 */
class AgreementFragment : BaseDbFragment<AgreementViewModel, FragmentAgreementBinding>() {

    companion object {
        //服务条款
        const val service = "https://h5.sjtuanliu.com/#/pages/service/service"
        //隐私协议
        const val privacy = "https://h5.sjtuanliu.com/#/pages/Privacy/Privacy"
    }

    @SuppressLint("SetJavaScriptEnabled")
    override fun initView(savedInstanceState: Bundle?) {
        //true - 隐私协议  false - 服务条款
        val privacyBoolean = arguments?.getBoolean("agreement") ?: false

        mDataBind.WebViewA.apply {
            setLifecycleOwner(this@AgreementFragment)
            setBrowserViewClient(AppBrowserViewClient())
            setBrowserChromeClient(AppBrowserChromeClient(this))
            loadUrl(if (privacyBoolean) privacy else service)
        }
        mDataBind.TitleBarA.apply {
            titleBarText.text = if (privacyBoolean) "隐私协议" else "服务协议"
            titleBarBack.setOnClickListener {
                findNavController().navigateUp()
            }
        }
    }

    private inner class AppBrowserViewClient : BrowserView.BrowserViewClient() {

        /**
         * 网页加载错误时回调，这个方法会在 onPageFinished 之前调用
         */
        override fun onReceivedError(view: WebView, errorCode: Int, description: String, failingUrl: String) {
            ToastUtils.show("加载失败")
        }

        /**
         * 开始加载网页
         */
        override fun onPageStarted(view: WebView, url: String, favicon: Bitmap?) {
            mDataBind.TitleBarProgress.visible()
        }

        /**
         * 完成加载网页
         */
        override fun onPageFinished(view: WebView, url: String) {
            mDataBind.TitleBarProgress.gone()
        }
    }

    private inner class AppBrowserChromeClient constructor(view: BrowserView) : BrowserView.BrowserChromeClient(view) {

        /**
         * 收到加载进度变化
         */
        override fun onProgressChanged(view: WebView, newProgress: Int) {
            mDataBind.TitleBarProgress.progress = newProgress
        }
    }

    override fun fragmentConfigInit(): FragmentConfigData = FragmentConfigData(
        showToolbar = false,
        statusBarMode = StatusBarMode.STATUS_BAR_MODE_DARK
    )
}
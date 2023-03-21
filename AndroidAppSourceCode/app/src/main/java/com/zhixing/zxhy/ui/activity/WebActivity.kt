package com.zhixing.zxhy.ui.activity

import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.webkit.WebView
import com.hjq.toast.ToastUtils
import com.tuanliu.common.ext.gone
import com.tuanliu.common.ext.visible
import com.zhixing.zxhy.R
import com.zhixing.zxhy.databinding.ActivityWebBinding
import org.flower.l.library.base.BaseWebActivity
import org.flower.l.library.immerBar.ImmerData
import org.flower.l.library.immerBar.immersionBarInit
import org.flower.l.library.view.webview.BrowserView

/**
 * 内置的WebView
 */
class WebActivity : BaseWebActivity<ActivityWebBinding>() {

    private var webUri: String = ""

    override fun getLayoutId(): Int = R.layout.activity_web

    override fun initView() {
        webUri = this.intent.extras?.getString(WEB_URI_KEY) ?: return
        mDataBind.apply {
            WebViewA.apply {
                setLifecycleOwner(this@WebActivity)
                setBrowserViewClient(AppBrowserViewClient())
                setBrowserChromeClient(AppBrowserChromeClient(this))
                loadUrl(webUri)
            }
            TitleBarA.titleBarBack.setOnClickListener {
                finish()
            }
        }
    }

    override fun initData() {}

    private inner class AppBrowserViewClient : BrowserView.BrowserViewClient() {

        /**
         * 网页加载错误时回调，这个方法会在 onPageFinished 之前调用
         */
        override fun onReceivedError(view: WebView, errorCode: Int, description: String, failingUrl: String) {
            mDataBind.StatusLyA.showError()
        }

        /**
         * 开始加载网页
         */
        override fun onPageStarted(view: WebView, url: String, favicon: Bitmap?) {
            mDataBind.TitleBarProgress.visible()
            mDataBind.StatusLyA.apply {
                listener = {
                    mDataBind.WebViewA.loadUrl(webUri)
                }
                showLoading()
            }
        }

        /**
         * 完成加载网页
         */
        override fun onPageFinished(view: WebView, url: String) {
            mDataBind.TitleBarProgress.gone()
            mDataBind.WebViewA.visible()
            mDataBind.StatusLyA.showComplete()
        }
    }

    private inner class AppBrowserChromeClient constructor(view: BrowserView) : BrowserView.BrowserChromeClient(view) {

        /**
         * 设置标题
         */
        override fun onReceivedTitle(view: WebView?, title: String?) {
            if (title?.isBlank() == true) return

            mDataBind.TitleBarA.titleBarText.text = title
        }

        /**
         * 收到加载进度变化
         */
        override fun onProgressChanged(view: WebView, newProgress: Int) {
            mDataBind.TitleBarProgress.progress = newProgress
        }
    }

    override fun onResume() {
        super.onResume()
        this.immersionBarInit(ImmerData(tranNavigationBar = true, statusBarDark = true), mDataBind.TopView)
    }

    companion object {
        const val WEB_URI_KEY = "WEBVIEW_URI_KEY"

        fun start(context: Context, url: String) {
            if (url.isBlank()) {
                ToastUtils.show("错误: 链接为空...")
                return
            }
            val intent = Intent(context, WebActivity::class.java).apply {
                putExtra(WEB_URI_KEY, url)
            }
            context.startActivity(intent)
        }
    }

}
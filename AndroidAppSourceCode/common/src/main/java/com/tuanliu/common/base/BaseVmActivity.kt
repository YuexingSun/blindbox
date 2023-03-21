package com.tuanliu.common.base

import android.os.Bundle
import android.util.Log
import android.view.*
import android.widget.FrameLayout
import androidx.lifecycle.ViewModelProvider
import com.blankj.utilcode.util.KeyboardUtils
import com.gyf.immersionbar.ImmersionBar
import com.gyf.immersionbar.ktx.immersionBar
import com.tuanliu.common.R
import com.tuanliu.common.ext.*
import com.tuanliu.common.customView.CustomToolBar

abstract class BaseVmActivity<VM : BaseViewModel> : BaseActivity(), BaseIView {

    //当前Activity绑定的 ViewModel
    lateinit var mViewModel: VM

    //toolbar 这个可替换成自己想要的标题栏
    lateinit var mToolbar: CustomToolBar

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_base)
        //生成ViewModel
        mViewModel = createViewModel()
        //初始化 status View
        initStatusView(savedInstanceState)
    }

    private fun initStatusView(savedInstanceState: Bundle?) {
        mToolbar = findViewById(R.id.baseToolBar)
        mToolbar.run {
            setBackgroundColor(getColorExt(R.color.colorBackGround))
            //是否隐藏标题栏
            visibleOrGone(showToolBar())
        }
        initImmersionBar()
        findViewById<FrameLayout>(R.id.baseContentView).addView(
            if (dataBindView == null) LayoutInflater.from(
                this
            ).inflate(layoutId, null) else dataBindView
        )
        findViewById<FrameLayout>(R.id.baseContentView).post {
            initView(savedInstanceState)
        }
    }

    /**
     * 点击非编辑区域收起键盘
     * 获取点击事件
     */
    override fun dispatchTouchEvent(ev: MotionEvent?): Boolean {
        if (ev?.action == MotionEvent.ACTION_DOWN) {
            val view = currentFocus
            if (isShouldHideKeyBord(view, ev) && KeyboardUtils.isSoftInputVisible(currentActivity!!)) {
                view?.let { KeyboardUtils.hideSoftInput(it) }
            }
        }
        return super.dispatchTouchEvent(ev)
    }

    /**
     * 初始化view
     */
    abstract fun initView(savedInstanceState: Bundle?)

    /**
     * 创建viewModel
     */
    private fun createViewModel(): VM {
        return ViewModelProvider(this).get(getVmClazz(this))
    }

    /**
     * 是否显示 标题栏 默认隐藏
     */
    protected open fun showToolBar(): Boolean {
        return false
    }

    /**
     * 初始化沉浸式
     * Init immersion bar.
     * toolbar
     */
    protected open fun initImmersionBar() {
        //设置共同沉浸式样式
        if (showToolBar()) {
            mToolbar.setBackgroundColor(getColorExt(R.color.colorWhite))
            setSupportActionBar(mToolbar.getBaseToolBar())
            ImmersionBar.with(this).titleBar(mToolbar).init()
        }
    }

}
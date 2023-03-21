package com.tuanliu.common.base

import android.content.Context
import android.os.Bundle
import android.view.KeyEvent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.ViewModelProvider
import com.blankj.utilcode.util.AppUtils
import com.gyf.immersionbar.ImmersionBar
import com.gyf.immersionbar.ktx.immersionBar
import com.hjq.toast.ToastUtils
import com.tuanliu.common.R
import com.tuanliu.common.ext.*
import com.tuanliu.common.customView.CustomToolBar
import com.tuanliu.common.model.FragmentConfigData
import com.tuanliu.common.model.StatusBarMode
import timber.log.Timber
import java.util.*

abstract class BaseVmFragment<VM : BaseViewModel> : BaseFragment(), BaseIView {

    //是否第一次加载
    private var isFirst: Boolean = true

    //当前Fragment绑定的泛型类ViewModel
    lateinit var mViewModel: VM

    //父类activity
    lateinit var mActivity: AppCompatActivity

    //toolbar 这个可替换成自己想要的标题栏
    lateinit var mToolbar: CustomToolBar

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        isFirst = true
        Timber.d(javaClass.simpleName)
        val rootView = if (dataBindView == null) {
            inflater.inflate(layoutId, container, false)
        } else {
            dataBindView
        }

        initAnimation()

        // 设置toolbar
        return initToolbar(rootView, inflater, container, savedInstanceState)
    }

    override fun onAttach(context: Context) {
        super.onAttach(context)
        mActivity = context as AppCompatActivity
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        mViewModel = createViewModel()
        initStatusView(view, savedInstanceState)
        initLoadingUiChange()
    }

    /**
     * 初始化toolbar
     */
    private fun initToolbar(
        contentView: View?,
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val rootView = inflater.inflate(R.layout.fragment_base, container, false)

        if (fragmentConfigInit().showToolbar) {
            mToolbar = rootView.findViewById(R.id.baseToolBar)
            //显示标题栏
            mToolbar.visibleOrGone(fragmentConfigInit().showToolbar)
            initImmersionBar()
        }

        if (updateStatusBarColor()) {
            //设置状态栏颜色和导航栏颜色
            setBarColorMode(fragmentConfigInit())
        }

        rootView.findViewById<FrameLayout>(R.id.baseContentView).addView(contentView)
        return rootView
    }

    /**
     * 设置状态栏样式
     * @param mode 样式
     * [isExecute] 是否拦截
     */
    fun setBarColorMode(fragmentConfigData: FragmentConfigData) {
        fragmentConfigData.apply {
            immersionBar {
                //状态栏颜色
                when (transparentStatusBar) {
                    true -> {
                        transparentStatusBar()
                        statusBarDarkFont(statusBarMode == StatusBarMode.STATUS_BAR_MODE_DARK)
                    }
                    //false -> 浅色 -- true -> 深色
                    else -> statusBarDarkFont(statusBarMode == StatusBarMode.STATUS_BAR_MODE_DARK)
                }

                //导航栏颜色
                when (transparentNavigationBar) {
                    true -> transparentNavigationBar()
                    false -> {
                        navigationBarColor(navigationBarColor)
                        // 有导航栏的情况下，Activity是否全屏显示
                        fullScreen(false)
                    }
                }
            }
        }
    }

    /**
     * 初始化沉浸式
     * Init immersion bar.
     */
    protected open fun initImmersionBar() {
        //设置共同沉浸式样式
        if (updateStatusBarColor()) {
            mToolbar.setBackgroundColor(getColorExt(R.color.colorWhite))
            mActivity.setSupportActionBar(mToolbar.getBaseToolBar())
            ImmersionBar.with(this).titleBar(mToolbar).init()
        }
    }

    private fun initStatusView(view: View, savedInstanceState: Bundle?) {
        view.findViewById<FrameLayout>(R.id.baseContentView).post {
            initView(savedInstanceState)
            initLiveData()
            initNetRequest()
        }
    }

    /**
     * 创建viewModel
     */
    private fun createViewModel(): VM {
        return ViewModelProvider(this).get(getVmClazz(this))
    }

    /**
     * 初始化view操作
     */
    abstract fun initView(savedInstanceState: Bundle?)

    /**
     * 初始化fragment需要配置的东西
     */
    open fun fragmentConfigInit(): FragmentConfigData = FragmentConfigData()

    /**
     * 懒加载
     */
    open fun lazyLoadData() {}

    override fun onResume() {
        super.onResume()
        onVisible()
        //点击两次返回按钮关闭app
        if (onGetFocus()) getFocus()
    }

    /**
     * 是否需要懒加载
     */
    private fun onVisible() {
        if (lifecycle.currentState == Lifecycle.State.STARTED && isFirst) {
            isFirst = false
            //这里要等待一下 view加载完成后才能执行lazyLoadData方法，因为不等待的话 lazyLoadData懒加载方法会比initView先执行
            view.notNull({
                it.post {
                    lazyLoadData()
                }
            }, {
                lazyLoadData()
            })
        }
    }

    /**
     * 子类可传入需要被包裹的View，做状态显示-空、错误、加载
     * 如果子类不覆盖该方法 那么会将整个当前Fragment界面都当做View包裹
     */
    open fun getLoadingView(): View? = null

    /**
     * 注册 UI 事件
     */
    private fun initLoadingUiChange() {}

    /**
     * 可以初始化一些过场动画啥的
     */
    open fun initAnimation() {}

    /**
     * 页面一进来要执行的网络请求
     */
    open fun initNetRequest() {}

    /**
     * 是否更新状态栏/导航栏颜色
     */
    open fun updateStatusBarColor(): Boolean = true

    /**
     * 初始化LiveData
     */
    open fun initLiveData() {}

    /**
     * 是否获取页面的焦点，点击两次返回按钮关闭页面
     */
    open fun onGetFocus(): Boolean = false

    /**
     * 获取焦点
     */
    fun getFocus(eventS: (() -> Unit)? = null) {
        view?.isFocusableInTouchMode = true
        view?.requestFocus()
        view?.setOnKeyListener(object : View.OnKeyListener {
            override fun onKey(v: View?, keyCode: Int, event: KeyEvent?): Boolean {
                return if (event?.action == KeyEvent.ACTION_DOWN && keyCode == KeyEvent.KEYCODE_BACK) {
                    eventS?.let {
                        eventS()
                    } ?: run {
                        onBackPressed()
                    }
                    //返回true防止事件进一步传播
                    true
                } else {
                    //这里需要返回false，让activity可以处理其他事件 false
                    false
                }
            }
        })
    }

    private var lastTime: Long? = null

    /**
     * 再按一次退出
     */
    private fun onBackPressed() {
        val now = System.currentTimeMillis()
        lastTime?.let {
            if (now - it < 1500) {
                //关闭app
                AppUtils.exitApp()
                return
            }
        }
        lastTime = now
        ToastUtils.show("再按一次退出")
    }
}
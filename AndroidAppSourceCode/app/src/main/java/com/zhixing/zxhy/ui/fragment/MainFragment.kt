package com.zhixing.zxhy.ui.fragment

import android.os.Bundle
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentActivity
import androidx.lifecycle.lifecycleScope
import androidx.viewpager2.adapter.FragmentStateAdapter
import com.amap.api.location.AMapLocationClient
import com.amap.api.maps.MapsInitializer
import com.amap.api.navi.NaviSetting
import com.hjq.toast.ToastUtils
import com.zhixing.zxhy.R
import com.zhixing.zxhy.databinding.FragmentMainBinding
import com.zhixing.zxhy.view_model.MainViewModel
import com.tuanliu.common.base.BaseDbFragment
import com.tuanliu.common.base.BaseViewModel
import com.tuanliu.common.base.MainBottomData
import com.tuanliu.common.model.FragmentConfigData
import com.zhixing.zxhy.util.toPermission.ToLocation
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import android.content.Intent
import android.provider.Settings
import android.widget.Button
import android.widget.ProgressBar
import android.widget.TextView
import com.tuanliu.common.base.BoxBtnStatus
import com.tuanliu.common.ext.*
import com.tuanliu.common.util.BitmapUtil
import com.tuanliu.common.util.InStallApp
import com.zhixing.zxhy.util.bottomInAnimation
import com.zhixing.zxhy.util.bottomOutAnimation
import com.zhixing.zxhy.util.rotateInfinite
import com.zhixing.zxhy.util.toPermission.BlindBoxPermission
import com.zhixing.zxhy.util.toPermission.InStallPermission
import com.zhixing.zxhy.view_model.InitData
import per.goweii.anylayer.Layer

/**
 * 主Fragment
 */
class MainFragment : BaseDbFragment<MainViewModel, FragmentMainBinding>() {

    //升级弹窗内的按钮和进度条
    private var progressBar: ProgressBar? = null
    private var updateDialog: Layer? = null

    //将索引值和fragment做一个关系映射
    private val fragments = mapOf<Int, ReFragment>(
        MainBottomData.Box.index to { BlindBoxFragment() },
        MainBottomData.Home.index to { HomeFragment() },
        MainBottomData.Me.index to { MeFragment() }
    )

    private val blindBoxPermission: BlindBoxPermission by lazy {
        BlindBoxPermission(this@MainFragment)
    }

    //定位
    private val toLocation by lazy { ToLocation(this@MainFragment) }

    override fun initView(savedInstanceState: Bundle?) {
        mDataBind.apply {

            MainViewPager.apply {
                adapter = MainViewPagerAdapter(requireActivity(), fragments)
                //ViewPager2是否需要滑动
                isUserInputEnabled = false
                currentItem = mViewModel.currentSelected.value?.index ?: 0
                visible()
            }

            initBottomItem()

            Home.setOnClickListener {
                selectedBottomItem(MainBottomData.Home)
            }
            Box.setOnClickListener {
                selectedBottomItem(MainBottomData.Box)
            }
            Me.setOnClickListener {
                selectedBottomItem(MainBottomData.Me)
            }

            lifecycleScope.launch(Dispatchers.IO) {
                //隐私合规检查 - 高德
                MapsInitializer.updatePrivacyShow(requireContext(), true, true)
                MapsInitializer.updatePrivacyAgree(requireContext(), true)
                AMapLocationClient.updatePrivacyShow(requireContext(), true, true);
                AMapLocationClient.updatePrivacyAgree(requireContext(), true);
                NaviSetting.updatePrivacyShow(requireContext(), true, true)
                NaviSetting.updatePrivacyAgree(requireContext(), true)
            }
        }
    }

    override fun initLiveData() {
        mViewModel.apply {
            //修改状态栏颜色
            mViewModel.statusBarChange.observerKt { menu ->
                changeStatusBarTint(menu)
            }

            //跳转到某个菜单页面
            BaseViewModel.skipNavMenu.observerKt {
                it?.let { skipNavMenuViewPager(it) }
            }

            //底部中间盒子按钮的状态
            BaseViewModel.boxBtnStatus.observerKt {
                it?.let { status ->
                    mDataBind.Box.apply {
                        //禁止/开启 点击
                        isEnabled = status != BoxBtnStatus.RedBox
                        //如果不是盲盒页就不需要替换图标
                        if (getCurrentItem() == MainBottomData.Box.index) {
                            //图标
                            setImageResource(if (status == BoxBtnStatus.RedBox) R.mipmap.ic_main_box else R.mipmap.ic_main_refresh)
                        } else isEnabled = true

                        when (status) {
                            BoxBtnStatus.RedBox, BoxBtnStatus.RedRefresh, BoxBtnStatus.RedRefreshStop -> {
                                clearAnimation()
                            }
                            //红色旋转 - 请求
                            BoxBtnStatus.RedRefreshIng -> {
                                if (BaseViewModel.lat == null || BaseViewModel.lng == null) {
                                    ToastUtils.show("获取定位坐标中，请稍后重试。")
                                    return@observerKt
                                }
                                if (BaseViewModel.boxBtnStatus.value == BoxBtnStatus.RedRefresh) {
                                    ToastUtils.show("正在获取数据...")
                                    return@observerKt
                                }
                                //获取盲盒
                                BaseViewModel.openBoxGetOne.value =
                                    System.currentTimeMillis().toString()
                                rotateInfinite()
                            }
                        }
                    }
                }
            }

            //显示/隐藏导航栏
            BaseViewModel.isVisibleBottomNavi.observerKt {
                when {
                    //显示
                    it == true && mDataBind.ConstraintLayoutA.isGone() ->
                        mDataBind.ConstraintLayoutA.bottomInAnimation()
                    //隐藏
                    it == false && mDataBind.ConstraintLayoutA.isVisible() ->
                        mDataBind.ConstraintLayoutA.bottomOutAnimation()
                }
            }

            //客户端初始化数据
            initDataLiveData.observerKt {

                indexShow = it?.indexshow

                val initData = it?.versions?.android ?: return@observerKt
                val requestCode =
                    initData.newest?.replace(".", "")?.toIntOrNull() ?: return@observerKt

                val packageCode =
                    BitmapUtil.packageCode(requireContext()).replace(".", "").toIntOrNull()
                        ?: return@observerKt

                if (packageCode < requestCode && downLoadIsVisi != initData.newest.toString()) {
                    //弹窗 判断是否强制更新
                    updateAnyLayer(initData.force == 0, initData.newest)
                    downLoadIsVisi = initData.newest.toString()
                }
            }

            //下载apk的进度
            downApkProgress.observerKt { i ->
                if (progressBar != null && updateDialog != null && progressBar?.isShown == true) {
                    progressBar!!.progress = i ?: 0
                }
            }

            //下载完成，拿到uri
            apkUri.observerKt {
                it?.let { it1 -> InStallApp.install(requireActivity(), it1) }
            }
        }
    }

    override fun initNetRequest() {
        mViewModel.getInitData()
    }

    //初始化Bottom下方的图标
    private fun initBottomItem() {
        val index = mViewModel.currentSelected.value ?: MainBottomData.Home
        mDataBind.apply {
            when (index) {
                MainBottomData.Home -> {
                    Home.setImageResource(R.mipmap.ic_main_home)
                    Me.setImageResource(R.mipmap.ic_main_me_uns)
                    Box.setImageResource(R.mipmap.ic_main_box_uns)
                }
                MainBottomData.Box -> {
                    Home.setImageResource(R.mipmap.ic_main_home_uns)
                    Me.setImageResource(R.mipmap.ic_main_me_uns)
                    if (!toLocation.systemLocationServiceEnable(requireContext())) {
                        ToastUtils.show("未开启定位服务")
                        val intent = Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS)
                        startActivity(intent)
                    }

                    blindBoxPermission.checkPermission(
                        noPermission = {
                            BaseViewModel.setBoxBtnStatus(BoxBtnStatus.RedBox)
                            return@checkPermission
                        }
                    ) {
                        BaseViewModel.boxBtnStatus.value =
                            BaseViewModel.boxBtnStatus.value ?: BoxBtnStatus.RedBox
                    }
                }
                MainBottomData.Me -> {
                    Home.setImageResource(R.mipmap.ic_main_home_uns)
                    Box.setImageResource(R.mipmap.ic_main_box_uns)
                    Me.setImageResource(R.mipmap.ic_main_me)
                }
            }
        }
    }

    /**
     * 点击的Bottom
     */
    private fun selectedBottomItem(index: MainBottomData) {

        //是否开启定位功能
        if (index == MainBottomData.Box && !toLocation.systemLocationServiceEnable(requireContext())) {
            ToastUtils.show("未开启定位服务")
            val intent = Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS)
            startActivity(intent)
            return
        }

        //修改状态栏内容颜色
        mViewModel.statusBarChange.value = index.index
        mDataBind.apply {
            //viewpager2切换页面 切换动画
            MainViewPager.setCurrentItem(index.index, false)
            when (index) {
                MainBottomData.Home -> {
                    Home.setImageResource(R.mipmap.ic_main_home)
                    Me.setImageResource(R.mipmap.ic_main_me_uns)
                    Box.setImageResource(R.mipmap.ic_main_box_uns)
                    Box.isEnabled = true
                }
                MainBottomData.Box -> {
                    Home.setImageResource(R.mipmap.ic_main_home_uns)
                    Me.setImageResource(R.mipmap.ic_main_me_uns)
                    blindBoxPermission.checkPermission(
                        noPermission = {
                            BaseViewModel.setBoxBtnStatus(BoxBtnStatus.RedBox)
                            return@checkPermission
                        }
                    ) {
                        return@checkPermission
                    }
                    BaseViewModel.setBoxBtnStatus(
                        if (mViewModel.currentSelected.value == MainBottomData.Box) BoxBtnStatus.RedRefreshIng
                        else BaseViewModel.boxBtnStatus.value
                            ?: BoxBtnStatus.RedBox
                    )
                }
                MainBottomData.Me -> {
                    Home.setImageResource(R.mipmap.ic_main_home_uns)
                    Box.setImageResource(R.mipmap.ic_main_box_uns)
                    Box.isEnabled = true
                    Me.setImageResource(R.mipmap.ic_main_me)
                }
            }
        }
        //记录当前显示的页面
        mViewModel.currentSelected.value = index
    }

    /**
     * 获取当前的item 1-首页 0-盲盒页 2-我的页
     */
    private fun getCurrentItem(): Int = mDataBind.MainViewPager.currentItem

    /**
     * 跳转到Menu的某个页面
     */
    private fun skipNavMenuViewPager(mainBottomData: MainBottomData) {
        selectedBottomItem(mainBottomData)
    }

    //修改状态栏颜色和导航栏颜色(默认白色)
    private fun changeStatusBarTint(menu: Int?) {
        when (menu) {
            MainBottomData.Home.index -> {
                //解决底部导航栏消失状态下进入文章详情后返回首页，底部导航栏出现的问题
                BaseViewModel.isVisibleBottomNavi.value = BaseViewModel.isVisibleBottomNavi.value
                setBarColorMode(HomeFragmentStatusBar)
            }
            MainBottomData.Box.index -> setBarColorMode(BlindBoxFragmentStatusBar)
            MainBottomData.Me.index -> setBarColorMode(MyFragmentStatusBar)
        }
    }

    /**
     * 更新弹窗
     * [cancelable] 点击旁边是否可以关闭弹窗
     */
    private fun updateAnyLayer(cancelable: Boolean, versionStr: String) {
        updateDialog = anyLayer(
            R.layout.dialog_install_app,
            cancelable,
            R.color.c_F
        ).onClick({ layer, _ ->
            //获取安装app的权限
            InStallPermission(this@MainFragment).checkPermission {
                layer.getView<Button>(R.id.NowUpdate).gone()
                progressBar = layer.getView<ProgressBar>(R.id.ProgressBarA)
                progressBar.visible()
                //请求下载apk
                mViewModel.downLoadApk(requireContext())
            }
        }, R.id.NowUpdate)
            .onInitialize { layer ->
                layer.getView<TextView>(R.id.VersionStr)?.text = "V ${versionStr}"
            }
            //不拦截物理按键
            .interceptKeyEvent(false)
        updateDialog!!.show()
    }

    override fun onResume() {
        super.onResume()
        //如果布局位于栈顶,修改状态栏内容颜色  默认黑色
        if (mActivity.isFragmentTop(MainFragment::class.java)) {
            getFocus()
            val menu = mViewModel.statusBarChange.value ?: 0
            changeStatusBarTint(menu)
        }
    }

    //不更新状态栏/导航栏颜色
    override fun updateStatusBarColor(): Boolean = false

    override fun onGetFocus(): Boolean = true

    companion object {

        //初始化信息 - 是否显示ugc内容
        var indexShow: InitData.Indexshow? = null

        //首页
        val HomeFragmentStatusBar: FragmentConfigData = FragmentConfigData()

        //盲盒
        val BlindBoxFragmentStatusBar: FragmentConfigData = FragmentConfigData()

        //我的
        val MyFragmentStatusBar: FragmentConfigData = FragmentConfigData()
    }
}

class MainViewPagerAdapter(
    fragmentActivity: FragmentActivity,
    private val fragments: Map<Int, ReFragment>
) : FragmentStateAdapter(fragmentActivity) {

    //有多少个元素
    override fun getItemCount() = fragments.size

    override fun createFragment(position: Int) = fragments[position]?.invoke()
        ?: error("请确保fragment数据源和ViewPager2的index匹配")

}

//类型别名 传入的是一个代码块，每次都是一个新的Fragment
typealias ReFragment = () -> Fragment
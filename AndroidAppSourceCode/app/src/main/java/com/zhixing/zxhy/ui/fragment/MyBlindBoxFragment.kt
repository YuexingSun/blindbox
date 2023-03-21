package com.zhixing.zxhy.ui.fragment

import android.os.Bundle
import android.util.Log
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.navigation.fragment.findNavController
import androidx.viewpager2.adapter.FragmentStateAdapter
import com.google.android.material.tabs.TabLayoutMediator
import com.hjq.toast.ToastUtils
import com.tuanliu.common.base.BaseDbFragment
import com.tuanliu.common.ext.initBack
import com.tuanliu.common.ext.visible
import com.tuanliu.common.model.FragmentConfigData
import com.tuanliu.common.model.StatusBarMode
import com.zhixing.zxhy.databinding.FragmentMyBlindBoxBinding
import com.zhixing.zxhy.view_model.MyBlindBoxViewModel

/**
 * 我的盲盒页面 / 历史行程页面
 */
class MyBlindBoxFragment :
    BaseDbFragment<MyBlindBoxViewModel, FragmentMyBlindBoxBinding>() {

    private val blindBoxOneFragment by lazy { BlindBoxOneFragment() }
    private val blindBoxTwoFragment by lazy { BlindBoxTwoFragment() }
    private val blindBoxThreeFragment by lazy { BlindBoxThreeFragment() }
    private val blindBoxFourFragment by lazy { BlindBoxFourFragment() }
    private val tabFragmentList = arrayListOf<Fragment>()
    private val tabTitleList = arrayOf("全部", "已完成", "已失效", "待评价")

    init {
        tabFragmentList.run {
            add(blindBoxOneFragment)
            add(blindBoxTwoFragment)
            add(blindBoxThreeFragment)
            add(blindBoxFourFragment)
        }
    }

    override fun initView(savedInstanceState: Bundle?) {
        mDataBind.apply {
            vm = mViewModel

            //返回
            Back.setOnClickListener {
                findNavController().navigateUp()
            }

            ViewPagerA.apply {
                //预加载 这里不开启，不然会走完生命周期
//                offscreenPageLimit = 1
                adapter = object : FragmentStateAdapter(this@MyBlindBoxFragment) {
                    override fun getItemCount(): Int = tabFragmentList.size

                    override fun createFragment(position: Int): Fragment = tabFragmentList[position]
                }
                visible()
            }

            //tabLayout 和viewPager绑定
            TabLayoutMediator(TabLayoutA, ViewPagerA) { tab, position ->
                tab.text = tabTitleList[position]
            }.attach()

        }
    }

    override fun initNetRequest() {
        mViewModel.getMyBoxData()
    }

    override fun onDestroy() {
        super.onDestroy()
        tabFragmentList.clear()
    }

    override fun fragmentConfigInit(): FragmentConfigData =
        FragmentConfigData(
            false,
            transparentStatusBar = false,
            statusBarMode = StatusBarMode.STATUS_BAR_MODE_DARK,
            transparentNavigationBar = false
        )

}
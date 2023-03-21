package com.zhixing.zxhy.ui.fragment

import android.os.Bundle
import android.view.animation.AnimationUtils
import androidx.core.view.isGone
import androidx.navigation.fragment.findNavController
import androidx.recyclerview.widget.LinearLayoutManager
import com.tuanliu.common.base.BaseDbFragment
import com.tuanliu.common.base.BaseRvAdapter
import com.tuanliu.common.base.BaseViewModel
import com.tuanliu.common.base.MainBottomData
import com.tuanliu.common.ext.*
import com.tuanliu.common.model.FragmentConfigData
import com.tuanliu.common.model.StatusBarMode
import com.zhixing.zxhy.R
import com.zhixing.zxhy.databinding.FragmentMyBlindBoxIndexBinding
import com.zhixing.zxhy.databinding.ViewMyBlindBoxBinding
import com.zhixing.zxhy.view_model.MyBlindBoxListData
import com.zhixing.zxhy.view_model.MyBlindBoxListStatus
import com.zhixing.zxhy.view_model.MyBlindBoxViewModel

/**
 * 已完成页面
 */
class BlindBoxTwoFragment :
    BaseDbFragment<MyBlindBoxViewModel, FragmentMyBlindBoxIndexBinding>() {

    override fun initView(savedInstanceState: Bundle?) {
        mDataBind.apply {

            RecyclerViewA.apply {
                layoutManager = object : LinearLayoutManager(requireContext(), VERTICAL, false) {}
                adapter = myBoxListAdapter
                visible()
            }

            SmartRefreshLayoutA.apply {
                //下拉刷新
                refresh {
                    mViewModel.getMyBoxListData(this, MyBlindBoxListStatus.Two)
                }
                //上拉加载
                loadMore {
                    mViewModel.getMyBoxListData(this, MyBlindBoxListStatus.Two, isRefresh = false)
                }
            }
        }
    }

    override fun initNetRequest() {
        getBlindListData()
    }

    override fun initLiveData() {
        mViewModel.apply {

            //获取我的盲盒列表
            getMyBoxListLiveData.observerKt { data ->
                myBoxListAdapter.loadListSuccess(data!!, mDataBind.SmartRefreshLayoutA)
            }

        }
    }

    /**
     * 获取盒子列表数据
     */
    private fun getBlindListData() {
        if (mViewModel.getMyBoxListLiveData.value == null) {
            mDataBind.SmartRefreshLayoutA.autoRefresh()
        }
    }

    //我的盲盒列表的adapter
    private val myBoxListAdapter =
        object : BaseRvAdapter<MyBlindBoxListData, ViewMyBlindBoxBinding>() {
            override fun onBindItem(
                holder: BaseViewHolder,
                binding: ViewMyBlindBoxBinding,
                item: MyBlindBoxListData,
                position: Int
            ) {
                binding.apply {
                    data = item

                    CardViewA.animation = AnimationUtils.loadAnimation(holder.itemView.context, R.anim.centre_scale_in)

                    when (item.status) {
                        //进行中的盲盒 回到盲盒页面
                        0, 1 -> {
                            TimeImage.setImageResource(R.mipmap.ic_blind_time_blue)
                            LocationImage.setImageResource(R.mipmap.ic_blind_location_blue)
                            CardViewA.setOnClickListener {
                                findNavController().navigateUp()
                                BaseViewModel.skipNavMenu.value = MainBottomData.Box
                            }
                        }
                        //已完成的盲盒跳转到详情 2-已完成未评价
                        2 -> {
                            TimeImage.setImageResource(R.mipmap.ic_blind_time_yellow)
                            LocationImage.setImageResource(R.mipmap.ic_blind_location_yellow)
                            StatusImg.setImageResource(R.mipmap.ic_blind_status_wpj)
                            CardViewA.setOnClickListener {
                                val bundle = Bundle()
                                bundle.putInt("boxid", item.boxid)
                                animationNav(
                                    R.id.action_myBlindBoxFragment_to_boxDetailFragment,
                                    bundle
                                )
                            }
                        }
                        //已完成
                        3 -> {
                            TimeImage.setImageResource(R.mipmap.ic_blind_time_green)
                            LocationImage.setImageResource(R.mipmap.ic_blind_location_green)
                            StatusImg.setImageResource(R.mipmap.ic_blind_status_ywc)
                            CardViewA.setOnClickListener {
                                val bundle = Bundle()
                                bundle.putInt("boxid", item.boxid)
                                animationNav(
                                    R.id.action_myBlindBoxFragment_to_boxDetailFragment,
                                    bundle
                                )
                            }
                        }
                        //已失效
                        4, 5 -> {
                            TimeImage.setImageResource(R.mipmap.ic_blind_time_red)
                            LocationImage.setImageResource(R.mipmap.ic_blind_location_red)
                            StatusImg.setImageResource(R.mipmap.ic_blind_status_ysx)
                        }
                    }
                }
            }

            override fun getLayoutResId(viewType: Int): Int = R.layout.view_my_blind_box
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
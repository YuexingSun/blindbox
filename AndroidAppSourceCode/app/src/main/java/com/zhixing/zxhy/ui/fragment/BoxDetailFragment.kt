package com.zhixing.zxhy.ui.fragment

import android.os.Bundle
import android.view.Gravity
import androidx.navigation.fragment.findNavController
import com.tuanliu.common.base.BaseDbFragment
import com.tuanliu.common.ext.*
import com.tuanliu.common.model.FragmentConfigData
import com.tuanliu.common.model.StatusBarMode
import com.zhixing.zxhy.R
import com.zhixing.zxhy.databinding.FragmentBoxDetailBinding
import com.zhixing.zxhy.view_model.BoxDetailViewModel
import com.zhixing.zxhy.util.SkipOtherApp
import per.goweii.anylayer.widget.SwipeLayout

/**
 * 盲盒详情页面
 */
class BoxDetailFragment :
    BaseDbFragment<BoxDetailViewModel, FragmentBoxDetailBinding>() {

    override fun initView(savedInstanceState: Bundle?) {

        mDataBind.apply {
            mViewModel.boxid = arguments?.getInt("boxid") ?: 0

            vm = mViewModel

            //其他导航
            OtherNavi.setOnClickListener {
                if (!otherNavigation.isShown) otherNavigation.show()
            }

            //返回
            Back.setOnClickListener {
                findNavController().navigateUp()
            }
        }
    }

    override fun initNetRequest() {
        mViewModel.getBoxDetail(mViewModel.boxid)
    }

    override fun initLiveData() {
        mViewModel.apply {

            //盲盒详情
            boxDetailLiveData.observerKt { data ->
                mDataBind.Icon.glideDefault(requireContext(), data?.logo, showPlaceHolder = false)
                statusShowBtn(data?.islike ?: 0)
            }

            //进行评价 - 是否满意
            isLike.observerKt {
                selectedLike(it ?: 0)
            }

            //提交评价完成返回上一页
            enjoyBoxLiveData.observerKt {
                findNavController().navigateUp()
            }

        }
    }

    /**
     * 评价 - 选择是否满意
     */
    private fun selectedLike(status: Int) {
        when (status) {
            //满意
            1 -> {
                mDataBind.apply {
                    ManYi.setBackgroundResource(R.mipmap.ic_box_manyi_selected)
                    NoManYi.setBackgroundResource(R.mipmap.ic_box_nomanyi_unselected)
                }
            }
            //不满意
            2 -> {
                mDataBind.apply {
                    ManYi.setBackgroundResource(R.mipmap.ic_box_manyi_unselected)
                    NoManYi.setBackgroundResource(R.mipmap.ic_box_nomanyi_selected)
                }
            }
        }
    }

    /**
     * 各个状态需要显示对应的btn
     */
    private fun statusShowBtn(status: Int) {
        mDataBind.apply {
            when (status) {
                //未选
                0 -> {
                    ManYi.setBackgroundResource(R.mipmap.ic_box_manyi_unselected)
                    NoManYi.setBackgroundResource(R.mipmap.ic_box_nomanyi_unselected)
                }
                //满意
                1 -> {
                    ManYi.setBackgroundResource(R.mipmap.ic_box_manyi_selected)
                }
                //不满意
                2 -> {
                    NoManYi.setBackgroundResource(R.mipmap.ic_box_nomanyi_selected)

                    noManYiSelectedBtn()
                }
            }
        }
    }

    /**
     * 不满意情况下选择框内按钮的显示
     */
    private fun noManYiSelectedBtn() {

        val mycommentlist = mViewModel.boxDetailLiveData.value?.mycommentlist

        mDataBind.IncludeA.apply {
            TextOne.gone()
            TextTwo.gone()
            TextThree.gone()
            TextFour.gone()
            TextFive.gone()
            TextSix.gone()

            mycommentlist?.forEachIndexed { index, s ->
                when (index) {
                    0 -> {
                        TextOne.apply {
                            visible()
                            text = s
                            isEnabled = false
                        }
                    }
                    1 -> {
                        TextTwo.apply {
                            visible()
                            text = s
                            isEnabled = false
                        }
                    }
                    2 -> {
                        TextThree.apply {
                            visible()
                            text = s
                            isEnabled = false
                        }
                    }
                    3 -> {
                        TextFour.apply {
                            visible()
                            text = s
                            isEnabled = false
                        }
                    }
                    4 -> {
                        TextFive.apply {
                            visible()
                            text = s
                            isEnabled = false
                        }
                    }
                    5 -> {
                        TextSix.apply {
                            visible()
                            text = s
                            isEnabled = false
                        }
                    }
                }
            }
        }
    }

    //其他导航弹框
    private val otherNavigation by lazy {
        anyLayerBottom(R.layout.dialog_other_navigation, true, R.color.c_F5)
            .onClickToDismiss({ _, _ -> }, R.id.Cancel)
            //百度
            .onClickToDismiss({ _, _ ->
                SkipOtherApp.goBaiDu(
                    requireActivity(),
                    mViewModel.boxDetailLiveData.value?.realname ?: "",
                    mViewModel.boxDetailLiveData.value?.lnglat?.lat.toString(),
                    mViewModel.boxDetailLiveData.value?.lnglat?.lng.toString()
                )
            }, R.id.BaiDu)
            //高德
            .onClickToDismiss({ _, _ ->
                SkipOtherApp.goGeoDe(
                    requireActivity(),
                    mViewModel.boxDetailLiveData.value?.realname ?: "",
                    mViewModel.boxDetailLiveData.value?.lnglat?.lat.toString(),
                    mViewModel.boxDetailLiveData.value?.lnglat?.lng.toString()
                )
            }, R.id.GaoDe)
    }

    override fun fragmentConfigInit(): FragmentConfigData =
        FragmentConfigData(
            false,
            transparentStatusBar = false,
            statusBarMode = StatusBarMode.STATUS_BAR_MODE_DARK,
            transparentNavigationBar = false,
            navigationBarColor = R.color.c_F5
        )

}
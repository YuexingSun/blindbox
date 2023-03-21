package com.zhixing.zxhy.ui.fragment

import android.os.Bundle
import androidx.navigation.fragment.findNavController
import com.google.android.material.chip.Chip
import com.hjq.toast.ToastUtils
import com.noober.background.drawable.DrawableCreator
import com.tuanliu.common.base.BaseDbFragment
import com.tuanliu.common.ext.dp2Pix
import com.tuanliu.common.ext.getResColor
import com.tuanliu.common.model.FragmentConfigData
import com.tuanliu.common.model.StatusBarMode
import com.zhixing.zxhy.R
import com.zhixing.zxhy.databinding.FragmentHobbyBinding
import com.zhixing.zxhy.view_model.HobbyViewModel
import com.zhixing.zxhy.view_model.UserTagListData

/**
 * 兴趣爱好页面
 */
class HobbyFragment :
    BaseDbFragment<HobbyViewModel, FragmentHobbyBinding>() {

    //BL控件动态设置属性的drawable
    private val drawable by lazy { DrawableCreator.Builder() }

    override fun initView(savedInstanceState: Bundle?) {
        mDataBind.vm = mViewModel
    }

    override fun initLiveData() {
        mViewModel.apply {

            //用户标签信息
            userTagLiveData.observerKt { data ->
                if (data?.data != null && data.data.isNotEmpty()) {
                    initChipGroup(data)
                }
            }

            //设置用户标签信息
            setUserTagLiveData.observerKt {
                ToastUtils.show("设置成功")
                findNavController().navigateUp()
            }

            //选中标签数量
            tagMapLength.observerKt { i ->
                when (i) {
                    //允许点击提交
                    5 -> {
                        mDataBind.ButtonA.background =
                            drawable.setCornersRadius(dp2Pix(requireContext(),20f).toFloat())
                                //渐变
                                .setGradientColor(
                                    requireContext().getResColor(R.color.c_FF599F),
                                    requireContext().getResColor(R.color.c_FF4545)
                                )
                                .setGradientAngle(0)
                                .build()
                        mDataBind.ButtonA.isEnabled = true
                    }
                    //禁止点击提交
                    4 -> {
                        mDataBind.ButtonA.background =
                            drawable.setCornersRadius(dp2Pix(requireContext(),20f).toFloat())
                                .setGradientColor(
                                    requireContext().getResColor(R.color.c_E1),
                                    requireContext().getResColor(R.color.c_E1)
                                )
                                .build()
                        mDataBind.ButtonA.isEnabled = false
                    }
                }
            }

        }
    }

    override fun initNetRequest() {
//        mViewModel.getUserTagList()
    }

    /**
     * 初始化Chip
     */
    private fun initChipGroup(userTagListData: UserTagListData) {
        mDataBind.apply {
            LabelChip.removeAllViews()
            for (userTag in userTagListData.data!!) {
                val chip = layoutInflater.inflate(R.layout.chip_label, LabelChip, false) as Chip
                chip.text = userTag.name ?: ""
                chip.setOnCheckedChangeListener { _, b ->
                    when (b) {
                        //选中
                        true -> {
                            mViewModel.apply {
                                tagMap[userTag.id] = 0
                                tagMapLength.value = tagMapLength.value ?: 0 + 1
                            }
                        }
                        //取消选中
                        false -> {
                            mViewModel.apply {
                                tagMap.remove(userTag.id)
                                tagMapLength.value = tagMapLength.value ?: 1 - 1
                            }
                        }
                    }
                }
                LabelChip.addView(chip)
            }
        }
    }

    override fun fragmentConfigInit(): FragmentConfigData =
        FragmentConfigData(
            false,
            transparentStatusBar = true,
            statusBarMode = StatusBarMode.STATUS_BAR_MODE_DARK,
            transparentNavigationBar = false
        )

}
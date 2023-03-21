package com.zhixing.zxhy.ui.fragment

import android.annotation.SuppressLint
import com.zhixing.zxhy.R
import android.os.Bundle
import androidx.navigation.fragment.findNavController
import androidx.recyclerview.widget.LinearLayoutManager
import com.google.android.material.chip.Chip
import com.google.android.material.slider.Slider
import com.tuanliu.common.base.BaseDbFragment
import com.tuanliu.common.base.BaseRvAdapter
import com.tuanliu.common.model.FragmentConfigData
import com.tuanliu.common.model.StatusBarMode
import com.zhixing.zxhy.databinding.FragmentPerfectDataTwoBinding
import com.zhixing.zxhy.databinding.ViewPerfectdataTwoBinding
import com.zhixing.zxhy.service.QuestionAnswerArray
import com.zhixing.zxhy.view_model.PerfectDataTwoViewModel
import com.zhixing.zxhy.view_model.QuestionData
import kotlin.collections.ArrayList

/**
 * 完善资料第二个页面
 */
class PerfectDataTwoFragment :
    BaseDbFragment<PerfectDataTwoViewModel, FragmentPerfectDataTwoBinding>() {

    override fun initView(savedInstanceState: Bundle?) {
        mDataBind.apply {
            RecyclerViewA.apply {
                //纵向布局
                layoutManager =
                    object : LinearLayoutManager(requireContext(), VERTICAL, false) {}
                adapter = perfectAdapter
            }

            //完成
            ButtonA.setOnClickListener {
                if (perfectAdapter.getSaveQuestionList().size == 0) return@setOnClickListener

                val array = perfectAdapter.getSaveQuestionList().toTypedArray()
                mViewModel.submitBaseDataTwoData(array)
            }
        }
    }

    override fun initLiveData() {
        mViewModel.apply {

            //表单问题列表
            questionListData.observerKt { data ->
                data?.let {
                    mDataBind.questionList = data.queslist?.size ?: 0
                    perfectAdapter.setData(data.queslist)
                }
            }

            //提交表单
            submitBaseData.observerKt {
                findNavController().navigate(R.id.action_perfectDataTwoFragment_to_mainFragment)
            }

        }
    }

    override fun initNetRequest() {
        //获取新用户表单问题
        mViewModel.getNewUserFromData()
    }

    /**
     * 表单RecyclerView的adapter
     */
    private val perfectAdapter =
        object : BaseRvAdapter<QuestionData.Queslist, ViewPerfectdataTwoBinding>() {

            //问题选择列表
            val questionList: ArrayList<QuestionAnswerArray.QuestionAnswerItem> = arrayListOf()

            /**
             * 获取用户选择的列表
             */
            fun getSaveQuestionList(): ArrayList<QuestionAnswerArray.QuestionAnswerItem> =
                questionList

            override fun onBindItem(
                holder: BaseViewHolder,
                binding: ViewPerfectdataTwoBinding,
                item: QuestionData.Queslist,
                position: Int
            ) {
                //清除数据
                if (position == 0) questionList.clear()

                //初始化数据
                questionList.add(
                    QuestionAnswerArray.QuestionAnswerItem(
                        quesid = item.id,
                        ans = item.itemlist?.get(0)?.itemid.toString()
                    )
                )

                binding.apply {
                    questListData = item
                    when (item.type) {
                        //单选框
                        2 -> {
                            item.itemlist?.forEach { itemlist ->
                                val chip = layoutInflater.inflate(
                                    R.layout.item_prefect_chip,
                                    ChipGroupA,
                                    false
                                ) as Chip
                                chip.apply {
                                    text = itemlist?.itemname ?: ""
                                    if (itemlist?.itemid ?: 0 == item.answer) isChecked = true
                                }
                                ChipGroupA.addView(chip)
                            }
                            ChipGroupA.setOnCheckedChangeListener { group, itemId ->
                                val selected = item.itemlist?.filter {
                                    it?.itemname ?: "" == group.findViewById<Chip>(itemId).text.toString()
                                }?.component1() ?: return@setOnCheckedChangeListener

                                questionList[position].ans = selected.itemid.toString()
                            }
                        }
                        //拖动条
                        else -> {
                            SliderA.valueTo = ((item.itemlist?.size ?: 1) - 1).toFloat()
                            ItemName.text = item.itemlist?.getOrNull(0)?.itemname ?: ""
                            SliderA.addOnSliderTouchListener(object : Slider.OnSliderTouchListener {
                                @SuppressLint("RestrictedApi")
                                override fun onStartTrackingTouch(slider: Slider) {
                                }

                                //选择器改变的话就改变arrayList的数据
                                @SuppressLint("RestrictedApi")
                                override fun onStopTrackingTouch(slider: Slider) {
                                    questionList[position].ans =
                                        item.itemlist?.get(slider.value.toInt())?.itemid.toString()
                                    ItemName.text =
                                        item.itemlist?.get(slider.value.toInt())?.itemname ?: ""
                                }
                            })
                        }
                    }
                }

            }

            override fun getLayoutResId(viewType: Int): Int = R.layout.view_perfectdata_two
        }

    override fun fragmentConfigInit(): FragmentConfigData =
        FragmentConfigData(
            false,
            transparentStatusBar = true,
            statusBarMode = StatusBarMode.STATUS_BAR_MODE_DARK,
            transparentNavigationBar = false
        )

}
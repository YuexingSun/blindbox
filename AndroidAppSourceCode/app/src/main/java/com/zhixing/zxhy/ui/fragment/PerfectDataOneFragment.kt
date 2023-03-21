package com.zhixing.zxhy.ui.fragment

import android.os.Bundle
import android.text.Editable
import android.text.TextWatcher
import android.view.Gravity
import com.loper7.date_time_picker.DateTimeConfig
import com.loper7.date_time_picker.DateTimePicker
import com.noober.background.drawable.DrawableCreator
import com.tuanliu.common.base.BaseDbFragment
import com.tuanliu.common.ext.*
import com.tuanliu.common.model.FragmentConfigData
import com.tuanliu.common.model.StatusBarMode
import com.zhixing.zxhy.R
import com.zhixing.zxhy.databinding.FragmentPerfectDataOneBinding
import com.zhixing.zxhy.view_model.PerfectDataOneViewModel
import per.goweii.anylayer.widget.SwipeLayout

/**
 * 完善资料第一个页面
 */
class PerfectDataOneFragment :
    BaseDbFragment<PerfectDataOneViewModel, FragmentPerfectDataOneBinding>() {

    //BL控件动态设置属性的drawable
    private val drawable by lazy { DrawableCreator.Builder() }

    override fun initView(savedInstanceState: Bundle?) {

        mDataBind.apply {
            vm = mViewModel

            //用户名输入框
            UserName.apply {
                addTextChangedListener(userNameWatch)
                mViewModel.showKeyboard(this)
            }

            //点击获取焦点并拉起输入框
            ConstraintLayoutB.setOnClickListener {
                mViewModel.showKeyboard(UserName)
            }

            //选择生日
            ConstraintLayoutC.setOnClickListener {
                if (!selectedDate.isShown) selectedDate.show()
            }
        }
    }

    override fun initLiveData() {
        mViewModel.apply {
            gender.observerKt {
                nextButtonColor()
            }
            userName.observerKt {
                nextButtonColor()
            }
            userDate.observerKt {
                nextButtonColor()
            }

            skipNextFragment.observerKt {
                //跳转到资料完善的第二个页面
                animationNav(R.id.action_perfectDataOneFragment_to_perfectDataTwoFragment)
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

    /**
     * 改变下一步按钮的颜色且是否可点击
     */
    private fun nextButtonColor() {
        mViewModel.apply {
            mDataBind.Next.apply {
                when {
                    gender.value != 0 && userName.value != "" && userName.value.toString().length <= 16 && userDate.value != "" -> {
                        background =
                            drawable.setCornersRadius(dp2Pix(requireContext(),20f).toFloat())
                                //渐变
                                .setGradientColor(
                                    requireContext().getResColor(R.color.c_FF599F),
                                    requireContext().getResColor(R.color.c_FF4545)
                                )
                                .setGradientAngle(0)
                                .build()
                        //可以点击
                        isEnabled = true
                        setTextColor(requireContext().getResColor(R.color.c_F))
                    }
                    userName.value.toString().length == 17 || userName.value == "" -> {
                        background =
                            drawable.setCornersRadius(dp2Pix(requireContext(),20f).toFloat())
                                .setGradientColor(
                                    requireContext().getResColor(R.color.c_CF),
                                    requireContext().getResColor(R.color.c_CF)
                                )
                                .build()
                        //无法点击
                        isEnabled = false
                        setTextColor(requireContext().getResColor(R.color.c_B))
                    }
                }
            }
        }
    }

    //用户名输入监听
    private val userNameWatch by lazy {
        object : TextWatcher {
            override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {}

            override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {}

            //变化后
            override fun afterTextChanged(p0: Editable?) {
                mViewModel.userName.value = p0.toString()
            }
        }
    }

    //选择时间
    private val selectedDate by lazy {
        anyLayer(true).contentView(R.layout.dialog_date_picker_one)
            .gravity(Gravity.BOTTOM)
            .swipeDismiss(SwipeLayout.Direction.BOTTOM)
            .onClickToDismiss({ _, _ -> }, R.id.Cancel)
            //确定按钮事件
            .onClick({ layer, view ->
                val userDatePicker = layer.getView<DateTimePicker>(R.id.UserDatePicker)
                //获取当前选中的时间戳
                val long = userDatePicker?.getMillisecond() ?: 0L

                val year = long.transToString("yyyy")
                val month = long.transToString("MM")

                mViewModel.userDate.value = "$year.$month"

                layer.dismiss()

            }, R.id.Confirm)
            //初始化
            .onInitialize { layer ->
                //拿到当前的年份
                val thisYear = System.currentTimeMillis().transToString("yyyy").toInt() - 10

                val userDatePicker = layer.getView<DateTimePicker>(R.id.UserDatePicker)
                userDatePicker?.apply {
                    setGlobal(DateTimeConfig.GLOBAL_CHINA)
                    setDisplayType(intArrayOf(DateTimeConfig.YEAR, DateTimeConfig.MONTH))
                    //年份不循环滚动
                    setWrapSelectorWheel(mutableListOf(DateTimeConfig.YEAR), false)
                    setMinMillisecond("1950-1".transToTimeStamp("yyyy-MM"))
                    //最大选择日期
                    setMaxMillisecond("$thisYear-12".transToTimeStamp("yyyy-MM"))
                }

            }
    }

}
package com.zhixing.zxhy.ui.fragment

import android.os.Bundle
import android.view.Gravity
import android.widget.TextView
import androidx.navigation.fragment.findNavController
import com.hjq.toast.ToastUtils
import com.loper7.date_time_picker.DateTimeConfig
import com.loper7.date_time_picker.DateTimePicker
import com.tuanliu.common.base.BaseDbFragment
import com.tuanliu.common.base.BaseViewModel
import com.tuanliu.common.ext.*
import com.tuanliu.common.model.FragmentConfigData
import com.tuanliu.common.model.StatusBarMode
import com.zhixing.zxhy.R
import com.zhixing.zxhy.databinding.FragmentMyInformationBinding
import com.zhixing.zxhy.util.AliYunImage
import com.zhixing.zxhy.util.selectedPic.ChangeHeader
import com.tuanliu.common.util.ImmersionBarUtil.changeNaviColor
import com.zhixing.zxhy.view_model.MyInformationViewModel
import per.goweii.anylayer.Layer
import per.goweii.anylayer.widget.SwipeLayout

/**
 * 编辑个人资料页面
 */
class MyInformationFragment :
    BaseDbFragment<MyInformationViewModel, FragmentMyInformationBinding>() {

    override fun initView(savedInstanceState: Bundle?) {
        mDataBind.apply {
            vm = mViewModel
            //返回
            Back.setOnClickListener {
                findNavController().navigateUp()
            }
            //更改头像
            ChangeHead.setOnClickListener {
                ChangeHeader(this@MyInformationFragment) {
                    mViewModel.uploadFile(it)
                }
            }
            //保存
            Save.setOnClickListener {
                mViewModel.changeHeader()
            }
            //修改昵称
            Name.afterTextChange {
                if (!mDataBind.Save.isEnabled && it != mViewModel.userProfileLiveData.value?.nickname.toString()) mDataBind.Save.isEnabled =
                    true
            }
            //修改年龄
            AgeCon.setOnClickListener {
                if (!selectedDate.isShown) selectedDate.show()
            }
            //修改性别
            GenderCon.setOnClickListener {
                selectedGender()
            }
        }
    }

    override fun initLiveData() {
        mViewModel.apply {

            //用户资料信息
            userProfileLiveData.observerKt { data ->
                mDataBind.AvatarImage.glideDefault(requireContext(), AliYunImage.mfit(data?.headimg.toString(), 200)) {}
            }

            //修改头像
            uploadFileLiveData.observerKt {
                changeSaveEnable()
                mDataBind.AvatarImage.glideDefault(requireContext(), AliYunImage.mfit(it.toString(), 200)) {}
            }

            //保存成功
            changeDataLiveData.observerKt {
                //通知我的页面刷新
                BaseViewModel.updateUserMessage.value = System.currentTimeMillis().toString()
                ToastUtils.show("修改个人信息成功")
                findNavController().navigateUp()
            }

        }
    }

    override fun initNetRequest() {
        mViewModel.getUserProfile()
    }

    /**
     * 改变保存按钮的状态
     */
    private fun changeSaveEnable() {
        if (!mDataBind.Save.isEnabled) mDataBind.Save.isEnabled = true
    }

    //选择年龄
    private val selectedDate by lazy {
        anyLayer(cancelable = true).contentView(R.layout.dialog_date_picker_one)
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

                mViewModel.age.value = "$year-$month"
                changeSaveEnable()

                layer.dismiss()

            }, R.id.Confirm)
            //初始化
            .onInitialize { layer ->
                //拿到当前的年份
                val thisYear = (System.currentTimeMillis().transToString("yyyy").toInt() - 10).toString()

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

    /**
     * 修改性别
     */
    private fun selectedGender() {
        val list = listOf("女", "男")
        baseCommonAnyLayer(list, oneBlock = {
            if (mViewModel.gender.value != "女") {
                changeSaveEnable()
                mViewModel.gender.value = "女"
            }
        }, twoBlock = {
            if (mViewModel.gender.value != "男") {
                changeSaveEnable()
                mViewModel.gender.value = "男"
            }
        }) {}
    }

    /**
     * 公共弹窗
     */
    private fun baseCommonAnyLayer(
        dataList: List<String>,
        oneBlock: () -> Unit,
        twoBlock: () -> Unit,
        cancelBlock: (() -> Unit)? = null
    ) {
        anyLayer(true).contentView(R.layout.dialog_amap_close)
            .gravity(Gravity.BOTTOM)
            .swipeDismiss(SwipeLayout.Direction.BOTTOM)
            .onInitialize { layer ->
                if (dataList.size < 2) return@onInitialize
                layer.getView<TextView>(R.id.One)?.text = dataList[0]
                layer.getView<TextView>(R.id.Two)?.text = dataList[1]
                changeNaviColor(R.color.c_80000000)
            }
            .onClickToDismiss({ _, _ ->
                cancelBlock?.invoke()
            }, R.id.Cancel)
            .onClickToDismiss({ _, _ ->
                oneBlock()
            }, R.id.One)
            .onClickToDismiss({ _, _ ->
                twoBlock()
            }, R.id.Two)
            .onDismissListener(object : Layer.OnDismissListener {
                override fun onDismissing(layer: Layer) {}

                override fun onDismissed(layer: Layer) {
                    changeNaviColor(R.color.c_EF)
                }
            })
            .show()
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
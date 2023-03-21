package com.zhixing.zxhy.ui.fragment

import android.graphics.Rect
import android.os.Bundle
import android.view.View
import androidx.core.view.isGone
import androidx.core.view.isVisible
import androidx.lifecycle.lifecycleScope
import androidx.navigation.fragment.findNavController
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.blankj.utilcode.util.KeyboardUtils
import com.hjq.toast.ToastUtils
import com.tuanliu.common.base.BaseDbFragment
import com.tuanliu.common.base.BaseRvAdapter
import com.tuanliu.common.base.BaseViewModel
import com.tuanliu.common.ext.*
import com.tuanliu.common.model.FragmentConfigData
import com.tuanliu.common.model.StatusBarMode
import com.zhixing.zxhy.R
import com.zhixing.zxhy.databinding.FragmentSendArticleBinding
import com.zhixing.zxhy.databinding.ViewSendArticleImageBinding
import com.zhixing.zxhy.util.AliYunImage
import com.zhixing.zxhy.util.recoverAnimation
import com.zhixing.zxhy.util.scaleAnimation
import com.zhixing.zxhy.util.selectedPic.WriteArticlePic
import com.zhixing.zxhy.util.toPermission.SendArticlePermission
import com.zhixing.zxhy.view_model.SendArticleViewModel
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

/**
 * 发布文章页面
 */
class SendArticleFragment :
    BaseDbFragment<SendArticleViewModel, FragmentSendArticleBinding>() {

    val writeArticlePic by lazy { WriteArticlePic(this@SendArticleFragment) }

    //定位
    private val sendArticlePermission by lazy { SendArticlePermission(this) }

    override fun initView(savedInstanceState: Bundle?) {
        mDataBind.apply {
            mViewModel.id = arguments?.getInt("id") ?: 0
            mViewModel.titleStr.value = arguments?.getString("TITLE_STR") ?: "写笔记"
            mViewModel.sendStr.value = arguments?.getString("SEND_STR") ?: "发布"

            vm = mViewModel
            //返回
            Back.setOnClickListener {
                findNavController().navigateUp()
            }
            //发布
            Send.setOnClickListener {
                val title = Title.text.toString()
                mViewModel.inforCreateInfo(title, Content.text.toString(), ArrayList(picListAdapter.getItems()))
            }
            //图片控件
            PicRecyc.apply {
                addItemDecoration(object : RecyclerView.ItemDecoration() {
                    override fun getItemOffsets(
                        outRect: Rect,
                        view: View,
                        parent: RecyclerView,
                        state: RecyclerView.State
                    ) {
                        val position = parent.getChildAdapterPosition(view)
                        outRect.left = when (position) {
                            0 -> dp2Pix(parent.context, 16f)
                            else -> dp2Pix(parent.context, 12f)
                        }
                    }
                })
                layoutManager = object : LinearLayoutManager(requireContext(), HORIZONTAL, false) {}
                adapter = picListAdapter
                visible()
            }
            //跳转到搜索地址页面
            LocationConst.setOnClickListener {
                sendArticlePermission.checkPermission {
                    animationNav(R.id.action_sendArticleFragment_to_seekLocationFragment)
                }
            }
            //显示软键盘
            KeyboardUtils.showSoftInput(mDataBind.Title)
        }
    }

    override fun initLiveData() {
        mViewModel.apply {

            //搜索页面回来的数据
            findNavController().currentBackStackEntry?.savedStateHandle?.getLiveData<Array<String>>(
                "LOCATION"
            )?.observerKt {
                val address = it?.get(0).toString()
                mDataBind.ImgA.isSelected = address.isNotBlank()
                addressLD.value = address
                lng = it?.get(1).toString().toDouble()
                lat = it?.get(2).toString().toDouble()
                detailAddress = it?.get(3).toString()
                point = it?.get(4).toString().toDouble()
            }

            //文章详情
            detailsLiveData.observerKt {
                if (it == null) return@observerKt

                picListAdapter.setData(it.bannerlist)
                mDataBind.Title.setText(it.title)
                mDataBind.Content.setText(it.content)
                if (it.location.lng != 0.0) {
                    lat = it.location.lat
                    lng = it.location.lng
                    addressLD.value = it.location.address
                    mDataBind.ImgA.isSelected = true
                }
            }

            //上传图片成功
            uploadMultFileLD.observerKt {
                picListAdapter.addDataAll(it?.data?.urllist)
                //滑动到指定位置
                lifecycleScope.launch {
                    delay(500)
                    mDataBind.PicRecyc.smoothScrollToPosition(picListAdapter.getItems().size)
                }
            }

            //发布文章
            inforCreateInfoLD.observerKt {
                if (id == 0) {
                    mDataBind.SendSuccess.visible()
                } else ToastUtils.show("修改成功")
                lifecycleScope.launch {
                    val system = System.currentTimeMillis().toString()
                    delay(500)
                    findNavController().navigateUp()
                    //刷新首页列表
                    BaseViewModel.updateHomeListLayout.postValue(system)
                    //更新用户信息
                    BaseViewModel.updateUserMessage.postValue(system)
                }
            }
        }
    }

    override fun initNetRequest() {
        mViewModel.apply {
            if (id != 0 && detailsLiveData.value == null) {
                inforGetDetailData()
            }
        }
    }

    //照片的adapter
    private val picListAdapter =
        object : BaseRvAdapter<String, ViewSendArticleImageBinding>(true) {

            override fun onBindItem(
                holder: BaseViewHolder,
                binding: ViewSendArticleImageBinding,
                item: String,
                position: Int
            ) {
                binding.apply {
                    ImageA.glideDefault(holder.itemView.context, AliYunImage.mfit(item, 200), false)
                    //删除图片
                    Close.setOnClickListener {
                        removeItem(position)
                    }
                    //删除按钮是否出现
                    ImageA.setOnClickListener {
                        if (Close.isVisible) {
                            ImageA.recoverAnimation()
                            Close.gone()
                        }
                        else if (Close.isGone) {
                            ImageA.scaleAnimation()
                            Close.visible()
                        }
                    }
                }
            }

            override fun onBindItemAddOneView(
                binding: ViewSendArticleImageBinding?,
                item: String?,
                position: Int
            ) {
                binding?.apply {
                    ImageA.setImageResource(R.mipmap.ic_write_addpic)
                    ImageA.setOnClickListener {
                        writeArticlePic.checkPermission(9 - getItems().size) {
                            mViewModel.upLoadMultFile(it)
                        }
                    }
                }
                super.onBindItemAddOneView(binding, item, position)
            }

            override fun getLayoutResId(viewType: Int): Int = R.layout.view_send_article_image
        }

    override fun onDestroy() {
        super.onDestroy()
        mViewModel.clearData()
    }

    override fun fragmentConfigInit(): FragmentConfigData =
        FragmentConfigData(
            false,
            transparentStatusBar = true,
            statusBarMode = StatusBarMode.STATUS_BAR_MODE_DARK,
            transparentNavigationBar = false,
            navigationBarColor = R.color.c_EF
        )

}
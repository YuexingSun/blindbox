package com.zhixing.zxhy.ui.fragment

import android.graphics.Rect
import com.zhixing.zxhy.InforMyFavData
import com.zhixing.zxhy.R
import android.os.Bundle
import android.util.Log
import android.view.View
import android.view.animation.AnimationUtils
import androidx.lifecycle.lifecycleScope
import androidx.navigation.fragment.findNavController
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.blankj.utilcode.util.NetworkUtils
import com.hjq.toast.ToastUtils
import com.tuanliu.common.base.BaseDbFragment
import com.tuanliu.common.base.BaseRvAdapter
import com.tuanliu.common.base.BaseViewModel
import com.tuanliu.common.ext.*
import com.tuanliu.common.model.FragmentConfigData
import com.tuanliu.common.model.StatusBarMode
import com.zhixing.zxhy.databinding.FragmentMyCollectBinding
import com.zhixing.zxhy.databinding.ViewCollectBinding
import com.zhixing.zxhy.view_model.MyCollectViewModel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

/**
 * 我的收藏页面
 */
class MyCollectFragment :
    BaseDbFragment<MyCollectViewModel, FragmentMyCollectBinding>() {

    override fun initView(savedInstanceState: Bundle?) {
        mDataBind.apply {

            RecycA.apply {
                addItemDecoration(object : RecyclerView.ItemDecoration() {
                    override fun getItemOffsets(
                        outRect: Rect,
                        view: View,
                        parent: RecyclerView,
                        state: RecyclerView.State
                    ) {
                        outRect.bottom = dp2Pix(requireContext(), 12f)
                    }
                })
                layoutManager = object : LinearLayoutManager(requireContext(), VERTICAL, false) {}
                adapter = inforMyFavListAdapter
                visible()
            }

            SmartRefreshLayoutA.apply {
                refresh {
                    mViewModel.getInforMyFavListData(this)
                }
                loadMore {
                    mViewModel.getInforMyFavListData(this, false)
                }
            }

            //返回
            Back.setOnClickListener {
                findNavController().navigateUp()
            }
        }
    }

    override fun initLiveData() {
        mViewModel.apply {

            //更新我的收藏列表
            BaseViewModel.updateMyCollectList.observerKt {
                lifecycleScope.launch(Dispatchers.Main) {
                    mDataBind.SmartRefreshLayoutA.autoRefresh()
                }
            }

            //我收藏的文章
            inforMyFavListLiveData.observerKt { data ->
                inforMyFavListAdapter.loadListSuccess(data!!, mDataBind.SmartRefreshLayoutA)
            }

        }
    }

    override fun initNetRequest() {
        if (mViewModel.inforMyFavListLiveData.value == null) {
            mDataBind.SmartRefreshLayoutA.autoRefresh()
        }
    }

    //我收藏的文章列表的adapter
    private val inforMyFavListAdapter =
        object : BaseRvAdapter<InforMyFavData, ViewCollectBinding>() {

            override fun onBindItem(
                holder: BaseViewHolder,
                binding: ViewCollectBinding,
                item: InforMyFavData,
                position: Int
            ) {
                binding.apply {
                    data = item

                    DeleteView.animation = AnimationUtils.loadAnimation(
                        holder.itemView.context,
                        R.anim.centre_scale_in
                    )

                    ShowImg.glideDefault(holder.itemView.context, item.banner, false)
                    HeadImg.glideDefault(holder.itemView.context, item.avatar, false)

                    //取消收藏
                    Delete.setOnClickListener {
                        lifecycleScope.launch(Dispatchers.IO) {
                            //查询当前网络是否可用
                            if (NetworkUtils.isAvailable()) {
                                //取消文章收藏
                                mViewModel.inforFavActicle(item.id)
                                this.launch(Dispatchers.Main) {
                                    ToastUtils.show("取消收藏成功")
                                    removeItem(position)
                                }
                            } else ToastUtils.show("当前网络不可用。")
                        }
                    }

                    //查看文章详情
                    ConstA.setOnClickListener {
                        val bundle = Bundle().apply {
                            putInt("id", item.id)
                            putInt("ENTRANCE", ArticleDetailsFragment.Entrance.MY_COLLECT.i)
                        }
                        animationNav(
                            R.id.action_myCollectFragment_to_articleDetailsFragment,
                            bundle
                        )
                    }
                }
            }

            override fun getLayoutResId(viewType: Int): Int = R.layout.view_collect
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
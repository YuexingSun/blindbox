package com.zhixing.zxhy.ui.fragment

import ExpandStaggeredManager
import android.graphics.Rect
import com.zhixing.zxhy.R
import android.os.Bundle
import android.view.View
import android.view.animation.AnimationUtils
import androidx.core.view.isGone
import androidx.core.view.isVisible
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.RecyclerView
import com.google.android.material.appbar.AppBarLayout
import com.tuanliu.common.base.BaseDbFragment
import com.tuanliu.common.base.BaseRvAdapter
import com.tuanliu.common.base.BaseViewModel
import com.tuanliu.common.ext.*
import com.zhixing.zxhy.MyInfoData
import com.zhixing.zxhy.databinding.FragmentMeBinding
import com.zhixing.zxhy.databinding.ViewMyIssueBinding
import com.zhixing.zxhy.util.AliYunImage
import com.zhixing.zxhy.util.alpha0
import com.zhixing.zxhy.util.alpha1
import com.zhixing.zxhy.view_model.MeViewModel
import com.zhixing.zxhy.widget.chartCircleView.ChartCircleItem
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

/**
 * 我的页面
 */
class MeFragment : BaseDbFragment<MeViewModel, FragmentMeBinding>() {

    //近7天开的盒子的数据
    private val items: ArrayList<ChartCircleItem> = arrayListOf()

    //appBar是否显示
    private var appBarIsVisi = false

    override fun initView(savedInstanceState: Bundle?) {
        mDataBind.apply {
            vm = mViewModel

            //我发表的文章列表
            RecycA.apply {
                addItemDecoration(object : RecyclerView.ItemDecoration() {
                    override fun getItemOffsets(
                        outRect: Rect,
                        view: View,
                        parent: RecyclerView,
                        state: RecyclerView.State
                    ) {
                        super.getItemOffsets(outRect, view, parent, state)
                        val position = parent.getChildAdapterPosition(view)
                        if (position == 0 || position == 1) return
                        outRect.top = dp2Pix(requireContext(), 16f)
                    }
                })
                //瀑布流布局
                layoutManager = object : ExpandStaggeredManager(2, VERTICAL) {
                    //禁止滑动
                    override fun canScrollHorizontally(): Boolean = false

                    //防止item交换位置
                    override fun setGapStrategy(gapStrategy: Int) {
                        super.setGapStrategy(GAP_HANDLING_NONE)
                    }
                }
                adapter = myArticleListAdapter
            }

            //设置
            TBSetting.setOnClickListener {
                animationNav(R.id.action_mainFragment_to_settingFragment)
            }
            Setting.setOnClickListener {
                animationNav(R.id.action_mainFragment_to_settingFragment)
            }

            //我的收藏
            Favorites.setOnClickListener {
                animationNav(R.id.action_mainFragment_to_myCollectFragment)
            }

            //历史盲盒
            History.setOnClickListener {
                animationNav(R.id.action_mainFragment_to_myBlindBoxFragment)
            }

            //下拉刷新
            SmartRefreshLayoutA.apply {
                refresh {
                    mViewModel.getMyDataList()
                    when(MainFragment.indexShow?.type ?: 2) {
                        1 -> {
                            mViewModel.inforSearchList(this)
                            if (NoteSTr.isGone) NoteSTr.visible()
                        }
                        2 -> if (NoteSTr.isVisible) NoteSTr.gone()
                        else -> {}
                    }
                }
                loadMore {
                    mViewModel.inforSearchList(this, false)
                }
            }

            AppBarA.addOnOffsetChangedListener(AppBarLayout.OnOffsetChangedListener { appBarLayout, verticalOffset ->
                //判断appBarLayout被滑动的距离是否超过appbarLayout总高度的5%
                when {
                    //显示
                    -verticalOffset >= (appBarLayout.totalScrollRange * 0.05).toInt() && (!appBarIsVisi || ToolbarA.isGone) -> {
                        appBarIsVisi = true
                        ToolbarA.alpha1(500)
                    }
                    //隐藏
                    -verticalOffset < (appBarLayout.totalScrollRange * 0.05).toInt() && appBarIsVisi -> {
                        appBarIsVisi = false
                        ToolbarA.alpha0(500)
                    }
                }
            })
        }
    }

    override fun initNetRequest() {
        if (mViewModel.myDataLiveData.value == null) {
            getMyData()
        }
    }

    override fun initLiveData() {
        mViewModel.apply {

            //网络状态改变
            BaseViewModel.netWorkStatusChange.observeInFragment(this@MeFragment) {
                initNetRequest()
            }

            //更新用户信息
            BaseViewModel.updateUserMessage.observerKt {
                getMyData()
            }

            //获取我的信息
            myDataLiveData.observerKt { data ->
                mDataBind.SmartRefreshLayoutA.finishRefresh()
                //更新头像
                requireContext().glideDefault(
                    AliYunImage.mfit(
                        data?.memberinfo?.avatar.toString(),
                        200
                    ), R.mipmap.ic_default_head
                ) {
                    mDataBind.Avatar.setImageBitmap(it)
                    mDataBind.TBAvatar.setImageBitmap(it)
                }

                //近7天开的盒子
                items.clear()
                data?.last7days?.catelist?.forEach { list ->
                    when (list.cateid) {
                        1 -> {
                            items.add(ChartCircleItem(list.number, R.color.c_FFC368))
                            mDataBind.LineAa.text = list.catename
                            mDataBind.EatStr.text = list.number.toString()
                        }
                        2 -> {
                            items.add(ChartCircleItem(list.number, R.color.c_8584FD))
                            mDataBind.LineBa.text = list.catename
                            mDataBind.PlayStr.text = list.number.toString()
                        }
                        3 -> {
                            items.add(ChartCircleItem(list.number, R.color.c_F299F2))
                            mDataBind.LineCa.text = list.catename
                            mDataBind.SmallEatStr.text = list.number.toString()
                        }
                    }
                }
                mDataBind.ArcViewA.setItems(items)
            }

            //我发布的笔记
            myInfoListLD.observerKt {
                //没有数据
                if (it?.list?.size ?: 0 == 0 && mDataBind.IssueInclude.ConstA.isGone) {
                    mDataBind.IssueInclude.ConstA.visible()
                    mDataBind.RecycA.gone()
                    mDataBind.SmartRefreshLayoutA.finishRefresh()
                }
                myArticleListAdapter.loadListSuccess(it!!, mDataBind.SmartRefreshLayoutA)
                //有数据
                if (it.list.isNotEmpty() && mDataBind.RecycA.isGone) {
                    mDataBind.IssueInclude.ConstA.gone()
                    mDataBind.RecycA.visible()
                }
                //这里需要刷新一下最后两项，不然有可能列表会不正确
                if (it.isRefresh()) {
                    lifecycleScope.launch {
                        delay(200)
                        myArticleListAdapter.refreshEndTwo()
                    }
                }
            }

        }
    }

    /**
     * 获取我的信息数据
     */
    private fun getMyData() {
        mDataBind.SmartRefreshLayoutA.autoRefresh()
    }

    //我发表的文章列表适配器
    private val myArticleListAdapter =
        object :
            BaseRvAdapter<MyInfoData, ViewMyIssueBinding>() {

            override fun onBindItem(
                holder: BaseViewHolder,
                binding: ViewMyIssueBinding,
                item: MyInfoData,
                position: Int
            ) {
                binding.apply {
                    ConstA.animation = AnimationUtils.loadAnimation(
                        holder.itemView.context,
                        R.anim.centre_scale_in
                    )
                    ShowImg.glideDefault(
                        holder.itemView.context,
                        AliYunImage.mfitW(item.banner, 504),
                        false
                    )
                    Title.text = item.title
                    //跳转到文章详情
                    ConstA.setOnClickListener {
                        val bundle = Bundle().apply {
                            putInt("id", item.id)
                            putInt("ENTRANCE", ArticleDetailsFragment.Entrance.HAVE_ARTICLE.i)
                        }
                        animationNav(R.id.action_mainFragment_to_articleDetailsFragment, bundle)
                    }
                }
            }

            override fun getLayoutResId(viewType: Int): Int = R.layout.view_my_issue
        }

    override fun updateStatusBarColor(): Boolean = false

}
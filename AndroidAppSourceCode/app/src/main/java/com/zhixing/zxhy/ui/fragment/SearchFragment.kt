package com.zhixing.zxhy.ui.fragment

import android.graphics.Rect
import android.os.Bundle
import android.text.Editable
import android.text.TextWatcher
import android.view.KeyEvent
import android.view.View
import android.view.animation.AnimationUtils
import android.view.inputmethod.EditorInfo
import androidx.core.view.isGone
import androidx.lifecycle.lifecycleScope
import androidx.navigation.fragment.findNavController
import androidx.recyclerview.widget.RecyclerView
import androidx.recyclerview.widget.StaggeredGridLayoutManager
import androidx.transition.TransitionInflater
import com.blankj.utilcode.util.KeyboardUtils
import com.tuanliu.common.base.BaseDbFragment
import com.tuanliu.common.base.BaseRvAdapter
import com.tuanliu.common.ext.*
import com.tuanliu.common.model.FragmentConfigData
import com.tuanliu.common.model.StatusBarMode
import com.zhixing.zxhy.InforSearchData
import com.zhixing.zxhy.R
import com.zhixing.zxhy.databinding.FragmentSearchBinding
import com.zhixing.zxhy.databinding.ViewMyIssueBinding
import com.zhixing.zxhy.util.AliYunImage
import com.zhixing.zxhy.view_model.SearchViewModel
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

/**
 * 搜索页面
 */
class SearchFragment : BaseDbFragment<SearchViewModel, FragmentSearchBinding>() {

    override fun initAnimation() {
        sharedElementEnterTransition =
            TransitionInflater.from(requireContext()).inflateTransition(R.transition.slide)
        sharedElementReturnTransition =
            TransitionInflater.from(requireContext()).inflateTransition(R.transition.slide)
    }

    override fun initView(savedInstanceState: Bundle?) {
        mDataBind.apply {
            mViewModel.searchContent.value = ""
            //取消
            Cancel.setOnClickListener {
                findNavController().navigateUp()
            }
            //搜素列表
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
                        if (position == 0 && position == 1) return
                        outRect.top = dp2Pix(requireContext(), 16f)
                    }
                })
                //瀑布流布局
                layoutManager = object : StaggeredGridLayoutManager(2, VERTICAL) {
                    //禁止滑动
                    override fun canScrollHorizontally(): Boolean = false

                    //防止item交换位置
                    override fun setGapStrategy(gapStrategy: Int) {
                        super.setGapStrategy(GAP_HANDLING_NONE)
                    }
                }
                adapter = searchListAdapter
                visible()
            }
            //刷新头
            SmartA.apply {
                refresh {
                    mViewModel.inforSearchList(this)
                }
                loadMore {
                    mViewModel.inforSearchList(this, false)
                }
            }

            //搜索栏
            Search.apply {
                addTextChangedListener(object : TextWatcher {
                    override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {}
                    override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {}

                    override fun afterTextChanged(p0: Editable?) {
                        if (p0.toString() != "") {
                            mViewModel.searchContent.value = p0.toString()
                        }
                    }
                })
                inputType = EditorInfo.TYPE_CLASS_TEXT
                imeOptions = EditorInfo.IME_ACTION_SEARCH
                setOnKeyListener { p0, p1, p2 ->
                    if (p1 == KeyEvent.KEYCODE_ENTER) {
                        KeyboardUtils.hideSoftInput(requireView())
                        //搜索
                        SmartA.autoRefresh()
                    }
                    //这里不拦截其他事件，以防无法传递，例如删除
                    false
                }
                if (mViewModel.inforSearchListLD.value == null) {
                    //显示软键盘
                    KeyboardUtils.showSoftInput(this)
                }
            }
        }
    }

    override fun initLiveData() {
        mViewModel.apply {
            //获取搜索列表
            inforSearchListLD.observerKt {
                //没有数据
                if (it?.list?.size ?: 0 == 0 && mDataBind.Empty.isGone) {
                    mDataBind.SmartA.gone()
                    mDataBind.Empty.visible()
                    mDataBind.SmartA.finishRefresh()
                }
                searchListAdapter.loadListSuccess(it!!, mDataBind.SmartA)
                //有数据
                if (it.list.isNotEmpty() && mDataBind.SmartA.isGone) {
                    mDataBind.SmartA.visible()
                    mDataBind.Empty.gone()
                }
                if (it.isRefresh()) {
                    lifecycleScope.launch {
                        delay(200)
                        searchListAdapter.refreshEndTwo()
                    }
                }
            }
        }
    }

    //搜索列表适配器
    private val searchListAdapter =
        object :
            BaseRvAdapter<InforSearchData, ViewMyIssueBinding>() {

            override fun onBindItem(
                holder: BaseViewHolder,
                binding: ViewMyIssueBinding,
                item: InforSearchData,
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
                        }
                        animationNav(R.id.action_searchFragment_to_articleDetailsFragment, bundle)
                    }
                }
            }

            override fun getLayoutResId(viewType: Int): Int = R.layout.view_my_issue
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
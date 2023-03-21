package com.zhixing.zxhy.ui.fragment

import android.annotation.SuppressLint
import android.graphics.Bitmap
import android.graphics.Color
import android.graphics.Rect
import android.os.Build
import android.os.Bundle
import android.text.Html
import android.view.View
import android.webkit.WebView
import android.widget.ImageView
import androidx.core.view.isGone
import androidx.lifecycle.lifecycleScope
import androidx.navigation.fragment.FragmentNavigatorExtras
import androidx.navigation.fragment.findNavController
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.google.android.material.transition.Hold
import com.hjq.toast.ToastUtils
import com.tuanliu.common.base.*
import com.tuanliu.common.ext.*
import com.zhixing.zxhy.*
import com.zhixing.zxhy.databinding.FragmentHomeBinding
import com.zhixing.zxhy.databinding.ViewHomeListBinding
import com.zhixing.zxhy.databinding.ViewHomeListHeaderBinding
import com.zhixing.zxhy.ui.activity.WebActivity
import com.zhixing.zxhy.util.*
import com.zhixing.zxhy.util.databinding.Common
import com.zhixing.zxhy.util.toPermission.HomeGoBoxPermission
import com.zhixing.zxhy.view_model.HomeViewModel
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import org.flower.l.library.view.webview.BrowserView

/**
 * 首页页面
 */
class HomeFragment : BaseDbFragment<HomeViewModel, FragmentHomeBinding>() {

    //滑动状态 -1初始 0下滑 1上滑
    private var scrollStatus: Int = -1

    //刷新点赞的数据类
    private var changeLikeData: ChangeLikeData = ChangeLikeData()

    //首页广告跳转到盲盒页面需要的权限
    private val homeGoBoxPermission: HomeGoBoxPermission by lazy {
        HomeGoBoxPermission(this@HomeFragment)
    }

    override fun initAnimation() {
        exitTransition = Hold()
    }

    @SuppressLint("SetJavaScriptEnabled")
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
                        val position = parent.getChildAdapterPosition(view)

                        if (position == 0) {
                            outRect.top = dp2Pix(requireContext(), 16f)
                            outRect.bottom = dp2Pix(requireContext(), 18f)
                            return
                        }

                        outRect.bottom = dp2Pix(requireContext(), 32f)
                    }
                })
                addOnScrollListener(object : RecyclerView.OnScrollListener() {
                    override fun onScrolled(recyclerView: RecyclerView, dx: Int, dy: Int) {
                        super.onScrolled(recyclerView, dx, dy)
                        when {
                            //页面上滑 显示
                            dy < 0 && scrollStatus != 0 -> {
                                scrollStatus = 0
                                BaseViewModel.isVisibleBottomNavi.value = true
                                //稍微等一下再显示，导航栏有延迟
                                lifecycleScope.launch {
                                    delay(300)
                                    mDataBind.SendArticle.makeInAnimation(false, 250L)
                                }
                            }
                            //页面下滑 隐藏
                            dy > 0 && scrollStatus != 1 -> {
                                scrollStatus = 1
                                BaseViewModel.isVisibleBottomNavi.value = false
                                mDataBind.SendArticle.makeOutAnimation(true, 250L)
                            }
                        }
                    }
                })
                layoutManager = object : LinearLayoutManager(requireContext(), VERTICAL, false) {}
                adapter = informationListAdapter
                visible()
            }

            WebViewA.apply {
                setLifecycleOwner(this@HomeFragment)
                setBrowserViewClient(AppBrowserViewClient())
                setBrowserChromeClient(AppBrowserChromeClient(this))
            }

            //搜索 - 跳转到搜索页面
            SearchConst.setOnClickListener {
                val extras = FragmentNavigatorExtras(
                    mDataBind.SearchConst to "search_const",
                    mDataBind.SearchImg to "search_img",
                    mDataBind.SearchText to "search_text"
                )
                findNavController().navigate(
                    R.id.action_mainFragment_to_searchFragment,
                    null,
                    null,
                    extras
                )
            }

            SmartRefreshLayoutA.apply {
                refresh {
                    mViewModel.getInformationBannerList()
                    mViewModel.getInformationListData(this)
                }
                loadMore {
                    mViewModel.getInformationListData(this, false)
                }
            }

            //跳转到发布文章页面
            SendArticle.setOnClickListener {
                animationNav(R.id.action_mainFragment_to_sendArticleFragment)
            }
        }
    }

    override fun initNetRequest() {
        mViewModel.apply {
            when (MainFragment.indexShow?.type ?: 2) {
                //显示ugc内容
                1 -> {
                    mDataBind.UGCLayout.visible()
                    mDataBind.WebViewA.gone()
                }
                //显示webview
                2 -> {
                    mDataBind.UGCLayout.gone()
                    mDataBind.WebViewA.visible()
                    mDataBind.WebViewA.loadUrl(MainFragment.indexShow?.url ?: "")
                }
                else -> {
                }
            }
            //页面初始化需要请求的内容
            homeInit()
        }
        if (mViewModel.informationListLiveData.value == null) {
            mDataBind.SmartRefreshLayoutA.autoRefresh()
        }
    }

    override fun initLiveData() {
        mViewModel.apply {

            //网络状态改变
            BaseViewModel.netWorkStatusChange.observeInFragment(this@HomeFragment) {
                initNetRequest()
            }

            //刷新首页列表
            BaseViewModel.updateHomeListLayout.observerKt {
                mDataBind.SmartRefreshLayoutA.autoRefresh()
            }

            //文章详情页面带回来的数据
            findNavController().currentBackStackEntry?.savedStateHandle?.getLiveData<Array<ChangeLikeData>>(
                "LIKE"
            )?.observerKt {
                if (it == null) return@observerKt
                changeLikeData = it[0]
                informationListAdapter.setReplace(changeLikeData.refreshPosi)
            }

            //获取首页信息流列表
            informationListLiveData.observerKt { data ->
                informationListAdapter.loadListSuccess(data!!, mDataBind.SmartRefreshLayoutA)
            }

            //首页信息流弹出广告(大霸屏)数据
            inforPopupPicLD.observerKt {
                it?.let {
                    if (it.showpic == 1) {
                        advertisingAnyLayer(it.targettype, it.pic, it.param)
                    }
                }
            }

            //首页信息流弹出广告(顶部广告)数据
            inforBannerListLd.observerKt {
                it?.let {
                    informationListAdapter.setHeadData(it)
                }
            }

        }
    }

    /**
     * 跳转到文章详情页面
     */
    private fun skipArticleDetails(mId: Int, mPosition: Int = -1) {
        val bundle = Bundle().apply {
            putInt("id", mId)
            putInt("POSITION", mPosition)
        }
        animationNav(
            R.id.action_mainFragment_to_articleDetailsFragment,
            bundle
        )
    }

    /**
     * 广告弹窗
     */
    private fun advertisingAnyLayer(
        targetType: String,
        pic: String,
        //如果类型是TargetType.DETAIL就是文章id，如果是h5就是链接
        param: String
    ) {
        anyLayer(R.layout.dialog_home_advertising, true, R.color.c_F)
            .onInitialize { layer ->
                //图片
                layer.getView<ImageView>(R.id.PicImage)?.apply {
                    glideDefault(layer.child.context, pic, false)
                    setOnClickListener {
                        when (targetType) {
                            //跳转到开盒页
                            TargetType.BOX.type -> {
                                homeGoBoxPermission.checkPermission {
                                    layer.dismiss()
                                    BaseViewModel.skipNavMenu.value = MainBottomData.Box
                                }
                            }
                            //跳转到文章详情
                            TargetType.DETAIL.type -> {
                                layer.dismiss()
                                skipArticleDetails(param.toIntOrNull() ?: return@setOnClickListener)
                            }
                            //跳转到内置的webview
                            TargetType.H5.type -> {
                                layer.dismiss()
                                WebActivity.start(requireContext(), param)
                            }
                            //无点击事件
                            TargetType.NONE.type -> {
                            }
                        }
                    }
                }
            }
            .onClickToDismiss(R.id.Close)
            //不拦截物理按键
            .interceptKeyEvent(false)
            .show()
    }

    //广告图片的点击事件
    private val imageClick = { targetType: String, param: String ->
        when (targetType) {
            //跳转到开盒页
            TargetType.BOX.type -> {
                homeGoBoxPermission.checkPermission {
                    BaseViewModel.skipNavMenu.value = MainBottomData.Box
                }
            }
            //跳转到文章详情
            TargetType.DETAIL.type -> {
                if (param.toIntOrNull() != null) {
                    skipArticleDetails(param.toIntOrNull()!!)
                }
            }
            //跳转到内置的webview
            TargetType.H5.type -> {
                WebActivity.start(requireContext(), param)
            }
            //无点击事件
            TargetType.NONE.type -> {
            }
        }
    }

    //信息流列表的adapter
    private val informationListAdapter =
        object :
            BaseHeaderAdapter<InformationData, ViewHomeListBinding, InforBannerListData, ViewHomeListHeaderBinding>(
                showHeaderLayout = true
            ) {

            @SuppressLint("UseCompatLoadingForDrawables")
            override fun onBindItem(
                holder: BaseViewHolder,
                binding: ViewHomeListBinding,
                item: InformationData,
                position: Int
            ) {
                binding.apply {
                    type = item.type
                    data = item

                    when (item.type) {
                        1 -> {
                            ImageShowA.setItems(item.bannerlist)
                            HeadImg.glideDefault(
                                holder.itemView.context,
                                AliYunImage.mfit(item.avatar, 100),
                                true,
                                R.mipmap.ic_default_head
                            )
                            if (changeLikeData.likeRefresh) {
                                //在文章详情页面点赞回来的时候执行true
                                Like.isSelected = changeLikeData.isLike
                                //点赞数
                                LikeNumber.text = Common.intDispose(changeLikeData.likeNum)
                                changeLikeData.likeRefresh = false
                            } else {
                                //是否已经点赞
                                Like.isSelected = item.isliked == 1
                                LikeNumber.text = Common.intDispose(item.likenumber)
                            }
                            Content.text = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                                //html块元素之间使用一个换行符分隔
                                Html.fromHtml(item.content, Html.FROM_HTML_MODE_COMPACT)
                            } else {
                                Html.fromHtml(item.content)
                            }
                            //点赞 / 取消点赞
                            Like.setOnClickListener {
                                LikeNumber.text = if (Like.isSelected) {
                                    (LikeNumber.text.toString().toInt() - 1).toString()
                                } else {
                                    Like.scaleXY(1.1f, 1.1f, 150)
                                    (LikeNumber.text.toString().toInt() + 1).toString()
                                }
                                Like.isSelected = !Like.isSelected
                                mViewModel.inforLikeArticle(item.id)
                            }
                            //跳转到文章详情
                            ArticleConst.setOnClickListener {
                                skipArticleDetails(item.id, position)
                            }
                        }
                        2 -> {
                            CardA.setBackgroundColor(Color.TRANSPARENT)
                            BgImg.glideDefault(
                                holder.itemView.context,
                                AliYunImage.mfit(item.bgimg, 750),
                                false
                            )
                            Banner.glideDefault(
                                holder.itemView.context,
                                AliYunImage.mfit(item.banner, 200),
                                false
                            )
                            EntryContent.text =
                                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                                    //html块元素之间使用一个换行符分隔
                                    Html.fromHtml(item.content, Html.FROM_HTML_MODE_COMPACT)
                                } else {
                                    Html.fromHtml(item.content)
                                }
                            //todo 去开个词条盲盒
                            GoBtn.setOnClickListener {
//
                            }
                        }
                    }
                }
            }

            override fun onBindHeaderItem(
                holder: BaseViewHolder,
                binding: ViewHomeListHeaderBinding,
                item: InforBannerListData
            ) {
                binding.apply {
                    when (item.list.size) {
                        1 -> {
                            if (ImageA.isGone) ImageA.visible()
                            ImageB.gone()
                        }
                        2 -> {
                            if (ImageA.isGone) ImageA.visible()
                            if (ImageB.isGone) ImageB.visible()
                        }
                        else -> {
                            ImageA.gone()
                            ImageB.gone()
                        }
                    }

                    item.list.getOrNull(0)?.let { bannerItem ->
                        ImageA.glideDefault(holder.itemView.context, bannerItem.pic, false)
                        ImageA.setOnClickListener {
                            imageClick(bannerItem.targettype, bannerItem.param)
                        }
                    }

                    item.list.getOrNull(1)?.let { bannerItem ->
                        ImageB.glideDefault(holder.itemView.context, bannerItem.pic, false)
                        ImageB.setOnClickListener {
                            imageClick(bannerItem.targettype, bannerItem.param)
                        }
                    }

                }
            }

            override fun getLayoutResId(viewType: Int): Int {
                return when (viewType) {
                    0 -> R.layout.view_home_list_header
                    else -> R.layout.view_home_list
                }
            }
        }

    private inner class AppBrowserViewClient : BrowserView.BrowserViewClient() {

        /**
         * 网页加载错误时回调，这个方法会在 onPageFinished 之前调用
         */
        override fun onReceivedError(view: WebView, errorCode: Int, description: String, failingUrl: String) {
            ToastUtils.show("加载失败")
        }

        /**
         * 开始加载网页
         */
        override fun onPageStarted(view: WebView, url: String, favicon: Bitmap?) {
            mDataBind.TitleBarProgress.visible()
        }

        /**
         * 完成加载网页
         */
        override fun onPageFinished(view: WebView, url: String) {
            mDataBind.TitleBarProgress.gone()
        }
    }

    private inner class AppBrowserChromeClient constructor(view: BrowserView) : BrowserView.BrowserChromeClient(view) {

        /**
         * 收到加载进度变化
         */
        override fun onProgressChanged(view: WebView, newProgress: Int) {
            mDataBind.TitleBarProgress.progress = newProgress
        }
    }

    override fun updateStatusBarColor(): Boolean = false

}
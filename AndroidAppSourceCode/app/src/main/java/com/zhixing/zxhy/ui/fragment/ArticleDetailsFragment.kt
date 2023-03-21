package com.zhixing.zxhy.ui.fragment

import android.content.Context
import android.graphics.Rect
import android.os.Build
import android.os.Bundle
import android.text.*
import android.view.Gravity
import android.view.View
import android.widget.*
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.core.view.isGone
import androidx.core.view.isVisible
import androidx.core.widget.NestedScrollView
import androidx.lifecycle.lifecycleScope
import androidx.navigation.fragment.findNavController
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.blankj.utilcode.util.*
import com.google.android.material.imageview.ShapeableImageView
import com.hjq.toast.ToastUtils
import com.tuanliu.common.base.BaseDbAdapter
import com.tuanliu.common.base.BaseDbFragment
import com.tuanliu.common.base.BaseRvAdapter
import com.tuanliu.common.base.BaseViewModel
import com.tuanliu.common.ext.*
import com.tuanliu.common.model.FragmentConfigData
import com.tuanliu.common.model.StatusBarMode
import com.zhixing.zxhy.databinding.*
import com.zhixing.zxhy.util.*
import com.tuanliu.common.util.ImmersionBarUtil.changeNaviColor
import com.zhixing.zxhy.*
import com.zhixing.zxhy.util.databinding.Common
import com.zhixing.zxhy.util.toPermission.CheckSitePermission
import com.zhixing.zxhy.view_model.ArticleDetailsViewModel
import com.zhixing.zxhy.widget.BaseCommonAnyLayer
import com.zhpan.bannerview.BannerViewPager
import com.zhpan.bannerview.BaseBannerAdapter
import com.zhpan.bannerview.BaseViewHolder
import com.zhpan.indicator.enums.IndicatorSlideMode
import com.zhpan.indicator.enums.IndicatorStyle
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import per.goweii.anylayer.AnyLayer
import per.goweii.anylayer.Layer
import per.goweii.anylayer.widget.SwipeLayout
import kotlin.math.abs

/**
 * 文章详情页面
 */
class ArticleDetailsFragment :
    BaseDbFragment<ArticleDetailsViewModel, FragmentArticleDetailsBinding>() {

    companion object {
        val dialogList = listOf("删除笔记", "编辑笔记")
    }

    private val baseCommonAnyLayer = BaseCommonAnyLayer(this)

    //文章详情的入口
    private var entrance = Entrance.ARTICLE_DETAIL.i

    //改变上个页面的爱好
    private var changeUpLayoutLike: Boolean = false
    private var homeListPosi: Int = -1

    private val checkSitePermission by lazy { CheckSitePermission(this@ArticleDetailsFragment) }

    override fun initView(savedInstanceState: Bundle?) {
        val id = arguments?.getInt("id") ?: 0
        homeListPosi = arguments?.getInt("POSITION") ?: -1
        entrance = arguments?.getInt("ENTRANCE") ?: 0
        if (id == 0) {
            ToastUtils.show("数据有误。")
            backUpLayout()
        } else mViewModel.id = id

        mDataBind.apply {
            vm = mViewModel
            getBannerVp(BannerVp as BannerViewPager<String>).apply {
                adapter = detailsBannerAdapter
                setIndicatorView(IndVA)
                    .create()
                visible()
            }

            //返回
            Back.setOnClickListener {
                backUpLayout()
            }
            //点赞
            Like.setOnClickListener {
                LikeNumber.text.toString().toIntOrNull()?.let {
                    LikeNumber.text = if (Like.isSelected) {
                        (it - 1).toString()
                    } else {
                        Like.scaleXY(1.1f, 1.1f, 150)
                        (it + 1).toString()
                    }
                }
                ToastUtils.show(if (Like.isSelected) "取消点赞" else "点赞成功")
                Like.isSelected = !Like.isSelected
                mViewModel.inforLikeArticle()
            }
            //收藏
            Collect.setOnClickListener {
                CollectNumber.text.toString().toIntOrNull()?.let {
                    CollectNumber.text = if (Collect.isSelected) {
                        (it - 1).toString()
                    } else {
                        (it + 1).toString()
                    }
                }
                Collect.isSelected = !Collect.isSelected
                mViewModel.inforFavActicle()
            }
            //到过的人的头像
            GoTavatarRecyc.apply {
                //重叠
                addItemDecoration(object : RecyclerView.ItemDecoration() {
                    override fun getItemOffsets(
                        outRect: Rect,
                        view: View,
                        parent: RecyclerView,
                        state: RecyclerView.State
                    ) {
                        super.getItemOffsets(outRect, view, parent, state)
                        val position = parent.getChildAdapterPosition(view)
                        if (position == 0) return
                        outRect.left = -dp2Pix(requireContext(), 5f)
                    }
                })
                layoutManager =
                    object : LinearLayoutManager(requireContext(), HORIZONTAL, false) {
                        //禁止滑动
                        override fun canScrollHorizontally(): Boolean = false
                    }
                adapter = gotAvatarAdapter
            }
            //评论
            CommentRecyc.apply {
                layoutManager =
                    object : LinearLayoutManager(requireContext(), VERTICAL, false) {
                        //禁止滑动
                        override fun canScrollHorizontally(): Boolean = false
                    }
                adapter = commentAdapter
            }
            //评论下拉框
            CommentSmart.loadMore {
                mViewModel.inforGetCommentList(CommentSmart, false)
            }
            //讲两句弹框
            ViewA.setOnClickListener {
                inputComment {
                    mViewModel.inforCreateComment(it, null)
                }
            }
            //评论数量，点击滑动到评论位置
            Comment.setOnClickListener {
                //带动画滚动到指定位置
                NestA.smoothScrollTo(0, CommentStr.top)
            }
            //分享
            Share.setOnClickListener {
                if (!shareDialog.isShown) shareDialog.show()
            }
            //删除/编辑文章
            Compile.setOnClickListener {
                baseCommonAnyLayer(dialogList, oneBlock = {
                    //删除笔记弹窗
                    if (!deleteAnyLayer.isShown) deleteAnyLayer.show()
                }, twoBlock = {
                    //跳转到写笔记页面
                    val bundle = Bundle().apply {
                        putInt("id", mViewModel.id)
                        putString("TITLE_STR", "编辑笔记")
                        putString("SEND_STR", "保存")
                    }
                    animationNav(R.id.action_articleDetailsFragment_to_sendArticleFragment, bundle)
                }, naviColor = R.color.c_F8, oneTextColor = R.color.c_E24E4E) {}
            }
            //文章的地址
            LocationConst.setOnClickListener {
                checkSitePermission.checkPermission {
                    mViewModel.detailsLiveData.value?.location?.apply {
                        if (lat == 0.0 || lng == 0.0) return@checkPermission
                        val bundle = Bundle().apply {
                            putParcelable(
                                "checkSiteData",
                                CheckSiteData(lat, lng, address, detailaddress, point)
                            )
                        }
                        animationNav(
                            R.id.action_articleDetailsFragment_to_checkSiteFragment,
                            bundle
                        )
                    }
                }
            }
        }
    }

    override fun initNetRequest() {
        mViewModel.inforGetDetailData()
    }

    override fun initLiveData() {
        mViewModel.apply {

            //文章详情
            detailsLiveData.observerKt {
                if (it == null) return@observerKt
                //评论数量
                if (it.commentnumber != 0) {
                    inforGetCommentList(mDataBind.CommentSmart, true)
                }
                mDataBind.BannerVp.refreshData(it.bannerlist)
                //是否已经点赞
                mDataBind.Like.isSelected = it.isliked == 1
                //是否已经收藏
                mDataBind.Collect.isSelected = it.isfaved == 1
                //头像
                mDataBind.HeadImg.glideDefault(
                    requireContext(),
                    AliYunImage.mfit(it.avatar, 100),
                    id = R.mipmap.ic_default_head
                )
                //文章内容
                mDataBind.Content.text = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                    //html块元素之间使用一个换行符分隔
                    Html.fromHtml(it.content, Html.FROM_HTML_MODE_COMPACT)
                } else {
                    Html.fromHtml(it.content)
                }
                //到过的人
                if (it.gotavatarlist?.size ?: 0 >= 1) {
                    gotAvatarAdapter.setData(it.gotavatarlist)
                }
            }

            //点赞
            inforLikeArticleLiveData.observerKt {
                changeUpLayoutLike = !changeUpLayoutLike
            }

            //评论列表
            inforCommentListLiveData.observerKt {
                commentAdapter.loadListSuccess(it!!, mDataBind.CommentSmart)
            }

            //发表评论
            inforCreateCommentLiveData.observerKt {
                if (it == null) return@observerKt
                ToastUtils.show("评论成功")
                when (it.replyid) {
                    //评论文章
                    0 -> {
                        //评论数量
                        commentnumber.value = commentnumber.value!! + 1
                        if (mDataBind.CommentSmart.isGone) {
                            mDataBind.CommentSmart.visible()
                            mDataBind.EmptyComment.gone()
                            commentAdapter.setData(listOf(it))
                        } else commentAdapter.addItemAll(it, 0)
                    }
                }
            }

            //举报
            inforReportLiveData.observerKt {
                mDataBind.ReportImg.clearAnimation()
                reportHint()
            }

            //删除文章
            inforDeleteLd.observerKt {
                ToastUtils.show("删除成功")
                backUpLayout()
                when (entrance) {
                    Entrance.ARTICLE_DETAIL.i -> {
                        //刷新首页
                        BaseViewModel.updateHomeListLayout.value = "it"
                    }
                    Entrance.MY_COLLECT.i -> {
                        //更新我的收藏列表
                        BaseViewModel.updateMyCollectList.value = "it"
                    }
                    Entrance.HAVE_ARTICLE.i -> {
                    }
                }
                //如果是自己发布的文章就更新更新用户信息
                if (it == true) {
                    BaseViewModel.updateUserMessage.value = "it"
                }
            }

        }
    }

    /**
     * 返回上一个页面
     */
    private fun backUpLayout() {
        if (homeListPosi != -1 && changeUpLayoutLike) {
            findNavController().previousBackStackEntry?.savedStateHandle?.set(
                "LIKE",
                arrayOf(
                    ChangeLikeData(
                        true, homeListPosi,
                        mDataBind.Like.isSelected, getLikeNumber()
                    )
                )
            )
        }
        findNavController().popBackStack()
    }

    /**
     * 获取真实的点赞数
     */
    private fun getLikeNumber(): Int {
        val selected = mDataBind.Like.isSelected
        val likeNum = mViewModel.detailsLiveData.value?.likenumber ?: 0
        return when (selected) {
            (mViewModel.detailsLiveData.value?.isliked == 1) -> likeNum
            else -> if (selected) likeNum + 1 else likeNum - 1
        }
    }

    /**
     * 举报成功提示
     */
    private fun reportHint() {
        lifecycleScope.launch {
            mDataBind.ReportImg.alpha1()
            //这里的3秒包括显示的1秒钟
            delay(3000)
            mDataBind.ReportImg.alpha0()
        }
    }

    /**
     * 评论列表的数据
     */
    private fun commentData(
        context: Context,
        HeadImg: ShapeableImageView,
        NickName: TextView,
        Content: TextView,
        Time: TextView,
        avatar: String,
        nickname: String,
        content: String,
        sendtime: String
    ) {
        HeadImg.glideDefault(context, AliYunImage.mfit(avatar, 100), false)
        NickName.text = nickname
        Content.text = ""
        Content.append(content.emojiTextToSpan(requireContext(), 17f))
        Time.text = Common.dateTransition(sendtime)
    }

    /**
     * 创建一个bannerViewPager
     */
    private fun getBannerVp(bannerViewPager: BannerViewPager<String>): BannerViewPager<String> {
        bannerViewPager.apply {
            //是否开启自动轮播
            setAutoPlay(false)
            //是否开启循环
            setCanLoop(true)
            //左右间隔
//            setPageMargin(dp2Pix(requireContext(), 20f))
//            setRevealWidth(0, dp2Pix(requireContext(), 137f))
            setIndicatorSliderGap(dp2Pix(requireContext(), 4f))
            setIndicatorStyle(IndicatorStyle.ROUND_RECT)
            setIndicatorSlideMode(IndicatorSlideMode.WORM)
            setIndicatorSliderColor(
                requireContext().getResColor(R.color.c_C4),
                requireContext().getResColor(R.color.c_FF5280)
            )
        }
        return bannerViewPager
    }

    /**
     * 输入评论弹窗
     */
    private fun inputComment(commentHint: String = "讲两句", sendBlock: (commentStr: String) -> Unit) {

        //当前是否显示是键盘(此时处于表情页面键盘收起)
        var isKeyBoard = true

        //记录时间，避免太快点击表情/键盘切换
        var recordTime = 0L

        AnyLayer.dialog(requireContext())
            //点击浮层以外区域是否可关闭
            .cancelableOnTouchOutside(true)
            .gravity(Gravity.BOTTOM)
            .swipeDismiss(SwipeLayout.Direction.BOTTOM)
            .contentView(R.layout.dialog_details_edit)
            //拦截物理按键
            .interceptKeyEvent(true)
            .onInitialize { layer ->
                val comment = layer.getView<EditText>(R.id.Comment)
                val sendBtn = layer.getView<Button>(R.id.SendBtn)

                comment!!.hint = commentHint
                comment!!.addTextChangedListener(object : TextWatcher {
                    override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {}
                    override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {}

                    override fun afterTextChanged(p0: Editable?) {
                        if (p0.toString() != "" && !sendBtn!!.isEnabled) {
                            sendBtn.isEnabled = true
                        } else if (p0.toString() == "" && sendBtn!!.isEnabled) {
                            sendBtn.isEnabled = false
                        }
                    }
                })

                //表情Const
                val emojiConst = layer.getView<ConstraintLayout>(R.id.EmojiConst)
                //键盘 或 表情
                val keyBoardEmoji = layer.getView<ImageView>(R.id.KeyBoardEmoji)

                val keyBoardFalse = {
                    keyBoardEmoji?.setImageResource(R.mipmap.ic_keyboard)
                    KeyboardUtils.hideSoftInput(comment!!)
                    lifecycleScope.launch {
                        delay(180)
                        emojiConst.visible()
                    }
                }

                val keyBoardTrue = {
                    keyBoardEmoji?.setImageResource(R.mipmap.ic_emoji)
                    emojiConst.gone()
                    KeyboardUtils.showSoftInput(comment!!)
                }

                comment.setOnClickListener {
                    isKeyBoard = !isKeyBoard
                    if (isKeyBoard) keyBoardTrue()
                }

                keyBoardEmoji?.setOnClickListener {
                    val nowTime = System.currentTimeMillis()
                    if (nowTime - recordTime < 250) {
                        ToastUtils.show("亲，你点太快啦。")
                        return@setOnClickListener
                    }
                    recordTime = nowTime
                    isKeyBoard = !isKeyBoard
                    when (isKeyBoard) {
                        //软键盘隐藏，EmojiConst显示
                        false -> keyBoardFalse()
                        //软键盘显示，EmojiConst隐藏
                        true -> keyBoardTrue()
                    }
                }

                val emojiAppend = { emojiFace: EmojiFace ->
                    val span = requireContext().toEmojiSpan(emojiFace, 14f)
                    comment.append(span)
                }

                layer.getView<ImageButton>(R.id.Emoji001)?.setOnClickListener {
                    emojiAppend(EmojiFace.Emoji001)
                }
                layer.getView<ImageButton>(R.id.Emoji002)?.setOnClickListener {
                    emojiAppend(EmojiFace.Emoji002)
                }
                layer.getView<ImageButton>(R.id.Emoji003)?.setOnClickListener {
                    emojiAppend(EmojiFace.Emoji003)
                }
                layer.getView<ImageButton>(R.id.Emoji004)?.setOnClickListener {
                    emojiAppend(EmojiFace.Emoji004)
                }
                layer.getView<ImageButton>(R.id.Emoji005)?.setOnClickListener {
                    emojiAppend(EmojiFace.Emoji005)
                }
                layer.getView<ImageButton>(R.id.Emoji006)?.setOnClickListener {
                    emojiAppend(EmojiFace.Emoji006)
                }
                layer.getView<ImageButton>(R.id.Emoji007)?.setOnClickListener {
                    emojiAppend(EmojiFace.Emoji007)
                }
                layer.getView<ImageButton>(R.id.Emoji008)?.setOnClickListener {
                    emojiAppend(EmojiFace.Emoji008)
                }
                layer.getView<ImageButton>(R.id.Emoji009)?.setOnClickListener {
                    emojiAppend(EmojiFace.Emoji009)
                }
                layer.getView<ImageButton>(R.id.Emoji010)?.setOnClickListener {
                    emojiAppend(EmojiFace.Emoji010)
                }
                layer.getView<ImageButton>(R.id.Emoji011)?.setOnClickListener {
                    emojiAppend(EmojiFace.Emoji011)
                }
                layer.getView<ImageButton>(R.id.Emoji012)?.setOnClickListener {
                    emojiAppend(EmojiFace.Emoji012)
                }
                layer.getView<ImageButton>(R.id.Emoji013)?.setOnClickListener {
                    emojiAppend(EmojiFace.Emoji013)
                }
                layer.getView<ImageButton>(R.id.Emoji014)?.setOnClickListener {
                    emojiAppend(EmojiFace.Emoji014)
                }
                layer.getView<ImageButton>(R.id.Emoji015)?.setOnClickListener {
                    emojiAppend(EmojiFace.Emoji015)
                }
                layer.getView<ImageButton>(R.id.Emoji016)?.setOnClickListener {
                    emojiAppend(EmojiFace.Emoji016)
                }
                layer.getView<ImageButton>(R.id.Emoji017)?.setOnClickListener {
                    emojiAppend(EmojiFace.Emoji017)
                }
                layer.getView<ImageButton>(R.id.Emoji018)?.setOnClickListener {
                    emojiAppend(EmojiFace.Emoji018)
                }
                layer.getView<ImageButton>(R.id.Emoji019)?.setOnClickListener {
                    emojiAppend(EmojiFace.Emoji019)
                }
                layer.getView<ImageButton>(R.id.Emoji020)?.setOnClickListener {
                    emojiAppend(EmojiFace.Emoji020)
                }

                //发送
                sendBtn!!.setOnClickListener {
                    sendBlock.invoke(comment.text.toString())
                    layer.dismiss()
                }
                //延迟一点，等弹窗初始化完成，不然会有下面的透明区域
                lifecycleScope.launch {
                    delay(200)
                    KeyboardUtils.showSoftInput(comment!!)
                }
            }
            .show()
    }

    /**
     * 分享到微信对话/朋友圈
     * [SendToWx.Session] 分享到对话
     * [SendToWx.TimeLine] 分享到朋友圈
     */
    private fun share(context: Context, sendToWx: SendToWx = SendToWx.Session) {
        context.glideDefault(
            AliYunImage.mfit(
                mViewModel.detailsLiveData.value?.bannerlist?.get(0) ?: "", 100
            )
        ) {
            lifecycleScope.launch(Dispatchers.Main) {
                WxApi.sendUrl(
                    sendToWx,
                    mViewModel.detailsLiveData.value?.h5url.toString(),
                    mViewModel.detailsLiveData.value?.title.toString(),
                    mViewModel.detailsLiveData.value?.content.toString(),
                    it
                )
            }
        }
    }

    //分享弹窗
    private val shareDialog by lazy {
        anyLayer(true).contentView(R.layout.dialog_article_share_b)
            .gravity(Gravity.BOTTOM)
            .swipeDismiss(SwipeLayout.Direction.BOTTOM)
            .onClickToDismiss(R.id.Close)
            .onShowListener(object : Layer.OnShowListener {
                override fun onShowing(layer: Layer) {
                    changeNaviColor(R.color.c_F)
                }

                override fun onShown(layer: Layer) {}
            })
            //举报文章
            .onClickToDismiss({ _, _ ->
                //这里停顿一下，不然会影响举报弹窗导航栏颜色
                lifecycleScope.launch {
                    delay(300)
                    reportTwoAnyLayer()
                }
            }, R.id.Report)
            //复制链接
            .onClick({ _, _ ->
                ClipboardUtils.copyText(mViewModel.detailsLiveData.value?.h5url.toString())
                ToastUtils.show("复制成功")
            }, R.id.Link)
            //分享到对话
            .onClick({ _, v ->
                share(v.context)
            }, R.id.WeiXin)
            //分享到朋友圈
            .onClick({ _, v ->
                share(v.context, SendToWx.TimeLine)
            }, R.id.Friend)
            .onDismissListener(object : Layer.OnDismissListener {
                override fun onDismissing(layer: Layer) {}

                override fun onDismissed(layer: Layer) {
                    changeNaviColor(R.color.c_F8)
                }
            })
    }

    /**
     * 顶部轮播图适配器
     */
    private val detailsBannerAdapter by lazy {
        object : BaseBannerAdapter<String>() {

            override fun bindData(
                holder: BaseViewHolder<String>?,
                data: String?,
                position: Int,
                pageSize: Int
            ) {
                val image = holder?.findViewById<ImageView>(R.id.ImageViewA)
                holder?.itemView?.context?.glideDefault(data.toString()) { bitmap ->
                    image?.let {
                        image.scaleType =
                            if (bitmap.width > bitmap.height) ImageView.ScaleType.FIT_CENTER else ImageView.ScaleType.CENTER_CROP
                        image.setImageBitmap(bitmap)
                    }
                }
            }

            override fun getLayoutId(viewType: Int): Int = R.layout.view_details_image
        }
    }

    /**
     * 到过的人列表的适配器
     */
    private val gotAvatarAdapter by lazy {
        object : BaseRvAdapter<String, ViewDetailsGotImageBinding>() {
            override fun onBindItem(
                holder: BaseViewHolder,
                binding: ViewDetailsGotImageBinding,
                item: String,
                position: Int
            ) {
                binding.apply {
                    Photo.glideDefault(
                        requireContext(),
                        AliYunImage.mfit(item, 40),
                        id = R.mipmap.ic_default_head
                    )
                    //z轴越大显示在越上面 abs：绝对值
                    ConstA.translationZ = abs(position - 5).toFloat()
                }
            }

            override fun getLayoutResId(viewType: Int): Int = R.layout.view_details_got_image
        }
    }

    /**
     * 列表动画
     */
    private fun recyclerAnimation(recyclerView: RecyclerView) {
        val parent = recyclerView.parent as View
        val height = recyclerView.height
        recyclerView.measure(
            View.MeasureSpec.makeMeasureSpec(
                parent.measuredWidth,
                View.MeasureSpec.AT_MOST
            ),
            View.MeasureSpec.makeMeasureSpec(
                0,
                View.MeasureSpec.UNSPECIFIED
            )
        )
        val measuredHeight = recyclerView.measuredHeight
        recyclerView.animationUpdate(height, measuredHeight)
    }

    /**
     * 评论长按弹窗
     * [ismine] 是否是自己发的文章
     * [id] 评论id/回复id
     * [delete] 删除评论的回调
     */
    private fun View.longClickDialog(ismine: Int, id: Int, delete: () -> Unit) {
        this.setOnLongClickListener {
            baseCommonAnyLayer.baseCommonAnyLayer(
                if (ismine == 1) "删除留言" else "举报",
                dismissNaviColor = R.color.c_F8
            ) {
                when (ismine) {
                    //删除
                    1 -> mViewModel.inforDeleteComment(id) {
                        delete()
                    }
                    //举报
                    0 -> mViewModel.inforReportComment(id)
                }
            }
            true
        }
    }

    /**
     * 评论父布局适配器
     */
    private val commentAdapter by lazy {
        object : BaseRvAdapter<CommentListData, ViewCommentBinding>() {
            override fun onBindItem(
                holder: BaseViewHolder,
                binding: ViewCommentBinding,
                item: CommentListData,
                position: Int
            ) {
                binding.apply {
                    val commentIndexAdapter = object :
                        BaseDbAdapter<CommentListData.Replylist, ViewCommentIndexBinding>() {
                        override fun onBindItem(
                            holder: BaseViewHolder,
                            binding: ViewCommentIndexBinding,
                            commentItem: CommentListData.Replylist,
                            commentPosi: Int
                        ) {
                            binding.apply {
                                commentData(
                                    holder.itemView.context,
                                    HeadImg,
                                    NickName,
                                    Content,
                                    Time,
                                    commentItem.avatar,
                                    commentItem.nickname,
                                    commentItem.content,
                                    commentItem.sendtime
                                )
                                //删除评论
                                ConstA.longClickDialog(commentItem.ismine, commentItem.replyid) {
                                    when (SpreadConst.isVisible) {
                                        true -> {
                                            removeOne(commentPosi)
                                            notifyDataSetChanged()
                                            if (getItems().size <= 2) SpreadConst.gone()
                                            else Spread.text = "展开 ${(getItems().size - 2)} 条回复"
                                        }
                                        false -> {
                                            if (getItems().size > 2) {
                                                removeItemNoReturn(commentPosi)
                                                recyclerAnimation(OtherCommentRecyc)
                                            } else removeItemNoReturnTwo(commentPosi)
                                        }
                                    }
                                }
                                //添加评论
                                ConstA.setOnClickListener {
                                    inputComment("回复${commentItem.nickname}:") { str ->
                                        mViewModel.inforCreateCommentIndex(
                                            str,
                                            commentItem.commentid
                                        ) {
                                            addDataNoRefresh(listOf(it))
                                            val itemsSize = getItems().size
                                            if (SpreadConst.isVisible) {
                                                notifyItemRangeChanged(0, 2)
                                                Spread.text = "展开 ${(itemsSize - 2)} 条回复"
                                            } else {
                                                when {
                                                    itemsSize == 3 -> {
                                                        SpreadConst.visible()
                                                        notifyDataSetChanged()
                                                        Spread.text = "展开 ${(itemsSize - 2)} 条回复"
                                                    }
                                                    itemsSize < 3 -> notifyItemInserted(0)
                                                    itemsSize > 3 -> recyclerAnimation(
                                                        OtherCommentRecyc
                                                    )
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        override fun getLayoutResId(viewType: Int): Int =
                            R.layout.view_comment_index

                        override fun setLayoutType(): LayoutType = LayoutType.CAN_UNFOLD
                    }
                    val replyListSize = item.replylist?.size ?: 0
                    //评论子列表
                    OtherCommentRecyc.apply {
                        layoutManager =
                            object :
                                LinearLayoutManager(requireContext(), VERTICAL, false) {
                                //禁止滑动
                                override fun canScrollHorizontally(): Boolean = false
                            }
                        adapter = commentIndexAdapter
                        visible()
                    }
                    commentIndexAdapter.setData(item.replylist)
                    when {
                        replyListSize <= 2 -> SpreadConst.gone()
                        else -> {
                            SpreadConst.visible()
                            Spread.text = "展开 ${(replyListSize - 2)} 条回复"
                        }
                    }
                    //父评论
                    IncludeA.apply {
                        commentData(
                            holder.itemView.context,
                            HeadImg,
                            NickName,
                            Content,
                            Time,
                            item.avatar,
                            item.nickname,
                            item.content,
                            item.sendtime
                        )
                        SpreadConst.setOnClickListener {
                            SpreadConst.gone()
                            //暂时只做展开
                            lifecycleScope.launch {
                                commentIndexAdapter.recyclerAnimationRefreshTwo(OtherCommentRecyc)
                            }
                            //如果是最下面一项的话就直接移动到底部
                            if (position == getItems().size - 1) {
                                //停顿一下等全部展开了再滚动到最下面
                                lifecycleScope.launch {
                                    delay(500)
                                    mDataBind.NestA.fullScroll(NestedScrollView.FOCUS_DOWN)
                                }
                            }
                        }
                        ConstA.longClickDialog(item.ismine, item.commentid) {
                            removeItem(position)
                            mViewModel.commentnumber.value = mViewModel.commentnumber.value!! - 1
                            //如果此时没有数据的话就显示空布局
                            if (itemCount == 0) {
                                mDataBind.CommentSmart.gone()
                                mDataBind.EmptyComment.visible()
                            }
                        }
                        ConstA.setOnClickListener {
                            inputComment("回复${item.nickname}:") { str ->
                                mViewModel.inforCreateCommentIndex(str, item.commentid) {
                                    commentIndexAdapter.addDataNoRefresh(listOf(it))
                                    val itemsSize = commentIndexAdapter.getItems().size
                                    if (SpreadConst.isVisible) {
                                        commentIndexAdapter.notifyItemRangeChanged(0, 2)
                                        Spread.text = "展开 ${(itemsSize - 2)} 条回复"
                                    } else {
                                        when {
                                            itemsSize == 3 -> {
                                                SpreadConst.visible()
                                                commentIndexAdapter.notifyDataSetChanged()
                                                Spread.text = "展开 ${(itemsSize - 2)} 条回复"
                                            }
                                            itemsSize < 3 -> commentIndexAdapter.notifyItemInserted(
                                                0
                                            )
                                            itemsSize > 3 -> recyclerAnimation(OtherCommentRecyc)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            override fun getLayoutResId(viewType: Int): Int = R.layout.view_comment
        }
    }

    //删除笔记弹窗
    private val deleteAnyLayer by lazy {
        anyLayer(R.layout.dialog_delete_article, true, R.color.c_F8)
            .onClickToDismiss(R.id.Cancel)
            .onClickToDismiss({ _, _ ->
                //确定删除
                mViewModel.inforDeleteInfo()
            }, R.id.Confirm)
    }

    //举报二次确认弹窗
    private fun reportTwoAnyLayer() =
        anyLayer(R.layout.dialog_report_two, true, R.color.c_F8)
            .onClickToDismiss(R.id.Cancel)
            .onClickToDismiss({ _, _ ->
                mViewModel.inforReportComment()
            }, R.id.Confirm)
            .show()

    override fun onResume() {
        super.onResume()
        getFocus {
            backUpLayout()
        }
    }

    override fun fragmentConfigInit(): FragmentConfigData =
        FragmentConfigData(
            false,
            transparentStatusBar = false,
            statusBarMode = StatusBarMode.STATUS_BAR_MODE_DARK,
            transparentNavigationBar = false,
            navigationBarColor = R.color.c_F8
        )

    /**
     * 页面的入口
     */
    enum class Entrance(val i: Int) {
        //文章详情
        ARTICLE_DETAIL(0),

        //我的收藏
        MY_COLLECT(1),

        //已发布的笔记
        HAVE_ARTICLE(2)
    }

}
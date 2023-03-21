package com.zhixing.zxhy.widget

import android.view.View
import androidx.recyclerview.widget.RecyclerView
import com.tuanliu.common.ext.dp
import kotlin.math.abs

/**
 * 弹幕的LayoutManager
 * https://juejin.cn/post/7010521583894659103#heading-5
 */
class LaneLayoutManager : RecyclerView.LayoutManager() {
    /**
     * 填充结束标识
     */
    private val LAYOUT_FINISH = -1

    /**
     * 列表适配器索引
     */
    private var adapterIndex = 0

    /**
     * the min right most pixel according to RecyclerView of lane view,
     * it means that lane will drain out first when scrolling
     */
    private var minEnd = Int.MAX_VALUE

    /**
     * 第几行
     */
    private var firstDrainLaneIndex = 0

    /**
     * 存放所有泳道的数据
     */
    private var lanes = mutableListOf<Lane>()

    /**
     * 弹幕纵向间隔
     */
    var verticalGap = 5
        get() = field.dp

    /**
     * 弹幕横向间隔
     */
    var horizontalGap = 3
        get() = field.dp

    //可供弹幕布局的高度，即列表高度
    private val totalSpace: Int
        get() = height - paddingTop - paddingBottom

    //弹幕泳道数，即列表纵向可以容纳几条弹幕
    private var laneCount: Int? = null

    /**
     * define the layout params for child view in RecyclerView
     * override this is a must for customized [RecyclerView.LayoutManager]
     */
    override fun generateDefaultLayoutParams(): RecyclerView.LayoutParams {
        return RecyclerView.LayoutParams(
            RecyclerView.LayoutParams.WRAP_CONTENT,
            RecyclerView.LayoutParams.WRAP_CONTENT
        )
    }

    /**
     * 只会在列表初次布局的时候调用一次
     */
    override fun onLayoutChildren(recycler: RecyclerView.Recycler?, state: RecyclerView.State?) {
        fillLanes(recycler, lanes)
    }

    /**
     * RecyclerView在滚动发生之前，会根据预计滚动位移距离大小决定向列表内填充多少新的表项
     * 每一段位滚动的位移都会传递到这个方法
     * 通常在该方法中根据位移大小填充新的表项，然后再触发列表的滚动
     */
    override fun scrollHorizontallyBy(
        dx: Int,
        recycler: RecyclerView.Recycler?,
        state: RecyclerView.State?
    ): Int {
        return scrollBy(dx, recycler)
    }

    /**
     * 列表可以横向滚动
     */
    override fun canScrollHorizontally(): Boolean = true

    /**
     * 封装了根据滚动持续填充表项的逻辑
     *
     * 遵循的原则：
     * 1、更新泳道信息
     * 2、向枯竭泳道填充弹幕
     * 3、触发滚动
     * 在3之前，我们能根据位移距离计算出滚动发生之后即将枯竭的泳道
     */
    private fun scrollBy(dx: Int, recycler: RecyclerView.Recycler?): Int {
        //如果列表没有子项或未发生滚动则返回0，不滚动
        if (childCount == 0 || dx == 0) return 0

        //更新泳道的信息
        updateLanesEnd(lanes)
        //取滚动的绝对值
        val absDx = abs(dx)
        // fill new views into lanes after scrolled
        val endView = lanes.getOrNull(firstDrainLaneIndex)?.getEndView()
        if (endView != null && isVisibleByScroll(endView, absDx)) {
            fillLanes(recycler, lanes)
        }
        // recycle views in lanes after scrolled
        recycleGoneView(lanes, absDx, recycler)
        //滚动列表的落脚点：将表项向手指位移的反方向平移相同的距离
        offsetChildrenHorizontal(-absDx)
        return dx
    }

    /**
     * 填充表项
     */
    private fun fillLanes(recycler: RecyclerView.Recycler?, lanes: MutableList<Lane>) {
        //可供弹幕布局的剩余高度
        var remainSpace = totalSpace
        //只要空间足够，就继续填充表项
        while (hasMoreLane(remainSpace)) {
            val consumeSpace = layoutView(recycler, totalSpace, remainSpace, lanes)
            //填充结束标示
            if (consumeSpace == LAYOUT_FINISH) break
            //更新剩余空间
            remainSpace -= consumeSpace
        }
        minEnd = Int.MAX_VALUE
    }

    /**
     * 回收弹幕
     */
    private fun recycleGoneView(lanes: List<Lane>, dx: Int, recycler: RecyclerView.Recycler?) {
        recycler ?: return
        lanes.forEach { lane ->
            getChildAt(lane.startLayoutIndex)?.let { startView ->
                if (isGoneByScroll(startView, dx)) {
                    //RecyclerView回收表项的入口
                    removeAndRecycleView(startView, recycler)
                    updateLaneIndexAfterRecycle(lanes, lane.startLayoutIndex)
                    lane.startLayoutIndex += lanes.size - 1
                }
            }
        }
    }

    /**
     * after view is recycled and remove from RecyclerView, the layout index in lane should be minus 1
     */
    private fun updateLaneIndexAfterRecycle(lanes: List<Lane>, recycleIndex: Int) {
        lanes.forEachIndexed { index, lane ->
            if (lane.startLayoutIndex > recycleIndex) {
                lane.startLayoutIndex--
            }
            if (lane.endLayoutIndex > recycleIndex) {
                lane.endLayoutIndex--
            }
        }
    }

    /**
     * 填充单个表项
     */
    private fun layoutView(
        recycler: RecyclerView.Recycler?,
        totalSpace: Int,
        remainSpace: Int,
        lanes: MutableList<Lane>
    ): Int {
        /**
         * 1、从缓存池中获取表项试图
         * 如果未缓存，则会触发onCreateViewHolder和onBindViewHolder
         * 如果获取表项试图失败，则结束填充
         */
        val view = recycler?.getViewForPosition(adapterIndex) ?: return LAYOUT_FINISH
        //测量表项视图
        measureChildWithMargins(view, 0, 0)
        val verticalMargin =
            (view.layoutParams as? RecyclerView.LayoutParams)?.let { it.topMargin + it.bottomMargin }
                ?: 0
        val consumed = getDecoratedMeasuredHeight(view) + verticalMargin + verticalGap
        //如果剩余高度不足以填充，就返回结束，到下一行
        if (remainSpace - consumed < 0) return LAYOUT_FINISH

        //将表项视图填充成列表子项
        addView(view)

        //弹幕泳道数，即列表纵向可以容纳几条弹幕
        if (laneCount == null) laneCount =
            (totalSpace + verticalGap) / (view.measuredHeight + verticalGap)
        //计算当前表项所在泳道
        val laneIndex = adapterIndex % laneCount!!
        val lane = lanes.getOrElse(laneIndex) { emptyLane(adapterIndex) }
            .apply { endLayoutIndex = childCount - 1 }
        //计算当前表项上下左右边框
        //弹幕起始点位于列表右边
        val left = lane.end + horizontalGap
        val top = paddingTop + laneIndex * (view.measuredHeight + verticalGap)
        val right = left + view.measuredWidth
        val bottom = top + view.measuredHeight
        //4、布局该表项(该方法考虑到了ItemDecoration)
        layoutDecorated(view, left, top, right, bottom)

        updateLane(laneIndex, right, lane, lanes)
        findFirstDrainLane(right, laneIndex)

        //更新当前子项index
        adapterIndex++
        //返回消耗的像素值
        return consumed
    }

    /**
     * whether [view] will be exposed in RecyclerView if scrolled [dx] to the left
     */
    private fun isVisibleByScroll(view: View, dx: Int): Boolean = getEnd(view) - dx < width

    /**
     * whether [view] will be invisible in RecyclerView if scrolled [dx] to the left
     */
    private fun isGoneByScroll(view: View, dx: Int): Boolean = getEnd(view) - dx < 0

    /**
     * 更新泳道信息
     * 因为每次很小段的位移也会让尾部弹幕的横坐标发生变化，如果不同步更新的话会导致计算出错
     */
    private fun updateLanesEnd(lanes: MutableList<Lane>) {
        lanes.forEach { lane ->
            lane.getEndView()?.let { lane.end = getEnd(it) }
        }
    }

    /**
     * 计算表项的right值
     * [getDecoratedRight] 返回指定子视图在其父视图内的右边缘
     */
    private fun getEnd(view: View) =
        getDecoratedRight(view) + (view.layoutParams as RecyclerView.LayoutParams).rightMargin

    /**
     * 是否还有剩余空间用于填充 和 是否还有更多数据
     */
    private fun hasMoreLane(remainSpace: Int) = remainSpace > 0 && adapterIndex in 0 until itemCount

    /**
     * find the lane which will drain out first
     * [right] 右边
     * [laneIndex] 是第几行
     */
    private fun findFirstDrainLane(right: Int, laneIndex: Int) {
        if (right < minEnd) {
            minEnd = right
            firstDrainLaneIndex = laneIndex
        }
    }

    /**
     * keep the last view's right in list prepared for layout follow-up views
     */
    private fun updateLane(laneIndex: Int, right: Int, lane: Lane, lanes: MutableList<Lane>) {
        lane.end = right
        if (!lanes.contains(lane)) {
            lanes.add(laneIndex, lane)
        }
    }

    /**
     * return the layout index according to the adapter index
     */
    private fun getLayoutIndex(adapterIndex: Int): Int {
        val firstChildIndex =
            getChildAt(0)?.let { (it.layoutParams as RecyclerView.LayoutParams).bindingAdapterPosition }
                ?: 0
        return adapterIndex - firstChildIndex
    }

    /**
     * [end] 末尾弹幕横坐标：泳道中最后一个弹幕的right值，即它的右侧相对于RecyclerView左侧的距离。该值用于判断经过一段位移的滚动后，该泳道是否会枯竭
     * [endLayoutIndex] 末尾弹幕的布局索引：它是泳道中最后一个弹幕布局的索引，记录它是为了方便地通过getChildAt()获取泳道中最后一个弹幕的视图,
     *      因为对于适配器索引[adapterIndex]来说，它的取值范围是[0, itemsSize],而对于弹幕来说，取之是[0, ∞]
     * [startLayoutIndex] 头部弹幕的布局索引：与[endLayoutIndex]类似，为了方便的获取泳道第一个弹幕的视图
     */
    data class Lane(var end: Int, var endLayoutIndex: Int, var startLayoutIndex: Int)

    /**
     * 获取泳道列表中最后一个弹幕的索引
     */
    private fun Lane.getEndView(): View? = getChildAt(endLayoutIndex)

    /**
     * create an empty [Lane] object
     */
    private fun emptyLane(adapterIndex: Int) =
        Lane(-horizontalGap + width, 0, getLayoutIndex(adapterIndex))
}
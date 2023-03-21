package com.tuanliu.common.base

import android.animation.ValueAnimator
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.annotation.LayoutRes
import androidx.databinding.DataBindingUtil
import androidx.databinding.ViewDataBinding
import androidx.recyclerview.widget.RecyclerView
import com.tuanliu.common.ext.visible
import kotlinx.coroutines.delay
import timber.log.Timber
import kotlin.math.absoluteValue

/**
 * RecycleViewAdapter 基类
 */
abstract class BaseDbAdapter<M, B : ViewDataBinding> :
    RecyclerView.Adapter<BaseDbAdapter.BaseViewHolder>() {

    /**
     * 列表数据源
     */
    private val items: MutableList<M> = ArrayList()

    override fun getItemCount(): Int = when (mLayoutType) {
        LayoutType.NULL -> 1
        LayoutType.NORMAL -> items.size
        LayoutType.MAX_VALUE -> Int.MAX_VALUE
        LayoutType.CAN_UNFOLD -> {
            when(isUnFoldType) {
                UnfoldType.JUST_TWO -> if (items.size >= 2) 2 else items.size
                UnfoldType.UNFOLD -> items.size
            }
        }
    }

    fun getItems(): List<M> {
        return items
    }

    /**
     * 设置数据，触发全局刷新
     * @param dataList 数据列表
     */
    fun setData(dataList: List<M>?) {
        if (dataList == null) {
            Timber.w("数据列表为null，不修改")
            return
        }
        items.clear()
        items.addAll(dataList)
        // 全部刷新
        notifyDataSetChanged()
    }

    /**
     * 刷新position位置的数据
     * 局部刷新
     */
    fun setReplace(position: Int, data: M?) {
        if (data == null) {
            Timber.w("数据列表为null，不修改")
            return
        }
        items[position] = data
        notifyItemRangeChanged(position, items.size - position)
    }

    /**
     * 清除所有数据
     */
    fun deleteData() {
        items.clear()
        notifyDataSetChanged()
    }

    /**
     * 追加数据，追加数据到列表末尾，局部刷新
     * @param dataList 数据列表
     */
    fun addData(dataList: List<M>?) {
        if (dataList == null || dataList.isEmpty()) {
            Timber.w("数据列表为null或者为空，不添加")
            return
        }
        // 当前长度
        val curSize = itemCount
        items.addAll(dataList)
        // 局部刷新
        notifyItemRangeChanged(curSize, dataList.size)
    }

    /**
     * 追加数据，追加数据到列表末尾，全局刷新
     * @param dataList 数据列表
     */
    fun addData(dataList: M?) {
        if (dataList == null) {
            Timber.w("数据列表为null或者为空，不添加")
            return
        }
        items.add(dataList)
        notifyDataSetChanged()
    }

    /**
     * 追加数据，追加数据到列表末尾，全局刷新
     * @param dataList 数据列表
     */
    fun addDataAll(dataList: List<M>?) {
        if (dataList == null || dataList.isEmpty()) {
            Timber.w("数据列表为null或者为空，不添加")
            return
        }
        items.addAll(dataList)
        notifyDataSetChanged()
    }

    /**
     * 追加数据到列表末尾，不刷新
     */
    fun addDataNoRefresh(dataList: List<M>?) {
        if (dataList == null || dataList.isEmpty()) {
            Timber.w("数据列表为null或者为空，不添加")
            return
        }
        items.addAll(dataList)
    }

    /**
     * 移除指定位置元素并返回该元素，局部刷新
     * @param position 位置
     * @return 返回被移除的元素
     */
    fun removeItem(position: Int): M? {
        if (position < 0 || position >= items.size) {
            Timber.w("非法位置：%d", position)
            return null
        }
        val item = items.removeAt(position)
        // 通知数据移除
        notifyItemRemoved(position)
        // 刷新位置
        notifyItemRangeChanged(position, items.size - position)
        return item
    }

    /**
     * 移除指定位置元素，局部刷新
     */
    fun removeItemNoReturn(position: Int) {
        if (position < 0 || position >= itemCount) {
            Timber.w("非法位置：%d", position)
            return
        }
        items.removeAt(position)
        // 通知数据移除
        notifyItemRemoved(position)
        // 刷新位置
        notifyItemRangeChanged(position, items.size - position)
    }

    /**
     * 移除指定位置元素，局部刷新
     */
    fun removeItemNoReturnTwo(position: Int) {
        if (position < 0 || position >= itemCount) {
            Timber.w("非法位置：%d", position)
            return
        }
        items.removeAt(position)
        if (mLayoutType == LayoutType.CAN_UNFOLD && isUnFoldType == UnfoldType.JUST_TWO) {
            notifyItemInserted((position - 1).absoluteValue)
            notifyDataSetChanged()
        }  else {
            // 通知数据移除
            notifyItemRemoved(position)
            // 刷新位置
            notifyItemRangeChanged(position, items.size - position)
        }
    }

    /**
     * 移除指定位置元素，不刷新
     * @param position 位置
     * @return 返回被移除的元素
     */
    fun removeOne(position: Int) {
        if (position < 0 || position >= items.size) {
            Timber.w("非法位置：%d", position)
            return
        }
        items.removeAt(position)
    }

    /**
     * 添加数据到列表末尾，局部刷新
     * @param item 数据
     */
    fun addItem(item: M) {
        // 插入位置
        val position = itemCount
        // 插入数据
        items.add(item)
        // 通知数据插入
        notifyItemInserted(position)
    }

    /**
     * 添加数据到列表指定位置，局部刷新
     * @param item 数据
     * @param position 位置
     */
    fun addItem(item: M, position: Int) {
        if (position < 0 || position >= itemCount) {
            Timber.w("非法位置：%d", position)
            return
        }
        // 插入数据
        items.add(position, item)
        // 通知数据插入
        notifyItemInserted(position)
        // 刷新位置
        notifyItemRangeChanged(position, items.size - position)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): BaseViewHolder {
        //创建普通的item
        val binding: B = DataBindingUtil.inflate(
            LayoutInflater.from(parent.context),
            getLayoutResId(viewType),
            parent,
            false
        )
        return BaseViewHolder(binding.root)
    }

    override fun onBindViewHolder(holder: BaseViewHolder, position: Int) {
        if (items.size == 0) {
            val binding: B? = DataBindingUtil.getBinding(holder.itemView)
            onNullBindItem(
                holder,
                binding!!,
            )
            return
        }

        when (mLayoutType) {
            LayoutType.NULL -> {
            }
            LayoutType.NORMAL -> {
                val binding: B? = DataBindingUtil.getBinding(holder.itemView)
                onBindItem(holder, binding!!, items[position], position)
            }
            LayoutType.MAX_VALUE -> {
                val binding: B? = DataBindingUtil.getBinding(holder.itemView)
                onBindItem(
                    holder,
                    binding!!,
                    items[position % items.size],
                    position % items.size
                )
            }
            LayoutType.CAN_UNFOLD -> {
                val binding: B? = DataBindingUtil.getBinding(holder.itemView)
                when(isUnFoldType) {
                    UnfoldType.JUST_TWO -> {
                        if (items.size - (1 + position) < 0) return
                        onBindItem(
                            holder,
                            binding!!,
                            items[items.size - (1 + position)],
                            items.size - (1 + position)
                        )
                    }
                    UnfoldType.UNFOLD -> onBindItem(holder, binding!!, items[position], position)
                }
            }
        }
    }

    /**
     * 数据绑定
     */
    abstract fun onBindItem(holder: BaseViewHolder, binding: B, item: M, position: Int)

    /**
     * 如果有空数据不得不执行的时候
     */
    open fun onNullBindItem(holder: BaseViewHolder, binding: B) {}

    /**
     * 获取布局ID
     * @param viewType 视图类型
     */
    @LayoutRes
    abstract fun getLayoutResId(viewType: Int): Int

    /**
     * ViewHolder
     */
    class BaseViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView)

    /**
     * 设置布局类型
     */
    open fun setLayoutType(): LayoutType = LayoutType.NORMAL

    //布局类型
    private val mLayoutType: LayoutType
        get() = setLayoutType()

    //可展开列表类型
    var isUnFoldType: UnfoldType = UnfoldType.JUST_TWO

    /**
     * 列表展开
     */
    fun recyclerAnimation(recyclerView: RecyclerView) {
        //设置为展开
        isUnFoldType = UnfoldType.UNFOLD
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
     * 列表展开
     * 并刷新前两行数据
     * 这里需要暂停一下让前两行数据刷新完先
     */
    suspend fun recyclerAnimationRefreshTwo(recyclerView: RecyclerView) {
        //设置为展开
        isUnFoldType = UnfoldType.UNFOLD
        //刷新前两行数据后再测量height
        notifyItemRangeChanged(0, 2)
        delay(500)
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
     * 动画展开(折叠)控件
     */
    private fun View.animationUpdate(start: Int, end: Int) {
        val lp = this.layoutParams
        this.visible()
        val animator = ValueAnimator.ofInt(start, end)
        animator.addUpdateListener {
            lp.height = it.animatedValue as Int
            this.layoutParams = lp
        }
        animator.start()
    }

    /**
     * 列表折叠
     */
    fun recyclerFoldAnimation(recyclerView: RecyclerView) {
        //设置为折叠
        isUnFoldType = UnfoldType.JUST_TWO
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
        recyclerView.animationUpdate(height - measuredHeight, 0)
    }

    enum class LayoutType {
        //空布局
        NULL,

        //正常的
        NORMAL,

        //无限
        MAX_VALUE,

        //能展开的
        CAN_UNFOLD,
    }

    enum class UnfoldType {
        //只有两条数据
        JUST_TWO,
        //展开
        UNFOLD,
    }

}
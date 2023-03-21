package com.tuanliu.common.base

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.annotation.LayoutRes
import androidx.databinding.DataBindingUtil
import androidx.databinding.ViewDataBinding
import androidx.recyclerview.widget.RecyclerView
import com.tuanliu.common.R
import com.tuanliu.common.databinding.LayoutEmptyVerticalBinding
import timber.log.Timber

/**
 * RecycleViewAdapter 基类
 * [showEmptyView] 是否显示空布局，默认不显示
 * [showAddOneView] 是否显示多一个布局,默认不显示
 * [refreshBtnShow] 空布局的刷新按钮是否显示,默认不显示
 * [refreshBtnOnClick] 空布局的刷新按钮点击事件
 */
abstract class BaseRvAdapter<M, B : ViewDataBinding>(
    //是否显示多一个布局,默认不显示
    val showAddOneView: Boolean = false,
    //空布局的刷新按钮是否显示,默认不显示
    val refreshBtnShow: Boolean = false,
    //空布局的布局
    val refreshLayout: Int = R.layout.layout_empty_vertical,
    //空布局的刷新按钮点击事件
    val refreshBtnOnClick: (() -> Unit)? = null
) :
    RecyclerView.Adapter<BaseRvAdapter.BaseViewHolder>() {

    //是否显示空布局
    private var showEmptyView: Boolean = false

    private val layoutId: Int
        get() = refreshLayout

    /**
     * 列表数据源
     */
    private var items: MutableList<M> = ArrayList()

    override fun getItemCount(): Int {
        //如果没有数据就显示空布局返回1
        return when {
            items.size > 0 && !showAddOneView -> items.size
            //显示空布局
            showEmptyView -> 1
            //显示多一个空白布局 这里最多显示9张图片
            showAddOneView -> if (items.size >= 9) 9 else items.size + 1
            else -> 0
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
     * 设置为空布局
     */
    fun setEmpty() {
        items.clear()
        showEmptyView = true
        //全部刷新
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
     * 刷新position位置的数据
     * 局部刷新
     */
    fun setReplace(position: Int) {
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
     * 移除指定位置元素并返回该元素，局部刷新
     * @param position 位置
     * @return 返回被移除的元素
     */
    fun removeItem(position: Int): M? {
        if (position < 0 || position >= itemCount) {
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
     * 移除指定位置元素并返回该元素，不刷新
     * @param position 位置
     * @return 返回被移除的元素
     */
    fun removeOne(position: Int) {
        if (position < 0 || position >= itemCount) {
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

    /**
     * 添加数据到列表指定位置，全局刷新
     */
    fun addItemAll(item: M, position: Int) {
        if (position < 0 || position >= itemCount) {
            Timber.w("非法位置：%d", position)
            return
        }
        // 插入数据
        items.add(position, item)
        // 通知数据插入
        notifyItemInserted(position)
    }

    private var isReEndTwo = false
    /**
     * 刷新最后两项数据
     * 这里执行一次，用于瀑布流列表
     */
    fun refreshEndTwo() {
        if (items.size > 2 && !isReEndTwo) {
            isReEndTwo = true
            notifyItemRangeChanged(items.size - 1, items.size)
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): BaseViewHolder {
        return if (viewType == TYPE_EMPTY) {
            //创建空布局item 横向的布局layout_empty_horizontal
            val binding: LayoutEmptyVerticalBinding =
                DataBindingUtil.inflate(
                    LayoutInflater.from(parent.context),
                    layoutId,
                    parent,
                    false
                )
            BaseViewHolder(binding.root)
        } else {
            //创建普通的item
            val binding: B = DataBindingUtil.inflate(
                LayoutInflater.from(parent.context),
                getLayoutResId(viewType),
                parent,
                false
            )
            BaseViewHolder(binding.root)
        }
    }

    override fun onBindViewHolder(holder: BaseViewHolder, position: Int) {
        if (!isEmptyPosition(position)) {
            if (showAddOneView && position == items.size) {
                //多出来的那个Item,绑定的是onBindItemAddOneView的数据
                val binding: B? = DataBindingUtil.getBinding(holder.itemView)
                onBindItemAddOneView(binding, null, position)
            } else {
                val binding: B? = DataBindingUtil.getBinding(holder.itemView)
                onBindItem(holder, binding!!, items[position], position)
            }
        } else {
            //如果是空布局item
            val binding: LayoutEmptyVerticalBinding? = DataBindingUtil.getBinding(holder.itemView)
            binding?.apply {
                if (refreshBtnShow) {
                    ButtonA.visibility = View.VISIBLE
                    if (refreshBtnOnClick != null) {
                        //"点击重试"点击事件
                        ButtonA.setOnClickListener {
                            refreshBtnOnClick?.let { it1 -> it1() }
                        }
                    }
                } else ButtonA.visibility = View.GONE
            }
            showEmptyView = false
        }
    }

    /**
     * 数据绑定
     */
    abstract fun onBindItem(holder: BaseViewHolder, binding: B, item: M, position: Int)

    /**
     * 数据绑定 多出来的那个Item
     */
    open fun onBindItemAddOneView(binding: B?, item: M?, position: Int) {}

    /**
     * 获取布局ID
     * @param viewType 视图类型
     */
    @LayoutRes
    abstract fun getLayoutResId(viewType: Int): Int

    override fun getItemViewType(position: Int): Int {
        return if (isEmptyPosition(position)) {
            //空布局
            TYPE_EMPTY
        } else {
            TYPE_ITEM
        }
    }

    /**
     * 判断是否是空布局
     */
    open fun isEmptyPosition(position: Int): Boolean {
        val count = items.size
        return position == 0 && showEmptyView && count == 0
    }

    /**
     * ViewHolder
     */
    class BaseViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView)

    companion object {
        const val TYPE_EMPTY = 2
        const val TYPE_ITEM = 1
    }

}
package com.tuanliu.common.base

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.annotation.LayoutRes
import androidx.databinding.DataBindingUtil
import androidx.databinding.ViewDataBinding
import androidx.recyclerview.widget.RecyclerView
import timber.log.Timber

/**
 * RecycleViewAdapter 带头部的基类
 * [H] 头部的布局
 * [D] 头部布局的数据
 */
abstract class BaseHeaderAdapter<M, B : ViewDataBinding, D, H : ViewDataBinding>(
    //是否显示头部,默认不显示
    private val showHeaderLayout: Boolean = false
) :
    RecyclerView.Adapter<BaseHeaderAdapter.BaseViewHolder>() {

    /**
     * 列表数据源
     */
    private var items: MutableList<M> = ArrayList()

    private var headerData: D? = null

    override fun getItemCount(): Int {
        //如果没有数据就显示空布局返回1
        return when {
            items.size > 0 && !showHeaderLayout -> items.size
            items.size > 0 && showHeaderLayout -> items.size + 1
            else -> 0
        }
    }

    fun getItems(): List<M> {
        return items
    }

    /**
     * 设置数据，触发全局刷新
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
     * 设置为空布局
     */
    fun setEmpty() {
        items.clear()
        //全部刷新
        notifyDataSetChanged()
    }

    /**
     * 设置头部数据，触发全局刷新
     */
    fun setHeadData(data: D?) {
        headerData = data
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

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): BaseViewHolder {
        return when (viewType) {
            IS_HEADER -> {
                //创建头部的item
                val binding: H = DataBindingUtil.inflate(
                    LayoutInflater.from(parent.context),
                    getLayoutResId(viewType),
                    parent,
                    false
                )
                BaseViewHolder(binding.root)
            }
            else -> {
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
    }

    override fun onBindViewHolder(holder: BaseViewHolder, position: Int) {
        when(holder.itemViewType) {
            IS_HEADER -> {
                val binding: H? = DataBindingUtil.getBinding(holder.itemView)
                onBindHeaderItem(holder, binding!!, headerData!!)
            }
            NO_HEADER -> {
                val binding: B? = DataBindingUtil.getBinding(holder.itemView)
                onBindItem(holder, binding!!, items[position - 1], position)
            }
            NOT_HEADER -> {
                val binding: B? = DataBindingUtil.getBinding(holder.itemView)
                onBindItem(holder, binding!!, items[position], position)
            }
        }
    }

    /**
     * 数据绑定
     */
    abstract fun onBindItem(holder: BaseViewHolder, binding: B, item: M, position: Int)

    open fun onBindHeaderItem(holder: BaseViewHolder, binding: H, item: D) {}

    /**
     * 获取布局ID
     * @param viewType 视图类型
     */
    @LayoutRes
    abstract fun getLayoutResId(viewType: Int): Int

    override fun getItemViewType(position: Int): Int {
        return when(showHeaderLayout) {
            true -> {
                if (headerData == null) {
                    return NOT_HEADER
                } else {
                    if (position == 0) IS_HEADER
                    else NO_HEADER
                }
            }
            false -> NOT_HEADER
        }
    }


    /**
     * ViewHolder
     */
    class BaseViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView)

    companion object {
        /**
         * 头部
         */
        const val IS_HEADER = 0

        /**
         * 不是头部
         */
        const val NO_HEADER = 1

        /**
         * 没有头部
         */
        const val NOT_HEADER = 2
    }

}
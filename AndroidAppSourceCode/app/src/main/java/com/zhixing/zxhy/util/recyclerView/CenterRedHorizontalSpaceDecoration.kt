package com.zhixing.zxhy.util.recyclerView

import android.graphics.Rect
import android.view.View
import androidx.recyclerview.widget.RecyclerView

/**
 * 横向红点列表的间隔设置
 */
class CenterRedHorizontalSpaceDecoration(
    //item总个数
    val mTotalCount: Int,
    //RecyclerView的宽度
    val mTotalWidth: Int,
    //单个item的宽度
    val mItemWidth: Int,
    //间距
    val mSpace: Int
) : RecyclerView.ItemDecoration() {

    override fun getItemOffsets(
        outRect: Rect,
        view: View,
        parent: RecyclerView,
        state: RecyclerView.State
    ) {
        val position = parent.getChildAdapterPosition(view)

        if (position == 0 || position == mTotalCount) {
            //左边或右边的间隔
            val space =
                (mTotalWidth - ((mTotalCount - 1) * mSpace) - (mItemWidth * mTotalCount)) / 2
            when (position) {
                0 -> {
                    outRect.left = space
                    outRect.right = mSpace
                }
                mTotalCount -> outRect.right = space
            }
        } else outRect.right = mSpace
    }
}
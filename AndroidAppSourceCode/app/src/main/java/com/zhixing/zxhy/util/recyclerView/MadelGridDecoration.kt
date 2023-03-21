package com.zhixing.zxhy.util.recyclerView

import android.graphics.Rect
import android.view.View
import androidx.recyclerview.widget.RecyclerView
import com.tuanliu.common.ext.dp2Pix

/**
 * 成就列表的Decoration
 * 平分宽度的间距
 */
class MadelGridDecoration(
    //一行多少个元素
    val mTotalCount: Int,
    //RecyclerView的宽度
    val mTotalWidth: Int,
    //每个item的宽度
    val mItemWidth: Int,
    //顶部间隔
    val topMargin: Float = 0f
): RecyclerView.ItemDecoration() {

    override fun getItemOffsets(
        outRect: Rect,
        view: View,
        parent: RecyclerView,
        state: RecyclerView.State
    ) {

        val position = parent.getChildAdapterPosition(view)

        //每个元素都需要设置的间距
        val space = (mTotalWidth - (mTotalCount * mItemWidth)) / (mTotalCount * 2)

        outRect.left = space
        outRect.right = space

        //第二行开始有顶部padding  position从0开始
        if (position >= mTotalCount) {
            outRect.top = dp2Pix(view.context, topMargin)
        }

    }

}
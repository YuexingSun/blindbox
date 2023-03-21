package com.zhixing.zxhy.util.recyclerView

import android.graphics.Rect
import android.view.View
import androidx.recyclerview.widget.RecyclerView

/**
 * GridLayoutManager（网格布局）设置item的间隔
 */
class GridSpacingItemDecoration() : RecyclerView.ItemDecoration() {

    //列数
    private var spanCount = 0

    //间隔
    private var spacing = 0

    //是否包含边缘
    private var includeEdge = false

    constructor(spanCount: Int, spacing: Int, includeEdge: Boolean) : this() {
        this.spanCount = spanCount
        this.spacing = spacing
        this.includeEdge = includeEdge
    }

    override fun getItemOffsets(
        outRect: Rect,
        view: View,
        parent: RecyclerView,
        state: RecyclerView.State
    ) {
        super.getItemOffsets(outRect, view, parent, state)
        //这里是关键，需要根据你有几列来判断
        val position = parent.getChildAdapterPosition(view) // item position
        val column = position % spanCount // item column
        if (includeEdge) {
            outRect.left =
                spacing - column * spacing / spanCount // spacing - column * ((1f / spanCount) * spacing)
            outRect.right =
                (column + 1) * spacing / spanCount // (column + 1) * ((1f / spanCount) * spacing)
            if (position < spanCount) { // top edge
                outRect.top = spacing
            }
            outRect.bottom = spacing // item bottom
        } else {
            // column * ((1f / spanCount) * spacing)
            outRect.left = column * spacing / spanCount
            // spacing - (column + 1) * ((1f /    spanCount) * spacing)
            outRect.right = spacing - (column + 1) * spacing / spanCount
            // item top
//            if (position >= spanCount) {
//                outRect.top = spacing
//            }
        }
    }

}
import android.content.Context
import android.util.AttributeSet
import androidx.recyclerview.widget.RecyclerView
import androidx.recyclerview.widget.RecyclerView.Recycler
import androidx.recyclerview.widget.StaggeredGridLayoutManager
import java.lang.Exception

/**
 * 重写 StaggeredGridLayoutManager 解决崩溃的情况
 * Google背锅
 */
open class ExpandStaggeredManager : StaggeredGridLayoutManager {

    constructor(
        context: Context?,
        attrs: AttributeSet?,
        defStyleAttr: Int,
        defStyleRes: Int
    ) : super(context, attrs, defStyleAttr, defStyleRes) {
    }

    constructor(spanCount: Int, orientation: Int) : super(spanCount, orientation)

    override fun onLayoutChildren(recycler: Recycler, state: RecyclerView.State) {
        try {
            super.onLayoutChildren(recycler, state)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    /**
     * 通过 try catch 捕捉错误
     */
    override fun onScrollStateChanged(state: Int) {
        try {
            super.onScrollStateChanged(state)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
}
package org.flower.l.library.layout

import android.content.Context
import android.content.res.TypedArray
import android.graphics.drawable.Drawable
import android.util.AttributeSet
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.TextView
import androidx.annotation.DrawableRes
import androidx.annotation.RawRes
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.core.content.ContextCompat
import androidx.core.view.isGone
import androidx.core.view.isVisible
import com.airbnb.lottie.LottieAnimationView
import org.flower.l.library.R

/**
 * 状态布局(加载中/网络错误/异常错误/空数据)
 */
class StatusLayout @JvmOverloads constructor(
    context: Context,
    attrs: AttributeSet?,
    defStyleAttr: Int = 0
) :
    ConstraintLayout(context, attrs, defStyleAttr) {

    private var mainLayout: ViewGroup =
        LayoutInflater.from(context).inflate(R.layout.layout_status, this, false) as ViewGroup

    private var lottieView: LottieAnimationView = mainLayout.findViewById(R.id.iv_status_icon)

    private var textView: TextView = mainLayout.findViewById(R.id.iv_status_text)

    private var retryView: Button = mainLayout.findViewById(R.id.iv_status_retry)

    //重试按钮点击事件
    var listener: (() -> Unit)? = null
        set(value) {
            if (value != null) {
                retryView.setOnClickListener {
                    value()
                }
            }
            field = value
        }

    init {
        if (mainLayout.background == null) {
            // 默认使用 windowBackground 作为背景
            val typedArray: TypedArray =
                context.obtainStyledAttributes(intArrayOf(android.R.attr.windowBackground))
            mainLayout.background = typedArray.getDrawable(0)
            typedArray.recycle()
        }
        addView(mainLayout)
    }

    /**
     * 显示加载中布局
     * @param id Int 动画资源id
     */
    fun showLoading(@RawRes id: Int = R.raw.loading) {
        show()
        setAnimaResource(id)
        textView.text = ""
        if (textView.isVisible) textView.visibility = View.GONE
        if (retryView.isVisible) retryView.visibility = View.GONE
    }

    /**
     * 显示加载完成布局(隐藏这个页面)
     */
    fun showComplete() {
        hide()
    }

    /**
     * 显示空布局
     */
    fun showEmpty(str: String = "空空如也") {
        show()
        setIcon(R.drawable.ic_status_empty)
        textView.text = str
        if (textView.isGone) textView.visibility = View.VISIBLE
        if (listener != null && retryView.isGone) retryView.visibility = View.VISIBLE
    }

    /**
     * 显示网络错误布局
     */
    fun showError(str: String = "网络错误，请重试") {
        show()
        setIcon(R.drawable.ic_status_network)
        textView.text = str
        if (textView.isGone) textView.visibility = View.VISIBLE
        if (listener != null && retryView.isGone) retryView.visibility = View.VISIBLE
    }

    /**
     * 显示
     */
    private fun show() {
        if (mainLayout.isShown) return
        mainLayout.visibility = View.VISIBLE
    }

    /**
     * 隐藏
     */
    private fun hide() {
        if (!mainLayout.isShown) return
        mainLayout.visibility = View.INVISIBLE
    }

    private fun setIcon(@DrawableRes id: Int) {
        setIcon(ContextCompat.getDrawable(context, id))
    }

    private fun setIcon(drawable: Drawable?) {
        lottieView.apply {
            if (isAnimating) cancelAnimation()
            setImageDrawable(drawable)
        }
    }

    /**
     * 设置动画
     * @param id Int
     */
    private fun setAnimaResource(@RawRes id: Int) {
        lottieView.apply {
            setAnimation(id)
            if (!isAnimating) playAnimation()
        }
    }

}
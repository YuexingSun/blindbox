package com.tuanliu.common.customView

import android.content.Context
import android.util.AttributeSet
import android.view.LayoutInflater
import android.view.View
import android.widget.FrameLayout
import androidx.annotation.ColorRes
import androidx.appcompat.widget.AppCompatTextView
import androidx.appcompat.widget.Toolbar
import androidx.core.content.ContextCompat
import com.tuanliu.common.R
import com.tuanliu.common.ext.getResColor

/**
 * 一个toolbar 然后中间放了一个文字
 */
class CustomToolBar : FrameLayout {

    private lateinit var toolBar: Toolbar
    private lateinit var toolBarTitle: AppCompatTextView
    private lateinit var toolBarImage: AppCompatTextView
    private lateinit var toolbarText: AppCompatTextView

    constructor(context: Context) : super(context)

    constructor(context: Context, attrs: AttributeSet) : super(context, attrs) {
        init(context, attrs)
    }

    constructor(context: Context, attrs: AttributeSet, defStyleAttr: Int) : super(
        context,
        attrs,
        defStyleAttr
    ) {
        init(context, attrs)
    }

    private fun init(context: Context, attrs: AttributeSet) {
        val view = LayoutInflater.from(context).inflate(R.layout.toolbar_layout_custom, this)
        toolBar = view.findViewById(R.id.toolBar)
        toolBar.title = ""
        toolBarTitle = view.findViewById(R.id.toolbarTitle)
        toolBarImage = view.findViewById(R.id.toolbarImage)
        toolbarText = view.findViewById(R.id.toolbarText)
    }

    fun setCenterTitle(titleStr: String) {
        toolBarTitle.text = titleStr
    }

    fun setCenterTitle(titleResId: Int) {
        toolBarTitle.text = context.getString(titleResId)
    }

    fun setCenterTitleColor(colorResId: Int) {
        toolBarTitle.setTextColor(colorResId)
    }


    fun getBaseToolBar(): Toolbar {
        return toolBar
    }

    fun setEndImage(drawableImage: Int?) {
        drawableImage?.let {
            toolBarImage.visibility = View.VISIBLE
            toolBarImage.setBackgroundResource(drawableImage)
        }
    }

    fun setEndTextTitle(str: String?) {
        str?.let {
            toolbarText.visibility = View.VISIBLE
            toolbarText.text = str
        }
    }

    /**
     * 设置颜色
     */
    fun setEndTextColor(@ColorRes color: Int) {
        toolbarText.setTextColor(context.getResColor(color))
    }

    /**
     * 右边按钮点击事件
     */
    fun setEndTextListener(listener: () -> Unit) {
        toolbarText.setOnClickListener {
            listener()
        }
    }

}

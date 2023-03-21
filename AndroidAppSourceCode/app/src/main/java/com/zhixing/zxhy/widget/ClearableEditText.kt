package com.zhixing.zxhy.widget

import android.content.Context
import android.graphics.drawable.Drawable
import android.text.Editable
import android.text.TextWatcher
import android.util.AttributeSet
import android.view.MotionEvent
import android.view.View
import android.view.View.OnFocusChangeListener
import android.view.View.OnTouchListener
import androidx.appcompat.widget.AppCompatEditText
import androidx.core.content.ContextCompat
import androidx.core.graphics.drawable.DrawableCompat
import com.tuanliu.common.ext.dp2Pix
import com.zhixing.zxhy.R


/**
 * 自定义的 带清除按钮的EditText
 */
class ClearableEditText : AppCompatEditText, OnTouchListener, OnFocusChangeListener, TextWatcher {
    private var clearTextIcon: Drawable? = null
    private var mOnFocusChangeListener: OnFocusChangeListener? = null
    private var mOnTouchListener: OnTouchListener? = null

    @get:Synchronized
    @set:Synchronized
    var isCanClear = false

    constructor(context: Context) : super(context) {
        init(context)
    }

    constructor(context: Context, attrs: AttributeSet?) : super(context, attrs) {
        init(context, attrs)
    }

    constructor(
        context: Context, attrs: AttributeSet?,
        defStyleAttr: Int
    ) : super(context, attrs, defStyleAttr) {
        init(context, attrs, defStyleAttr)
    }

    override fun setOnFocusChangeListener(onFocusChangeListener: OnFocusChangeListener) {
        mOnFocusChangeListener = onFocusChangeListener
    }

    override fun setOnTouchListener(onTouchListener: OnTouchListener) {
        mOnTouchListener = onTouchListener
    }

    private fun init(context: Context, attrs: AttributeSet? = null, defStyleAttr: Int = 0) {
        val typeArray = context.obtainStyledAttributes(attrs, R.styleable.ClearableEditText)

        //清除按钮样式
        val clearIcon = typeArray.getResourceId(R.styleable.ClearableEditText_clearIcon, R.mipmap.ic_edittext_close)
        val drawable = ContextCompat.getDrawable(context, clearIcon)
        val wrappedDrawable = DrawableCompat.wrap(drawable!!)

        val clearIconHeight = typeArray.getDimension(R.styleable.ClearableEditText_clearIconHeight, dp2Pix(context, 14f).toFloat())
        val clearIconWidth = typeArray.getDimension(R.styleable.ClearableEditText_clearIconWidth, dp2Pix(context, 14f).toFloat())

        clearTextIcon = wrappedDrawable
        //关闭图标的width和height
        clearTextIcon!!.setBounds(
            0, 0, clearIconHeight.toInt(),
            clearIconWidth.toInt()
        )
        setClearIconVisible(false)
        super.setOnTouchListener(this)
        super.setOnFocusChangeListener(this)
        addTextChangedListener(this)
        typeArray.recycle()
    }

    override fun onFocusChange(view: View, hasFocus: Boolean) {
        if (hasFocus) {
            setClearIconVisible(text!!.isNotEmpty())
        } else {
            setClearIconVisible(false)
            isCanClear = true
        }
        if (mOnFocusChangeListener != null) {
            mOnFocusChangeListener!!.onFocusChange(view, hasFocus)
        }
    }

    override fun onTouch(view: View, motionEvent: MotionEvent): Boolean {
        val x = motionEvent.x.toInt()
        return if (x > width - paddingRight - clearTextIcon!!.intrinsicWidth) {
            if (motionEvent.action == MotionEvent.ACTION_DOWN) {
                if (clearTextIcon!!.isVisible) {
                    error = null
                    setText("")
                } else if (isCanClear) {
                    isCanClear = false
                    error = null
                    setText("")
                }
            }
            true
        } else {
            mOnTouchListener != null && mOnTouchListener!!.onTouch(
                view,
                motionEvent
            )
        }
    }

    override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {
        if (isFocused) {
            setClearIconVisible(s.isNotEmpty())
        }
    }

    override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {}
    override fun afterTextChanged(s: Editable) {}
    private fun setClearIconVisible(visible: Boolean) {
        clearTextIcon!!.setVisible(visible, false)
        val compoundDrawables = compoundDrawables
        setCompoundDrawables(
            compoundDrawables[0],
            compoundDrawables[1],
            if (visible) clearTextIcon else null,
            compoundDrawables[3]
        )
    }
}
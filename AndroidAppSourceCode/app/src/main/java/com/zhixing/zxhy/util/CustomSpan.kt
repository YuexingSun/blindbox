package com.zhixing.zxhy.util

import android.content.Context
import android.graphics.Canvas
import android.graphics.Paint
import android.graphics.Rect
import android.text.style.ImageSpan
import androidx.core.content.ContextCompat
import com.tuanliu.common.ext.dp
import com.tuanliu.common.ext.sp2px

/**
 * 图片适应文本行高度
 */
class CustomSpan constructor(
    val context: Context,
    private val emojiFace: EmojiFace,
    private val textSize: Float
) : ImageSpan(context, emojiFace.id) {

    lateinit var rect: Rect

    private val drawable1 by lazy {
        ContextCompat.getDrawable(context, emojiFace.id)
    }

    override fun getSize(
        paint: Paint,
        text: CharSequence?,
        start: Int,
        end: Int,
        fm: Paint.FontMetricsInt?
    ): Int {
        rect = Rect(2.dp, 2.dp, sp2px(textSize + emojiFace.addWidth), sp2px(textSize + emojiFace.addHeight))
        return rect.right
    }

    override fun draw(
        canvas: Canvas,
        text: CharSequence?,
        start: Int,
        end: Int,
        x: Float,
        top: Int,
        y: Int,
        bottom: Int,
        paint: Paint
    ) {

        val b = drawable

        canvas.save()

        val transY = ((bottom - top) - ((b?.bounds?.bottom ?: 0) / 2) + top)

        canvas.translate(x, transY.toFloat())

        drawable1?.apply {
            bounds = rect
            draw(canvas)
        }

//        canvas.translate(rect.right / 2.0f, rect.bottom / 2.0f)

        canvas.restore()
    }

}
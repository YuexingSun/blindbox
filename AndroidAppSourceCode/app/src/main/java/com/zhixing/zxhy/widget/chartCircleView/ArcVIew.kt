package com.zhixing.zxhy.widget.chartCircleView

import android.animation.ValueAnimator
import android.content.Context
import android.graphics.*
import android.util.AttributeSet
import android.util.Log
import android.view.View
import android.view.animation.LinearInterpolator
import com.hjq.toast.ToastUtils
import com.tuanliu.common.ext.dp
import com.tuanliu.common.ext.getResColor
import com.zhixing.zxhy.R

/**
 * 圆环统计图
 */
class ArcVIew : View {

    private lateinit var arcPaint: Paint
    private lateinit var textPaint: Paint
    private lateinit var textPaintA: Paint
    private val rectF = RectF()

    private val mStrokeWidth = 10
        get() = field.dp

    //绘画的进度
    private var precent: Float = 1.0f

    private var startAngle: Int = -90

    //控件宽度
    private var mWidth: Int = 0

    //控件高度
    private var mHeight: Int = 0

    //数据
    private var items: ArrayList<ChartCircleItem> = arrayListOf()

    //值的总和
    private var maxValue: Int = 0

    //圆的半径
    private var mRadius: Float = 0f

    //有多少可用的数据（不等于0的数据）
    private var usableListData = 0

    constructor(context: Context) : this(context, null)

    constructor(context: Context, attr: AttributeSet?) : this(context, attr, 0)

    constructor(context: Context, attr: AttributeSet?, defStyleAttr: Int) : super(
        context,
        attr,
        defStyleAttr
    ) {
        initPaint()
    }

    fun setItems(array: ArrayList<ChartCircleItem>) {
        items.clear()
        items.addAll(array)
        //记录有多少可用的数据
        usableListData = 0
        items.forEach {
            if (it.value > 0) usableListData++
        }

        if (mWidth != 0) {
            maxValue = 0
            calculateMax()
        }
        startAnim()
    }

    private fun initPaint() {
        arcPaint = Paint().apply {
            isAntiAlias = true
            //绘制轮廓
            style = Paint.Style.STROKE
//            strokeCap = Paint.Cap.ROUND
        }
        textPaint = Paint().apply {
            isAntiAlias = true
            color = context.getResColor(R.color.c_9)
            textSize = 13f.dp
            style = Paint.Style.FILL
            textAlign = Paint.Align.CENTER
        }
        textPaintA = Paint().apply {
            isAntiAlias = true
            color = context.getResColor(R.color.c_4)
            textSize = 28f.dp
            style = Paint.Style.FILL
            typeface = Typeface.DEFAULT_BOLD
            textAlign = Paint.Align.CENTER
        }
    }

    override fun onLayout(changed: Boolean, left: Int, top: Int, right: Int, bottom: Int) {
        super.onLayout(changed, left, top, right, bottom)
        if (changed) {
            mWidth = width
            mHeight = height
            //圆的边距
            val mMargin = (mStrokeWidth / 1.6).toFloat().dp
            val minLength = if (mWidth >= mHeight) mHeight else mWidth
            //圆的半径
            mRadius = minLength / 2 - mMargin
            calculateMax()
        }
    }

    private var amsAngle = 0f
    private var realWidth: Double = 0.0
    override fun onDraw(canvas: Canvas?) {
        super.onDraw(canvas)
        if (width == 0) return

        //没有开过盒子的情况
        if (maxValue == 0) {
            arcPaint.color = context.getResColor(R.color.c_F299F2)
            //画笔宽度
            arcPaint.strokeWidth = ((mStrokeWidth * 0.33) + mStrokeWidth).toFloat()

            rectF.set(
                width / 2 - mRadius,
                height / 2 - mRadius,
                width / 2 + mRadius,
                height / 2 + mRadius
            )
            canvas?.drawArc(
                rectF,
                0f,
                380f * precent,
                false,
                arcPaint
            )
        }

        //当前累积的角度
        amsAngle = 0f
        items.forEachIndexed { index, item ->

            //中断本次循环
            if (item.value == 0) return@forEachIndexed

            arcPaint.color = context.getResColor(item.color)

            realWidth = mStrokeWidth * 0.33 * index

            //画笔宽度
            arcPaint.strokeWidth = (realWidth + mStrokeWidth).toFloat()
            val currentAngle = item.value * 360f / maxValue - 1.dp

            rectF.set(
                (width / 2 - mRadius - (realWidth / 2)).toFloat(),
                (height / 2 - mRadius - (realWidth / 2)).toFloat(),
                (width / 2 + mRadius + (realWidth / 2)).toFloat(),
                (height / 2 + mRadius + (realWidth / 2)).toFloat()
            )

            canvas?.apply {
                //如果只有一个可用的数据，画一个圆就可以了
                if (usableListData <= 1) {
                    drawArc(
                        rectF,
                        0f + startAngle,
                        (360f - startAngle) * precent,
                        false,
                        arcPaint
                    )
                } else {
                    //这里跟线的strokeWidth有关，因为最后会加多一个半圆，这个半圆的长度跟描线的宽度有关，不是固定大小
                    drawArc(
                        rectF,
                        amsAngle * precent + startAngle,
                        currentAngle * precent,
                        false,
                        arcPaint
                    )
                }

                amsAngle += currentAngle + 1.dp
            }
        }

        //进度条绘制完之后才绘制文字
        if (precent == 1.0f) {
            //绘制文字
            val fontMetrics = textPaint.fontMetrics
            val top = fontMetrics.top
            val basLineY = (height + top) / 2 - 2.dp
            canvas?.drawText("开盒", (width / 2).toFloat(), basLineY, textPaint)

            val fontMetricsA = textPaintA.fontMetrics
            val topA = fontMetricsA.top
            val basLineYA = (height - topA) / 2 + 2.dp
            canvas?.drawText(maxValue.toString(), (width / 2).toFloat(), basLineYA, textPaintA)
        }
    }

    private fun startAnim() {
        ValueAnimator.ofFloat(0.0f, 1.0f).apply {
            duration = 500L
            interpolator = LinearInterpolator()
            addUpdateListener {
                precent = it.animatedValue as Float
                invalidate()
            }
            start()
        }
    }

    private fun calculateMax() {
        items.forEach {
            maxValue += it.value
        }
    }

}
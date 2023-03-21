package com.zhixing.zxhy.widget.chartCircleView

import android.animation.ValueAnimator
import android.annotation.SuppressLint
import android.content.Context
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.RectF
import android.util.AttributeSet
import android.util.Log
import android.view.View
import android.view.animation.LinearInterpolator
import androidx.annotation.ColorRes
import com.tuanliu.common.ext.dp2Pix
import com.tuanliu.common.ext.getResColor
import com.zhixing.zxhy.R

/**
 * 圆环统计控件
 */
@SuppressLint("Recycle")
class ChartCircleView : View {

    //背景颜色
    private var BgColor: Int
    //起始角度
    private var startAngle: Int
    //是否为扇形
    private var isArc: Boolean
    //动画时间
    private var cvAnimaDuration: Int
    //是否开启动画
    private var isAnim: Boolean
    //圆环比率，也可理解为圆环with比率
    private var circleRate: Float

    //画笔
    private lateinit var paint: Paint
    private lateinit var paintInner: Paint

    //控件宽度
    private var mWidth: Int = 0

    //控件高度
    private var mHeight: Int = 0
    private var mMargin10: Int = 0

    //圆的半径
    private var mRadius: Int = 0

    //内圆的半径，用于盖住
    private var mInnerRadius: Int = 0

    //画圆矩形的方法
    private lateinit var rectF: RectF

    //数据
    private var items: ArrayList<ChartCircleItem> = arrayListOf()

    //值的总和
    private var maxValue: Int = 0

    //绘画的进度
    private var precent: Float = 1.0f

    constructor(context: Context) : this(context, null)

    constructor(context: Context, attrs: AttributeSet?) : this(context, attrs, 0)

    constructor(context: Context, attrs: AttributeSet?, defStyleAttr: Int) : super(
        context,
        attrs,
        defStyleAttr
    ) {
        val typedArray = context.obtainStyledAttributes(attrs, R.styleable.ChartCircleView)
        BgColor = typedArray.getColor(
            R.styleable.ChartCircleView_cv_background,
            Color.parseColor("#ffffff")
        )
        startAngle = typedArray.getInt(R.styleable.ChartCircleView_cv_startAngle, -90)
        isArc = typedArray.getBoolean(R.styleable.ChartCircleView_cv_isArc, false)
        cvAnimaDuration = typedArray.getInt(R.styleable.ChartCircleView_cv_animDuration, 1000)
        isAnim = typedArray.getBoolean(R.styleable.ChartCircleView_cv_isAnim, true)
        circleRate = typedArray.getFloat(R.styleable.ChartCircleView_cv_rate, 0.68f)
        when {
            circleRate > 0.9f -> circleRate = 0.9f
            circleRate < 0f -> circleRate = 0f
        }
        typedArray.recycle()
        initPaint()
    }

    fun setItems(array: ArrayList<ChartCircleItem>) {
        items.clear()
        items.addAll(array)
        if (mWidth != 0) {
            maxValue = 0
            calculateMax()
        }
        isStartAnima()
    }

    private fun isStartAnima() {
        if (isAnim) startAnim()
        else invalidate()
    }

    /**
     * 初始化画笔
     */
    private fun initPaint() {
        paint = Paint().apply {
            //描边填充效果 1.STROKE 描边 2.FIll 填充 3.FILL_AND_STROKE 描边+填充
            style = Paint.Style.FILL
            //是否抗锯齿
            isAntiAlias = true
        }

        paintInner = Paint().apply {
            color = BgColor
            style = Paint.Style.FILL
            isAntiAlias = true
        }
    }

    override fun onLayout(changed: Boolean, left: Int, top: Int, right: Int, bottom: Int) {
        super.onLayout(changed, left, top, right, bottom)
        if (changed) {
            mWidth = width
            mHeight = height
            //圆的边距
            mMargin10 = dp2Pix(context, 10f)
            val minLength = if (mWidth >= mHeight) mHeight else mWidth
            //圆的半径
            mRadius = minLength / 2 - mMargin10 * 3
            calculateInnerRadius()
            //设置背景颜色
//            setBackgroundColor(BgColor)
            calculateMax()
        }
    }

    /**
     * 计算内部的圆心
     */
    private fun calculateInnerRadius() {
        mInnerRadius = (circleRate * mRadius).toInt()
    }

    /**
     * 计算值的总和
     */
    private fun calculateMax() {
        items.forEach {
            maxValue += it.value
        }
    }

    override fun onDraw(canvas: Canvas?) {
        super.onDraw(canvas)
        canvas?.let {
            drawBaseBackground(it)
        }
    }

    /**
     * 绘制基础背景图
     */
    private fun drawBaseBackground(canvas: Canvas) {
        //当前累积的角度
        var amssAngle: Int = 0
        items.forEachIndexed { index, item ->
            paint.color = context.getResColor(item.color)
            //当前需要占据的角度
            val currentAngle: Float = (item.value * 360 / maxValue).toFloat()
            rectF = RectF(
                (width / 2 - mRadius - index * 10).toFloat(),
                (height / 2 - mRadius - index * 10).toFloat(),
                (width / 2 + mRadius + index * 10).toFloat(),
                (height / 2 + mRadius + index * 10).toFloat()
            )
            //这里解决画圆不全的问题
            if (index == items.size - 1 && amssAngle + currentAngle.toInt() != 360) {
                //圆弧 起始角度 中止角度(顺时针) 在绘制圆弧时是否将圆心包括在内 画板属性
                canvas.drawArc(
                    rectF,
                    amssAngle * precent + startAngle + 10,
                    (360 - amssAngle) * precent - 10,
                    true,
                    paint
                )
            } else {
                canvas.drawArc(
                    rectF,
                    amssAngle * precent + startAngle + 10,
                    currentAngle * precent - 10,
                    true,
                    paint
                )
            }

            amssAngle += currentAngle.toInt()
        }

        if (!isArc) {
            canvas.drawCircle(
                (mWidth / 2).toFloat(),
                (mHeight / 2).toFloat(), mInnerRadius.toFloat(), paintInner
            )
        }
    }

    /**
     * 动画
     * 开始绘制
     */
    private fun startAnim() {
        val anim = ValueAnimator.ofFloat(0.0f, 1.0f).apply {
            duration = cvAnimaDuration.toLong()
            interpolator = LinearInterpolator()
            addUpdateListener {
                precent = it.animatedValue as Float
                invalidate()
            }
        }
        anim.start()
    }

}
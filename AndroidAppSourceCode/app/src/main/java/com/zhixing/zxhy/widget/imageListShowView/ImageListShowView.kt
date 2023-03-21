package com.zhixing.zxhy.widget.imageListShowView

import android.content.Context
import android.graphics.*
import android.util.AttributeSet
import android.view.View
import com.tuanliu.common.ext.dp2Pix
import com.tuanliu.common.ext.glideDefault
import com.zhixing.zxhy.R

/**
 * 图片宫格展示控件
 */
class ImageListShowView @JvmOverloads constructor(
    context: Context, attrs: AttributeSet? = null, defStyleAttr: Int = 0
) : View(context, attrs, defStyleAttr) {

    companion object {
        const val picA = "?x-oss-process=image/resize,m_fill,h_789,w_1053,limit_0"
        const val picB = "?x-oss-process=image/resize,m_fill,h_786,w_528,limit_0"
        const val picC = "?x-oss-process=image/resize,m_fill,h_387,w_519,limit_0"
        const val picD = "?x-oss-process=image/resize,m_fill,h_786,w_603,limit_0"
        const val picE = "?x-oss-process=image/resize,m_fill,h_252,w_438,limit_0"
        const val picF = "?x-oss-process=image/resize,m_fill,h_387,w_603,limit_0"
    }

    private lateinit var imagePaint: Paint
    private val rectF: RectF = RectF()
    private var dp2: Float = 0.0f
    private var dp4: Float = 0.0f
    private var dp8: Float = 0.0f
    private var dp150: Float = 0.0f

    //控件宽度
    private var mWidth: Int = 0

    //控件高度
    private var mHeight: Int = 0

    private val xfermode = PorterDuffXfermode(PorterDuff.Mode.SRC_IN)

    init {
        initStyle(context, attrs)
        initPaint()
        initDp()
    }

    //临时的list
    private val items: ArrayList<Bitmap> = arrayListOf()

    /**
     * 用来进行整理的数据
     */
    private val sortList = arrayListOf<Bitmap>()

    fun setItems(list: List<String>) {
        if (list.isEmpty()) return
        listToBitmap(ArrayList(list))
    }

    fun setItems(arrayList: ArrayList<String>) {
        if (arrayList.size == 0) return
        listToBitmap(arrayList)
    }

    /**
     * 链接转Bitmap
     */
    private fun listToBitmap(arrayList: ArrayList<String>) {
        items.clear()

        arrayList.forEachIndexed { index, s ->
            var str: String = s
            when (arrayList.size) {
                1 -> str = "${str}$picA"
                2 -> str = "${str}$picB"
                3 -> {
                    str = when (index) {
                        0 -> "${str}$picB"
                        else -> "${str}$picC"
                    }
                }
                4 -> {
                    str = when (index) {
                        0 -> "${str}$picD"
                        else -> "${str}$picE"
                    }
                }
                else -> {
                    str = when (index) {
                        1, 2 -> "${str}$picF"
                        else -> "${str}$picE"
                    }
                }
            }
            context.glideDefault(str) {
                items.add(it)

                if (index == arrayList.size - 1) {
                    invalidate()
                }
            }
        }
    }

    /**
     * 样式代码
     */
    private fun initStyle(context: Context, attrs: AttributeSet?) {
        val typeArray = context.obtainStyledAttributes(attrs, R.styleable.ImageListShowView)

        //背景
        setBackgroundColor(
            typeArray.getColor(
                R.styleable.ImageListShowView_imgShow_background,
                Color.parseColor("#ffffff")
            )
        )
        typeArray.recycle()
    }

    private fun initPaint() {
        setLayerType(LAYER_TYPE_HARDWARE, null)
        imagePaint = Paint().apply {
            isAntiAlias = true
            style = Paint.Style.FILL
            color = Color.WHITE
        }
    }

    /**
     * 初始化屏幕像素值
     */
    private fun initDp() {
        val ddp2 = dp2Pix(context, 2f).toFloat()
        dp2 = ddp2
        dp4 = ddp2 * 2
        dp8 = ddp2 * 4
        dp150 = ddp2 * 75
    }

    /**
     * 整理成合适的list
     */
    private fun picListSort(): ArrayList<Bitmap> {

        //这里倒序一下，尽量让数据的顺序正确
        items.reversed().forEachIndexed { _, bitmap ->
            when (items.size) {
                1 -> sortList.add(bitmap)
                2 -> sortList.add(bitmap)
                3 -> if (bitmap.height == 786) {
                    //添加到最前面
                    sortList.add(0, bitmap)
                } else sortList.add(bitmap)
                4 -> if (bitmap.height == 786) {
                    sortList.add(0, bitmap)
                } else sortList.add(bitmap)
                else -> if (bitmap.height == 387) {
                    sortList.add(0, bitmap)
                } else sortList.add(bitmap)
            }
        }
        items.clear()
        items.addAll(sortList)
        sortList.clear()

        return items
    }

    override fun onLayout(changed: Boolean, left: Int, top: Int, right: Int, bottom: Int) {
        super.onLayout(changed, left, top, right, bottom)
        if (changed) {
            mWidth = width
            mHeight = height
        }
    }

    override fun onDraw(canvas: Canvas?) {
        super.onDraw(canvas)
        if (mWidth == 0) return
        if (canvas == null) return

        //这里设置一个比控件更大的带圆角的图层，接着只保留重复的地方，以此来切出某些index的圆角
        canvas.drawRoundRect(
            0f, 0f, width.toFloat(), height.toFloat() + 20f,
            dp8,
            dp8,
            imagePaint
        )

        canvas.apply {
            picListSort().forEachIndexed { index, item ->
                imagePaint.xfermode = xfermode
                when (items.size) {
                    1 -> {
                        rectF.set(0f, 0f, mWidth.toFloat(), mHeight.toFloat())
                    }
                    2 -> {
                        when (index) {
                            0 -> rectF.set(
                                0f,
                                0f,
                                (mWidth / 2).toFloat() - dp2,
                                mHeight.toFloat()
                            )
                            1 -> rectF.set(
                                (mWidth / 2).toFloat() + dp2,
                                0f,
                                mWidth.toFloat(),
                                mHeight.toFloat()
                            )
                        }
                    }
                    3 -> {
                        when (index) {
                            0 -> rectF.set(
                                0f,
                                0f,
                                (mWidth / 2).toFloat() - dp2,
                                mHeight.toFloat()
                            )
                            1 -> rectF.set(
                                (mWidth / 2).toFloat() + dp2,
                                0f,
                                mWidth.toFloat(),
                                (mHeight / 2).toFloat() - dp2
                            )
                            2 -> rectF.set(
                                (mWidth / 2).toFloat() + dp2,
                                (mHeight / 2).toFloat() + dp2,
                                mWidth.toFloat(),
                                mHeight.toFloat()
                            )
                        }
                    }
                    4 -> {
                        when (index) {
                            0 -> rectF.set(
                                0f,
                                0f,
                                mWidth.toFloat() - dp150,
                                mHeight.toFloat()
                            )
                            1 -> rectF.set(
                                mWidth.toFloat() - dp150 + dp4,
                                0f,
                                mWidth.toFloat(),
                                (mHeight.toFloat() - dp8) / 3
                            )
                            2 -> rectF.set(
                                mWidth.toFloat() - dp150 + dp4,
                                (mHeight.toFloat() - dp8) / 3 + dp4,
                                mWidth.toFloat(),
                                (mHeight.toFloat() - dp8) / 3 * 2 + dp4
                            )
                            3 -> rectF.set(
                                mWidth.toFloat() - dp150 + dp4,
                                (mHeight.toFloat() - dp8) / 3 * 2 + dp8,
                                mWidth.toFloat(),
                                mHeight.toFloat()
                            )
                        }
                    }
                    else -> {
                        when (index) {
                            0 -> rectF.set(
                                0f,
                                0f,
                                mWidth.toFloat() - dp150,
                                (mHeight / 2).toFloat() - dp2
                            )
                            1 -> rectF.set(
                                0f,
                                (mHeight / 2).toFloat() + dp2,
                                mWidth.toFloat() - dp150,
                                mHeight.toFloat()
                            )
                            2 -> rectF.set(
                                mWidth.toFloat() - dp150 + dp4,
                                0f,
                                mWidth.toFloat(),
                                (mHeight.toFloat() - dp8) / 3
                            )
                            3 -> rectF.set(
                                mWidth.toFloat() - dp150 + dp4,
                                (mHeight.toFloat() - dp8) / 3 + dp4,
                                mWidth.toFloat(),
                                (mHeight.toFloat() - dp8) / 3 * 2 + dp4
                            )
                            4 -> rectF.set(
                                mWidth.toFloat() - dp150 + dp4,
                                (mHeight.toFloat() - dp8) / 3 * 2 + dp8,
                                mWidth.toFloat(),
                                mHeight.toFloat()
                            )
                            //有多的就不执行draw了
                            else -> {
                                imagePaint.xfermode = null
                                return@apply
                            }
                        }
                    }
                }
                canvas.drawBitmap(item, null, rectF, imagePaint)
                imagePaint.xfermode = null
            }
        }
    }

}
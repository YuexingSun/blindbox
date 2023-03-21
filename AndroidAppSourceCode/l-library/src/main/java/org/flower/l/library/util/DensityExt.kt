package org.flower.l.library.util

import android.content.Context
import android.content.res.Resources
import android.util.TypedValue

internal object DensityExt {

    /**
     * dp转px
     */
    fun dp2Pix(context: Context, dp: Float): Int {
        return try {
            val density: Float = context.resources.displayMetrics.density
            (dp * density + 0.5f).toInt()
        } catch (e: java.lang.Exception) {
            dp.toInt()
        }
    }

    /**
     * sp转px
     */
    val Int.sp
        get() = TypedValue.applyDimension(
            TypedValue.COMPLEX_UNIT_SP,
            this.toFloat(),
            Resources.getSystem().displayMetrics
        )

    /**
     * sp转px
     */
    val Float.sp
        get() = TypedValue.applyDimension(
            TypedValue.COMPLEX_UNIT_SP,
            this,
            Resources.getSystem().displayMetrics
        )

    /**
     * px转sp
     */
    fun px2sp(pxVal: Float) = pxVal / Resources.getSystem().displayMetrics.scaledDensity

}
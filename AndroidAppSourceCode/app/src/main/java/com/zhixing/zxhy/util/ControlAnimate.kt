package com.zhixing.zxhy.util

import android.animation.*
import android.view.View
import android.view.animation.*
import com.tuanliu.common.ext.gone
import com.tuanliu.common.ext.visible
import com.zhixing.zxhy.R

/**
 * 控件隐藏
 * [duration] 动画持续时间
 */
fun View.alpha0(duration: Int = 1000) {
    this.animate().alpha(0f).setDuration(duration.toLong()).setListener(object :
        AnimatorListenerAdapter() {
        override fun onAnimationEnd(animation: Animator?) {
            this@alpha0.gone()
        }
    })
}

/**
 * 控件显示
 * [duration] 动画持续时间
 */
fun View.alpha1(duration: Int = 1000) {
    this.apply {
        alpha = 0f
        visible()
        animate().alpha(1f).setDuration(duration.toLong()).setListener(null)
    }
}

/**
 * 控件旋转
 * [degrees] 旋转度数
 * [duration] 总的持续时间
 */
fun View.rotate(degrees: Float = 360f, allDuration: Long = 1000) {
    val anim = RotateAnimation(
        0f,
        degrees,
        Animation.RELATIVE_TO_SELF,
        0.5f,
        Animation.RELATIVE_TO_SELF,
        0.5f
    )
    anim.apply {
        //设置保持动画最后的状态
        fillAfter = true
        //动画时间
        duration = allDuration
        /**
         * 设置插值器
         *（1） LinearInterpolator：动画从开始到结束，变化率是线性变化。
         *（2）AccelerateInterpolator：动画从开始到结束，变化率是一个加速的过程。
         *（3）DecelerateInterpolator：动画从开始到结束，变化率是一个减速的过程。
         *（4）CycleInterpolator：动画从开始到结束，变化率是循环给定次数的正弦曲线。
         *（5）AccelerateDecelerateInterpolator：动画从开始到结束，变化率是先加速后减速的过程
         */
        interpolator = LinearInterpolator()
    }
    this.startAnimation(anim)
}

/**
 * 无限循环
 */
fun View.rotateInfinite(degrees: Float = 360f, allDuration: Long = 600) {
    val anim = RotateAnimation(
        0f,
        degrees,
        Animation.RELATIVE_TO_SELF,
        0.5f,
        Animation.RELATIVE_TO_SELF,
        0.5f
    )
    anim.apply {
        //设置保持动画最后的状态
        fillAfter = true
        //动画时间
        duration = allDuration
        //无限循环
        repeatCount = Animation.INFINITE
        /**
         * 设置插值器
         *（1）LinearInterpolator：动画从开始到结束，变化率是线性变化。
         *（2）AccelerateInterpolator：动画从开始到结束，变化率是一个加速的过程。
         *（3）DecelerateInterpolator：动画从开始到结束，变化率是一个减速的过程。
         *（4）CycleInterpolator：动画从开始到结束，变化率是循环给定次数的正弦曲线。
         *（5）AccelerateDecelerateInterpolator：动画从开始到结束，变化率是先加速后减速的过程
         */
        interpolator = LinearInterpolator()
    }
    this.startAnimation(anim)
}

/**
 * 动画展开控件
 */
fun View.animationUpdate(end: Int) {
    val lp = this.layoutParams
    this.visible()
    val animator = ValueAnimator.ofInt(0, end)
    animator.addUpdateListener {
        lp.height = it.animatedValue as Int
        this.layoutParams = lp
    }
    animator.start()
}

/**
 * 动画展开控件
 */
fun View.animationUpdate(start: Int, end: Int) {
    val lp = this.layoutParams
    this.visible()
    val animator = ValueAnimator.ofInt(start, end)
    animator.addUpdateListener {
        lp.height = it.animatedValue as Int
        this.layoutParams = lp
    }
    animator.start()
}

/**
 * 隐藏控件动画
 * [toRight] 是否右移隐藏
 */
fun View.makeOutAnimation(toRight: Boolean, mDuration: Long = 500L) {
    this.gone()
    this.animation = AnimationUtils.makeOutAnimation(context, toRight).apply {
        duration = mDuration
    }
}

/**
 * 显示控件动画
 * [toRight] 是否右移出现
 */
fun View.makeInAnimation(toRight: Boolean, mDuration: Long = 500L) {
    this.visible()
    this.animation = AnimationUtils.makeInAnimation(context, toRight).apply {
        duration = mDuration
    }
}

/**
 * 往下移动隐藏控件动画
 */
fun View.bottomOutAnimation() {
    this.gone()
    this.animation = AnimationUtils.loadAnimation(context, R.anim.bottom_out)
}

/**
 * 往上移动隐藏控件动画
 */
fun View.topOutAnimation() {
    this.gone()
    this.animation = AnimationUtils.loadAnimation(context, R.anim.top_in)
}

/**
 * 往上移动显示控件动画
 */
fun View.bottomInAnimation() {
    this.visible()
    this.animation = AnimationUtils.loadAnimation(context, R.anim.bottom_in)
}

/**
 * 缩小一下控件
 */
fun View.scaleAnimation(toXY: Float = 0.85f, mDuration: Long = 300) {
    val scaleAnimation = ScaleAnimation(
        1f,
        toXY,
        1f,
        toXY,
        Animation.RELATIVE_TO_SELF,
        0.5f,
        1,
        0.5f
    ).apply {
        duration = mDuration
        //保持动画结束的最终状态
        fillAfter = true
        //1次
        repeatCount = 0
    }
    this.startAnimation(scaleAnimation)
}

/**
 * 放大一下控件
 */
fun View.recoverAnimation(toXY: Float = 0.85f, mDuration: Long = 300) {
    val recoverAnimation = ScaleAnimation(
        toXY,
        1f,
        toXY,
        1f,
        Animation.RELATIVE_TO_SELF,
        0.5f,
        1,
        0.5f
    ).apply {
        duration = mDuration
        //保持动画结束的最终状态
        fillAfter = true
        //1次
        repeatCount = 0
    }
    this.startAnimation(recoverAnimation)
}

/**
 * 缩放并且移动到某个位置
 * [targetView] 要移动到目标控件的位置
 */
fun View.transScaleXY(
    targetView: View,
    mScaleX: Float,
    mScaleY: Float,
    mDuration: Long,
    animationEnd: (Animator?) -> Unit
) {

    val tranXValue = (targetView.left - this.left).toFloat()
    val tranYValue = (targetView.top - this.top).toFloat()

    //缩放中心点位置 在左上角
    this.pivotX = 0f
    this.pivotY = 0f

    val tranX = ObjectAnimator.ofFloat(this, "translationX", tranXValue).apply {
        duration = mDuration
        repeatMode = ValueAnimator.REVERSE
    }
    val tranY = ObjectAnimator.ofFloat(this, "translationY", tranYValue).apply {
        duration = mDuration
        repeatMode = ValueAnimator.REVERSE
    }

    val scaleXAnima = ObjectAnimator.ofFloat(this, "scaleX", mScaleX).apply {
        duration = mDuration
        repeatMode = ValueAnimator.REVERSE
    }

    val scaleYAnima = ObjectAnimator.ofFloat(this, "scaleY", mScaleY).apply {
        duration = mDuration
        repeatMode = ValueAnimator.REVERSE
    }

    AnimatorSet().apply {
        playTogether(scaleXAnima, scaleYAnima, tranX, tranY)
        addListener(object : AnimatorListenerAdapter() {
            override fun onAnimationEnd(animation: Animator?) {
                super.onAnimationEnd(animation)
                animationEnd(animation)
            }
        })
    }.start()
}

/**
 * 缩放,完成后恢复原样
 */
fun View.scaleXY(mScaleX: Float, mScaleY: Float, mDuration: Long) {

    val scaleXAnima = ObjectAnimator.ofFloat(this, "scaleX", 1.0f, mScaleX).apply {
        duration = mDuration
        repeatMode = ValueAnimator.REVERSE
    }

    val scaleYAnima = ObjectAnimator.ofFloat(this, "scaleY", 1.0f, mScaleY).apply {
        duration = mDuration
        repeatMode = ValueAnimator.REVERSE
    }

    val endScaleX = ObjectAnimator.ofFloat(this, "scaleX", mScaleX, 1.0f).apply {
        duration = mDuration
        repeatMode = ValueAnimator.REVERSE
    }

    val endScaleY = ObjectAnimator.ofFloat(this, "scaleY", mScaleY, 1.0f).apply {
        duration = mDuration
        repeatMode = ValueAnimator.REVERSE
    }

    AnimatorSet().apply {
        play(scaleXAnima).with(scaleYAnima).before(endScaleX).before(endScaleY)
    }.start()

}

/**
 * 无限旋转
 */
fun View.rotationInfinite(): ObjectAnimator {
    val objectAnimation = ObjectAnimator.ofFloat(this, "rotation", 0f, 360f)
    objectAnimation.apply {
        duration = 1200
        //无限次数
        repeatCount = ValueAnimator.INFINITE
        //重头开始
        repeatMode = ValueAnimator.RESTART
        interpolator = LinearInterpolator()
        start()
    }
    return objectAnimation
}
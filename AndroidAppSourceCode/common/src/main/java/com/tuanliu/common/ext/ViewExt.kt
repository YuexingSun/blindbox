package com.tuanliu.common.ext

import android.view.View
import android.view.animation.CycleInterpolator
import android.view.animation.TranslateAnimation
import androidx.dynamicanimation.animation.DynamicAnimation
import androidx.dynamicanimation.animation.SpringAnimation
import androidx.dynamicanimation.animation.SpringForce

/**
 * 控件摆动
 * [duration] 持续时间
 * [cycles] 循环插值器，持续时间内执行几次动画
 */
fun View.shake(duration: Long, cycles: Float, fromX: Float = 0f, toX: Float = 0f, fromY: Float = 0f, toY: Float = 0f) {
    val anim = TranslateAnimation(fromX, toX, fromY, toY)
    //持续时间
    anim.duration = duration
    //循环插值器 在持续时间内执行几次动画
    anim.interpolator = CycleInterpolator(cycles)
    startAnimation(anim)
}

/**
 * SpringAnimation动画的控件摆动,和拖拽事件一起使用，不然没有加速度就只能设置finalPotion值 != 0f
 *
 * [FloatPropertyCompat]SpingAnimation的第二个参数
 * 属性：
 * TRANSLATION_X —— 在原布局容器位置的基础上实现x轴的位移
 * TRANSLATION_Y —— Y轴的位移
 * TRANSLATION_Z —— Z轴的位移
 * ALPHA - alpha值的变化，0(全透明) —— 1(不透明)
 * ROTATION,ROTATION_X,ROTATION_Y —— 控制2D的旋转以及3D旋转的轴心点
 * SCROLL_X,SCROLL_Y —— 距离左边和顶部的距离，单位是像素px
 * SCALE_X,SCALE_Y —— 控制基于轴心点的2D缩放
 * X,Y,Z —— 分别控制view左侧位移、顶部位移以及深度(elevation)
 *
 * 可以在动画启动前注册监听器，addUpdateListener,动画执行的每一帧都没收到响应的回调
 * value值和velocity加速度
 * 当我们要实现一个动画链的时候，就可以根据当前 value 值设置下一链的 finalPostion
 * 结束监听的时候removeUpdateListener移除监听器
 */
fun View.springShake() {
    val springAnimation = SpringAnimation(this, DynamicAnimation.TRANSLATION_X)
    //finalPosition最终位置
    val springForce = SpringForce(0f).apply {
        /**
         * 阻尼:指振动系统在振动中，由于外界作用或系统本身固有的原因引起的振动幅度逐渐下降的特性
         *
         * >1 迅速回到平衡位置
         * =1 在较短的时间内回到平衡位置
         * <1 多次来回震动然后回到平衡位置
         * =0 永远震动，回不到最终位置
         *
         * 默认DAMPING_RATIO_MEDIUM_BOUNCY 0.5
         *
         */
        dampingRatio = SpringForce.DAMPING_RATIO_HIGH_BOUNCY
        /**
         * 刚度:指材料或结构在受力时抵抗弹性变形的能力
         *
         * 默认值STIFFNESS_MEDIUM 1500f
         */
        stiffness = SpringForce.STIFFNESS_LOW
    }
    springAnimation.spring = springForce
    //执行动画
    springAnimation.start()
}

/**
 * View显示
 */
fun View?.visible() {
    this?.visibility = View.VISIBLE
}

/**
 * View隐藏
 */
fun View?.gone() {
    this?.visibility = View.GONE
}

/**
 * View占位隐藏
 */
fun View?.inVisible() {
    this?.visibility = View.INVISIBLE
}

/**
 * View是否显示
 */
fun View?.isVisible(): Boolean {
    return this?.visibility == View.VISIBLE
}

/**
 * View是否隐藏
 */
fun View?.isGone(): Boolean {
    return this?.visibility == View.GONE
}

/**
 * View是否占位隐藏
 */
fun View?.isInVisible(): Boolean {
    return this?.visibility == View.INVISIBLE
}

/**
 * @param visible 如果为true 该View显示 否则隐藏
 */
fun View?.visibleOrGone(visible: Boolean) {
    if (visible) {
        this.visible()
    } else {
        this.gone()
    }
}

/**
 * @param visible 如果为true 该View显示 否则占位隐藏
 */
fun View?.visibleOrInvisible(visible: Boolean) {
    if (visible) {
        this.visible()
    } else {
        this.inVisible()
    }
}

/**
 * 显示传入的view集合
 */
fun visibleViews(vararg views: View?) {
    views.forEach {
        it?.visible()
    }
}

/**
 * 隐藏传入的view集合
 */
fun goneViews(vararg views: View?) {
    views.forEach {
        it?.gone()
    }
}




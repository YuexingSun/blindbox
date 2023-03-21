package com.tuanliu.common.ext

import android.content.Context
import android.view.Gravity
import androidx.annotation.ColorRes
import androidx.annotation.LayoutRes
import androidx.fragment.app.Fragment
import com.tuanliu.common.R
import com.tuanliu.common.util.ImmersionBarUtil.changeNaviColor
import per.goweii.anylayer.AnyLayer
import per.goweii.anylayer.Layer
import per.goweii.anylayer.widget.SwipeLayout

/**
 * 基本的弹窗
 */
fun Fragment.anyLayer(
    cancelable: Boolean = false
) = AnyLayer.dialog(requireContext())
    //点击浮层以外区域是否可关闭
    .cancelableOnTouchOutside(cancelable)
    .backgroundColorInt(requireContext().getResColor(R.color.c_80000000))

/**
 * 基本的弹窗
 */
fun Context.anyLayer(
    cancelable: Boolean = false
) = AnyLayer.dialog(this)
    //点击浮层以外区域是否可关闭
    .cancelableOnTouchOutside(cancelable)
    .backgroundColorInt(this.getResColor(R.color.c_80000000))

/**
 * 基本的弹窗
 */
fun Fragment.anyLayer(
    @LayoutRes contentViewId: Int,
    cancelable: Boolean = false,
    @ColorRes naviColor: Int
) = AnyLayer.dialog(requireContext())
    //点击浮层以外区域是否可关闭
    .cancelableOnTouchOutside(cancelable)
    .backgroundColorInt(requireContext().getResColor(R.color.c_80000000))
    .contentView(contentViewId)
    .onShowListener(object : Layer.OnShowListener {
        override fun onShowing(layer: Layer) {
            changeNaviColor(R.color.c_80000000)
        }
        override fun onShown(layer: Layer) {}
    })
    .onDismissListener(object : Layer.OnDismissListener {
        override fun onDismissing(layer: Layer) {
            changeNaviColor(naviColor)
        }
        override fun onDismissed(layer: Layer) {}
    })

/**
 * 基本的弹窗
 * 下面进下面出
 */
fun Fragment.anyLayerBottom(
    @LayoutRes contentViewId: Int,
    cancelable: Boolean = false,
    @ColorRes naviColors: Int,
    @ColorRes startNaviColor: Int = R.color.c_80000000,
) = AnyLayer.dialog(requireContext())
    //点击浮层以外区域是否可关闭
    .cancelableOnTouchOutside(cancelable)
    .backgroundColorInt(requireContext().getResColor(R.color.c_80000000))
    .gravity(Gravity.BOTTOM)
    .swipeDismiss(SwipeLayout.Direction.BOTTOM)
    .contentView(contentViewId)
    .onShowListener(object : Layer.OnShowListener {
        override fun onShowing(layer: Layer) {
            changeNaviColor(startNaviColor)
        }
        override fun onShown(layer: Layer) {}
    })
    .onDismissListener(object : Layer.OnDismissListener {
        override fun onDismissing(layer: Layer) {
            changeNaviColor(naviColors)
        }
        override fun onDismissed(layer: Layer) {}
    })



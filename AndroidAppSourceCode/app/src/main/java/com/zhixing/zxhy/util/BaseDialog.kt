package com.zhixing.zxhy.util

import android.view.Gravity
import android.widget.TextView
import androidx.annotation.ColorRes
import androidx.fragment.app.Fragment
import com.tuanliu.common.ext.anyLayer
import com.tuanliu.common.ext.getResColor
import com.zhixing.zxhy.R
import com.tuanliu.common.util.ImmersionBarUtil.changeNaviColor
import per.goweii.anylayer.Layer
import per.goweii.anylayer.widget.SwipeLayout

/**
 * 公共弹窗
 * 两个按钮样式的弹窗
 */
fun Fragment.baseCommonAnyLayer(
    dataList: List<String>,
    oneBlock: () -> Unit,
    twoBlock: () -> Unit,
    @ColorRes naviColor: Int = R.color.c_EF,
    @ColorRes oneTextColor: Int = R.color.c_3,
    cancelBlock: (() -> Unit)? = null
) {
    anyLayer(true).contentView(R.layout.dialog_amap_close)
        .gravity(Gravity.BOTTOM)
        .swipeDismiss(SwipeLayout.Direction.BOTTOM)
        .onInitialize { layer ->
            if (dataList.size < 2) return@onInitialize
            val one = layer.getView<TextView>(R.id.One)
            one?.text = dataList[0]
            one?.setTextColor(this.requireContext().getResColor(oneTextColor))
            layer.getView<TextView>(R.id.Two)?.text = dataList[1]
            changeNaviColor(R.color.c_80000000)
        }
        .onClickToDismiss({ _, _ ->
            cancelBlock?.invoke()
        }, R.id.Cancel)
        .onClickToDismiss({ _, _ ->
            oneBlock()
        }, R.id.One)
        .onClickToDismiss({ _, _ ->
            twoBlock()
        }, R.id.Two)
        .onDismissListener(object : Layer.OnDismissListener {
            override fun onDismissing(layer: Layer) {
                changeNaviColor(naviColor)
            }

            override fun onDismissed(layer: Layer) {}
        })
        .show()
}
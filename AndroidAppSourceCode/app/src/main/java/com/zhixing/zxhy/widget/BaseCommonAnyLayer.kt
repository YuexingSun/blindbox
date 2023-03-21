package com.zhixing.zxhy.widget

import android.view.Gravity
import android.widget.TextView
import androidx.annotation.ColorRes
import com.tuanliu.common.base.BaseFragment
import com.tuanliu.common.ext.anyLayer
import com.zhixing.zxhy.R
import com.tuanliu.common.util.ImmersionBarUtil.changeNaviColor
import per.goweii.anylayer.Layer
import per.goweii.anylayer.widget.SwipeLayout

/**
 * 公共弹窗
 */
class BaseCommonAnyLayer(val fragment: BaseFragment) {

    /**
     * 两个选项
     */
    fun baseCommonAnyLayer(
        dataList: List<String>,
        cancelBlock: (() -> Unit)? = null,
        @ColorRes initNaviColor: Int = R.color.c_80000000,
        @ColorRes dismissNaviColor: Int = R.color.c_EF,
        oneBlock: () -> Unit,
        twoBlock: () -> Unit,
    ) {
        fragment.anyLayer(true).contentView(R.layout.dialog_amap_close)
            .gravity(Gravity.BOTTOM)
            .swipeDismiss(SwipeLayout.Direction.BOTTOM)
            .onInitialize { layer ->
                if (dataList.size < 2) return@onInitialize
                layer.getView<TextView>(R.id.One)?.text = dataList[0]
                layer.getView<TextView>(R.id.Two)?.text = dataList[1]
                fragment.changeNaviColor(initNaviColor)
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
                override fun onDismissing(layer: Layer) {}

                override fun onDismissed(layer: Layer) {
                    fragment.changeNaviColor(dismissNaviColor)
                }
            })
            .show()
    }

    /**
     * 一个选项
     */
    fun baseCommonAnyLayer(
        str: String,
        cancelBlock: (() -> Unit)? = null,
        @ColorRes initNaviColor: Int = R.color.c_80000000,
        @ColorRes dismissNaviColor: Int = R.color.c_EF,
        oneBlock: () -> Unit,
    ) {
        fragment.anyLayer(true).contentView(R.layout.dialog_base)
            .gravity(Gravity.BOTTOM)
            .swipeDismiss(SwipeLayout.Direction.BOTTOM)
            .onInitialize { layer ->
                val one = layer.getView<TextView>(R.id.One)
                one?.text = str
                fragment.changeNaviColor(initNaviColor)
            }
            .onClickToDismiss({ _, _ ->
                cancelBlock?.invoke()
            }, R.id.Cancel)
            .onClickToDismiss({ _, _ ->
                oneBlock()
            }, R.id.One)
            .onDismissListener(object : Layer.OnDismissListener {
                override fun onDismissing(layer: Layer) {}

                override fun onDismissed(layer: Layer) {
                    fragment.changeNaviColor(dismissNaviColor)
                }
            })
            .show()
    }

}
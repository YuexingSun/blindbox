package com.tuanliu.common.base

import android.graphics.drawable.ColorDrawable
import android.os.Bundle
import android.view.*
import androidx.annotation.LayoutRes
import androidx.databinding.DataBindingUtil
import androidx.databinding.ViewDataBinding
import androidx.fragment.app.DialogFragment
import androidx.lifecycle.LiveData
import androidx.lifecycle.Observer
import com.tuanliu.common.R
import com.tuanliu.common.ext.dp2Pix

/**
 * DialogFragment的基类
 */
abstract class BaseDialogFragment<DB : ViewDataBinding>(
    @LayoutRes val layout: Int,
    //布局的高度
    private val maxHeight: Float = 0f
) :
    DialogFragment() {

    lateinit var mDataBind: DB

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        //去掉标题
        requireDialog().requestWindowFeature(Window.FEATURE_NO_TITLE)
        val window = requireDialog().window
        //去掉dialog默认的padding
        window!!.decorView.setPadding(0, 0, 0, 0)
        val lp = window.attributes
        //宽高
        lp.width = WindowManager.LayoutParams.MATCH_PARENT
        lp.height = dp2Pix(requireContext(), maxHeight)
        //设置dialog的位置在底部
        lp.gravity = Gravity.BOTTOM
        //设置dialog的动画
        lp.windowAnimations = R.style.BottomDialogAnimation
        window.attributes = lp
        window.setBackgroundDrawable(ColorDrawable())

        mDataBind = DataBindingUtil.inflate(inflater, layout, container, false)

        return mDataBind.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        initView(savedInstanceState)
        initLiveData()
    }

    /**
     * 初始化view操作
     */
    abstract fun initView(savedInstanceState: Bundle?)

    /**
     * 初始化LiveData
     */
    open fun initLiveData() {}

    /*
    * 扩展liveData的observer函数
    * livedata回传回来的数据可能为null
    * 不用写viewLifecycleOwner
    * */
    protected fun <T : Any?> LiveData<T>.observerKt(block: (T?) -> Unit) {
        this.observe(viewLifecycleOwner, Observer { data ->
            // block.invoke(data)
            block(data)
        })
    }

}
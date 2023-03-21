package org.flower.l.library.base

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.util.SparseArray
import androidx.appcompat.app.AppCompatActivity
import androidx.databinding.DataBindingUtil
import androidx.databinding.ViewDataBinding
import org.flower.l.library.base.action.ActivityAction
import java.util.*
import kotlin.math.pow

abstract class BaseWebActivity<DB: ViewDataBinding>: AppCompatActivity(), ActivityAction {

    lateinit var mDataBind: DB

    /** Activity 回调集合 */
    private val activityCallbacks: SparseArray<OnActivityCallback?> by lazy { SparseArray(1) }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        initActivity()
    }

    protected open fun initActivity() {
        initLayout()
        initView()
        initData()
    }

    /**
     * 初始化控件
     */
    protected abstract fun initView()

    /**
     * 初始化数据
     */
    protected abstract fun initData()

    protected open fun initLayout() {
        if (getLayoutId() > 0) {
            //利用反射 根据泛型得到 ViewDataBinding
//            val superClass = javaClass.genericSuperclass
//            val aClass = (superClass as ParameterizedType).actualTypeArguments[1] as Class<*>
//            val method = aClass.getDeclaredMethod("inflate", LayoutInflater::class.java)
//            mDataBind = method.invoke(null, layoutInflater) as DB
            mDataBind = DataBindingUtil.setContentView(this, getLayoutId())
            mDataBind.lifecycleOwner = this
        }
    }

    protected abstract fun getLayoutId(): Int

    @Suppress("deprecation")
    override fun startActivityForResult(intent: Intent, requestCode: Int, options: Bundle?) {
        // 查看源码得知 startActivity 最终也会调用 startActivityForResult
        super.startActivityForResult(intent, requestCode, options)
    }

    /**
     * startActivityForResult 方法优化
     */
    open fun startActivityForResult(clazz: Class<out Activity>, callback: OnActivityCallback?) {
        startActivityForResult(Intent(this, clazz), null, callback)
    }

    open fun startActivityForResult(intent: Intent, callback: OnActivityCallback?) {
        startActivityForResult(intent, null, callback)
    }

    @Suppress("deprecation")
    open fun startActivityForResult(intent: Intent, options: Bundle?, callback: OnActivityCallback?) {
        // 请求码必须在 2 的 16 次方以内
        val requestCode: Int = Random().nextInt(2.0.pow(16.0).toInt())
        activityCallbacks.put(requestCode, callback)
        startActivityForResult(intent, requestCode, options)
    }

    @Suppress("deprecation")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        var callback: OnActivityCallback?
        if ((activityCallbacks.get(requestCode).also { callback = it }) != null) {
            callback?.onActivityResult(resultCode, data)
            activityCallbacks.remove(requestCode)
            return
        }
        super.onActivityResult(requestCode, resultCode, data)
    }

    override fun getContext(): Context = this

    override fun startActivity(intent: Intent) {
        return super<AppCompatActivity>.startActivity(intent)
    }

    interface OnActivityCallback {

        /**
         * 结果回调
         *
         * @param resultCode        结果码
         * @param data              数据
         */
        fun onActivityResult(resultCode: Int, data: Intent?)
    }

}
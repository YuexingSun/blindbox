package com.zhixing.zxhy.ui.fragment

import android.os.Bundle
import android.widget.Button
import android.widget.ProgressBar
import android.widget.TextView
import androidx.lifecycle.lifecycleScope
import androidx.navigation.fragment.findNavController
import com.blankj.utilcode.util.ClipboardUtils
import com.hjq.toast.ToastUtils
import com.tuanliu.common.base.BaseDbFragment
import com.tuanliu.common.ext.*
import com.tuanliu.common.model.FragmentConfigData
import com.tuanliu.common.model.StatusBarMode
import com.tuanliu.common.util.BitmapUtil
import com.zhixing.zxhy.R
import com.zhixing.zxhy.databinding.FragmentAboutMeBinding
import com.zhixing.zxhy.view_model.AboutMeViewModel
import com.tuanliu.common.util.ImmersionBarUtil.changeNaviColor
import com.zhixing.zxhy.util.alpha0
import com.zhixing.zxhy.util.alpha1
import com.zhixing.zxhy.util.toPermission.InStallPermission
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import per.goweii.anylayer.Layer

/**
 * 关于我们页面
 */
class AboutMeFragment : BaseDbFragment<AboutMeViewModel, FragmentAboutMeBinding>() {

    //升级弹窗内的按钮和进度条
    private var progressBar: ProgressBar? = null

    override fun initView(savedInstanceState: Bundle?) {
        mDataBind.apply {
            wx = arguments?.getString("WX_SERVICE") ?: ""

            //返回
            Back.setOnClickListener {
                findNavController().navigateUp()
            }
            //跳转到隐私协议页面
            AgreementConst.setOnClickListener {
                val bundle = Bundle()
                bundle.putBoolean("agreement", true)
                animationNav(R.id.action_aboutMeFragment_to_agreementFragment, bundle)
            }
            //服务协议
            ServiceCost.setOnClickListener {
                animationNav(R.id.action_aboutMeFragment_to_agreementFragment)
            }
            //版本更新
            UpdateConst.setOnClickListener {
                //获取客户端初始化信息
                mViewModel.getInitData()
            }
            //客服微信号
            WXServiceConst.setOnClickListener {
                isCopyHint()
                ClipboardUtils.copyText(wx)
            }
        }
    }

    override fun initLiveData() {
        mViewModel.apply {

            //客户端初始化数据
            initDataLiveData.observerKt {
                val initData = it?.versions?.android ?: return@observerKt
                val requestCode =
                    initData.newest?.replace(".", "")?.toIntOrNull() ?: return@observerKt

                val packageCode =
                    BitmapUtil.packageCode(requireContext()).replace(".", "").toIntOrNull()
                        ?: return@observerKt

                if (packageCode < requestCode) {
                    //弹窗 判断是否强制更新
                    updateAnyLayer(initData.force == 0, initData.newest)
                } else ToastUtils.show("当前已经是最新版本啦！")
            }

            //下载apk的进度
            downApkProgress.observerKt { i ->
                progressBar?.let {
                    it.progress = i ?: 0
                }
            }

        }
    }

    //已复制提示
    private fun isCopyHint() {
        lifecycleScope.launch {
            mDataBind.IsCopy.alpha1(500)
            delay(1250)
            mDataBind.IsCopy.alpha0(500)
        }
    }

    /**
     * 更新弹窗
     * [cancelable] 点击旁边是否可以关闭弹窗
     */
    private fun updateAnyLayer(cancelable: Boolean, versionStr: String) {
        changeNaviColor(R.color.c_80000000)
        anyLayer(cancelable).contentView(R.layout.dialog_install_app)
            .onClick(Layer.OnClickListener { layer, _ ->
                //获取安装app的权限
                InStallPermission(this@AboutMeFragment).checkPermission {
                    layer.getView<Button>(R.id.NowUpdate).gone()
                    progressBar = layer.getView<ProgressBar>(R.id.ProgressBarA)
                    progressBar.visible()
                    //请求下载apk
                    mViewModel.downLoadApk(requireContext())
                }
            }, R.id.NowUpdate)
            .onInitialize { layer ->
                layer.getView<TextView>(R.id.VersionStr)?.text = "V ${versionStr}"
            }
            .onDismissListener(object : Layer.OnDismissListener {
                override fun onDismissing(layer: Layer) {
                    changeNaviColor(R.color.c_EF)
                }

                override fun onDismissed(layer: Layer) {
                    progressBar = null
                }
            })
            //拦截物理按键
            .interceptKeyEvent(true)
            .show()
    }

    override fun fragmentConfigInit(): FragmentConfigData =
        FragmentConfigData(
            false,
            transparentStatusBar = false,
            statusBarMode = StatusBarMode.STATUS_BAR_MODE_DARK,
            transparentNavigationBar = false,
            navigationBarColor = R.color.c_EF
        )

}
package com.zhixing.zxhy.util.selectedPic

import android.view.Gravity
import android.widget.TextView
import com.hjq.permissions.OnPermissionCallback
import com.hjq.permissions.Permission
import com.hjq.permissions.XXPermissions
import com.hjq.toast.ToastUtils
import com.luck.picture.lib.PictureSelector
import com.luck.picture.lib.config.PictureConfig
import com.luck.picture.lib.config.PictureMimeType
import com.luck.picture.lib.entity.LocalMedia
import com.luck.picture.lib.listener.OnResultCallbackListener
import com.tuanliu.common.base.BaseFragment
import com.tuanliu.common.ext.anyLayer
import com.zhixing.zxhy.R
import com.zhixing.zxhy.util.GlideEngine
import com.tuanliu.common.util.ImmersionBarUtil.changeNaviColor
import per.goweii.anylayer.Layer
import per.goweii.anylayer.widget.SwipeLayout

/**
 * 修改头像
 * [imgPath] 压缩后的头像path
 */
class ChangeHeader(val fragment: BaseFragment, val imgPath: (path: String) -> Unit) {

    init {
        val list = listOf("拍照", "从相册中选择")
        baseCommonAnyLayer(list, oneBlock = {
            //查看权限，如果获取到了就跳转到拍照页面
            checkPermission(true)
        }, twoBlock = {
            //查看权限，如果获取到了就跳转到选择相片页面
            checkPermission(false)
        }) {}
    }

    //照片选择器对象
    private val pictureSelector = PictureSelector.create(fragment)

    /**
     * 查看权限是否获取
     * [isPicture] 是否直接拍照
     */
    private fun checkPermission(isPicture: Boolean) {
        XXPermissions.with(fragment).permission(
            Permission.CAMERA,
            Permission.READ_EXTERNAL_STORAGE
        )
            .request(object : OnPermissionCallback {
                override fun onGranted(permissions: MutableList<String>?, all: Boolean) {
                    if (all) {
                        if (isPicture) picturePhoto()
                        else openPhotoAlbum()
                    } else ToastUtils.show("有权限未通过，请点击重试。")
                }

                override fun onDenied(permissions: MutableList<String>?, never: Boolean) {
                    if (never)
                        ToastUtils.show("被永久拒绝授权，请手动授予权限")
                    else ToastUtils.show("获取部分权限失败")
                }
            })
    }

    /**
     * 直接拍照
     */
    private fun picturePhoto() {
        pictureSelector.openCamera(PictureMimeType.ofImage())
            //单选
            .selectionMode(PictureConfig.SINGLE)
            //预览
            .isPreviewImage(true)
            //压缩
            .isCompress(true)
            //开启裁剪
            .isEnableCrop(true)
            //裁剪比例
            .withAspectRatio(1, 1)
            //不显示gif
            .isGif(false)
            //图片加载引擎
            .imageEngine(GlideEngine().createGlideEngine())
            //回调
            .forResult(object : OnResultCallbackListener<LocalMedia> {
                override fun onResult(result: MutableList<LocalMedia>?) {
                    var path = ""
                    result?.forEach { localMedia: LocalMedia ->
                        //是否压缩 压缩的话拿压缩地址，否则拿原图地址
                        if (localMedia.isCompressed) path = localMedia.compressPath

                        if (path == "") {
                            ToastUtils.show("图片压缩失败，请重试。")
                            return@forEach
                        }

                        imgPath(path)
                    }
                }

                override fun onCancel() {}
            })
    }

    /**
     * 打开相册
     */
    private fun openPhotoAlbum() {
        pictureSelector.openGallery(PictureMimeType.ofImage())
            //单选
            .selectionMode(PictureConfig.SINGLE)
            //单选模式下选择后直接返回
            .isSingleDirectReturn(true)
            //预览
            .isPreviewImage(true)
            //压缩
            .isCompress(true)
            //开启裁剪
            .isEnableCrop(true)
            //裁剪比例
            .withAspectRatio(1, 1)
            //列表不显示拍照按钮
            .isCamera(false)
            //不显示gif
            .isGif(false)
            //图片加载引擎
            .imageEngine(GlideEngine().createGlideEngine())
            //回调
            .forResult(object : OnResultCallbackListener<LocalMedia> {
                override fun onResult(result: MutableList<LocalMedia>?) {
                    var path = ""
                    result?.forEach { localMedia: LocalMedia ->
                        //是否压缩 压缩的话拿压缩地址，否则拿原图地址
                        if (localMedia.isCompressed) path = localMedia.compressPath
                        if (path == "") {
                            ToastUtils.show("图片压缩失败，请重试。")
                            return@forEach
                        }

                        imgPath(path)
                    }
                }

                override fun onCancel() {}
            })
    }

    /**
     * 公共弹窗
     */
    private fun baseCommonAnyLayer(
        dataList: List<String>,
        oneBlock: () -> Unit,
        twoBlock: () -> Unit,
        cancelBlock: (() -> Unit)? = null
    ) {
        fragment.anyLayer(true).contentView(R.layout.dialog_amap_close)
            .gravity(Gravity.BOTTOM)
            .swipeDismiss(SwipeLayout.Direction.BOTTOM)
            .onInitialize { layer ->
                if (dataList.size < 2) return@onInitialize
                layer.getView<TextView>(R.id.One)?.text = dataList[0]
                layer.getView<TextView>(R.id.Two)?.text = dataList[1]
                fragment.changeNaviColor(R.color.c_80000000)
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
                    fragment.changeNaviColor(R.color.c_EF)
                }
            })
            .show()
    }

}
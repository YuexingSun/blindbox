package com.zhixing.zxhy.util.selectedPic

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
import com.zhixing.zxhy.ui.fragment.SendArticleFragment
import com.zhixing.zxhy.util.GlideEngine
import java.io.File

/**
 * 写文章 - 上传图片
 * [imgPath] 压缩后的图片path
 */
class WriteArticlePic(val fragment: BaseFragment) {

    //照片选择器对象
    private var pictureSelector: PictureSelector = PictureSelector.create(fragment)

    //图片路径
    var path = ""
    var fileList = arrayListOf<File>()

    /**
     * 查看权限是否获取
     * [maxSelectedNum] 最多选择数量
     */
    fun checkPermission(
        maxSelectedNum: Int,
        imgPath: (fileList: ArrayList<File>) -> Unit
    ) {
        XXPermissions.with(fragment).permission(
            Permission.CAMERA,
            Permission.READ_EXTERNAL_STORAGE
        )
            .request(object : OnPermissionCallback {
                override fun onGranted(permissions: MutableList<String>?, all: Boolean) {
                    if (all) {
                        openPhotoAlbum(maxSelectedNum, imgPath)
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
     * 打开相册
     */
    private fun openPhotoAlbum(maxSelectedNum: Int, imgPath: (fileList: ArrayList<File>) -> Unit) {
        pictureSelector.openGallery(PictureMimeType.ofImage())
            //多选
            .selectionMode(PictureConfig.MULTIPLE)
            //预览
            .isPreviewImage(true)
            //压缩
            .isCompress(true)
            //开启图片编辑
            .isEditorImage(true)
            //列表是否显示拍照按钮
            .isCamera(false)
            //不显示gif
            .isGif(false)
            //最大选择数量
            .maxSelectNum(maxSelectedNum)
            //图片加载引擎
            .imageEngine(GlideEngine().createGlideEngine())
            //回调
            .forResult(object : OnResultCallbackListener<LocalMedia> {
                override fun onResult(result: MutableList<LocalMedia>?) {
                    fileList.clear()
                    result?.forEach { localMedia: LocalMedia ->
                        //是否压缩 压缩的话拿压缩地址，否则拿原图地址
                        if (localMedia.isCompressed) path = localMedia.compressPath
                        if (path == "") {
                            ToastUtils.show("图片压缩失败，请重试。")
                            return@forEach
                        }
                        fileList.add(File(path))
                    }
                    imgPath(fileList)
                }

                override fun onCancel() {}
            })
    }

}
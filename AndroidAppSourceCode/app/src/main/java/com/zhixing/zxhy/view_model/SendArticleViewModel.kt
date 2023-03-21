package com.zhixing.zxhy.view_model

import android.util.Log
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import com.hjq.toast.ToastUtils
import com.tuanliu.common.base.BaseViewModel
import com.tuanliu.common.net.onBizError
import com.tuanliu.common.net.onBizOK
import com.tuanliu.common.net.onFailure
import com.tuanliu.common.net.onSuccess
import com.tuanliu.common.util.SingleLiveEvent
import com.zhixing.network.base.NetUrl
import com.zhixing.network.ext.serverData
import com.zhixing.network.model.NetConstant
import com.zhixing.zxhy.ArticleDetailsData
import com.zhixing.zxhy.SendInfoData
import com.zhixing.zxhy.UploadMultFileData
import com.zhixing.zxhy.repo.SendArticleRepo
import com.zhixing.zxhy.service.InforCreateInfoBody
import com.zhixing.zxhy.service.InforDetailBody
import rxhttp.awaitResult
import rxhttp.toClass
import rxhttp.wrapper.param.RxHttp
import java.io.File

class SendArticleViewModel : BaseViewModel() {

    //标题
    val titleStr = MutableLiveData<String>("写笔记")
    //界面右上角的字
    val sendStr = MutableLiveData<String>("保存")

    val addressLD = SingleLiveEvent<String>()
    var lat: Double = 0.0
    var lng: Double = 0.0
    var detailAddress: String = ""
    var point: Double = 0.0

    //文章id
    var id: Int = 0

    /**
     * 清除数据
     */
    fun clearData() {
        addressLD.value = ""
        lat = 0.0
        lng = 0.0
        id = 0
    }

    //文章详情
    private val _detailsLiveData = SingleLiveEvent<ArticleDetailsData>()
    val detailsLiveData: LiveData<ArticleDetailsData>
        get() = _detailsLiveData

    /**
     * 获取文章详情
     */
    fun inforGetDetailData() = serverAwait {
        SendArticleRepo.inforGetDetailData(InforDetailBody(id)).serverData().onSuccess {
            onBizError { code, message ->
                Log.e("xxx", "获取文章详情 接口异常 $code $message")
            }
            onBizOK<ArticleDetailsData> { _, data, _ ->
                _detailsLiveData.postValue(data)
            }
        }.onFailure {
            Log.e("xxx", "获取文章详情 接口异常 $it")
        }
    }

    //上传多个文件的数据
    private val _uploadMultFileLD = SingleLiveEvent<UploadMultFileData>()
    val uploadMultFileLD: LiveData<UploadMultFileData>
        get() = _uploadMultFileLD

    /**
     * 上传多个文件
     */
    fun upLoadMultFile(fileList: ArrayList<File>) = serverAwait {
        RxHttp.postForm(NetUrl.UPLOAD_MULT_FILE)
            .addFiles("file[]", fileList)
            .toClass<UploadMultFileData>()
            .awaitResult {
                when(it.code) {
                    NetConstant.SUCCESS_CODE -> _uploadMultFileLD.postValue(it)
                    NetConstant.ERROR_CODE_10003 -> codeRequest.postValue(it.code)
                    else -> ToastUtils.show("${it.msg}")
                }
            }.onFailure {
                Log.i("xxx", "上传多个文件 接口异常 ${it.message}")
            }
    }

    //文章id
    private val _inforCreateInfoLD = SingleLiveEvent<SendInfoData>()
    val inforCreateInfoLD: LiveData<SendInfoData>
        get() = _inforCreateInfoLD

    /**
     * 写笔记或修改笔记
     */
    fun inforCreateInfo(title: String, content: String, pic: ArrayList<String>) = serverAwait {

        if (title.isBlank() || content.isBlank() || pic.size == 0) {
            ToastUtils.show("标题/正文/图片不能为空")
            return@serverAwait
        }

        SendArticleRepo.inforCreateInfo(
            InforCreateInfoBody(
                title,
                content,
                pic,
                if (id != 0) id else null,
                addressLD.value,
                lng,
                lat,
                detailaddress = detailAddress,
                point
            )
        ).serverData().onSuccess {
            onBizError { code, message ->
                Log.e("xxx", "写笔记或修改笔记 接口异常 $code $message")
            }
            onBizOK<SendInfoData> { _, data, _ ->
                _inforCreateInfoLD.postValue(data)
            }
        }.onFailure {
            Log.e("xxx", "写笔记或修改笔记 接口异常 $it")
        }
    }

}
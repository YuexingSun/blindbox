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
import com.zhixing.network.ext.serverData
import com.zhixing.zxhy.repo.MyInformationRepo
import com.zhixing.zxhy.service.ChangeUserProfileData
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.MultipartBody
import okhttp3.RequestBody.Companion.asRequestBody
import java.io.File

/**
 * 个人资料
 */
class MyInformationViewModel : BaseViewModel() {

    //昵称
    val nickName = MutableLiveData<String>()

    //年龄
    val age = MutableLiveData<String>()

    //性别
    val gender = MutableLiveData<String>()

    //用户资料信息数据
    private val _userProfileLiveData = MutableLiveData<UserProfileData>()
    val userProfileLiveData: LiveData<UserProfileData>
        get() = _userProfileLiveData

    /**
     * 获取用户资料信息
     */
    fun getUserProfile() = serverAwait {
        MyInformationRepo.getUserProfile().serverData().onSuccess {
            onBizError { code, message ->
                Log.e("xxx", "获取我的信息 接口异常 $code $message")
            }
            onBizOK<UserProfileData> { _, data, _ ->
                _userProfileLiveData.postValue(data)
                data?.let {
                    nickName.postValue(it.nickname.toString())
                    age.postValue(it.age.toString())
                    gender.postValue(if (it.sex == 0) "女" else "男")
                }
            }
        }.onFailure {
            Log.e("xxx", "获取我的信息 接口异常 $it")
        }
    }

    //修改信息
    private val _uploadFileLiveData = SingleLiveEvent<String>()
    val uploadFileLiveData: LiveData<String>
        get() = _uploadFileLiveData

    /**
     * 上传文件
     */
    fun uploadFile(path: String) = serverAwait {

        val file = File(path)
        val body = file.asRequestBody("multipart/form-data".toMediaType())
        val request = MultipartBody.Builder().addFormDataPart("file", file.name, body).build()

        val uploadFile = MyInformationRepo.uploadFile(request.part(0)).serverData()
        uploadFile.onSuccess {
            onBizOK<UploadFileData> { _, data, _ ->
                data?.let {
                    if (data.url == "" || data.url == null) ToastUtils.show("上传头像失败，请重试")
                    else _uploadFileLiveData.postValue(data.url!!)
                }
            }
        }
    }

    //修改信息
    private val _changeDataLiveData = SingleLiveEvent<String>()
    val changeDataLiveData: LiveData<String>
        get() = _changeDataLiveData

    /**
     * 修改信息
     */
    fun changeHeader() = serverAwait {

        val userProfileData = ChangeUserProfileData(
            headimg = _uploadFileLiveData.value,
            nickname = nickName.value,
            sex = when (gender.value) {
                "女" -> "0"
                "男" -> "1"
                else -> "0"
            },
            age = age.value
        )

        MyInformationRepo.setUserProfile(userProfileData).serverData().onSuccess {
            onBizError { code, message ->
                Log.e("xxx", "提交个人信息修改 接口异常 $code $message")

            }
            onBizOK<Any> { _, _, _ ->
                _changeDataLiveData.postValue(System.currentTimeMillis().toString())
            }
        }
            .onFailure {
                Log.e("xxx", "提交个人信息修改 接口异常 $it")
            }
    }

}
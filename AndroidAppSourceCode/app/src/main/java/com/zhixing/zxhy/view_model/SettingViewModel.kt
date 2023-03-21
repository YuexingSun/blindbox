package com.zhixing.zxhy.view_model

import android.util.Log
import com.tuanliu.common.base.BaseViewModel
import androidx.annotation.Keep
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import com.hjq.toast.ToastUtils
import com.tuanliu.common.util.SingleLiveEvent
import com.zhixing.network.ext.serverData
import com.zhixing.zxhy.repo.SettingRepo
import java.io.File
import com.tuanliu.common.net.*
import com.zhixing.zxhy.service.ChangeUserProfileData
import okhttp3.*
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.RequestBody.Companion.asRequestBody

class SettingViewModel : BaseViewModel() {

    //用户资料信息数据
    private val _userProfileLiveData = MutableLiveData<UserProfileData>()
    val userProfileLiveData: LiveData<UserProfileData>
        get() = _userProfileLiveData

    /**
     * 获取用户资料信息
     */
    fun getUserProfile() = serverAwait {
        SettingRepo.getUserProfile().serverData().onSuccess {
            onBizError { code, message ->
                Log.e("xxx", "获取我的信息 接口异常 $code $message")
            }
            onBizOK<UserProfileData> { _, data, _ ->
                _userProfileLiveData.postValue(data)
            }
        }.onFailure {
            Log.e("xxx", "获取我的信息 接口异常 $it")
        }
    }

    //退出登录数据
    private val _userLogoutLiveData = SingleLiveEvent<String>()
    val userLogoutLiveData: LiveData<String>
        get() = _userLogoutLiveData

    /**
     * 退出登录
     */
    fun userLogout() = serverAwait {
        SettingRepo.userLogout().serverData().onSuccess {
            onBizError { code, message ->
                Log.e("xxx", "退出登录 接口异常 $code $message")
            }
            onBizOK<Any> { _, _, _ ->
                _userLogoutLiveData.postValue(System.currentTimeMillis().toString())
            }
        }.onFailure {
            Log.e("xxx", "退出登录 接口异常 $it")
        }
    }

}

/**
 * 用户资料信息数据
 */
@Keep
data class UserProfileData(
    //年龄
    val age: String?,
    //头像地址
    val headimg: String?,
    //手机号
    val mob: String?,
    //昵称
    val nickname: String?,
    //推送通知状态，0关闭，1打开
    val notifystatus: Int,
    //性别，0女生，1男生
    val sex: Int,
    //用户已拥有的标签
    val taglist: List<Taglist>?,
    //客服微信
    val servicewechat: String = ""
) {
    @Keep
    data class Taglist(
        //标签id
        val tagid: Int,
        //标签名称
        val tagname: String?
    )
}

/**
 * 上传文件
 */
@Keep
data class UploadFileData(
    val url: String?
)

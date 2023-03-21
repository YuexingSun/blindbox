package com.zhixing.zxhy.service

import androidx.annotation.Keep
import com.google.gson.annotations.SerializedName
import com.zhixing.network.base.NetUrl
import com.zhixing.network.model.BaseResponse
import okhttp3.MultipartBody
import retrofit2.Call
import retrofit2.http.*

interface SendArticleService {

    //写笔记或修改笔记
    @POST(NetUrl.INFORMATION_CREATE_INFO)
    fun inforCreateInfo(@Body inforCreateInfoBody: InforCreateInfoBody): Call<BaseResponse>

    //首页信息流详情
    @POST(NetUrl.INFORMATION_GET_DETAIL)
    fun inforGetDetailData(@Body inforDetailBody: InforDetailBody): Call<BaseResponse>

}

/**
 * 写笔记或修改笔记的body
 */
@Keep
data class InforCreateInfoBody(
    //标题
    @SerializedName("title")
    val title: String,
    //内容
    @SerializedName("content")
    val content: String,
    //图片
    @SerializedName("pic")
    val pic: ArrayList<String>,
    //修改文章的文章id
    @SerializedName("id")
    val id: Int? = null,
    //关联地理位置名称
    @SerializedName("address")
    val address: String? = null,
    //关联地理位置经度
    @SerializedName("lng")
    val lng: Double? = null,
    //关联地理位置纬度
    @SerializedName("lat")
    val lat: Double? = null,
    //详细地址
    @SerializedName("detailaddress")
    val detailaddress: String,
    //评分
    @SerializedName("point")
    val point: Double? = null,
)
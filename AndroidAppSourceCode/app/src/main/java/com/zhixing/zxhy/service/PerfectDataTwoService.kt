package com.zhixing.zxhy.service

import androidx.annotation.Keep
import com.google.gson.annotations.SerializedName
import com.zhixing.network.base.NetUrl
import com.zhixing.network.model.BaseResponse
import retrofit2.Call
import retrofit2.http.Body
import retrofit2.http.Header
import retrofit2.http.Headers
import retrofit2.http.POST

interface PerfectDataTwoService {

    /**
     * 获取新用户表单问题
     */
    @POST(NetUrl.GET_NEW_USER_FROM_DATA)
    fun getNewUserFromData(@Header("token") token: String? = null): Call<BaseResponse>

    /**
     * 提交新用户信息二
     */
    @Headers("Content-Type: application/json;charset=UTF-8")
    @POST(NetUrl.SUBMIT_BASE_DATA_TWO)
    fun submitBaseDataTwo(
        @Header("token") token: String? = null,
        @Body answer: QuestionAnswerArray
    ): Call<BaseResponse>

}

/**
 * 表单答案
 */
@Keep
data class QuestionAnswerArray(
    @SerializedName("jsonstr")
    val jsonstr: Array<QuestionAnswerItem>
) {
    @Keep
    data class QuestionAnswerItem(
        @SerializedName("quesid")
        val quesid: Int,
        @SerializedName("ans")
        var ans: String
    )

    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (javaClass != other?.javaClass) return false

        other as QuestionAnswerArray

        if (!jsonstr.contentEquals(other.jsonstr)) return false

        return true
    }

    override fun hashCode(): Int {
        return jsonstr.contentHashCode()
    }
}
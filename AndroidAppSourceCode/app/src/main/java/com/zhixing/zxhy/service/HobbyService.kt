package com.zhixing.zxhy.service

import com.google.gson.annotations.SerializedName
import com.zhixing.network.base.NetUrl
import com.zhixing.network.model.BaseResponse
import retrofit2.Call
import retrofit2.http.Body
import retrofit2.http.Headers
import retrofit2.http.POST

interface HobbyService {

    /**
     * 获取用户标签信息
     */
    @POST(NetUrl.GET_USER_TAG_LIST)
    fun getUserTagList(): Call<BaseResponse>

    /**
     * 设置用户标签信息
     */
    @Headers("Content-Type: application/json;charset=UTF-8")
    @POST(NetUrl.SET_USER_TAG_LIST)
    fun setUserTagList(@Body setUserTagListData: SetUserTagListData): Call<BaseResponse>

}

/**
 * 设置用户标签信息的数据
 */
data class SetUserTagListData(
    @SerializedName("tagids")
    val tagids: Array<Int>
) {
    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (javaClass != other?.javaClass) return false

        other as SetUserTagListData

        if (!tagids.contentEquals(other.tagids)) return false

        return true
    }

    override fun hashCode(): Int {
        return tagids.contentHashCode()
    }
}
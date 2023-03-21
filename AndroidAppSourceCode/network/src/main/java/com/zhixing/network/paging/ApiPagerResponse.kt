package com.zhixing.network.paging

import java.io.Serializable
import androidx.annotation.Keep

/**
 * 服务器返回的列表数据的基类
 */
@Keep
data class ApiPagerResponse<T>(
    //列表数据
    var list: List<T>,
    //总数量
    val totalnum: Int,
    //总页码
    val totalpage: Int,
    //当前页码
    var currpage: Int,
) : Serializable {
    /**
     * 数据是否为空
     */
    fun isEmpty(): Boolean = list.isEmpty()

    /**
     * 是否为刷新
     */
    fun isRefresh() = currpage == 1

    /**
     * 是否还有更多数据
     */
    fun hasMore() = currpage != totalpage
}




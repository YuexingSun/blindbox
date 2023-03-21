package com.zhixinhuixue.library.net.entity.base

import timber.log.Timber
import java.io.Serializable

/**
 * 服务器返回的列表数据的基类
 */
data class ApiPagerResponse<T> (
    var contents: ArrayList<T>,
    var pageNum: Int,
    var pageSize: Int,
    var total: Int,
    var totalPages: Int,
    var hasMore: Boolean,
) : Serializable {
    /**
     * 数据是否为空
     */
    fun isEmpty() = contents.size == 0

    /**
     * 是否为刷新
     */
    fun isRefresh() = pageNum == 1

    /**
     * 是否还有更多数据
     */
    fun hasMore() = hasMore
}




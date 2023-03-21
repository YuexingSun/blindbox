package com.tuanliu.common.ext

import com.scwang.smart.refresh.layout.SmartRefreshLayout
import com.tuanliu.common.base.BaseHeaderAdapter
import com.tuanliu.common.base.BaseRvAdapter
import com.zhixing.network.paging.ApiPagerResponse

fun SmartRefreshLayout.refresh(refreshAction: () -> Unit = {}): SmartRefreshLayout {
    this.setOnRefreshListener {
        refreshAction.invoke()
    }
    return this
}

fun SmartRefreshLayout.loadMore(loadMoreAction: () -> Unit = {}): SmartRefreshLayout {
    this.setOnLoadMoreListener {
        loadMoreAction.invoke()
    }
    return this
}

/**
 * 列表数据加载成功
 */
fun <T> BaseRvAdapter<T, *>.loadListSuccess(
    baseListNetEntity: ApiPagerResponse<T>,
    smartRefreshLayout: SmartRefreshLayout
) {

    //是否为刷新
    val isRefresh = baseListNetEntity.isRefresh()
    //是否为空数据
    val isEmpty = baseListNetEntity.isEmpty()

    when {
        isRefresh && isEmpty -> {
            //关闭头部刷新
            smartRefreshLayout.finishRefresh()
            //关闭上拉加载功能
            smartRefreshLayout.setEnableLoadMore(false)
            //显示空布局
            setEmpty()
        }
        isRefresh && !isEmpty -> {
            //关闭头部刷新
            smartRefreshLayout.finishRefresh()
            //关闭上拉加载功能
            smartRefreshLayout.setEnableLoadMore(true)
            //如果是第一页 设置最新数据替换
            setData(baseListNetEntity.list)
        }
        !isRefresh -> {
            //关闭尾部刷新
            smartRefreshLayout.finishLoadMore()
            //不是第一页，累加数据
            addData(baseListNetEntity.list)
        }
    }

    //如果还有下一页数据 那么设置smartRefreshLayout还可以加载更多数据
    if (baseListNetEntity.hasMore()) {
        smartRefreshLayout.finishLoadMore()
        /**
         * [setNoMoreData]是否加载完了数据
         * false 还有更多
         * true 没有更多
         *
         * 这里主要解决和顶部的Magic指示器联动产生的hasMore没有重新刷新的问题
         */
        smartRefreshLayout.setNoMoreData(false)
    } else {
        //如果没有更多数据了，设置smartRefreshLayout加载完毕 没有更多数据
        smartRefreshLayout.finishLoadMoreWithNoMoreData()
    }
}

/**
 * 列表数据加载成功
 */
fun <T> BaseHeaderAdapter<T, *, *, *>.loadListSuccess(
    baseListNetEntity: ApiPagerResponse<T>,
    smartRefreshLayout: SmartRefreshLayout
) {

    //是否为刷新
    val isRefresh = baseListNetEntity.isRefresh()
    //是否为空数据
    val isEmpty = baseListNetEntity.isEmpty()

    when {
        isRefresh && isEmpty -> {
            //关闭头部刷新
            smartRefreshLayout.finishRefresh()
            //关闭上拉加载功能
            smartRefreshLayout.setEnableLoadMore(false)
            //显示空布局
            setEmpty()
        }
        isRefresh && !isEmpty -> {
            //关闭头部刷新
            smartRefreshLayout.finishRefresh()
            //关闭上拉加载功能
            smartRefreshLayout.setEnableLoadMore(true)
            //如果是第一页 设置最新数据替换
            setData(baseListNetEntity.list)
        }
        !isRefresh -> {
            //关闭尾部刷新
            smartRefreshLayout.finishLoadMore()
            //不是第一页，累加数据
            addData(baseListNetEntity.list)
        }
    }

    //如果还有下一页数据 那么设置smartRefreshLayout还可以加载更多数据
    if (baseListNetEntity.hasMore()) {
        smartRefreshLayout.finishLoadMore()
        /**
         * [setNoMoreData]是否加载完了数据
         * false 还有更多
         * true 没有更多
         *
         * 这里主要解决和顶部的Magic指示器联动产生的hasMore没有重新刷新的问题
         */
        smartRefreshLayout.setNoMoreData(false)
    } else {
        //如果没有更多数据了，设置smartRefreshLayout加载完毕 没有更多数据
        smartRefreshLayout.finishLoadMoreWithNoMoreData()
    }
}

/**
 * 列表数据加载成功
 */
fun <T> BaseRvAdapter<T, *>.loadListSuccess(
    //是否是刷新
    isRefresh: Boolean,
    //是否为空数据
    isEmpty: Boolean,
    //是否还有更多数据
    hasMore: Boolean,
    list: List<T>,
    smartRefreshLayout: SmartRefreshLayout
) {

    when {
        isRefresh && isEmpty -> {
            //关闭头部刷新
            smartRefreshLayout.finishRefresh()
            //关闭上拉加载功能
            smartRefreshLayout.setEnableLoadMore(false)
            //显示空布局
            setEmpty()
        }
        isRefresh && !isEmpty -> {
            //关闭头部刷新
            smartRefreshLayout.finishRefresh()
            //关闭上拉加载功能
            smartRefreshLayout.setEnableLoadMore(true)
            //如果是第一页 设置最新数据替换
            setData(list)
        }
        !isRefresh -> {
            //关闭尾部刷新
            smartRefreshLayout.finishLoadMore()
            //不是第一页，累加数据
            addData(list)
        }
    }

    //如果还有下一页数据 那么设置smartRefreshLayout还可以加载更多数据
    if (hasMore) {
        smartRefreshLayout.finishLoadMore()
        /**
         * [setNoMoreData]是否加载完了数据
         * false 还有更多
         * true 没有更多
         *
         * 这里主要解决和顶部的Magic指示器联动产生的hasMore没有重新刷新的问题
         */
        smartRefreshLayout.setNoMoreData(false)
    } else {
        //如果没有更多数据了，设置smartRefreshLayout加载完毕 没有更多数据
        smartRefreshLayout.finishLoadMoreWithNoMoreData()
    }
}

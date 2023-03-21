package com.zhixing.zxhy.view_model

import android.util.Log
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import com.hjq.toast.ToastUtils
import com.scwang.smart.refresh.layout.SmartRefreshLayout
import com.tuanliu.common.base.BaseViewModel
import com.tuanliu.common.net.onBizError
import com.tuanliu.common.net.onBizOK
import com.tuanliu.common.net.onFailure
import com.tuanliu.common.net.onSuccess
import com.tuanliu.common.util.SingleLiveEvent
import com.zhixing.network.ext.serverData
import com.zhixing.network.paging.ApiPagerResponse
import com.zhixing.zxhy.ArticleDetailsData
import com.zhixing.zxhy.CommentListData
import com.zhixing.zxhy.InformationData
import com.zhixing.zxhy.repo.ArticleDetailsRepo
import com.zhixing.zxhy.repo.HomeRepo
import com.zhixing.zxhy.repo.MyCollectRepo
import com.zhixing.zxhy.service.*
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class ArticleDetailsViewModel : BaseViewModel() {

    //评论数量
    val commentnumber = MutableLiveData<Int>(0)

    //文章id
    var id: Int = 0

    //文章详情
    private val _detailsLiveData = MutableLiveData<ArticleDetailsData>()
    val detailsLiveData: LiveData<ArticleDetailsData>
        get() = _detailsLiveData

    /**
     * 获取文章详情
     */
    fun inforGetDetailData() = serverAwait {
        ArticleDetailsRepo.inforGetDetailData(InforDetailBody(id)).serverData().onSuccess {
            onBizError { code, message ->
                Log.e("xxx", "获取文章详情 接口异常 $code $message")
            }
            onBizOK<ArticleDetailsData> { code, data, message ->
                _detailsLiveData.postValue(data)
                commentnumber.postValue(data?.commentnumber ?: 0)
            }
        }.onFailure {
            Log.e("xxx", "获取文章详情 接口异常 $it")
        }
    }

    //收藏 / 取消收藏
    private val _inforFavActicleLiveData = MutableLiveData<String>()
    val inforFavActicleLiveData: LiveData<String>
        get() = _inforFavActicleLiveData

    /**
     * 取消收藏
     * [id] 文章id
     */
    fun inforFavActicle() = serverAwait {
        ArticleDetailsRepo.informationFavActicle(InforFavActicleBody(id))
            .serverData().onSuccess {
                onBizError { code, message ->
                    Log.e("xxx", "取消收藏 接口异常 $code $message")
                }
                onBizOK<Any> { code, data, message ->
                    _inforFavActicleLiveData.postValue(System.currentTimeMillis().toString())
                }
            }.onFailure {
                Log.e("xxx", "取消收藏 接口异常 $it")
            }
    }

    //点赞 / 取消点赞
    private val _inforLikeArticleLiveData = MutableLiveData<String>()
    val inforLikeArticleLiveData: LiveData<String>
        get() = _inforLikeArticleLiveData

    /**
     * 点赞 / 取消点赞
     * [id] 文章id
     */
    fun inforLikeArticle() = serverAwait {
        ArticleDetailsRepo.informationLikeArticle(InforLikeArticleBody(id))
            .serverData().onSuccess {
                onBizError { code, message ->
                    Log.e("xxx", "点赞 / 取消点赞 接口异常 $code $message")
                }
                onBizOK<Any> { code, data, message ->
                    _inforLikeArticleLiveData.postValue(System.currentTimeMillis().toString())
                }
            }.onFailure {
                Log.e("xxx", "点赞 / 取消点赞 接口异常 $it")
            }
    }

    //评论列表数据
    private val _inforCommentListLiveData = MutableLiveData<ApiPagerResponse<CommentListData>>()
    val inforCommentListLiveData: LiveData<ApiPagerResponse<CommentListData>>
        get() = _inforCommentListLiveData
    private var commentListPage = 1

    /**
     * 获取评论列表
     */
    fun inforGetCommentList(
        smartRefreshLayout: SmartRefreshLayout,
        isRefresh: Boolean = true
    ) = serverAwait {

        if (isRefresh) commentListPage = 1

        ArticleDetailsRepo.inforGetCommentList(
            InforCommentListBody(id, commentListPage)
        ).serverData().onSuccess {
            onBizError { code, message ->
                Log.e("xxx", "获取评论列表 接口异常 $code $message")

            }
            onBizOK<ApiPagerResponse<CommentListData>> { code, data, message ->
                if (data?.list?.size ?: 0 != 0) {
                    commentListPage++
                    _inforCommentListLiveData.postValue(data)
                }
            }
        }.onFailure(smartRefreshLayout, isRefresh) {
            Log.e("xxx", "获取评论列表 接口异常 $it")
        }

    }

    //写评论
    private val _inforCreateCommentLiveData = MutableLiveData<CommentListData>()
    val inforCreateCommentLiveData: LiveData<CommentListData>
        get() = _inforCreateCommentLiveData

    /**
     * 写评论
     */
    fun inforCreateComment(content: String, commentid: Int?) = serverAwait {
        ArticleDetailsRepo.inforCreateComment(
            CreateCommentBody(id, content, commentid)
        ).serverData().onSuccess {
            onBizError { code, message ->
                Log.e("xxx", "写评论 接口异常 $code $message")

            }
            onBizOK<CommentListData> { code, data, message ->
                _inforCreateCommentLiveData.postValue(data)
            }
        }.onFailure {
            Log.e("xxx", "写评论 接口异常 $it")
        }
    }

    /**
     * 写评论 评论子项用
     */
    fun inforCreateCommentIndex(
        content: String,
        commentid: Int,
        block: (replyList: CommentListData.Replylist) -> Unit
    ) = serverAwait {
        ArticleDetailsRepo.inforCreateComment(
            CreateCommentBody(id, content, commentid)
        ).serverData().onSuccess {
            onBizError { code, message ->
                Log.e("xxx", "写评论 接口异常 $code $message")

            }
            onBizOK<CommentListData> { code, data, message ->
                launch(Dispatchers.Main) {
                    if (data == null) return@launch
                    ToastUtils.show("回复成功")
                    block(
                        CommentListData.Replylist(
                            data.avatar,
                            data.content,
                            data.ismine,
                            data.nickname,
                            data.replyid,
                            data.sendtime,
                            data.commentid
                        )
                    )
                }
            }
        }.onFailure {
            Log.e("xxx", "写评论 接口异常 $it")
        }
    }

    /**
     * 删除评论/回复
     * [id] 评论/回复id
     */
    fun inforDeleteComment(
        id: Int,
        block: () -> Unit
    ) = serverAwait {
        ArticleDetailsRepo.inforDeleteComment(
            InforDeleteBody(id)
        ).serverData().onSuccess {
            onBizError { code, message ->
                Log.e("xxx", "删除评论 接口异常 $code $message")
            }
            onBizOK<Any> { code, data, message ->
                launch(Dispatchers.Main) {
                    if (data == null) return@launch
                    ToastUtils.show("删除成功")
                    block()
                }
            }
        }.onFailure {
            Log.e("xxx", "删除评论 接口异常 $it")
        }
    }

    //举报 评论/回复/文章
    private val _inforReportLiveData = SingleLiveEvent<String>()
    val inforReportLiveData: LiveData<String>
        get() = _inforReportLiveData

    /**
     * 举报评论/回复
     * [id] 评论/回复id
     */
    fun inforReportComment(
        id: Int
    ) = serverAwait {
        ArticleDetailsRepo.inforReportComment(
            InforReportBody(id)
        ).serverData().onSuccess {
            onBizError { code, message ->
                Log.e("xxx", "举报评论/回复 接口异常 $code $message")
            }
            onBizOK<Any> { code, data, message ->
                _inforReportLiveData.postValue(System.currentTimeMillis().toString())
            }
        }.onFailure {
            Log.e("xxx", "举报评论/回复 接口异常 $it")
        }
    }

    /**
     * 举报文章
     */
    fun inforReportComment() = serverAwait {
        ArticleDetailsRepo.inforReportInfo(
            InforReportInfoBody(id)
        ).serverData().onSuccess {
            onBizError { code, message ->
                Log.e("xxx", "举报文章 接口异常 $code $message")
            }
            onBizOK<Any> { code, data, message ->
                _inforReportLiveData.postValue(System.currentTimeMillis().toString())
            }
        }.onFailure {
            Log.e("xxx", "举报文章 接口异常 $it")
        }
    }

    //删除文章
    private val _inforDeleteLD = SingleLiveEvent<Boolean>()
    val inforDeleteLd: LiveData<Boolean>
        get() = _inforDeleteLD

    /**
     * 删除文章
     */
    fun inforDeleteInfo() = serverAwait {
        ArticleDetailsRepo.inforDeleteInfo(
            InforDeleteBody(id)
        ).serverData().onSuccess {
            onBizError { code, message ->
                Log.e("xxx", "删除文章 接口异常 $code $message")
            }
            onBizOK<Any> { code, data, message ->
                _inforDeleteLD.postValue(_detailsLiveData.value?.ismine == 1)
            }
        }.onFailure {
            Log.e("xxx", "删除文章 接口异常 $it")
        }
    }

}
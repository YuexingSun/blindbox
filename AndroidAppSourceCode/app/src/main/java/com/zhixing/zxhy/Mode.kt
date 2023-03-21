package com.zhixing.zxhy

import android.os.Parcelable
import androidx.annotation.Keep
import kotlinx.parcelize.Parcelize

/**
 * 首页信息流列表数据
 */
@Keep
data class InformationData(
    //头像
    val avatar: String = "",
    //轮播图列表
    val bannerlist: List<String>,
    //轮播图数量
    val bannernumber: Int = 0,
    //评价数量
    val commentnumber: Int = 0,
    //富文本内容
    val content: String = "",
    //文章id 词条id
    val id: Int,
    //是否已点赞 0否 1是
    val isliked: Int = 0,
    //点赞数量
    val likenumber: Int = 0,
    //用户昵称
    val nickname: String = "",
    //文章发送时间
    val sendtime: String = "",
    //文章标题/词条标题
    val title: String = "",
    //1文章 2词条
    val type: Int = 1,
    //词条的图片
    val banner: String = "",
    //词条的背景
    val bgimg: String = "",
    //词条的副标题
    val subtitle: String = "",
    //词条按钮上显示的文字
    val btntxt: String = ""
)

/**
 * 我收藏的文章列表数据
 */
@Keep
data class InforMyFavData(
    //头像
    val avatar: String = "",
    //图片
    val banner: String = "",
    //文章id
    val id: Int,
    //作者昵称
    val nickname: String = "",
    //发布时间
    val sendtime: String = "",
    //标题
    val title: String = ""
)

/**
 * 文章详情数据
 */
@Keep
data class ArticleDetailsData(
    //头像
    val avatar: String = "",
    //轮播图
    val bannerlist: List<String>,
    //轮播图数量
    val bannernumber: Int = 0,
    //评价数量
    val commentnumber: Int = 0,
    //文章内容
    val content: String = "",
    //收藏数量
    val favnumber: Int = 0,
    //到过的人的头像
    val gotavatarlist: List<String>?,
    //复制链接的h5链接
    val h5url: String = "",
    //文章id
    val id: Int,
    //是否已经收藏了 0否 1是
    val isfaved: Int = 0,
    //自己是否已经点赞 0否 1是
    val isliked: Int = 0,
    //是否是自己发布的文章 0否 1是
    val ismine: Int = 0,
    //点赞数量
    val likenumber: Int = 0,
    val location: Location,
    //用户昵称
    val nickname: String = "",
    //发布时间
    val sendtime: String = "",
    //标题
    val title: String = ""
) {
    data class Location(
        //地点名称
        val address: String = "",
        val lat: Double = 0.0,
        val lng: Double = 0.0,
        //详细地址
        val detailaddress: String = "",
        //评分
        val point: Float = 0.0f
    )
}

/**
 * 评论列表数据
 */
@Keep
data class CommentListData(
    //头像
    val avatar: String = "",
    //评论的id
    val commentid: Int,
    //内容
    val content: String = "",
    //是否是自己发的评论 0否 1是
    val ismine: Int = 0,
    //昵称
    val nickname: String = "",
    //回复列表
    val replylist: List<Replylist>?,
    //发送时间
    val sendtime: String = "",
    //二级评论的id
    val replyid: Int = 0
) {
    data class Replylist(
        val avatar: String = "",
        val content: String = "",
        val ismine: Int = 0,
        val nickname: String = "",
        //回复人的id
        val replyid: Int,
        val sendtime: String = "",
        //评论id
        val commentid: Int = 0,
        //回复人的昵称
        val commentnickname: String = ""
    )
}

/**
 * 信息流搜索列表数据
 */
@Keep
data class InforSearchData(
    val banner: String = "",
    val id: Int,
    val title: String = ""
)

/**
 * 我发布的文章数据
 */
@Keep
data class MyInfoData(
    val banner: String = "",
    val id: Int,
    val title: String = ""
)

/**
 * 上传多个文件
 */
@Keep
data class UploadMultFileData(
    val data: ImgList,
    //接口状态码
    val code: Int,
    //接口出错消息
    val msg: String = ""
) {
    data class ImgList(
        //上传的照片列表
        val urllist: List<String>?
    )
}

/**
 * 发布/修改文章后的文章id
 */
@Keep
data class SendInfoData(
    val id: Int,
)

/**
 * 搜索地址返回的数据
 */
@Keep
data class SeekLocaData(
    //地址名称
    val address: String,
    //详细地址
    val detailAddress: String,
    //经度
    val lng: Double,
    //纬度
    val lat: Double,
    //评分
    val point: Double = 0.0
)

/**
 * 可选分类数据
 */
@Keep
data class BoxCateTypesData(
    //内容列表
    val catelist: List<Catelist>?,
    //颜色列表
    val colorlist: List<Colorlist>?
) {
    data class Catelist(
        //分类id
        val cateid: Int,
        //标题
        val title: String
    )

    data class Colorlist(
        //背景颜色
        val bgcolor: String,
        //边缘颜色
        val linecolor: String,
        //文字颜色
        val txtcolor: String
    )
}

/**
 * 改变点赞状态 用于在文章详情页面回来的时候
 */
@Keep
data class ChangeLikeData(
    //是否刷新刷新点赞按钮
    var likeRefresh: Boolean = false,
    //刷新哪个子项
    val refreshPosi: Int = -1,
    //是否是点赞
    val isLike: Boolean = false,
    //点赞数
    val likeNum: Int = 0
)

/**
 * 查看地址页面的数据
 */
@Parcelize
@Keep
data class CheckSiteData(
    val lat: Double = 0.0,
    val lng: Double = 0.0,
    val address: String = "",
    //详细地址
    val detailAddress: String = "",
    //评分
    val point: Float = 0.0f
): Parcelable

/**
 * 首页信息流弹出广告(大霸屏)数据
 */
@Keep
data class InforPopupPicData(
    // 文章详情页的id，外部h5的url
    val `param`: String = "",
    // 图片地址
    val pic: String = "",
    //1显示弹出图片，0不显示
    val showpic: Int,
    //跳转类型, box跳转到开盒页，detail跳转到文章详情页，h5跳转到外部h5页面, none无点击事件
    val targettype: String = "none"
)

/**
 * 获取首页信息流弹出广告(顶部广告)
 */
@Keep
data class InforBannerListData(
    //0无广告，1单图类型，2双图类型
    val bannertype: Int = 0,
    //图片列表
    val list: List<BannerItem>
) {
    data class BannerItem(
        //文章详情页的id或h5的url
        val `param`: String = "",
        //图片地址
        val pic: String = "",
        //跳转类型, box跳转到开盒页，detail跳转到文章详情页，h5打开h5页面, none无点击事件
        val targettype: String = "none"
    )
}



/**
 * 广告弹窗的类型
 */
enum class TargetType(val type: String) {
    /**
     * 跳转到开盒页
     */
    BOX("box"),

    /**
     * 跳转到文章详情
     */
    DETAIL("detail"),

    /**
     * 跳转到内置的webview
     */
    H5("h5"),

    //无点击事件
    NONE("none")
}
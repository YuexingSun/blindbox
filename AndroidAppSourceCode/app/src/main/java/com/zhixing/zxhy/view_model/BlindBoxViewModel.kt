package com.zhixing.zxhy.view_model

import android.os.Parcelable
import android.util.Log
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import com.hjq.toast.ToastUtils
import com.tuanliu.common.base.BaseViewModel
import com.tuanliu.common.util.SingleLiveEvent
import com.zhixing.network.ext.serverData
import com.zhixing.zxhy.repo.BlindBoxRepo
import androidx.annotation.Keep
import com.blankj.utilcode.util.RomUtils
import com.google.gson.annotations.SerializedName
import com.tuanliu.common.net.*
import com.tuanliu.common.util.SpUtilsMMKV
import com.zhixing.zxhy.service.Boxid
import com.tuanliu.common.base.BoxBtnStatus
import com.zhixing.zxhy.BoxCateTypesData
import com.zhixing.zxhy.R
import com.zhixing.zxhy.repo.SetOutRepo
import com.zhixing.zxhy.service.BoxCateTypesBody
import kotlinx.coroutines.Job
import kotlinx.coroutines.async
import kotlinx.coroutines.delay
import kotlinx.parcelize.Parcelize


class BlindBoxViewModel : BaseViewModel() {

    //引导页
    val guideList =
        listOf<@androidx.annotation.DrawableRes Int>(
            R.mipmap.bg_guide_page_1,
            R.mipmap.bg_guide_page_2,
            R.mipmap.bg_guide_page_3
        )

    //店铺图片job
    val storeImgJob = mutableListOf<Job>()

    /**
     * 关闭店铺图片job携程
     */
    fun cancelStoreJob() {
        storeImgJob.forEach { it.cancel() }
    }

    //引导页提示
    val hintGuidePage
        get() = SpUtilsMMKV.getBoolean(CommonConstant.GUIDE_PAGE_HINT) ?: false

    //距离 500 3000 10000
    val distance = MutableLiveData<Int>(3000)

    //地图的缩放比例
    val fourList: List<Float> by lazy {
        if (RomUtils.isVivo())
        //vivo
            listOf<Float>(15.4f, 12.9f, 11f)
        else
        //小米、华为、oppo
            listOf<Float>(16f, 13.5f, 11.7f)
    }

    //预算金额id
    var selectedOneId = 0

    //出行人数id
    var selectedTwoId = 0

    //心情id
    var selectedThreeId = 0

    //预算金额按钮选中的id
    var selectedOneItemId = 0

    //出行人数选中的id
    var selectedTwoItemId = 0

    //心情选中的id
    var selectedThreeItemIdA = -1
    var selectedThreeItemIdB = -1

    //自己去 0 一起去 1
    var selectedThree = 0

    //选择出发的盒子的indexid
    var selectedId: Int = 0
        set(value) {
            _boxGetOneMutableLiveData.value?.parentlist?.forEach { parentlist ->
                if (parentlist.range == distance.value) {
                    field = parentlist.childlist?.get(value)?.indexid ?: 0
                }
            }
        }

    //点击距离的时间间隔不能太小
    private var clickDistanceTime: Long? = null

    /**
     * 距离减小
     */
    fun subtractDistance() {
        if (lat == null || lng == null) {
            ToastUtils.show("暂未获取到地址，请稍后重试")
            return
        }

        if (distance.value == 500) return

        val now = System.currentTimeMillis()
        clickDistanceTime?.let {
            if (now - it < 500) {
                ToastUtils.show("我有些反应不过来啦。")
                return
            }
        }
        clickDistanceTime = now

        when (distance.value) {
            500 -> {
            }
            3000 -> distance.value = 500
            10000 -> distance.value = 3000
        }
    }

    /**
     * 距离放大
     */
    fun addDistance() {
        if (lat == null || lng == null) {
            ToastUtils.show("暂未获取到地址，请稍后重试")
            return
        }

        if (distance.value == 10000) return

        val now = System.currentTimeMillis()
        clickDistanceTime?.let {
            if (now - it < 500) {
                ToastUtils.show("我有些反应不过来啦。")
                return
            }
        }
        clickDistanceTime = now

        when (distance.value) {
            500 -> distance.value = 3000
            3000 -> distance.value = 10000
            10000 -> {
            }
        }
    }

    //出行人数数据
    val tripNumber: List<GetBoxQuesListData.DataItem.Itemdict.Imagelist>?
        get() {
            var list: List<GetBoxQuesListData.DataItem.Itemdict.Imagelist>? = null
            _boxQuesListMutableLiveData.value?.let { boxQuesList ->
                boxQuesList.list?.forEach { quesItem ->
                    if (quesItem.id == 4) {
                        list = quesItem.itemlist
                        return@let
                    }
                }
            } ?: kotlin.run { null }
            return list
        }

    //出行心情数据
    val tripMood: GetBoxQuesListData.DataItem.Itemdict?
        get() {
            var itemDict: GetBoxQuesListData.DataItem.Itemdict? = null
            _boxQuesListMutableLiveData.value?.let { boxQuesList ->
                boxQuesList.list?.forEach { quesItem ->
                    if (quesItem.id == 3) {
                        itemDict = quesItem.itemdict
                        return@let
                    }
                }
            } ?: kotlin.run { null }
            return itemDict
        }

    //出行预算数据
    val tripBudget: List<GetBoxQuesListData.DataItem.Itemdict.Imagelist>?
        get() {
            var list: List<GetBoxQuesListData.DataItem.Itemdict.Imagelist>? = null
            _boxQuesListMutableLiveData.value?.let { boxQuesList ->
                boxQuesList.list?.forEach { quesItem ->
                    if (quesItem.id == 1) {
                        list = quesItem.itemlist
                        return@let
                    }
                }
            } ?: kotlin.run { null }
            return list
        }

    //获取盲盒待答问题数据
    private val _boxQuesListMutableLiveData = SingleLiveEvent<GetBoxQuesListData>()
    val boxQuesListLiveData: LiveData<GetBoxQuesListData>
        get() = _boxQuesListMutableLiveData

    //获取盲盒待答问题
    fun getBoxQuesList() = serverAwait {
        BlindBoxRepo.getBoxQuesList().serverData().onSuccess {
            onBizError { code, message ->
                Log.e("xxx", "获取盲盒待答问题 接口异常 $code $message")
            }
            onBizOK<GetBoxQuesListData> { _, data, _ ->
                _boxQuesListMutableLiveData.postValue(data)
            }
        }.onFailure {
            Log.e("xxx", "获取盲盒待答问题 接口异常 $it")
        }
    }

    /**
     * 是否有未开启和进行中的盲盒 - 刷新专用
     */
    fun checkBeingBoxRefresh(mWordid: Int? = null, mCateid: Int? = null) = serverAwait {
        BlindBoxRepo.checkBeingBox().serverData().onSuccess {
            onBizError { code, message ->
                Log.e("xxx", "是否有未开启和进行中的盲盒 接口异常 $code $message")
            }
            onBizOK<BeingBoxData> { _, data, _ ->
                //有进行中的盲盒
                if (data?.isbeing ?: 0 == 1) {
                    if (data?.status ?: -1 == 1 || data?.status ?: -1 == 2) {
                        data?.boxid?.let { getBoxDetail(it) }
                    }
                } else boxGetOne(mWordid, mCateid)
            }
        }.onFailure {
            Log.e("xxx", "是否有未开启和进行中的盲盒 接口异常 $it")
        }
    }

    /**
     * 是否有未开启和进行中的盲盒
     */
    fun checkBeingBox(getBoxCateTypes: Boolean = false) = serverAwait {
        BlindBoxRepo.checkBeingBox().serverData().onSuccess {
            onBizError { code, message ->
                Log.e("xxx", "是否有未开启和进行中的盲盒 接口异常 $code $message")
            }
            onBizOK<BeingBoxData> { _, data, _ ->
                //有进行中的盲盒
                if (data?.isbeing ?: 0 == 1) {
                    if (data?.status ?: -1 == 1 || data?.status ?: -1 == 2) {
                        data?.boxid?.let { getBoxDetail(it) }
                    }
                } else {
                    canGetBox()
                    //todo 隐藏弹幕
//                    if (getBoxCateTypes) {
//                        async {
//                            delay(5000)
//                            //获取可选分类
//                            getBoxCateTypes()
//                        }.start()
//                    }
                }
            }
        }.onFailure {
            Log.e("xxx", "是否有未开启和进行中的盲盒 接口异常 $it")
        }
    }

    //标识 - 可以获取盲盒了
    var isCanGetBox: Boolean = false
        set(value) {
            if (field != value) {
                field = value
            }
        }

    /**
     * 刷新盒子状态 - 这里会调用获取盲盒接口
     */
    fun canGetBox() {
        if (isCanGetBox)
            setBoxBtnStatus(BoxBtnStatus.RedRefreshIng)
        else isCanGetBox = true
    }

    //获取盲盒
    private val _boxGetOneMutableLiveData = SingleLiveEvent<GetOneBoxData>()
    val boxGetOneLiveData: LiveData<GetOneBoxData>
        get() = _boxGetOneMutableLiveData

    //是否是第一次获取盲盒
    var isFirstBoxOne = true

    /**
     * 获取盲盒
     */
    private fun boxGetOne(mWordid: Int? = null, mCateid: Int? = null) = serverAwait {

        if (lat == null || lng == null) {
            ToastUtils.show("暂未获取到地址，请稍后重试")
            return@serverAwait
        }

        val boxGetOneData = when (selectedThreeItemIdA) {
            //未打开过弹窗 不传参数
            -1 -> BoxGetOneData(1, lng ?: 0.0, lat ?: 0.0, wordid = mWordid, cateid = mCateid)
            else -> {
                if (_boxQuesListMutableLiveData.value == null) {
                    getBoxQuesList()
                    ToastUtils.show("盲盒待答问答数据为空，请点击重试。")
                    return@serverAwait
                }
                val list = arrayListOf<BoxGetOneData.JsonStr>()
                list.add(BoxGetOneData.JsonStr(selectedOneId, selectedOneItemId))
                list.add(BoxGetOneData.JsonStr(selectedTwoId, selectedTwoItemId))
                list.add(
                    BoxGetOneData.JsonStr(
                        selectedThreeId,
                        if (selectedThree == 0) selectedThreeItemIdA else selectedThreeItemIdB
                    )
                )
                BoxGetOneData(
                    1,
                    lng ?: 0.0,
                    lat ?: 0.0,
                    list.toList(),
                    wordid = mWordid,
                    cateid = mCateid
                )
            }
        }

        BlindBoxRepo.boxGetOne(boxGetOneData).serverData().onSuccess {
            onBizError { code, message ->
                Log.e("xxx", "获取盲盒 接口异常 $code $message")
            }
            onBizOK<GetOneBoxData> { _, data, _ ->
                _boxGetOneMutableLiveData.postValue(data)
            }
        }.onFailure {
            Log.e("xxx", "获取盲盒 接口异常 $it")
        }.onExecute {
            boxBtnStatus.postValue(BoxBtnStatus.RedRefreshStop)
        }
    }

    //盲盒详情数据
    private val _boxDetailLiveData = SingleLiveEvent<GetOneBoxData>()
    val boxDetailLiveData: LiveData<GetOneBoxData>
        get() = _boxDetailLiveData

    /**
     * 获取盲盒详情
     */
    private fun getBoxDetail(id: Int) = serverAwait {
        BlindBoxRepo.getBoxDetail(Boxid(id)).serverData().onSuccess {
            onBizError { code, message ->
                Log.e("xxx", "获取盲盒详情 接口异常 $code $message")
            }
            onBizOK<GetOneBoxData> { _, data, _ ->
                boxBtnStatus.postValue(BoxBtnStatus.RedBox)
                _boxDetailLiveData.postValue(data)
            }
        }.onFailure {
            Log.e("xxx", "获取盲盒详情 接口异常 $it")
        }
    }

    //开始一个盲盒
    private val _startBoxMutableLiveData = SingleLiveEvent<GetOneBoxData.Parentlist.Childlist>()
    val startBoxOneLiveData: LiveData<GetOneBoxData.Parentlist.Childlist>
        get() = _startBoxMutableLiveData

    /**
     * 开始一个盲盒
     */
    fun startBox() = serverAwait {

        var boxid = 0
        var childList: GetOneBoxData.Parentlist.Childlist? = null

        _boxGetOneMutableLiveData.value?.parentlist?.forEach parent@{ parentlist ->
            if (parentlist.range == distance.value) {
                parentlist.childlist?.forEach child@{ childlist ->
                    if (childlist.indexid == selectedId) {
                        childList = childlist
                        boxid = childlist.boxid
                        return@parent
                    }
                }
            }
        }

        if (boxid == 0 || selectedId == 0 || childList == null) {
            ToastUtils.show("盲盒出错")
            Log.i("xxx", "盲盒出错 $boxid $selectedId $childList")
            return@serverAwait
        }

        BlindBoxRepo.startBox(StartBox(boxid, selectedId)).serverData().onSuccess {
            onBizError { code, message ->
                Log.e("xxx", "开始一个盲盒 接口异常 $code $message")
            }
            onBizOK<Any> { _, _, _ ->
                _startBoxMutableLiveData.postValue(childList!!)
            }
        }.onFailure {
            Log.e("xxx", "开始一个盲盒 接口异常 $it")
        }
    }

    //不满意原因 选择的map数据
    val selectedMap = mutableMapOf<Int, String>()

    //是否满意 1-满意 2-不满意
    var isLike = 0

    //盲盒评价数据
    private val _enjoyBoxLiveData = SingleLiveEvent<String>()
    val enjoyBoxLiveData: LiveData<String>
        get() = _enjoyBoxLiveData

    //提交评价按钮 - 盲盒评价
    fun submitBtn() = serverAwait {

        val child = _boxDetailLiveData.value?.parentlist?.get(_boxDetailLiveData.value!!.selparentindex)?.childlist?.get(
            _boxDetailLiveData.value!!.selchildindex
        )
        val boxid = child?.boxid ?: return@serverAwait

        if (isLike == 0) ToastUtils.show("请选择评价")

        //有活动的话为活动链接，没有的话就是""
        val lotteryUrl = if (child.activityinfo == 1) child.url else ""

        //满意
        val box = if (isLike == 1) {
            Boxid(boxid)
        } else {

            //如果没选不满意的原因
            if (selectedMap.isEmpty()) {
                ToastUtils.show("请至少选择一项原因")
                return@serverAwait
            }

            //不满意
            var str = ""
            for (map in selectedMap) {
                if (str == "") {
                    str = map.value
                    continue
                }

                str = "$str|${map.value}"
            }
            Boxid(boxid, str)
        }

        SetOutRepo.getBoxEnjoyBox(box).serverData().onSuccess {
            onBizError { code, message ->
                Log.e("xxx", "盲盒评价 接口异常 $code $message")
            }
            onBizOK<Any> { _, _, _ ->
                _enjoyBoxLiveData.postValue(lotteryUrl)
            }
        }.onFailure {
            Log.e("xxx", "盲盒评价 接口异常 $it")
        }.onExecute {
            isLike = 0
        }
    }

    //可选分类数据
    private val _boxCateTypesLD = SingleLiveEvent<BoxCateTypesData>()
    val boxCateTypesLD: LiveData<BoxCateTypesData>
        get() = _boxCateTypesLD

    private var listIndices: IntRange? = _boxCateTypesLD.value?.colorlist?.indices
    private var thisBarrageColor: Int = -1
    private var lastBarrageColor: Int = -1
    //弹幕随机的颜色值
    val barrageColor: BoxCateTypesData.Colorlist?
        get() {
            //thisBarrageColor lastBarrageColor 解决相邻两个弹幕不能相同 最多循环10次
            for (i in 0 until 11) {
                thisBarrageColor = (listIndices)?.random() ?: -1
                if (thisBarrageColor != lastBarrageColor) {
                    lastBarrageColor = thisBarrageColor
                    break
                }
            }
            return _boxCateTypesLD.value?.colorlist?.get(lastBarrageColor)
        }

    /**
     * 获取可选分类
     */
    private fun getBoxCateTypes() = serverAwait {
        BlindBoxRepo.getBoxCateTypes(BoxCateTypesBody(lng, lat)).serverData().onSuccess {
            onBizError { code, message ->
                Log.e("xxx", "获取可选分类 接口异常 $code $message")
            }
            onBizOK<BoxCateTypesData> { _, data, _ ->
                _boxCateTypesLD.postValue(data)
                listIndices = data?.colorlist?.indices
            }
        }.onFailure {
            Log.e("xxx", "获取可选分类 接口异常 $it")
        }
    }

}

/**
 * 获取盲盒待答问题数据
 */
@Keep
data class GetBoxQuesListData(
    val list: List<DataItem>?,
    //问题数量
    val pagenum: Int
) {
    @Keep
    data class DataItem(
        //可选列表中，默认选中的ID - 可以不用
        val defaultid: Int,
        //待答问题的ID
        val id: Int,
        //第一个问题的图片
        val itemdict: Itemdict?,
        //第一个问题的文字
        val itemlist: List<Itemdict.Imagelist>?,
        //标题
        val title: String?,
        //类型
        val type: String?
    ) {
        @Keep
        data class Itemdict(
            //单人出行 的图片
            val imagelist1: List<Imagelist>?,
            //多人出行 的图片
            val imagelist2: List<Imagelist>?
        ) {
            @Keep
            data class Imagelist(
                //是否默认选中 1是 0不是
                val isdefault: Int,
                //选项id
                val itemid: Int,
                //选项名称
                val itemname: String?,
                //未选中图片
                val itempic: String?,
                //选中图片
                val itemselpic: String?,
                //勾的颜色
                val textcolor: String?
            )
        }
    }
}

/**
 * 获取盲盒接口的数据类型
 */
@Parcelize
@Keep
data class GetOneBoxData(
    val parentlist: List<Parentlist>?,
    //选定的首层数据索引
    val selparentindex: Int = 0,
    //选定的首层数据索引
    val selchildindex: Int = 0,
    //盒子心情图片
    val heartimg: String?,
    //盒子心情id
    val heartid: Int?
) : Parcelable {
    @Parcelize
    @Keep
    data class Parentlist(
        val childlist: List<Childlist>?,
        //该组数据的距离 500 3000 10000
        val range: Int
    ) : Parcelable {
        @Parcelize
        @Keep
        data class Childlist(
            //到达前用于显示的地址
            val address: String?,
            //含中固定变量名SJTL1…的文案内容
            val arrivedtext: String?,
            //动态文字的内容
            val arrivedvarlist: List<String>?,
            //开启行程得到的幸运值
            val beinpoint: String?,
            //盲盒的唯一ID
            val boxid: Int,
            //到达前用于显示的位置名称
            val buildName: String?,
            //显示时文字时需要使用的颜色RGB色值
            val colorlist: Colorlist?,
            //参与评价得到的幸运值
            val commentpoint: String?,
            //到达前用于显示的文案文字
            val detail: String?,
            //盲盒有效时间，10位时间戳
            val expiretime: Int,
            //来过人
            val gotlist: List<String>?,
            //来过人数
            val gotnum: Int,
            //不同类型盲盒的顺序ID
            val indexid: Int,
            //盲盒中需要显示的文字信息数组
            val items: List<Item>?,
            //真实坐标,高德坐标系
            val lnglat: Lnglat?,
            //盲盒所属分类的图标
            val logo: String?,
            //电话列表 逗号分割
            val mob: String?,
            //盲盒的显示用图片
            val pic: String?,
            //评分
            val point: Double,
            //目的地的真实地址
            val readAddress: String?,
            //目的地的真实名称
            val realname: String?,
            //分享积分
            val sharepoint: String?,
            //盲盒的标题
            val title: String?,
            //类型图标
            val typelogo: String?,
            //类型名称
            val typename: String?,
            //盲盒状态
            val status: Int?,
            //盲盒评价 0未评价 1满意 2不满意
            val islike: Int?,
            //评价内容
            val mycommentlist: List<String>?,
            //是否有抽奖活动正在进行 0没有 1有
            val activityinfo: Int = 0,
            //抽奖活动链接
            val url: String = ""
        ) : Parcelable {
            @Parcelize
            @Keep
            data class Colorlist(
                //文案的背景颜色
                val bgcolor: String?,
                //文案的文字颜色
                val textcolor: String?,
                //文案中动态文字的颜色
                val varcolor: String?
            ) : Parcelable

            @Parcelize
            @Keep
            data class Item(
                //列表左侧文字
                val item: String?,
                //列表要显示的项目，用于方便前端显示对应的图标，暂定4种类型：1距离，2人均消费，3新秘感，4新鲜感
                val type: Int,
                //列表右侧文字
                val value: String?
            ) : Parcelable

            @Parcelize
            @Keep
            data class Lnglat(
                //纬度
                val lat: Double,
                //经度
                val lng: Double
            ) : Parcelable
        }
    }
}

/**
 * 获取盲盒所需的数据
 */
@Parcelize
data class BoxGetOneData(
    @SerializedName("typeid")
    val typeid: Int,
    @SerializedName("lng")
    val lng: Double,
    @SerializedName("lat")
    val lat: Double,
    @SerializedName("jsonstr")
    val jsonstr: List<JsonStr>? = null,
    //词条开盒的话是词条开盒的id
    @SerializedName("wordid")
    val wordid: Int? = null,
    //品类开盒的话是品类开盒的id
    @SerializedName("cateid")
    val cateid: Int? = null,
) : Parcelable {
    @Parcelize
    data class JsonStr(
        @SerializedName("quesid")
        val quesid: Int,
        @SerializedName("ans")
        val ans: Int
    ) : Parcelable
}

/**
 * 开始一个盲盒请求需要携带的数据
 */
data class StartBox(
    @SerializedName("boxid")
    val boxid: Int,
    @SerializedName("indexid")
    val indexid: Int
)


/**
 * 是否有未开启和进行中的盲盒
 */
@Keep
data class BeingBoxData(
    //如果有，则此值为盲盒的ID
    val boxid: Int,
    //是否有待开启或者进行中的盲盒，0没有，1有
    val isbeing: Int,
    //如果有，则此值为该盲盒的当前状态  1进行中 2未评价 - 已完成 3已完成 45已失效
    val status: Int
)
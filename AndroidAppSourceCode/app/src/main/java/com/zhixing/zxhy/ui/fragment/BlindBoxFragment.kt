package com.zhixing.zxhy.ui.fragment

import android.graphics.Color
import android.os.Bundle
import android.text.method.LinkMovementMethod
import android.util.Log
import android.view.Gravity
import android.view.MotionEvent
import android.view.View
import android.view.animation.LinearInterpolator
import android.widget.Button
import android.widget.ImageView
import android.widget.RatingBar
import android.widget.TextView
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.constraintlayout.widget.Group
import androidx.core.content.ContextCompat
import androidx.lifecycle.lifecycleScope
import androidx.navigation.fragment.findNavController
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.RecyclerView
import androidx.viewpager2.widget.ViewPager2
import com.airbnb.lottie.LottieAnimationView
import com.amap.api.location.AMapLocation
import com.amap.api.location.AMapLocationClient
import com.amap.api.location.AMapLocationClientOption
import com.amap.api.location.AMapLocationListener
import com.amap.api.maps.AMap
import com.amap.api.maps.CameraUpdateFactory
import com.amap.api.maps.model.*
import com.blankj.utilcode.util.ArrayUtils
import com.google.android.material.imageview.ShapeableImageView
import com.hjq.toast.ToastUtils
import com.linx.common.ext.addTo
import com.noober.background.drawable.DrawableCreator
import com.tuanliu.common.base.*
import com.tuanliu.common.ext.*
import com.tuanliu.common.net.CommonConstant
import com.tuanliu.common.util.SpUtilsMMKV
import com.zhixing.zxhy.R
import com.zhixing.zxhy.databinding.FragmentBlindBoxBinding
import com.zhixing.zxhy.databinding.ViewTripBtnBinding
import com.zhixing.zxhy.view_model.*
import com.tuanliu.common.util.ImmersionBarUtil.changeNaviColor
import com.zhixing.zxhy.BoxCateTypesData
import com.zhixing.zxhy.databinding.ViewBarrageTextBinding
import com.zhixing.zxhy.ui.activity.WebActivity
import com.zhixing.zxhy.util.*
import com.zhixing.zxhy.util.mapUtil.AMapUtil
import com.zhixing.zxhy.util.mapUtil.MarkerUtil
import com.zhixing.zxhy.util.recyclerView.MadelGridDecoration
import com.zhixing.zxhy.util.toPermission.ToLocation
import com.zhixing.zxhy.widget.LaneLayoutManager
import com.zhpan.bannerview.BannerViewPager
import com.zhpan.bannerview.BaseBannerAdapter
import com.zhpan.bannerview.BaseViewHolder
import com.zhpan.bannerview.constants.PageStyle
import com.zhpan.indicator.IndicatorView
import com.zhpan.indicator.enums.IndicatorSlideMode
import de.hdodenhof.circleimageview.CircleImageView
import kotlinx.coroutines.*
import kotlinx.coroutines.flow.launchIn
import per.goweii.anylayer.AnyLayer
import per.goweii.anylayer.Layer
import per.goweii.anylayer.widget.SwipeLayout
import timber.log.Timber

/**
 * 盲盒页面
 */
class BlindBoxFragment : BaseDbFragment<BlindBoxViewModel, FragmentBlindBoxBinding>(),
    AMapLocationListener {

    companion object {
        private val selectedList =
            listOf<String>("以前来过", "不喜欢这个地方", "导航不清晰", "太好猜", "时间不准确", "找不到店")
    }

    //屏幕宽度
    private val screenWidthThree = getScreenWidth() * 3
    private val screenWidth40 = getScreenWidth() + 40.dp

    //匀速差值器
    private val linearInterpolator = LinearInterpolator()

    //地图控制器对象
    private lateinit var aMap: AMap

    //圆
    private var circle: Circle? = null

    //高德定位服务客户端
    private val mLocationClient: AMapLocationClient by lazy {
        AMapLocationClient(requireContext())
    }

    //高德地图定位参数
    private val mLocationOption: AMapLocationClientOption by lazy {
        AMapLocationClientOption()
    }

    //拿到屏幕的宽度
    private val windowsWidth by lazy { resources.displayMetrics.widthPixels }

    //定位
    private val toLocation by lazy { ToLocation(this@BlindBoxFragment) }

    //心情轮播控件 第一个
    private var bannerVp: BannerViewPager<GetBoxQuesListData.DataItem.Itemdict.Imagelist>? = null

    //心情轮播控件 第二个
    private var bannerVpB: BannerViewPager<GetBoxQuesListData.DataItem.Itemdict.Imagelist>? = null

    //出行选择控件
    private var bannerVpSele: BannerViewPager<GetOneBoxData.Parentlist.Childlist>? = null

    //到达弹窗
    private var arriveLayer: Layer? = null

    //蓝点样式
    private val myLocationStyle by lazy {
        MyLocationStyle()
            .strokeColor(
                ContextCompat.getColor(
                    requireContext(),
                    R.color.transparent
                )
            )
            .radiusFillColor(
                ContextCompat.getColor(
                    requireContext(),
                    R.color.transparent
                )
            )
            .strokeWidth(0f)
            .anchor(0.5f, 0.5f)
    }

    override fun initView(savedInstanceState: Bundle?) {
        mDataBind.apply {
            vm = mViewModel

            //选择出行场景
            Scene.setOnClickListener {
                if (!sceneAnyLayer.isShown) sceneAnyLayer.show()
            }

            //todo 隐藏弹幕
//            barrageInit()

            initLocation()
            initAMap()
        }
    }

    override fun initLiveData() {
        mViewModel.apply {

            //打开盲盒 - 调用获取盲盒接口
            BaseViewModel.openBoxGetOne.observerKt {
                //清除地图店铺标点
                aMap.mapScreenMarkers.forEach {
                    if (!it.isFlat) it.remove()
                }
                mViewModel.checkBeingBoxRefresh()
            }

            //查询是否有未开启和进行中的盲盒
            BaseViewModel.updateCheckBeingBox.observerKt {
                checkBeingBox()
            }

            //网络状态改变
            BaseViewModel.netWorkStatusChange.observeInFragment(this@BlindBoxFragment) {
                if (!isCanGetBox) {
                    //是否有进行中的盲盒
                    checkBeingBox()
                }
                //开始定位
                mLocationClient.startLocation()
            }

            //显示距离
            distance.observerKt {
                initMarkerAMap(
                    if (BaseViewModel.lat == null || BaseViewModel.lng == null) null else LatLng(
                        BaseViewModel.lat!!,
                        BaseViewModel.lng!!
                    )
                )
                //改变右上角的图片
                mDataBind.Hint.setImageResource(
                    when (it) {
                        500 -> R.mipmap.ic_hint_500
                        3000 -> R.mipmap.ic_hint_3000
                        else -> R.mipmap.ic_hint_10000
                    }
                )
            }

            //获取盲盒待答问题
            boxQuesListLiveData.observerKt { boxQuesListData ->
                //出行预算
                tripBudget?.let { dataItem ->
                    btnOneAdapter.setData(dataItem)
                }
                //刷新出行人数控件和预算
                initTripNumberMood(sceneAnyLayer)

                //保存id
                boxQuesListData?.list?.forEach { dataItem ->
                    when (dataItem.id) {
                        4 -> selectedTwoId = dataItem.id
                        3 -> selectedThreeId = dataItem.id
                        1 -> selectedOneId = dataItem.id
                    }
                }
            }

            //获取盲盒
            boxGetOneLiveData.observerKt { getOneBoxData ->
                if (mDataBind.Hint.isGone()) controlAppear()
                if (mDataBind.JourneyDialog.isVisible()) mDataBind.JourneyDialog.gone()
                setAMapLocationStyle(getOneBoxData?.heartimg.toString())

                //第一次的时候刷新地图 后面只更新绘制店铺
                when (isFirstBoxOne) {
                    true -> {
                        initMarkerAMap(
                            LatLng(BaseViewModel.lat!!, BaseViewModel.lng!!),
                        )
                        isFirstBoxOne = false
                    }
                    false -> drawStore(
                        mViewModel.distance.value ?: 500,
                        mViewModel.boxGetOneLiveData.value
                    )
                }
            }

            //获取盲盒详情
            boxDetailLiveData.observerKt { getOneBoxData ->
                val listData =
                    getOneBoxData?.parentlist?.get(getOneBoxData.selparentindex)?.childlist?.get(
                        getOneBoxData.selchildindex
                    )
                when (listData?.status) {
                    //1 - 进行中弹窗
                    1 -> mDataBind.JourneyDialog.apply {
                        //顶部背景
                        findViewById<ShapeableImageView>(R.id.TypePic)
                            .glideDefault(
                                requireContext(),
                                (listData.pic ?: "").fillHW(594, 933),
                                false
                            )
                        //品类标签
                        findViewById<ImageView>(R.id.Type).glideDefault(
                            requireContext(),
                            listData.typelogo ?: "",
                            false
                        )
                        //标题
                        findViewById<TextView>(R.id.StoreName).text = listData.title ?: ""
                        //详情
                        findViewById<TextView>(R.id.TypeDescribe).text = listData.detail ?: ""
                        listData.items?.forEach { item ->
                            when (item.type ?: 0) {
                                //实时距离
                                1 -> {
                                    findViewById<TextView>(R.id.Distance).text =
                                        item.value.toString()
                                    findViewById<TextView>(R.id.TextA).text = item.item.toString()
                                }
                                //人均消费
                                2 -> {
                                    //金额
                                    findViewById<TextView>(R.id.Cost).apply {
                                        movementMethod = LinkMovementMethod.getInstance()
                                        text = item.value.toString().differentTestSize(0, 1, 0.66f)
                                    }
                                    findViewById<TextView>(R.id.TextB).text = item.item.toString()
                                }
                                //神秘感
                                3 -> {
                                    findViewById<RatingBar>(R.id.MysteryNum).rating =
                                        item.value.toString().toFloat()
                                    findViewById<TextView>(R.id.TextD).text = item.item.toString()
                                }
                                //新鲜感
                                4 -> {
                                    findViewById<RatingBar>(R.id.NewNum).rating =
                                        item.value.toString().toFloat()
                                    findViewById<TextView>(R.id.TextC).text = item.item.toString()
                                }
                            }
                        }
                        //继续行程
                        findViewById<Button>(R.id.Btn).setOnClickListener {
                            this.gone()
                            skipSetOutFragment(listData, true)
                        }
                        mDataBind.Element.gone()
                        this.visible()
                    }
                    //2 - 未评价 - 已完成
                    2 -> arriveNewAnyLayer(listData)
                }
            }

            //盲盒启程
            startBoxOneLiveData.observerKt { childList ->
                childList?.let { skipSetOutFragment(it) }
            }

            //盲盒评价
            enjoyBoxLiveData.observerKt {
                if (evaluateAnyLayer != null && evaluateAnyLayer?.isShown == true) evaluateAnyLayer!!.dismiss()
                if (arriveLayer?.isShown == true) {
                    arriveLayer!!.dismiss()
                    arriveLayer = null
                }
                canGetBox()
                ToastUtils.show("评价成功")
                if (it?.isNotBlank() == true) {
                    lifecycleScope.launch {
                        delay(300)
                        WebActivity.start(requireContext(), it)
                    }
                }
            }

            //获取可选分类
            boxCateTypesLD.observerKt {
                it?.let {
                    //分割数组，上下各一半
                    val allSize = it.catelist?.size ?: return@observerKt
                    val aSize = allSize / 2
                    val aList = ArrayUtils.subArray(
                        it.catelist.toTypedArray(),
                        0,
                        aSize
                    )
                    val bList = ArrayUtils.subArray(
                        it.catelist.toTypedArray(),
                        aSize,
                        allSize
                    )
                    barrageAdapter.setData(aList?.toList())
                    barrageAdapterB.setData(bList?.toList())
                    mDataBind.BarrageRecyc.visible()
                    mDataBind.BarrageRecycB.visible()
                    lifecycleScope.launch {
                        //留点时间加载数据
                        delay(1000)
                        mDataBind.BarrageRecyc.smoothScrollBy(
                            screenWidth40,
                            0,
                            null,
                            2000
                        )
                        mDataBind.BarrageRecycB.smoothScrollBy(
                            screenWidth40,
                            0,
                            null,
                            2000
                        )
                        delay(2100)
                        //开始滚动
                        countdown(Long.MAX_VALUE, 10000) {
                            mDataBind.BarrageRecyc.smoothScrollBy(
                                (screenWidthThree * 1.5).toInt(),
                                0,
                                linearInterpolator,
                                20000
                            )
                            mDataBind.BarrageRecycB.smoothScrollBy(
                                screenWidthThree,
                                0,
                                linearInterpolator,
                                20000
                            )
                        }.launchIn(lifecycleScope)
                    }
                }
            }

        }
    }

    override fun initNetRequest() {
        mViewModel.apply {
            //引导页是否出现过
            if (!hintGuidePage) guidePageHintAnyLayer()

            getBoxQuesList()
            //是否有进行中的盲盒
            checkBeingBox(true)
        }
    }

    /**
     * 初始化弹幕相关的内容
     */
    private fun barrageInit() {
        mDataBind.apply {
            BarrageRecyc.apply {
                layoutManager = LaneLayoutManager().apply {
                    horizontalGap = 16
                    verticalGap = 0
                }
                //添加子项的点击事件 这里要用这个触摸的，不然在移动中无法监听到
                addOnItemTouchListener(object : RecyclerView.OnItemTouchListener {
                    override fun onInterceptTouchEvent(rv: RecyclerView, e: MotionEvent): Boolean {
                        val child = rv.findChildViewUnder(e.x, e.y) ?: return true
                        val position = rv.getChildViewHolder(child).bindingAdapterPosition
                        val itemList = barrageAdapter.getItems()
                        clearMapGetOne(mCateid = itemList[position % itemList.size].cateid)
                        return true
                    }

                    override fun onTouchEvent(rv: RecyclerView, e: MotionEvent) {}

                    override fun onRequestDisallowInterceptTouchEvent(disallowIntercept: Boolean) {}
                })
                adapter = barrageAdapter
            }
            BarrageRecycB.apply {
                layoutManager = LaneLayoutManager().apply {
                    horizontalGap = 16
                    verticalGap = 0
                }
                //添加子项的点击事件 这里要用这个触摸的，不然在移动中无法监听到
                addOnItemTouchListener(object : RecyclerView.OnItemTouchListener {
                    override fun onInterceptTouchEvent(rv: RecyclerView, e: MotionEvent): Boolean {
                        val child = rv.findChildViewUnder(e.x, e.y) ?: return true
                        val position = rv.getChildViewHolder(child).bindingAdapterPosition
                        val itemList = barrageAdapterB.getItems()
                        clearMapGetOne(mCateid = itemList[position % itemList.size].cateid)
                        return true
                    }

                    override fun onTouchEvent(rv: RecyclerView, e: MotionEvent) {}

                    override fun onRequestDisallowInterceptTouchEvent(disallowIntercept: Boolean) {}
                })
                adapter = barrageAdapterB
            }
        }
    }

    /**
     * 控件显现/隐藏 渐变动画
     */
    private fun controlAppear(isAppear: Boolean = true) {
        mDataBind.apply {
            when (isAppear) {
                true -> {
                    Hint.alpha1()
                    ConSence.alpha1()
                    ConDistance.alpha1()
                    FenGeA.alpha1()
                    lifecycleScope.launch {
                        //等透明度动画执行完
                        delay(1000)
                        Element.visible()
                    }
                }
                false -> Element.gone()
            }
        }
    }

    /**
     * 附近没有店铺提示
     */
    private fun noStoreHint() {
        lifecycleScope.launch {
            mDataBind.ConNoStore.alpha1()
            //这里的3秒包括显示的1秒钟
            delay(3000)
            mDataBind.ConNoStore.alpha0()
        }
    }

    /**
     * 初始化定位
     */
    private fun initLocation() {
        Timber.d("初始化定位服务")
        // 设置定位模式 Hight_Accuracy：高精度模式 Battery_Saving：低功耗模式
        mLocationOption.locationMode = AMapLocationClientOption.AMapLocationMode.Battery_Saving
        Timber.d("启动多次定位模式")
        mLocationOption.isOnceLocation = false
        //获取最近3s内精度最高的一次定位结果：
        //设置setOnceLocationLatest(boolean b)接口为true，启动定位时SDK会返回最近3s内精度最高的一次定位结果。如果设置其为true，setOnceLocation(boolean b)接口也会被设置为true，反之不会，默认为false。
        mLocationOption.isOnceLocationLatest = false
        //定位间隔
        mLocationOption.interval = 10000
        //设置是否允许模拟位置,默认为true，允许模拟位置
        mLocationOption.isMockEnable = false
        //关闭缓存
        mLocationOption.isLocationCacheEnable = false
        // 给定位客户端对象设置定位参数
        mLocationClient.setLocationOption(mLocationOption)
        // 设置定位监听器
        mLocationClient.setLocationListener(this)
    }

    /**
     * 初始化地图
     */
    private fun initAMap() {
        //创建地图
        mDataBind.MapViewA.onCreate(findNavController().saveState())

        aMap = mDataBind.MapViewA.map

        AMapUtil.setAMapStyle(requireContext(), aMap)

        aMap.uiSettings.apply {
            //禁用所有手势
            setAllGesturesEnabled(false)
            //隐藏右下角的缩放按钮
            isZoomControlsEnabled = false
        }
        //是否开启定位功能
        toLocation.requestLocation {
            //开始定位
            mLocationClient.startLocation()
        }
    }

    /**
     * 设置地图蓝点样式
     */
    private fun setAMapLocationStyle(headImg: String) {
        //隐藏蓝点精度范围圈圈
        val view = this@BlindBoxFragment.layoutInflater.inflate(
            R.layout.view_map_pointer,
            mDataBind.ConstraintLayoutA,
            false
        )
        val image = view.findViewById<CircleImageView>(R.id.ImageViewA)
        image.glideDefault(
            requireContext(),
            AliYunImage.mfit(headImg, 50),
            id = R.mipmap.ic_pointer_happy
        ) {
            myLocationStyle.myLocationIcon(BitmapDescriptorFactory.fromView(view))
            if (!aMap.isMyLocationEnabled) aMap.isMyLocationEnabled = true
            aMap.myLocationStyle = myLocationStyle
        }
    }

    /**
     * 更新蓝点
     * [selectedFour] 距离
     * [isUpdateMood] 是否刷新心情
     */
    private fun initMarkerAMap(
        latLng: LatLng?,
        selectedFour: Int = mViewModel.distance.value ?: 500,
    ) {

        //切换的时候可能定位还没获取到位置，所以如果为空的话就不执行下面的内容
        if (latLng == null) return

        //清除店铺图标
        aMap.mapScreenMarkers.forEach {
            if (!it.isFlat) {
                it.remove()
            }
        }

        //地图缩放
        mapMoveCamera(latLng, selectedFour) {
            //更新绘制地图店铺
            drawStore(selectedFour, mViewModel.boxGetOneLiveData.value)
        }
    }

    /**
     * 地图缩放
     * 缩放级别：https://blog.csdn.net/u010378579/article/details/53097978
     */
    private fun mapMoveCamera(
        latLng: LatLng?,
        selectedFour: Int = mViewModel.distance.value ?: 500,
        onFinish: (() -> Unit)? = null
    ) {
        animationDrawAMap(latLng, selectedFour) {
            //有圆的话就先清除掉
            circle?.remove()
            //绘制圆
            circle = aMap.addCircle(
                //radius圆的半径 单位米
                CircleOptions().center(latLng).radius(selectedFour.toDouble())
                    //圆的填充颜色
                    .fillColor(requireContext().getResColor(R.color.c_333D8BFF))
                    //边框颜色
                    .strokeColor(requireContext().getResColor(R.color.c_803D8BFF))
                    //边框宽度
                    .strokeWidth(dp2Pix(requireContext(), 1f).toFloat())
            )
            onFinish?.invoke()
        }
    }

    /**
     * aMap动画执行，这里要执行两次不然很大概率会失败
     */
    private fun animationDrawAMap(
        latLng: LatLng?,
        selectedFour: Int,
        finishBlock: () -> Unit
    ) {
        aMap.apply {
            //更新 中心点的坐标 瞬间移动，没有移动的过程 第二个参数为缩放级别
            animateCamera(
                CameraUpdateFactory.newLatLngZoom(
                    latLng, when (selectedFour) {
                        500 -> mViewModel.fourList[0]
                        3000 -> mViewModel.fourList[1]
                        else -> mViewModel.fourList[2]
                    }
                ),
                object : AMap.CancelableCallback {
                    override fun onFinish() {
                        finishBlock()
                    }

                    override fun onCancel() {
                        animateCamera(
                            CameraUpdateFactory.newLatLngZoom(
                                latLng, when (selectedFour) {
                                    500 -> mViewModel.fourList[0]
                                    3000 -> mViewModel.fourList[1]
                                    else -> mViewModel.fourList[2]
                                }
                            ), object : AMap.CancelableCallback {
                                override fun onFinish() {
                                    finishBlock()
                                }

                                override fun onCancel() {
                                    //连续失败的话也直接绘制 这里有可能是因为坐标没改变/刷新的缘故
                                    finishBlock()
                                }
                            }
                        )
                    }
                }
            )
        }
    }

    /**
     * 绘制店铺
     * [selectedFour] 距离
     */
    private fun drawStore(selectedFour: Int, getOneBoxData: GetOneBoxData?) {
        getOneBoxData?.parentlist?.forEach { parentlist ->
            when {
                //附近没有店铺
                parentlist.range == selectedFour && parentlist.childlist?.size ?: 0 == 0 -> {
                    noStoreHint()
                    return
                }
                //附近有店铺，筛选到选中距离的那组数据显示
                parentlist.range == selectedFour && parentlist.childlist?.size ?: 0 != 0 -> {
                    parentlist.childlist?.forEachIndexed { index, childList ->
                        val markerOptions = MarkerOptions()
                        //不可拖动
                        markerOptions.apply {
                            draggable(false)
                            //设置maker id
                            period(childList.indexid)
                            //平贴地图
                            isFlat = false
                            //地址
                            position(
                                LatLng(
                                    childList.lnglat?.lat ?: 0.0,
                                    childList.lnglat?.lng ?: 0.0
                                )
                            )
                            //覆盖物的高度（权重，越高越上面 bg是0, 心情icon是1，这里设置2就已经在最上面了）
                            zIndex(2f)
                        }
                        //绘制背景
                        val view = this@BlindBoxFragment.layoutInflater.inflate(
                            R.layout.view_amap_store,
                            mDataBind.ConstraintLayoutA,
                            false
                        )

                        //关闭之前的店铺渲染
                        mViewModel.cancelStoreJob()
                        lifecycleScope.launch {
                            //图片加载成功再显示出来
                            view.findViewById<CircleImageView>(
                                R.id.ImageViewA
                            ).glideDefault(
                                requireContext(),
                                AliYunImage.mfit(childList.pic.toString(), 150)
                            ) {
                                markerOptions.icon(
                                    BitmapDescriptorFactory.fromView(
                                        view
                                    )
                                )
                                aMap.setOnMarkerClickListener {
                                    //有进行中的盒子在显示就不触发点击事件
                                    if (!mDataBind.JourneyDialog.isVisible()) {
                                        //点击心情图标也弹出dialog
                                        tripSelectedAnyLayer(parentlist, it.period)
                                    }
                                    true
                                }
                                val marker = aMap.addMarker(markerOptions)
                                //缩放动画
                                MarkerUtil.setScaleAnima(marker, duration = (index + 1) * 150L)
                            }
                        }.addTo(mViewModel.storeImgJob)
                    }
                }
            }
        }
    }

    /**
     * 清除店铺图标并调获取盲盒接口
     */
    private fun clearMapGetOne(mWordid: Int? = null, mCateid: Int? = null) {
        //清除地图店铺标点
        aMap.mapScreenMarkers.forEach {
            if (!it.isFlat) it.remove()
        }
        mViewModel.checkBeingBoxRefresh(mWordid, mCateid)
    }

    override fun onLocationChanged(p0: AMapLocation?) {
        if (p0 != null) {
            when (p0.errorCode) {
                AMapLocation.LOCATION_SUCCESS -> {
                    val latLng = LatLng(p0.latitude, p0.longitude)
                    if (BaseViewModel.lat != p0.latitude && BaseViewModel.lng != p0.longitude) {
                        BaseViewModel.saveLatLng(p0.latitude, p0.longitude)
                        if (mViewModel.boxGetOneLiveData.value != null) {
                            //改变中心点的位置
                            mapMoveCamera(latLng)
                            return
                        }
                    }
                    //如果没有数据的话才自动去获取 - 才打开app
                    if (mViewModel.boxGetOneLiveData.value == null && mViewModel.boxDetailLiveData.value == null) {
                        mViewModel.canGetBox()
                        return
                    }
                    //如果是有进行中的盒子就只改变状态
                    if (mViewModel.boxDetailLiveData.value != null) {
                        mViewModel.isCanGetBox = true
                        return
                    }
                }
                AMapLocation.ERROR_CODE_FAILURE_LOCATION_PERMISSION -> Log.e("xxx", "未给予定位权限")
                else -> Log.e("xxx", "定位出错 ${p0.errorCode} ${p0.errorInfo}")
            }
        }
    }

    /**
     * 刷新出行人数控件和预算
     */
    private fun initTripNumberMood(layer: Layer) {
        //出行人数
        mViewModel.tripNumber?.let { list ->
            val listA = list[0]
            val listB = list[1]
            layer.getView<TextView>(R.id.Me)?.apply {
                text = listA.itemname
                if (listA.isdefault == 1) {
                    this.isEnabled = false
                    mViewModel.selectedTwoItemId = listA.itemid
                }
            }
            layer.getView<TextView>(R.id.Friend)?.apply {
                text = listB.itemname
                if (listB.isdefault == 1) {
                    this.isEnabled = false
                    mViewModel.selectedTwoItemId = listB.itemid
                }
            }
        }

        //预算
        mViewModel.tripMood?.let { itemdict ->
            bannerVp?.refreshData(itemdict.imagelist1)
            bannerVpB?.refreshData(itemdict.imagelist2)
        }
    }

    /**
     * 跳转到出行页面
     * [notCountDown] 是否不需要显示倒计时
     */
    private fun skipSetOutFragment(
        listData: GetOneBoxData.Parentlist.Childlist,
        notCountDown: Boolean = false
    ) {
        val bundle = Bundle().apply {
            putParcelable("getBoxData", listData)
            if (notCountDown) putBoolean("notCountDown", true)
        }
        animationNav(R.id.action_mainFragment_to_setOutFragment, bundle)
    }

    /**
     * 引导页弹窗
     */
    private fun guidePageHintAnyLayer() {
        AnyLayer.dialog(requireContext())
            //点击浮层以外区域是否可关闭
            .cancelableOnTouchOutside(false).contentView(R.layout.dialog_guide_page)
            .onInitialize { layer ->
                (layer.getView(R.id.BannerVp) as? BannerViewPager<Int>)?.let { bannerVp ->
                    bannerVp.apply {
                        adapter = object : BaseBannerAdapter<Int>() {
                            override fun bindData(
                                holder: BaseViewHolder<Int>?,
                                data: Int?,
                                position: Int,
                                pageSize: Int
                            ) {
                                if (data == null) return
                                holder?.apply {
                                    holder.findViewById<ImageView>(R.id.ImageA).apply {
                                        setImageResource(data)
                                        //点击任意位置移动到下一页
                                        setOnClickListener {
                                            if (position + 1 == itemCount) {
                                                SpUtilsMMKV.put(
                                                    CommonConstant.GUIDE_PAGE_HINT,
                                                    true
                                                )
                                                layer.dismiss()
                                            } else setCurrentItem(position + 1, true)
                                        }
                                    }
                                }
                            }

                            override fun getLayoutId(viewType: Int): Int = R.layout.view_guide_page
                        }
                        //不开启自动轮播
                        setAutoPlay(false)
                        //是否开启循环
                        setCanLoop(false)
                        //页面滚动时间
                        setScrollDuration(300)
                        setIndicatorVisibility(View.GONE)
                            .create(mViewModel.guideList)
                    }
                }
            }
            //不拦截物理按键
            .interceptKeyEvent(false)
            .onShowListener(object : Layer.OnShowListener {
                override fun onShowing(layer: Layer) {
                    changeNaviColor(R.color.c_99000000)
                }

                override fun onShown(layer: Layer) {}
            })
            .onDismissListener(object : Layer.OnDismissListener {
                override fun onDismissing(layer: Layer) {
                    changeNaviColor(R.color.c_F)
                }

                override fun onDismissed(layer: Layer) {}
            })
            .show()
    }

    //出行场景弹窗
    private val sceneAnyLayer by lazy {
        anyLayer(true).contentView(R.layout.view_new_trip)
            .gravity(Gravity.BOTTOM)
            .swipeDismiss(SwipeLayout.Direction.BOTTOM)
            .onClickToDismiss(R.id.Cancel)
            .onClickToDismiss({ layer, view ->
                //点击一下中间的盒子按钮
                BaseViewModel.setBoxBtnStatus(BoxBtnStatus.RedRefreshIng)
            }, R.id.Confirm)
            .onClick({ layer, view ->
                layer.getView<TextView>(R.id.Friend)?.isEnabled = true
                view.isEnabled = false
                mViewModel.tripNumber?.let { list ->
                    mViewModel.selectedTwoItemId = list[0].itemid
                }
                mViewModel.selectedThree = 0
                layer.getView<Group>(R.id.BannerA)?.visible()
                layer.getView<Group>(R.id.BannerB)?.gone()
            }, R.id.Me)
            .onClick({ layer, view ->
                layer.getView<TextView>(R.id.Me)?.isEnabled = true
                view.isEnabled = false
                mViewModel.tripNumber?.let { list ->
                    mViewModel.selectedTwoItemId = list[1].itemid
                }
                mViewModel.selectedThree = 1
                layer.getView<Group>(R.id.BannerA)?.gone()
                layer.getView<Group>(R.id.BannerB)?.visible()
            }, R.id.Friend)
            .onInitialize { layer ->
                mViewModel.boxQuesListLiveData.value?.list?.forEach { dataItem ->
                    when (dataItem.id) {
                        //出行场景
                        4 -> layer.getView<TextView>(R.id.TitleB)?.text = dataItem.title
                        //人均预算
                        1 -> layer.getView<TextView>(R.id.TitleA)?.text = dataItem.title
                    }
                }

                //出行预算
                layer.getView<RecyclerView>(R.id.TripRecyclerViewA)?.apply {
                    addItemDecoration(
                        MadelGridDecoration(
                            3,
                            windowsWidth,
                            dp2Pix(requireContext(), 104f),
                            15f
                        )
                    )
                    layoutManager = object : GridLayoutManager(requireContext(), 3) {
                        //禁止垂直滑动
                        override fun canScrollVertically(): Boolean = false
                    }
                    adapter = btnOneAdapter
                }

                //心情
                bannerVp = layer.getView(R.id.BannerVp)
                bannerVp?.let { bannerVp ->
                    getBannerVp(bannerVp).apply {
                        adapter = btnTwoAdapter
                        setIndicatorView(layer.getView<IndicatorView>(R.id.IndVA))
                        //滑动监听
                        registerOnPageChangeCallback(object :
                            ViewPager2.OnPageChangeCallback() {
                            override fun onPageSelected(position: Int) {
                                super.onPageSelected(position)
                                if (mViewModel.selectedThreeItemIdA == -1) return
                                if (btnTwoAdapter.dialogFirst)
                                    btnTwoAdapter.dialogFirst = false
                                mViewModel.selectedThreeItemIdA =
                                    mViewModel.tripMood?.imagelist1?.get(position)?.itemid ?: 0
                                //下个ui帧才更新，这里确保不在计算布局的时候触发
                                bannerVp.post { btnTwoAdapter.notifyDataSetChanged() }
                            }
                        })
                            .create()
                    }
                }

                //心情 B
                bannerVpB = layer.getView(R.id.BannerVpB)
                bannerVpB?.let { bannerVpB ->
                    getBannerVp(bannerVpB).apply {
                        adapter = btnTwoAdapterB
                        setIndicatorView(layer.getView<IndicatorView>(R.id.IndVAB))
                        //滑动监听
                        registerOnPageChangeCallback(object :
                            ViewPager2.OnPageChangeCallback() {
                            override fun onPageSelected(position: Int) {
                                super.onPageSelected(position)
                                if (mViewModel.selectedThreeItemIdB == -1) return
                                if (btnTwoAdapterB.dialogFirst) btnTwoAdapterB.dialogFirst =
                                    false
                                mViewModel.selectedThreeItemIdB =
                                    mViewModel.tripMood?.imagelist2?.get(position)?.itemid ?: 0
                                //下个ui帧才更新，这里确保不在计算布局的时候触发
                                bannerVpB.post { btnTwoAdapterB.notifyDataSetChanged() }
                            }
                        })
                            .create()
                    }
                }
                //刷新出行人数控件和预算
                initTripNumberMood(layer)
            }
            //不拦截物理按键
            .interceptKeyEvent(false)
    }

    /**
     * 创建一个bannerViewPager
     */
    private fun getBannerVp(bannerViewPager: BannerViewPager<GetBoxQuesListData.DataItem.Itemdict.Imagelist>): BannerViewPager<GetBoxQuesListData.DataItem.Itemdict.Imagelist> {
        bannerViewPager.apply {
            //不开启自动轮播
            setAutoPlay(false)
            //是否开启循环
            setCanLoop(true)
            //左右间隔
            setPageMargin(dp2Pix(requireContext(), 20f))
            setRevealWidth(0, dp2Pix(requireContext(), 137f))
            setIndicatorSliderGap(dp2Pix(requireContext(), 10f))
            //指示器平滑移动
            setIndicatorSlideMode(IndicatorSlideMode.SMOOTH)
            setIndicatorSliderColor(
                requireContext().getResColor(R.color.c_1A404D66),
                requireContext().getResColor(R.color.c_FF5280)
            )
        }
        return bannerViewPager
    }

    //弹幕适配器
    private val barrageAdapter by lazy {
        object : BaseDbAdapter<BoxCateTypesData.Catelist, ViewBarrageTextBinding>() {

            val bgDrawable = DrawableCreator.Builder()

            var barrageColor: BoxCateTypesData.Colorlist? = null

            override fun onBindItem(
                holder: BaseViewHolder,
                binding: ViewBarrageTextBinding,
                item: BoxCateTypesData.Catelist,
                position: Int
            ) {
                binding.apply {
                    barrageColor = mViewModel.barrageColor
                    ConstA.apply {
                        visible()
                        background =
                            bgDrawable.setCornersRadius(18.dp.toFloat())
                                .setSolidColor(Color.parseColor(barrageColor?.bgcolor ?: "#ffffff"))
                                .setStrokeWidth(2.dp.toFloat())
                                .setStrokeColor(
                                    Color.parseColor(
                                        barrageColor?.linecolor ?: "#ffffff"
                                    )
                                )
                                .build()
                    }
                    Str.apply {
                        text = item.title
                        setTextColor(Color.parseColor(barrageColor?.txtcolor ?: "#000000"))
                    }
                }
            }

            override fun getLayoutResId(viewType: Int): Int = R.layout.view_barrage_text
            override fun setLayoutType(): LayoutType = LayoutType.MAX_VALUE
        }
    }

    //弹幕适配器 RecycB
    private val barrageAdapterB by lazy {
        object : BaseDbAdapter<BoxCateTypesData.Catelist, ViewBarrageTextBinding>() {

            val bgDrawable = DrawableCreator.Builder()

            var barrageColor: BoxCateTypesData.Colorlist? = null

            override fun onBindItem(
                holder: BaseViewHolder,
                binding: ViewBarrageTextBinding,
                item: BoxCateTypesData.Catelist,
                position: Int
            ) {
                binding.apply {
                    barrageColor = mViewModel.barrageColor
                    ConstA.apply {
                        visible()
                        background =
                            bgDrawable.setCornersRadius(18.dp.toFloat())
                                .setSolidColor(Color.parseColor(barrageColor?.bgcolor ?: "#ffffff"))
                                .setStrokeWidth(2.dp.toFloat())
                                .setStrokeColor(
                                    Color.parseColor(
                                        barrageColor?.linecolor ?: "#ffffff"
                                    )
                                )
                                .build()
                    }
                    Str.apply {
                        text = item.title
                        setTextColor(Color.parseColor(barrageColor?.txtcolor ?: "#000000"))
                    }
                }
            }

            override fun getLayoutResId(viewType: Int): Int = R.layout.view_barrage_text
            override fun setLayoutType(): LayoutType = LayoutType.MAX_VALUE
        }
    }


    //预算 按钮的适配器
    private val btnOneAdapter =
        object :
            BaseRvAdapter<GetBoxQuesListData.DataItem.Itemdict.Imagelist, ViewTripBtnBinding>() {

            //是否是第一次加载数据
            var dialogFirst = true

            override fun onBindItem(
                holder: BaseViewHolder,
                binding: ViewTripBtnBinding,
                item: GetBoxQuesListData.DataItem.Itemdict.Imagelist,
                position: Int
            ) {
                binding.apply {
                    BtnA.text = item.itemname

                    mViewModel.apply {
                        when (dialogFirst) {
                            true -> {
                                if (item.isdefault == 1) {
                                    selectedOneItemId = item.itemid
                                    BtnA.isEnabled = false
                                }

                                if (position + 1 == itemCount) {
                                    dialogFirst = false
                                }
                            }
                            false -> BtnA.isEnabled = selectedOneItemId != item.itemid
                        }

                        BtnA.setOnClickListener {
                            selectedOneItemId = item.itemid
                            notifyDataSetChanged()
                        }
                    }
                }
            }

            override fun getLayoutResId(viewType: Int): Int = R.layout.view_trip_btn
        }

    /**
     * 心情的适配器
     */
    private val btnTwoAdapter by lazy {
        object : BaseBannerAdapter<GetBoxQuesListData.DataItem.Itemdict.Imagelist>() {

            //是否是第一次加载数据
            var dialogFirst = true

            override fun bindData(
                holder: BaseViewHolder<GetBoxQuesListData.DataItem.Itemdict.Imagelist>?,
                data: GetBoxQuesListData.DataItem.Itemdict.Imagelist?,
                position: Int,
                pageSize: Int
            ) {
                val image = holder?.findViewById<ImageView>(R.id.ImageViewA)

                when (dialogFirst) {
                    //第一次加载数据
                    true -> {
                        if (data?.isdefault == 1) {
                            mViewModel.selectedThreeItemIdA = data.itemid
                            bannerVp?.currentItem = position
                        }

                        image?.glideDefault(
                            requireContext(),
                            if (data?.isdefault == 1) data.itemselpic else data?.itempic
                        ) {}
                    }
                    false -> {
                        image?.glideDefault(
                            requireContext(),
                            if (data?.itemid == mViewModel.selectedThreeItemIdA) data.itemselpic else data?.itempic
                        ) {}
                    }
                }
            }

            override fun getLayoutId(viewType: Int): Int = R.layout.view_image
        }
    }

    /**
     * 心情的适配器 B
     */
    private val btnTwoAdapterB by lazy {
        object : BaseBannerAdapter<GetBoxQuesListData.DataItem.Itemdict.Imagelist>() {

            //是否是第一次加载数据
            var dialogFirst = true

            override fun bindData(
                holder: BaseViewHolder<GetBoxQuesListData.DataItem.Itemdict.Imagelist>?,
                data: GetBoxQuesListData.DataItem.Itemdict.Imagelist?,
                position: Int,
                pageSize: Int
            ) {
                val image = holder?.findViewById<ImageView>(R.id.ImageViewA)

                when (dialogFirst) {
                    //第一次加载数据
                    true -> {
                        if (data?.isdefault == 1) {
                            mViewModel.selectedThreeItemIdB = data.itemid
                            bannerVpB?.currentItem = position
                        }

                        image?.glideDefault(
                            requireContext(),
                            if (data?.isdefault == 1) data.itemselpic else data?.itempic
                        ) {}
                    }
                    false -> {
                        image?.glideDefault(
                            requireContext(),
                            if (data?.itemid == mViewModel.selectedThreeItemIdB) data.itemselpic else data?.itempic
                        ) {}
                    }
                }
            }

            override fun getLayoutId(viewType: Int): Int = R.layout.view_image
        }
    }

    /**
     * 出行选择弹窗
     * [period] 地图map的id，根据这个id识别当前选择的是那个index
     */
    private fun tripSelectedAnyLayer(getOneBoxData: GetOneBoxData.Parentlist, period: Int) {
        changeNaviColor(R.color.c_80000000)
        anyLayer(true).contentView(R.layout.dialog_trip_selected)
            .onClick({ layer, _ ->
                layer.dismiss()
                mViewModel.startBox()
            }, R.id.Btn)
            .onInitialize { layer ->
                bannerVpSele = layer.getView(R.id.BannerVp)
                bannerVpSele?.let { bannerVp ->
                    bannerVp.apply {
                        adapter = object : BaseBannerAdapter<GetOneBoxData.Parentlist.Childlist>() {
                            override fun bindData(
                                holder: BaseViewHolder<GetOneBoxData.Parentlist.Childlist>?,
                                data: GetOneBoxData.Parentlist.Childlist?,
                                position: Int,
                                pageSize: Int
                            ) {
                                if (data == null) return
                                holder?.apply {
                                    //顶部背景
                                    findViewById<ShapeableImageView>(R.id.TypePic)
                                        .glideDefault(
                                            requireContext(),
                                            (data.pic ?: "").fillHW(540, 861),
                                            false
                                        )
                                    //品类标签
                                    findViewById<ImageView>(R.id.Type).glideDefault(
                                        requireContext(),
                                        data.typelogo ?: "",
                                        false
                                    )
                                    //标题
                                    findViewById<TextView>(R.id.StoreName).text = data.title ?: ""
                                    //详情
                                    findViewById<TextView>(R.id.TypeDescribe).text =
                                        data.detail ?: ""
                                    data.items?.forEach { item ->
                                        when (item.type) {
                                            //实时距离
                                            1 -> {
                                                val str = item.value.toString()
                                                //是否包含米，如果不包含就是公里
                                                val spannableInfo = str.differentTestSize(
                                                    str.length - if (str.contains("米")) 1 else 2,
                                                    str.length,
                                                    0.45f
                                                )
                                                val distance = findViewById<TextView>(R.id.Distance)
                                                distance.movementMethod =
                                                    LinkMovementMethod.getInstance()
                                                distance.text = spannableInfo
                                                findViewById<TextView>(R.id.TextA).text =
                                                    item.item.toString()
                                            }
                                            //人均消费
                                            2 -> {
                                                findViewById<TextView>(R.id.TextB).text =
                                                    item.item.toString()
                                                //金额
                                                findViewById<TextView>(R.id.Cost).apply {
                                                    movementMethod =
                                                        LinkMovementMethod.getInstance()
                                                    text = item.value.toString()
                                                        .differentTestSize(0, 1, 0.66f)
                                                }
                                            }
                                            //神秘感
                                            3 -> {
                                                findViewById<RatingBar>(R.id.MysteryNum).rating =
                                                    item.value.toString().toFloat()
                                                findViewById<TextView>(R.id.TextD).text =
                                                    item.item.toString()
                                            }
                                            //新鲜感
                                            4 -> {
                                                findViewById<RatingBar>(R.id.NewNum).rating =
                                                    item.value.toString().toFloat()
                                                findViewById<TextView>(R.id.TextC).text =
                                                    item.item.toString()
                                            }
                                        }
                                    }
                                }
                            }

                            override fun getLayoutId(viewType: Int): Int = R.layout.view_journey
                        }
                        //滑动监听
                        registerOnPageChangeCallback(object :
                            ViewPager2.OnPageChangeCallback() {
                            override fun onPageSelected(position: Int) {
                                super.onPageSelected(position)
                                mViewModel.selectedId = position
                            }
                        })
                        //不开启自动轮播
                        setAutoPlay(false)
                        //是否开启循环
                        setCanLoop(getOneBoxData.childlist?.size ?: 0 >= 3)
                        setPageMargin(dp2Pix(requireContext(), 21f))
                        setPageStyle(PageStyle.MULTI_PAGE_SCALE)
                        setRevealWidth(dp2Pix(requireContext(), 15f), dp2Pix(requireContext(), 21f))
                        setIndicatorVisibility(View.GONE)
                            .create(getOneBoxData.childlist)
                        //移动到初始的item
                        getOneBoxData.childlist?.forEachIndexed { index, childlist ->
                            if (childlist.indexid == period) {
                                when {
                                    index != 0 -> setCurrentItem(index, false)
                                    index == 0 -> mViewModel.selectedId = 0
                                }
                            }
                        }
                    }
                }
            }
            //不拦截物理按键
            .interceptKeyEvent(false)
            .onDismissListener(object : Layer.OnDismissListener {
                override fun onDismissing(layer: Layer) {
                    changeNaviColor(R.color.c_F)
                }

                override fun onDismissed(layer: Layer) {
                    bannerVpSele = null
                }
            })
            .show()
    }

    //新的到达弹窗
    private fun arriveNewAnyLayer(data: GetOneBoxData.Parentlist.Childlist) {
        changeNaviColor(R.color.c_BF00A473)
        arriveLayer = AnyLayer.dialog(requireContext())
            //点击浮层以外区域是否可关闭
            .cancelableOnTouchOutside(false).contentView(R.layout.dialog_arrive_new)
            //不拦截物理按键
            .interceptKeyEvent(false)
            .onInitialize { layer ->
                //限时抽奖活动图标
                layer.getView<ImageView>(R.id.LotteryImage)?.visibility =
                    if (data.activityinfo == 1) View.VISIBLE else View.GONE
                //店铺名字
                layer.getView<TextView>(R.id.StoreName)?.text = data.realname
                //店铺具体地址
                layer.getView<TextView>(R.id.StoreLocation)?.text = data.readAddress

                //到达出现的文案
                val arriveStr = data.arrivedtext
                //第三个参数是指定忽略大小写
                var newArriveStr =
                    arriveStr?.replaceFirst("{{SJTL1}}", data.arrivedvarlist?.get(0) ?: "", false)
                        .toString()
                newArriveStr = newArriveStr.replaceFirst(
                    "{{SJTL2}}",
                    data.arrivedvarlist?.get(1) ?: "",
                    false
                )
                newArriveStr = newArriveStr.replaceFirst(
                    "{{SJTL3}}",
                    data.arrivedvarlist?.get(2) ?: "",
                    false
                )
                newArriveStr = newArriveStr.replaceFirst(
                    "{{SJTL4}}",
                    data.arrivedvarlist?.get(3) ?: "",
                    false
                )
                layer.getView<TextView>(R.id.ArriveText)?.text = newArriveStr

                //到达按钮 - 评论
                layer.getView<ImageView>(R.id.IAmArrive)?.setOnClickListener {
                    if (evaluateAnyLayer != null && evaluateAnyLayer!!.isShown) {
                        evaluateAnyLayer!!.dismiss()
                    }
                    evaluateAnyLayer()
                }

                //寻求帮助
                layer.getView<ImageView>(R.id.Help)?.setOnClickListener {
                    notFindAnyLayer(data)
                }
            }
            .onDismissListener(object : Layer.OnDismissListener {
                override fun onDismissing(layer: Layer) {
                    //停止播放动画
                    layer.getView<LottieAnimationView>(R.id.ArriveLottie)?.cancelAnimation()
                    changeNaviColor(R.color.c_F)
                }

                override fun onDismissed(layer: Layer) {}
            })
        arriveLayer?.show()
    }

    //没有找到目的地弹窗
    private fun notFindAnyLayer(data: GetOneBoxData.Parentlist.Childlist) {
        anyLayerBottom(R.layout.dialog_not_found_location, true, R.color.c_BF00A473, R.color.c_F)
            .onClickToDismiss(R.id.Close)
            .onClick({ layer, view ->
                val onePhone = layer.getView<TextView>(R.id.PhoneB)?.text.toString()
                if (onePhone == "暂无") return@onClick
                SkipOtherApp.callPhone(this, onePhone)
            }, R.id.PhoneB)
            .onClick({ layer, view ->
                val twoPhone = layer.getView<TextView>(R.id.PhoneC)?.text.toString()
                if (twoPhone == "暂无") return@onClick
                SkipOtherApp.callPhone(this, twoPhone)
            }, R.id.PhoneC)
            //高德地图
            .onClick({ layer, view ->
                SkipOtherApp.goGeoDe(
                    requireActivity(),
                    data.realname ?: "",
                    data.lnglat?.lat.toString(),
                    data.lnglat?.lng.toString()
                )
            }, R.id.Geode)
            //百度地图
            .onClick({ layer, view ->
                SkipOtherApp.goBaiDu(
                    requireActivity(),
                    data.realname ?: "",
                    data.lnglat?.lat.toString(),
                    data.lnglat?.lng.toString()
                )
            }, R.id.BaiDu)
            .onInitialize { layer ->
                val mobList = data.mob?.split(",")
                when (mobList?.size ?: 0) {
                    //隐藏一个
                    1 -> {
                        layer.getView<Group>(R.id.PhoneGroupOne)?.gone()
                        layer.getView<TextView>(R.id.PhoneB)?.text = mobList?.get(0)
                    }
                    2 -> {
                        layer.getView<TextView>(R.id.PhoneB)?.text = mobList?.get(0)
                        layer.getView<TextView>(R.id.PhoneC)?.text = mobList?.get(1)
                    }
                    //全部隐藏
                    else -> layer.getView<Group>(R.id.PhoneGroup)?.gone()
                }
            }
            .show()
    }

    //评价弹窗
    private var evaluateAnyLayer: Layer? = null
    private fun evaluateAnyLayer() {
        changeNaviColor(R.color.c_F)
        evaluateAnyLayer = anyLayer(true).contentView(R.layout.dialog_arrive_evaluate)
            .gravity(Gravity.BOTTOM)
            .swipeDismiss(SwipeLayout.Direction.BOTTOM)
            .onInitialize { layer ->
                val noManYi = layer.getView<TextView>(R.id.NoManYi)
                val noManYiText = layer.getView<TextView>(R.id.ETextE)
                val constraintLayoutC = layer.getView<ConstraintLayout>(R.id.ConstraintLayoutC)

                val manYi = layer.getView<TextView>(R.id.ManYi)
                val manYiText = layer.getView<TextView>(R.id.ETextD)

                noManYi?.setOnClickListener {
                    mViewModel.isLike = 2
                    noManYi.setBackgroundResource(R.mipmap.ic_box_nomanyi_selected)
                    manYi?.setBackgroundResource(R.mipmap.ic_box_manyi_unselected)
                    noManYi.isEnabled = false
                    manYi?.isEnabled = true
                    manYiText.gone()
                    noManYiText.visible()
                    constraintLayoutC.visible()
                }

                manYi?.setOnClickListener {
                    mViewModel.isLike = 1
                    noManYi?.setBackgroundResource(R.mipmap.ic_box_nomanyi_unselected)
                    manYi.setBackgroundResource(R.mipmap.ic_box_manyi_selected)
                    noManYi?.isEnabled = true
                    manYi.isEnabled = false
                    manYiText.visible()
                    noManYiText.gone()
                    constraintLayoutC.gone()
                }

                val oneText = layer.getView<TextView>(R.id.TextOne)
                val twoText = layer.getView<TextView>(R.id.TextTwo)
                val threeText = layer.getView<TextView>(R.id.TextThree)
                val fourText = layer.getView<TextView>(R.id.TextFour)
                val fiveText = layer.getView<TextView>(R.id.TextFive)
                val sixText = layer.getView<TextView>(R.id.TextSix)
                oneText?.setOnClickListener { selectedBtns(oneText, 1) }
                twoText?.setOnClickListener { selectedBtns(twoText, 2) }
                threeText?.setOnClickListener { selectedBtns(threeText, 3) }
                fourText?.setOnClickListener { selectedBtns(fourText, 4) }
                fiveText?.setOnClickListener { selectedBtns(fiveText, 5) }
                sixText?.setOnClickListener { selectedBtns(sixText, 6) }

                //提交评价
                layer.getView<Button>(R.id.EBtnA)?.setOnClickListener {
                    mViewModel.submitBtn()
                }
            }
            .onDismissListener(object : Layer.OnDismissListener {
                override fun onDismissing(layer: Layer) {
                    changeNaviColor(R.color.c_BF00A473)
                }

                override fun onDismissed(layer: Layer) {}
            })
            //不拦截物理按键
            .interceptKeyEvent(false)
        evaluateAnyLayer!!.show()
    }

    /**
     * 选择不满意原因的六个框
     */
    private fun selectedBtns(textView: TextView, btnNum: Int) {
        when (mViewModel.selectedMap.containsKey(btnNum)) {
            true -> {
                textView.isSelected = false
                mViewModel.selectedMap.remove(btnNum)
            }
            false -> {
                textView.isSelected = true
                mViewModel.selectedMap[btnNum] = selectedList[btnNum - 1]
            }
        }
    }

    override fun onResume() {
        super.onResume()
        mDataBind.MapViewA.onResume()
        //开启定位
        mLocationClient.startLocation()
    }

    override fun onDestroy() {
        super.onDestroy()
        mDataBind.MapViewA.onDestroy()
        //销毁定位
        mLocationClient.onDestroy()
    }

    override fun onPause() {
        super.onPause()
        mDataBind.MapViewA.onPause()
        //停止定位
        mLocationClient.stopLocation()
    }

    override fun updateStatusBarColor(): Boolean = false

}
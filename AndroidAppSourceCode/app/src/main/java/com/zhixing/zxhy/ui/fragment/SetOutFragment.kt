package com.zhixing.zxhy.ui.fragment

import android.annotation.SuppressLint
import android.graphics.BitmapFactory
import android.graphics.Typeface
import android.os.Bundle
import android.text.Spannable
import android.text.SpannableStringBuilder
import android.text.method.LinkMovementMethod
import android.text.style.StyleSpan
import android.view.Gravity
import android.view.MotionEvent
import android.view.View
import android.widget.*
import androidx.annotation.DrawableRes
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.constraintlayout.widget.Group
import androidx.lifecycle.lifecycleScope
import androidx.navigation.fragment.findNavController
import com.airbnb.lottie.LottieAnimationView
import com.amap.api.location.AMapLocation
import com.amap.api.location.AMapLocationClient
import com.amap.api.location.AMapLocationClientOption
import com.amap.api.maps.*
import com.amap.api.maps.model.*
import com.amap.api.navi.*
import com.amap.api.navi.enums.NaviType
import com.amap.api.navi.enums.PathPlanningStrategy
import com.amap.api.navi.model.*
import com.amap.api.navi.view.NextTurnTipView
import com.amap.api.services.core.LatLonPoint
import com.amap.api.services.route.*
import com.google.android.material.imageview.ShapeableImageView
import com.hjq.toast.ToastUtils
import com.tuanliu.common.base.BaseViewModel
import com.tuanliu.common.ext.*
import com.tuanliu.common.model.FragmentConfigData
import com.tuanliu.common.model.StatusBarMode
import com.zhixing.zxhy.R
import com.zhixing.zxhy.databinding.FragmentSetOutBinding
import com.zhixing.zxhy.view_model.SetOutViewModel
import com.zhixing.zxhy.base.BaseAMapDbFragment
import com.zhixing.zxhy.ui.activity.WebActivity
import com.zhixing.zxhy.util.*
import com.zhixing.zxhy.util.toPermission.ToLocation
import com.zhixing.zxhy.util.mapUtil.MapUtil
import com.zhixing.zxhy.view_model.GetOneBoxData
import de.hdodenhof.circleimageview.CircleImageView
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import per.goweii.anylayer.AnyLayer
import per.goweii.anylayer.Layer
import per.goweii.anylayer.widget.SwipeLayout
import timber.log.Timber

/**
 * 启程页面
 * https://a.amap.com/lbs/static/unzip/Android_Navi_Doc/index.html
 */
@SuppressLint("ClickableViewAccessibility")
class SetOutFragment : BaseAMapDbFragment<SetOutViewModel, FragmentSetOutBinding>() {

    companion object {
        private val selectedList =
            listOf<String>("以前来过", "不喜欢这个地方", "导航不清晰", "太好猜", "时间不准确", "找不到店")
    }

    private lateinit var mAMapNavi: AMapNavi

    //高德地图定位参数
    private val mLocationOption by lazy { AMapLocationClientOption() }

    //高德定位服务客户端
    private val mLocationClient by lazy { AMapLocationClient(requireContext()) }

    //手机震动类
    private val playVibrate by lazy { PlayVibrate(requireContext()) }

    //定位权限检测
    private val toLocation by lazy { ToLocation(this@SetOutFragment) }

    //地图元素绘制
    private val markerOptions by lazy {
        MarkerOptions().draggable(false).position(
            LatLng(
                mViewModel.mEndPoint.latitude,
                mViewModel.mEndPoint.longitude
            )
        )
    }

    //店铺marker
    private var storeMarker: Marker? = null

    //测距
    private val distanceSearch by lazy { DistanceSearch(requireContext()) }
    private val distanceQuery by lazy { DistanceSearch.DistanceQuery() }

    //是否是步行
    private var isWalk = false

    //距离
    private lateinit var distanceA: TextView

    //单位
    private lateinit var distanceB: TextView

    //下一路口名
    private lateinit var address: TextView

    //高德图标
    private lateinit var nextTurnA: NextTurnTipView

    //地图控制器对象
    private lateinit var aMap: AMap

    //导航途中需要改变icon
    private val naviIngChange = NavigationIngChange()

    @DrawableRes
    var mIconType: Int? = null

    //是否跳转到了WebActivity
    private var goWebActivity: Boolean = false

    override fun initView(savedInstanceState: Bundle?) {
        mViewModel.boxGetOneLiveData.value = arguments?.getParcelable("getBoxData")
        mViewModel.notCountDown = arguments?.getBoolean("notCountDown") ?: false

        try {
            //AMapNaviView
            initAMapNaviView(savedInstanceState)
            //初始化mAMapNavi
            initAMapNavi()
            //开启测距
            distanceSearch.setDistanceSearchListener(this@SetOutFragment)
        } catch (e: AMapException) {
            e.printStackTrace()
        }

        toLocation.requestLocation(noOpen = {
            findNavController().navigateUp()
        }) {
            //权限、定位无误，开启定位后进行导航
            initLocation()
        }
    }

    override fun initLiveData() {
        mViewModel.apply {
            //盲盒评价
            enjoyBoxLiveData.observerKt {
                if (evaluateAnyLayer.isShown) evaluateAnyLayer.dismiss()
                arriveNewAnyLayer?.apply {
                    if (isShown) dismiss()
                }
                ToastUtils.show("评价成功")
                //如果有活动的话跳转到活动页面
                if (it?.isNotBlank() == true) {
                    lifecycleScope.launch {
                        delay(200)
                        goWebActivity = true
                        WebActivity.start(requireContext(), it)
                    }
                } else backUp()
            }

            //盲盒到达
            arrivedBoxData.observerKt {
                //开启震动
                playVibrate.playVibrate(false)
                //导航弹窗隐藏
                navigationAnyLayer?.let {
                    if (it.isShown) it.dismiss()
                }
                //到达弹窗显示
                arriveNewAnyLayer()
            }

            //中止盲盒成功
            cancelBoxData.observerKt {
                closeNavArriveDialog()
                if (closeAnyLayer.isShown) closeAnyLayer.dismiss()
                backUp()
            }

        }
    }

    /**
     * 获取焦点
     */
    private fun setOutGetFocus() {
        getFocus {
            //只有导航栏出现的时候才能够退出
            if (navigationAnyLayer?.isShown == true || arriveNewAnyLayer?.isShown == true) {
                navigationAnyLayer?.getView<ImageView>(R.id.Close)?.performClick()
            }
        }
    }

    /**
     * 初始化AMapNaviView
     */
    private fun initAMapNaviView(savedInstanceState: Bundle?) {
        mDataBind.AMapNaviViewA.apply {
            aMap = map
            onCreate(savedInstanceState)
            setAMapNaviViewListener(this@SetOutFragment)
            //获取导航模式 北方向上 / 车头向上
            naviMode = AMapNaviView.NORTH_UP_MODE
            //1-锁车态 2-全览态 3-普通态
//            setShowMode(1)
            //是否显示 起终途点、步行轮渡扎点、禁行限行封路icon
            setRouteMarkerVisible(false, false, false)

            val options = this.viewOptions
            options.apply {
                //这个罗盘位图是不动的
//                fourCornersBitmap = BitmapFactory.decodeResource(resources, R.mipmap.ic_pointer_happy)
                //这个车是会随陀螺仪动的
                carBitmap = BitmapFactory.decodeResource(resources, R.mipmap.ic_map_start)
                setEndPointBitmap(
                    BitmapFactory.decodeResource(
                        resources,
                        R.mipmap.ic_map_end
                    )
                )
                //界面ui不显示
                isLayoutVisible = false
                //锁车态下是否自动进行地图缩放变化
                isAutoChangeZoom = false
                //设置6秒后是否自动锁车
                isAutoLockCar = false
                //算路成功后是否自动进入全览模式
                isAutoDisplayOverview = true
                val route = RouteOverlayOptions()
                route.apply {
                    //通过的路线置灰
                    isAfterRouteAutoGray = true
//                    //交通状况良好下的纹理位图
//                    smoothTraffic = BitmapFactory.decodeResource(resources, R.mipmap.ic_app)
//                    //无路况路线的纹理
//                    normalRoute = BitmapFactory.decodeResource(resources, R.mipmap.ic_app)
//                    //交通状况未知下的纹理位图
//                    unknownTraffic = BitmapFactory.decodeResource(resources, R.mipmap.ic_app)
//
//                    //交通状况非常拥堵下的纹理位图
//                    veryJamTraffic = BitmapFactory.decodeResource(resources, R.mipmap.ic_app)
//                    //交通状况迟缓下的纹理位图
//                    slowTraffic = BitmapFactory.decodeResource(resources, R.mipmap.ic_app)
//                    //交通状况拥堵下的纹理位图
//                    jamTraffic = BitmapFactory.decodeResource(resources, R.mipmap.ic_app)
                }
                routeOverlayOptions = route
            }
            viewOptions = options
        }
    }

    /**
     * 初始化mAMapNavi
     */
    private fun initAMapNavi() {
        mAMapNavi = AMapNavi.getInstance(requireContext())
        mAMapNavi.apply {
            addAMapNaviListener(this@SetOutFragment)
            addParallelRoadListener(this@SetOutFragment)
            //设置使用内部语音播报
            setUseInnerVoice(true, false)
            //设置模拟导航的行车速度
            setEmulatorNaviSpeed(100)
            //位置更新的时间间隔
            startGPS(100)
        }
    }

    /**
     * 初始化定位 并开启单次定位
     */
    private fun initLocation() {
        Timber.d("初始化定位服务")
        // 设置定位模式为AMapLocationMode.Hight_Accuracy，高精度模式。
        mLocationOption.locationMode = AMapLocationClientOption.AMapLocationMode.Hight_Accuracy
        Timber.d("启动单次定位模式")
        mLocationOption.isOnceLocation = true
        //获取最近3s内精度最高的一次定位结果：
        //设置setOnceLocationLatest(boolean b)接口为true，启动定位时SDK会返回最近3s内精度最高的一次定位结果。如果设置其为true，setOnceLocation(boolean b)接口也会被设置为true，反之不会，默认为false。
        mLocationOption.isOnceLocationLatest = true
        //设置是否允许模拟位置,默认为true，允许模拟位置
        mLocationOption.isMockEnable = false
        //关闭缓存
        mLocationOption.isLocationCacheEnable = false
        // 给定位客户端对象设置定位参数
        mLocationClient.setLocationOption(mLocationOption)
        // 设置定位监听器
        mLocationClient.setLocationListener(this)
        //开启定位
        mLocationClient.startLocation()
    }

    /**
     * 返回
     */
    private fun backUp() {
        //查询是否有未开启和进行中的盲盒
        BaseViewModel.updateCheckBeingBox.value = System.currentTimeMillis().toString()
        //更新个人信息
        BaseViewModel.updateUserMessage.value = System.currentTimeMillis().toString()
        findNavController().navigateUp()
    }

    //其他导航弹框
    private fun otherNavigation() {
        val constraintLayoutC =
            navigationAnyLayer?.getView<ConstraintLayout>(R.id.ConstraintLayoutC)
        val threeGroup = navigationAnyLayer?.getView<Group>(R.id.ThreeBtnGroup)

        anyLayer(true).contentView(R.layout.dialog_other_navigation)
            .gravity(Gravity.BOTTOM)
            .swipeDismiss(SwipeLayout.Direction.BOTTOM)
            .onClickToDismiss({ _, _ -> }, R.id.Cancel)
            //百度
            .onClickToDismiss({ _, _ ->
                SkipOtherApp.goBaiDu(
                    requireActivity(),
                    mViewModel.boxGetOneLiveData.value?.realname ?: "",
                    mViewModel.mEndPoint.latitude.toString(),
                    mViewModel.mEndPoint.longitude.toString()
                )
            }, R.id.BaiDu)
            //高德
            .onClickToDismiss({ _, _ ->
                SkipOtherApp.goGeoDe(
                    requireActivity(),
                    mViewModel.boxGetOneLiveData.value?.realname ?: "",
                    mViewModel.mEndPoint.latitude.toString(),
                    mViewModel.mEndPoint.longitude.toString()
                )
            }, R.id.GaoDe)
            .onDismissListener(object : Layer.OnDismissListener {
                override fun onDismissing(layer: Layer) {
                    if (constraintLayoutC.isVisible()) {
                        threeGroup.visible()
                    }
                }

                override fun onDismissed(layer: Layer) {
                    setOutGetFocus()
                }
            })
            .show()
    }

    /**
     * 关闭导航和到达弹窗
     */
    private fun closeNavArriveDialog() {
        arriveNewAnyLayer?.apply {
            if (isShown) dismiss()
        }
        navigationAnyLayer?.let {
            if (it.isShown) it.dismiss()
        }
    }

    /**
     * 关闭导航弹窗
     */
    private val closeAnyLayer by lazy {
        AnyLayer.dialog(requireContext())
            //点击浮层以外区域是否可关闭
            .cancelableOnTouchOutside(false).contentView(R.layout.dialog_amap_close)
            .gravity(Gravity.BOTTOM)
            .swipeDismiss(SwipeLayout.Direction.BOTTOM)
            .onClickToDismiss({ _, _ ->
                navigationAnyLayer?.getView<Group>(R.id.ThreeBtnGroup).visible()
                setOutGetFocus()
            }, R.id.Cancel)
            //退出并关闭行程
            .onClickToDismiss({ _, _ ->
                //是否震动过了 / 是否已到达
                if (mViewModel.isVibrate) {
                    closeNavArriveDialog()
                    backUp()
                    return@onClickToDismiss
                }
                mViewModel.boxCancelBox()
            }, R.id.One)
            //退出导航
            .onClickToDismiss({ _, _ ->
                closeNavArriveDialog()
                backUp()
            }, R.id.Two)
    }

    //新的到达弹窗
    private var arriveNewAnyLayer: Layer? = null
    private fun arriveNewAnyLayer() {
        arriveNewAnyLayer = AnyLayer.dialog(requireContext())
            //点击浮层以外区域是否可关闭
            .cancelableOnTouchOutside(false).contentView(R.layout.dialog_arrive_new)
            //不拦截物理按键
            .interceptKeyEvent(false)
            .onInitialize { layer ->
                val data = mViewModel.boxGetOneLiveData.value ?: return@onInitialize
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
                    if (!evaluateAnyLayer.isShown) evaluateAnyLayer.show()
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
                }

                override fun onDismissed(layer: Layer) {}
            })
        arriveNewAnyLayer!!.show()
    }

    //没有找到目的地弹窗
    private fun notFindAnyLayer(data: GetOneBoxData.Parentlist.Childlist) {
        anyLayerBottom(R.layout.dialog_not_found_location, true, R.color.c_BF00A473, R.color.c_F)
            .onClickToDismiss(R.id.Close)
            .onClick({ layer, _ ->
                val onePhone = layer.getView<TextView>(R.id.PhoneB)?.text.toString()
                if (onePhone == "暂无") return@onClick
                SkipOtherApp.callPhone(this, onePhone)
            }, R.id.PhoneB)
            .onClick({ layer, _ ->
                val twoPhone = layer.getView<TextView>(R.id.PhoneC)?.text.toString()
                if (twoPhone == "暂无") return@onClick
                SkipOtherApp.callPhone(this, twoPhone)
            }, R.id.PhoneC)
            //高德地图
            .onClick({ _, _ ->
                SkipOtherApp.goGeoDe(
                    requireActivity(),
                    data.realname ?: "",
                    data.lnglat?.lat.toString(),
                    data.lnglat?.lng.toString()
                )
            }, R.id.Geode)
            //百度地图
            .onClick({ _, _ ->
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
            .onDismissListener(object : Layer.OnDismissListener {
                override fun onDismissing(layer: Layer) {}

                override fun onDismissed(layer: Layer) {
                    setOutGetFocus()
                }
            })
            .show()
    }

    //评价弹窗
    private val evaluateAnyLayer by lazy {
        anyLayer(true).contentView(R.layout.dialog_arrive_evaluate)
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
                override fun onDismissing(layer: Layer) {}
                override fun onDismissed(layer: Layer) {
                    setOutGetFocus()
                }
            })
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

    //导航弹窗
    private var navigationAnyLayer: Layer? = null
    private fun navigationAnyLayer() {
        navigationAnyLayer = AnyLayer.dialog(requireContext())
            //点击浮层以外区域是否可关闭
            .cancelableOnTouchOutside(false).contentView(R.layout.dialog_amap_navigation)
            .onClick({ _, _ ->
                otherNavigation()
            }, R.id.OtherNaviA)
            .onInitialize { layer ->
                //显示导航布局
                val constB = layer.getView<ConstraintLayout>(R.id.ConstraintLayoutB)
                val constC = layer.getView<ConstraintLayout>(R.id.ConstraintLayoutC)

                //请先前往
                val bTextA = layer.getView<TextView>(R.id.TextViewA)
                val cTextA = layer.getView<TextView>(R.id.CTextA)

                //行程弹窗
                val journey = layer.getView<View>(R.id.JourneyDialog)

                //地点
                val cLocation = layer.getView<TextView>(R.id.CLocation)
                val cInfoIcon = layer.getView<ImageView>(R.id.InfoIcon)

                if (!mViewModel.notCountDown) {
                    //附近
                    val location = layer.getView<TextView>(R.id.Location)
                    mViewModel.boxGetOneLiveData.value?.buildName?.let {
                        val str = it.replace("附近", " 附近")

                        val spannableInfo =
                            str.differentTestSize(str.length - 2, str.length, 0.56f)
                        location?.movementMethod = LinkMovementMethod.getInstance()
                        location?.text = spannableInfo
                    }
                    //倒计时
                    lifecycleScope.launch {
                        for (i in 2 downTo 1) {
                            delay(if (i == 2) 1500 else 1000)
                            if (i == 1) {
                                delay(500)
                                //地点
                                cLocation?.let {
                                    location?.transScaleXY(it, 0.45f, 0.45f, 700) {}
                                    constB?.alpha0(1400)
                                    constC?.alpha1(1300)
                                }
                                //请先前往
                                cTextA?.let {
                                    bTextA?.transScaleXY(it, 0.8f, 0.8f, 700) {}
                                }
                            }
                        }
                    }
                } else {
                    constB?.gone()
                    constC?.visible()
                }

                mViewModel.boxGetOneLiveData.value?.buildName?.let {
                    val str = it.replace("附近", " 附近")

                    //加粗
                    val spannableInfoC = SpannableStringBuilder(str)
                    spannableInfoC.setSpan(
                        StyleSpan(Typeface.BOLD),
                        0,
                        str.length - 2,
                        Spannable.SPAN_EXCLUSIVE_INCLUSIVE
                    )
                    cLocation?.text = spannableInfoC
                }
                //地图的元素
                distanceA = layer.getView<TextView>(R.id.DistanceA)!!
                distanceB = layer.getView<TextView>(R.id.DistanceB)!!
                address = layer.getView<TextView>(R.id.Address)!!
                nextTurnA = layer.getView<NextTurnTipView>(R.id.NextTurnA)!!

                val threeBtnGroup = navigationAnyLayer?.getView<Group>(R.id.ThreeBtnGroup)
                //其他导航
                layer.getView<ImageView>(R.id.OtherNavi)?.setOnClickListener {
                    threeBtnGroup.gone()
                    otherNavigation()
                }
                //关闭
                layer.getView<ImageView>(R.id.Close)?.setOnClickListener {
                    threeBtnGroup.gone()
                    closeAnyLayer.show()
                }
                //中间的按钮
                val constraintLayoutA = layer.getView<ConstraintLayout>(R.id.ConstraintLayoutA)
                layer.getView<ImageView>(R.id.Touch)?.setOnTouchListener { view, motionEvent ->
                    when (motionEvent.action) {
                        //按下
                        MotionEvent.ACTION_DOWN -> {
                            constraintLayoutA.gone()
                        }
                        //抬起
                        MotionEvent.ACTION_UP -> {
                            constraintLayoutA.visible()
                        }
                        //移动
                        MotionEvent.ACTION_MOVE -> {
                        }
                    }
                    true
                }

                val clickJourney = {
                    if (journey.isGone()) {
                        threeBtnGroup?.gone()
                        journey?.alpha1(200)
                    }
                }
                //点击 图标/"请先前往"/地点 弹出行程弹窗
                cLocation?.setOnClickListener {
                    clickJourney()
                }
                cTextA?.setOnClickListener {
                    clickJourney()
                }
                cInfoIcon?.setOnClickListener {
                    clickJourney()
                }

                //行程弹窗
                mViewModel.boxGetOneLiveData.value?.apply {
                    journey?.apply {
                        //顶部背景
                        findViewById<ShapeableImageView>(R.id.TypePic)
                            .glideDefault(
                                requireContext(),
                                (pic ?: "").fillHW(594, 933),
                                false
                            )
                        //品类标签
                        findViewById<ImageView>(R.id.Type).glideDefault(
                            requireContext(),
                            typelogo ?: "",
                            false
                        )
                        //标题
                        findViewById<TextView>(R.id.StoreName).text = title ?: ""
                        //详情
                        findViewById<TextView>(R.id.TypeDescribe).text = detail ?: ""
                        items?.forEach { item ->
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
                            this.alpha0(200)
                            threeBtnGroup?.visible()
                        }
                    }
                }
            }
            .onDismissListener(object : Layer.OnDismissListener {
                override fun onDismissing(layer: Layer) {
                    //停止播放动画
                    layer.getView<LottieAnimationView>(R.id.CountDown)?.pauseAnimation()
                }

                override fun onDismissed(layer: Layer) {}
            })
            //长按下一路口地址开启模拟导航 todo 测试
            .onLongClick({ _, _ ->
                //停止导航
                mAMapNavi.stopNavi()
                //开启模拟导航
                mAMapNavi.startNavi(NaviType.EMULATOR)
            }, R.id.Address)
            //不拦截物理按键
            .interceptKeyEvent(false)
        navigationAnyLayer!!.show()
    }

    //导航过程中的信息更新，请看NaviInfo的具体说明
    override fun onNaviInfoUpdate(p0: NaviInfo?) {
        mDataBind.apply {

            navigationAnyLayer?.let {
                //导航弹窗显示中
                if (it.isShown) {
                    mIconType = naviIngChange.naviIconChange(p0?.iconType)
                    when (mIconType) {
                        //用自带的
                        null -> {
                            //更新路口转向图标
                            when {
                                p0?.iconBitmap != null -> nextTurnA.setImageBitmap(p0.iconBitmap)
                                else -> p0?.iconType?.let { nextTurnA.setIconType(it) }
                            }
                        }
                        else -> nextTurnA.setImageResource(mIconType!!)
                    }

                    //下一路口名
                    address.text = p0?.nextRoadName
                    //距离
                    distanceA.text = MapUtil.formatKM(p0?.curStepRetainDistance ?: 0)
                    //单位
                    distanceB.text = MapUtil.formatKMUnit(p0?.curStepRetainDistance ?: 0)
                }
            }

            //修改地图上的终点元素
            drawStore(p0?.pathRetainTime ?: 0)

            //请求盲盒到达接口
            mViewModel.apply {
                if (!isVibrate && p0?.pathRetainDistance ?: 0 < 120) {
                    arrivedBox()
                }
            }
        }
    }

    override fun onCalculateRouteSuccess(p0: AMapCalcRouteResult?) {
        //开启步行导航 GPS
        mAMapNavi.startNavi(NaviType.GPS)
        //显示导航弹窗
        navigationAnyLayer?.let {
            if (!it.isShown) it.show()
        } ?: run {
            navigationAnyLayer()
        }
        setOutGetFocus()
    }

    //单次定位结果
    override fun onLocationChanged(p0: AMapLocation?) {
        if (p0 != null) {
            when (p0.errorCode) {
                AMapLocation.LOCATION_SUCCESS -> {
                    // 定位成功，可在其中解析amapLocation获取相应内容。
                    Timber.d("定位成功：经度 = %f, 纬度 = %f", p0.longitude, p0.latitude)

                    aMap.animateCamera(
                        CameraUpdateFactory.newLatLng(LatLng(p0.latitude, p0.longitude))
                    )

                    val startLatLng = NaviLatLng(p0.latitude, p0.longitude)
                    mViewModel.mStartPoint = startLatLng
                    startDistance(p0.latitude, p0.longitude)
                }
                AMapLocation.ERROR_CODE_FAILURE_LOCATION_PERMISSION -> {
                    ToastUtils.show("请先授权定位权限")
                }
                else -> {
                    ToastUtils.show("定位出错 ${p0.errorCode} ${p0.errorInfo}")
                }
            }
        }
    }

    private var residueDuration: Int? = null

    /**
     * 绘制终点店铺
     * [isWalk] 是否是步行
     * [duration] 预计行驶时间
     */
    private fun drawStore(duration: Int?) {

        if (duration != null) {
            val newDuration = duration / 60
            if (residueDuration == null || residueDuration != newDuration) residueDuration =
                newDuration
            else return
        }

        val storeView = this.layoutInflater.inflate(
            R.layout.view_amap_marker,
            mDataBind.ConstraintLayoutA,
            false
        )
        //绘制背景
        val image = storeView.findViewById<CircleImageView>(R.id.ImageViewA)
        //店铺图片
        image.glideDefault(requireContext(), mViewModel.boxGetOneLiveData.value?.pic.toString()) {
            //步行/驾车图标
            storeView.findViewById<ImageView>(R.id.Pattern)
                .setImageResource(if (isWalk) R.mipmap.ic_marker_walk else R.mipmap.ic_marker_car)
            //步行/驾车文字
            storeView.findViewById<TextView>(R.id.PatternStr).text =
                "${if (isWalk) "步行" else "驾车"} "
            //步行/驾车时间
            storeView.findViewById<TextView>(R.id.Time)?.text =
                "${if (duration == null) "未知" else duration / 60} 分钟"
            markerOptions.icon(BitmapDescriptorFactory.fromView(storeView))
            //店铺的marker 有的话就先删除掉
            storeMarker?.remove()
            storeMarker = aMap.addMarker(markerOptions)
        }
    }

    //测距
    private fun startDistance(lat: Double, lng: Double) {
        //起点
        distanceQuery.origins = listOf(LatLonPoint(lat, lng))
        //终点
        distanceQuery.destination =
            LatLonPoint(mViewModel.mEndPoint.latitude, mViewModel.mEndPoint.longitude)
        //步行距离
        distanceQuery.type = DistanceSearch.TYPE_WALK_DISTANCE
        //发送测距请求
        distanceSearch.calculateRouteDistanceAsyn(distanceQuery)
    }

    //测距
    override fun onDistanceSearched(p0: DistanceResult?, p1: Int) {
        if (p1 == 1000) {
            //步行距离 米
            val distance = p0?.distanceResults?.get(0)?.distance?.toInt() ?: 0
            if (distance <= 3000)
            //步行
                mAMapNavi.calculateWalkRoute(mViewModel.mEndPoint)
            else
            //驾车
                mAMapNavi.calculateDriveRoute(
                    listOf(mViewModel.mEndPoint),
                    arrayListOf<NaviLatLng>(),
                    PathPlanningStrategy.DRIVING_MULTIPLE_ROUTES_DEFAULT
                )
            isWalk = distance <= 3000

            return
        }

        isWalk = true
        //测距失败直接步行导航
        mAMapNavi.calculateWalkRoute(mViewModel.mStartPoint, mViewModel.mEndPoint)
    }

    override fun onResume() {
        super.onResume()
        if (goWebActivity) {
            backUp()
            return
        }
        mDataBind.AMapNaviViewA.onResume()
    }

    override fun onDestroy() {
        super.onDestroy()
        mDataBind.AMapNaviViewA.onDestroy()
        mAMapNavi.stopNavi()
        AMapNavi.destroy()
        playVibrate.cancelVibrate()
        mLocationClient.onDestroy()
    }

    override fun onPause() {
        super.onPause()
        mDataBind.AMapNaviViewA.onPause()
        mLocationClient.stopLocation()
    }

    override fun fragmentConfigInit(): FragmentConfigData = FragmentConfigData(
        showToolbar = false,
        statusBarMode = StatusBarMode.STATUS_BAR_MODE_DARK,
        transparentNavigationBar = true
    )

}
package com.zhixing.zxhy.ui.fragment

import android.os.Bundle
import android.util.Log
import androidx.navigation.fragment.findNavController
import com.amap.api.location.AMapLocation
import com.amap.api.location.AMapLocationClient
import com.amap.api.location.AMapLocationClientOption
import com.amap.api.location.AMapLocationListener
import com.amap.api.maps.AMap
import com.amap.api.maps.CameraUpdateFactory
import com.amap.api.maps.model.LatLng
import com.amap.api.maps.model.MarkerOptions
import com.amap.api.services.core.LatLonPoint
import com.amap.api.services.route.DistanceResult
import com.amap.api.services.route.DistanceSearch
import com.tuanliu.common.base.BaseDbFragment
import com.tuanliu.common.base.BaseViewModel
import com.tuanliu.common.model.FragmentConfigData
import com.tuanliu.common.model.StatusBarMode
import com.zhixing.zxhy.databinding.FragmentCheckSiteBinding
import com.zhixing.zxhy.util.mapUtil.AMapUtil
import com.zhixing.zxhy.util.mapUtil.MapUtil
import com.zhixing.zxhy.view_model.CheckSiteViewModel
import timber.log.Timber

/**
 * 查看地址页面
 */
class CheckSiteFragment : BaseDbFragment<CheckSiteViewModel, FragmentCheckSiteBinding>(),
    AMapLocationListener, DistanceSearch.OnDistanceSearchListener {

    //地图控制器对象
    private lateinit var aMap: AMap

    //高德定位服务客户端
    private val mLocationClient: AMapLocationClient by lazy {
        AMapLocationClient(requireContext())
    }

    //高德地图定位参数
    private val mLocationOption: AMapLocationClientOption by lazy {
        AMapLocationClientOption()
    }

    //测距
    private val distanceSearch by lazy { DistanceSearch(requireContext()) }
    private val distanceQuery by lazy { DistanceSearch.DistanceQuery() }

    override fun initView(savedInstanceState: Bundle?) {
        mDataBind.apply {
            mViewModel.checkSiteData.value = arguments?.getParcelable("checkSiteData")
            vm = mViewModel
            Back.setOnClickListener {
                findNavController().navigateUp()
            }
        }

        distanceSearch.setDistanceSearchListener(this@CheckSiteFragment)

        initAMap()
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
            //不禁用所有手势
            setAllGesturesEnabled(true)
            //隐藏右下角的缩放按钮
            isZoomControlsEnabled = false
        }
        initLocation()
    }

    /**
     * 初始化并开始单次定位
     */
    private fun initLocation() {
        Timber.d("初始化定位服务")
        // 设置定位模式 Hight_Accuracy：高精度模式 Battery_Saving：低功耗模式
        mLocationOption.locationMode = AMapLocationClientOption.AMapLocationMode.Hight_Accuracy
        mLocationOption.isOnceLocation = true
        //获取最近3s内精度最高的一次定位结果：
        //设置setOnceLocationLatest(boolean b)接口为true，启动定位时SDK会返回最近3s内精度最高的一次定位结果。如果设置其为true，setOnceLocation(boolean b)接口也会被设置为true，反之不会，默认为false。
        mLocationOption.isOnceLocationLatest = true
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
        //开始定位
        mLocationClient.startLocation()
    }

    //测距
    private fun startDistance(startLatLng: LatLng, endLatLng: LatLng) {
        //起点
        distanceQuery.apply {
            origins = listOf(LatLonPoint(startLatLng.latitude, startLatLng.longitude))
            //终点
            destination =
                LatLonPoint(endLatLng.latitude, endLatLng.longitude)
            //直线距离
            type = DistanceSearch.TYPE_DRIVING_DISTANCE
        }
        //发送测距请求
        distanceSearch.calculateRouteDistanceAsyn(distanceQuery)
    }

    override fun onLocationChanged(p0: AMapLocation?) {
        if (p0 != null) {
            when (p0.errorCode) {
                AMapLocation.LOCATION_SUCCESS -> {
                    BaseViewModel.saveLatLng(p0.latitude, p0.longitude)

                    val latLng = LatLng(mViewModel.checkSiteData.value!!.lat, mViewModel.checkSiteData.value!!.lng)
                    aMap.moveCamera(CameraUpdateFactory.newLatLngZoom(latLng, 15.4f))
                    aMap.addMarker(MarkerOptions().position(latLng))
                    //开始测距
                    startDistance(LatLng(p0.latitude, p0.longitude), latLng)
                }
                AMapLocation.ERROR_CODE_FAILURE_LOCATION_PERMISSION -> Log.e("xxx", "未给予定位权限")
                else -> Log.e("xxx", "定位出错 ${p0.errorCode} ${p0.errorInfo}")
            }
        }
    }

    override fun onDistanceSearched(p0: DistanceResult?, p1: Int) {
        val distance =
            MapUtil.getFriendlyLengthB(p0?.distanceResults?.get(0)?.distance?.toInt() ?: 0)
        mDataBind.Distance.text = "距离你 $distance"
    }

    override fun onResume() {
        super.onResume()
        mDataBind.MapViewA.onResume()
    }

    override fun onDestroy() {
        super.onDestroy()
        mDataBind.MapViewA.onDestroy()
        mLocationClient.onDestroy()
    }

    override fun onPause() {
        super.onPause()
        mDataBind.MapViewA.onPause()
        mLocationClient.stopLocation()
    }

    override fun fragmentConfigInit(): FragmentConfigData =
        FragmentConfigData(
            false,
            transparentStatusBar = false,
            statusBarMode = StatusBarMode.STATUS_BAR_MODE_DARK,
            transparentNavigationBar = true
        )

}
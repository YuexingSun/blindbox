package com.zhixing.zxhy.ui.fragment

import android.os.Bundle
import android.util.Log
import android.view.KeyEvent
import android.view.animation.AnimationUtils
import android.view.inputmethod.EditorInfo
import androidx.navigation.fragment.findNavController
import androidx.recyclerview.widget.LinearLayoutManager
import com.amap.api.location.AMapLocation
import com.amap.api.location.AMapLocationClient
import com.amap.api.location.AMapLocationClientOption
import com.amap.api.location.AMapLocationListener
import com.amap.api.services.core.LatLonPoint
import com.amap.api.services.core.PoiItem
import com.amap.api.services.poisearch.PoiResult
import com.amap.api.services.poisearch.PoiSearch
import com.blankj.utilcode.util.KeyboardUtils
import com.hjq.toast.ToastUtils
import com.tuanliu.common.base.BaseDbFragment
import com.tuanliu.common.base.BaseRvAdapter
import com.tuanliu.common.base.BaseViewModel
import com.tuanliu.common.ext.loadListSuccess
import com.tuanliu.common.ext.loadMore
import com.tuanliu.common.ext.visible
import com.tuanliu.common.model.FragmentConfigData
import com.tuanliu.common.model.StatusBarMode
import com.zhixing.zxhy.R
import com.zhixing.zxhy.SeekLocaData
import com.zhixing.zxhy.databinding.FragmentSeekLocationBinding
import com.zhixing.zxhy.databinding.ViewSeekLocationBinding
import com.zhixing.zxhy.view_model.SeekLocationViewModel
import timber.log.Timber

/**
 * 搜索地址页面
 */
class SeekLocationFragment : BaseDbFragment<SeekLocationViewModel, FragmentSeekLocationBinding>(),
    AMapLocationListener, PoiSearch.OnPoiSearchListener {

    private val arrayList = arrayListOf<SeekLocaData>()

    private lateinit var query: PoiSearch.Query

    private lateinit var poiSearch: PoiSearch

    //高德定位服务客户端
    private val mLocationClient: AMapLocationClient by lazy {
        AMapLocationClient(requireContext())
    }

    //高德地图定位参数
    private val mLocationOption: AMapLocationClientOption by lazy {
        AMapLocationClientOption()
    }

    //poi的城市
    private var city: String = ""

    //页码
    private var pageNum: Int = 1

    override fun initView(savedInstanceState: Bundle?) {
        mDataBind.apply {
            //取消
            Cancel.setOnClickListener {
                setOutGetFocus("", 0.0, 0.0, "", 0.0)
            }
            //不显示地址
            NotLocation.setOnClickListener {
                setOutGetFocus("", 0.0, 0.0, "", 0.0)
            }
            //地址列表
            RecycA.apply {
                layoutManager = object : LinearLayoutManager(requireContext(), VERTICAL, false) {}
                adapter = locaListAdapter
                visible()
            }
            SmartA.apply {
                loadMore {
                    startPoi(true)
                }
            }
            //搜索栏
            Search.apply {
                inputType = EditorInfo.TYPE_CLASS_TEXT
                imeOptions = EditorInfo.IME_ACTION_SEARCH
                setOnKeyListener { _, p1, _ ->
                    if (p1 == KeyEvent.KEYCODE_ENTER) {
                        val editStr = this.text.toString()
                        if (editStr.isNotBlank()) {
                            KeyboardUtils.hideSoftInput(requireView())
                            locaListAdapter.deleteData()
                            initPoiSearch(this.text.toString())
                            startPoi()
                        } else ToastUtils.show("搜索内容不能为空")
                    }
                    //这里不拦截其他事件，以防无法传递，例如删除
                    false
                }
            }

            initPoiSearch()
            initLocation()
        }
    }

    /**
     * 初始化定位
     */
    private fun initLocation() {
        Timber.d("初始化定位服务")
        // 设置定位模式 Hight_Accuracy：高精度模式 Battery_Saving：低功耗模式
        mLocationOption.locationMode = AMapLocationClientOption.AMapLocationMode.Battery_Saving
        Timber.d("启动单次定位模式")
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
        //启动定位
        mLocationClient.startLocation()
    }

    /**
     * [keyWord] 搜索地点
     */
    private fun initPoiSearch(keyWord: String = "") {
        query = PoiSearch.Query(keyWord, null, city).apply {
            //每页返回多少数据
            pageSize = 15
            //页码
            pageNum = pageNum
            //返回完整字段
            extensions = PoiSearch.EXTENSIONS_ALL
        }
        poiSearch = PoiSearch(requireContext(), query)
        poiSearch.setOnPoiSearchListener(this)
    }

    /**
     * 开始搜索地址
     * [loadMore] 是否是下拉刷新
     */
    private fun startPoi(loadMore: Boolean = false) {
        if (!loadMore) {
            pageNum = 1
        }
        query.pageNum = pageNum
        poiSearch.searchPOIAsyn()
    }

    /**
     * 返回的时候带上地址数据
     */
    private fun setOutGetFocus(address: String, lng: Double, lat: Double, detailsAddress: String, point: Double) {
        findNavController().previousBackStackEntry?.savedStateHandle?.set(
            "LOCATION",
            arrayOf(address, lng.toString(), lat.toString(), detailsAddress, point.toString())
        )
        findNavController().popBackStack()
    }

    //地址的adapter
    private val locaListAdapter =
        object : BaseRvAdapter<SeekLocaData, ViewSeekLocationBinding>() {

            override fun onBindItem(
                holder: BaseViewHolder,
                binding: ViewSeekLocationBinding,
                item: SeekLocaData,
                position: Int
            ) {
                binding.apply {
                    ConstA.animation = AnimationUtils.loadAnimation(holder.itemView.context, R.anim.centre_scale_in)
                    ConstA.setOnClickListener {
                        setOutGetFocus(item.address, item.lng, item.lat, item.detailAddress, item.point)
                    }
                    Location.text = item.address
                    DetailLoca.text = item.detailAddress
                }
            }

            override fun getLayoutResId(viewType: Int): Int = R.layout.view_seek_location
        }

    override fun onLocationChanged(p0: AMapLocation?) {
        if (p0 != null) {
            when (p0.errorCode) {
                AMapLocation.LOCATION_SUCCESS -> {
                    city = p0.city
                    BaseViewModel.saveLatLng(p0.latitude, p0.longitude)
                    poiSearch.bound =
                        PoiSearch.SearchBound(LatLonPoint(p0.latitude, p0.longitude), 50)
                    startPoi()
                }
                AMapLocation.ERROR_CODE_FAILURE_LOCATION_PERMISSION -> Log.e("xxx", "未给予定位权限")
                else -> Log.e("xxx", "定位出错 ${p0.errorCode} ${p0.errorInfo}")
            }
        }
    }

    override fun onPoiSearched(p0: PoiResult?, p1: Int) {
        when (p1) {
            1000 -> {
                pageNum++
                arrayList.clear()
                p0?.pois?.forEach { poiItem ->
                    arrayList.add(
                        SeekLocaData(
                            poiItem.title,
                            "${poiItem.cityName}${poiItem.adName}${poiItem.snippet}",
                            poiItem.latLonPoint.longitude,
                            poiItem.latLonPoint.latitude,
                            poiItem.poiExtension.getmRating().toDoubleOrNull() ?: 0.0
                        )
                    )
                }
                val pageNum = p0?.query?.pageNum ?: 1
                val pageCount = p0?.pageCount ?: 1
                locaListAdapter.loadListSuccess(
                    pageNum == 1,
                    arrayList.size == 0 && pageNum == 1,
                    pageNum != pageCount,
                    arrayList,
                    mDataBind.SmartA
                )
            }
            else -> Log.i("xxx", "获取poi失败")
        }

    }

    override fun onPoiItemSearched(p0: PoiItem?, p1: Int) {}

    override fun onResume() {
        super.onResume()
        getFocus {
            setOutGetFocus("", 0.0, 0.0, "", 0.0)
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        mLocationClient.onDestroy()
    }

    override fun onPause() {
        super.onPause()
        mLocationClient.stopLocation()
    }

    override fun fragmentConfigInit(): FragmentConfigData =
        FragmentConfigData(
            false,
            transparentStatusBar = false,
            statusBarMode = StatusBarMode.STATUS_BAR_MODE_DARK,
            transparentNavigationBar = false,
            navigationBarColor = R.color.c_EF
        )

}
package com.zhixing.zxhy.base

import android.util.Log
import androidx.databinding.ViewDataBinding
import com.amap.api.location.AMapLocation
import com.amap.api.location.AMapLocationListener
import com.amap.api.navi.AMapNaviListener
import com.amap.api.navi.AMapNaviViewListener
import com.amap.api.navi.ParallelRoadListener
import com.amap.api.navi.enums.AMapNaviParallelRoadStatus
import com.amap.api.navi.model.*
import com.amap.api.services.route.DistanceResult
import com.amap.api.services.route.DistanceSearch
import com.tuanliu.common.base.BaseDbFragment
import com.tuanliu.common.base.BaseViewModel

/**
 * 导航地图的基类
 */
abstract class BaseAMapDbFragment<VM : BaseViewModel, DB : ViewDataBinding>: BaseDbFragment<VM, DB>(),
    AMapNaviListener,
    AMapNaviViewListener, ParallelRoadListener, AMapLocationListener,
    DistanceSearch.OnDistanceSearchListener {

    companion object {
        private val TAG = "地图地图"
    }

    override fun onInitNaviFailure() {
        Log.d(TAG, "地图导航初始化失败")
    }

    //初始化成功
    //AMapNavi 对象是单例的，onInitNaviSuccess只执行一次
    override fun onInitNaviSuccess() {}

    //开始导航回调
    override fun onStartNavi(p0: Int) {
    }

    override fun onTrafficStatusUpdate() {
    }

    //当前位置回调
    override fun onLocationChange(p0: AMapNaviLocation?) {
    }

    //播报类型和播报文字回调
    override fun onGetNavigationText(p0: Int, p1: String?) {
    }

    override fun onGetNavigationText(p0: String?) {
    }

    //结束模拟导航
    override fun onEndEmulatorNavi() {
    }

    //到达目的地
    override fun onArriveDestination() {
    }

    override fun onCalculateRouteFailure(p0: Int) {
    }

    override fun onCalculateRouteFailure(p0: AMapCalcRouteResult?) {
        //路线计算失败
        Log.e(TAG, "--------------------------------------------");
        Log.i(
            TAG,
            "路线计算失败：错误码=" + p0?.getErrorCode() + ",Error Message= " + p0?.getErrorDescription()
        );
        Log.i(TAG, "错误码详细链接见：http://lbs.amap.com/api/android-navi-sdk/guide/tools/errorcode/");
        Log.e(TAG, "--------------------------------------------");
    }

    //偏航后重新计算路线回调
    override fun onReCalculateRouteForYaw() {
    }

    //拥堵后重新计算路线回调
    override fun onReCalculateRouteForTrafficJam() {
    }

    //到达途径点
    override fun onArrivedWayPoint(p0: Int) {
    }

    //GPS开关状态回调
    override fun onGpsOpenStatus(p0: Boolean) {
    }

    //导航过程中的信息更新，请看NaviInfo的具体说明
    override fun onNaviInfoUpdate(p0: NaviInfo?) {

    }

    override fun updateCameraInfo(p0: Array<out AMapNaviCameraInfo>?) {
    }

    override fun updateIntervalCameraInfo(
        p0: AMapNaviCameraInfo?,
        p1: AMapNaviCameraInfo?,
        p2: Int
    ) {
    }

    override fun onServiceAreaUpdate(p0: Array<out AMapServiceAreaInfo>?) {
    }

    //显示放大图回调
    override fun showCross(p0: AMapNaviCross?) {
    }

    //隐藏放大图回调
    override fun hideCross() {
    }

    override fun showModeCross(p0: AMapModelCross?) {
    }

    override fun hideModeCross() {
    }

    //显示车道信息
    override fun showLaneInfo(p0: Array<out AMapLaneInfo>?, p1: ByteArray?, p2: ByteArray?) {
    }

    override fun showLaneInfo(p0: AMapLaneInfo?) {
    }

    //隐藏车道信息
    override fun hideLaneInfo() {
    }

    //多路径算路成功回调
    override fun onCalculateRouteSuccess(p0: IntArray?) {
    }

    override fun onCalculateRouteSuccess(p0: AMapCalcRouteResult?) {

    }

    override fun notifyParallelRoad(p0: Int) {
    }

    //更新交通设施信息
    override fun OnUpdateTrafficFacility(p0: Array<out AMapNaviTrafficFacilityInfo>?) {
    }

    override fun OnUpdateTrafficFacility(p0: AMapNaviTrafficFacilityInfo?) {
    }

    //更新巡航模式的统计信息
    override fun updateAimlessModeStatistics(p0: AimLessModeStat?) {
    }

    //更新巡航模式的拥堵信息
    override fun updateAimlessModeCongestionInfo(p0: AimLessModeCongestionInfo?) {
    }

    override fun onPlayRing(p0: Int) {
    }

    override fun onNaviRouteNotify(p0: AMapNaviRouteNotifyData?) {
    }

    override fun onGpsSignalWeak(p0: Boolean) {
    }

    override fun notifyParallelRoad(p0: AMapNaviParallelRoadStatus?) {
        if (p0?.getmElevatedRoadStatusFlag() == 1) {
            Log.d(TAG, "当前在高架上");
        } else if (p0?.getmElevatedRoadStatusFlag() == 2) {
            Log.d(TAG, "当前在高架下");
        }

        if (p0?.getmParallelRoadStatusFlag() == 1) {
            Log.d(TAG, "当前在主路");
        } else if (p0?.getmParallelRoadStatusFlag() == 2) {
            Log.d(TAG, "当前在辅路");
        }
    }

    //底部导航设置点击回调
    override fun onNaviSetting() {
    }

    override fun onNaviCancel() {
    }

    override fun onNaviBackClick(): Boolean {
        return true
    }

    //导航态车头模式，0:车头朝上状态；1:正北朝上模式。
    override fun onNaviMapMode(p0: Int) {
    }

    //转弯view的点击回调
    override fun onNaviTurnClick() {
    }

    //下一个道路View点击回调
    override fun onNextRoadClick() {
    }

    //全览按钮点击回调
    override fun onScanViewButtonClick() {
    }

    //锁地图状态发生变化时回调
    override fun onLockMap(p0: Boolean) {
    }

    override fun onNaviViewLoaded() {
        Log.d(TAG, "导航页面加载成功");
        Log.d(TAG, "请不要使用AMapNaviView.getMap().setOnMapLoadedListener();会overwrite导航SDK内部画线逻辑");
    }

    override fun onMapTypeChanged(p0: Int) {
    }

    override fun onNaviViewShowMode(p0: Int) {
    }

    //单次定位结果
    override fun onLocationChanged(p0: AMapLocation?) {

    }

    //测距
    override fun onDistanceSearched(p0: DistanceResult?, p1: Int) {

    }

}
package com.zhixing.zxhy.view_model

import android.util.Log
import android.view.View
import android.widget.TextView
import androidx.lifecycle.LiveData
import com.tuanliu.common.base.BaseViewModel
import com.tuanliu.common.net.onBizError
import com.tuanliu.common.net.onBizOK
import com.tuanliu.common.net.onFailure
import com.tuanliu.common.net.onSuccess
import com.zhixing.network.ext.serverData
import com.zhixing.zxhy.repo.BoxDetailRepo
import com.zhixing.zxhy.service.Boxid
import androidx.annotation.Keep
import androidx.lifecycle.MutableLiveData
import com.hjq.toast.ToastUtils
import com.noober.background.drawable.DrawableCreator
import com.tuanliu.common.ext.dp2Pix
import com.tuanliu.common.ext.getResColor
import com.zhixing.zxhy.R


class BoxDetailViewModel : BaseViewModel() {

    companion object {
        private val selectedList =
            listOf<String>("以前来过", "不喜欢这个地方", "导航不清晰", "太好猜", "时间不准确", "找不到店")
    }

    //盲盒id
    var boxid = 0

    //选择 - 是否满意
    val isLike = MutableLiveData<Int>(0)

    /**
     * 改变满意/不满意选择
     */
    fun changeIsLike(like: Int) {
        if (like != isLike.value) isLike.value = like
    }

    //不满意原因 选择的map数据
    private val selectedMap = mutableMapOf<Int, String>()

    /**
     * 选择不满意原因的六个框
     */
    fun selectedBtns(view: View, btnNum: Int) {
        val textView = when (btnNum) {
            1 -> view.findViewById<TextView>(R.id.TextOne)
            2 -> view.findViewById<TextView>(R.id.TextTwo)
            3 -> view.findViewById<TextView>(R.id.TextThree)
            4 -> view.findViewById<TextView>(R.id.TextFour)
            5 -> view.findViewById<TextView>(R.id.TextFive)
            else -> view.findViewById<TextView>(R.id.TextSix)
        }

        when (selectedMap.containsKey(btnNum)) {
            true -> {
                textView.isSelected = false
                selectedMap.remove(btnNum)
            }
            false -> {
                textView.isSelected = true
                selectedMap[btnNum] = selectedList[btnNum - 1]
            }
        }
    }

    //盲盒评价数据
    private val _enjoyBoxLiveData = MutableLiveData<String>()
    val enjoyBoxLiveData: LiveData<String>
        get() = _enjoyBoxLiveData

    //提交评价按钮 - 盲盒评价
    fun submitBtn() = serverAwait {

        if (boxid == 0 && isLike.value == 0) return@serverAwait

        //满意
        val box = if (isLike.value == 1) {
            Boxid(boxid = boxid)
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

        BoxDetailRepo.getBoxEnjoyBox(box).serverData().onSuccess {
            onBizError { code, message ->
                Log.e("xxx", "盲盒评价 接口异常 $code $message")
            }
            onBizOK<Any> { _, _, _ ->
                _enjoyBoxLiveData.postValue(System.currentTimeMillis().toString())
            }
        }.onFailure {
            Log.e("xxx", "盲盒评价 接口异常 $it")
        }
    }

    //盲盒详情数据
    private val _boxDetailLiveData = MutableLiveData<GetOneBoxData.Parentlist.Childlist>()
    val boxDetailLiveData: LiveData<GetOneBoxData.Parentlist.Childlist>
        get() = _boxDetailLiveData

    /**
     * 获取盲盒详情
     */
    fun getBoxDetail(id: Int) = serverAwait {

        val boxid = Boxid(boxid = id)

        BoxDetailRepo.getBoxDetail(boxid).serverData().onSuccess {
            onBizError { code, message ->
                Log.e("xxx", "获取盲盒详情 接口异常 $code $message")
            }
            onBizOK<GetOneBoxData> { _, data, _ ->
                _boxDetailLiveData.postValue(
                    data?.parentlist?.get(data.selparentindex)?.childlist?.get(
                        data.selchildindex
                    )
                )
            }
        }.onFailure {
            Log.e("xxx", "获取盲盒详情 接口异常 $it")
        }
    }

}

@Keep
data class BoxDetailData(
    //	开启行程得到的幸运值
    val beinpoint: String?,
    //参与评价得到的幸运值
    val commentpoint: String?,
    //进行中的盲盒的满意状态，0未选，1满意，2不满意
    val islike: Int,
    //ConstraintLayoutD
    val items: List<Item>?,
    //icon
    val logo: String?,
    //我的评论
    val mycommentlist: List<String>?,
    //评分
    val point: Double,
    //目的地的真实地址
    val readAddress: String?,
    //目的地的真实名称
    val realname: String?,
    //状态 2未评价 - 已完成 3已完成 | 45已失效 - （点不进来）
    val status: Int,
    //真实坐标,高德坐标系
    val lnglat: Lnglat?,
) {
    @Keep
    data class Item(
        //标题
        val item: String?,
        //类型
        val type: Int,
        //内容
        val value: Any?
    )

    data class Lnglat(
        //纬度
        val lat: Double,
        //经度
        val lng: Double
    )
}
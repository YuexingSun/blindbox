package com.zhixing.zxhy

import android.graphics.Bitmap
import com.blankj.utilcode.util.ImageUtils
import com.tencent.mm.opensdk.modelmsg.SendMessageToWX
import com.tencent.mm.opensdk.modelmsg.WXMediaMessage
import com.tencent.mm.opensdk.modelmsg.WXWebpageObject
import com.tencent.mm.opensdk.openapi.IWXAPI
import com.tencent.mm.opensdk.openapi.WXAPIFactory
import com.tuanliu.common.base.appContext

/**
 * 微信开放sdk帮助类
 */
object WxApi {

    const val App_Id = "wx781eb963c8919a48"

    val api: IWXAPI by lazy(mode = LazyThreadSafetyMode.SYNCHRONIZED) {
        WXAPIFactory.createWXAPI(appContext, App_Id, true)
    }

    /**
     * SDK注册
     */
    fun regToWx(): IWXAPI {
        //注册到微信
        api.registerApp(App_Id)
        return api
    }

    /**
     * 分享链接
     * [mScene] 分享类型 timeLine朋友圈 session对话（默认）
     * [url] 链接
     */
    fun sendUrl(
        mScene: SendToWx = SendToWx.Session,
        url: String,
        mTitle: String,
        mDescription: String,
        bitmap: Bitmap
    ) {
        val webpage = WXWebpageObject()
        webpage.webpageUrl = url

        val msg = WXMediaMessage(webpage)
        val replaceTitle = mTitle.replace("<p>", "").replace("</p>", "").replace("<br />", "")
        val replaceDescription =
            mDescription.replace("<p>", "").replace("</p>", "").replace("<br />", "")
        msg.apply {
            //网页标题 不能超过64个字
            title = if (replaceTitle.length > 64) replaceTitle.substring(0, 63) else replaceTitle
            //网页描述 不能超过128个字
            description = if (replaceDescription.length > 128) replaceDescription.substring(
                0,
                127
            ) else replaceDescription
            //图片 不能超过32kb
            thumbData = ImageUtils.compressByQuality(bitmap, 32000L)
        }

        val req = SendMessageToWX.Req()
        req.apply {
            //事务id
            transaction = "01001"
            message = msg
            //场景
            scene = mScene.i
            userOpenId = openId
        }
        api.sendReq(req)
    }

}

enum class SendToWx(val i: Int) {
    /**
     * 分享到朋友圈
     */
    TimeLine(SendMessageToWX.Req.WXSceneTimeline),

    /**
     * 分享到对话
     */
    Session(SendMessageToWX.Req.WXSceneSession)
}
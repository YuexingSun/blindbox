package com.tuanliu.common.ext

//import androidx.lifecycle.rxLifeScope
//import com.zhixinhuixue.library.common.base.BaseViewModel
//import com.zhixinhuixue.library.net.entity.base.LoadingDialogEntity
//import com.zhixinhuixue.library.net.entity.loadingtype.LoadingType
//import kotlinx.coroutines.CoroutineScope
//import timber.log.Timber
//
///**
// * 封装一下 RxHttp请求
// * @receiver BaseViewModel
// * @param requestDslClass [@kotlin.ExtensionFunctionType] Function1<HttpResultDsl, Unit>
// */
//fun BaseViewModel.rxHttpRequest(requestDslClass: HttpRequestDsl.() -> Unit) {
//    val httpRequestDsl = HttpRequestDsl()
//    requestDslClass(httpRequestDsl)
//    rxLifeScope.launch({
//        // 携程体方法执行工作
//        httpRequestDsl.onRequest.invoke(this)
//        //请求完成 走到这里说明请求成功了 如果请求类型为LOADING_XML 那么通知Activity/Fragment展示success 界面
//        if (httpRequestDsl.loadingType == LoadingType.LOADING_XML) {
//
//        }
//    }, {
//        if (httpRequestDsl.onError == null) {
//
//        } else {
//            //请求失败时将错误日志打印一下 防止错哪里了都不晓得
//            it.printStackTrace()
//            Timber.e("请求出错了----> ${it.message}")
//            //传递了 onError 需要自己处理
//            httpRequestDsl.onError?.invoke(it)
//        }
//    }, {
//        //发起请求时
//        if (httpRequestDsl.loadingType != LoadingType.LOADING_NULL) {
//            loadingChange.loading.value =
//                LoadingDialogEntity(
//                    httpRequestDsl.loadingType,
//                    httpRequestDsl.loadingMessage,
//                    true,
//                    httpRequestDsl.requestCode
//                )
//        }
//    }, {
//        //请求结束时
//        if (httpRequestDsl.loadingType != LoadingType.LOADING_NULL) {
//            loadingChange.loading.value =
//                LoadingDialogEntity(
//                    httpRequestDsl.loadingType,
//                    httpRequestDsl.loadingMessage,
//                    false,
//                    httpRequestDsl.requestCode
//                )
//        }
//    })
//}
//
//class HttpRequestDsl {
//    var onRequest: suspend CoroutineScope.() -> Unit = {} //请求工作 在这里执行网络接口请求，然后回调成功数据
//    var onError: ((Throwable) -> Unit)? = null //错误回调，默认为null 如果你传递了他 那么就代表你请求失败的逻辑你自己处理
//    var loadingMessage: String = "请稍候..." //目前这个只有在 loadingType == LOADING_DIALOG 的时候才有用 不是的话都不用传他
//
//    @LoadingType
//    var loadingType = LoadingType.LOADING_NULL// 请求时loading类型
//    var requestCode: String = "mmp" //请求 code 请求错误时 需要根据字段去判断到底是哪个请求 可以用URL去标记
//    var isRefreshRequest: Boolean = false //是否是刷新请求 做列表分页功能使用 一般请求用不到
//    var intentData: Any? =
//        null //请求时回调给发起请求时携带的参数 示例场景：发起请求时传递一个position ,如果请求失败时，可能需要把这个position回调给 activity/fragment 根据position做错误处理
//}

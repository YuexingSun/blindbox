package com.tuanliu.common.net

import android.util.Log
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.hjq.toast.ToastUtils
import com.scwang.smart.refresh.layout.SmartRefreshLayout
import com.tuanliu.common.base.BaseViewModel
import com.zhixing.network.model.BaseResponse
import com.zhixing.network.model.DataResult
import com.zhixing.network.model.NetConstant
import com.zhixing.network.model.succeeded
import java.lang.RuntimeException
import kotlin.contracts.ExperimentalContracts
import kotlin.contracts.InvocationKind
import kotlin.contracts.contract

/**
 * 这里表示网络请求成功，并得到业务服务器的响应
 * 将BaseCniaoRsp的对象，转化为需要的对象类型，也就是将body.string转为entity
 * @return 返回需要类型对象，可能为null，如果json解析失败的话
 * 加了reified才可以T::class.java
 */
inline fun <reified T> BaseResponse.toEntity(): T? {

    if (data == null) {
        Log.e("DataResultExt", "server Response Json Ok,But data==null,$code,$msg")
        return null
    }

    //如果有需要的话在这里对返回的data数据进行解密然后再tojson fromjson

    // val decodeData = CnUtils.decodeData(data.toString())
    //gson不允许我们将json对象采用String,所以单独处理
    // if (T::class.java.isAssignableFrom(String::class.java)) {
    //     return decodeData as T
    // }

    //如果data不为空，先进行tojson处理再转化为T对象类型的entity string
    //传入LoginRsp就是LoginRsp  传入RegisterRsp就是RegisterRsp
    return kotlin.runCatching {
        //Gson不能直接解析泛型 如果遇到List<*>会报错 这里需要借助TypeToken类传递泛型
        val type = object : TypeToken<T>() {}.type
        return Gson().fromJson(Gson().toJson(data), type)
    }.onFailure { e ->
        e.printStackTrace() //Catch出错，报错
    }.getOrNull()
}

/**
 * 接口成功，但是业务返回code不是0的情况
 */
@OptIn(ExperimentalContracts::class)
inline fun BaseResponse.onBizError(
    smartRefreshLayout: SmartRefreshLayout? = null,
    isRefresh: Boolean? = null,
    crossinline block: (code: Int, message: String?) -> Unit
): BaseResponse {
    contract {
        callsInPlace(block, InvocationKind.AT_MOST_ONCE)
    }

    if (code != NetConstant.SUCCESS_CODE) {

        if (smartRefreshLayout != null && isRefresh != null) {
            finishRefresh(smartRefreshLayout, isRefresh)
        }

        //如果没有传递 onError参数 默认调用封装的逻辑
        when (code) {
            NetConstant.ERROR_CODE_10003 -> BaseViewModel.codeRequest.postValue(code)
            else -> ToastUtils.show("$msg")
        }
        //返回错误码和错误信息
        block.invoke(code, msg ?: "Error Message Null")
    }

    return this
}

/**
 * 关闭请求头/尾
 */
fun finishRefresh(smartRefreshLayout: SmartRefreshLayout, isRefresh: Boolean) {
    when (isRefresh) {
        true -> smartRefreshLayout.finishRefresh()
        else -> smartRefreshLayout.finishLoadMore()
    }
}


/**
 * 接口成功且业务成功code==0的情况
 * crossinline关键字 只要标志了就不能进入return true函数快
 */
@OptIn(ExperimentalContracts::class)
inline fun <reified T> BaseResponse.onBizOK(crossinline action: (code: Int, data: T?, message: String?) -> Unit): BaseResponse {
    contract {
        callsInPlace(action, InvocationKind.AT_MOST_ONCE)
    }
    //code == 0,成功
    if (code == NetConstant.SUCCESS_CODE) {
        //返回成功码和解密之后的序列化对象
        action.invoke(code, this.toEntity<T>(), msg)
    }
    return this
}

/**
 * 一定会执行一次的代码
 */
@OptIn(ExperimentalContracts::class)
inline fun <R> DataResult<R>.onExecute(action: () -> Unit): DataResult<R> {
    //契约关系
    contract {
        //最多走一次
        callsInPlace(action, InvocationKind.AT_MOST_ONCE)
    }

    action.invoke()

    return this
}

/*
* 扩展用于处理网络返回数据结果 网络接口请求成功，但是业务成功与否不一定
* 注解 使用的是一个实验性的特性 需要在.gradel编译器中添加参数注明
* */
@OptIn(ExperimentalContracts::class)
inline fun <R> DataResult<R>.onSuccess(action: R.() -> Unit): DataResult<R> {
    //契约关系
    contract {
        callsInPlace(action, InvocationKind.AT_MOST_ONCE) //最多走一次
    }

    if (succeeded) action.invoke((this as DataResult.Success).data)
    return this
}

/*
* 扩展用于处理网络返回数据结果 网络请求出现错误的时候的回调
* */
@OptIn(ExperimentalContracts::class)
inline fun <R> DataResult<R>.onFailure(
    smartRefreshLayout: SmartRefreshLayout? = null,
    isRefresh: Boolean? = null,
    action: (exception: Throwable) -> Unit
): DataResult<R> {
    contract {
        callsInPlace(action, InvocationKind.AT_MOST_ONCE)
    }

    if (smartRefreshLayout != null && isRefresh != null && this is DataResult.Error) {
        finishRefresh(smartRefreshLayout, isRefresh)
    }

    if (this is DataResult.Error) {
        if (exception is RuntimeException) {
            ToastUtils.show("请求超时")
        }
        action.invoke(exception)
    }
    return this
}
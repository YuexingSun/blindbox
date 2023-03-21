package com.zhixing.zxhy.util

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.*

/**
 * 倒计时
 * 异步数据流，该流每次都会发射一个倒计时的剩余时间
 */
fun <T> countdown(
    //倒计时总时长
    duration: Long,
    //倒计时间隔(毫秒)
    interval: Long,
    //倒计时回调
    onCountdown: suspend (Long) -> T
): Flow<T> = flow { (duration - interval downTo 0 step interval).forEach { emit(it) } }
    //流每次发射之间做的事情，中间消费者
    .onEach { delay(interval) }
    //所有数据发射之前做一件事情，中间消费者 onCompletion与其相反，在之后做
    .onStart { emit(duration) }
    //获取每个值
    .map { onCountdown(it) }
    //改变上游流执行线程，不影响下游流所执行的线程
    .flowOn(Dispatchers.Default)
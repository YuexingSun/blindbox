package com.tuanliu.common.ext

/**
 * 数组的扩展函数
 */
inline fun <reified INNER> array2d(
    sizeOuter: Int,
    sizeInner: Int,
    noinline innerInit: (Int) -> INNER
): Array<Array<INNER>> = Array(sizeOuter) { Array<INNER>(sizeInner, innerInit) }

fun array2dOfInt(sizeOuter: Int, sizeInner: Int): Array<IntArray> =
    Array(sizeOuter) { IntArray(sizeInner) }

fun array2dOfLong(sizeOuter: Int, sizeInner: Int): Array<LongArray> =
    Array(sizeOuter) { LongArray(sizeInner) }

fun array2dOfByte(sizeOuter: Int, sizeInner: Int): Array<ByteArray> =
    Array(sizeOuter) { ByteArray(sizeInner) }

fun array2dOfChar(sizeOuter: Int, sizeInner: Int): Array<CharArray> =
    Array(sizeOuter) { CharArray(sizeInner) }

fun array2dOfBoolean(sizeOuter: Int, sizeInner: Int): Array<BooleanArray> =
    Array(sizeOuter) { BooleanArray(sizeInner) }
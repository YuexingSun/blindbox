package com.tuanliu.common.util

import com.google.gson.Gson
import com.google.gson.GsonBuilder

object GsonUtils {
    private val gsonBuilder: GsonBuilder by lazy { GsonBuilder() }
    val gson: Gson by lazy { gsonBuilder.create() }


    fun toJson(paramObject: Any?): String = gson.toJson(paramObject)
}
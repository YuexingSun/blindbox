package com.zhixinhuixue.library.net.parser

import com.zhixinhuixue.library.net.NetConstant
import com.zhixinhuixue.library.net.entity.base.ApiPagerResponse
import com.zhixinhuixue.library.net.entity.base.ApiResponse
import rxhttp.wrapper.annotation.Parser
import rxhttp.wrapper.entity.ParameterizedTypeImpl
import rxhttp.wrapper.exception.ParseException
import rxhttp.wrapper.parse.AbstractParser
import rxhttp.wrapper.utils.convert
import timber.log.Timber
import java.io.IOException
import java.lang.reflect.Type

/**
 * 描述　: 输入T,输出T,并对code统一判断
 */
@Parser(name = "Response")
open class ResponseParser<T> : AbstractParser<T> {
    /**
     * 此构造方法适用于任意Class对象，但更多用于带泛型的Class对象，如：List<Student>
     *
     * 用法:
     * Java: .asParser(new ResponseParser<List<Student>>(){})
     * Kotlin: .asParser(object : ResponseParser<List<Student>>() {})
     *
     * 注：此构造方法一定要用protected关键字修饰，否则调用此构造方法将拿不到泛型类型
     */
    protected constructor() : super()

    /**
     * 此构造方法仅适用于不带泛型的Class对象，如: Student.class
     *
     * 用法
     * Java: .asParser(new ResponseParser<>(Student.class))   或者  .asResponse(Student.class)
     * Kotlin: .asParser(ResponseParser(Student::class.java)) 或者  .asResponse<Student>()
     */
    constructor(type: Type) : super(type)

    @Throws(IOException::class)
    override fun onParse(response: okhttp3.Response): T {
        val type: Type = ParameterizedTypeImpl[ApiResponse::class.java, mType] //获取泛型类型
        val data: ApiResponse<T> = response.convert(type)
        var t = data.data //获取data字段

        /*
         * 考虑到有些时候服务端会返回：{"errorCode":0,"errorMsg":"关注成功"}  类似没有data的数据
         * 此时code正确，但是data字段为空，直接返回data的话，会报空指针错误，
         * 所以，判断泛型为 String 或者 Any 类型时，重新赋值，并确保赋值不为null
         * 重新赋值为"请求成功"
        */
        if (t == null && mType == String::class.java || t == null && mType == Any::class.java) {
            t = "请求成功" as T
        }

//        val tData = t as? ApiPagerResponse<*>
//        if (tData != null) {
////            如果返回值值列表封装类，且是第一页并且空数据 那么给空异常 让界面显示空
//            if (tData.isRefresh() && tData.isEmpty()) {
//                Timber.d("code = 让界面为空")
//                throw ParseException(NetConstant.ERROR_CODE.toString(), data.message, response)
//            }
//        }
        // errCode 不等于 SUCCESS_CODE，抛出异常
        if (data.code != NetConstant.SUCCESS_CODE) {
            throw ParseException(data.code.toString(), data.message, response)
        }
        return t
    }
}
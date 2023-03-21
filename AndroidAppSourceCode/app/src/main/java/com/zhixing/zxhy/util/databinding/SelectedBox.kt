package com.zhixing.zxhy.util.databinding

import com.tuanliu.common.ext.transToString

object SelectedBox {

    /**
     * 盲盒失效时间 10位时间戳乘1000 = Data Long
     */
    @JvmStatic
    fun timeLongToStr(long: Long?): String {
        return if (long == null || long == 0L) "盲盒将在 后失效"
        else
            "盲盒将在${(long.times(1000)).transToString()}后失效"
    }

}
package com.zhixinhuixue.library.net.entity.base

import com.zhixinhuixue.library.net.entity.loadingtype.LoadingType

data class LoadingDialogEntity(
    @LoadingType var loadingType: Int = LoadingType.LOADING_NULL,
    var loadingMessage: String = "",
    var isShow: Boolean = false,
    var requestCode: String = "mmp"
)
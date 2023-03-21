package com.tuanliu.common.util

import com.bumptech.glide.annotation.GlideModule
import com.bumptech.glide.module.AppGlideModule

@GlideModule
class MyAppGlideModule: AppGlideModule() {
    override fun isManifestParsingEnabled(): Boolean {
        return false
    }
}
package com.tuanliu.common.ext

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.drawable.Drawable
import android.util.Log
import android.widget.ImageView
import androidx.annotation.DrawableRes
import com.bumptech.glide.Glide
import com.bumptech.glide.request.target.CustomTarget
import com.bumptech.glide.request.target.SimpleTarget
import com.bumptech.glide.request.transition.Transition
import com.tuanliu.common.R

/**
 * 带默认图片的Glide
 */
fun ImageView.glideDefault(
    context: Context,
    url: String?,
    //是否显示默认图片
    showPlaceHolder: Boolean = true,
    @DrawableRes id: Int = R.mipmap.ic_empty
) {
    if (showPlaceHolder) Glide.with(context).load(url.toString()).placeholder(id).into(this)
    else Glide.with(context).load(url.toString()).into(this)
}

/**
 * 带显示成功回调的glide
 */
fun ImageView.glideDefault(
    context: Context,
    url: String?,
    ready: () -> Unit
) {
    Glide.with(context).asBitmap().load(url.toString()).into(
        object : SimpleTarget<Bitmap>() {
            override fun onResourceReady(resource: Bitmap, transition: Transition<in Bitmap>?) {
                this@glideDefault.setImageBitmap(resource)
                ready()
            }
        })
}

/**
 * 带显示成功回调的glide
 */
fun ImageView.glideDefault(
    context: Context,
    url: String?,
    @DrawableRes id: Int = R.mipmap.ic_empty,
    ready: () -> Unit
) {
    Glide.with(context).asBitmap().load(url.toString()).placeholder(id).into(
        object : SimpleTarget<Bitmap>() {
            override fun onResourceReady(resource: Bitmap, transition: Transition<in Bitmap>?) {
                this@glideDefault.setImageBitmap(resource)
                ready()
            }
        })
}

/**
 * 带显示成功回调的glide
 */
fun Context.glideDefault(
    url: String?,
    ready: (bitmap: Bitmap) -> Unit
) {
    Glide.with(this).asBitmap().load(url.toString()).into(object : CustomTarget<Bitmap>() {
        override fun onResourceReady(resource: Bitmap, transition: Transition<in Bitmap>?) {
            ready(resource)
        }

        override fun onLoadCleared(placeholder: Drawable?) {
            val bitmap = BitmapFactory.decodeResource(this@glideDefault.resources, R.mipmap.ic_home_image_empty)
            ready(bitmap)
        }

        override fun onLoadFailed(errorDrawable: Drawable?) {
            val bitmap = BitmapFactory.decodeResource(this@glideDefault.resources, R.mipmap.ic_home_image_empty)
            ready(bitmap)
        }
    })
}

/**
 * 带显示成功回调的glide
 */
fun Context.glideDefault(
    url: String?,
    @DrawableRes id: Int = R.mipmap.ic_empty,
    ready: (bitmap: Bitmap) -> Unit
) {
    Glide.with(this).asBitmap().load(url.toString()).placeholder(id).into(object : CustomTarget<Bitmap>() {
        override fun onResourceReady(resource: Bitmap, transition: Transition<in Bitmap>?) {
            ready(resource)
        }

        override fun onLoadCleared(placeholder: Drawable?) {
            val bitmap = BitmapFactory.decodeResource(this@glideDefault.resources, R.mipmap.ic_home_image_empty)
            ready(bitmap)
        }
    })
}

/**
 * 带默认图片的Glide
 * Context扩展
 */
@JvmName("glideDefaultA1")
fun Context.glideDefault(url: String?, view: ImageView, @DrawableRes id: Int = R.mipmap.ic_empty) {
    Glide.with(this).load(url.toString()).placeholder(id).into(view)
}
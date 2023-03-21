package com.tuanliu.common.util

import android.content.Context
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.net.Uri
import android.util.Base64
import java.io.*

/**
 * Bitmap、path相关工具类
 */
object BitmapUtil {

    /**
     * 本地uri转换为Bitmap
     */
    fun getBitmapFromUri(context: Context, uri: Uri): Bitmap? {
        return try {
            BitmapFactory.decodeStream(context.contentResolver.openInputStream(uri))
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }

    /**
     * uri转换为File
     * [saveFilePath] 将要保存图片的路径
     */
    fun getUrlFromFile(path: String): File {
        return File(path)
    }

    /**
     * bitmap图片转换成String
     */
    fun convertIconToString(bitmap: Bitmap): String {
        val baos = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, baos)
        val appicon = baos.toByteArray()
        return Base64.encodeToString(appicon, Base64.DEFAULT)
    }

    /**
     * Bitmap转文件
     */
    fun bitmapToFile(bitmap: Bitmap, saveFilePath: String): File? {
        //将要保存图片的路径
        val file = File(saveFilePath)
        return try {
            val bos = BufferedOutputStream(FileOutputStream(file))
            bitmap.compress(Bitmap.CompressFormat.JPEG, 50, bos)
            bos.flush()
            bos.close()
            file
        } catch (e: IOException) {
            e.printStackTrace()
            null
        }
    }

    /**
     * byteArray转Bitmap
     */
    fun byteToBitmap(byte: ByteArray): Bitmap {
        return BitmapFactory.decodeByteArray(byte, 0, byte.size)
    }

    /**
     * 获取版本号
     * */
    fun packageCode(context: Context): String {
        val manager = context.packageManager
        var code = ""
        try {
            val info = manager.getPackageInfo(context.packageName, 0)
            code = info.versionName
        } catch (e: PackageManager.NameNotFoundException) {
            e.printStackTrace()
        }
        return code
    }

}
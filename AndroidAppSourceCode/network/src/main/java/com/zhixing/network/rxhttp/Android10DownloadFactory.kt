package com.zhixing.network.rxhttp

import android.content.ContentValues
import android.content.Context
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import okhttp3.Response
import rxhttp.wrapper.callback.UriFactory
import java.io.File

/**
 * Android10以上的下载帮助类
 */
class Android10DownloadFactory @JvmOverloads constructor(
    context: Context,
    private val fileName: String,
    private val queryUri: Uri? = null
) : UriFactory(context) {

    override fun insert(response: Response): Uri {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            ContentValues().run {
                //文件名
                put(MediaStore.MediaColumns.DISPLAY_NAME, fileName)
                //取contentType响应头作为文件类型
                put(MediaStore.MediaColumns.MIME_TYPE, response.body?.contentType().toString())
                //下载到Download目录
                put(MediaStore.MediaColumns.RELATIVE_PATH, Environment.DIRECTORY_DOWNLOADS)
                val uri = queryUri ?: MediaStore.Downloads.EXTERNAL_CONTENT_URI
                context.contentResolver.insert(uri, this)
            } ?: throw NullPointerException("Uri insert fail, Please change the file name")
        } else {
            val file = File("${Environment.getExternalStorageDirectory()}/${Environment.DIRECTORY_DOWNLOADS}/$fileName")
            Uri.fromFile(file)
        }
    }

}

package com.zhixing.zxhy.initializer

import android.content.Context
import android.text.TextUtils
import androidx.startup.Initializer
import com.tencent.bugly.crashreport.CrashReport
import com.tuanliu.common.base.appContext
import timber.log.Timber
import java.io.BufferedReader
import java.io.FileReader
import java.io.IOException


const val BUGLY_APP_ID = "eefb906176"

/**
 * Bugly sdk初始化
 */
class BuglyInitializer : Initializer<Boolean> {
    override fun create(context: Context): Boolean {
        Timber.v("Bugly sdk初始化")

        //当前包名
        val packageName = context.packageName
        //获取当前进程名
        val processName = getProcessName(android.os.Process.myPid())
        //设置是否为上报进程
        val strategy = CrashReport.UserStrategy(context)
        strategy.isUploadProcess = processName == null || processName == packageName

        CrashReport.initCrashReport(appContext, BUGLY_APP_ID, false, strategy)
        return true
    }

    override fun dependencies(): List<Class<out Initializer<*>>> {
        return emptyList()
    }

    /**
     * 获取进程号对应的进程名
     *
     * @param pid 进程号
     * @return 进程名
     */
    private fun getProcessName(pid: Int): String? {
        var reader: BufferedReader? = null
        try {
            reader = BufferedReader(FileReader("/proc/$pid/cmdline"))
            var processName: String = reader.readLine()
            if (!TextUtils.isEmpty(processName)) {
                processName = processName.trim { it <= ' ' }
            }
            return processName
        } catch (throwable: Throwable) {
            throwable.printStackTrace()
        } finally {
            try {
                reader?.close()
            } catch (exception: IOException) {
                exception.printStackTrace()
            }
        }
        return null
    }
}
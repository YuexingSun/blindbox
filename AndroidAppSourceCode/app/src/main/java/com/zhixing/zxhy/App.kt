package com.zhixing.zxhy

import com.tuanliu.common.base.BaseApplication

/**
 * Application
 * @author will
 */
class App : BaseApplication() {

    /**
     * Android中Application的onTerminate()函数只是用来在Android设备的模拟器中，如果application退出才会回调
     * 但在产品级（即运行在Android真机设备）应用App，不会再整个App退出时候回调这个onTerminate()函数
     */
    override fun onTerminate() {
        super.onTerminate()
    }

}
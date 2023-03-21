package com.tuanliu.common.listener

import android.app.Activity
import android.app.Application
import android.os.Bundle
import com.tuanliu.common.ext.addActivity
import com.tuanliu.common.ext.removeActivity
import timber.log.Timber

class KtxActivityLifecycleCallbacks : Application.ActivityLifecycleCallbacks {
    override fun onActivityPaused(p0: Activity) {

    }

    override fun onActivityStarted(p0: Activity) {

    }

    override fun onActivityDestroyed(activity: Activity) {
        removeActivity(activity)
    }

    override fun onActivitySaveInstanceState(p0: Activity, p1: Bundle) {
    }

    override fun onActivityStopped(p0: Activity) {
    }

    override fun onActivityCreated(activity: Activity, p1: Bundle?) {
        Timber.d(activity.javaClass.simpleName)
        addActivity(activity)
    }

    override fun onActivityResumed(p0: Activity) {
    }

}
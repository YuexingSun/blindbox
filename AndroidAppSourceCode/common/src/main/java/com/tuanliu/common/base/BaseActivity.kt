package com.tuanliu.common.base

import android.view.View
import androidx.appcompat.app.AppCompatActivity

abstract class BaseActivity : AppCompatActivity() {

    abstract val layoutId: Int

    var dataBindView: View? = null

}
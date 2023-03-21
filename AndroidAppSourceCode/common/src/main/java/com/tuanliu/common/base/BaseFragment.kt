package com.tuanliu.common.base

import android.view.View
import androidx.fragment.app.Fragment

abstract class BaseFragment : Fragment() {

    abstract val layoutId: Int

    var dataBindView: View? = null
}
package com.tuanliu.common.ext

import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.Fragment
import androidx.navigation.fragment.NavHostFragment

/**
 * 判断传入的Fragment是否位于Navigation栈顶
 */
fun <F: Fragment> AppCompatActivity.isFragmentTop(fragmentClass: Class<F>) : Boolean {

    val navHostFragment = this.supportFragmentManager.fragments.first() as NavHostFragment

    navHostFragment.childFragmentManager.fragments.forEach {
        if (fragmentClass.isAssignableFrom(it.javaClass)) {
            return true
        }
    }

    return false
}
package com.tuanliu.common.ext

import android.content.Context
import android.view.View
import android.view.inputmethod.InputMethodManager
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

/**
 * 加点延迟显示软键盘 以免不成功
 * @param view
 */
fun ViewModel.showKeyboard(view: View) {
    this.viewModelScope.launch {
        delay(50)
        if (view.requestFocus()) {
            val imm = view.context
                .getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
            imm.showSoftInput(view, InputMethodManager.SHOW_IMPLICIT)
        }
    }
}
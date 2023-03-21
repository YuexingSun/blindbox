package com.tuanliu.common.ext

import android.text.Editable
import android.text.InputType
import android.text.TextWatcher
import android.widget.EditText

/**
 * 优化输入框 只抽取afterTextChanged方法
 */
fun EditText.afterTextChange(afterTextChanged: (String) -> Unit) {

    this.addTextChangedListener(object : TextWatcher {
        override fun afterTextChanged(s: Editable?) {
            afterTextChanged.invoke(s.toString())
        }

        override fun beforeTextChanged(s: CharSequence?, start: Int, count: Int, after: Int) {
        }

        /**
         * 输入框内容发生变化的时候回调的方法
         */
        override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) {

        }
    })
}

fun EditText.showPwd(isChecked: Boolean) {
    inputType = if (isChecked) {
        InputType.TYPE_TEXT_VARIATION_VISIBLE_PASSWORD
    } else {
        InputType.TYPE_CLASS_TEXT or InputType.TYPE_TEXT_VARIATION_PASSWORD
    }
    setSelection(textString().length)
}
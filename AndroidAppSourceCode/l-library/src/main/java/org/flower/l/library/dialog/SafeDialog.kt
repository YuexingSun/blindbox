package org.flower.l.library.dialog

import android.content.Context
import android.view.View
import android.widget.EditText
import android.widget.TextView
import android.widget.Toast
import org.flower.l.library.R
import org.flower.l.library.aop.SingleClick
import org.flower.l.library.base.BaseDialog
import org.flower.l.library.view.CountdownView

/**
 * 短信校验对话框
 */
class SafeDialog {

    class Builder(context: Context) : CommonDialog.Builder<Builder>(context) {

        private val phoneView: TextView? by lazy { findViewById(R.id.tv_safe_phone) }
        private val codeView: EditText? by lazy { findViewById(R.id.et_safe_code) }
        private val countdownView: CountdownView? by lazy { findViewById(R.id.cv_safe_countdown) }

        private var listener: OnListener? = null

        /** 当前手机号 */
        private var phoneNumber: String? = null

        init {
            setTitle(R.string.safe_title)
            setCustomView(R.layout.dialog_safe)
            setOnClickListener(countdownView)
        }

        fun setPhone(phone: String): Builder = apply {

            if (phone.length != 11) {
                Toast.makeText(getContext(), "手机号码不正确", Toast.LENGTH_SHORT).show()
                return@apply
            }

            phoneNumber = phone
            // 为了保护用户的隐私，不明文显示中间四个数字
            phoneView?.text = String.format(
                "%s****%s", phone.substring(0, 3),
                phone.substring(phone.length - 4)
            )
        }

        fun setCode(code: String?): Builder = apply {
            codeView?.setText(code)
        }

        fun setListener(listener: OnListener?): Builder = apply {
            this.listener = listener
        }

        /**
         * 验证码已发送后，请调用这个方法
         */
        fun codeIsSend() {
            Toast.makeText(
                getContext(),
                R.string.common_code_send_hint,
                Toast.LENGTH_SHORT
            ).show()
            countdownView?.start()
            setCancelable(false)
        }

        @SingleClick
        override fun onClick(view: View) {
            when (view.id) {
                R.id.cv_safe_countdown -> {
                    listener?.onSendCode(phoneNumber!!)
                }
                R.id.tv_ui_confirm -> {

                    if (phoneNumber == null) return

                    if (codeView?.text.toString().length != getResources().getInteger(R.integer.sms_code_length)) {
                        Toast.makeText(
                            getContext(),
                            R.string.common_code_error_hint,
                            Toast.LENGTH_SHORT
                        ).show()
                        return
                    }

                    listener?.onConfirm(getDialog(), phoneNumber!!, codeView?.text.toString())
                }
                R.id.tv_ui_cancel -> {
                    autoDismiss()
                    listener?.onCancel(getDialog())
                }
            }
        }
    }

    interface OnListener {

        /**
         * 点击发送验证码时调用
         */
        fun onSendCode(phone: String)

        /**
         * 点击确定时回调
         */
        fun onConfirm(dialog: BaseDialog?, phone: String, code: String)

        /**
         * 点击取消时回调
         */
        fun onCancel(dialog: BaseDialog?) {}
    }
}
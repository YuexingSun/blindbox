package org.flower.l.library.dialog

import android.content.Context
import android.text.TextUtils
import android.widget.ImageView
import android.widget.TextView
import androidx.annotation.DrawableRes
import androidx.annotation.StringRes
import org.flower.l.library.R
import org.flower.l.library.base.BaseDialog
import org.flower.l.library.base.action.AnimAction

/**
 * 提示对话框
 * [ICON_FINISH] 勾
 * [ICON_ERROR] 叉
 * [ICON_WARNING] 感叹号
 * @setMessage 设置图片下方的文字
 */
class TipsDialog {

    sealed class TipsIcon(@DrawableRes val image: Int) {
        object ICON_FINISH: TipsIcon(R.drawable.ic_tips_finish)
        object ICON_ERROR: TipsIcon(R.drawable.ic_tips_error)
        object ICON_WARNING: TipsIcon(R.drawable.ic_tips_warning)
    }

    class Builder(context: Context) : BaseDialog.Builder<Builder>(context),
        Runnable, BaseDialog.OnShowListener {

        private val messageView: TextView? by lazy { findViewById(R.id.tv_tips_message) }
        private val iconView: ImageView? by lazy { findViewById(R.id.iv_tips_icon) }

        private var duration = 2000

        init {
            setContentView(R.layout.dialog_tips)
            setAnimStyle(AnimAction.ANIM_TOAST)
            setBackgroundDimEnabled(false)
            setCancelable(false)
            addOnShowListener(this)
        }

        fun setIcon(@DrawableRes id: Int): Builder = apply {
            iconView?.setImageResource(id)
        }

        fun setDuration(duration: Int): Builder = apply {
            this.duration = duration
        }

        fun setMessage(@StringRes id: Int): Builder = apply {
            setMessage(getString(id))
        }

        fun setMessage(text: CharSequence?): Builder = apply {
            messageView?.text = text
        }

        override fun create(): BaseDialog {
            // 如果显示的图标为空就抛出异常
            requireNotNull(iconView?.drawable) { "The display type must be specified" }
            // 如果内容为空就抛出异常
            require(!TextUtils.isEmpty(messageView?.text.toString())) { "Dialog message not null" }
            return super.create()
        }

        override fun onShow(dialog: BaseDialog?) {
            // 延迟自动关闭
            postDelayed(this, duration.toLong())
        }

        override fun run() {
            if (!isShowing()) {
                return
            }
            dismiss()
        }
    }
}
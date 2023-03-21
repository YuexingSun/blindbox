package org.flower.l.library.view

import android.content.Context
import android.util.AttributeSet
import android.view.LayoutInflater
import androidx.appcompat.widget.AppCompatImageView
import androidx.appcompat.widget.AppCompatTextView
import androidx.constraintlayout.widget.ConstraintLayout
import org.flower.l.library.R

class CustomTitleBar @JvmOverloads constructor(
    context: Context,
    attrs: AttributeSet? = null,
    defStyleAttr: Int = 0
) : ConstraintLayout(context, attrs, defStyleAttr) {

    var titleBarText: AppCompatTextView
    var titleBarBack: AppCompatImageView

    init {
        val view = LayoutInflater.from(context).inflate(R.layout.layout_title_bar, this)
        titleBarText = view.findViewById(R.id.TbText)
        titleBarBack = view.findViewById(R.id.TbBack)
    }

}
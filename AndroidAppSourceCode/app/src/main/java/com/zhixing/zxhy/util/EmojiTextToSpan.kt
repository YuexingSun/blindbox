package com.zhixing.zxhy.util

import android.content.Context
import android.text.Spannable
import android.text.SpannableString
import androidx.annotation.DrawableRes
import com.zhixing.zxhy.R

sealed class EmojiFace(
    val name: String,
    @DrawableRes val id: Int,
    //表情比正常高多少
    val addHeight: Int = 0,
    //表情比正常宽多少
    val addWidth: Int = 0
) {
    object Emoji001 : EmojiFace("[emoji-001]", R.mipmap.show_emoji_001)
    object Emoji002 : EmojiFace("[emoji-002]", R.mipmap.show_emoji_002)
    object Emoji003 : EmojiFace("[emoji-003]", R.mipmap.show_emoji_003)
    object Emoji004 : EmojiFace("[emoji-004]", R.mipmap.show_emoji_004)
    object Emoji005 : EmojiFace("[emoji-005]", R.mipmap.show_emoji_005)
    object Emoji006 : EmojiFace("[emoji-006]", R.mipmap.show_emoji_006)
    object Emoji007 : EmojiFace("[emoji-007]", R.mipmap.show_emoji_007)
    object Emoji008 : EmojiFace("[emoji-008]", R.mipmap.show_emoji_008, addWidth = 2)
    object Emoji009 : EmojiFace("[emoji-009]", R.mipmap.show_emoji_009)
    object Emoji010 : EmojiFace("[emoji-010]", R.mipmap.show_emoji_010)
    object Emoji011 : EmojiFace("[emoji-011]", R.mipmap.show_emoji_011)
    object Emoji012 : EmojiFace("[emoji-012]", R.mipmap.show_emoji_012)
    object Emoji013 : EmojiFace("[emoji-013]", R.mipmap.show_emoji_013)
    object Emoji014 : EmojiFace("[emoji-014]", R.mipmap.show_emoji_014, addWidth = 3)
    object Emoji015 : EmojiFace("[emoji-015]", R.mipmap.show_emoji_015, addWidth = 4)
    object Emoji016 : EmojiFace("[emoji-016]", R.mipmap.show_emoji_016, addWidth = 2)
    object Emoji017 : EmojiFace("[emoji-017]", R.mipmap.show_emoji_017)
    object Emoji018 : EmojiFace("[emoji-018]", R.mipmap.show_emoji_018)
    object Emoji019 : EmojiFace("[emoji-019]", R.mipmap.show_emoji_019)
    object Emoji020 : EmojiFace("[emoji-020]", R.mipmap.show_emoji_020)
}

/**
 * emoji表情文本转换成SpannableString
 * \[emoji-[0-9]*\]
 */
fun String.emojiTextToSpan(context: Context, textSize: Float): SpannableString {
    var imageSpan: CustomSpan
    val spanStr = SpannableString(this)
    Regex("\\[emoji-[0-9]{3}\\]").findAll(this, 0).forEach {
        imageSpan = CustomSpan(context, nameToDrawableRes(it.value), textSize)
        spanStr.setSpan(
            imageSpan,
            it.range.first,
            it.range.last + 1,
            Spannable.SPAN_INCLUSIVE_EXCLUSIVE
        )
    }
    return spanStr
}

/**
 * 获取drawable id
 */
private fun nameToDrawableRes(str: String): EmojiFace {
    return when (str) {
        "[emoji-001]" -> EmojiFace.Emoji001
        "[emoji-002]" -> EmojiFace.Emoji002
        "[emoji-003]" -> EmojiFace.Emoji003
        "[emoji-004]" -> EmojiFace.Emoji004
        "[emoji-005]" -> EmojiFace.Emoji005
        "[emoji-006]" -> EmojiFace.Emoji006
        "[emoji-007]" -> EmojiFace.Emoji007
        "[emoji-008]" -> EmojiFace.Emoji008
        "[emoji-009]" -> EmojiFace.Emoji009
        "[emoji-010]" -> EmojiFace.Emoji010
        "[emoji-011]" -> EmojiFace.Emoji011
        "[emoji-012]" -> EmojiFace.Emoji012
        "[emoji-013]" -> EmojiFace.Emoji013
        "[emoji-014]" -> EmojiFace.Emoji014
        "[emoji-015]" -> EmojiFace.Emoji015
        "[emoji-016]" -> EmojiFace.Emoji016
        "[emoji-017]" -> EmojiFace.Emoji017
        "[emoji-018]" -> EmojiFace.Emoji018
        "[emoji-019]" -> EmojiFace.Emoji019
        "[emoji-020]" -> EmojiFace.Emoji020
        else -> EmojiFace.Emoji001
    }
}

/**
 * emoji转换成span
 */
fun Context.toEmojiSpan(
    emojiFace: EmojiFace,
    textSize: Float
): SpannableString {
    val spanStr = SpannableString(emojiFace.name)
    val imageSpan = CustomSpan(
        this,
        emojiFace,
        textSize
    )
    spanStr.setSpan(
        imageSpan,
        0,
        emojiFace.name.length,
        Spannable.SPAN_INCLUSIVE_EXCLUSIVE
    )
    return spanStr
}

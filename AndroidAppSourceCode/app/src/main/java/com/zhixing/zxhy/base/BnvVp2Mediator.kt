package com.zhixing.zxhy.base

import android.view.MenuItem
import androidx.core.view.forEachIndexed
import androidx.viewpager2.widget.ViewPager2
import com.google.android.material.bottomnavigation.BottomNavigationView


/*
*BottomNavigation点击事件和Viewpager2滑动事件绑定，实现同步
* config:() -> Unit 函数体作为一个参数的形式传递给构造函数
* */
class BnvVp2Mediator(
    private val bnv: BottomNavigationView,
    private val vp2: ViewPager2,
    private val config: ((BottomNavigationView, ViewPager2) -> Unit)? = null
) {

    //容器map
    private val map = mutableMapOf<MenuItem, Int>()

    //初始化
    init {
        //拿到循环遍历，构建一个map映射<每个item，每个item的位置>
        bnv.menu.forEachIndexed { index, item ->
            map[item] = index
        }
    }

    //附加/关联
    fun attach(block:(menu: Int, goTop: Boolean) -> Unit, click: (menu: Int) -> Unit) {
        //执行Unit函数体内的动作
        config?.invoke(bnv, vp2)
        //如果ViewPager2要启用滑动的话，那么最好进行判断，是否点击的是同一个页面，如果是的话不执行OnPageSelected
//        vp2.registerOnPageChangeCallback(object :
//            ViewPager2.OnPageChangeCallback() {
//            override fun onPageSelected(position: Int) {
//                super.onPageSelected(position)
//                //切换界面的时候，将bnv对应的itemid赋给seleceteditemid然后改变bnv位置
//                bnv.selectedItemId = bnv.menu.getItem(position).itemId
//            }
//        })
        //开启预加载，默认为-1，不能 < 0
        vp2.offscreenPageLimit = 1

        var mGoTop: Long = 0
        var oldMenu: Int = -1

        //BottomNavigationView点击事件响应到ViewPager2上
        bnv.setOnNavigationItemSelectedListener { item ->
            val menu: Int = map[item] ?: error("Bnv的item的ID${item.itemId}没有对应的ViewPager2元素")
            vp2.setCurrentItem(menu, false)

            click.invoke(menu)

            //判断是否点击的是同一个Item
            if (oldMenu != menu) {
                oldMenu = menu
                mGoTop = System.currentTimeMillis()
                return@setOnNavigationItemSelectedListener true
            }

            when {
                    //快速点击某个Item两次
                (System.currentTimeMillis() - mGoTop) > 500 -> {
                    mGoTop = System.currentTimeMillis()
                }
                else -> {
                    /**
                     * BottomNavigation点击事件监听
                     * [menu]第几个菜单
                     */
                    block.invoke(menu, true)
                }
            }

            true
        }

    }

}
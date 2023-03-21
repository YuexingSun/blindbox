import Vue from 'vue'
import App from './App'
import moment from 'moment'
import store from './store'

Vue.config.productionTip = false
//自定义的请求函数
import api from "@/apis"
//自定义工具函数
import tool from "@/utils/tool.js"
App.mpType = 'app'

//注入自定义全局变量
Vue.prototype.$api=api
Vue.prototype.$tool=tool
Vue.prototype.$moment=moment
Vue.prototype.$store=store

const app = new Vue({
    ...App
})
app.$mount()

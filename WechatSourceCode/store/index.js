import Vue from 'vue'
import Vuex from 'vuex'
import getters from './getters.js'
import box from './modules/box.js'
import userInfo from './modules/userInfo.js'
Vue.use(Vuex)

const store = new Vuex.Store({
  modules: {
	box,
	userInfo
  },
  getters
})

export default store
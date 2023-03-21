const box = {
	state: {
		openBox: uni.getStorageSync('openBox') ? uni.getStorageSync('openBox') : [], //开盒的资料
		location: uni.getStorageSync('location') ? uni.getStorageSync('location') : [], //位置
		boxInfo: uni.getStorageSync('boxInfo') ? uni.getStorageSync('boxInfo') : [],//多盲盒详情
		oneBoxInfo:uni.getStorageSync('oneBoxInfo') ? uni.getStorageSync('oneBoxInfo') : [],//单一盲盒详情
	},
	mutations: {
		// setUserstate:(state,option)=>{
		// 	state[option.state]=option.data//存放到vuex中
		// 	uni.setStorageSync(option.state,option.data)//存放的缓存中
		// },
		serVuex: (state, option) => {
			state[option.state] = option.data //存放到vuex中
			uni.setStorageSync(option.state, option.data)
		},
		// serUserStateS:(state,option)=>{
		// 	state[option.state]=option.data//存放到vuex中
		// 	sessionStorage.setItem(option.state,option.data)//存放的回话缓存中
		// }
	},
	actions: {
		saveBox({
			commit
		}, data) {
			commit('serVuex', {
				state: "openBox",
				data: data
			})
		},
		savelocation({
			commit
		}, data) {
			commit('serVuex', {
				state: "location",
				data: data
			})
		},
		saveboxInfo({commit}, data) {
			commit('serVuex', {
				state: "boxInfo",
				data: data
			})
		},
		saveoneBoxInfo({commit}, data) {
			commit('serVuex', {
				state: "oneBoxInfo",
				data: data
			})
		},
	}
}

export default box

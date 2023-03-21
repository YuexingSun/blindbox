const box = {
	state: {
		userInfo: {},//用户详情
		UserProfile:{}
	},
	mutations: {
		setUserstate:(state,option)=>{
			state[option.state]=option.data//存放到vuex中
			uni.setStorageSync(option.state,option.data)//存放的缓存中
		},
		setVuex: (state, option) => {
			state[option.state] = option.data //存放到vuex中
			console.log( option.data)
		},
		
	},
	actions: {
		saveuserInfo({commit}, data) {
			commit('setVuex', {
				state: "userInfo",
				data: data
			})
		},
		saveUserProfile({commit},data){
			// console.log(111)
			commit('setVuex',{
				state:'UserProfile',
				data:data
			})
		}
	}
}

export default box

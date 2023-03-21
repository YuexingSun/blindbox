<script>
	export default {
		onLaunch: function() {
			// var token = uni.getStorageSync('token')
			// if(token){
			// 	this.getUserInfo()
			// }else{
			// 	uni.login({
			// 		success: (res) => {
			// 			this.userLogin(res.code)
			// 		}
			// 	})
			// }
			// uni.login({
			// 	success: (res) => {
			// 		this.userLogin(res.code)
			// 	}
			// })
			
		},
		onShow: function() {
			console.log('App Show')
		},
		onHide: function() {
			console.log('App Hide')
		},
		methods:{
			// #ifdef MP-WEIXIN
			//用户登录
			userLogin(code){
				var params={
					code
				}
				this.$api.user.userLogin(params).then(loginres=>{
					console.log(loginres)
					//判定用户是够是新用户
					if(loginres.isnew==0){
						uni.setStorageSync("token",loginres.token)
						uni.setStorageSync("userBaseInfo",loginres)
						// this.$tool.reLaunch('/pages/auther/question')
					}
				}).catch(err=>{
					console.log(err)
				})
			},
			getUserInfo(){
				this.$api.user.getUserInfo().then(userinfo=>{
					uni.setStorageSync('userInfo')
				}).catch(err=>{
					uni.login({
						success: (res) => {
							this.userLogin(res.code)
						}
					})
				})
			}
			
			// #endif
			
			
		}
	}
</script>

<style>
	/*每个页面公共css */
	@import '@/static/app.scss';
</style>

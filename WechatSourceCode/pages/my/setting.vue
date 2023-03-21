<template>
	<view class="setting_warp">
		<view class="baseInfo">
			<view class="item flex" style="justify-content: space-between;" @click="updataAvatar">
				<view class="left">
					<image :src="UserProfile.headimg" mode="widthFix" class="image flex"></image>
					<text class="galy" style="margin-left: 32rpx;">修改头像</text>
				</view>
				<view class="right">
					<uni-icons type="arrowright" color="#737373"></uni-icons>
				</view>
			</view>
			<view class="item flex" style="justify-content: space-between;" @click="jumpTo('name')">
				<view class="left">
					<text >昵称</text>
				</view>
				<view class="right">
					<text class="galy" style="margin-right: 16rpx;">{{UserProfile.nickname}}</text>
					<uni-icons type="arrowright" color="#737373"></uni-icons>
				</view>
			</view>
			<view class="item flex" style="justify-content: space-between;" >
				<view class="left">
					<text >手机</text>
				</view>
				<view class="right">
					<text class="galy" style="margin-right: 16rpx;">{{UserProfile.mob}}</text>
					<uni-icons type="arrowright" color="#737373"></uni-icons>
				</view>
			</view>
				<view class="item flex" style="justify-content: space-between;" v-for="(item,index) in settingItem" :key="index" @click="jumpTo(item.page)">
					<view class="left">
						<text >{{item.title}}</text>
					</view>
					<view class="right">
						<text class="pink" style="margin-right: 16rpx;">去设置</text>
						<uni-icons type="arrowright" color="#737373"></uni-icons>
					</view>
				</view>
				<view class="item flex" style="justify-content: space-between;">
					<view class="left">
						<text >兴趣爱好</text>
					</view>
					<view class="right">
						<uni-icons type="arrowright" color="#737373"></uni-icons>
					</view>
				</view>
		</view>
		<view class="baseInfo">
		<!-- 	<view class="item flex" style="justify-content: space-between;" @click="cancellation">
				<view class="left">
					<text>注销账号</text>
				</view>
				<view class="right">
					<uni-icons type="arrowright" color="#737373"></uni-icons>
				</view>
			</view> -->
			<view class="item flex" style="justify-content: space-between;">
				<view class="left">
					<text>关于我们</text>
				</view>
				<view class="right">
					<uni-icons type="arrowright" color="#737373"></uni-icons>
					
					
				</view>
			</view>
		</view>
	<!-- 	<view class="baseInfo" >
			<view class="item flex" @click="logout">
				<text class="pink" style="font-size: 36rpx;">退出登录</text>
			</view>
		</view> -->
	</view>
</template>

<script>
	import {mapGetters,mapActions} from 'vuex'
	export default {
		data() {
			return {
				settingItem:[
					{
						page:'age',
						title:'年龄'
					},{
						page:'sex',
						title:'性别'
					}
				]
			}
		},
		methods: {
			...mapActions(['saveUserProfile']),
			cancellation(){
				uni.showModal({
					title:'注销账号',
					content:`你的所有资料，包括盲盒行程记录
					将被删除，不可恢复`,
					cancelColor:'#999999',
					confirmColor:'#bc3332',
					confirmText:'注销账号',
					success: (res) => {
						if(res.confirm){
							//注销账号，退出登录
						}
						// console.log(res)
					}
				})
			},
			logout(){
				uni.showModal({
					title:'是否退出登录',
					cancelColor:'#999999',
					confirmColor:'#bc3332',
					success: (res) => {
						if(res.confirm){
							//，退出登录
							this.mylogout()
						}
						// console.log(res)
					}
				})
			},
			mylogout(){
				var params={
					token:uni.getStorageSync('token')
				}
				this.$api.user.logout(params).then(res=>{
					// console.log(res)
					uni.setStorageSync('userInfo',{})
					uni.setStorageSync('token','')
					this.$tool.switchTab('/pages/my/my')
				}).catch((err)=>{
					this.$tool.toast(err)
				})
			},
			jumpTo(path){
				this.$tool.navigateTo(`/pages/my/settingDetail?type=${path}`)
			},
			//获取用户资料
			getUserProfile(){
				this.$api.user.getUserProfile().then(res=>{
					// console.log(res)
					this.saveUserProfile(res)
				}).catch(err=>{
					this.$tool.toast(err)
				})
			},
			//更新头像
			updataAvatar(){
				var _this =this
				uni.chooseImage({
					success: (image) => {
						console.log(image)
						_this.$api.user.upload(image.tempFilePaths[0]).then(res=>{
							// console.log(res)
							this.setUserProfile(res)
						}).catch(err=>{
							console.log(err)
						})
						// console.log(image)
					}
				})
			},
			setUserProfile(image){
				var params={
					headimg:'https://api.sjtuanliu.com/V1/Uploads/images/2021/09/23/2021092316325216323859726934.png'
				}
				this.$api.user.setUserProfile(params).then(res=>{
					this.$tool.toast('更新成功')
					this.getUserProfile()
				}).catch(err=>{
					this.$tool.toast(err)
				})
			}
		},
		onShow(){
			this.getUserProfile()
		},
		computed:{
			...mapGetters(['UserProfile'])
		}
	}
</script>

<style lang="scss" scoped>
.baseInfo{
	background-color: #FFFFFF;
	margin-top: 16rpx;
	padding:  0 32rpx;
	box-sizing: border-box;
	.item{
		height: 120rpx;
		box-sizing: border-box;
		padding: 12rpx;
		border-bottom: 1rpx solid #EBEBEB;
		font-size: 32rpx;
		.galy{
			color: rgba(0,0,0,0.5);
		}
		.pink{
			color: #FF4A80;
		}
		.left{
			display: flex;
			align-items: center;
		}
		.image{
			width: 96rpx;
			height: 96rpx;
			border-radius: 50%;
			overflow: hidden;
		}
	}
	.item:last-child{
		border-bottom: none;
	}
}
</style>

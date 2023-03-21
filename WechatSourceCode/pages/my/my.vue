<template>
	<view>
		<view class="bgimage">
			<image src="../../static/img/mybg.png" mode="widthFix" style="width: 100vw;height: 100vh;"></image>
		</view>
		<navbar></navbar>
		<!-- 123123132 -->
		<view class="warp">
			<view class="flex" style="justify-content: space-between;position: relative;">
				<view class="userInfo">
					<view class="avator">
						<!-- <an-image :url="userInfo.memberinfo.avatar" alt="https://admin.sjtuanliu.com/api/Uploads/images/2021/08/25/2021082514313916298730993398.png" mode="widthFix" width='112'></an-image> -->
						<image :src="userInfo.memberinfo.avatar||avatar" mode="widthFix" style="width: 112rpx;height: 112rpx;"></image>
					</view>
					<button class="username" open-type="getPhoneNumber" @getphonenumber="getphonenumber"
						v-if="!userInfo.memberinfo.nickname">立即登录</button>
					<view class="username" v-else>{{userInfo.memberinfo.nickname}}</view>
				</view>
				<view class="setting_icon">
					<image src="../../static/icons/setting.png" mode="widthFix" style="width: 40rpx;height: 40rpx;" @click="jumpTo('setting')"></image>
				</view>
			</view>
			<view class="level" style="margin-bottom: 20rpx;">
				<view class="levelInfo">还有{{userInfo.memberinfo.nextlevelpoint  - userInfo.memberinfo.nowpoint ||0}}点升级</view>
				<f-progress :number="cent " :color1="'#FFA827'" :color2="'#F8D96C'"></f-progress>
				<view class="nowAnext">
					<view class="now">{{userInfo.memberinfo.nowlevel?userInfo.memberinfo.nowlevel:'v1'}}</view>
					<view class="next">{{userInfo.memberinfo.nextlevel?userInfo.memberinfo.nextlevel:'v2'}}</view>
					<view class="EX" v-if="cent" :style="'left' + cent +'%'">
						{{userInfo.memberinfo.nowpoint}}
					</view>
				</view>
			</view>
			<view class="hasBox warp card" v-if="userInfo.mybeingboxlist.boxid" @click="chack">
				<image src="../../static/icons/hasbox.png" mode="widthFix" style="width: 68rpx;"></image>
				<text class="text">您有一个进行中的盲盒行程</text>
				<view class="check">去看看</view>
			</view>
			<view class="card mybox">
				<view class="left" @click="jumpTo('boxList')">
					<image src="../../static/icons/myBox.png" mode="widthFix" style="width: 86rpx;"></image>
					<view class="info">
						<view class="number">{{userInfo.myboxnum||0}}</view>
						<view class="text">我的盲盒</view>
					</view>
				</view>
				<view class="left">
					<image src="../../static/icons/myprops.png" mode="widthFix" style="width: 86rpx;"></image>
					<view class="info">
						<view class="number">{{userInfo.mypropsnum||0 }}</view>
						<view class="text">我的道具</view>
					</view>
				</view>
			</view>
			<view class="myachievement">
				<view class="info">我的成就</view>
				<view class="achievement_warp">
					<view class="item" v-for="(item,index) in userInfo.myachievelist" :key="index">
						<image :src="item.islight==1?item.lightpic:item.pic" mode="widthFix" style="width: 124rpx;"></image>
						<view style="margin-top: 20rpx;">{{item.title}}</view>
					</view>
				</view>
			</view>
		</view>
	</view>
</template>

<script>
	import {
		mapGetters,mapActions
	} from 'vuex'
	export default {
		data() {
			return {
				hasBandPhone: false,
				openId:'',
				avatar:'https://admin.sjtuanliu.com/api/Uploads/images/2021/08/25/2021082514313916298730993398.png'
			}
		},
		onShow() {
			this.getUserInfo()
		},
		computed:{
			...mapGetters(['userInfo']),
			cent(){
				var _cent = 0 
				// console.log(this.userInfo)
				// console.log(_cent)
				if(this.userInfo.memberinfo&&this.userInfo.memberinfo.nowpoint!=0){
					_cent = this.userInfo.memberinfo.nowpoint / this.userInfo.memberinfo.nextlevelpoint
					_cent=parseInt(_cent) * 100
				}
				// console.log(_cent)
				return _cent
			},
			token(){
				return uni.getStorageSync('token')
			},
			nowpoint(){
				// console.log( this.userInfo)
				return 0
			}
		},
		methods: {
			...mapActions(["saveuserInfo"]),
			//获取用户手机号码
			getphonenumber(res) {
				// console.log(res)
				if (res.detail.errMsg !== 'getPhoneNumber:ok') {
					return this.$tool.toast('请授权手机号码，以便获得更好的服务')
				}
				var shareid = uni.getStorageSync('shareid') || ''
				var params = {
					encryptedData: res.detail.encryptedData,
					iv: res.detail.iv,
					shareid: uni.getStorageSync('Pshareid'),
					openid: this.openId
				}
				// console.log(params)
				this.$api.user.submitActiveByPhone(params).then(res => {
					// console.log(res)
					if (res.isnew == 0) { //老用户
						uni.setStorageSync('token', res.token)
					} else {
						this.$tool.navigateTo(`/pages/index/question?token=${res.token}`)
					}
					// this.submituserInfo()
				}).catch(err => {
					this.$tool.toast(err)
				})
				// this.getUserinfo()
			},
			//获取用户信息
			getUserInfo() {
				this.$api.user.getUserInfo().then(res=>{
					console.log(res.memberinfo.avatar)
					this.saveuserInfo(res)
				}).catch(err=>{
					// this.$tool.toast(err)
					uni.login({
						success: (res) => {
							// console.log(res)
							var params = {
								code: res.code
							}
							this.$api.user.userLogin(params).then(loginres => {
								// uni.setStorageSync('shareid',loginres.shareid)	
								this.openId = loginres.openid
								if (loginres.isnew == 0) { //非新用户
									uni.setStorageSync('token', loginres.token)
									this.getUserInfo()
									// uni.setStorageSync("userBaseInfo",loginres)
								} else if (loginres.token) { //新用户但是已经绑定手机号码
									this.hasBandPhone = true
									this.token = loginres.token
								}
							}).catch(err => {
								console.log(err)
							})
						}
					})
				})
			},
			chack(){
				this.$tool.switchTab('/pages/bindbox/bindbox')
			},
			jumpTo(url){
				var token = uni.getStorageSync('token')
				if(!token){
					this.$tool.toast('请先登录')
					return
				}
				this.$tool.navigateTo(`/pages/my/${url}`)
			}
		},

	}
</script>

<style scoped lang="scss">
	.bgimage {
		position: absolute;
		left: 0;
		top: 0;
		z-index: -1;
	}

	.userInfo {
		display: flex;

		.username {
			font-size: 40rpx;
			font-weight: 600;
			color: #ff416F;
			line-height: 47rpx;
			margin-left: 40rpx;
			background-color: rgba(255, 255, 255, 0);
			padding: 0;
		}
	}

	.level {
		margin-top: 42rpx;

		.levelInfo {
			font-size: 28rpx;
			color: #442c60;
			line-height: 1.2;
		}
	}

	.nowAnext {
		position: relative;
		display: flex;
		justify-content: space-between;
		width: 100%;
		font-size: 28rpx;
		font-weight: 600;
		color: #442C60;
		line-height: 1.5;

		.EX {
			position: absolute;
			background-color: #df9478;
			padding: 6rpx 20rpx;
			// color: rg
			color: #FFFFFF;
			text-align: center;
			border-radius: 10rpx;
			// left: 70%;
			top: 10rpx;
			font-size: 22rpx;
			transform: translateX(-50%);
		}

		.EX:after {
			color: rgba(255, 255, 255, 0);
			content: '';
			position: absolute;
			width: 0;
			height: 0;
			border: 16rpx solid;
			border-bottom-color: #df9478;

			// background-color: rgba($color: #000000, $alpha: 0);
			left: 50%;
			bottom: 100%;
			margin-left: -15rpx;
		}
	}

	.hasBox {
		margin-top: 42rpx;
		display: flex;
		justify-content: space-between;
		align-items: center;

		.text {
			font-size: 28rpx;
		}

		.check {
			background-color: #FFC7DF;
			border-radius: 46rpx;
			padding: 12rpx 28rpx;
			box-sizing: border-box;
			color: #442C60;
			font-size: 28rpx;
		}
	}

	.card {
		background-color: #FFFFFF;
		border-radius: 16rpx;
		padding: 20rpx;
		box-sizing: border-box;
		margin-bottom: 20rpx;
	}

	.mybox {
		display: grid;
		grid-template-columns: 1fr 1fr;
		grid-gap: 20rpx;

		.left {
			// flex:1;
			display: flex;

			image {
				margin-right: 20rpx;
			}

			.number {
				font-size: 36rpx;
				font-weight: 400;
				color: #ffc7df;
				line-height: 1.2;
			}

			.text {
				font-size: 28rpx;
				color: #666666;
			}
		}

		.left:first-child {
			border-right: 1rpx solid #e3e3e3;
		}
	}

	.myachievement {
		background-color: #ffffff;
		border-radius: 16rpx;

		.info {
			padding: 30rpx;
			border-bottom: 1rpx solid #e3e3e3;
			font-size: 32rpx;
		}

		.achievement_warp {
			padding: 48rpx 32rpx;
			box-sizing: border-box;
			display: grid;
			grid-template-columns: repeat(4, 1fr);
			grid-gap: 22rpx;

			// display: flex;
			.item {
				display: flex;
				justify-content: center;
				align-items: center;
				flex-direction: column;
				color: #442c60;
				line-height: 1.5;
				font-size: 28rpx;

				text {
					margin-top: 20rpx;
				}
			}
		}
	}
	.setting_icon{
		position: absolute;
		top: 0;
		right: 0;
	}
</style>

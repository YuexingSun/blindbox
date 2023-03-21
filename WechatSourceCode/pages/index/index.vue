<template>
	<view class="content">
<!-- 		<button type="default" open-type="getPhoneNumber" @getphonenumber="getPhoneNumber">授权手机号码</button>
		<button type="default" open-type="getUserInfo" @getuserinfo="getUserInfo">授权用户信息</button> -->
		<!-- <open-data type="userNickName"></open-data> -->
	</view>
</template>

<script>
	export default {
		data() {
			return {
				title: 'Hello',
			}
		},
		onLoad() {
		},
		methods: {
			getPhoneNumber(res){
				console.log(res)
			},
			getUserInfo(res){
				console.log(res)
			}
		},
		onShareAppMessage(res){
			var {shareid} = uni.getStorageSync('userBaseInfo')
			return{
				title:`给你分享一个好玩的小程序`,
				path:`/pages/index/index?shareid=${shareid}`
			}
		}
	}
</script>

<style>
	.content {
		display: flex;
		flex-direction: column;
		align-items: center;
		justify-content: center;
	}

	.logo {
		height: 200rpx;
		width: 200rpx;
		margin-top: 200rpx;
		margin-left: auto;
		margin-right: auto;
		margin-bottom: 50rpx;
	}

	.text-area {
		display: flex;
		justify-content: center;
	}

	.title {
		font-size: 36rpx;
		color: #8f8f94;
	}
</style>

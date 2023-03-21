<template>
	<view class="popup">
		<view class="first card shape flex" style="width: 60%;">
			<text style="font-size: 28rpx;font-weight: 500;color: rgba(68,44,94,0.8);">到达目的</text>
			<view class="left  flex">
				<view class="icon">
					<image src="../../static/icons/xingxing.png" mode="widthFix"></image>
				</view>
				<text>幸运值+{{oneBoxInfo.beinpoint}}</text>
			</view>
		</view>
		<view class="second other" style="margin-bottom: 10rpx;">
			<view class="top flex " style="padding: 20rpx;box-sizing: border-box;background-color: #FFFFFF;position: relative;" @click="checkMap">
				<image :src="oneBoxInfo.logo" mode="widthFix" style="width: 148rpx;margin-right: 30rpx;"></image>
				<view class="right">
					<view class="name text-cut" style="width: 80%;">{{oneBoxInfo.realname}}</view>
					<uni-rate :value="oneBoxInfo.point" :readonly="true" activeColor="#ff599f" size="12"></uni-rate>
					<view class="address">{{oneBoxInfo.readAddress}}
					<uni-icons type="paperplane" class="addressicon"></uni-icons></view>
				</view>
			</view>
			<view class="bottom" :style="'background-color:' + oneBoxInfo.colorlist.bgcolor + ';font-size:30rpx;text-aline:center'" >
				<rich-text :nodes="vhtml"></rich-text>
			</view>
		</view>
		<view class="three card">
			<view class="avators flex" style="justify-content: flex-start;">
				<view class="item" v-for="(item,index) in oneBoxInfo.gotlist" :key="index">
					<image :src="item" mode="widthFix" style="width: 64rpx;height: 64rpx;border-radius: 50%;overflow: hidden;"> </image>
				</view>
				<text class="hadbeen">共{{oneBoxInfo.gotnum}}人去过</text>
			</view>
		</view>
		<button type="default" @click="endBox" v-if="oneBoxInfo.status==1" class="button">确定到达</button>
		<view class="four card" v-if="oneBoxInfo.status==2&&Satisfied==0">
			<image src="../../static/img/luck.png" mode="widthFix" style="width: 280rpx;"></image>
			<view class="title">您对这次盲盒的内容满意吗？</view>
			<view class="satisfied">
				<view class="item" @click="Satisfied=1">
					<image :src="`../../static/icons/${Satisfied===1?'ASatisfied':'Satisfied'}.png`" mode="widthFix">
					</image>
					<text>满意</text>
				</view>
				<view class="item" @click="Satisfied=2">
					<image :src="`../../static/icons/${Satisfied===2?'AunSatisfied':'unSatisfied'}.png`"
						mode="widthFix"></image>
					<text>不满意</text>
				</view>
			</view>
		</view>
	</view>
</template>

<script>
	import {
		mapGetters
	} from 'vuex'
	export default {
		name: "boxDetail",
		data() {
			return {
				Satisfied: 0
			};
		},
		computed: {
			...mapGetters(['oneBoxInfo']),
			vhtml: function() {
				var str1 =
					`<span style="color:${this.oneBoxInfo.colorlist.textcolor};font-size:15px;font-weight:600;margin:0 6px">${this.oneBoxInfo.arrivedvarlist[0]}</span>`
				var str2 =
					`<span style="color:${this.oneBoxInfo.colorlist.textcolor};font-size:15px;font-weight:600;margin:0 6px">${this.oneBoxInfo.arrivedvarlist[1]}</span>`
				var str3 =
					`<span style="color:${this.oneBoxInfo.colorlist.textcolor};font-size:15px;font-weight:600;margin:0 6px">${this.oneBoxInfo.arrivedvarlist[2]}</span>`
				var str4 =
					`<span style="color:${this.oneBoxInfo.colorlist.textcolor};font-size:15px;font-weight:600;margin:0 6px">${this.oneBoxInfo.arrivedvarlist[3]}</span>`
				var STR = this.oneBoxInfo.arrivedtext
				STR = STR.replace('{{SJTL1}}', str1)
				STR = STR.replace('{{SJTL2}}', str2)
				STR = STR.replace('{{SJTL3}}', str3)
				STR = STR.replace('{{SJTL4}}', str4)
				// console.log(STR)
				return STR
			}
		},
		methods: {
			addreason(item) {
				var index = this.myreason.indexOf(item)
				if (index != -1) {
					this.myreason.splice(index, 1)
				} else {
					this.myreason.push(item)
				}
			},
			finishBox(Satisfied) {
				var params = {
					boxid: this.oneBoxInfo.boxid,
					islike: Satisfied
				}
				this.$api.box.finishBox(params).then(res => {
					this.Satisfied = Satisfied
					this.oneBoxInfo.status = 2
					// this.$tool.toast()
				}).catch(err => {
					this.$tool.toast(err)
				})
			},
			endBox(){
				var params = {
					boxid: this.oneBoxInfo.boxid,
				}
				this.$api.box.arrivedBox(params).then(res=>{
					// this.saveBox(oneBoxInfo)
					// this.saveoneBoxInfo(oneBoxInfo)
					// this.$refs.locationpopup.open()
					this.$emit('arrivedBox')
				}).catch(err=>{
					this.$tool.toast(err)
				})
			},
			checkMap(){
				console.log(this.oneBoxInfo)
				uni.openLocation({
					address: this.oneBoxInfo.readAddress,
					name: this.oneBoxInfo.realname,
					latitude: this.oneBoxInfo.lnglat.lat,
					longitude: this.oneBoxInfo.lnglat.lng
				})
			}
		}
	}
</script>

<style scoped lang="scss">
	.popup {
		// height: 90vh;
		width: 100vw;
		padding: 48rpx;
		box-sizing: border-box;
	}

	.card {
		background-color: #FFFFFF;
		padding: 18rpx 22rpx;
		border-radius: 26rpx;
		box-sizing: border-box;
		margin-bottom: 10rpx;
	}

	.shape {
		border-top-right-radius: 0;
		border-bottom-left-radius: 0;
	}

	.icon {
		width: 28rpx;
		height: 28rpx;
		display: flex;
		justify-content: center;
		align-items: center;
		background-color: #ff86aa;
		border-radius: 50%;
		margin-right: 10rpx;

		image {
			width: 80%;
			height: 80%;
		}
	}

	.left {
		background-color: #FFB2E9;
		color: #df5e9e;
		font-size: 28rpx;
		line-height: 1.5;
		border-radius: 46rpx;
		margin-left: 20rpx;
		padding: 2rpx 20rpx;
	}

	.flex {
		display: flex;
		// justify-content: center;
		align-items: center;
	}

	.right {
		.name {
			font-size: 36rpx;
			// line-height: 2;
			padding-bottom: 20rpx;
		}

		.address {
			font-size: 28rpx; 
			line-height: 1.5;
			color: #6e6f72;
		}
	}

	.other {
		border-radius: 20rpx;
		overflow: hidden;
	}

	.bottom {
		padding: 20rpx 40rpx;
		box-sizing: border-box;
		line-height: 1.5;
	}

	.avators {

		// flex-direction: row-reverse;
		// justify-content: flex-start;
		.item {
			border: 2rpx solid #FF75C8;
			border-radius: 50%;
			margin-left: -20rpx;
			background-color: #FFFFFF;
			display: flex;
			justify-content: center;
			align-items: center;
			image{
				width: 100%;
				border-radius: 50%;
				overflow: hidden;
			}
			// border-image: linear-gradient(273deg, rgba(255, 117.93749392032623, 200.1750522851944, 1), rgba(112.20001459121704, 0, 255, 1)) 2 2
		}

		.item:first-child {
			margin: 0;
		}
	}

	.hadbeen {
		font-size: 24rpx;
		color: #442c60;
		line-height: 28rpx;
		margin-left: 30rpx;
	}

	.four {
		.title {
			font-size: 32rpx;
			line-height: 2;
		}

		.satisfied {
			display: flex;
			justify-content: space-around;
			align-items: center;

			.item {
				display: flex;
				flex-direction: column;
				align-items: center;
				justify-content: center;
				margin: 40rpx;

				image {
					width: 80rpx;
					height: 80rpx;
				}

				text {
					margin-top: 20rpx;
					font-size: 24rpx;
					line-height: 28rpx;
				}
			}
		}

		.unSatisfied {
			margin: 20rpx 0;
			display: grid;
			grid-template-columns: repeat(2, 1fr);
			grid-gap: 24rpx;

			.item {
				border: 1rpx solid #999999;
				color: #999999;
				font-size: 28rpx;
				text-align: center;
				padding: 16rpx 40rpx;
				border-radius: 16rpx;
			}

			.activeItem {
				color: #ff6b98;
				background-color: #fddae5;
				border-color: #fea0bd;
			}
		}
	}

	.button {
		color: #FFFFFF;
		font-size: 32rpx;
		font-weight: 600;
		line-height: 2;
		border-radius: 46rpx;
		margin-top: 50rpx;
		width: 80%;
		background: linear-gradient(90deg, #FF599E 0%, #FF4545 100%);
	}
	.addressicon{
		position: absolute;
		top: 20rpx;
		right: 40rpx;
	}
</style>

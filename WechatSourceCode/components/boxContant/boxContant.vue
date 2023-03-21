<template>
	<view class="choose_warp" v-if="contantType!='going'">
		<!-- 123123 -->
		<scroll-view scroll-x="true">
			<view class="choose" style="padding-left: 40rpx;">
				<view class="choose_pic" v-for="(item,index) in choosePic" :key="index" @click="chooseIndex=index">
					<image :src="item" mode="widthFix" style="width: 284rpx;"></image>
					<image :src="`../../static/icons/${index==chooseIndex?'choose':'unchoose'}.png`" mode="widthFix"
						style="width: 48rpx;height: 48rpx;" class="choose_icon"></image>
				</view>
			</view>
		</scroll-view> 
		
		<view class="choose_contant">
			<view class="choose_title">{{boxInfo[chooseIndex].title}}</view>
			<view class="choose_item_warp">
				<view class="item" v-for="(item,index) in boxInfo[chooseIndex].items" :key="index">
					<view class="left">
						<view class="icon">
							<image :src="icons[index]" style="width: 30rpx;height: 30rpx;"></image>
						</view>
						<text>{{item.item}}</text>
					</view>
					<view class="right">
						<text v-if="item.type==1||item.type==2">{{item.value}}</text>
						<uni-rate v-model="item.value" :readonly="true" :size="16" v-if="item.type==3||item.type==4" activeColor="#ff1577" />
					</view>
				</view>
			</view>
			
		</view>
		<!-- <swiper :indicator-dots="true"  style="height: 70vh;">
			<swiper-item v-for="(boxitem,boxindex) in boxInfo" :key="boxindex">
				<view class="swiper-item flex column">
					<image :src="choosePic[boxindex]" mode="widthFix" style="width: 284rpx;"></image>
					<view class="choose_contant" style="margin-top: 0;">
						<view class="choose_title">{{boxitem.title}}</view>
						<view class="item" v-for="(item,index) in boxitem.items" :key="index">
							<view class="left">
								<view class="icon">
									<image :src="icons[index]" style="width: 30rpx;height: 30rpx;"></image>
								</view>
								<text>{{item.item}}</text>
							</view>
							<view class="right">
								<text v-if="item.type==1||item.type==2">{{item.value}}</text>
								<uni-rate v-model="item.value" :readonly="true" :size="16" v-if="item.type==3||item.type==4" />
							</view>
						</view>
					</view>
				</view>
			</swiper-item>
		</swiper> -->
		<view class="choose_button_warp" style="flex-direction: column;">
			<button class="button go" @click="jumpTo()">马上启程</button>
			<button @click="back()" class="button back">终止行程</button>
		</view>
		<view class="info">盲盒将在 <text>{{time}}</text> 后失效</view>
	</view>
	<view class="boxContant" v-else>
		<image :src="oneBoxInfo.logo" class="pic" @longpress="longpress"></image>
		<view class="title">{{oneBoxInfo.title}}</view>
		<view v-if="contantType=='going'">
			<view class="goinginfo">
				<view>行程已经进行<text class="time">{{openTime}}</text>分钟</view>
				<view>离目的地大约还有<text>{{distance}}</text>米</view>
			</view>
			<view class="button_warp" style="flex-direction: column;">
				<button class="button go" style="width: 100%;" @click="jumpTo()" >{{distance<100?'揭晓答案':'马上启程'}}</button>
				<text @click="back()"
					style="text-align: center;color: #f1709b;font-size: 28rpx;text-decoration:underline;margin-top: 40rpx;">终止行程</text>
			</view>
		</view>
		<view class="info">盲盒将在 {{time}} 后失效</view>
		<uni-popup ref="locationpopup" type="center" >
			<boxDetail @arrivedBox="arrivedBox"></boxDetail>
			<view style="width: 100%;display: flex;justify-content: center;" @click="close()">
				<image src="../../static/icons/cancole.png" mode="widthFix" style="width: 80rpx;" class=""></image>
			</view>
		</uni-popup>
	</view>
</template>

<script>
	import {
		mapGetters,
		mapActions
	} from 'vuex'
	export default {
		name: "boxContant",
		data() {
			return {
				mood: '',
				icons: ['../../static/icons/distance.png', '../../static/icons/consumption.png',
					'../../static/icons/freshness.png', '../../static/icons/mystery.png'
				],
				choosePic: ['../../static/img/1.png', '../../static/img/2.png', '../../static/img/3.png'],
				chooseIndex: 0,
				hasopen:false
			};
		},
		computed: {
			...mapGetters(["boxInfo", 'openBox', 'location', 'oneBoxInfo']),
			time() {
				if(this.boxInfo.length!=0){
					return this.$moment(this.boxInfo[this.chooseIndex].expiretime * 1000).format('YYYY-MM-DD HH:mm:ss')
				}
				
			},
			openTime() {
				var nowTime = new Date()
				var countDownTime = this.$tool.currentday(this.oneBoxInfo.starttime * 1000, nowTime)
				return countDownTime
			},
			contantType() {
				if (this.boxInfo.length == 3) { //待开始状态
					return 'working'
				} else {
					return 'going'
				}
			},
			distance() {
				if (this.contantType == 'going') {
					var _distance = this.$tool.GetDistance(this.location[0], this.location[1], this.oneBoxInfo.lnglat.lat,
						this.oneBoxInfo.lnglat.lng)
					return _distance
				}
			}
		},
		props: {
			isTabbar: {
				type: Boolean,
				default: false
			}

		},

		methods: {
			...mapActions(['saveoneBoxInfo']),
			back() {
				// this.$emit('back')
				var Item = {
					boxid: this.boxInfo[0].boxid,
					indexid: this.chooseIndex,
					type: this.contantType
				}
				if (this.contantType == 'working') {
					this.$emit('back', Item)
					return
				} else if (this.contantType == 'going') {
					this.$emit('back', Item)
				}
			},
			jumpTo() {
				if (this.contantType == 'working') {
					var item = {
						boxInfo: this.boxInfo[this.chooseIndex],
						chooseIndex: this.chooseIndex
					}
					this.$emit('jumpTo', item)
				} else if (this.distance < 100) {
					if(this.hasopen){
						this.longpress()
					}else{
						this.$emit('play')
						this.hasopen=true
					}		
				} else {
					uni.openLocation({
						address: this.oneBoxInfo.address,
						name: this.oneBoxInfo.buildName,
						latitude: this.oneBoxInfo.lnglat.lat,
						longitude: this.oneBoxInfo.lnglat.lng
					})
				}
			},
			saveBoxInfo() {
				this.saveoneBoxInfo(this.boxInfo[this.chooseIndex])
			},
			close() {
				this.$refs.locationpopup.close()
			},
			arrivedBox() {
				this.close()
				this.$emit('arrivedBox')
			},
			longpress(){
				this.$refs.locationpopup.open()
			},
		},
	}
</script>

<style scoped lang="scss">
	.pic {
		border-radius: 50%;
		overflow: hidden;
		width: 158rpx;
		height: 158rpx;
		border: 30rpx solid #FFFFFF;
		// margin-top: -94rpx;
		position: absolute;
		top: 0%;
		left: 50%;
		z-index: 2;
		transform: translate(-50%, -50%);
	}

	.choose_warp {
		.info {
			width: 100%;
			text-align: center;

			text {
				color: #dd3c66;
			}
		}

		.choose {
			display: grid;
			grid-template-columns: repeat(3, 284rpx);
			grid-gap: 0 24rpx;

			.choose_pic {
				position: relative;

				.choose_icon {
					position: absolute;
					bottom: 16rpx;
					right: 16rpx;
					transform: translate(0, -25%);
				}
			}
		}

		.choose_contant {
			background-color: #FFFFFF;
			// margin-top: 60rpx;
			margin: 56rpx 30rpx 20rpx 30rpx;
			width: auto;
			border-radius: 16rpx;
			overflow: hidden;
			.choose_item_warp{
				padding: 30rpx 110rpx 40rpx 110rpx;
				box-sizing: border-box;
			}
			.item {
				display: flex;
				justify-content: space-between;
				align-items: center;
				// margin-bottom: 38rpx;
				border-bottom: 1rpx solid #DADADA;
				line-height: 2;

				text {
					font-size: 28rpx;
				}

				.left {
					// flex: 1;
					display: flex;
					align-items: center;
					color: #8484b2;

					.icon {
						margin-right: 22rpx;
					}
				}

				.right {
					// flex: 1;
					color: #442c60;
				}
			}

			.item:last-child {
				border: none;
			}

			.choose_title {
				text-align: center;
				color: #6700B8;
				font-size: 36rpx;
				// margin-bottom: 46rpx;
				font-weight: 600;
				width: 100%;
				padding: 34rpx 0;
				background-color: #cdd2ff;
				
			}
		}
	}

	.boxContant {

		position: relative;
		background-color: #FFFFFF;
		margin: 40rpx;
		margin-top: 94rpx;
		width: auto;
		// height: 200rpx;
		border-radius: 26rpx;
		padding: 40rpx;
		padding-top: 94rpx;
		padding-bottom: 40rpx;
		display: flex;
		flex-direction: column;
		align-items: center;
		justify-content: center;
		box-sizing: border-box;
	}

	.title {
		// margin-top: 20rpx;
		color: #442C60;
		font-size: 48rpx;
		font-size: 500;
		line-height: 1.5;
		text-align: center;

	}

	.detail {
		border-radius: 0 60rpx 60rpx 60rpx;
		// background-color: red;
		padding: 26rpx 44rpx;
		font-size: 26rpx;
		text-align: center;
	}

	.item_warp {
		margin-top: 60rpx;
		width: 100%;
		padding: 0 76rpx;
		box-sizing: border-box;

		.item {
			display: flex;
			// justify-content: ;
			align-items: center;
			margin-bottom: 38rpx;

			text {
				font-size: 28rpx;
			}

			.left {
				flex: 1;
				display: flex;
				align-items: center;
				color: #8484b2;

				.icon {
					margin-right: 22rpx;
				}
			}

			.right {
				flex: 1;
				color: #442c60;
			}
		}
	}

	.button_warp {
		display: flex;
		width: 100%;

		.button {
			flex: 1;
			font-size: 32rpx;
			border-radius: 40rpx;
			border: 2rpx solid red;
			margin-top: 40rpx;
		}

		.button:first-child {
			margin-right: 40rpx;
		}

		.back {
			border-color: #f27c82;
			color: #F86D97;
			background-color: #FFFFFF;
		}

		.go {
			border-color: #ec5556;
			background: linear-gradient(90.68deg, #F86E97 0.59%, #EC5454 100%);
			color: #FFFFFF;
		}
	}

	.happy {
		color: #c06b22;
		background-color: #ffe39b;
	}

	.excited {
		color: #9f3c3c;
		background-color: #ffbcbc;
	}

	.relax {
		color: #75a23c;
		background-color: #d5f3af;
	}

	.turmoil {
		color: #3d4f8a;
		background-color: #d3e3fb;
	}

	.lost {
		color: #8456a8;
		background-color: #e8d9f7;
	}

	.agitated {
		color: #9285af;
		background-color: #c6d1ff;
	}

	.info {
		color: #442c60;
		font-size: 28rpx;
		margin-top: 40rpx;
	}

	.goinginfo {
		font-size: 32rpx;
		font-weight: 600;
		color: #442c60;
		line-height: 1.5;
		text-align: center;

		text {
			// transform: scale(2,2);
			font-size: 48rpx;
			color: #F86C97;
			margin: 0 20rpx;
		}
	}

	.choose_button_warp {
		padding: 0 120rpx;
		box-sizing: border-box;
		display: flex;
		justify-content: center;
		align-items: center;
		flex-direction: column;

		.button {
			flex: 1;
			font-size: 32rpx;
			border-radius: 40rpx;
			border: 2rpx solid red;
			margin-top: 40rpx;
			width: 100%;
		}

		.button:first-child {
			margin-right: 40rpx;
		}

		.back {
			border-color: #f27c82;
			color: #F86D97;
			background-color: #FFFFFF;
		}

		.go {
			border-color: #ec5556;
			background: linear-gradient(90.68deg, #F86E97 0.59%, #EC5454 100%);
			color: #FFFFFF;
		}
	}
</style>

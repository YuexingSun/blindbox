<template>
	<view class="warp" style="background-color: #FFFFFF;">
		<view class="image">
			<image src="../../static/img/boxInfo.png" mode="widthFix" style="width: 100%"></image>
			<view class="info">
				<view class="top">
					<text>{{openBox[2].ans.itemname}}</text>
				</view>
				<view class="bottom">
					<text>{{openBox[0].ans.itemname}}</text>
					<text>{{openBox[1].ans.itemname}}</text>
				</view>
			</view>
		</view>
		<view class="textinfo">
			将耗费 1 个盲盒
		</view>
		<view class="button_warp">
			<view class="button back" @click="cancle()">我再想想</view>
			<view class="button go" @click="confirmOpenBox">马上开盒</view>
		</view>
	</view>
</template>

<script>
	import {
		mapGetters,mapActions
	} from 'vuex'
	export default {
		computed: {
			...mapGetters(["openBox",'location'])
		},
		data() {
			return {
				typeid:''
			}
		},
		onLoad(option) {
			// console.log/(this.openBox)
			this.typeid=option.typeid
		},
		methods: {
			...mapActions(['saveboxInfo']),
			//确认开盒
			confirmOpenBox(){
				var _answer=[]
				_answer=this.openBox.map((item)=>{
					return{
						quesid:item.quesid,
						ans:item.ans.itemid
					}
				})
				var params={
					typeid:this.typeid,
					lng:this.location[1],
					lat:this.location[0],
					jsonstr:_answer
				}
				this.$api.box.useBox(params).then(res=>{
					this.saveboxInfo(res)
					this.$tool.redirectTo('/pages/bindbox/boxContant')
				}).catch(err=>{
					this.$tool.toast(err)
				})
				// console.log(params)
			},
			cancle(){
				this.$tool.navigateBack()
			}
		}
	}
</script>

<style scoped lang="scss">
	.warp {
		padding: 60rpx;
	}

	.image {
		position: relative;
	}

	.info {
		position: absolute;
		top: 68rpx;
		// left: 50%;
		// transform: translateX(-50%);
		width: 100%;
		display: flex;
		flex-direction: column;
		align-items: center;
		justify-content: center;

		.top {
			text-align: center;
			width: 80%;
			border-bottom: 1px solid #FFB4AC;
			padding-bottom: 20rpx;

			text {
				color: #442C60;
				font-weight: 600;
				font-size: 40rpx;
			}
		}

		.bottom {
			display: flex;
			flex-direction: column;
			align-items: center;
			justify-content: center;

			text {
				font-size: 28rpx;
				line-height: 33rpx;
				color: #FFFFFF;
				background-color: #FF6493;
				margin-top: 14rpx;
				padding: 8rpx 24rpx;
				border-radius: 46rpx;
			}
		}
	}

	.textinfo {
		color: #442C60;
		font-weight: 600;
		font-size: 28rpx;
		text-align: center;
		padding: 20rpx 0;
	}

	.button_warp {
		display: flex;
		align-items: center;
		justify-content: space-between;
		.button{
			width: 100%;
			text-align: center;
			font-size: 32rpx;
			line-height:2;
			border-radius: 46rpx;
		}
		.back {
			
			margin-right:34rpx;
			border: 4rpx solid red;
			// border-image: linear-gradient(270deg, rgba(248.0000004172325, 109.00000110268593, 148.000006377697, 1), rgba(237.0000010728836, 86.00000247359276, 88.00000235438347, 1)) 4 4;
			color: #F86D97;
			box-sizing: border-box;
		}
		.go{
			// border: 4rpx solid #FFFFFF;
			background: linear-gradient(90deg, #FF599E 0%, #EB5353 100%);
			color: #FFFFFF;
		}
	}
	
</style>

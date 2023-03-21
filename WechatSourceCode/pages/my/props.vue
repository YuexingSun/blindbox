<template>
	<view class="prop_warp">
		<view class="navbar">
				<navbarList :items="items" @onChange="onChange"></navbarList>
		</view>
		<view class="warp">
			<view class="contant">
				<view class="item " v-for="(item,index) in porps" :keys="inedx">
					 <image src="../../static/img/porpsBg.png" mode="widthFix" class="porpsBG " style="width: 100%;"></image>
					 <view class="itemcontant " >
						 <image src="../../static/icons/porps.png" mode="widthFix" class="porps_img "></image>
						 <view class="info">
							 <view class="left">
								 <text style="font-size: 32rpx;color: rgba(0,0,0,0.75);line-height: 38rpx;font-weight: 600;">{{item.title}}</text>
								 <text style="font-size: 24rpx;color: rgba(0,0,0,0.75);line-height:1.5;">{{item.info}}</text>
								 <text class="time ">有效期至<text style="color: #FF4A80;">{{item.time}}</text></text>
							 </view>
							 <button class="info_button">立即使用</button>
						 </view>
					 </view>
				</view>
			</view>
		</view>
	</view>
</template>

<script>
	export default {
		data() {
			return {
				items:[
					{
						title:'未使用',
						value:'unuse'
					},{
						title:'已使用',
						value:'used'
					},{
						title:'已过期',
						value:'passed'
					}
				],
				porps:[
					{
						title:'开盒道具',
						info:'拥有开盒能力，当日有效',
						time:'2021/09/09'
					},{
						title:'开盒道具',
						info:'拥有开盒能力，当日有效',
						time:'2021/09/09'
					},{
						title:'开盒道具',
						info:'拥有开盒能力，当日有效',
						time:'2021/09/09'
					}
				]
			}
		},
		methods: {
			onChange(e){
				console.log(e)
			}
		}
	}
</script>

<style scoped lang="scss">
	.prop_warp{
		min-height: 100vh;
		background-color: #FFFFFF;
	}
.item{
	position: relative;
	width: 100%;
	margin-bottom: 16rpx;
	.itemcontant{
		position: absolute;
		top: 0;
		left: 0;
		display: flex;
		align-items: center;
		width: 100%;
		height: 100%;
		padding:34rpx 14rpx;
		box-sizing: border-box;
		.porps_img{
			width: 160rpx;
			margin-right: 20rpx;
		}
		.info{
			display: flex;
			justify-content: space-between;
			align-items: center;
			height: 100%;
			width: 100%;
			.left{
				height: 100%;
				position: relative;
				display: flex;
				flex-direction: column;
				.time{
					position: absolute;
					bottom: 0;
					left: 0;
					font-size: 22rpx;
					color: #999999;
				}
			}
			.info_button{
				margin: 0;
				background: linear-gradient(50deg, #FF599B 0%, #FF4649 100%);
				color: #FFFFFF;
				border-radius: 46rpx;
				font-size: 28rpx;
				line-height: 2;
			}
		}
	}
	
}
.used{
	filter:grayscale(1);
}
</style>

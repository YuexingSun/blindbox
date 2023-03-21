<template>
	<view style="position: relative;">
		<navbar :needIcon="true" @back="back"  :sticky="true" @height="Naheight" :bgc="bgc">我的盲盒</navbar>
		<view class="heard" :style="'padding-top:' + height + 'px'">
			<view class="info">
				<view class="item">
					<view class="num">{{boxraisenum||0}}%</view>
					<text>盲盒满意度</text>
				</view>
				<view class="item">
					<view class="num">{{myboxticketnum||0}}</view>
					<text>可使用盲盒</text>
				</view>
			</view>
		</view>
		<view class="navbar" :style="'top:' + height + 'px'">
			<view class="item" v-for="(item,index) in type" :class="index==typeindex?'active':''" :key="index"
				@click="typeindex=index">
				{{item.title}}
			</view>
		</view>
		<view class="contatn" v-if="list.length==0" style="padding-top: 10vh;">
			<empty>
				<text class="empty_text">除了空空...什么也没有</text>
				<!-- <button class="empty_button" @click="switchTab()">去开盒</button> -->
			</empty>
		</view>
		<view class="contant" v-else>
			<view class="item" v-for="(item,index) in list" :key="index" @click="jumpTo(item)">
				<vier class="status">{{item.status | status}}</vier>
				<view class="title">
					<text class="text-cut" :style="{width:item.status==2?'50%':'100%'}">{{item.title}}</text>
					<text v-if="item.status==2" class="commit">待评价</text>
				</view>
				<view class="time" style="margin-top: 28rpx;">
					<image src="../../static/icons/time.png" mode="widthFix" style="width: 20rpx;margin-right: 18rpx;"></image>
				{{item.time}}</view>
				<view class="time" style="margin-top: 10rpx;">
					<image src="../../static/icons/location.png" mode="widthFix" style="width: 20rpx;margin-right: 18rpx;"></image>
				{{item.subtitle}}</view>
			</view>
		</view>
	</view>
</template>

<script>
	export default {
		data() {
			return {
				type: [{
					title: '全部',
					status: ''
				}, {
					title: '已完成',
					status: '2|3'
				}, {
					title: '已失效',
					status: '4|5'
				}, {
					title: '待评价',
					status: '2'
				}],
				typeindex: 0,
				pageNumber: 1,
				boxraisenum: 0, //满意度
				totalpage: 0, //总页数
				list: [], //盲盒列表
				myboxticketnum: 0, //我可开盲盒
				height:0,
				bgc:'linear-gradient(135deg, #ffe7ca 0%, #ffd8eb 100%);'
			}
		},
		methods: {
			back() {
				this.$tool.navigateBack()
			},
			//获取盲盒列表
			getBoxList() {
				var params = {
					status: this.type[this.typeindex].status,
					page: this.pageNumber
				}
				this.$api.user.getMyboxList(params).then(res => {
					// console.log(res)
					this.boxraisenum = res.boxraisenum
					this.totalpage = res.totalpage
					this.myboxticketnum = res.myboxticketnum
					if (this.pageNumber == 1) { //判定是否第一页
						this.list = res.list
					} else {
						this.list = [...this.list, ...res.list]
					}
				}).catch(err => {
					this.$tool.toast(err)
				}).finally(() => {
					uni.stopPullDownRefresh();
				})
			},
			jumpTo(item){
				// console.log(it/em)
				if(item.status==1||item.status==0){//进行中的盲盒跳转首页
					this.$tool.switchTab('/pages/bindbox/bindbox')
				}else if(item.status==4||item.status==5){
					return
				}else{
					this.$tool.navigateTo(`/pages/bindbox/boxDetails?boxId=${item.boxid}`)
				}
			},
			switchTab(){
				this.$tool.switchTab('/pages/bindbox/bindbox')
			},
			//导航栏高度
			Naheight(H){
				this.height=H
			}
		},
		onLoad() {
			this.getBoxList()
		},
		watch: {
			typeindex(newval, oldval) {
				this.pageNumber = 1
				this.getBoxList()
				// this
				// uni.settop
				uni.pageScrollTo({
				duration:0,//过渡时间必须为0，uniapp bug，否则运行到手机会报错
				scrollTop: 0,//滚动到目标位置
				// success:function(){
				// console,log('成功了')
				// }
				})
			}
		},
		onPullDownRefresh() {
			this.pageNumber = 1
			this.getBoxList()
		},
		onReachBottom() {
			if (this.pageNumber == this.totalpage) {
				return
			}
			this.pageNumber++
			this.getBoxList()
		},
		filters:{
			status(item){
				if(item==0){
					return '待开启'
				}
				if(item==1){
					return '进行中'
				}
				if(item==4||item==5){
					return '已失效'
				}else{
					return '已完成'
				}
			}
		}
	}
</script>

<style scoped lang="scss">
	.heard {
		background: linear-gradient(135deg, #ffe7ca 0%, #ffd5f4 100%);
	}

	.info {
		display: flex;
		justify-content: space-around;
		align-items: center;
		padding: 50rpx 0;

		.item {
			display: flex;
			justify-content: center;
			align-items: center;
			flex-direction: column;
			color: #FF416F;

			.num {
				font-size: 48rpx;
				font-weight: 600;
				line-height: 1.2;
			}

			text {
				font-size: 32rpx;
				margin-top: 20rpx;
			}
		}
	}

	.navbar {
		background-color: #FFFFFF;
		position: sticky;
		// top: 0;
		left: 0;
		z-index: 10;
		width: 100%;
		padding: 0 56rpx;
		// padding-top: var(--status-bar-height);  
		box-sizing: border-box;
		// display: flex;
		// // justify-content: center;
		// align-items: center;
		display: grid;
		grid-template-columns: repeat(4, 1fr);
		grid-gap: 30rpx;
		border-bottom: 4rpx solid #f5f5f5;

		.item {
			text-align: center;
			padding: 14rpx;
			box-sizing: border-box;
			color: #555555;
			font-size: 32rpx;
		}

		.active {
			color: #ff6287;
			// padding-bottom: 1rpx solid #ff6287;
			border-bottom: 6rpx solid #ff6287;

		}
	}

	.contant {
		min-height: 90vh;
		background-color: #f5f5f5;
		padding: 32rpx;
		box-sizing: border-box;

		.item {
			padding: 26rpx 44rpx;
			box-sizing: border-box;
			background-color: #FFFFFF;
			border-radius: 16rpx;
			margin-bottom: 20rpx;
			position: relative;
			.title{
				font-size: 36rpx;
				color: #333333;
				display: flex;
				align-items: center;	
				.commit{
					font-size: 28rpx;
					padding:6rpx 20rpx;
					background-color: #ffdca8;
					color: #FF8900;
					border-radius: 46rpx;
					margin-left: 20rpx;
				}
			}
			.time{
				font-size: 28rpx;
				color: #7e7e7e;
			}
			.status{
				font-size: 32rpx;
				color: #8e8e8e;
				position: absolute;
				top: 32rpx;
				right: 24rpx;
				
			}
		}
	}
	.empty_text{
		font-size: 28rpx;
		color: #919191;
	}
	.empty_button{
		margin-top: 44rpx;
		border-radius: 48rpx;
		font-size: 32rpx;
		color: #FFFFFF;
		background: linear-gradient(90deg, #F96F97 0%, #ED5556 100%);
		width: 50%;
	}
</style>

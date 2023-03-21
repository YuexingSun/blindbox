<template>
	<view class="navbar" >
		<view class="title" :style="'padding-top:' + statusBarHeight  + 'px;height:' + navigationHeight + 'px;background:' + bgc " :class="sticky?'sticky':''">
			<view class="back" @click="back">
				<uni-icons type="arrowleft" size="19" v-if="needIcon"></uni-icons>
			</view>
			<slot></slot>
		</view>
	</view>
	

</template>

<script>
	export default {
		name: "navbar",
		props:{
			needIcon:false,
			sticky:false,
			bgc:''
		},
		data() {
			return {
				// menuButtonInfo:''
				statusBarHeight: '',
				navigationHeight: '',
				// height:''
			};
		},
		mounted() {
			this.attached()
			
			// this.menuButtonInfo = uni.getMenuButtonBoundingClientRect().height + 25
			// console.log(this.menuButtonInfo)
		},
		methods: {
			// 获取胶囊
			getMenuButtonBoundingClientRect(systemInfo) {
				const ios = !!(systemInfo.system.toLowerCase().search('ios') + 1)
				let rect
				try {
					rect = wx.getMenuButtonBoundingClientRect ? wx.getMenuButtonBoundingClientRect() : null
					if (rect === null) {
						throw new Error('getMenuButtonBoundingClientRect error')
					}
					// 取值为0的情况  有可能width不为0 top为0的情况
					if (this.checkRect(rect)) {
						throw new Error('getMenuButtonBoundingClientRect error')
					}
				} catch (error) {
					let gap = '' // 胶囊按钮上下间距 使导航内容居中
					let width = 96 // 胶囊的宽度
					if (systemInfo.platform === 'android') {
						gap = 8
						width = 96
					} else if (systemInfo.platform === 'devtools') {
						if (ios) {
							gap = 5.5 // 开发工具中ios手机
						} else {
							gap = 7.5 // 开发工具中android和其他手机
						}
					} else {
						gap = 4
						width = 88
					}
					if (!systemInfo.statusBarHeight) {
						// 开启wifi的情况下修复statusBarHeight值获取不到
						systemInfo.statusBarHeight = systemInfo.screenHeight - systemInfo.windowHeight - 20
					}
					rect = {
						// 获取不到胶囊信息就自定义重置一个
						bottom: systemInfo.statusBarHeight + gap + 32,
						height: 32,
						left: systemInfo.windowWidth - width - 10,
						right: systemInfo.windowWidth - 10,
						top: systemInfo.statusBarHeight + gap,
						width
					}
				}
				return rect
			},
			attached: function() {
				const systemInfo = wx.getSystemInfoSync();
				// 状态栏的高度
				let statusBarHeight = systemInfo.statusBarHeight;
				// 获取胶囊按钮位置信息
				let boundingClientRect = this.getMenuButtonBoundingClientRect(systemInfo);
				// 导航栏高度
				let navigationHeight = boundingClientRect.height + (boundingClientRect.top - statusBarHeight) * 2;
				this.statusBarHeight=statusBarHeight
				this.navigationHeight=navigationHeight
				// this.setData({
				//   statusBarHeight: statusBarHeight,
				//   navigationHeight: navigationHeight,
				// })
				var height = statusBarHeight + navigationHeight
				this.$emit('height',height)
			},
			back(){
				this.$emit('back')
			}
		}
	}
</script>

<style lang="scss" scoped>

	.navbar{
		// position: relative;
	}
	.title {
	    position: relative;
	    top: 0;
	    width: 750rpx;
	    height: 80rpx;
	    z-index: 99999;
	    display: flex;
	    align-items: center;
	    justify-content: center;
	  }
	  
	  .nav-back-block {
	    display: flex;
	    height: 32px;
	    width: 86px;
	    align-items: center;
	    justify-content: center;
	    position: absolute;
	    left: 10px;
	    bottom: 15rpx;
	    border-radius: 32px;
	    background-color: rgba(255, 255, 255, 0.65);
	    border: 1rpx solid rgba(214, 212, 211, 0.5);
	    box-sizing: border-box;
	    z-index: 10000;
	  }
	  
	  .nav-back-icon {
	    height: 16rpx;
	    width: 16rpx;
	    border: 6rpx solid black;
	    border-right-color: transparent;
	    border-bottom-color: transparent;
	    transform: rotate(-45deg);
	  }
	  
	  .nav-back-text {
	    font-size: 16px;
	  }
	  .back{
		  position: absolute;
		  // top: 50%;
		  left: 40rpx;
		  // transform: translate(0,-50%);
	  }
	  .sticky{
	  	position: fixed;
	  	top: 0;
	  	left: 0;
	  }
</style>

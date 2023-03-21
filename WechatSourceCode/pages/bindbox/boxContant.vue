<template>
	<view class="bindBox_warp">
		<navbar></navbar>
		<boxContant @back="back" @jumpTo='jumpTo' :isTabbar="false" ref="boxContant"></boxContant>
	</view>
</template>

<script>
	import {mapGetter, mapActions} from 'vuex'
	export default {
		data() {
			return {
				// boxcontant:uni.getStorageSync('boxContant')[0]
			} 
		},
		methods: {
			...mapActions(["saveboxInfo",'saveoneBoxInfo']),
			jumpTo(e){
				var params= {
					boxid:e.boxInfo.boxid,
					indexid:e.chooseIndex+1
				}
					this.$api.box.startBox(params).then(res=>{
						uni.openLocation({
							address:e.boxInfo.address,
							name:e.boxInfo.buildName,
							latitude:e.boxInfo.lnglat.lat,
							longitude:e.boxInfo.lnglat.lng
						})
						this.$tool.switchTab('/pages/bindbox/bindbox')
					}).catch(err=>{
						this.$tool.toast(err)
					})
			},
			back(e){
				var _this=this
				// console.log(111)
								// this.$tool.switchTab('/pages/bindbox/bindbox')
				uni.showModal({
					content:'确定结束行程',
					success: (res) => {
						if(res.confirm){
							var params = {
								boxid:e.boxid
							}
							var boxInfo={}
							this.$api.box.endBox(params).then(res=>{
								// this.hasBox=false
								this.saveboxInfo(boxInfo)
								this.saveoneBoxInfo(boxInfo)
								_this.$tool.navigateBack()
							}).catch(err=>{
								this.$tool.toast(err)
							})
						}
					}
				})
			},
		},
		computed:{
		},
	}
</script>

<style scoped lang="scss">
.warp{
	// background-color: #ffedeb;
	// min-height: 100vh;
	// display: flex;
	// justify-content: center;
	// align-items: center;
	position: relative;
}
.bindBox_warp{
	background-image: url('https://admin.sjtuanliu.com/api/Uploads/images/2021/08/31/2021083116370216303990229963.png');
	background-size:100vw auto;
	min-height: 100vh;
	background-repeat: no-repeat;
	background-size: cover;
	padding-bottom: 50rpx;
} 
.bgc{
	position: absolute;
	top: 0;
	left: 0;
	z-index: -1;
	height: 100%;
}
</style>

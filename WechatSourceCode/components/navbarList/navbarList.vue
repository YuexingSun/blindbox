<template>
	<view class="navbarList_warp">
		<view class="item" v-for="(item,index) in items" :key="index" :class="myactive==index?'active':''" @click="change(item,index)">
			{{item.title}}
		</view>
	</view>
</template>

<script>
	export default {
		name:"navbarList",
		data() {
			return {
				myactive:0
			};
		},
		props:{
			items:{
				type:Array,
				default:[]
			},
			active:{
				type:Number,
				default:0
			}
		},
		methods:{
			change(item,index){
				this.myactive=index
				this.$emit('onChange',item)
			}
		},
		mounted() {
			this.myactive=JSON.parse(JSON.stringify(this.active))
			
		}
	}
</script>

<style scoped lang="scss">
.navbarList_warp{
	width: 100%;
	background-color: #FFFFFF;
	display: flex;
	justify-content: space-around;
	align-items: center;
	padding: 20rpx;
	.item{
		color: #6f6f6f;
		font-size: 32rpx;
		line-height: 2;
		border-bottom: 2px solid #FFFFFF;
		position: relative;
	}
	.active{
		color: #FF416F;
	}
	.active:after{
		position: absolute;
		content: "";
		bottom: 0;
		left: 50%;
		transform: translate(-50%,0);
		width: 70%;
		height: 2px;
		background-color:#FF416F;
		// color: #FF416F;
		// border-bottom: 2px solid #ff416f;
		// border-width: 80%;
	}
}
</style>

<template>
	<view>
		<!-- <image :src="src" :mode="mode" @error="imgError" 
			:style="'width:'+(width<1?width*100+'%':width+'rpx')+'; height: '+(height<1?height*100+'%':height+'rpx')+'; background-image: url('+alt+'); background-size:'+(width<1?width*100+'%':width+'px')+' '+(height<1?height*100+'%':height+'px')+';'">
		</image> -->
		<image :src="url?url:alt" mode="widthFix" style="width: 112rpx;" @error="imgError"></image>
	</view>
</template>

<script>
	export default {
		props: {
			src: {
				type: String,
				default: '' 
			}, 
			alt: {
				type: String,
				default: ''
			},
			mode: {
				type: String,
				default: 'scaleToFill'
			},
			width: {
				type: Number,
				default: 70
			},
			height: {
				type: Number,
				default: 90
			}
		},
		data() {
			return {
				url: ''
			};
		},
		methods: {
			imgError(){
				console.log(this.alt)
				this.url = this.alt;
			},
		}
	}
</script>

<style scoped>
	image{
		border-radius: 50%;
		overflow: hidden;
	}
</style>

<template>
	<view class="empty flex column">
		<image src="../../static/icons/empty.png" mode="widthFix" style="width: 340rpx;"></image>
		<slot></slot>
	</view>
</template>

<script>
	export default {
		name:"empty",
		data() {
			return {
				
			};
		}
	}
</script>

<style lang="scss" scoped>
.empty{
	width: 100%;
}
</style>

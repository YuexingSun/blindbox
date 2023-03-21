<template>
	<view class="setting_warp">
		<view class="sex" v-if="title=='性别'">
			<view class="item" @click="sex=1">
				<text>男</text>
				<uni-icons type="checkmarkempty" color="#999999" v-if="sex==1" ></uni-icons>
			</view>
			<view class="item" @click="sex=0">
				<text>女</text>
				<uni-icons type="checkmarkempty" color="#999999" v-if="sex==0"></uni-icons>
			</view>
		</view>
		<view class="phone" v-if="title=='手机号'">
			<input type="text" value="" v-model="phone" :placeholder="userInfo.memberinfo.phone"/>
		</view>
		<view class="phone" v-if="title=='设置昵称'">
			<input type="text" value="" v-model="name" :placeholder="userInfo.memberinfo.nickname"/>
		</view>
		<view class="phone" v-if="title=='设置年龄'">
			<picker mode="date" fields="month" :value="age" :end="endDate" @change="bindDateChange">
				<!-- <view class="uni-input" style="width: 100%;">{{userInfo.age}}</view> -->
				<view class="input flex" >
					<input type="number" v-model="age"  disabled :placeholder="userInfo.memberinfo.age"/>
					<!-- <text>{{age}}</text> -->
				</view>
			</picker>
		</view>
		<view class="button" @click="setUserProfile">确定</view>
	</view>
</template>

<script>
	import {mapGetters} from 'vuex' 
	export default {
		data() {
			return {
				title:'',
				sex:0,
				phone:'',
				name:'',
				age:''
			}
		},
		methods: {
			getDate(type) {
				const date = new Date();
				let year = date.getFullYear();
				let month = date.getMonth() + 1;
				let day = date.getDate();
			
				if (type === 'start') {
					year = year - 60;
				} else if (type === 'end') {
					year = year;
				}
				month = month > 9 ? month : '0' + month;
				day = day > 9 ? day : '0' + day;
				return `${year}-${month}-${day}`;
			},
			bindDateChange(e) {
				// console.log(e)
				this.age=e.detail.value
			},
			setUserProfile(){
				var params={}
				if(this.age){
					// console.log(1212)
					params.age=this.age
				}else if(this.name){
					params.nickname=this.name
				}else if(this.sex){
					params.sex =this.sex
				}
				this.$api.user.setUserProfile(params).then(res=>{
					this.$tool.toast('更新成功')
					setTimeout(()=>{
						this.$tool.navigateBack()
					},1600)
				}).catch(err=>{
					this.$tool.toast(err)
				})
			}
		},
		computed: {
			endDate() {
				return this.getDate('end');
			},
			...mapGetters(['UserProfile'])
		},
		onLoad(options) {
			if(options.type=='name'){
				this.title='设置昵称'
				this.name=this.UserProfile.nickname
			}else if(options.type=='phone'){
				this.title='手机号'
			}else if(options.type=='age'){
				this.title='设置年龄'
				this.age=this.UserProfile.age
			}else if(options.type=='sex'){
				this.title='性别'
				this.sex=this.UserProfile.sex
			}
			uni.setNavigationBarTitle({
				title:this.title
			})
		}
	}
</script>

<style lang="scss" scoped>
.sex{
	background-color: #FFFFFF;
	padding: 0 32rpx;
	box-sizing: border-box;
	.item{
		margin-top: 16rpx;
		font-size: 32rpx;
		display: flex;
		align-items: center;
		justify-content: space-between;
		padding: 32rpx 0;
		border-bottom: 1rpx solid #EBEBEB;
	}
	.item:last-child{
		margin: 0;
		border: none;
	}

}
.phone{
	margin-top: 16rpx;
	background-color: #FFFFFF;
	border-bottom: 1rpx solid #d6d6d6;
	padding: 19rpx 16rpx;
	font-size: 32rpx;
	input{
		width: 100%;
	}
}
	.button{
		background-color: #FFFFFF;
		margin-top: 16rpx;
		font-size: 32rpx;
		height: 96rpx;
		display: flex;
		justify-content: center;
		align-items: center;
		color: #ff3366;
	}
</style>

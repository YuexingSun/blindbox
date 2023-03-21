<template>
	<view class="boxDetail">
		<view class="bg">
			<image src="../../static/img/mybg.png" mode="widthFix" style="width: 100vw;"></image>
		</view>
		<navbar :needIcon="true" @back="back">行程详情</navbar>
		<view class="contant warp">
			<view class="status_warp" v-if="boxDetails.status==4||boxDetails.status==5">
				<view class="status">已失效</view>
				<view class="reason">用户主动终止行程/行程已超时</view>
			</view>
			<view class="status_warp" v-else>
				<view class="status">已完成</view>
				<view class="reason">恭喜！已走完整个行程</view>
			</view>
			<view class="first card shape flex">
				<text style="font-size: 28rpx;font-weight: 500;color: rgba(68,44,94,0.8);">{{boxDetails.status==4||boxDetails.status==5?'未到达目的地':'到达目的地'}}</text>
				<view class="left  flex " :class="boxDetails.status==4||boxDetails.status==5?'unfinisleft':''">
					<view class="icon "><image src="../../static/icons/xingxing.png" mode="widthFix" ></image></view>
					<text v-if="boxDetails.status==4||boxDetails.status==5">幸运值+0</text>
					<text v-else>幸运值+{{boxDetails.beinpoint||0}}</text>
				</view>
			</view>
			
			<view class="second other card" >
				<view class="flex " style="padding: 20rpx;box-sizing: border-box;background-color: #FFFFFF;">
					<image :src="boxDetails.logo" mode="widthFix" style="width: 148rpx;margin-right: 30rpx;"></image>
					<view class="right" v-if="boxDetails.status==4||boxDetails.status==5">
						<text class="name">{{boxDetails.title}}</text>
						<!-- <uni-rate :value="boxDetails.point" :readonly="true" activeColor="#ff599f" size="12"></uni-rate> -->
						<view class="address">某未知地点</view>
					</view>
					<view class="right" v-else="boxDetails.status==4||boxDetails.status==5">
						<text class="name">{{boxDetails.realname}}</text>
						<uni-rate :value="boxDetails.point" :readonly="true" activeColor="#ff599f" size="12"></uni-rate>
						<view class="address">{{boxDetails.address}}</view>
					</view>
				</view>
			</view>
			
			<view class="three card">
				<view class="item" v-for="(item,index) in boxDetails.items" :key="index">
					<view class="left">
						<view class="icon">
							<image :src="icons[index]"  style="width: 30rpx;height: 30rpx;"></image>
						</view>
						<text>{{item.item}}</text>
					</view>
					<view class="right">
						<text v-if="item.type==1||item.type==2">{{item.value}}</text>
						<uni-rate v-model="item.value" :readonly="true" :size="16" v-if="item.type==3||item.type==4"/>
					</view>
				</view>
			</view>
			
			<view class="four card" v-if="boxDetails.status==2||boxDetails.status==3">
				<image src="../../static/img/luck.png" mode="widthFix" style="width: 280rpx;"></image>
				<view class="title">您对这次盲盒的内容满意吗？</view>
				<view class="satisfied" v-if="boxDetails.islike===0">
					<view class="item" @click="Satisfied(1)">
						<image src="../../static/icons/Satisfied.png" mode="widthFix"></image>
						<text>满意</text>
					</view>
					<view class="item" @click="Satisfied(2)">
						<image src="../../static/icons/unSatisfied.png" mode="widthFix"></image>
						<text>不满意</text>
					</view>
				</view>
				<view class="satisfied" v-else>
					<view class="item">
						<image :src="`../../static/icons/${boxDetails.islike==1?'ASatisfied':'AunSatisfied'}.png`" mode="widthFix"></image>
						<text>{{boxDetails.islike==1?'满意':'不满意'}}</text>
					</view>
				</view>
				<view v-if="boxDetails.islike===2&&boxDetails.status==2">
					<view class="reason" >
						<view class="item" :class="myreason.indexOf(item)!=-1?'active':''" v-for="(item,index) in reason" :key="index" @click="addreason(item)">
							{{item}}
						</view>
					</view>
					<textarea  placeholder="其他原因" v-model="otherReason" class="textarea"/>
					<button type="default" class="button" @click="sumbitPinjia">提交评价</button>
				</view>
				<view v-if="boxDetails.islike===2&&boxDetails.status==3">
					<view class="reason" v-if="up">
						<view class="item"  v-for="(item,index) in boxDetails.mycommentlist" :key="index" @click="addreason(item)">
							{{item}}
						</view>
					</view>
					<!-- <textarea  placeholder="其他原因" v-model="otherReason" class="textarea"/> -->
					<view class="check" v-if="!up" @click="up=true"><text>查看评论</text><uni-icons size="11" type="arrowdown" ></uni-icons></view>
					<view class="check up"  v-if="up"  @click="up=false"><text>收起评论</text><uni-icons size="11" type="arrowup"></uni-icons></view>
				</view>
				<view v-if="boxDetails.islike===1&&boxDetails.status==2" class="flex column">
					<view class="text_info">“感谢支持，我们会继续努力”</view>
					<button type="default" open-type="share" class="button" style="margin-bottom: 20rpx;width: 80%;">分享给好友</button>
					<image src="../../static/img/share.png" mode="widthFix" style="width: 304rpx;" class="image"></image>
				</view>
			</view>
		</view>
		
	</view>
</template>

<script>
	export default {
		data() {
			return {
				boxId:'',
				boxDetails:{},
				icons:['../../static/icons/distance.png','../../static/icons/consumption.png','../../static/icons/freshness.png','../../static/icons/mystery.png'],
				reason:['以前来过','不喜欢这个地方','导航不清晰','太好猜','时间不准确','找不到店'],
				myreason:[],
				otherReason:'',
				up:false
			}
		},
		onLoad(options){
			this.boxId=options.boxId || ''
			// this.boxId=505
			// console.log(this.boxId)
			this.getBoxDetail()
		},
		methods: {
			getBoxDetail(){
				var params={
					boxid:this.boxId
				}
				this.$api.box.getBoxDetail(params).then(res=>{
					// console.log(res)
					this.boxDetails=res[0]
					// console.log(this.boxDetails)
				}).catch(err=>{
					// console.log(err)
					this.$tool.toast(err)
				})
			},
			back(){
				this.$tool.navigateBack()
			},
			Satisfied(islike){
				var params={
					boxid:this.boxDetails.boxid,
					islike:islike
				}
				this.$api.box.finishBox(params).then(res=>{
					this.boxDetails.islike=islike
					// this.$tool.toast()
				}).catch(err=>{
					this.$tool.toast(err)
				})
			},
			addreason(item){
				var index = this.myreason.indexOf(item)
				if(index!=-1){
					this.myreason.splice(index,1)
				}else{
					this.myreason.push(item)
				}
			},
			sumbitPinjia(){
				var _reason=JSON.parse(JSON.stringify(this.myreason))
				if(this.otherReason){
					_reason.push(this.otherReason)
				}
				var str =_reason.toString().replace(/,/g, "|")
				console.log(str)
				var params={
					content:str,
					boxid:this.boxId
				}
				this.$api.box.enjoyBox(params).then(res=>{
					// console.log(res)
					this.getBoxDetail()
				}).catch(err=>{
					this.$tool.toast(err)
				})
			}
		}
	}
</script>

<style scoped lang="scss">
	// .boxDetail{
	// 	background-color: #f4f4f4;
	// }
.contant{
	background: linear-gradient(180deg,rgba(255,255,255,0) 0%,rgba(245, 245, 245,1) 100%);
}
.bg{
	position: absolute;
	top: 0;
	left: 0;
	z-index: -1;
	// flex-direction: column;
}
.status_warp{
	color: #ff416f;
	padding: 0 40rpx ;
	.status{
		font-size: 36rpx;
		font-weight: 600;
		line-height: 1.5;
	}
	.reason{
		font-size: 28rpx;
		line-height: 33rpx;
	}
}
.card{
	background-color: #FFFFFF;
	padding: 18rpx 22rpx;
	border-radius: 26rpx;
	box-sizing: border-box;
	margin: 20rpx 0;
}
.shape{
	border-top-right-radius: 0;
	border-bottom-left-radius: 0;
	width: 70%;
	font-size: 32rpx;
	.icon{
		width: 28rpx;
		height: 28rpx;
		display: flex;
		justify-content: center;
		align-items: center;
		background-color: #ff86aa;
		border-radius: 50%;
		margin-right: 10rpx;
		image{
			width: 80%;
			height: 80%;
		}
	}
	.left{
		background-color: #FFB2E9;
		color: #df5e9e;
		font-size: 28rpx;
		line-height: 1.5;
		border-radius: 46rpx;
		margin-left: 20rpx;
		padding: 2rpx 20rpx;
	}
	.unfinisleft{
		background-color: #ececec;
		color: #bcbcbc;
		.icon{
			background-color: #c2c2c2;
		}
	}
}
.second{
	.right{
		.name{
			font-size: 36rpx;
			// line-height: 2;
			padding-bottom: 20rpx;
		}
		.address{
			font-size: 28rpx;
			// line-height: ;
			color: #6e6f72;
		}
	}
}
.three{
	padding: 40rpx;
	box-sizing: border-box;
	.item{
		display: flex;
		// justify-content: ;
		justify-content: space-between;
		align-items: center;
		margin-bottom: 20rpx;
		text{
			font-size: 28rpx;
		}
		.left{
			// flex: 1;
			display: flex;
			align-items: center;
			color: #8484b2;
			.icon{ 
				margin-right: 22rpx;
			}
		}
		.right{
			// flex: 1;
			color: #442c60;
			font-weight: 600;
		}
	}
}
.four{
	padding: 20rpx 40rpx;
	box-sizing: border-box;
	background: linear-gradient(195deg, #FFF2F9 0%, #FFFFFF 100%);
	.title{
		font-size: 32rpx;
		line-height: 2;
	}
	.satisfied{
		display: flex;
		justify-content: space-around;
		align-items: center;
		.item{
			display: flex;
			flex-direction: column;
			align-items: center;
			justify-content: center;
			margin: 40rpx;
			image{ 
				width: 80rpx;
				height: 80rpx;
			}
			text{
				margin-top: 20rpx;
				font-size: 24rpx;
				line-height: 28rpx;
			}
		}
	}
	.reason{
		display: grid;
		grid-template-columns: 1fr 1fr;
		grid-gap: 24rpx;
		.item{
			font-size: 28rpx;
			border-radius: 16rpx;
			border: 1rpx solid #a1a1a1;
			color: #a1a1a1;
			text-align: center;
			padding: 16rpx 0;
		}
		.active{
			color: #FF4A80;
			background-color: #fddae5;
			border-color: #feacc6;
		}
		
	}
	.textarea{
		margin-top: 20rpx;
		width: 100%;
		border-radius: 16rpx;
		font-size: 28rpx;
		background-color: #ebebeb;
		border: 1rpx solid #d8d8d8;
		color:#8f8f8f;
		padding: 20rpx;
		box-sizing: border-box;
		height: 80rpx;
	}
	.button{
		background: linear-gradient(91deg, #FF599F 0%, #FF4545 100%);
		color: #FFFFFF;
		font-weight: 600;
		font-size: 32rpx;
		border-radius: 46rpx;
		margin-top: 40rpx;
	}
	.text_info{
		font-size: 34rpx;
		font-weight: 600;
		// margin-top: 50rpx;
		text-align: center;
	}
	
	
}
.check{
	text-align: center;
	font-size: 28rpx;
}
.up{
	margin-top: 50rpx;
}
.flex{
	display: flex;
	// justify-content: center;
	align-items: center;
}

</style>

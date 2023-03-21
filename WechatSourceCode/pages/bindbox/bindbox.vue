<template>
	<view :class="hasBox?'box_warp':'bindBox_warp'">
		<navbar></navbar>
	<!-- 	<image src="../../static/img/backgroundcolor.png" mode="widthFix" style="width: 100vw;" class="bgc" v-if="hasBox"></image>
		<view v-else>
			<image src="../../static/svg/bindBoxBg.svg" mode="aspectFill" class="bgc" style="width: 100vw;height: 100vh;"></image>
		</view> -->
		<view class="ing"  v-if="hasBox" style="padding-bottom: 50rpx;">
			<boxContant @back="back" @jumpTo='jumpTo' @arrivedBox='arrivedBox' @play="initLottie" ref="boxContant"  :isTabbar='true'></boxContant>
		</view>
		<view class="warp" style="padding-top: 0;" v-if='!hasBox'>
			<view class="title">选择一种盲盒，准备出行</view>
			<swiper class="swiper" indicator-dots indicator-active-color="#ec5455">
				<swiper-item v-for="(item,index) in boxsTypes" :key="index" class="swiper-item">
					<image :src="item.pic" mode="aspectFill"></image>
					<button class="button" @click="openbox(item)">{{item.status==0?'准备出行':'敬请期待'}}</button>
				</swiper-item>
			</swiper>
		</view>
		
		<uni-popup ref="choosepopup" type="bottom"  @change="hidetabbar" :maskClick="false">
			<view class="choosePopup">
				<scroll-view scroll-y="true" style="height: calc(80vh);">
					<!-- 选项 -->
					<view class="question" v-for="(item,index) in boxQuestions" :key="index">
						<view class="title">{{item.title}}</view>
						<view class="questioncantant grid" v-if="item.type=='tag'">
							<view class="item" :class="ansitem.itemid==item.ans.itemid?'active':''" v-for="(ansitem,ansindex) in item.itemlist" :key="ansindex" @click="choose(item,ansitem)">
								{{ansitem.itemname}}
							</view>
						</view>
						<!-- 进度条 -->
						<view class="questioncantant range" v-if="item.type=='range'">
							<view class="top">
								<view>{{item.itemlist[0].itemname}}</view>
								<view>{{item.itemlist[item.itemlist.length-1].itemname}}</view>
							</view>
							<slider @change="sliderChange($event.detail,item)"  :min="0" :max="item.itemlist.length-1" :block-size="12" activeColor="#f86d97" backgroundColor="#ffedeb"/>
							<view class="bottom">
								当前选择：{{item.ans.itemname}}
							</view>
							<!-- <cj-slider :min="0" :max="item.itemlist.length-1" :step="1" v-model="priceValue" inactiveColor="#ffedeb" activeColor="#f8749c" ></cj-slider> -->
							<!-- <cu-progress :max="4" :min="0" :step="1" showInfo></cu-progress> -->
						</view>
						<scroll-view  v-if="item.type=='image'" scroll-x="true" :scroll-left="100" style="height: 300rpx">
							<view class="scroll-view ">
								<view class="item" :class="imageitem.itemid==item.ans.itemid?'active':''" v-for="(imageitem,imageindex) in item.itemlist" :key="imageindex"  @click="choose(item,imageitem)">
									<image :src="imageitem.itempic" mode="widthFix" ></image>
									<text>{{imageitem.itemname}}</text>
								</view>
							</view>
							
						</scroll-view>
					</view>
					<view class="button">
						<view class="canclce" @click="canclcechoosepopup">取消</view>
						<view class="confirom" @click="sumbitans">选好了</view>
					</view>
				</scroll-view>
			</view>
		</uni-popup>
		<view class="lottie_warp" :class="palying==1?'playing':''">
			<canvas id="test-canvas" canvas-id="test-canvas" style="width: 100px;height: 100px;"></canvas>
		</view>
	</view>
</template>

<script>
	import lottie from "lottie-miniapp";
	import {
		mapGetters,
		mapActions
	} from 'vuex'
	export default {
		computed:{
			...mapGetters(["boxInfo"])
		},
		data() {
			return {
				boxsTypes: [],
				boxQuestions:[],
				answer:[],
				typeid:'',
				lat:'',
				lng:'',
				hasBox:false,
				palying:0
			}
		}, 
		onLoad() {
			this.getboxsType()
			// this.initLottie()
		
		},
		onShow() {
			this.getUserhasBox()
			this.getLocation()
		},
		methods: {
			...mapActions(["saveBox",'savelocation','saveboxInfo','saveoneBoxInfo']),
			//获取定位
			getLocation(){
				var _this=this
				uni.getLocation({
					altitude:true,
					type:'gcj02',
					success: (res) => {
						// console.log(res)
						var location=[res.latitude,res.longitude]
						_this.savelocation(location)
					},fail(err) {
						uni.authorize({
						    scope: 'scope.userLocation',
						    success() {
						        this.getLocation()
						    }
						})
					}
				})
			},
			//获取盲盒种类
			getboxsType() {
				this.$api.box.boxsType().then(res => {
					this.boxsTypes = res
				}).catch(err => {
					this.$tool.toast(err)
				})
			},
			//去开盲盒
			openbox(item){
				this.typeid=item.typeid
				if(item.status!==0){
					return
				}
				var token = uni.getStorageSync('token')
				// var login = this.$tool.judgeUserIsOld()
				if(!token){
					this.$tool.toast('请先登录')
					setTimeout(()=>{
						this.$tool.switchTab('/pages/my/my')
					},1500)
					return
				}
				this.getBoxQuestion(item.typeid)
			},
			//获取盲盒问题
			getBoxQuestion(typeid){
				var params={
					typeid
				}
				this.$api.box.getBoxQuestion(params).then(res=>{
					this.boxQuestions=res.map((item)=>{
						var _ans = item.itemlist.findIndex((ansitem)=>ansitem.itemid==item.defaultid)
						return {
							...item,
							ans:item.itemlist[_ans]||item.itemlist[0],
							index:_ans
						}
					})
					this.$refs.choosepopup.open()
				}).catch(err=>{
					this.$tool.toast(err)
				})
			},
			//单选
			choose(question,ans){
				question.ans=ans
			},
			sliderChange(e, questions){
				questions.ans = questions.itemlist[e.value]
			},
			//取消答题弹窗
			canclcechoosepopup(){
				this.$refs.choosepopup.close()
			},
			//待提交
			sumbitans(){
				this.answer=this.boxQuestions.map((item)=>{
					return{
						quesid :item.id,
						ans :item.ans
					}
				})
				this.canclcechoosepopup()
				this.saveBox(this.answer)
				this.$tool.navigateTo(`/pages/bindbox/openBox?typeid=${this.typeid}`)
			},
			//控制导航栏显示
			hidetabbar(e){
				if(e.show){
					this.$tool.hideTabBar()
				}else{
					this.$tool.showTabBar()
				}
			},
			back(e){
				uni.showModal({
					content:'确定结束行程',
					success: (res) => {
						if(res.confirm){
							var params = {
								boxid:e.boxid
							}
							var boxInfo={}
							this.$api.box.endBox(params).then(res=>{
								this.hasBox=false
								this.saveboxInfo(boxInfo)
								this.saveoneBoxInfo(boxInfo)
							}).catch(err=>{
								this.$tool.toast(err)
							})
						}
					}
				})
			},
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
					}).catch(err=>{
						this.$tool.toast(err)
					})
				// }else{
				// 	this.$tool.navigateTo('/pages/bindbox/map')
				// }
			},
			//获取用户是否存在进行中的盒子
			getUserhasBox(){
				var token = uni.getStorageSync('token')
				if(!token){
					return 
				}
				this.$api.user.checkBeingBox().then(res=>{
					if(res.boxid){
						this.getBoxDetail(res.boxid)
						this.hasBox=true
					}else{
						this.hasBox=false
					}
					
				}).catch(err=>{
					this.$tool.toast(err)
				})
			},
			//获取进行中盒子的详情
			getBoxDetail(boxid){
				var params={
					boxid
				}
				this.$api.box.getBoxDetail(params).then(res=>{
					this.saveboxInfo(res)
					this.saveoneBoxInfo(res[0])
				}).catch(err=>{
					this.$tool.toast(err)
				}) 
			},
			arrivedBox(){
				this.getUserhasBox()
			},
			//加载开盒动画
			initLottie(){
				const canvasContext = uni.createCanvasContext("test-canvas");
				//  请求到的lottie json数据
				const animationData = {};
				// 请求lottie的路径。注意开启downloadFile域名并且返回格式是json
				const animationPath = "https://api.sjtuanliu.com/jsons/data.json";
				
				// 指定canvas大小
				canvasContext.canvas = {
				  width: 100,
				  height: 100,
				};
				// canvasContext.translate(50,50)
				// 如果同时指定 animationData 和 path， 优先取 animationData
				var _lottie = lottie.loadAnimation({
				  renderer: "canvas", // 只支持canvas
				  loop: false,
				  autoplay: false,
				  // animationData: animationData,
				  path: animationPath,
				  rendererSettings: {
				    context: canvasContext,
				    clearCanvas: true,
				  },
				});
				this.palying=1
				_lottie.play()
				_lottie.addEventListener('complete', ()=>{
					// console.log('播放完成')
					this.$refs.boxContant.longpress()
					this.palying=0
				});
			},
		}
	}
</script>

<style scoped lang="scss">
	.bindBox_warp{
		// background: linear-gradient(180deg, #FFE4CC 0%, #DCD0FF 100%);;
		background-image: url('https://admin.sjtuanliu.com/api/Uploads/images/2021/09/03/2021090314382116306511012705.png');
		background-size:100vw auto;
		min-height: 100vh;
		background-repeat: no-repeat;
		background-size: cover;
	}
	.box_warp{
		background-size:100vw auto;
		min-height: 100vh;
		background-image: url('https://admin.sjtuanliu.com/api/Uploads/images/2021/08/31/2021083116370216303990229963.png');
		background-repeat: no-repeat;
		background-size: cover;
	}
	.title {
		font-size: 40rpx;
		font-weight: 600;
		line-height: 2;
		text-align: center;
		color: #442c60;
	}
	.swiper{
		margin-top: 40rpx;
		height: 75vh;
		
		// height: 100%;
		// height: 1014rpx;
		.swiper-item{
			display: flex;
			justify-content: center; 
			border-radius: 16rpx;
			overflow: hidden;
			position: relative;
			// width: 100%;
		}
		image{
			width: 100vw;
			height: 100%;
			border-radius: 16rpx;
			overflow: hidden; 
			// width: 622rpx;
			// height: 1014rpx;
			// width: 622rpx;
		}
		.button{
			width: 80%;
			position: absolute;
			bottom: 40rpx;
			left: 50%;
			transform: translateX(-50%);
			color: #FFFFFF;
			font-size: 32rpx;
			border-radius: 46rpx;
			line-height: 2.5;
			background: linear-gradient(90deg, #FF599E 0%, #FF4545 100%);
			
		}
	}
	.choosePopup{
		height: 90vh;
		border-top-left-radius: 46rpx;
		border-top-right-radius: 46rpx;
		padding: 48rpx;
		box-sizing: border-box;
		background-color: #FFFFFF;
		.button{
			padding: 20rpx;
			box-sizing: border-box;
			display: flex;
			font-size: 32rpx;
			line-height: 2.5;
			.canclce{
				border-radius: 46rpx;
				flex: 1;
				color: #bcb5c3;
				background-color: #efefef;
				text-align: center;
				margin-right: 40rpx;
			}
			.confirom{
				border-radius: 46rpx;
				text-align: center;
				flex: 2.5;
				color: #FFFFFF;
				background: linear-gradient(90.68deg, #F86E97 0.59%, #EC5454 100%);;
			}
		}
	}
	.questioncantant{
		margin: 48rpx 0;
	}
	.range{
		.top{
			display: flex;
			justify-content: space-between;
			align-items: center;
			font-size: 28rpx;
			color: #b4acbc;
		}
		.bottom{
			font-size: 28rpx;
			color: #b4acbc;
		}
	}
	.grid{
		display: grid;
		 grid-template-columns:repeat(3,1fr);
		 grid-gap: 30rpx;
		 .item{
			 padding: 13rpx 26rpx;
			 font-size: 26rpx;
			 // line-height: 18rpx;
			 color: #B4ACBC;
			 border: 1rpx solid #B4ACBC;
			 border-radius: 46rpx;
			 display: flex;
			 justify-content: center;
			 align-items: center;
		 }
		 .active{
			 border: 1rpx solid #f86d97;
			 color: #FFFFFF;
			 background-color: #f86d97;
			 opacity: 1;
		 }
	}
.info{
	display: flex;
	flex-direction: column;
	justify-content: center;
	align-items: center;
	width: 70vw;
	font-size: 40rpx;
	height: calc(50vw * 1.2);
	background-color: #FFFFFF;
	// border: 24rpx;
	border-radius: 24rpx;
	text{
		font-weight: 600;
		line-height: 2.5;
	}
}
.open-btn{
	font-size: 32rpx;
	border-radius: 46rpx;
	line-height: 2.5;
	background:linear-gradient(90deg, #F86E97 0.59%, #EC5454 100%);
	color: #FFFFFF;
}
.scroll-view{
	// display: flex;
	display: grid;
	grid-template-columns: repeat(6,200rpx);
	margin-top: 40rpx;
	.item{
		display: flex;
		justify-content: center;
		align-items: center;
		flex-direction: column;
		opacity: 0.3;
		// width: 100%;
		image{
			width: 144rpx;
			height: 144rpx;
		}
		text{
			line-height: 2;
			// margin-top: 40rpx;
			color: #442C60;
			font-size: 28rpx;
			font-size: 600;
		}
	}
	.active{
		opacity: 1;
	}
}
.ing{
	// padding: 40rpx;
	padding-top: 0;
	box-sizing: border-box;
	position: relative;
	// background-image: url('https://imgtu.com/i/hEymcV');
}
.bgc{
	position: absolute;
	top: 0;
	left: 0;
	z-index: -1;
}
.lottie_warp{
	height: 100vh;
	width: 100vw;
	display: flex;
	justify-content: center;
	align-items: center;
	position: absolute;
	top: 0;
	left: 0;
	background-color: rgba(0,0,0,0.3);
	opacity: 0;
	z-index: -99;
}
.playing{
	opacity: 1;
	z-index: 99;
}
</style>

<template>
	<view class="contant">
		<view class="firstpage" v-show="nowpage==0">
			<view class="questioncontant">
				<text style="color: #8f8f8f;">填个用户名吧</text>
				<view class="input flex">
					<image src="../../static/icons/name.png" mode="widthFix" style="width: 48rpx;"></image>
					<input type="text" v-model="userInfo.username" maxlength="8" @click="getuserInfo" />
				</view>
			</view>
			<view class="questioncontant">
				<text>再填个年龄吧</text>
				<picker mode="date" fields="month" :value="userInfo.age" :end="endDate" @change="bindDateChange">
					<!-- <view class="uni-input" style="width: 100%;">{{userInfo.age}}</view> -->
					<view class="input flex" >
						<image src="../../static/icons/age.png" mode="widthFix" style="width: 48rpx;"></image>
						<!-- <input type="number" v-model="userInfo.age"  disabled/> -->
						<text>{{userInfo.age}}</text>
					</view>
				</picker>
			</view>
			<view class="questioncontant">
				<text>你是小哥哥还是小姐姐啊？</text>
				<view class="choose">
					<view class="item" :class="userInfo.sex==1?'active':''" @click="userInfo.sex=1">
						<image :src="`../../static/icons/${userInfo.sex==1?'Aman':'man'}.png`" mode="widthFix" style="width: 162rpx;"></image>
					</view>
					<view class="item" :class="userInfo.sex==0?'active':''" @click="userInfo.sex=0">
						<image :src="`../../static/icons/${userInfo.sex==0?'Agirl':'girl'}.png`" mode="widthFix" style="width: 162rpx;"></image>
					</view>
				</view>
			</view>
			<button type="default" class="next" @click="submituserInfo">下一步</button>
		</view>
		<view class="sencondwarp" v-show="nowpage==1">
			<view class="title">拖一下这 5 个东西</view>
			<view class="question" v-for="(question,index) in questions" :key="index">
				<view class="questioncontant">
					<view class="info">
						<text class="lefttext">{{question.title}}</text>
						<text class="righttext">{{question.ans.itemname}}</text>
					</view>
					<view class="slider_warp">
						<slider :value="0" @change="sliderChange($event.detail,question)" min="0"
							:max="question.itemlist.length-1" block-size="16" activeColor="#F86D97"
							block-color="#dddddd" backgroundColor="#FFEDEB" />
					</view>
				</view>
			</view>
			<view class="next filsh" @click="submit">完成</view>
		</view>
	</view>
</template>

<script>
	export default {
		data() {
			return {
				userInfo: {
					age: '',
					username: '',
					sex: 1
				},
				questions: [],
				nowpage: 0,
				choosequestion: '',
				token: ''
			}
		},
		onLoad(options) {
			this.token = options.token

		},
		computed: {
			endDate() {
				return this.getDate('end');
			}
		},
		methods: {
			//获取问题数量
			getMyquestion() {
				var params = {
					token: this.token,
				}
				this.$api.user.question(params).then(res => {
					// console.log(res.pagelist)

					res.queslist.forEach((question) => {
						// console.log(pageItem)
						question.ans = question.itemlist[0]
					})
					this.questions = res.queslist
					console.log(this.questions)
				}).catch(err => {
					this.$tool.toast(err)
				})
			},
			getuserInfo() {
				if(this.userInfo.username){
					return
				}
				uni.getUserProfile({
					lang: 'zh_CN',
					desc: '方便用户资料填写',
					success: (res) => {
						// console.log(res)
						this.userInfo.username = res.userInfo.nickName,
						this.userInfo.sex = res.userInfo.gender == 1 ? 1 : 0
					},
					fail: (err) => {
						console.log(err)
					}
				})
			},
			//单选
			singerchoose(page, question, answer) {
				this.question[page].queslist[question].answer = answer
			},
			//多选
			multiselect(page, question, answer) {
				var nowanswer = this.question[page].queslist[question].answer || []
				// if(nowanswer.fin)
				var index = nowanswer.findIndex((item) => item == answer)
				if (index) {
					nowanswer.splice(index, 1)
				} else {
					nowanswer.push(index)
				}
			},
			//滑动选择
			sliderChange(e, questions) {
				questions.ans = questions.itemlist[e.value]
				console.log(this.questions)
				// console.log(e)
				// console.log(questions)
			},
			// 提交用户基本信息
			submituserInfo() {
				if (this.userInfo.age == "" || this.userInfo.username == "") {
					return this.$tool.toast('请填写个人资料')
				}
				var params = {
					token: this.token,
					name: this.userInfo.username,
					age: this.userInfo.age,
					sex: this.userInfo.sex
				}
				this.$api.user.updatauserInfo(params).then(res => {
					// console.log(res)
					this.nowpage++
				}).catch(err => {
					this.$tool.toast(err)
				})
			},
			//提交答案
			submit() {
				var jsonstr = []
				this.questions.forEach((question) => {
					var item = {
						quesid: question.id,
						ans: question.ans.itemid
					}
					jsonstr.push(item)
				})
				// console.log(jsonstr)
				var params = {
					token: this.token,
					jsonstr
				}
				this.$api.user.submitNewUserFormData(params).then(res => {
					// console.log(res)
					this.$tool.toast('提交成功')
					uni.setStorageSync('token', this.token)
					// uni.setStorageSync('isnew',0)
					setTimeout(() => {
						this.$tool.navigateBack()
						// this.$tool.switchTab('/pages/index/index')
					}, 1500)
				}).catch(err => {
					console.log(err)
					this.$tool.toast(err)
				})
			},
			//判断当前页是答案是否有空值
			check() {
				var vaild = true
				for (var i = 0; i < this.question[this.nowpage].queslist.length; i++) {
					var answer = this.question[this.nowpage].queslist[i].answer
					if (answer == '' || answer.length == 0) {
						vaild = false
					}
				}
				return vaild
			},
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
				this.userInfo.age=e.detail.value
			}
		},
		onShow() {
			this.getMyquestion()
		}
	}
</script>

<style lang="scss" scoped>
	.contant {
		padding: 40rpx 80rpx;
		box-sizing: border-box;
	}

	.firstpage {
		margin-top: 40rpx;
		font-size: 26rpx;

		.questioncontant {
			padding: 30rpx 0;
			box-sizing: border-box;
			font-size: 32rpx;
			color: #8f8f8f;

			.input {
				border-bottom: 1rpx solid #E2E2E2;
				justify-content: flex-start;
				align-items: flex-end;
				padding: 22rpx 0;
				image{
					margin-right: 22rpx;
				}
			}

			.choose {
				margin-top: 40rpx;
				// width: auto;
				display: flex;
				justify-content: space-between;
				align-items: center;
				border-radius: 46rpx;
				overflow: hidden;

				.item {
					padding: 16rpx 20rpx;
					// background-color: #c4c4c4;
					position: relative;
				}
			}
		}
	}

	.sencondwarp {
		.title {
			margin: 64rpx 0;
			font-size: 56rpx;
			font-weight: 600;
			color: #442C60;
		}

		.info {
			display: flex;
			justify-content: space-between;
			align-items: center;

			.lefttext {
				font-size: 32rpx;
				font-weight: 600;
				color: #B4ACBC;
			}

			.righttext {
				font-size: 32rpx;
				font-weight: 500;
				color: #442C60;
			}
		}
	}

	.choosed {
		transform: scale(1.1);

		text {
			font-weight: 600;
		}
	}

	.next {
		// border: #c4c4c4;
		line-height: 2.55;
		text-align: center;
		margin-top: 40rpx;
		font-size: 32rpx;
		font-weight: 600;
		border-radius: 46rpx;
		// background-color: #c4c4c4;
		background: linear-gradient(90deg, #FF599E 0%, #FF4545 100%);
		color: #FFFFFF;
		
	}

	.filsh {
		line-height: 3;
		color: #FFFFFF;
		background: linear-gradient(90.68deg, #F86E97 0.59%, #EC5454 100%);
	}
</style>

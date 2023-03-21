<template>
	<view >
		<view class="map_warp">
			<map id="navi_map" :longitude="center[0]" :latitude="center[1]" :scale="scale"
				:circles="circles" class="map" :enable-scroll="false" :enable-zoom="false" :show-location="true"></map>
		</view>
		
	</view>
</template>

<script>
	import amapFile from '../../utils/amap-wx.js' 
	import {
		mapGetters,mapActions
	} from 'vuex'
	export default {
		data() {
			return {
				way: 1, //1=>步行，2=>驾车，3=>骑行
				key: 'a892f0dca95af8f87ced4239157032ae',
				myAmapFun: null,
				polyline: [],
				center: [],
				markers: [],
				circles:[],
				// marker:[],
				scale: 14,
				distance: '',
				origin: '',
				destination: '',
				mapCtx: null,
				playIndex: 0
			}
		},
		onLoad() {
			this.myAmapFun = new amapFile.AMapWX({
				key: this.key
			});
			let that = this;
			this.mapCtx = uni.createMapContext('navi_map', this); // 创建 map 上下文 MapContext 对象
			// console.log(this.mapCtx)
		},
		onShow() {
			this.getLocation()
			// this.getDistance(this.)
		},
		computed: {
			...mapGetters(["oneBoxInfo", 'location'])
		},
		methods: {
			...mapActions(['saveBox','saveoneBoxInfo']),
			//获取当前位置
			getLocation() {
				uni.getLocation({
					altitude: true,
					type:'gcj02',
					success: (res) => {
						// console.log(res)
						this.center = [res.longitude, res.latitude]
						this.circles.push({
							longitude:res.longitude,
							latitude:res.latitude,
							color:'rgba(41,91,255,1)',
							fillColor:'rgba(41,91,255,0.16)',
							radius:3000
						})
						this.scale=11.9
						// map.setview
						// this.origin = [res.longitude, res.latitude]
						// this.destination = [this.oneBoxInfo.lnglat.lng, this.oneBoxInfo.lnglat.lat]
						// // this.distance = this.boxInfo.navigationlist.distance
						// this.markers = [{
						// 	id: 1,
						// 	longitude: this.origin[0],
						// 	latitude: this.origin[1],
						// 	width: 23,
						// 	height: 23,
						// 	iconPath: '../../static/icons/s.png'
						// }, {
						// 	id: 2,
						// 	longitude: this.destination[0],
						// 	latitude: this.destination[1],
						// 	width: 23,
						// 	height: 23,
						// 	iconPath: '../../static/icons/e.png'
						// }]
						// // this.distance = 50
						// this.distance=this.$tool.GetDistance(this.origin[1],this.origin[0],this.destination[1],this.destination[0])
						// if (this.distance < 3000) {
						// 	// console.log('步行')
						// 	this.walk()
						// } else {
						// 	// console.log('驾车')
						// 	this.driving()
						// }
						// if(this.distance<100){
							
						// 	// this.$refs.popup.close()
						// 	// this.$refs.locationpopup.open()
						// 	this.arrivedBox()
						// }else{
						// 	this.$refs.popup.open()
						// }
					},
					fail: (err) => {
						uni.authorize({
							scope: 'scope.userLocation',
							success() {
								this.getLocation()
							}
						})
					}
				})
			},
			//改变出行方式
			changeWay(type) {
				this.way = type
				if (this.way == 1) {
					this.walk()
				} else if (this.way == 2) {
					this.driving()
				} else if (this.way == 3) {
					this.cycling()
				}
			},
			//获取步行路线规划
			walk() {
				console.log('walk')
				this.myAmapFun.getWalkingRoute({
					origin: this.origin.toString(),
					destination: this.destination.toString(),
					success: (res) => {
						console.log(res)
						this.path(res, 'walk')
					},
					fail: function(info) {
						console.log(info)
					}
				})
			},
			//获取驾车路线规划
			driving() {
				this.myAmapFun.getDrivingRoute({
					origin: this.origin.toString(),
					destination: this.destination.toString(),
					success: (res) => {
						console.log(res)
						this.path(res, 'driving')
					},
					fail: function(info) {
						console.log(info)
					}
				})
			},
			//获取骑行路线规划
			cycling() {
				this.myAmapFun.getRidingRoute({
					origin: this.origin,
					destination: this.destination,
					success: (res) => {
						console.log(res)
						this.path(res, 'cycling')
					}
				})
			},
			//路线规划
			path(data, way) {
				console.log(111)
				var points = []
				if (data.paths && data.paths[0] && data.paths[0].steps) {
					var steps = data.paths[0].steps;
					for (var i = 0; i < steps.length; i++) {
						var polen = steps[i].polyline.split(';');
						for (var j = 0; j < polen.length; j++) {
							// console.log(polen[j])
							points.push({
								longitude: parseFloat(polen[j].split(',')[0]),
								latitude: parseFloat(polen[j].split(',')[1])
							})
						}
					}
				} else {
					if (way == 'walk') {
						this.walk()
					} else if (way == 'driving') {
						this.driving()
					} else if (way == 'cycling') {
						this.cycling()
					}
				}
				this.polyline = [{
					points: points,
					// color: '#26262600',
					color: '#0e8adb',
					width: 4
				}]
				this.mapCtx.includePoints({
					padding: [40, 40, 40, 40],
					points: this.circles,
				})
			},
			onUpdated() {
				this.$tool.hideLoading()
			},
			//打开导航
			openLocation() {
				if(this.distance>100){
					var _this = this
					uni.openLocation({
						name:this.oneBoxInfo.buildName,
						address: this.oneBoxInfo.address,
						latitude: _this.destination[1],
						longitude: _this.destination[0],
					});
				}else{
					this.$refs.locationpopup.open()
				}
				
			},
			//创建地图mark点平移
			translateMarker() {
				let data = this.polyline[0].points
				let len = data.length
				let datai = data[this.playIndex]
				let _this = this
				_this.mapCtx.translateMarker({
					markerId: 1,
					autoRotate: false,
					destination: {
						longitude: datai.longitude,
						latitude: datai.latitude
					},
					duration: 500,
					complete: function() {
						_this.playIndex++;
						if (_this.playIndex < len) {
							_this.translateMarker()
							_this.mapCtx.moveToLocation({
								longitude: datai.longitude,
								latitude: datai.latitude
							})
						} else {
							_this.scale = 12
							_this.mapCtx.moveToLocation({
								longitude: (datai.longitude + _this.origin[0]) / 2,
								latitude: (datai.latitude + _this.origin[1]) / 2
							})
						}
					},
					animationEnd: () => {
						// console.log('下一个')
					},
					fail: (err) => {
						console.log('fail', err)
					}
				})
			},
			// 计算两坐标点之间的距离
			getDistance: function(lat1, lng1, lat2, lng2) {
				console.log(lat1, lng1, lat2, lng2)
				var radLat1 = this.Rad(lat1);
				var radLat2 = this.Rad(lat2);
				var a = radLat1 - radLat2;
				var b = this.Rad(lng1) - this.Rad(lng2);
				var s = 2 * Math.asin(Math.sqrt(Math.pow(Math.sin(a / 2), 2) +
					Math.cos(radLat1) * Math.cos(radLat2) * Math.pow(Math.sin(b / 2), 2)));
				s = s * 6378.137; // EARTH_RADIUS;
				s = Math.round(s * 10000); //输出为公里
				//s=s.toFixed(4);
				return s;

			},
			Rad(d) {
				return d * Math.PI / 180.0; //经纬度转换成三角函数中度分表形式。
			},
			knowIt() {
				this.$refs.popup.close()
			},
			close(){
				this.$refs.locationpopup.close()
			},
			//盲盒完成
			arrivedBox(){
				var params={
					boxid:this.oneBoxInfo.boxid
				}
				var oneBoxInfo={}
				this.$api.box.arrivedBox(params).then(res=>{
					this.saveBox(oneBoxInfo)
					this.saveoneBoxInfo(oneBoxInfo)
					this.$refs.locationpopup.open()
				}).catch(err=>{
					this.$tool.toast(err)
				})
			},
			longpress(){
				// console.log('长按了')
				// this.$refs.popup.close()
				this.$refs.locationpopup.open()
			}
		},
	}
</script>

<style scoped lang="scss">
	.map_warp{
		padding-top: 400rpx;
		width: 100vw;
		height: 400rpx;
	}
	.map {
		width: 100%;
		height: 100%;
	}



</style>

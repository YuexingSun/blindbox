/* 工具类 */
// import db from './db'
import moment from "moment";

const tool = {
  /**
   * 显示toast
   * @param {String} title toast内容
   * @param {String} icon 图标,可选,默认无图标
   * @param {String} duration 显示时间(毫秒),可选,默认1500
   * @param {Boolean} mask 是否显示透明蒙层，防止触摸穿透，默认：true
   */
  toast(title="服务器错误，请稍后重试", icon = "none", duration = 1500, mask = true) {
    return uni.showToast({
      title,
      icon,
      duration,
      position: "bottom",
      mask,
    });
  },
  /**
   * 显示loading
   * @param {String} title loading内容,可选,默认"请稍候"
   * @param {Boolean} mask 是否禁止点击空白区域,默认true
   */
  showLoading(title = "加载中", mask = true) {
    return uni.showLoading({
      title,
      mask,
    });
  },
  /**
   * 关闭loading
   */
  hideLoading() {
    return uni.hideLoading();
  },
  /**
   * 隐藏 tabBar
   */
  hideTabBar() {
    uni.hideTabBar({
      // #ifdef MP-WEIXIN
      animation: true,
      // #endif
    });
  },
  /**
   * 显示 tabBar
   */
  showTabBar() {
    uni.showTabBar({
      // #ifdef MP-WEIXIN
      animation: true,
      // #endif
    });
  },
  /**
   * 页面跳转
   * @param {String} url 页面链接
   * @type {URIString}
   */
  navigateTo(url) {
    uni.showLoading({
      title: "正在跳转",
    });
    uni.navigateTo({
      url: url,
      success: (res) => {},
      fail: (err) => {
        console.log(err);
      },
      complete: () => {
        uni.hideLoading();
      },
    });
  },
  
  //
  /*
	*重定向
	* @param {string} url 重定向页面链接
	* @type {URIString}
	* 
  */
 reLaunch(url){
	 uni.reLaunch({
	 	url:url
	 })
 },
 //
  /*
 	关闭当前跳转
 	* @param {string} url 重定向页面链接
 	* @type {URIString}
 	* 
  */
 redirectTo(url){
 	 uni.redirectTo({
 	 	url:url
 	 })
 },
  /**
   * 切换tab
   * @param {String} url tab页链接
   */
  switchTab(url) {
	  console.log(url)
    uni.switchTab({
      url: url,
      success: (res) => {},
      fail: () => {
		  console.log('fali')
	  },
      complete: () => {},
    });
  },
  /**
   * 返回
   * @param {Number} delta 层级，默认1
   */
  navigateBack(delta = 1) {
    uni.navigateBack({
      delta,
    });
  },
  /**
   * 设置剪贴板
   * @param {String} content 剪贴板内容
   * @param {String} msg 提示消息, 默认:"复制成功"
   */
  copy(content, msg = "复制成功", duration = 1500) {
    uni.setClipboardData({
      data: content,
      success: () => {
        if (msg != "") {
          if (msg.length > 7) {
            this.toast(msg, "none", duration);
          } else {
            this.toast(msg, "success", duration);
          }
        }
      },
      complete: () => {
        if (msg == "") {
          uni.hideToast();
        }
      },
    });
  },
  /**
   * 预览图片，单图
   * @param {String} imgUrl 图片路径
   */
  previewImage(imgUrl) {
    uni.previewImage({
      urls: [imgUrl],
    });
  },
  /**
   * 预览图片，多图
   * @param {String} imgUrls 图片路径
   * @param {String, Number} current 当前图片，下标或者连接，非法值则显示第一张
   */
  previewImages(imgUrls, current = "") {
    uni.previewImage({
      urls: imgUrls,
      count: current,
      current: current,
    });
  },
  /**
   * 保存图片
   * @param {String} url 图片链接
   */
  saveImage(url) {
    if (url == "") {
      return;
    }
    // #ifdef MP-WEIXIN
    uni.authorize({
      scope: "scope.writePhotosAlbum",
      success: () => {
        // #endif
        this.showLoading();
        // 1. 下载图片
        uni.downloadFile({
          url: url, //仅为示例，并非真实的资源
          success: (res) => {
            if (res.statusCode === 200) {
              // console.log("res: " + JSON.stringify(res));
              uni.saveImageToPhotosAlbum({
                filePath: res.tempFilePath,
                success: () => {
                  this.hideLoading();
                  this.toast("图片保存成功", "success");
                  // 发送事件方便回调监听
                  uni.$emit(db.events.saveImg, {
                    result: "ok",
                  });
                },
                fail: (err) => {
                  // console.log("err: " + JSON.stringify(err));
                  this.hideLoading();
                  this.toast("图片保存失败");
                },
              });
            }
          },
          fail: (err) => {
            // console.log("err: " + JSON.stringify(err));
            this.hideLoading();
            this.toast("图片下载失败");
          },
        });
        // #ifdef MP-WEIXIN
      },
      fail: () => {
        this.toast("未授权，无法保存图片");
      },
    });
    // #endif
  },
  /**
   * 拨打电话
   * @param {String} phone 手机号码
   */
  call(phone) {
    uni.makePhoneCall({
      phoneNumber: phone,
    });
  },
  /**
   * 格式化时间戳
   * @param {Long} date 时间戳
   * @param {String} format 格式, 默认：YYYY-MM-DD
   */
  formatDateUtc(date, format = "YYYY-MM-DD") {
    if (date) {
      return moment(date).format(format);
    }
    return "";
  },
  /*
   *手机号码校验
   */
  phoneCheck(phone) {
    if (!phone) {
      uni.showToast({
        title: "请填写手机号码",
        icon: "none",
        duration: 1500,
        position: "bottom",
        mask: true,
      });
      return false;
    } else if (!/^1(3|4|5|6|7|8|9)\d{9}$/.test(phone)) {
      uni.showToast({
        title: "手机号码错误，请重新填写",
        icon: "none",
        duration: 1500,
        position: "bottom",
        mask: true,
      });
      return false;
    } else {
      return true;
    }
  },
  /*
   *微信小程序scene转对象
   * */
  parseScene(sceneStr) {
    const scene = {};
    if (sceneStr == "") {
      return scene;
    }
    const params = sceneStr.split("&");
    for (let index in params) {
      const param = params[index].split("=");
      scene[param[0]] = param[1];
    }
    return scene;
  },
  /*
   *数组乱序
   */
  shuffle(arr) {
    let m = arr.length;
    while (m > 1) {
      let index = Math.floor(Math.random() * m--);
      [arr[m], arr[index]] = [arr[index], arr[m]];
    }
    return arr;
  },
  /*
   *倒计时时间差
   * 结束时间
   */
  current(startTime,endTime) {
    // var endTime = moment(e).valueOf();
    // var endTime =new Date(new Date(e.replace(/-/g,'/')).getTime())
    // var startTime = new Date(new Date().getTime())
    // var startTime = moment(new Date()).valueOf();
    var currentTime = endTime - startTime;
    //console.log(endTime)
    var days = Math.floor(currentTime / (24 * 3600 * 1000)); //计算出相差天数
    var leave1 = currentTime % (24 * 3600 * 1000); //计算天数后剩余的毫秒数
    var hours = Math.floor(leave1 / (3600 * 1000)); //计算相差分钟数
    var leave2 = leave1 % (3600 * 1000); //计算小时数后剩余的毫秒数
    var minutes = Math.floor(leave2 / (60 * 1000)); //计算相差秒数
    var leave3 = leave2 % (60 * 1000); //计算分钟数后剩余的毫秒数
    var seconds = Math.round(leave3 / 1000);
    var countDownTime = {
      day: days,
      hour: hours + days * 24,
      min: minutes,
      sec: seconds,
    };
    //console.log(countDownTime)
    return countDownTime;
  },
  /*
   *相隔时间
   * 
   */
  currentday(e,e1) {
	  
    var endTime = moment(e).valueOf();
    var startTime = moment(e1).valueOf();
	if(endTime>startTime){
		 var currentTime = endTime - startTime;
	}else{
		var currentTime = startTime - endTime;
	}
	    //计算出相差天数
	    var days = Math.floor(currentTime / (24 * 3600 * 1000));
	    //计算出小时数
	    var leave1 = currentTime % (24 * 3600 * 1000); //计算天数后剩余的毫秒数
	    var hours = Math.floor(leave1 / (3600 * 1000));
	    //计算相差分钟数
	    var leave2 = leave1 % (3600 * 1000); //计算小时数后剩余的毫秒数
	    var minutes = Math.floor(leave2 / (60 * 1000));
	    //计算相差秒数
	    var leave3 = leave2 % (60 * 1000); //计算分钟数后剩余的毫秒数
	    var seconds = Math.round(leave3 / 1000);
	    var mint= days*24 + hours*60 +minutes
	    return  mint
  },
  //转时间戳
  Time(e) {
    if (e) {
      return moment(e).valueOf();
    }
    return "";
  },

  /**
   * @description: 一维数组转二维数组
   * @param {Array} arr:需要进行处理的原始一维数组
   * @param {Number} targetNums:每一个二维数组中包含几个对象
   * @return {Array} 处理后的数组
   */
  arrHandle(arr, targetNums = 2) {
    //原始数组长度
    const _length = arr.length;

    //计算需要循环次数
    const _splitNums =
      _length % targetNums === 0
        ? _length / targetNums
        : Math.ceil(_length / targetNums);

    //定义最终输出数组
    let _resArr = [];

    //循环,使用slice方法,选择数组的一部分浅拷贝到一个新数组对象,且原始数组不会被修改
    for (let i = 0; i < _splitNums; i++) {
      let _tempArr = arr.slice(i * targetNums, i * targetNums + targetNums);
      //检测数组长度,如果数组长度小于每组的元素长度,使用第一个对象补齐,目的是修复flex布局
      if (_tempArr.length < targetNums) {
        const _needNums = targetNums - _tempArr.length;
        // for(let i = 0; i < _needNums; i++){
        //   _tempArr.push(arr[0]);  //添加第一个对象
        // }
      }
      _resArr.push(_tempArr);
    }

    return _resArr;
  },

//判断用户手机系统
getSystem(){
	 var ua = navigator.userAgent.toLocaleLowerCase()
	 var u = navigator.userAgent
	 var isIOS = !!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/) // ios终端
	 var isAndroid = u.indexOf('Android') > -1 || u.indexOf('Linux') > -1 // g
	 if(isIOS){
		 return `IOS`
	 }
	 if(isAndroid){
		 return `Android`
	 }
},
//判断用户是否登录
judgeUserIsOld(){
	var token = uni.getStorageSync('token')
	var isnew = uni.getStorageSync('isnew')
	if(!token){//用户未登录
		uni.showModal({
			content:'请绑定手机号码，完善用户资料',
			confirmText:'去绑定',
			success: (res) => {
				if(res.confirm){
					uni.navigateTo({
						url:'/pages/auther/phone'
					})
				}
				
			},
			fail: () => {
				
			}
		})
		return false
	}else if(isnew===1){//判断是否新用户
		uni.showModal({
			content:'请完善用户资料',
			confirmText:'去完善',
			success: (res) => {
				if(res.confirm){
					uni.navigateTo({
						url:'/pages/index/question'
					})
				}
				
			},
			fail: () => {
				
			}
		})
		return false
	}else{
		return true
	}
	
},
 GetDistance( lat1,  lng1,  lat2,  lng2){
	 
	 var radLat1 = lat1*Math.PI / 180.0;
	     var radLat2 = lat2*Math.PI / 180.0;
	     var a = radLat1 - radLat2;
	     var  b = lng1*Math.PI / 180.0 - lng2*Math.PI / 180.0;
	     var s = 2 * Math.asin(Math.sqrt(Math.pow(Math.sin(a/2),2) +
	     Math.cos(radLat1)*Math.cos(radLat2)*Math.pow(Math.sin(b/2),2)));
	     s = s *6378.137 ;// EARTH_RADIUS;
	     s = Math.round(s * 10000) / 10;
	     return s;
}
};



export default tool;

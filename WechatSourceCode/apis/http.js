// import db from '@/utils/db'
import Request from './luch-request'
// import store from'../store/index.js'
const http = new Request()
let DEBUG = false
// 线上地址
let BASE_URL = 'https://api.sjtuanliu.com/V1'
if (process.env.NODE_ENV === 'development') {
  DEBUG = true
  // 开发环境
  // BASE_URL = 'http://192.168.50.77:8080'
}

http.setConfig((config) => {
  /* 设置全局配置 */

  // 根域名
  config.baseURL = BASE_URL
  config.header = {
    ...config.header,
    // #ifdef H5
    // 跨域请求时是否携带凭证（cookies）仅H5支持（HBuilderX 2.6.15+）
    withCredentials: true,
    // #endif
    // 'content-type': 'application/x-www-form-urlencoded'
	'content-type': 'application/json'
  }
  return config
})

/**
 * 自定义验证器，如果返回true 则进入响应拦截器的响应成功函数(resolve)，否则进入响应拦截器的响应错误函数(reject)
 * @param { Number } statusCode - 请求响应体statusCode（只读）
 * @return { Boolean } 如果为true,则 resolve, 否则 reject
 */
http.validateStatus = (statusCode) => {
  return statusCode === 200
}

/**
 * 请求之前拦截
 */
http.interceptors.request.use((config) => {
  // 可使用async await 做异步操作
  config.header = {
    ...config.header,
    // 拦截器header加参
    // 'X-TOKEN': db.get(db.keys.token,'')
	// 'AUTH': uni.getStorageSync('AUTH'),
	// 'MID':uni.getStorageSync('MID')
	"token":uni.getStorageSync("token")
  }
  // 演示custom 用处
  // if (config.custom.auth) {
  //   config.header.token = 'token'
  // }
  // uni.showLoading()
  uni.showLoading({
  	title:"正在加载"
  })
  // if (config.custom.loading) {
  //  uni.showLoading()
  // }
  /**
   /* 演示
   if (!token) { // 如果token不存在，return Promise.reject(config) 会取消本次请求
      return Promise.reject(config)
    }
   **/
  if (DEBUG) {
    // console.log("Request: " + JSON.stringify(config));
  }
  return config
}, config => {
  // 可使用async await 做异步操作
  return Promise.reject(config)
})

/**
 * 请求之后拦截器
 */
http.interceptors.response.use((response) => {
  // 请求成功, statusCode === 200
  if (DEBUG) {
    // console.log("Response: " + JSON.stringify(response.data));
  }
 uni.hideLoading()//关闭上一页面的加载动画
 // console.log(123123)
  if (response.data.code !== undefined) {
	  
    if (response.data.code == 0) {//请求成功后将数据返回
		// console.log(response)
		// if(typeof(response.data.data)'boolean'){
		// 	return response.data;
		// }
      return response.data.data;
    }
	
    if (response.data.code == 10003) {
	// console.log(response)
	uni.setStorageSync('token','')
	uni.setStorageSync('userInfo','')
	if(response.config.url!=='/Api/User/getMyDataList'){
		uni.reLaunch({
		 	url:'/pages/my/my'
		 })
	}
	 return Promise.reject(`请重新登录`)
    }
    if(response.data.code == 1){
		return Promise.reject(response.data.message)
	}else{
		return Promise.reject(response.data.message)
	}
  }

  return Promise.reject(response)
}, (response) => {
  // 请求错误做点什么, statusCode !== 200
  if (DEBUG) {
    console.error("Response: " + JSON.stringify(response));
  }
  uni.hideLoading()
  return Promise.reject(response)
})

export default http

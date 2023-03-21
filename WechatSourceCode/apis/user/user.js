import http from '../http.js'

//用户登录
export function userLogin (params){
	return http.post('/Api/System/getMiniToken',params)
}
export function updatauserInfo(params){
	return http.post('/Api/User/submitNewUserBaseData',params)
}
//获取用户画像所需要的问题
export function question (params){
	return http.post('/Api/User/getNewUserFormData',params)
}
//提交用户画像
export function submitNewUserFormData(params){
	return http.post('/Api/User/submitNewUserFormData',params)
}
//绑定手机号码
export function submitActiveByPhone(params){
	return http.post('/Api/User/submitActiveByPhone',params) 
}
//获取用户信息
export function getUserInfo(){
	return http.post('/Api/User/getMyDataList') 
}
//获取用户是否存在进行中的盒子
export function checkBeingBox(){
	return http.post('/Api/Box/checkBeingBox') 
}
//获取我的盲盒列表
export function getMyboxList(params){
	return http.post('/Api/User/getMyBoxList',params) 
}
//登出
export function logout(params){
	return http.post('/Api/User/logout',params) 
}
//获取用户个人资料
export function getUserProfile(){
	return http.post('/Api/User/getUserProfile') 
}
//更新用户个人资料
export function setUserProfile(params){
	return http.post('/Api/User/setUserProfile',params) 
}
//上传头像
export function upload(file){
	return http.upload('/Api/System/uploadFile',{
		// files:[file],
		filePath:file,
		name:'file'
	})
}
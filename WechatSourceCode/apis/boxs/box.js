import http from '../http.js'

//获取盲盒类型
export function boxsType(){
	return http.post('/Api/Box/getBoxType')
}
//获取盲盒待答问题
export function getBoxQuestion(params){
	return http.post('/Api/Box/getBoxQuesList',params)
}
//消费盲盒
export function useBox(params){
	return http.post('/Api/Box/getOne',params)
}
//盲盒启程
export function startBox(params){
	return http.post('/Api/Box/startBox',params)
}
//获取盒子详情
export function getBoxDetail(params){
	return http.post('/Api/Box/getBoxDetail',params)
}
//终止盒子行程
export function endBox(params){
	return http.post('/Api/Box/cancelBox',params)
}
//到达盲盒
export function arrivedBox(params){
	return http.post('/Api/Box/arrivedBox',params)
}
//完成盲盒
export function finishBox(params){
	return http.post('/Api/Box/finishBox',params)
}
//评价盲盒
export function enjoyBox(params){
	return http.post('/Api/Box/enjoyBox',params)
}
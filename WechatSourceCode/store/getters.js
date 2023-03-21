
const getters = {
	//盒子信息
	openBox:state=>state.box.openBox,//开盒所需要的信息
	location:state=>state.box.location,//用户定位数据
	boxInfo:state=>state.box.boxInfo,//盲盒具体信息
	userInfo:state=>state.userInfo.userInfo,//用户详细信息
	oneBoxInfo:state=>state.box.oneBoxInfo,//单一盒子信息
	UserProfile:state=>state.userInfo.UserProfile,//用户个人资料
}

export default getters
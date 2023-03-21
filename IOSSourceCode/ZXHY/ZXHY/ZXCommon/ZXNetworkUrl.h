//
//  ZXNetworkUrl.h
//  ZXHY
//
//  Created by Bern Mac on 8/5/21.
//

#ifndef ZXNetworkUrl_h
#define ZXNetworkUrl_h


#pragma mark - 主服务


#ifdef DEBUG
static NSString * const ZX_ReqMainUrl = @"https://api.sjtuanliu.com/dist/V2/"; //测试地址
//static NSString * const ZX_ReqMainUrl = @"https://api.sjtuanliu.com/dev/V2/";  //正式地址
#else
static NSString * const ZX_ReqMainUrl = @"https://api.sjtuanliu.com/dev/V2/";  //正式地址
#endif




//系统分配的密码
static NSString * const ZX_ReqAppID= @"IOS";

//系统分配的密码
static NSString * const ZX_ReqSecret= @"88888888";



#pragma mark - API
//====================公共类====================//

//获取客户端初始化信息
static NSString * const ZX_ReqApiGetInitData = @"Api/System/getInitData";

//获取通信token
static NSString * const ZX_ReqApiGetToken = @"Api/System/getToken";

//获取短信验证码
static NSString * const ZX_ReqApiGetSMSCode = @"Api/System/getSafeSMSCode";

//获取上传文件
static NSString * const ZX_ReqApiUploadFile = @"Api/System/uploadMultFile";


//====================用户====================//

//通过短信验证码 注册或者登录
static NSString * const ZX_ReqApiLoginBySMSCode = @"Api/User/loginBySMSCode";

//获取短信验证码-带安全验证
//static NSString * const ZX_ReqApiLoginBySMSCode = @"Api/System/getSafeSMSCode";

//修改手机号码
static NSString * const ZX_ReqApiResetPhoneBySMSCode = @"Api/User/resetPhoneBySMSCode";

//通过一键登录 注册或登录
static NSString * const ZX_ReqApiLoginByMob = @"Api/User/loginByMob";

//提交新用户基本信息
static NSString * const ZX_ReqApiSubmitNewUserBaseData = @"Api/User/submitNewUserBaseData";

//获取新用户表单问题
static NSString * const ZX_ReqApiGetNewUserFormData = @"Api/User/getNewUserFormData";

//提交新用户表单问题
static NSString * const ZX_ReqApiSubmitNewUserFormData = @"Api/User/submitNewUserFormData";

//获取我的信息
static NSString * const ZX_ReqApiGetMyDataList = @"Api/User/getMyDataList";

//获取用户资料信息
static NSString * const ZX_ReqApiGetUserProfile = @"Api/User/getUserProfile";

//设置用户资料信息
static NSString * const ZX_ReqApiSetUserProfile = @"Api/User/setUserProfile";

//退出登录
static NSString * const ZX_ReqApiLogout = @"Api/User/logout";


//====================首页====================//

//获取首页信息列表
static NSString * const ZX_ReqApiInfomationGetList = @"Api/Infomation/getList";

//获取首页信息流首页广告
static NSString * const ZX_ReqApiInfomationGetBannerList = @"Api/Infomation/getBannerList";

//获取首页信息流弹出广告
static NSString * const ZX_ReqApiInfomationGetPopupPic = @"Api/Infomation/getPopupPic";

//获取首页信息详情列表
static NSString * const ZX_ReqApiInfomationGetDetail = @"Api/Infomation/getDetail";

//首页信息流搜索列表
static NSString * const ZX_ReqApiInfomationGetSearchList = @"Api/Infomation/getSearchList";

//获取信息流评论列表
static NSString * const ZX_ReqApiInfomationGetCommentList = @"Api/Infomation/getCommentList";

//举报评论或回复
static NSString * const ZX_ReqApiInfomationReportComment = @"Api/Infomation/reportComment";

//写评论
static NSString * const ZX_ReqApiInfomationCreateComment = @"Api/Infomation/createComment";

//删除评论或回复
static NSString * const ZX_ReqApiInfomationDeleteComment = @"Api/Infomation/deleteComment";

//点赞/取消点赞
static NSString * const ZX_ReqApiInfomationLikeArticle= @"Api/Infomation/likeArticle";

//收藏/取消收藏
static NSString * const ZX_ReqApiInfomationFavArticle= @"Api/Infomation/favArticle";

//写笔记
static NSString * const ZX_ReqApiInfomationCreateInfo = @"Api/Infomation/createInfo";

//删除笔记
static NSString * const ZX_ReqApiInfomationDeleteInfo = @"Api/Infomation/deleteInfo";

//举报笔记
static NSString * const ZX_ReqApiInfomationReportInfo = @"Api/Infomation/reportInfo";

//收藏的文章
static NSString * const ZX_ReqApiInfomationGetMyfavList = @"Api/Infomation/getMyfavList";

//我发布的笔记
static NSString * const ZX_ReqApiInfomationGetMyInfoList = @"Api/Infomation/getMyInfoList";


//====================盲盒====================//

//获取顶部分类列表
static NSString * const ZX_ReqApiGetBoxCateTypes = @"Api/Box/getBoxCateTypes";

//查询是否有未开启和进行中的盲盒
static NSString * const ZX_ReqApiCheckBeingBox = @"Api/Box/checkBeingBox";

//获取可选盲盒类型
static NSString * const ZX_ReqApiGetBoxType = @"Api/Box/getBoxType";

//获取盲盒待答问题
static NSString * const ZX_ReqApiGetBoxQuesList = @"Api/Box/getBoxQuesList";

//获取盲盒
static NSString * const ZX_ReqApiGetBox = @"Api/Box/getOne";

//盲盒启程
static NSString * const ZX_ReqApiStartBox = @"Api/Box/startBox";

//盲盒到达
static NSString * const ZX_ReqApiArrivedBox = @"Api/Box/arrivedBox";

//盲盒到达后评价
static NSString * const ZX_ReqApiFinishBox = @"Api/Box/finishBox";

//获取盲盒详情
static NSString * const ZX_ReqApiGetBoxDetail = @"Api/Box/getBoxDetail";

//中止盲盒
static NSString * const ZX_ReqApiCancelBox = @"Api/Box/cancelBox";

//我的盲盒列表
static NSString * const ZX_ReqApiGetMyBoxList = @"Api/User/getMyBoxList";

//评价盲盒
static NSString * const ZX_ReqApiEnjoyBox = @"Api/Box/enjoyBox";





//====================个人信息====================//



#endif /* ZXNetworkUrl_h */

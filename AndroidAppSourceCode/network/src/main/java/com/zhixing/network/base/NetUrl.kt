package com.zhixing.network.base

import rxhttp.wrapper.annotation.DefaultDomain

object NetUrl {

    //正式环境
//    const val BASE_URL = "https://api.sjtuanliu.com/dev/V2/"
    //Rxhttp的默认域名 正式环境
//    @DefaultDomain
//    const val RXHTTP_BASE_URL = "https://api.sjtuanliu.com/dev/V2/"

    //测试环境
    const val BASE_URL = "https://api.sjtuanliu.com/dist/V2/"
    //Rxhttp的默认域名 测试环境
    @DefaultDomain
    const val RXHTTP_BASE_URL = "https://api.sjtuanliu.com/dist/V2/"



    //获取可选盲盒类型
    const val GET_BOX_TYPE = "Api/Box/getBoxType"

    //注册/登录 - 通过一键登录完成
    const val LOGIN_BY_MOB = "Api/User/loginByMob"

    //获取短信验证码-带安全验证
    const val GET_SAFE_SMSCODE = "Api/System/getSafeSMSCode"

    //注册/登录-通过短信验证码
    const val LOGIN_BY_SMS_CODE = "Api/User/loginBySMSCode"

    //提交新用户基本信息一
    const val SUBMIT_BASE_DATA_ONE = "Api/User/submitNewUserBaseData"

    //获取新用户表单问题
    const val GET_NEW_USER_FROM_DATA = "Api/User/getNewUserFormData"

    //提交新用户基本信息二
    const val SUBMIT_BASE_DATA_TWO = "Api/User/submitNewUserFormData"

    //获取我的信息
    const val User_GET_MY_DATA_LIST = "Api/User/getMyDataList"

    //获取用户资料信息
    const val GET_USER_PROFILE = "Api/User/getUserProfile"

    //设置用户资料信息
    const val SET_USER_PROFILE = "Api/User/setUserProfile"

    //修改用户手机号
    const val RESET_PHONE_BY_SMS_CODE = "Api/User/resetPhoneBySMSCode"

    //退出登录
    const val USER_LOGOUT = "Api/User/logout"

    //获取用户标签信息
    const val GET_USER_TAG_LIST = "Api/User/getUserTagList"

    //设置用户标签信息
    const val SET_USER_TAG_LIST = "Api/User/setUserTagList"

    //上传文件
    const val UPLOAD_FILE = "Api/System/uploadFile"

    //上传多个文件
    const val UPLOAD_MULT_FILE = "Api/System/uploadMultFile"

    //获取我的盲盒列表
    const val GET_MY_BOX_LIST = "Api/User/getMyBoxList"

    //获取盲盒详情
    const val GET_BOX_DETAIL = "Api/Box/getBoxDetail"

    //评价盲盒
    const val BOX_ENJOYBOX = "Api/Box/enjoyBox"

    //查询是否有赠送道具
    const val CHECK_TODAY_GROCERY = "Api/User/checkTodayGrocery"

    //获取盲盒待答问题
    const val GET_BOX_QUES_LIST = "Api/Box/getBoxQuesList"

    //获取盲盒
    const val BOX_GET_ONE = "Api/Box/getOne"

    //中止盲盒
    const val BOX_CANCEL_BOX = "Api/Box/cancelBox"

    //查询是否有进行中的盲盒
    const val BOX_CHECK_BEING_BOX = "Api/Box/checkBeingBox"

    //开始一个盲盒
    const val START_BOX = "Api/Box/startBox"

    //盲盒到达
    const val ARRIVED_BOX = "Api/Box/arrivedBox"

    //隐私协议
    const val GET_PIVACY_POLICY = "Api/System/getPivacyPolicy"

    //获取客户端初始化信息
    const val GET_INIT_DATA = "Api/System/getInitData"

    //获取首页信息流弹出广告(大霸屏)
    const val INFORMATION_GET_POPUPPIC = "Api/Infomation/getPopupPic"

    //获取首页信息流弹出广告(顶部广告)
    const val INFORMATION_GET_BANNERLIST = "Api/Infomation/getBannerList"

    //首页信息流列表
    const val INFORMATION_GET_List = "Api/Infomation/getList"

    //获取首页信息流详情
    const val INFORMATION_GET_DETAIL = "Api/Infomation/getDetail"

    //获取信息流评论详情
    const val INFORMATION_GET_COMMENT_LIST = "Api/Infomation/getCommentList"

    //评论
    const val INFORMATION_CREATE_COMMENT = "Api/Infomation/createComment"

    //我收藏的文章
    const val INFORMATION_MY_FAVLIST = "Api/Infomation/getMyfavList"

    //收藏 / 取消收藏文章
    const val INFORMATION_FAV_ARTICLE = "Api/Infomation/favArticle"

    //点赞 / 取消点赞
    const val INFORMATION_LIKE_ARTICLE = "Api/Infomation/likeArticle"

    //删除评论/回复
    const val INFORMATION_DELETE_COMMENT = "Api/Infomation/deleteComment"

    //举报评论/回复
    const val INFORMATION_REPORT_COMMENT = "Api/Infomation/reportComment"

    //举报笔记
    const val INFORMATION_REPORT_INFO = "Api/Infomation/reportInfo"

    //信息流搜索列表
    const val INFORMATION_SEARCH_LIST = "Api/Infomation/getSearchList"

    //我发布的笔记
    const val INFORMATION_MYINFO_LIST = "Api/Infomation/getMyInfoList"

    //写笔记
    const val INFORMATION_CREATE_INFO = "Api/Infomation/createInfo"

    //删除笔记
    const val INFORMATION_DELETE_INFO = "Api/Infomation/deleteInfo"

    //获取可选分类
    const val BOX_CATE_TYPES = "Api/Box/getBoxCateTypes"

}
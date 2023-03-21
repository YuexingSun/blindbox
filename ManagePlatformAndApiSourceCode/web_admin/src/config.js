/**

 @Name：全局配置
 @Author：贤心
 @Site：http://www.layui.com/admin/
 @License：LPPL（layui付费产品协议）
    
 */
  function getWeekName(i){
    switch(i){
      case 1:
        return "周一";
      case 2:
        return "周二";
      case 3:
        return "周三";
      case 4:
        return "周四";
      case 5:
        return "周五";
      case 6:
        return "周六";
      case 7:
        return "周日";
    }
    return "";
  }
 
 
layui.define(['laytpl', 'layer', 'element', 'util'], function(exports){
  exports('setter', {
    container: 'LAY_app' //容器ID
    ,base: layui.cache.base //记录layuiAdmin文件夹所在路径
    ,views: layui.cache.base + 'views/' //视图所在目录
    ,entry: 'index' //默认视图文件名
    ,engine: '.html' //视图文件后缀名
    ,pageTabs: false //是否开启页面选项卡功能。单页版不推荐开启
    
    ,name: '知行盒一后台管理系统'
    ,tableName: 'layuiAdmin' //本地存储表名
    ,MOD_NAME: 'admin' //模块事件名
    
    ,debug: false //是否开启调试模式。如开启，接口异常时会抛出异常 URL 等信息
    
    ,interceptor: true //是否开启未登入拦截
    
    //自定义请求字段
    ,request: {
      tokenName: 'LoginToken' //自动携带 token 的字段名。可设置 false 不携带。
    }
    
    //自定义响应字段
    ,response: {
      statusName: 'errorcode' //数据状态的字段名称
      ,statusCode: {
        ok: 0 //数据状态一切正常的状态码
        ,logout: 10002 //登录状态失效的状态码
      }
      ,msgName: 'errormsg' //状态信息的字段名称
      ,dataName: 'data' //数据详情的字段名称
    }
    
    //独立页面路由，可随意添加（无需写参数）
    ,indPage: [
      '/user/login' //登入页
      ,'/user/reg' //注册页
      ,'/user/forget' //找回密码
      ,'/template/tips/test' //独立页的一个测试 demo
    ]
    
    //扩展的第三方模块
    ,extend: [
      'echarts', //echarts 核心包
      'echartsTheme', //echarts 主题
      'citypicker',
    ]
    
    //数据接口定义
    ,ApiUrl: {
      HostAddress : 'https://admin.sjtuanliu.com/api/',
      uploadFile :'Api/Admin/uploadFile', //上传文件
      uploadCKFile :'Api/Admin/uploadCKFile', //上传文件
      login : 'Api/Admin/login', //登录
      getMemuList : 'Api/Admin/getMemuList', //获取菜单
      getMineName : 'Api/Admin/getMineName', //个人资料
      getAdminUser2List : 'Api/Admin/getAdminUser2List', //获取管理人员管理列表
      removeUserGone : 'Api/Admin/removeUserGone', //管理人员停用删除
      submitNewUser2Data : 'Api/Admin/submitNewUser2Data', //新建后台管理人员
      getAllLogList : 'Api/Admin/getAllLogList', //日志数据
      setPassword : 'Api/Admin/setPassword', //修改密码
      logout : 'Api/Admin/logout', //退出

      getDictList : 'Api/Admin/getDictList', //获取字典数据列表，无权限验证，根据输入参数，输入对应字典

      TagDimen : 'Api/Admin/TagDimen', //B端标签维度
      TagList : 'Api/Admin/TagList', //B端标签列表
      RelationTagType : 'Api/Admin/RelationTagType', //B端标签与维度关系
      TagClientDimen : 'Api/Admin/TagClientDimen', //C端标签维度
      TagClientList : 'Api/Admin/TagClientList', //C端标签列表
      RelationTagTypeClient : 'Api/Admin/RelationTagTypeClient', //C端标签与维度关系
      TagSameTagClient : 'Api/Admin/TagSameTagClient', //设置标签相似度
      Destination : 'Api/Admin/Destination', //目的地管理
      DestinationImport : 'Api/Admin/DestinationImport', //批量导入目的地
      DestinationImportFile2 : 'Api/Admin/DestinationImportFile2', //批量导入目的地
      DestinationMain : 'Api/Admin/DestinationMain', //目的地主类别
      DestinationFirst : 'Api/Admin/DestinationFirst', //目的地分类管理
      RegQuestion : 'Api/Admin/RegQuestion', //用户注册的问答
      TradingCircle : 'Api/Admin/TradingCircle', //商圈管理
      TradingCircleImport : 'Api/Admin/TradingCircleImport', //批量导入商圈
      WebUser : 'Api/Admin/WebUser', //用户管理
      DestinationProduct : 'Api/Admin/DestinationProduct', //方案产品
      WebUserBox : 'Api/Admin/WebUserBox', //用户管理
      StatisticData : 'Api/Admin/StatisticData', //数据统计
      ConfigSetData : 'Api/Admin/ConfigSetData', //配置项
      Article : 'Api/Admin/Article', //文章管理
      Words : 'Api/Admin/Words', //文章管理
      CateColor : 'Api/Admin/CateColor', //分类颜色管理
      ArticleImport : 'Api/Admin/ArticleImport', //批量导入文章
      Report : 'Api/Admin/Report', //举报文章
      ShopAccount : 'Api/Admin/ShopAccount', //商户账号管理
      Banner : 'Api/Admin/Banner', //广告图
      Activity : 'Api/Admin/Activity', //抽奖
      ActivityGot : 'Api/Admin/ActivityGot', //抽奖中奖




    }

    //主题配置
    ,theme: {
      //内置主题配色方案
      color: [{
        main: '#20222A' //主题色
        ,selected: '#009688' //选中色
        ,alias: 'default' //默认别名
      },{
        main: '#03152A'
        ,selected: '#3B91FF'
        ,alias: 'dark-blue' //藏蓝
      },{
        main: '#2E241B'
        ,selected: '#A48566'
        ,alias: 'coffee' //咖啡
      },{
        main: '#50314F'
        ,selected: '#7A4D7B'
        ,alias: 'purple-red' //紫红
      },{
        main: '#344058'
        ,logo: '#1E9FFF'
        ,selected: '#1E9FFF'
        ,alias: 'ocean' //海洋
      },{
        main: '#3A3D49'
        ,logo: '#2F9688'
        ,selected: '#5FB878'
        ,alias: 'green' //墨绿
      },{
        main: '#20222A'
        ,logo: '#F78400'
        ,selected: '#F78400'
        ,alias: 'red' //橙色
      },{
        main: '#28333E'
        ,logo: '#AA3130'
        ,selected: '#AA3130'
        ,alias: 'fashion-red' //时尚红
      },{
        main: '#24262F'
        ,logo: '#3A3D49'
        ,selected: '#009688'
        ,alias: 'classic-black' //经典黑
      },{
        logo: '#226A62'
        ,header: '#2F9688'
        ,alias: 'green-header' //墨绿头
      },{
        main: '#344058'
        ,logo: '#0085E8'
        ,selected: '#1E9FFF'
        ,header: '#1E9FFF'
        ,alias: 'ocean-header' //海洋头
      },{
        header: '#393D49'
        ,alias: 'classic-black-header' //经典黑
      },{
        main: '#50314F'
        ,logo: '#50314F'
        ,selected: '#7A4D7B'
        ,header: '#50314F'
        ,alias: 'purple-red-header' //紫红头
      },{
        main: '#28333E'
        ,logo: '#28333E'
        ,selected: '#AA3130'
        ,header: '#AA3130'
        ,alias: 'fashion-red-header' //时尚红头
      },{
        main: '#28333E'
        ,logo: '#009688'
        ,selected: '#009688'
        ,header: '#009688'
        ,alias: 'green-header' //墨绿头
      }]
      
      //初始的颜色索引，对应上面的配色方案数组索引
      //如果本地已经有主题色记录，则以本地记录为优先，除非请求本地数据（localStorage）
      ,initColorIndex: 0
      
    }
  });
});

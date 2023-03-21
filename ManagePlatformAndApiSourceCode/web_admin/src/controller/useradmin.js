/**

 @Name：layuiAdmin 用户管理 管理员管理 角色管理
 @Author：star1029
 @Site：http://www.layui.com/admin/
 @License：LPPL
    
 */


layui.define(['table', 'form'], function(exports){
  var $ = layui.$
  ,admin = layui.admin
  ,view = layui.view
  ,table = layui.table
  ,form = layui.form;

  var local = layui.data(layui.setter.tableName);
  //console.log(layui.setter.request.tokenName);
  //var headername = layui.setter.request.tokenName;
  var headervalue = local[layui.setter.request.tokenName];
  table.set({
    headers:{
      LoginToken : headervalue,
      //[layui.setter.request.tokenName]:local[layui.setter.request.tokenName],
    },
  })



  //日志管理
  table.render({
    elem: '#LAY-adminlog-back-manage'
    ,url : layui.setter.ApiUrl.HostAddress + layui.setter.ApiUrl.getAllLogList   
    ,method : 'post'
    ,cols: [[
      //{type: 'checkbox', fixed: 'left'}
      {field: 'id', width: 80, title: 'ID'}
      ,{field: 'uname', title: '操作人员'}
      ,{field: 'action', title: '行为'}
      ,{field: 'optdesc', title: '详细说明'}
      ,{field: 'intabletime', title: '时间'}
      ,{title: '操作', width: 100, align: 'center', toolbar: '#table-adminlog-admin'}
    ]]
    ,toolbar: true
    ,defaultToolbar: ['filter', 'print', 'exports',{
        title: '下载全部日志' //标题
        ,layEvent: 'dowalllog' //事件名，用于 toolbar 事件中使用
        ,icon: 'layui-icon-download-circle' //图标类名
      } 
    ]
    ,page: true
    ,limits:[10,30,50,100,200,500]
    ,limit: 30
    ,text: {none:'暂无数据'}
    ,done: function(res, curr, count){
      if (res.errorcode != 0)
      {
        layer.msg(res.errormsg, {icon: 5});
      }
    }
  });

  //日志管理
  var logexportdata = [];
  var logtable = table.render({
    elem: '#LAY-adminlog-back-download'
    ,url : layui.setter.ApiUrl.HostAddress + layui.setter.ApiUrl.getAllLogList   
    ,method : 'post'
    ,where:{limit:9999999}
    ,cols: [[
      {field: 'id', width: 80, title: 'ID'}
      ,{field: 'uname', title: '操作人员'}
      ,{field: 'action', title: '行为'}
      ,{field: 'optdesc', title: '详细说明'}
      ,{field: 'intabletime', title: '时间'}
      ,{field: 'logdata', title: '操作数据'}
    ]]
    ,done: function(res, curr, count){
      logexportdata = res.data;
    }
  });  

  //监听工具条
  table.on('tool(LAY-adminlog-back-manage)', function(obj){
    var data = obj.data;
    if(obj.event === 'detail'){
      layer.alert(data.logdata);
    }
  });

  table.on('toolbar(LAY-adminlog-back-manage)', function(obj){
    if (obj.event == "dowalllog")
    {
      layui.table.exportFile(logtable.config.id,logexportdata,'xls');
    }
  });


  exports('useradmin', {})
});
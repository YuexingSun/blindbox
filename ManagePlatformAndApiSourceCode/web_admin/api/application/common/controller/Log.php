<?php 
namespace app\common\controller; 
use think\Db;
use think\Request;

class Log
{
	public $table = "log";
	
	public function add_log( $uid, $action, $optdesc, $logdata ){ 

		$param['uid'] = $uid;
		$param['action'] = $action;
		$param['optdesc'] = $optdesc;
		$param['logdata'] = $logdata;
		$param['intabletime'] = date("Y-m-d H:i:s");

		/*
		$request = Request::instance();  
		if(!$param['module']) $param['module'] = $request->module(); 
		if(!$param['action']) $param['action'] = $request->controller() . '/' .$request->action();
		$param['addtime'] = date('Y-m-d H:i:s');
		$param['action_msg'] = "$action_msg";
		$param['pid'] = "$pid"; 
		if(is_array($resule))
			$param['resule'] = json_encode($resule, JSON_UNESCAPED_UNICODE);  
		
		if( $param_push['uid'] ){
			$param['uid'] = $param_push['uid'];
			$param['clienttype'] = $param_push['clienttype'];
			if( 'admin' == strtolower($param['clienttype'])  ){
				$u_rows =  TB( "user", "user_id='$param[uid]'" );
				$param['user_name'] = $u_rows['user_name']. "（" .$u_rows['real_name']. "）";
				$param['company_id'] = $u_rows['company_id'];
			}else{
				$param['user_name'] = TB("web_user", "id='$param[uid]'", "nickname"); 
			}
		}*/
			
		$model = Db::name($this->table);   
		$id = $model->insertGetId($param);  
		return $id;
	}
	
}
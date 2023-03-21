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

		$model = Db::name($this->table);   
		$id = $model->insertGetId($param);  
		return $id;
	}
	
}
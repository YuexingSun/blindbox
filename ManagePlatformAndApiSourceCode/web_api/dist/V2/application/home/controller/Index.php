<?php
namespace app\home\controller;

use think\Db;

class Index
{
    public function create()
    { 
		
		echo 2222;
    }
	
	public function test(){ 
		$user_list = Db::name("user")->select(); 
		$db = Db::name("log");
		//$lastid = $db->insertGetId( array("uid"=>33) );
		//print_r( $db->getConfig() );
		 
		//$lastid = $db->getLastInsID();
		print_r($user_list); 
	}
}

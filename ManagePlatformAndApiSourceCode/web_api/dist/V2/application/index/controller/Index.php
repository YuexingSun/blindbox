<?php
namespace app\index\controller;

use think\Db;
use app\wechat\controller\Weiapi;

class Index
{
    public function index()
    { 
    	echo "hello";
		//header("location:".config("APP_DOMAIN_URL")."weixin");
    }
	
	public function test(){ 
	}
}

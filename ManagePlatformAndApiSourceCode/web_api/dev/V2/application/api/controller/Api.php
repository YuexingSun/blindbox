<?php
namespace app\api\controller;

use think\Db;
use think\Request;
use think\Controller; 
use think\cache\driver\Redis;
use app\common\controller\Common; 
use app\common\controller\JiGuang;

class Api extends Controller
{

	protected function _initialize()
    {
		
	}

	private function characet($data){
		if( !empty($data) ){
			$fileType = mb_detect_encoding($data , array('UTF-8','GBK','LATIN1','BIG5')) ;
			if( $fileType != 'UTF-8'){
			  $data = mb_convert_encoding($data ,'utf-8' , $fileType);
			}
		}
	  	return $data;
	}



	private function httpPost($url,$indata,$header) {
		$curl = curl_init();

		if ($header)
		{
			curl_setopt($curl, CURLOPT_HTTPHEADER, $header);
		}

		curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
		curl_setopt($curl, CURLOPT_POST, true);  
		curl_setopt($curl, CURLOPT_TIMEOUT, 10);
		curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
		curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, false);
		curl_setopt($curl, CURLOPT_URL, $url);
		curl_setopt($curl,CURLOPT_POSTFIELDS,$indata); 

		$res = curl_exec($curl);
		curl_close($curl);

		return $res;
	}


	private function httpGet($url) {
		$curl = curl_init();

		var_dump($curl);
		curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
		curl_setopt($curl, CURLOPT_TIMEOUT, 500);
		curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
		curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, false);
		curl_setopt($curl, CURLOPT_URL, $url);

		$res = curl_exec($curl);
		curl_close($curl);

		return $res;
	}

	private function cal_sign($app_secret, $req_param){
	    // 排序所有请求参数
	    ksort($req_param);
	    $src_value = "";
	    // 按照key1value1key2value2...keynvaluen拼接
	    foreach ($req_param as $key=>$value){
	        $src_value.=($key.$value);
	    }
	    //计算md5
	    return md5($app_secret.$src_value.$app_secret);
	}	


	public function xxs(){

		$appkey = "100xxxx";
		$app_secret = "4e0d1bxxxxxx";

		header("content-type:text/html; charset=utf-8");


		$param = array("app_key"=>$appkey,"deviceId"=>"123456","openshopid"=>"AQhjFxxxxxx","timestamp"=>"2021-08-06 17:13:00","format"=>"json","v"=>"1","sign_method"=>"MD5","session"=>"c1fc1773a2xxxxxxd");

		$sign = self::cal_sign($app_secret,$param);

		$str = "";
	    // 按照key1value1key2value2...keynvaluen拼接
	    foreach ($param as $key=>$value){
	        $str .= "&".$key."=".$value;
	    }

		$url = "https://openapi.dianping.com/router/poiinfo/detailinfo?sign=".$sign.$str;


		echo $url;
	}



}

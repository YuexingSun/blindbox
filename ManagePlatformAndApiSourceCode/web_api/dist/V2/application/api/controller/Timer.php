<?php
namespace app\api\controller;

use think\Db;
use think\Request;
use think\Controller; 
use think\cache\driver\Redis;
use app\common\controller\Common; 
use app\common\controller\JiGuang;

class Timer extends Controller
{
	protected function _initialize()
    {
		
	}


	private function httpPost($url,$indata) {
		$curl = curl_init();
		curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
		curl_setopt($curl, CURLOPT_POST, true);  
		curl_setopt($curl, CURLOPT_TIMEOUT, 500);
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
		curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
		curl_setopt($curl, CURLOPT_TIMEOUT, 500);
		curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
		curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, false);
		curl_setopt($curl, CURLOPT_URL, $url);

		$res = curl_exec($curl);
		curl_close($curl);

		return $res;
	}


	//获取可选盲盒类型
	public function checkBoxInStatus()
	{
		$list = Db::name('box_list')->where("status",0)->where("expiretime <'".date("Y-m-d H:i:s")."'")->select();
		foreach ($list as $key => $value) 
		{
			Db::name('box_list')->where("id",$value['id'])->update(array("status"=>4));
		}

        echo "ok";
        die();

	}

	//获取可选盲盒类型
	public function checkWetherData()
	{

		$list2 = db::name("city")->where("code<>''")->select();
		foreach ($list2 as $key => $value) 
		{
			$url = "https://devapi.qweather.com/v7/weather/now?location=".$value['code']."&key=a1aee2673a0xxxxxxa&gzip=n";

			$obj = self::httpGet($url);
			$json = json_decode($obj,true);
			$input = array();
			$input['wether'] = $json['now']['text'];
			$input['temp1'] = $json['now']['temp'];
			$input['lasttime'] = $json['updateTime'];
			db::name("city")->where("id",$value['id'])->update($input);
		}

        echo "ok";
        die();

	}



}

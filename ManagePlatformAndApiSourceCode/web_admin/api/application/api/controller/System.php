<?php
namespace app\api\controller;

use think\Db;
use think\Request;
use app\common\controller\Common; 

class System 
{
	
	protected function _initialize()
    {
		
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

	public function checkParam($arrayin)
	{
		$out = array();
		foreach ($arrayin as $name) 
		{
			$val = Request::instance()->request($name); 
			if ($val == "")
			{
	        	ajax_decode(array("errorcode" => 10001,"code" => 10001,"msg" => $name." is required."));
		        die();
			}
			else
			{
				$out[$name] = $val;
			}
		}
		return $out;
	}

	public function getMoreParam($arrayin)
	{
		$out = array();
		foreach ($arrayin as $name) 
		{
			$val = Request::instance()->request($name); 
			$out[$name] = $val;
		}
		return $out;
	}

	public function checkPutParam($arrayin)
	{
		$out = array();
		foreach ($arrayin as $name) 
		{
			$val = input("put.".$name); 
			if ($val == "")
			{
	        	ajax_decode(array("errorcode" => 10001,"code" => 10001,"msg" => $name." is required."));
		        die();
			}
			else
			{
				$out[$name] = $val;
			}
		}
		return $out;
	}

	public function getMorePutParam($arrayin)
	{
		$out = array();
		foreach ($arrayin as $name) 
		{
			$val = input("put.".$name); 
			$out[$name] = $val;
		}
		return $out;
	}

	//检查token是否有效
	public function checkToken($powerid = "")
	{
		$tokenin = Request::instance()->request('LoginToken'); 
	    if ($tokenin == "")
	    {
			$tokenin = Request::instance()->request('token'); 
		    if ($tokenin == "")
		    {
		    	$tokenin = $_SERVER['HTTP_LOGINTOKEN'];
		    }
	    }
	    if ($tokenin == "")
	    {	    	
	        ajax_decode(array("errorcode" => 10002,"errormsg"=>"" , "data" => array()));
	        die();
	    }

	    $info = Db::name('web_token')->where('token',$tokenin)->where("expirestime > ".time())->find();
	    if (!$info['id'])
        {
	        ajax_decode(array("errorcode" => 10002,"errormsg"=>"" , "data" => array()));
	        die();
        }

	    return $info;
	}

	 
}

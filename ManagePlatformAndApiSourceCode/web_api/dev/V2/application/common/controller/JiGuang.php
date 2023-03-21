<?php 
/*
* 微信配置
*/  
namespace app\common\Controller; 

use think\Db;
use app\common\controller\Log;
use app\common\controller\Common;
use think\Request;

class JiGuang extends Common 
{ 

	public $appkey = "d097636bbxxxx";
	public $secret = "c2485axxxxxx";
	public $prikey = 'xxxxxxxxxx
gspfZ26S4oj3zQ==';

	public function _initialize(){
		$this->RQ = Request::instance();    
		$this->reset_param();
	}  
	
	public function httpGet($url) {
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

	public function httpPost($url,$indata) {
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
	
	public function httpPostJson($url,$indata,$header) {
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


	public function jiguangPostJson($url,$indata) {
		$curl = curl_init();

		$base64_auth_string = base64_encode($this->appkey.":".$this->secret);
		$header = array(
			'Content-Type: application/json',
			'Content-Length: ' . strlen($indata),
			'Authorization: Basic '.$base64_auth_string
		);

		curl_setopt($curl, CURLOPT_HTTPHEADER, $header);
		curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
		curl_setopt($curl, CURLOPT_POST, true);  
		curl_setopt($curl, CURLOPT_TIMEOUT, 10);
		curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
		curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, false);
		curl_setopt($curl, CURLOPT_URL, $url);
		curl_setopt($curl,CURLOPT_POSTFIELDS,$indata); 

		$res = curl_exec($curl);
		curl_close($curl);

		add_log(0, 'jiguangPostJson', '', json_encode(array("in"=>$indata,"out"=>$res),JSON_UNESCAPED_UNICODE));


		return $res;
	}


	//获取短信验证码
	public function sendSMSCode($phone)
	{
		$url = "https://api.sms.jpush.cn/v1/codes";

		$data = array("mobile"=>$phone,"temp_id"=>1);
		$indata = json_encode($data,JSON_UNESCAPED_UNICODE);

		$obj = self::jiguangPostJson($url,$indata);
		$res = json_decode($obj,true);

		if (($res['error']['code'])||(!$res['msg_id']))
		{
	        ajax_decode(array("code" => 10025,"msg"=>$res['error']['code']."|".$res['error']['message'] , "data" => array()));
	        die();
		}

		return $res;

	}


	//验证码验证 API
	public function checkSMSCode($msgid,$code)
	{
		$url = "https://api.sms.jpush.cn/v1/codes/".$msgid."/valid";

		$data = array("code"=>$code);
		$indata = json_encode($data,JSON_UNESCAPED_UNICODE);

		$obj = self::jiguangPostJson($url,$indata);
		$res = json_decode($obj,true);

		if (!$res['is_valid'])
		{
	        ajax_decode(array("code" => 10026,"msg"=>$res['error']['code']."|".$res['error']['message'] , "data" => array()));
	        die();
		}

		return $res;

	}
	

	//loginTokenVerify API
	public function loginTokenVerify($code)
	{
		$url = "https://api.verification.jpush.cn/v1/web/loginTokenVerify";

		$data = array("loginToken"=>$code);
		$indata = json_encode($data,JSON_UNESCAPED_UNICODE);

		$obj = self::jiguangPostJson($url,$indata);
		$res = json_decode($obj,true);

		add_log(0, 'loginTokenVerify', '', json_encode(array("in"=>$data,"out"=>$obj),JSON_UNESCAPED_UNICODE));

		if ($res['code'] != "8000")
		{
	        ajax_decode(array("code" => 10027,"msg"=>$res['code']."|".$res['content'] , "data" => array()));
	        die();
		}

		$prefix = '-----BEGIN RSA PRIVATE KEY-----';
		$suffix = '-----END RSA PRIVATE KEY-----';
		$result = '';

		$encrypted = $res['phone'];

		$key = $prefix . "\n" . $this->prikey . "\n" . $suffix;
		$r = openssl_private_decrypt(base64_decode($encrypted), $result, openssl_pkey_get_private($key));

		return $result;

	}


	//loginTokenVerify API
	public function loginTokenVerifyTest($code)
	{

		$prefix = '-----BEGIN RSA PRIVATE KEY-----';
		$suffix = '-----END RSA PRIVATE KEY-----';
		$result = '';

		$encrypted = "aKNxxxxxxrfA=";

		$key = $prefix . "\n" . $this->prikey . "\n" . $suffix;
		$r = openssl_private_decrypt(base64_decode($encrypted), $result, openssl_pkey_get_private($key));

		return $result;

	}



	//Verify API
	public function verifyCode($phone,$code)
	{
		$url = "https://api.verification.jpush.cn/v1/web/verify";

		$data = array("token"=>$code,"phone"=>$phone);
		$indata = json_encode($data,JSON_UNESCAPED_UNICODE);

		$obj = self::jiguangPostJson($url,$indata);
		$res = json_decode($obj,true);

		if ($res['code'] != "9000")
		{
	        ajax_decode(array("code" => 10028,"msg"=>$res['code']."|".$res['content'] , "data" => array()));
	        die();
		}

		return true;

	}

	
}
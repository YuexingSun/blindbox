<?php
namespace app\api\controller;
require_once 'vendor/aliyun-oss-php-sdk/autoload.php';
use OSS\OssClient;
use OSS\Core\OssException;

use think\Db;
use think\Request;
use think\cache\driver\Redis;
use app\common\controller\Common; 
use app\common\controller\JiGuang;
use app\wechat\controller\WeiMiniapi;
use app\common\controller\Tencent;

class System 
{
	
	private $TokenTime = 604800;

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

	public function ext_json_decode($str, $mode=false){

	  $obj = json_decode($str, $mode);
	  if (!$obj)
	  {
		  if(preg_match('/\w:/', $str)){
		    $str = preg_replace('/(\w+):/is', '"$1":', $str);
		  }
	  }
	  return json_decode($str, $mode);
	}

	public function checkParam($arrayin)
	{
		$json = file_get_contents('php://input'); 
		$data = self::ext_json_decode($json,true);

		$out = array();
		foreach ($arrayin as $name) 
		{
			//$val = Request::instance()->request($name); 
			$val = $data[$name]; 
			if (($val === "")||($val === NULL))
			{
	        	ajax_decode(array("code" => 10001,"msg" => $name." is required."));
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
		$json = file_get_contents('php://input'); 
		$data = self::ext_json_decode($json, true);

		$out = array();
		foreach ($arrayin as $name) 
		{
			//$val = Request::instance()->request($name); 
			$val = $data[$name]; 
			$out[$name] = $val;
		}
		return $out;
	}

	//检查token是否有效
	public function checkToken()
	{
		$json = file_get_contents('php://input'); 
		$data = self::ext_json_decode($json, true);
		//$tokenin = Request::instance()->request('token'); 
		$tokenin = $data['token'];

		//用于直接传入token的用户ID，调试用
		if($data['tokenid'])
		{
			return $data['tokenid'];
		}

	    if ($tokenin == "")
	    {
			$tokenin = Request::instance()->request('token'); 
		    if ($tokenin == "")
		    {
		    	$tokenin = $_SERVER['HTTP_TOKEN'];
		    }
	    }
	    if ($tokenin == "")
	    {	    	
	        ajax_decode(array("code" => 10003,"msg"=>"" , "data" => array()));
	        die();
	    }

        $Redis = new Redis();
        if (!$Redis->has($tokenin))
        {
	        ajax_decode(array("code" => 10003,"msg"=>"" , "data" => array()));
	        die();
        }

        $tokeninfo = $Redis->get($tokenin);
        //刷新有效时间
        $Redis->set($tokenin,$tokeninfo,$this->TokenTime);

        //$tokeninfo = json_decode($tokeninfo,true);

	    return $tokeninfo;
	}

	//清除redis
	public function clearToken()
	{
		$json = file_get_contents('php://input'); 
		$data = self::ext_json_decode($json, true);
		//$tokenin = Request::instance()->request('token'); 
		$tokenin = $data['token'];

		//用于直接传入token的用户ID，调试用
		if($data['tokenid'])
		{
			return $data['tokenid'];
		}

	    if ($tokenin == "")
	    {
			$tokenin = Request::instance()->request('token'); 
		    if ($tokenin == "")
		    {
		    	$tokenin = $_SERVER['HTTP_TOKEN'];
		    }
	    }
	    if ($tokenin == "")
	    {	    	
	        ajax_decode(array("code" => 10003,"msg"=>"" , "data" => array()));
	        die();
	    }

        $Redis = new Redis();
        if (!$Redis->has($tokenin))
        {
	        ajax_decode(array("code" => 10003,"msg"=>"" , "data" => array()));
	        die();
        }

        $Redis->set($tokenin,"",1);

	    return "";
	}	

	//检查token是否有效
	public function getMoreToken()
	{
		$json = file_get_contents('php://input'); 
		$data = self::ext_json_decode($json, true);
		//$tokenin = Request::instance()->request('token'); 
		$tokenin = $data['token'];
	    if ($tokenin == "")
	    {
			$tokenin = Request::instance()->request('token'); 
		    if ($tokenin == "")
		    {
		    	$tokenin = $_SERVER['HTTP_TOKEN'];
		    }
	    }
	    if ($tokenin == "")
	    {	    	
	        return "";
	    }

        $Redis = new Redis();
        if (!$Redis->has($tokenin))
        {
	        return "";
        }

        $tokeninfo = $Redis->get($tokenin);
        //刷新有效时间
        $Redis->set($tokenin,$tokeninfo,$this->TokenTime);

        //$tokeninfo = json_decode($tokeninfo,true);

	    return $tokeninfo;
	}


	//创建通信token
	public function getToken()
	{
		$post = self::checkParam(array('AppID','Secret')); 

		$secretinfo = Db::name('system_secret')->where("appid",$post['AppID'])->where("secret",$post['Secret'])->find();
		if (!$secretinfo['id'])
		{
	        ajax_decode(array("code" => 10002,"msg"=>"" , "data" => array()));
	        die();
		}

	    $token_new = md5(time().$_SERVER['REMOTE_ADDR'].$_SERVER['REMOTE_PORT'].$_SERVER['REQUEST_TIME_FLOAT'].$_SERVER['HTTP_COOKIE']);

        $Redis = new Redis();
        $RedisArray = array();
        $RedisArray['token'] = $token_new;
        $Redis->set($token_new,json_encode($RedisArray,JSON_UNESCAPED_UNICODE),$this->TokenTime);

        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => array("token"=>$token_new)));
        die();

	}


	//获取短信验证码
	public function getSMSCode()
	{
		//$tokeninfo = self::checkToken();

		$post = self::checkParam(array('phone')); 


        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => array()));
        die();

	}


	//获取短信验证码-带安全验证
	public function getSafeSMSCode()
	{
		$post = self::checkParam(array('phone','ticket')); 
		$morepost = self::getMoreParam(array('randstr')); 

		$ctrl = new Tencent();

		$jiguang = new JiGuang();
		$res = $jiguang->sendSMSCode($post['phone']);

        $Redis = new Redis();
        $Redis->set($post['phone'],$res['msg_id'],600);//验证码10分钟有效

        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => array()));
        die();

	}


	public function decryptData($appid,$sessionkey, $encryptedData, $iv, &$data )
	{
		if (strlen($sessionkey) != 24) {
			return -41001;
		}
		$aesKey=base64_decode($sessionkey);

		if (strlen($iv) != 24) {
			return -41002;
		}
		$aesIV=base64_decode($iv);

		$aesCipher=base64_decode($encryptedData);

		$result=openssl_decrypt( $aesCipher, "AES-128-CBC", $aesKey, 1, $aesIV);

		$dataObj=json_decode( $result );
		if( $dataObj  == NULL )
		{
			return -41003;
		}
		if( $dataObj->watermark->appid != $appid )
		{
			return -41004;
		}
		$data = $result;
		return 0;
	}


	//通过接龙小程序授权获取token
	public function getMiniToken(){

		$post = self::checkParam(array('code')); 

		$wechat = new WeiMiniapi();
		$cfg = $wechat->GetUserInfos();
		$appID = $cfg['appid'];
		$appsecret = $cfg['screct'];
		
	    $url = "https://api.weixin.qq.com/sns/jscode2session?appid=".$appID."&secret=".$appsecret."&js_code=".$post['code']."&grant_type=authorization_code";

	    $Obj = json_decode(self::httpGet($url)); 
	    if (isset($Obj->openid))
	    {
	    	//var_dump($Obj);
	    	//该微信用户是否已存在
	    	$info = Db::name('wx_miniuser')->where('openid',$Obj->openid)->find();
	    	if (!$info['id'])
	    	{//新用户
	    		$input = array();
	    		$input['openid'] = $Obj->openid;
	            $input['nickname'] = "";
	            $input['sex'] = "";
	            $input['headimgurl'] = "";
	            $input['session_key'] = $Obj->session_key;

	            $input['unionid'] = "";
	            if (isset($Obj->unionid))
	            {
		            $input['unionid'] = $Obj->unionid;
	            }
	            $input['intabletime'] = date("Y-m-d H:i:s");
	    		$userid = Db::name('wx_miniuser')->insertGetId($input);
	    		$info = $input;
	    		$info['id'] = $userid;
	    		$info['openid'] = $input['openid'];
	    	}
	    	else
	    	{//更新sessionkey
	    		$input = array();
	            $input['session_key'] = $Obj->session_key;
	    		Db::name('wx_miniuser')->where("id",$info['id'])->update($input);
	    	}

	        $Redis = new Redis();

	    	//查询是否已注册过
	    	$token_new = "";
	    	$isnew = 1;
	    	if ($info['uid'])
	    	{
	 	    	//生成token
			    $token_new = md5($info['uid'].time().$_SERVER['REMOTE_ADDR'].$_SERVER['REMOTE_PORT'].$_SERVER['REQUEST_TIME_FLOAT'].$_SERVER['HTTP_COOKIE']);
       			$Redis->set($token_new,$info['uid'],$this->TokenTime);

		    	$userinfo = Db::name('web_user')->where('id',$info['uid'])->find();
		    	if ($userinfo['isovertag'])
		    	{
		    		$isnew = 0;
		    	}
	    	}

        	ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => array("token"=>$token_new,"openid"=>$info['openid'],"isnew"=>$isnew,"shareid"=>$info['id'])));
	        die();
	    }
	    else
	    {
	        ajax_decode(array("code" => 10021,"msg"=>$Obj->errcode."|".$Obj->errmsg , "data" => array()));
	        die();
	    }

	}



	public function uploadFile()
	{
		$upfile = $_FILES['file'];
		
		if($upfile)
		{
			$filepath =  "Uploads/images/".date("Y")."/";
			@mkdir($filepath);
			$filepath .= date("m")."/";
			@mkdir($filepath);
			$filepath .= date("d")."/";
			@mkdir($filepath);
			$len = strripos($upfile['name'], '.'); 
			if($len)
				$filename = $filepath.date("YmdHisU"). str_shuffle(rand(1000,9999)). substr( $upfile['name'], $len );
			else
				$filename = $filepath.date("YmdHisU").substr($upfile['name'],-4);     
		 
			$blen = move_uploaded_file($upfile['tmp_name'],$filename); 
			if($blen){
				$ossClient = new \OSS\OssClient(config('OSS_CONFIG_KeyId'), config('OSS_CONFIG_KeySecret'), config('OSS_CONFIG_endpoint'));

				$res = $ossClient->uploadFile(config('OSS_CONFIG_bucket'), $filename, $filename);
				
				$err = array("code" => 0,"msg"=>"Success" , "data" => array("url"=>config('OSS_CONFIG_file').$filename)); 
			}else{
				$err = array("code"=>20002, "msg"=>"上传失败", "errormsg"=>"文件移动错误", "data"=>array()); 
			}
		}else{
			$err = array("code"=>20004, "msg"=>"上传失败", "errormsg"=>"缺少必填参数", "data"=>array()); 
		}

        ajax_decode($err);
        die();
	}


	public function uploadMultFile()
	{
		$allfile = array();
		foreach ($_FILES['file']['name'] as $key => $value) {

			//$upfile = $_FILES['file'][$key];
			if($_FILES['file']['tmp_name'][$key])
			{
				$filepath =  "Uploads/images/".date("Y")."/";
				@mkdir($filepath);
				$filepath .= date("m")."/";
				@mkdir($filepath);
				$filepath .= date("d")."/";
				@mkdir($filepath);
				$len = strripos($_FILES['file']['name'][$key], '.'); 
				if($len)
					$filename = $filepath.date("YmdHisU"). str_shuffle(rand(1000,9999)). substr( $_FILES['file']['name'][$key], $len );
				else
					$filename = $filepath.date("YmdHisU").substr($_FILES['file']['name'][$key],-4);     
			 
				$blen = move_uploaded_file($_FILES['file']['tmp_name'][$key],$filename); 
				if($blen){
					$ossClient = new \OSS\OssClient(config('OSS_CONFIG_KeyId'), config('OSS_CONFIG_KeySecret'), config('OSS_CONFIG_endpoint'));

					$res = $ossClient->uploadFile(config('OSS_CONFIG_bucket'), $filename, $filename);
					$allfile[] = config('OSS_CONFIG_file').$filename;
					//$err = array("code" => 0,"msg"=>"Success" , "data" => array("url"=>config('OSS_CONFIG_file').$filename)); 
				}else{
					$err = array("code"=>20002, "msg"=>"上传失败", "errormsg"=>"文件移动错误", "data"=>array()); 
			        ajax_decode($err);
			        die();
				}
			}else{
				$err = array("code"=>20004, "msg"=>"上传失败", "errormsg"=>"缺少必填参数", "data"=>array()); 
		        ajax_decode($err);
		        die();
			}

		}

		$err = array("code" => 0,"msg"=>"Success" , "data" => array("urllist"=>$allfile)); 
        ajax_decode($err);
        die();
	}



	//获取隐私协议
	public function getPivacyPolicy()
	{
		//$tokeninfo = self::checkToken();
		$data = Db::name('system_config')->where("setkey","AppPivacyPolicy")->find();

        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => array("content"=>$data['setvalue'])));
        die();

	}

	//获取服务协议
	public function getServicePolicy()
	{
		//$tokeninfo = self::checkToken();
		$data = Db::name('system_config')->where("setkey","AppServicePolicy")->find();

        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => array("content"=>$data['setvalue'])));
        die();

	}

	//获取客户端初始化信息
	public function getInitData()
	{
		$post = self::getMoreParam("uuid");
		if (!$post['uuid'])
		{
			$post['uuid'] = "";
		}

		$iosversion = Db::name('system_config')->where("setkey","iosVersion")->find();
		$iosurl = Db::name('system_config')->where("setkey","iosDownloadUrl")->find();
		$androidversion = Db::name('system_config')->where("setkey","androidVersion")->find();
		$androidurl = Db::name('system_config')->where("setkey","androidDownloadUrl")->find();

		$res = array();
		$ios['newest'] = $iosversion['setvalue'];
		$ios['url'] = $iosurl['setvalue'];
		$ios['force'] = 1;
		$res['versions']['ios'] = $ios;

		$android['newest'] = $androidversion['setvalue'];
		$android['url'] = $androidurl['setvalue'];
		$android['force'] = 0;
		$res['versions']['android'] = $android;

		$res['launchinfo']['image'] = "";
		$res['launchinfo']['url'] = "";

		$res['indexshow']['type'] = "2";
		$res['indexshow']['url'] = "https://h5.sjtuanliu.com/#/pages/appindex/appindex";

        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => $res ));
        die();

	}


	 
}

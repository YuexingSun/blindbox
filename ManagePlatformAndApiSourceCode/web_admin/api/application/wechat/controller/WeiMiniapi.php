<?php 
/*
* 微信配置
*/  
namespace app\wechat\Controller; 
use think\Db;
use app\common\controller\Log;
use app\common\controller\Common;
use think\Request;

class WeiMiniapi extends Common 
{ 
	public $table = "wx_config";  
	
	public function _initialize(){
		$this->RQ = Request::instance();    
		$this->reset_param();
	}  
	
	//获取用户企业微信基本配置信息
	public function GetUserInfos($company_id=0){ 
		if($company_id){
			$company_id=$company_id; 
		}else{
			if($this->company_id)
				$company_id = $this->company_id;
			else
				$company_id = 1;  
		}
		$data_infos = TB('wx_config', "company_id='$company_id'"); 
		return $data_infos;
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
	

	public function httpPostJson($url,$indata) {
		$curl = curl_init();
		curl_setopt($curl, CURLOPT_HTTPHEADER, array(
    			'Content-Type: application/json',
    			'Content-Length: ' . strlen($indata))
		);
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


	
	//获取微信token
	public function getAccessToken($company_id=1){ 
		if($this->__G__('company_id')) $company_id = $company_id; 
		$wecfg =  $this->GetUserInfos($company_id);
		if (!$wecfg) return "";
		if (($wecfg['accesstoken'] != "") && ($wecfg['exttime'] > time()))
		{ 
			return $wecfg['accesstoken'];
		}else
		{
			//
			$weixinurl = "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=".$wecfg['appid']."&secret=".$wecfg['screct']; 
    		$retObj = json_decode($this->httpGet($weixinurl));
    		if ($retObj->{'access_token'})
    		{
    			$wecfg['accesstoken'] = $retObj->{'access_token'};
    			$wecfg['exttime'] = time() + $retObj->{'expires_in'} - 200; 
				$model = M($this->table);
				$model->where ( " id='".$wecfg['id']."' and company_id='".$company_id."'" )->update($wecfg);

    			return $wecfg['accesstoken']; 
    		}
    		else
    		{
    			echo "ErrorCode:".$retObj->{'errcode'}.";errmsg:".$retObj->{'errmsg'};
    			return "";
    		}
		}
	}
	
	//发送模板消息
	public function SendTpMsg($to,$tpid,$data,$url,$company_id=1) {#
		//此函数修改为只写表，不发送，由定时器负责发送
		if ($to != "")
		{
			$model = M('wx_template_msg');
			$post_intable_data = array(
				"toopenid"=>$to,
				"templateid"=>$tpid, 
				"contentjson"=>json_encode($data, JSON_UNESCAPED_UNICODE) ,
				"url"=>$url,
				"sendtime"=>0,"status"=>0,"company_id"=>$company_id);
			$model->insert($post_intable_data);
		}
	}	

	public function SendTpMsgFromMiniOut($company_id,$h5company_id,$to,$template_id,$url,$data,$miniprogram) {#
		header('Content-Type: text/html; charset=utf-8');
		$accesstokenstr = $this->getAccessToken($company_id); 
		$ch = curl_init(); 
		curl_setopt($ch,CURLOPT_URL,"https://api.weixin.qq.com/cgi-bin/message/wxopen/template/uniform_send?access_token=".$accesstokenstr); 
		$cfg = self::GetUserInfos($h5company_id);

		$tmpdata = array(
			"touser"=>$to,
			"mp_template_msg"=>array(
				"appid" => $cfg['appid'],
				"template_id" => $template_id,
				"url" => $url,
				"miniprogram" => $miniprogram,
				"data" => $data,
				),
			);
		$indata = json_encode($tmpdata, JSON_UNESCAPED_UNICODE);//$this->jsonEncodeWithCN($tmpdata);
		curl_setopt($ch,CURLOPT_POSTFIELDS,$indata); 
		curl_setopt($ch,CURLOPT_RETURNTRANSFER,true); 
		$data = curl_exec($ch); 
		curl_close($ch); 
		return $data;
		
	}	

	public function SendTpMsgFromMiniInDB($company_id,$h5company_id,$to,$template_id,$url,$data,$miniprogram) {#
		$cfg = self::GetUserInfos($h5company_id);
		$tmpdata = array(
			"touser"=>$to,
			"mp_template_msg"=>array(
				"appid" => $cfg['appid'],
				"template_id" => $template_id,
				"url" => $url,
				"miniprogram" => $miniprogram,
				"data" => $data,
				),
			);
		$indata = json_encode($tmpdata, JSON_UNESCAPED_UNICODE);//$this->jsonEncodeWithCN($tmpdata);

		$model = M('wx_template_msg');
		$post_intable_data = array(
			"msgjson"=>$indata,
			"mpid"=>$company_id,
			"intabletime"=>date("Y-m-d H:i:s"));
		$model->insert($post_intable_data);

		return true;
		
	}	

	public function SendDBMsgFromMiniOut($company_id,$indata) {#
		header('Content-Type: text/html; charset=utf-8');
		$accesstokenstr = $this->getAccessToken($company_id); 
		$ch = curl_init(); 
		curl_setopt($ch,CURLOPT_URL,"https://api.weixin.qq.com/cgi-bin/message/wxopen/template/uniform_send?access_token=".$accesstokenstr); 
		curl_setopt($ch,CURLOPT_POSTFIELDS,$indata); 
		curl_setopt($ch,CURLOPT_RETURNTRANSFER,true); 
		$data = curl_exec($ch); 
		curl_close($ch); 
		return $data;		
	}	


	public function SendTpMsgOut($to,$tpid,$data,$url,$company_id=1) {#
		header('Content-Type: text/html; charset=utf-8');
		$accesstokenstr = $this->getAccessToken($company_id); 
		$ch = curl_init(); 
		curl_setopt($ch,CURLOPT_URL,"https://api.weixin.qq.com/cgi-bin/message/template/send?access_token=".$accesstokenstr); 
		$tmpdata = array(
			"touser"=>$to,
			"template_id"=>$tpid,
			"url"=>$url,
			"topcolor"=>"#FF0000",
			"data"=>$data
			);
		$indata = json_encode($tmpdata, JSON_UNESCAPED_UNICODE);//$this->jsonEncodeWithCN($tmpdata);

		curl_setopt($ch,CURLOPT_POSTFIELDS,$indata); 
		curl_setopt($ch,CURLOPT_RETURNTRANSFER,true); 
		$data = curl_exec($ch); 
		curl_close($ch); 
		return $data;
		
	}	



	//下载文件
	public function getMediafile($mediaid, $company_id=1) {#
		header('Content-Type: text/html; charset=utf-8');
		$accesstokenstr = $this->getAccessToken($company_id); 

		$ch = curl_init(); 
		curl_setopt($ch,CURLOPT_URL,"http://file.api.weixin.qq.com/cgi-bin/media/get?access_token=".$accesstokenstr."&media_id=".$mediaid); 
		curl_setopt($ch,CURLOPT_RETURNTRANSFER,true); 
	    curl_setopt($ch,CURLOPT_FOLLOWLOCATION,1);  
	    curl_setopt($ch,CURLOPT_CONNECTTIMEOUT,5);  
	    $img=curl_exec($ch);  
		curl_close($ch); 

		$filepath =  "Uploads/images/".date("Y")."/";
		@mkdir($filepath);
		$filepath .= date("m")."/";
		@mkdir($filepath);
		$filepath .= date("d")."/";
		@mkdir($filepath);
        $filename = $filepath.$mediaid.".jpg"; 

	    $fp2=@fopen($filename,'w');  
	    fwrite($fp2,$img);  
	    fclose($fp2);  

		return $filename;
		
	}

	//获取小程序码
	public function getMiniCode($company_id=1,$scene) {#
		header('Content-Type: text/html; charset=utf-8');
		$accesstokenstr = $this->getAccessToken($company_id); 
		$ch = curl_init(); 
		curl_setopt($ch,CURLOPT_URL,"https://api.weixin.qq.com/wxa/getwxacodeunlimit?access_token=".$accesstokenstr); 
		$tmpdata = array(
			"scene"=>$scene,
			);
		$indata = json_encode($tmpdata, JSON_UNESCAPED_UNICODE);//$this->jsonEncodeWithCN($tmpdata);

		curl_setopt($ch,CURLOPT_POSTFIELDS,$indata); 
		curl_setopt($ch,CURLOPT_RETURNTRANSFER,true); 
		$data = curl_exec($ch); 
		curl_close($ch); 
		return $data;
		
	}	


	//获取用户列表
	public function getAllUserOpenidList($openid,$company_id=1) {#
		header('Content-Type: text/html; charset=utf-8');
		$accesstokenstr = $this->getAccessToken($company_id); 
		$weixinurl = "https://api.weixin.qq.com/cgi-bin/user/get?access_token=".$accesstokenstr."&next_openid=".$openid;
		$retObj = json_decode($this->httpGet($weixinurl),true);
		return $retObj;
	}		

	//批量获取用户基本信息
	public function getSomeMoreUserDetail($openidlist,$company_id=1) {#
		header('Content-Type: text/html; charset=utf-8');
		$accesstokenstr = $this->getAccessToken($company_id); 
		$weixinurl = "https://api.weixin.qq.com/cgi-bin/user/info/batchget?access_token=".$accesstokenstr;
		$ch = curl_init(); 
		curl_setopt($ch,CURLOPT_URL,$weixinurl); 
		$indata = json_encode($openidlist, JSON_UNESCAPED_UNICODE);//$this->jsonEncodeWithCN($tmpdata);

		curl_setopt($ch,CURLOPT_POSTFIELDS,$indata); 
		curl_setopt($ch,CURLOPT_RETURNTRANSFER,true); 
		$data = curl_exec($ch); 
		curl_close($ch); 
		return json_decode($data,true);
	}		



}
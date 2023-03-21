<?php 
namespace app\common\controller; 
use think\Db;
use think\Controller; 
use think\Request;
use think\Validate; 

class Common extends Controller
{
	
	protected $param_prefix = "__";    
	
	protected function _initialize()
    { 
		self::__main__(); 
    }
 
	protected function __main__(){ 
		$this->RQ = Request::instance();   
		$this->token_info = self::checkToken();
		self::reset_param();
	}
	
	protected function checkToken(){ 
		$tokenin = Request::instance()->request('token'); 
	    if ($tokenin == "")
	    {
	        ajax_decode(array("errorcode" => 10002,"errormsg"=>"token invalid" , "data" => array()));
	        die();
	    }
	    $info = Db::name('web_token')->where('token',$tokenin)->find();
	    /*if ($info['expirestime'] < time())
	    {
	        ajax_decode(array("errorcode" => 10002,"errormsg"=>"token invalid" , "data" => array()));
	        die();
	    }*/
		$this->token_info = $info;
	    return $info; 
	}
	
	
	//检查商户是否存在
	public function check_shop(){ 
		$db = __db("panel_company");
		$infos = $db->where(["appid"=>$this->appid])->find();
		if(!$infos){
			$arr = array("errorcode"=>400, "errormsg"=>"商户不存在"); 
			$this->json_error($arr); 
		}
		$this->shop_infos = $infos; 
		return ($infos);
	}
	
	//定义类成员参数
	protected function reset_param(){  
		foreach($_REQUEST as $key=>$v){
			$tmp_key = $this->param_prefix.$key; 
 			if(!$this->{$tmp_key}){
 				self::__G__($key);
			}
		} 
	}
	
	//获取参数（原始） 且 设置成员值（转义的）
	public function __G__($param){
		if(!$param) return $this->RQ->param();  
		$tmp_key = $this->param_prefix.$param; 
		
		$val = $this->RQ->only($param)[$param];
		 
		if(!$this->{$tmp_key}){
			$this->{$tmp_key} = addslashes( $val );  // 转义
		}
		
		if($val=="") return "";
		
		return $val;
	}
	
	//验证参数规则 是否必填
	public function validate($param, $print=true){ 
		foreach($param as $key=>$v){  
			$blen = preg_match('/[\d]+/', $key); 
			if($blen){ 
				$rule[$v] = "require" ;
				$data[$v] = $this->__G__($v); 
			}else{
				$rule[$key] = "$v" ;
				$data[$key] = $this->__G__($key); 
			} 
		}   
		$this->validate = new Validate( $rule ); 
		$result = $this->validate->check($data); 
		if( !$result ){  
			if($print==true){ 
				$msg = $this->validate->getError() ;  
				if( strpos($msg, '不能为空')===false ) $error = "必填参数有误";
				elseif($msg) $error = "缺少必填参数";
				$err=array("errorcode"=>10001, "error"=>"$error", "errormsg"=>"$msg");
				$this->json_error($err);
			}
		} 
		return $result;
	} 
	 
	public function common_str(){ 
		$str  = createNonceStr(32);
		return strtoupper( md5($str) );  
	}
	 
	public function wx_uploadFileAll($save_path){ 
		$upfile = $_FILES['file'];
		
		//print_r($_FILES);  
		//exit; 
		if($upfile)
		{
			if($save_path)
			$filepath =  $save_path.date("Y")."/";
			else
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
				$err = array("errorcode"=>0, "errormsg"=>"上传成功", "error"=>"上传成功", "data"=>array("filePath"=>config('APP_DOMAIN_URL').$filename)); 
			}else{
				$err = array("errorcode"=>20002, "errormsg"=>"上传失败", "error"=>"文件移动错误", "data"=>array()); 
			}
			/*	return '{"code":"200", "path":"'. config('KFU_ADMIN_URL').$filename.'"}';
			else 
				return '{"code":"400", "path":""}';*/
		}else{
			$err = array("errorcode"=>10001, "errormsg"=>"上传失败", "error"=>"缺少必填参数", "data"=>array()); 
		}
		return $err;  
	} 
	
	//检查数组的值是否存在:
	public function check_str_inarrays($str){ 
	 
		if( strripos($str, '[')!==0 ) return false;  //最后一次出现的位置必须是0开始
						 
		if( strpos($str, ']') != strlen($str)-1 ) return false;  //第一次出现的位置必须是 该字符串长度-1	 	 
		
		$arr = $this->str_arrays($str);  //转化成数组
		foreach($arr as $v){
			$temp = explode(':', $v); 
			if( $temp[0]=="" || $temp[1]=="" ) return false;  // 如果数组两个值都为空 表示错误的数组 
		}
		return true;
	}
	
	
	
	//输出json
	public  function json_error($data=array()){ 
		ajax_decode($data); 
		exit;
	} 
	
	public function error_shortcut($data=array()){ 
		$err = array("errorcode"=>20002, "errormsg"=>"保存失败", "error"=>"保存失败", "data"=>array()); 
		if( isset($data['errorcode']) ) $err['errorcode'] = $data['errorcode'] ;
		if( isset($data['errormsg']) ) $err['errormsg'] = $data['errormsg'] ;
		if( isset($data['error']) ) $err['error'] = $data['error'] ;
		if( isset($data['data']) ) $err['data'] = $data['data'] ; 
		$this->json_error($err);
	}
	
	public function success_shortcut($data=array()){ 
		$err = array("errorcode"=>0, "errormsg"=>"保存成功", "error"=>"保存成功", "data"=>array());  
		if( isset($data['errorcode']) ) $err['errorcode'] = $data['errorcode'] ;
		if( isset($data['errormsg']) ) $err['errormsg'] = $data['errormsg'] ;
		if( isset($data['error']) ) $err['error'] = $data['error'] ;
		if( isset($data['data']) ) $err['data'] = $data['data'] ; 
		$this->json_error($err);
	}
	
	public function error_shortcut_del($data=array()){  
		$err = array("errorcode"=>20002, "errormsg"=>"删除失败", "error"=>"删除失败", "data"=>array()); 
		if( isset($data['errorcode']) ) $err['errorcode'] = $data['errorcode'] ;
		if( isset($data['errormsg']) ) $err['errormsg'] = $data['errormsg'] ;
		if( isset($data['error']) ) $err['error'] = $data['error'] ;
		if( isset($data['data']) ) $err['data'] = $data['data'] ; 
		$this->json_error($err);
	}
	
	public function success_shortcut_del($data=array()){  
		$err = array("errorcode"=>0, "errormsg"=>"删除成功", "error"=>"删除成功", "data"=>array()); 
		if( isset($data['errorcode']) ) $err['errorcode'] = $data['errorcode'] ;
		if( isset($data['errormsg']) ) $err['errormsg'] = $data['errormsg'] ;
		if( isset($data['error']) ) $err['error'] = $data['error'] ;
		if( isset($data['data']) ) $err['data'] = $data['data'] ; 
		$this->json_error($err);
	}
	
	public function _empty()
    {  
		$err=array("code"=>20002, "errormsg"=>"请检查访问接口是否正确", "error"=>"接口地址不存在");    
		$this->error_shortcut($err);
    } 
}
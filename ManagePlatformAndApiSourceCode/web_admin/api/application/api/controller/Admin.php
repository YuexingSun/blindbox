<?php
namespace app\api\controller;
require_once 'vendor/aliyun-oss-php-sdk/autoload.php';
use OSS\OssClient;
use OSS\Core\OssException;

use think\Db;
use think\Request;
use think\Controller; 
use app\common\controller\Common; 
use app\wechat\controller\Zanapi;
use app\wechat\controller\Weiapi;

class Admin extends Controller
{

	private $SMSCodeTime = 10;//验证码的有效时间，分钟
	private $TokenTime = 12;//token的有效时间，小时
	private $pagelimit = 10;
	private $pipeheight = 10;

	private $SalesRolesArray = array(
		
	);

	protected function _initialize()
    {
		
	}

/*
 * unicode -> text
 */
	private function unicodeEncode($str){
	    if(!is_string($str))return $str;
	    if(!$str || $str=='undefined')return '';

	    $text = json_encode($str); 
	    $text = preg_replace_callback("/(\\\u[ed][0-9a-f]{3})/i",function($str){
	        return addslashes($str[0]);
	    },$text);
	    return json_decode($text);
	}

	/**
	 * text -> unicode
	 */
	private function  unicodeDecode($str)
	{
	    $text = json_encode($str);
	    $text = preg_replace_callback('/\\\\\\\\/i', function ($str) {
	        return '\\';
	    }, $text);
	    return json_decode($text);
	}

	private function  changeEmoji($str)
	{
	    return preg_replace('/\[emoji-([0-9]{3})\]/i','<img src="src/style/res/emoji/$1.png" width="25px">', $str);
	}


	private function getWeekID($str){
		if ($str == "周一") return 1;
		elseif ($str == "周二") return 2;
		elseif ($str == "周三") return 3;
		elseif ($str == "周四") return 4;
		elseif ($str == "周五") return 5;
		elseif ($str == "周六") return 6;
		elseif ($str == "周日") return 7;
		else return 0;
	}

	private function getWeekName($id){
		if ($id == 1) return "周一";
		elseif ($id == 2) return "周二";
		elseif ($id == 3) return "周三";
		elseif ($id == 4) return "周四";
		elseif ($id == 5) return "周五";
		elseif ($id == 6) return "周六";
		elseif ($id == 7) return "周日";
		else return "";
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

	private function getrolesname($id){
		foreach ($this->SalesRolesArray as $key => $value) 
		{
			if ($value['id'] == $id) return $value['name'];
		}
	  	return "";
	}

	public function setPointChange($uid,$point,$txt){

		if($point == 0) return false;
		$input = array();
		$input['uid'] = $uid;
		$input['point'] = $point;
		$input['txt'] = $txt;
		$input['type'] = ($point > 0)?"1":"2";
		$input['intabletime'] = date("Y-m-d H:i:s");
		Db::name('pointlist')->insert($input);

		$info = Db::name('wx_miniuser')->where("id",$uid)->find();
		Db::name('wx_miniuser')->where("id",$uid)->update(array("point"=>$info['point']+$point));
		//同步到第三方
		if ($info['mob'])
		{
			$ctrl = new Zanapi();
			if ($point > 0)
			{
				$res = $ctrl->addPoint($info['mob'],$point,$txt);
			}
			elseif ($point < 0)
			{
				$res = $ctrl->dePoint($info['mob'],abs($point),$txt);
			}
		}

		return true;
	}

	public function uploadFile()
	{
		$upfile = $_FILES['file'];

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
				$ossClient = new \OSS\OssClient(config('OSS_CONFIG_KeyId'), config('OSS_CONFIG_KeySecret'), config('OSS_CONFIG_endpoint'));

				$res = $ossClient->uploadFile(config('OSS_CONFIG_bucket'), $filename, $filename);
				
				$err = array("location"=>config('OSS_CONFIG_file').$filename); 
			}else{
				$err = array("errorcode"=>20002, "msg"=>"上传失败", "errormsg"=>"文件移动错误", "data"=>array()); 
			}
		}else{
			$err = array("errorcode"=>10001, "msg"=>"上传失败", "errormsg"=>"缺少必填参数", "data"=>array()); 
		}

        ajax_decode($err);
        die();
	}

	public function uploadCKFile()
	{
		$upfile = $_FILES['upload'];
		
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
				$ossClient = new \OSS\OssClient(config('OSS_CONFIG_KeyId'), config('OSS_CONFIG_KeySecret'), config('OSS_CONFIG_endpoint'));

				$res = $ossClient->uploadFile(config('OSS_CONFIG_bucket'), $filename, $filename);
				
			    ajax_decode(array("uploaded" => 1,"fileName"=>$upfile['name'],"url"=>config('OSS_CONFIG_file').$filename));
			}else{
				$err = "文件移动错误"; 
			    ajax_decode(array("uploaded" => 0,"error"=>array("message"=>$err)));
			}
		}else{
			$err = "请选择上传文件"; 
		    ajax_decode(array("uploaded" => 0,"error"=>array("message"=>$err)));
		}
        die();
	}




	//登录
	public function login(){

		$post['username'] = Request::instance()->request('username'); 
		$post['password'] = Request::instance()->request('password'); 

		if ($post['username'] == "")
		{
	        ajax_decode(array("errorcode" => 10031,"errormsg"=>"请填写用户名" , "data" => array()));
	        die();
		}

        //查询用户身份
		$info = Db::name('user')->where('username',$post['username'])->where("password",md5($post['password']))->where("status",1)->find();
		if (!$info['id'])
		{
	        ajax_decode(array("errorcode" => 10033,"errormsg"=>"用户名或密码错" , "data" => array()));
	        die();							
		}

	    $token_new = $info['id'].md5(time().$_SERVER['REMOTE_ADDR'].$_SERVER['REMOTE_PORT'].$_SERVER['REQUEST_TIME_FLOAT'].$_SERVER['HTTP_COOKIE']);

	    $expirestime = time() + $this->TokenTime * 60 * 60 ;
	    $input = array("token"=>$token_new,"expirestime"=>$expirestime,"uid"=>$info['id'],"intabletime"=>date("Y-m-d H:i:s"));
	    
	    Db::name('web_token')->insert($input);

		add_log($info['id'], '登录成功', '登录IP：'.GetIP(), json_encode($post,JSON_UNESCAPED_UNICODE));

	    ajax_decode(array("errorcode" => 0,"errormsg"=>"success" , "data" => array("access_token"=>$token_new)));
	    die();

	} 



	//生成菜单树
	public function getMemuList(){

		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

	    $res = array();
	    $menus = Db::name('menu_url')->where("pid",0)->where("is_show",1)->order("sortid desc,id asc")->select();
	    foreach ($menus as $key => $value) 
	    {
	    	$first = array();
	    	$first['title'] = $value['menu_name'];
	    	$first['icon'] = $value['icon'];
	    	$first['name'] = $value['menu_url'];
	    	$first['list'] = array();

	    	//第二级
	   		$menus2 = Db::name('menu_url')->where("pid",$value['id'])->where("is_show",1)->order("sortid desc,id desc")->select();
	   		$secitem = array();

	   		foreach ($menus2 as $v2) 
	   		{
	   			$secever = array();
		    	//第三级
		   		$menus3 = Db::name('menu_url')->where("pid",$v2['id'])->where("is_show",1)->order("sortid desc,id desc")->select();
		   		if (count($menus3) <= 0)
		   		{
		   			//如果该2级下没有3级，则该2级为终点
		   			//检查终点权限
		   			if (($tokeninfo['uid'] != 1)&&($v2['id']==37))//人员管理的权限只有admin有
		   			{
		   			}
		   			else
		   			{
		   				$line = array();
				    	$line['title'] = $v2['menu_name'];
				    	$line['name'] = $v2['menu_url'];
				    	$first['list'][] = $line;
		   			}
		   		}
		   		else
		   		{//还有第三级
		   			$thirditem = array();
		   			foreach ($menus3 as $v3) 
		   			{
			   			//检查终点权限
			   			// if (($groupinfo['id'] == 1)||(in_array($v3['id'], $rulesarray)))
			   			// {
			   				$line = array();
					    	$line['title'] = $v3['menu_name'];
					    	$line['name'] = $v3['menu_url'];
					    	$thirditem[] = $line;
			   			// }
		   			}
		   			if ($thirditem)
		   			{
		   				$line = array();
				    	$line['title'] = $v2['menu_name'];
				    	$line['name'] = $v2['menu_url'];
				    	$line['list'] = $thirditem;
				    	$secever = $line;
		   			}
		   		}
	   			if ($secever)
	   			{
			    	$first['list'][] = $secever;
	   			}
	   		}

	   		if ($first['list'])
	   		{
	   			$res[] = $first;
	   		}
	    }

	    ajax_decode(array("errorcode" => 0,"errormsg"=>"success" , "data" => $res ));
	    die();

	} 


	//个人资料
	public function getMineName(){

		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();
	    $info = Db::name('user')->where("id",$tokeninfo['uid'])->find();

	    ajax_decode(array("errorcode" => 0,"errormsg"=>"success" , "data" => array("username"=> $info['username']) ));
	    die();

	} 



	//获取人员管理列表
	public function getAdminUser2List(){

		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		$post['searchname'] = Request::instance()->request('searchname'); 
		$post['searchstatus'] = Request::instance()->request('searchstatus'); 
		$post['page'] = Request::instance()->request('page'); 
		$post['limit'] = Request::instance()->request('limit'); 

		if (!$post['page']) $post['page'] = 1;
		if (!$post['limit']) $post['limit']= $this->pagelimit;

		$wherestr = " 1=1 ";
		if ($post['searchname'] != "")
		{
			$wherestr .= " and username LIKE '%".$post['searchname']."%' ";
		}
		if ($post['searchstatus'])
		{
			$wherestr .= " and status = '".$post['searchstatus']."' ";
		}

	    $menus = Db::name('user')->field("id")->where($wherestr)->select();
	    $total = count($menus);

	    $res = array();
	    $menus = Db::name('user')->where($wherestr)->order("id desc")->limit((($post['page']-1)*$post['limit']).",".$post['limit'])->select();
	    foreach ($menus as $key => $value) 
	    {
	    	$line = array();
	    	$line = $value;

	    	$res[] = $line;
	    }

	    ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" , "count"=>$total, "data" => $res ));
	    die();

	} 

	//新建/编辑用户
	public function submitNewUser2Data(){

		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();


		$post = $sysctrl->checkParam(array("username"));

		$post['id'] = Request::instance()->request('id'); 
		$post['password'] = Request::instance()->request('password'); 

		$input = array();
		$input['username'] = $post['username'];
		if ($post['password'])
		{
			$input['password'] = md5($post['password']);
		}

		if ($post['id'])
		{
		    $old = Db::name('user')->where("username",$input['username'])->where("status",1)->where("id <> '".$post['id']."' ")->find();
		    if ($old['id'])
		    {
		        ajax_decode(array("errorcode" => 10033,"errormsg"=>"该账号已存在" , "data" => array()));
		        die();				
		    }
		    Db::name('user')->where("id",$post['id'])->update($input);
		}
		else
		{
			//检查重复
		    $old = Db::name('user')->where("username",$input['username'])->where("status",1)->find();
		    if ($old['id'])
		    {
		        ajax_decode(array("errorcode" => 10033,"errormsg"=>"该账号已存在" , "data" => array()));
		        die();				
		    }

			$input['status'] = 1;
			$input['intabletime'] = date("Y-m-d H:i:s");
		    Db::name('user')->insert($input);
		}

		add_log($tokeninfo['uid'], '新建/编辑账号', '', json_encode($post,JSON_UNESCAPED_UNICODE));

	    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
	    die();

	} 

	//用户离职
	public function removeUserGone(){

		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		$post = $sysctrl->checkParam(array("id","type"));

		if ($post['type'] == "stop")
		{
			Db::name('user')->where(" id = '".$post['id']."' ")->update(array("status"=>2));
			add_log($tokeninfo['uid'], '账号停用', '', json_encode($post,JSON_UNESCAPED_UNICODE));
		}
		elseif ($post['type'] == "start")
		{
			Db::name('user')->where(" id = '".$post['id']."' ")->update(array("status"=>1));
			add_log($tokeninfo['uid'], '账号启用', '', json_encode($post,JSON_UNESCAPED_UNICODE));
		}
		elseif ($post['type'] == "del")
		{
			Db::name('user')->where(" id = '".$post['id']."' ")->delete();
			add_log($tokeninfo['uid'], '账号删除', '', json_encode($post,JSON_UNESCAPED_UNICODE));
		}

	    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
	    die();

	} 

	//日志列表
	public function getAllLogList(){

		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		$post['searchrole'] = Request::instance()->request('searchrole'); 
		$post['searchlog'] = Request::instance()->request('searchlog'); 
		$post['page'] = Request::instance()->request('page'); 
		$post['limit'] = Request::instance()->request('limit'); 

		if (!$post['page']) $post['page'] = 1;
		if (!$post['limit']) $post['limit']= $this->pagelimit;

		$where = " 1=1 ";
		if ($post['searchrole'])
		{
			$userlist = Db::name('user')->where("username LIKE '%".$post['searchrole']."%' ")->select();
			$userids = "(";
			foreach ($userlist as $key => $value) 
			{
				$userids .= $value['id'].",";
			}
			$userids .= "0) ";
			$where .= " and a.uid in ".$userids." ";
		}
		if ($post['searchlog'])
		{
			$where .= " and a.intabletime >='".substr($post['searchlog'],0,10)." 00:00:00' and a.intabletime <='".substr($post['searchlog'],-10)." 23:59:59' ";
		}

	    $res = array();
	    $menus = Db::name('log')->alias("a")->field("id")->where($where)->select();
	    $total = count($menus);

	    $res = array();
	    $menus = Db::name('log')->field("a.*,b.username as uname")->alias("a")->join("user b","a.uid=b.id","left")->where($where)->order("id desc")->limit((($post['page']-1)*$post['limit']).",".$post['limit'])->select();

	    ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" , "count"=>$total, "data" => $menus ));
	    die();

	} 

	//修改密码
	public function setPassword(){

		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();
		$post = $sysctrl->checkParam(array("oldPassword","password","repassword"));

	    $info = Db::name('user')->where("id",$tokeninfo['uid'])->find();

	    if ($info['password'] != md5($post['oldPassword']))
	    {
	        ajax_decode(array("errorcode" => 10033,"errormsg"=>"原密码不正确" , "data" => array()));
	        die();							
	    }
	    $info = Db::name('user')->where("id",$tokeninfo['uid'])->update(array("password"=>md5($post['password'])));

		add_log($tokeninfo['uid'], '修改密码', '', json_encode($post,JSON_UNESCAPED_UNICODE));

	    ajax_decode(array("errorcode" => 0,"errormsg"=>"success" , "data" => array() ));
	    die();

	} 



	//登录
	public function logout(){

		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		add_log($tokeninfo['uid'], '退出登录', '', json_encode($post,JSON_UNESCAPED_UNICODE));
	    
	    Db::name('web_token')->where("token",$tokeninfo['token'])->delete();

	    ajax_decode(array("errorcode" => 0,"errormsg"=>"success" , "data" => array()));
	    die();

	} 



	//获取字典数据列表，无权限验证，根据输入参数，输入对应字典
	//安全起见，字典只支持POST方法
	public function getDictList(){

		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		$res = array();
		if (Request::instance()->isPost())
		{
			$post = $sysctrl->checkParam(array("type"));
		
			if ($post['type'] == "taglist")
			{//B端标签列表
				$res = Db::name("tag_list")->field("id,name")->order("name asc")->select();
			}
			elseif ($post['type'] == "typelist")
			{//B端分类列表
				$res = Db::name("tag_type")->field("id,name")->order("name asc")->select();
			}
			elseif ($post['type'] == "typechildtag")
			{//B端标签树列表
				$list = Db::name("tag_type")->field("id,name")->order("name asc")->select();
				$allid = array();
				foreach ($list as $key => $value) 
				{
					$child = Db::name("relation_type_tag")->alias("a")->field("b.id,b.name")->join("tag_list b","a.tagid=b.id","left")->where("a.typeid",$value['id'])->order("b.name asc")->select();
					$thischild = array();
					foreach ($child as $v) 
					{
						if (!in_array($v['id'],$allid))
						{
							$allid[] = $v['id'];
							$thischild[] = $v;
						}
					}

					if (count($thischild)>0)
					{
						$line = array();
						$line['name'] = $value['name'];
						$line['children'] = $thischild;	
						$res[] = $line;					
					}
				}

				$child = Db::name("tag_list")->alias("a")->field("a.id,a.name")->join("relation_type_tag b","a.id=b.tagid","left")->where("b.typeid IS NULL ")->order("a.name asc")->select();
				if (count($child)>0)
				{
					$line = array();
					$line['name'] = "无分组";
					$line['children'] = $child;	
					$res[] = $line;					
				}

			}
			elseif ($post['type'] == "typechildctag")
			{//C端标签树列表
				$list = Db::name("tagclient_type")->field("id,name")->order("name asc")->select();
				$allid = array();
				foreach ($list as $key => $value) 
				{
					$child = Db::name("relation_type_tag_client")->alias("a")->field("b.id,b.name")->join("tagclient_list b","a.tagid=b.id","left")->where("a.typeid",$value['id'])->order("b.name asc")->select();
					$thischild = array();
					foreach ($child as $v) 
					{
						if (!in_array($v['id'],$allid))
						{
							$allid[] = $v['id'];
							$thischild[] = $v;
						}
					}

					if (count($thischild)>0)
					{
						$line = array();
						$line['name'] = $value['name'];
						$line['children'] = $thischild;	
						$res[] = $line;					
					}
				}
				$child = Db::name("tagclient_list")->alias("a")->field("a.id,a.name")->join("relation_type_tag_client b","a.id=b.tagid","left")->where("b.typeid IS NULL ")->order("a.name asc")->select();
				if (count($child)>0)
				{
					$line = array();
					$line['name'] = "无分组";
					$line['children'] = $child;	
					$res[] = $line;					
				}
			}
			elseif ($post['type'] == "ctypelist")
			{//C端分类列表
				$res = Db::name("tagclient_type")->field("id,name")->order("name asc")->select();
			}
			elseif ($post['type'] == "ctaglist")
			{//C端标签列表
				$res = Db::name("tagclient_list")->field("id,name")->order("name asc")->select();
			}
			elseif ($post['type'] == "maintype")
			{//主分类列表
				$res = Db::name("base_type")->field("id,name")->order("name asc")->select();
			}
			elseif ($post['type'] == "firstcate")
			{//主分类列表
				$post = $sysctrl->checkParam(array("id"));
				$res = Db::name("first_cate")->field("id,name")->where("baseid",$post['id'])->order("name asc")->select();
			}
			elseif ($post['type'] == "circletype")
			{//商圈维度列表
				$res = Db::name("circle_type")->field("id,name")->order("id asc")->select();
			}
			elseif ($post['type'] == "circlelist")
			{//主分类列表
				$morepost = $sysctrl->getMoreParam(array("id"));
				$where = " 1 = 1 ";
				if ($morepost['id'])
				{
					$tmp = explode("/", $morepost['id']);
					if ($tmp[0])
					{
						$where .= " and province = '".$tmp[0]."' ";
					}
					if ($tmp[1])
					{
						$where .= " and city = '".$tmp[1]."' ";
					}
					if ($tmp[2])
					{
						$where .= " and district = '".$tmp[2]."' ";
					}
				}
				$res = Db::name("circle_list")->field("id,name")->where($where)->order("name asc")->select();
			}
			elseif ($post['type'] == "destination")
			{//商家列表
				$res = Db::name("destination")->field("id,name")->order("name asc")->select();
			}
			elseif ($post['type'] == "userlist")
			{//前端用户列表
				$res = Db::name("web_user")->field("id,mob,name,avatar")->order("id asc")->select();
			}
			elseif ($post['type'] == "productlist")
			{//前端用户列表
				$res = Db::name("product_list")->alias("a")->field("a.id,a.name,b.name as detiname")->join("destination b","a.destinationid=b.id","left")->order("a.id asc")->select();
			}
			elseif ($post['type'] == "articlelist")
			{//文章列表
				$res = Db::name("article")->field("id,title")->order("id asc")->select();
			}

		}
		ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" , "count"=>count($res), "data" => $res ));
		die();
	} 



	//B端标签维度
	public function TagDimen(){

		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		if (Request::instance()->isPost())
		{
			$post = $sysctrl->checkParam(array("name"));

			$input = array();
			$input['name'] = $post['name'];

			//检查重复
		    $old = Db::name('tag_type')->where("name",$input['name'])->find();
		    if ($old['id'])
		    {
		        ajax_decode(array("errorcode" => 10033,"errormsg"=>"已有相同名称的标签维度存在" , "data" => array()));
		        die();				
		    }
		    Db::name('tag_type')->insert($input);

			add_log($tokeninfo['uid'], '新建标签维度', '', json_encode($post,JSON_UNESCAPED_UNICODE));

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
		    die();

		}
		elseif (Request::instance()->isPut())
		{
			$post = $sysctrl->checkPutParam(array("name","id"));

			$input = array();
			$input['name'] = $post['name'];

			//检查重复
		    $old = Db::name('tag_type')->where("name",$input['name'])->where("id <> '".$post['id']."' ")->find();
		    if ($old['id'])
		    {
		        ajax_decode(array("errorcode" => 10033,"errormsg"=>"已有相同名称的标签维度存在" , "data" => array()));
		        die();				
		    }
		    Db::name('tag_type')->where("id",$post['id'])->update($input);

			add_log($tokeninfo['uid'], '修改标签维度', '', json_encode($post,JSON_UNESCAPED_UNICODE));

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
		    die();

		}
		elseif (Request::instance()->isDelete())
		{
			$post = $sysctrl->checkPutParam(array("id"));

			Db::name('tag_type')->where(" id = '".$post['id']."' ")->delete();
			//还要增加关联关系的删除
			Db::name('relation_type_tag')->where("typeid",$post['id'])->delete();

			add_log($tokeninfo['uid'], '删除标签维度', '', json_encode($post,JSON_UNESCAPED_UNICODE));

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
		    die();

		}
		elseif (Request::instance()->isGet())
		{
			$morepost = $sysctrl->getMoreParam(array("id"));
			if ($morepost['id'])
			{//查询某一个


			}
			else
			{//获取列表
				$morepost = $sysctrl->getMoreParam(array("page",'limit','tagname','field','order'));
		
				if (!$morepost['page']) $morepost['page'] = 1;
				if (!$morepost['limit']) $morepost['limit']= $this->pagelimit;

			    if ($morepost['field']!="" && $morepost['order']!="" )
			    {
			    	$sortstr = $morepost['field']." ".$morepost['order'];
			    }
			    else
			    {
			    	$sortstr = "id desc";
			    }

				$wherestr = " 1=1 ";
				if ($morepost['tagname'] != "")
				{
					$wherestr .= " and name LIKE '%".$morepost['tagname']."%' ";
				}
			    $menus = Db::name('tag_type')->field("id")->where($wherestr)->select();
			    $total = count($menus);

			    $res = array();
			    $menus = Db::name('tag_type')->where($wherestr)->order($sortstr)->limit((($morepost['page']-1)*$morepost['limit']).",".$morepost['limit'])->select();
			    foreach ($menus as $key => $value) 
			    {
			    	$line = array();
			    	$line = $value;
			    	$line['taglist'] = Db::name('relation_type_tag')->alias("a")->field("b.id,b.name")->where("a.typeid",$value['id'])->join("tag_list b","a.tagid=b.id","left")->select();

			    	$res[] = $line;
			    }

			    ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" , "count"=>$total, "data" => $res ));
			    die();
			}
		}
		ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" ,"data" => array() ));
		die();
	} 



	//标签列表
	public function TagList(){

		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		if (Request::instance()->isPost())
		{
			$post = $sysctrl->checkParam(array("name"));

			$input = array();
			$input['name'] = $post['name'];

			//检查重复
		    $old = Db::name('tag_list')->where("name",$input['name'])->find();
		    if ($old['id'])
		    {
		        ajax_decode(array("errorcode" => 10033,"errormsg"=>"已有相同名称的标签存在" , "data" => array()));
		        die();				
		    }
		    Db::name('tag_list')->insert($input);

			add_log($tokeninfo['uid'], '新建标签', '', json_encode($post,JSON_UNESCAPED_UNICODE));

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
		    die();

		}
		elseif (Request::instance()->isPut())
		{
			$post = $sysctrl->checkPutParam(array("name","id"));

			$input = array();
			$input['name'] = $post['name'];

			//检查重复
		    $old = Db::name('tag_list')->where("name",$input['name'])->where("id <> '".$post['id']."' ")->find();
		    if ($old['id'])
		    {
		        ajax_decode(array("errorcode" => 10033,"errormsg"=>"已有相同名称的标签存在" , "data" => array()));
		        die();				
		    }
		    Db::name('tag_list')->where("id",$post['id'])->update($input);

			add_log($tokeninfo['uid'], '修改标签', '', json_encode($post,JSON_UNESCAPED_UNICODE));

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
		    die();

		}
		elseif (Request::instance()->isDelete())
		{
			$post = $sysctrl->checkPutParam(array("id"));

			$tmp = explode(",",$post['id']);
			foreach ($tmp as $key => $value) 
			{
				if ($value)
				{
					Db::name('tag_list')->where(" id = '".$value."' ")->delete();
					//还要增加关联关系的删除
					Db::name('relation_type_tag')->where("tagid",$value)->delete();
					Db::name('tag_same')->where("btagid",$value)->delete();
				}
			}

			add_log($tokeninfo['uid'], '删除标签', '', json_encode($post,JSON_UNESCAPED_UNICODE));

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
		    die();

		}
		elseif (Request::instance()->isGet())
		{
			$morepost = $sysctrl->getMoreParam(array("id"));
			if ($morepost['id'])
			{//查询某一个


			}
			else
			{//获取列表
				$morepost = $sysctrl->getMoreParam(array("page",'limit','tagname','field','order'));
		
				if (!$morepost['page']) $morepost['page'] = 1;
				if (!$morepost['limit']) $morepost['limit']= $this->pagelimit;
			    if ($morepost['field']!="" && $morepost['order']!="" )
			    {
			    	$sortstr = $morepost['field']." ".$morepost['order'];
			    }
			    else
			    {
			    	$sortstr = "id desc";
			    }

				$wherestr = " 1=1 ";
				if ($morepost['tagname'] != "")
				{
					$wherestr .= " and name LIKE '%".$morepost['tagname']."%' ";
				}
			    $menus = Db::name('tag_list')->field("id")->where($wherestr)->select();
			    $total = count($menus);

			    $res = array();
			    $menus = Db::name('tag_list')->where($wherestr)->order($sortstr)->limit((($morepost['page']-1)*$morepost['limit']).",".$morepost['limit'])->select();
			    foreach ($menus as $key => $value) 
			    {
			    	$line = array();
			    	$line = $value;
			    	$line['taglist'] = Db::name('relation_type_tag')->alias("a")->field("b.id,b.name")->where("a.tagid",$value['id'])->join("tag_type b","a.typeid=b.id","left")->select();

			    	$res[] = $line;
			    }

			    ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" , "count"=>$total, "data" => $res ));
			    die();
			}
		}
		ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" ,"data" => array() ));
		die();
	} 

	//标签与维度关系
	public function RelationTagType(){

		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		if (Request::instance()->isPost())
		{
			$post = $sysctrl->checkParam(array("type","id","list"));

			if ($post['type'] == "type")
			{//以维度为基准进行管理
			    Db::name('relation_type_tag')->where("typeid",$post['id'])->delete();
			    $tmp = json_decode($post['list'],true);
			    foreach ($tmp as $key => $value) 
			    {
		    		$input = array();
		    		$input['typeid'] = $post['id'];
		    		$input['tagid'] = $value['value'];
		    		Db::name('relation_type_tag')->insert($input);
			    }
				add_log($tokeninfo['uid'], '编辑维度与标签关系', '', json_encode($post,JSON_UNESCAPED_UNICODE));

			    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
			    die();
			}
			elseif ($post['type'] == "tag")
			{//以标签为基准进行管理
			    Db::name('relation_type_tag')->where("tagid",$post['id'])->delete();
			    $tmp = json_decode($post['list'],true);
			    foreach ($tmp as $key => $value) 
			    {
		    		$input = array();
		    		$input['tagid'] = $post['id'];
		    		$input['typeid'] = $value['value'];
		    		Db::name('relation_type_tag')->insert($input);
			    }
				add_log($tokeninfo['uid'], '编辑维度与标签关系', '', json_encode($post,JSON_UNESCAPED_UNICODE));

			    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
			    die();
			}



		}

		ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" ,"data" => array() ));
		die();
	} 


	//C端标签维度
	public function TagClientDimen(){

		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		if (Request::instance()->isPost())
		{
			$post = $sysctrl->checkParam(array("name"));
			$morepost = $sysctrl->getMoreParam(array("power"));

			$input = array();
			$input['name'] = $post['name'];
			$input['power'] = $morepost['power'];

			//检查重复
		    $old = Db::name('tagclient_type')->where("name",$input['name'])->find();
		    if ($old['id'])
		    {
		        ajax_decode(array("errorcode" => 10033,"errormsg"=>"已有相同名称的标签维度存在" , "data" => array()));
		        die();				
		    }
		    Db::name('tagclient_type')->insert($input);

			add_log($tokeninfo['uid'], '新建C端标签维度', '', json_encode($post,JSON_UNESCAPED_UNICODE));

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
		    die();

		}
		elseif (Request::instance()->isPut())
		{
			$post = $sysctrl->checkPutParam(array("name","id"));
			$morepost = $sysctrl->getMorePutParam(array("power"));

			$input = array();
			$input['name'] = $post['name'];
			$input['power'] = $morepost['power'];

			//检查重复
		    $old = Db::name('tagclient_type')->where("name",$input['name'])->where("id <> '".$post['id']."' ")->find();
		    if ($old['id'])
		    {
		        ajax_decode(array("errorcode" => 10033,"errormsg"=>"已有相同名称的标签维度存在" , "data" => array()));
		        die();				
		    }
		    Db::name('tagclient_type')->where("id",$post['id'])->update($input);

			add_log($tokeninfo['uid'], '修改C端标签维度', '', json_encode($post,JSON_UNESCAPED_UNICODE));

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
		    die();

		}
		elseif (Request::instance()->isDelete())
		{
			$post = $sysctrl->checkPutParam(array("id"));

			Db::name('tagclient_type')->where(" id = '".$post['id']."' ")->delete();
			//还要增加关联关系的删除
			Db::name('relation_type_tag_client')->where(" typeid = '".$post['id']."' ")->delete();

			add_log($tokeninfo['uid'], '删除C端标签维度', '', json_encode($post,JSON_UNESCAPED_UNICODE));

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
		    die();

		}
		elseif (Request::instance()->isGet())
		{
			$morepost = $sysctrl->getMoreParam(array("id"));
			if ($morepost['id'])
			{//查询某一个


			}
			else
			{//获取列表
				$morepost = $sysctrl->getMoreParam(array("page",'limit','tagname','field','order'));
		
				if (!$morepost['page']) $morepost['page'] = 1;
				if (!$morepost['limit']) $morepost['limit']= $this->pagelimit;
			    if ($morepost['field']!="" && $morepost['order']!="" )
			    {
			    	$sortstr = $morepost['field']." ".$morepost['order'];
			    }
			    else
			    {
			    	$sortstr = "id desc";
			    }

				$wherestr = " 1=1 ";
				if ($morepost['tagname'] != "")
				{
					$wherestr .= " and name LIKE '%".$morepost['tagname']."%' ";
				}
			    $menus = Db::name('tagclient_type')->field("id")->where($wherestr)->select();
			    $total = count($menus);

			    $res = array();
			    $menus = Db::name('tagclient_type')->where($wherestr)->order($sortstr)->limit((($morepost['page']-1)*$morepost['limit']).",".$morepost['limit'])->select();
			    foreach ($menus as $key => $value) 
			    {
			    	$line = array();
			    	$line = $value;
			    	$line['taglist'] = Db::name('relation_type_tag_client')->alias("a")->field("b.id,b.name")->where("a.typeid",$value['id'])->join("tagclient_list b","a.tagid=b.id","left")->select();

			    	$res[] = $line;
			    }

			    ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" , "count"=>$total, "data" => $res ));
			    die();
			}
		}
		ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" ,"data" => array() ));
		die();
	} 

	//C端标签列表
	public function TagClientList(){

		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		if (Request::instance()->isPost())
		{
			$post = $sysctrl->checkParam(array("name"));

			$input = array();
			$input['name'] = $post['name'];

			//检查重复
		    $old = Db::name('tagclient_list')->where("name",$input['name'])->find();
		    if ($old['id'])
		    {
		        ajax_decode(array("errorcode" => 10033,"errormsg"=>"已有相同名称的标签存在" , "data" => array()));
		        die();				
		    }
		    Db::name('tagclient_list')->insert($input);

			add_log($tokeninfo['uid'], '新建C端标签', '', json_encode($post,JSON_UNESCAPED_UNICODE));

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
		    die();

		}
		elseif (Request::instance()->isPut())
		{
			$post = $sysctrl->checkPutParam(array("name","id"));

			$input = array();
			$input['name'] = $post['name'];

			//检查重复
		    $old = Db::name('tagclient_list')->where("name",$input['name'])->where("id <> '".$post['id']."' ")->find();
		    if ($old['id'])
		    {
		        ajax_decode(array("errorcode" => 10033,"errormsg"=>"已有相同名称的标签存在" , "data" => array()));
		        die();				
		    }
		    Db::name('tagclient_list')->where("id",$post['id'])->update($input);

			add_log($tokeninfo['uid'], '修改C端标签', '', json_encode($post,JSON_UNESCAPED_UNICODE));

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
		    die();

		}
		elseif (Request::instance()->isDelete())
		{
			$post = $sysctrl->checkPutParam(array("id"));

			$tmp = explode(",",$post['id']);
			foreach ($tmp as $key => $value) 
			{
				if ($value)
				{
					Db::name('tagclient_list')->where(" id = '".$value."' ")->delete();
					//还要增加关联关系的删除
					Db::name('relation_type_tag_client')->where("tagid",$value)->delete();
					Db::name('tag_same')->where("ctagid",$value)->delete();
				}
			}

			add_log($tokeninfo['uid'], '删除C端标签', '', json_encode($post,JSON_UNESCAPED_UNICODE));

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
		    die();

		}
		elseif (Request::instance()->isGet())
		{
			$morepost = $sysctrl->getMoreParam(array("id"));
			if ($morepost['id'])
			{//查询某一个


			}
			else
			{//获取列表
				$morepost = $sysctrl->getMoreParam(array("page",'limit','tagname','field','order'));
		
				if (!$morepost['page']) $morepost['page'] = 1;
				if (!$morepost['limit']) $morepost['limit']= $this->pagelimit;
			    if ($morepost['field']!="" && $morepost['order']!="" )
			    {
			    	$sortstr = $morepost['field']." ".$morepost['order'];
			    }
			    else
			    {
			    	$sortstr = "id desc";
			    }

				$wherestr = " 1=1 ";
				if ($morepost['tagname'] != "")
				{
					$wherestr .= " and name LIKE '%".$morepost['tagname']."%' ";
				}
			    $menus = Db::name('tagclient_list')->field("id")->where($wherestr)->select();
			    $total = count($menus);

			    $res = array();
			    $menus = Db::name('tagclient_list')->where($wherestr)->order($sortstr)->limit((($morepost['page']-1)*$morepost['limit']).",".$morepost['limit'])->select();
			    foreach ($menus as $key => $value) 
			    {
			    	$line = array();
			    	$line = $value;
			    	$line['taglist'] = Db::name('relation_type_tag_client')->alias("a")->field("b.id,b.name")->where("a.tagid",$value['id'])->join("tagclient_type b","a.typeid=b.id","left")->select();
			    	$line['samelist'] = Db::name('tag_same')->alias("a")->field("a.btagid,a.samenum,b.name")->where("a.ctagid",$value['id'])->join("tag_list b","a.btagid=b.id","left")->select();

			    	$res[] = $line;
			    }

			    ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" , "count"=>$total, "data" => $res ));
			    die();
			}
		}
		ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" ,"data" => array() ));
		die();
	} 


	//C端标签与维度关系
	public function RelationTagTypeClient(){

		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		if (Request::instance()->isPost())
		{
			$post = $sysctrl->checkParam(array("type","id","list"));

			if ($post['type'] == "type")
			{//以维度为基准进行管理
			    Db::name('relation_type_tag_client')->where("typeid",$post['id'])->delete();
			    $tmp = json_decode($post['list'],true);
			    foreach ($tmp as $key => $value) 
			    {
		    		$input = array();
		    		$input['typeid'] = $post['id'];
		    		$input['tagid'] = $value['value'];
		    		Db::name('relation_type_tag_client')->insert($input);
			    }
				add_log($tokeninfo['uid'], '编辑C端维度与标签关系', '', json_encode($post,JSON_UNESCAPED_UNICODE));

			    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
			    die();
			}
			elseif ($post['type'] == "tag")
			{//以标签为基准进行管理
			    Db::name('relation_type_tag_client')->where("tagid",$post['id'])->delete();
			    $tmp = json_decode($post['list'],true);
			    foreach ($tmp as $key => $value) 
			    {
		    		$input = array();
		    		$input['tagid'] = $post['id'];
		    		$input['typeid'] = $value['value'];
		    		Db::name('relation_type_tag_client')->insert($input);
			    }
				add_log($tokeninfo['uid'], '编辑C端维度与标签关系', '', json_encode($post,JSON_UNESCAPED_UNICODE));

			    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
			    die();
			}

		}

		ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" ,"data" => array() ));
		die();
	} 


	//设置标签相似度
	public function TagSameTagClient(){

		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		if (Request::instance()->isPost())
		{
			$post = $sysctrl->checkParam(array("id","nowindex"));

			Db::name('tag_same')->where("ctagid",$post['id'])->delete();

			for($i=1;$i<=$post['nowindex'];$i++)
			{
				$line = array();
				$line['valueInput'] = Request::instance()->request('valueInput_'.$i); 
				$line['propSelect'] = Request::instance()->request('propSelect_'.$i); 

				if ($line['valueInput'] != "")
				{
					$tmp = explode(",", $line['propSelect']);
					foreach ($tmp as $key => $value) 
					{
						if ($value)
						{
							$input = array();
							$input['ctagid'] = $post['id'];
							$input['btagid'] = $value;
							$input['samenum'] = $line['valueInput'];

							$old = Db::name('tag_same')->where("ctagid",$post['id'])->where("btagid",$value)->find();
							if ($old['id'])
							{
								Db::name('tag_same')->where("id",$old['id'])->update($input);
							}
							else
							{
								Db::name('tag_same')->insert($input);
							}
						}
					}
				}
			}
		}

		ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" ,"data" => array() ));
		die();
	} 

	//目的地管理
	public function Destination(){

		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		if (Request::instance()->isPost())
		{
			$post = $sysctrl->checkParam(array("name","maintypeid","firstcateid","city-picker","address","lng","lat","nowindex"));
			$morepost = $sysctrl->getMoreParam(array("subname","mob","point","consume","imgs","detail","taglist","notforlist","circlelist"));

			$input = array();
			$input['name'] = $post['name'];
			$input['maintypeid'] = $post['maintypeid'];
			$input['firstcateid'] = $post['firstcateid'];
			$tmp = explode("/", $post['city-picker']);
			$input['province'] = $tmp[0]?$tmp[0]:"";
			$input['city'] = $tmp[1]?$tmp[1]:"";
			$input['district'] = $tmp[2]?$tmp[2]:"";
			$input['address'] = $post['address'];
			$input['lng'] = $post['lng'];
			$input['lat'] = $post['lat'];

			$input['subname'] = $morepost['subname']?$morepost['subname']:"";
			$input['mob'] = $morepost['mob']?$morepost['mob']:"";
			$input['point'] = ($morepost['point']!="")?$morepost['point']:"";
			$input['consume'] = ($morepost['consume']!="")?$morepost['consume']:"";
			$input['pics'] = $morepost['imgs']?$morepost['imgs']:"";			
			$input['detail'] = $morepost['detail']?$morepost['detail']:"";

			//检查重复
		    $old = Db::name('destination')->where("name",$input['name'])->find();
		    if ($old['id'])
		    {
		        ajax_decode(array("errorcode" => 10033,"errormsg"=>"已有相同名称的目的地存在" , "data" => array()));
		        die();				
		    }
		    $insertID = Db::name('destination')->insertGetId($input);

		    for($i=1;$i<=$post['nowindex'];$i++)
		    {
				$valueInput = Request::instance()->request('valueInput_'.$i); 
				$propSelect = Request::instance()->request('propSelect_'.$i); 

				if ($valueInput)
				{
					$input = array();
					$input['destinationid'] = $insertID;
					$input['timestart'] = substr($valueInput, 0 , 8);
					$input['timeend'] = substr($valueInput, -8);
					$tmp = explode(",", $propSelect);
					foreach ($tmp as $v) 
					{
						$input['weekid'] = $v;
						Db::name('destination_time')->insert($input);
					}
				}
		    }

		    $tmp = explode(",",$morepost['taglist']);
			foreach ($tmp as $v) 
			{
				if ($v)
				{
					$input = array();
					$input['destinationid'] = $insertID;
					$input['tagid'] = $v;
					Db::name('destination_tag')->insert($input);
				}
			}
		    $tmp = explode(",",$morepost['notforlist']);
			foreach ($tmp as $v) 
			{
				if ($v)
				{
					$input = array();
					$input['destinationid'] = $insertID;
					$input['tagid'] = $v;
					Db::name('destination_untag')->insert($input);
				}
			}
		    $tmp = explode(",",$morepost['circlelist']);
			foreach ($tmp as $v) 
			{
				if ($v)
				{
					$input = array();
					$input['destinationid'] = $insertID;
					$input['circleid'] = $v;
					Db::name('destinationid_circle')->insert($input);
				}
			}


			add_log($tokeninfo['uid'], '新建目的地', '', json_encode($post,JSON_UNESCAPED_UNICODE));

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
		    die();

		}
		elseif (Request::instance()->isPut())
		{
			$post = $sysctrl->checkPutParam(array("id","type"));

			if ($post['type'] == "edit")
			{
				$post = $sysctrl->checkPutParam(array("id","name","maintypeid","firstcateid","city-picker","address","lng","lat","nowindex"));
				$morepost = $sysctrl->getMorePutParam(array("subname","mob","point","consume","imgs","detail","taglist","notforlist","circlelist"));

				$input = array();
				$input['name'] = $post['name'];
				$input['maintypeid'] = $post['maintypeid'];
				$input['firstcateid'] = $post['firstcateid'];
				$tmp = explode("/", $post['city-picker']);
				$input['province'] = $tmp[0]?$tmp[0]:"";
				$input['city'] = $tmp[1]?$tmp[1]:"";
				$input['district'] = $tmp[2]?$tmp[2]:"";
				$input['address'] = $post['address'];
				$input['lng'] = $post['lng'];
				$input['lat'] = $post['lat'];

				$input['subname'] = $morepost['subname']?$morepost['subname']:"";
				$input['mob'] = $morepost['mob']?$morepost['mob']:"";
				$input['point'] = ($morepost['point']!="")?$morepost['point']:"";
				$input['consume'] = ($morepost['consume']!="")?$morepost['consume']:"";
				$input['pics'] = $morepost['imgs']?$morepost['imgs']:"";			
				$input['detail'] = $morepost['detail']?$morepost['detail']:"";

				//检查重复
			    $old = Db::name('destination')->where("name",$input['name'])->where("id <> '".$post['id']."' ")->find();
			    if ($old['id'])
			    {
			        ajax_decode(array("errorcode" => 10033,"errormsg"=>"已有相同名称的目的地存在" , "data" => array()));
			        die();				
			    }
			    Db::name('destination')->where("id",$post['id'])->update($input);

				Db::name('destination_tag')->where("destinationid",$post['id'])->delete();
				Db::name('destination_untag')->where("destinationid",$post['id'])->delete();
				Db::name('destinationid_circle')->where("destinationid",$post['id'])->delete();
				Db::name('destination_time')->where("destinationid",$post['id'])->delete();
			    $tmp = explode(",",$morepost['taglist']);
				foreach ($tmp as $v) 
				{
					if ($v)
					{
						$input = array();
						$input['destinationid'] = $post['id'];
						$input['tagid'] = $v;
						Db::name('destination_tag')->insert($input);
					}
				}
			    $tmp = explode(",",$morepost['notforlist']);
				foreach ($tmp as $v) 
				{
					if ($v)
					{
						$input = array();
						$input['destinationid'] = $post['id'];
						$input['tagid'] = $v;
						Db::name('destination_untag')->insert($input);
					}
				}
			    $tmp = explode(",",$morepost['circlelist']);
				foreach ($tmp as $v) 
				{
					if ($v)
					{
						$input = array();
						$input['destinationid'] = $post['id'];
						$input['circleid'] = $v;
						Db::name('destinationid_circle')->insert($input);
					}
				}

			    for($i=1;$i<=$post['nowindex'];$i++)
			    {
					$valueInput = input("put.".'valueInput_'.$i); 
					$propSelect = input("put.".'propSelect_'.$i); 

					//$valueInput = Request::instance()->request('valueInput_'.$i); 
					//$propSelect = Request::instance()->request('propSelect_'.$i); 

					if ($valueInput)
					{
						$input = array();
						$input['destinationid'] = $post['id'];
						$input['timestart'] = substr($valueInput, 0 , 8);
						$input['timeend'] = substr($valueInput, -8);
						$tmp = explode(",", $propSelect);
						foreach ($tmp as $v) 
						{
							$input['weekid'] = $v;
							Db::name('destination_time')->insert($input);
						}
					}
			    }


				add_log($tokeninfo['uid'], '修改目的地', '', json_encode($post,JSON_UNESCAPED_UNICODE));
			}
			elseif ($post['type'] == "stop")
			{
				Db::name('destination')->where(" id = '".$post['id']."' ")->update(array("status"=>1));
				add_log($tokeninfo['uid'], '停用目的地', '', json_encode($post,JSON_UNESCAPED_UNICODE));
			}
			elseif ($post['type'] == "start")
			{
				Db::name('destination')->where(" id = '".$post['id']."' ")->update(array("status"=>0));
				add_log($tokeninfo['uid'], '启用目的地', '', json_encode($post,JSON_UNESCAPED_UNICODE));
			}
			elseif ($post['type'] == "stopall")
			{
				Db::name('destination')->where(" id in (".$post['id']."0) ")->update(array("status"=>1));
				add_log($tokeninfo['uid'], '停用目的地', '', json_encode($post,JSON_UNESCAPED_UNICODE));
			}
			elseif ($post['type'] == "startall")
			{
				Db::name('destination')->where(" id in (".$post['id']."0) ")->update(array("status"=>0));
				add_log($tokeninfo['uid'], '启用目的地', '', json_encode($post,JSON_UNESCAPED_UNICODE));
			}
			elseif ($post['type'] == "NewBD")
			{
				Db::name('destination')->where(" id = ".$post['id']." ")->update(array("isbdshop"=>1));
				add_log($tokeninfo['uid'], '新增BD商户', '', json_encode($post,JSON_UNESCAPED_UNICODE));
			}
			elseif ($post['type'] == "rmBD")
			{
				Db::name('destination')->where(" id = ".$post['id']." ")->update(array("isbdshop"=>0));
				add_log($tokeninfo['uid'], '删除BD商户', '', json_encode($post,JSON_UNESCAPED_UNICODE));
			}

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
		    die();

		}
		elseif (Request::instance()->isDelete())
		{
			$post = $sysctrl->checkPutParam(array("id"));
			$tmp = explode(",",$post['id']);
			foreach ($tmp as $key => $value) 
			{
				if ($value)
				{
					Db::name('destination')->where(" id = '".$value."' ")->delete();
					//还要增加关联关系的删除
					Db::name('destination_tag')->where("destinationid",$valuevalue)->delete();
					Db::name('destination_untag')->where("destinationid",$value)->delete();
					Db::name('destination_time')->where("destinationid",$value)->delete();
					Db::name('destinationid_circle')->where("destinationid",$value)->delete();
					Db::name('product_list')->where("destinationid",$value)->delete();

					add_log($tokeninfo['uid'], '删除目的地', '', json_encode($post,JSON_UNESCAPED_UNICODE));

				}
			}

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
		    die();

		}
		elseif (Request::instance()->isGet())
		{
			$morepost = $sysctrl->getMoreParam(array("id"));
			if (is_numeric($morepost['id']))
			{//查询某一个


			}
			elseif ($morepost['id'] == "AllForMap")
			{
				$morepost = $sysctrl->getMoreParam(array('searchname','searchmaintype','searchfirst',"city-pickersearch"));
		
				$wherestr = " 1=1 ";
				if ($morepost['searchname'] != "")
				{
					$wherestr .= " and a.name LIKE '%".$morepost['searchname']."%' ";
				}
				if ($morepost['searchmaintype'] != "")
				{
					$wherestr .= " and a.maintypeid = '".$morepost['searchmaintype']."' ";
				}
				if ($morepost['searchfirst'] != "")
				{
					$wherestr .= " and a.firstcateid = '".$morepost['searchfirst']."' ";
				}
				if ($morepost['city-pickersearch'] != "")
				{
					$tmp = explode("/", $morepost['city-pickersearch']);
					if ($tmp[0])
					{
						$wherestr .= " and a.province = '".$tmp[0]."' ";
					}
					if ($tmp[1])
					{
						$wherestr .= " and a.city = '".$tmp[1]."' ";
					}
					if ($tmp[2])
					{
						$wherestr .= " and a.district = '".$tmp[2]."' ";
					}
				}

			    $res = Db::name('destination')->alias("a")->field("a.id,lng,lat,name,maintypeid")->join("destination_tag b","a.id=b.destinationid","left")->where($wherestr)->group("a.id")->select();
			    ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" , "count"=>count($res), "data" => $res ));
			    die();

			}
			elseif ($morepost['id'] == "CantForMap")
			{
			    $res = Db::name('cant_list')->alias("a")->field("a.*")->where("id > 0")->select();
			    ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" , "count"=>count($res), "data" => $res ));
			    die();
			}
			else
			{//获取列表
				$morepost = $sysctrl->getMoreParam(array("page",'limit','searchname','field','order','searchmaintype','searchfirst',"export","city-pickersearch","id"));
		
				if (!$morepost['page']) $morepost['page'] = 1;
				if (!$morepost['limit']) $morepost['limit']= $this->pagelimit;
			    if ($morepost['field']!="" && $morepost['order']!="" )
			    {
			    	$sortstr = $morepost['field']." ".$morepost['order'];
			    }
			    else
			    {
			    	$sortstr = "id desc";
			    }

				$wherestr = " 1=1 ";
				if ($morepost['searchname'] != "")
				{
					$wherestr .= " and a.name LIKE '%".$morepost['searchname']."%' ";
				}
				if ($morepost['searchmaintype'] != "")
				{
					$wherestr .= " and a.maintypeid = '".$morepost['searchmaintype']."' ";
				}
				if ($morepost['searchfirst'] != "")
				{
					$wherestr .= " and a.firstcateid = '".$morepost['searchfirst']."' ";
				}
				if ($morepost['id'] == "IsBD")
				{
					$wherestr .= " and a.isbdshop = '1' ";
				}
				
				if ($morepost['city-pickersearch'] != "")
				{
					$tmp = explode("/", $morepost['city-pickersearch']);
					if ($tmp[0])
					{
						$wherestr .= " and a.province = '".$tmp[0]."' ";
					}
					if ($tmp[1])
					{
						$wherestr .= " and a.city = '".$tmp[1]."' ";
					}
					if ($tmp[2])
					{
						$wherestr .= " and a.district = '".$tmp[2]."' ";
					}
				}

				if ($morepost['export'] == 1)
				{//导出
				    $res = array();
				    $menus = Db::name('destination')->alias("a")->field("a.*,b.name as maintypename,c.name as firstname")->join("base_type b","a.maintypeid=b.id","left")->join("first_cate c","a.firstcateid=c.id","left")->where($wherestr)->select();

					Vendor("PHPExcel.PHPExcel"); 
					Vendor("PHPExcel.PHPExcel.Writer.Excel2007"); 
					 
					$objExcel = new \PHPExcel(); 
					$objWriter = new \PHPExcel_Writer_Excel2007($objExcel);

			   		$objExcel->setActiveSheetIndex(0); 
			    	$objActSheet = $objExcel->getActiveSheet(); 
			    	$objActSheet->setTitle('Matrix'); 
					$rows = array("A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z");

			    	$exportitem = array("评分",
			    						"门店名称",
			    						"人均消费",
			    						"地址",
			    						"电话",
			    						"风格",
			    						"营业周期",
			    						"类型",
			    						"子分类",
			    						"备注",
			    						"人数限制",
			    						"场景用时"
			    					);

			    	$exportall = array();
			    	$exportall[] = $exportitem;
			    	foreach ($menus as $key => $value) 
			    	{
			    		$line = array();
			    		$line[] = $value['point'];
			    		$line[] = $value['name'];
			    		$line[] = $value['consume'];
			    		$line[] = $value['address'];
			    		$line[] = $value['mob'];

				    	$list = Db::name('destination_tag')->alias("a")->field("b.name")->join("tag_list b","a.tagid=b.id","left")->where("a.destinationid",$value['id'])->select();
				    	$str = "";
				    	$i = 0;
				    	foreach ($list as $v) 
				    	{
				    		$str .= $v['name'];
				    		if ($i < count($list) - 1 )
				    		{
				    			$str .= "、";
				    		}
				    		$i++;
				    	}
			    		$line[] = $str;


				    	$str = "";
				    	$list = Db::name('destination_time')->where("destinationid",$value['id'])->group("timestart,timeend")->order("weekid")->select();
				    	$i = 0;
				    	foreach ($list as $v) 
				    	{
				    		$list2 = Db::name('destination_time')->where("destinationid",$value['id'])->where("timestart",$v['timestart'])->where("timeend",$v['timeend'])->order("weekid")->select();

				    		if (count($list2) > 1)
				    		{
				    			$str .= self::getWeekName($list2[0]['weekid'])."至".self::getWeekName($list2[count($list2)-1]['weekid']);
				    			$str .= substr($v['timestart'],0,5)."-".substr($v['timeend'],0,5);
				    		}
				    		else
				    		{
				    			$str .= self::getWeekName($list2[0]['weekid']);
				    			$str .= substr($v['timestart'],0,5)."-".substr($v['timeend'],0,5);
				    		}

				    		if ($i < count($list) - 1 )
				    		{
				    			$str .= "、";
				    		}
				    		$i++;
				    	}
			    		$line[] = $str;

			    		$line[] = $value['maintypename'];
			    		$line[] = $value['firstname'];
			    		$line[] = $value['memo'];
			    		$line[] = $value['minperson']?$value['minperson']."~".$value['maxperson']:"";
			    		$line[] = $value['needtime']?$value['needtime']."min":"";

				    	$list = Db::name('product_list')->where("destinationid",$value['id'])->select();
				    	foreach ($list as $v) 
				    	{
			    			$line[] = $v['name'];

					    	$list = Db::name('product_tag')->alias("a")->field("b.name")->join("tag_list b","a.tagid=b.id","left")->where("a.productid",$value['id'])->select();
					    	$str = "";
					    	$i = 0;
					    	foreach ($list as $v) 
					    	{
					    		$str .= $v['name'];
					    		if ($i < count($list) - 1 )
					    		{
					    			$str .= "、";
					    		}
					    		$i++;
					    	}
				    		$line[] = $str;

			    			$line[] = $v['content']?$v['content']:"";
				    	}

			    		$exportall[] = $line;
			    	}

			    	for($j=0;$j<count($exportall);$j++)
			    	{
			    		$p = $j+1;

				    	for($i=0;$i<count($exportall[$j]);$i++)
				    	{
				    		$x = floor($i/26);
				    		if ($x>0)
				    		{
				    			$a = $rows[$x-1];
				    		}
				    		else
				    		{
				    			$a = "";
				    		}
				    		$x = $i%26;
				    		$b = $rows[$x];

			   				$objActSheet->getStyle($a.$b.$p)->getFont()->setName('Arial');	    			
			   				$objActSheet->getStyle($a.$b.$p)->getFont()->setSize(10);	    
			   				$objActSheet->getStyle($a.$b.$p)->getAlignment()->setWrapText(TRUE);	    
					   		$objActSheet->setCellValue($a.$b.$p, $exportall[$j][$i]);
				    	}
				    }

					$filepath =  "Uploads/images/".date("Y")."/";
					@mkdir($filepath);
					$filepath .= date("m")."/";
					@mkdir($filepath);
					$filepath .= date("d")."/";
					@mkdir($filepath);
					$outputFileName = $filepath."destination"."_".time().rand(10000,99999).".xlsx";     

					$objWriter->save($outputFileName); 

				    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data"=>array("url"=>config('APP_DOMAIN_URL') . $outputFileName)));
				    die();

				}
				else
				{					

				    $menus = Db::name('destination')->alias("a")->field("id")->where($wherestr)->select();
				    $total = count($menus);

				    $res = array();
				    $menus = Db::name('destination')->alias("a")->field("a.*,b.name as maintypename,c.name as firstname")->join("base_type b","a.maintypeid=b.id","left")->join("first_cate c","a.firstcateid=c.id","left")->where($wherestr)->order($sortstr)->limit((($morepost['page']-1)*$morepost['limit']).",".$morepost['limit'])->select();
				    foreach ($menus as $key => $value) 
				    {
				    	$line = array();
				    	$line = $value;
				    	$line['fulladdress'] = $value['address'];
				    	//$line['fulladdress'] = $value['province'].$value['city'].$value['district'].$value['address'];
				    	$line['taglist'] = Db::name('destination_tag')->alias("a")->field("a.tagid,b.name")->where("a.destinationid",$value['id'])->join("tag_list b","a.tagid=b.id","left")->select();
				    	$line['untaglist'] = Db::name('destination_untag')->alias("a")->field("a.tagid,b.name")->where("a.destinationid",$value['id'])->join("tagclient_list b","a.tagid=b.id","left")->select();

				    	$line['opentime'] = array();
				    	$opentimelist = Db::name('destination_time')->where("destinationid",$value['id'])->group("timestart,timeend")->order("timestart asc")->select();
				    	foreach ($opentimelist as $v) 
				    	{
				    		$row = array();
				    		$row['time'] = $v['timestart']." - ".$v['timeend'];
				    		$row['weeklist'] = Db::name('destination_time')->field("weekid")->where("destinationid",$value['id'])->where("timestart",$v['timestart'])->where("timeend",$v['timeend'])->order("weekid asc")->select();
				    		$line['opentime'][] = $row;
				    	}

				    	$res[] = $line;
				    }

				    ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" , "count"=>$total, "data" => $res ));
				    die();
				}
			}
		}
		ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" ,"data" => array() ));
		die();
	} 


	//批量文件导入目的地
	public function DestinationImport(){

		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		$post = $sysctrl->checkParam(array("url"));
		$post['url'] = str_replace(config("APP_DOMAIN_URL"), "", $post['url']);
		$post['url'] = str_replace(config("OSS_CONFIG_file"), "", $post['url']);

		Vendor('PHPExcel.PHPExcel');
		Vendor('PHPExcel.PHPExcel.Reader.Excel5');
		Vendor('PHPExcel.PHPExcel.Reader.Excel2007'); 
	 
		$filePath = $post['url'];  

		$PHPExcel = new \PHPExcel(); 
		$ExcelData = new \PHPExcel_Shared_Date();

		//默认用excel2007读取excel，若格式不对，则用之前的版本进行读取
		$PHPReader = new \PHPExcel_Reader_Excel2007(); 
		if(!$PHPReader->canRead($filePath)){ 
			$PHPReader = new \PHPExcel_Reader_Excel5(); 
			if(!$PHPReader->canRead($filePath)){ 
			    ajax_decode(array("errorcode"=>10041, "errormsg"=>"文件读取错误", "error"=>"文件解析错误", "data"=>array() ));
			    die();
			} 
		}
		try{
			//建立excel对象，此时你即可以通过excel对象读取文件，也可以通过它写入文件  
			$PHPExcel = $PHPReader->load($filePath);   
			//读取excel文件中的第一个工作表
			$currentSheet = $PHPExcel->getSheet(0);  
			//取得最大的列号
			$allColumn = $currentSheet->getHighestColumn();  
			//取得一共有多少行
			$allRow = $currentSheet->getHighestRow(); 
		}catch(Exception $e){
		    ajax_decode(array("errorcode"=>10041, "errormsg"=>"文件解析错误", "error"=>"文件解析错误", "data"=>array() ));
		    die();
		}

		$cellarray = array('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','AA','AB','AC','AD','AE','AF','AG','AH','AI','AJ','AK','AL','AM','AN','AO','AP','AQ','AR','AS','AT','AU','AV','AW','AX','AY','AZ');

		$num = 0;
		$error = "";
		for($rowIndex=2;$rowIndex<=$allRow;$rowIndex++)
		{   
			$line = array();
			foreach ($cellarray as $key => $value) 
			{
				$cellname = $value.$rowIndex;

				$cellvalue = $currentSheet->getCell($cellname)->getValue();  
				if($cellvalue instanceof PHPExcel_RichText || is_object($cellvalue))     //富文本转换字符串  
					$cellvalue = $cellvalue->__toString();  

				if (substr($cellvalue,0,1) == "=")
				{
					$cellvalue = $currentSheet->getCell($cellname)->getCalculatedValue();  
					if($cellvalue instanceof PHPExcel_RichText || is_object($cellvalue))     //富文本转换字符串  
						$cellvalue = $cellvalue->__toString();  
				}

				//cellvalue  每一行每一列
				$line[] = self::characet($cellvalue);
			}

			$input = array();
			//$input['maintypeid'] = 0;
			//$input['firstcateid'] = 0;
			if ($line[1] != "")
			{
				if ($line[7])
				{
					$tmp = Db::name('base_type')->where("name",$line[7])->find();
					if (!$tmp['id'])
					{
						$tmpid = Db::name('base_type')->insertGetId(array("name"=>$line[7]));
						$input['maintypeid'] = $tmpid;
					}
					else
					{
						$input['maintypeid'] = $tmp['id'];
					}
				}

				if ($line[8])
				{
					$tmp = Db::name('first_cate')->where("name",$line[8])->where("baseid",$input['maintypeid'])->find();
					if (!$tmp['id'])
					{
						$tmpid = Db::name('first_cate')->insertGetId(array("name"=>$line[8],"baseid"=>$input['maintypeid']));
						$input['firstcateid'] = $tmpid;
					}
					else
					{
						$input['firstcateid'] = $tmp['id'];
					}
				}

				$input['name'] = $line[1];
				if ($line[0])
				{
					$input['point'] = $line[0];
				}
				if ($line[2])
				{
					$input['consume'] = $line[2];
				}
				if ($line[3])
				{
					$input['address'] = $line[3];
				}
				if ($line[4])
				{
					$input['mob'] = $line[4];
				}

				if ($line[3])
				{
					//解析坐标
					$url = "https://restapi.amap.com/v3/geocode/geo?address=".$input['address']."&output=JSON&key=d7c6689347cfxxxxxxxxxx";
					$jsonres = self::httpGet($url);
					$json = json_decode($jsonres,true);
					$dd = $json['geocodes'][0];
					if ($dd['province'])
					{
						$input['province'] = $dd['province'];
					}
					if ($dd['city'])
					{
						$input['city'] = $dd['city'];
					}
					if ($dd['district'])
					{
						$input['district'] = $dd['district'];
					}
					if ($dd['location'])
					{
						$a = explode(",", $dd['location']);
						$input['lng'] = $a[0];
						$input['lat'] = $a[1];
					}
				}

				$have = Db::name('destination')->where("name",$input['name'])->find();
				if ($have['id'])
				{
					Db::name('destination')->where("id",$have['id'])->update($input);
					$insertid = $have['id'];
				}
				else
				{
					if ((!$input['maintypeid'])||(!$input['firstcateid']))
					{
						//var_dump($input);
						//var_dump($line);
				        ajax_decode(array("errorcode" => 10033,"errormsg"=>$input['name']." 的分类错误" , "data" => array()));
				        die();				
					}
					$insertid = Db::name('destination')->insertGetId($input);
				}

				if ($line[5])
				{
					Db::name('destination_tag')->where("destinationid",$insertid)->delete();
					$tmp = explode("、", $line[5]);

					foreach ($tmp as $key => $value) 
					{
						if ($value)
						{
							$tag = Db::name('tag_list')->where("name",$value)->find();
							if ($tag['id'])
							{
								$tagid = $tag['id'];
							}
							else{
								$tagid = Db::name('tag_list')->insertGetId(array("name"=>$value));
							}
							Db::name('destination_tag')->insert(array("destinationid"=>$insertid,"tagid"=>$tagid));
						}
					}
				}

				if ($line[6])
				{
					Db::name('destination_time')->where("destinationid",$insertid)->delete();
					$tmp = explode("、", $line[6]);
					foreach ($tmp as $key => $value) 
					{
						if ($value)
						{
							$time = substr($value, -11);
							$tmp2 = explode("-", $time);
							if (($tmp2[0] == "")||($tmp2[1] == ""))
							{
								$error .= $line[1].">>"."第".$rowIndex."行营业时间不规范<br>";
							}
							else
							{
								$week = str_replace($time, "", $value);
								$tmp3 = explode("至", $week);
								if ($tmp3[1] == "")
								{//单个的
									$weekid = self::getWeekID($tmp3[0]);

									if (!$weekid)
									{
										$error .= $line[1].">>"."第".$rowIndex."行星期不规范<br>";
									}
									else
									{
										$inputweek = array();
										$inputweek['destinationid'] = $insertid;
										$inputweek['timestart'] = $tmp2[0].":00";
										$inputweek['timeend'] = $tmp2[1].":00";
										$inputweek['weekid'] = $weekid;
										Db::name('destination_time')->insert($inputweek);
									}
								}
								else
								{//两个的
									$weekid1 = self::getWeekID($tmp3[0]);
									$weekid2 = self::getWeekID($tmp3[1]);
									if ((!$weekid1)||(!$weekid2))
									{
										$error .= $line[1].">>"."第".$rowIndex."行星期不规范<br>";
									}
									else
									{
										for($i = $weekid1;$i<=$weekid2;$i++)
										{
											$inputweek = array();
											$inputweek['destinationid'] = $insertid;
											$inputweek['timestart'] = $tmp2[0].":00";
											$inputweek['timeend'] = $tmp2[1].":00";
											$inputweek['weekid'] = $i;
											Db::name('destination_time')->insert($inputweek);
										}
									}
								}
							}
						}
					}
				}
				if ($line[9])
				{
					$input['memo'] = $line[9];
				}
				if ($line[10])
				{
					$tmp = explode("~", $line[10]);
					if (($tmp[0])&&($tmp[1]))
					{
						$input['minperson'] = $tmp[0];
						$input['maxperson'] = $tmp[1];
					}
				}
				if ($line[11])
				{
					if (substr(strtolower($line[11]), -3) == "min") 
					{
						$tmp = strtolower($line[11]);
						$tmp = str_replace("min", "", $tmp);
						$input['needtime'] = $tmp;
					}
					else
					{
						$tmp = strtolower($line[11]);
						$tmp = str_replace("h", "", $tmp);
						$input['needtime'] = $tmp * 60;
					}
				}

				Db::name('product_list')->where("destinationid",$insertid)->delete();
				$startcel = 12;
				for($m=0;$m<10;$m++)
				{
					if ($line[$startcel+$m*3])
					{
						$inputproduct = array();
						$inputproduct['destinationid'] = $insertid;
						$inputproduct['name'] = $line[$startcel+$m*3];
						$inputproduct['content'] = $line[$startcel+$m*3+2]?$line[$startcel+$m*3+2]:"";
						$productid = Db::name('product_list')->insertGetId($inputproduct);

						if ($line[$startcel+$m*3+1])
						{
							$tmp = explode("、", $line[$startcel+$m*3+1]);
							foreach ($tmp as $key => $value) 
							{
								if ($value)
								{
									$tag = Db::name('tag_list')->where("name",$value)->find();
									if ($tag['id'])
									{
										$tagid = $tag['id'];
									}
									else{
										$tagid = Db::name('tag_list')->insertGetId(array("name"=>$value));
									}
									Db::name('product_tag')->insert(array("productid"=>$productid,"tagid"=>$tagid));
								}
							}
						}

					}
				}


			}
		}
		add_log($tokeninfo['uid'], '批量文件导入目的地', '', json_encode($post,JSON_UNESCAPED_UNICODE));

		ajax_decode(array("errorcode" => 0,"errormsg"=>$error ,"code" => 0,"msg"=>"success" ,"data" => array() ));
		die();
	} 


	//批量文件导入目的地
	public function DestinationImportFile2(){

		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		$post = $sysctrl->checkParam(array("url"));
		$post['url'] = str_replace(config("APP_DOMAIN_URL"), "", $post['url']);
		$post['url'] = str_replace(config("OSS_CONFIG_file"), "", $post['url']);

		Vendor('PHPExcel.PHPExcel');
		Vendor('PHPExcel.PHPExcel.Reader.Excel5');
		Vendor('PHPExcel.PHPExcel.Reader.Excel2007'); 
	 
		$filePath = $post['url'];  

$ff = fopen("Uploads/a.txt", "a+");
fwrite($ff, "startfile---".time()."\n");
		$PHPExcel = new \PHPExcel(); 
		$ExcelData = new \PHPExcel_Shared_Date();

		//默认用excel2007读取excel，若格式不对，则用之前的版本进行读取
		$PHPReader = new \PHPExcel_Reader_Excel2007(); 
		if(!$PHPReader->canRead($filePath)){ 
			$PHPReader = new \PHPExcel_Reader_Excel5(); 
			if(!$PHPReader->canRead($filePath)){ 
			    ajax_decode(array("errorcode"=>10041, "errormsg"=>"文件读取错误", "error"=>"文件解析错误", "data"=>array() ));
			    die();
			} 
		}
		try{
			//建立excel对象，此时你即可以通过excel对象读取文件，也可以通过它写入文件  
			$PHPExcel = $PHPReader->load($filePath);   
			//读取excel文件中的第一个工作表
			$currentSheet = $PHPExcel->getSheet(0);  
			//取得最大的列号
			$allColumn = $currentSheet->getHighestColumn();  
			//取得一共有多少行
			$allRow = $currentSheet->getHighestRow(); 
		}catch(Exception $e){
		    ajax_decode(array("errorcode"=>10041, "errormsg"=>"文件解析错误", "error"=>"文件解析错误", "data"=>array() ));
		    die();
		}

		$cellarray = array('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','AA','AB','AC','AD','AE','AF','AG','AH','AI','AJ','AK','AL','AM','AN','AO','AP','AQ','AR','AS','AT','AU','AV','AW','AX','AY','AZ');
fwrite($ff, "startone---".time()."----".$allRow."\n");
//var_dump($allRow);
		$num = 0;
		$error = "";
		for($rowIndex=2;$rowIndex<=$allRow;$rowIndex++)
		{   
			$line = array();
			foreach ($cellarray as $key => $value) 
			{
				$cellname = $value.$rowIndex;

				$cellvalue = $currentSheet->getCell($cellname)->getValue();  
				if($cellvalue instanceof PHPExcel_RichText || is_object($cellvalue))     //富文本转换字符串  
					$cellvalue = $cellvalue->__toString();  

				if (substr($cellvalue,0,1) == "=")
				{
					$cellvalue = $currentSheet->getCell($cellname)->getCalculatedValue();  
					if($cellvalue instanceof PHPExcel_RichText || is_object($cellvalue))     //富文本转换字符串  
						$cellvalue = $cellvalue->__toString();  
				}

				//cellvalue  每一行每一列
				$line[] = self::characet($cellvalue);
			}

			$input = array();
			//$input['maintypeid'] = 0;
			//$input['firstcateid'] = 0;
			if ($line[2] != "")
			{
				if ($line[17])
				{
					$tmp = Db::name('base_type')->where("name",$line[17])->find();
					if (!$tmp['id'])
					{
				        ajax_decode(array("errorcode" => 10033,"errormsg"=>"第".$rowIndex."行".$line[17]."频道不存在" , "data" => array()));
				        die();				
					}
					else
					{
						$input['maintypeid'] = $tmp['id'];
					}
				}

				if ($line[18])
				{
					$tmp = Db::name('first_cate')->where("name",$line[18])->where("baseid",$input['maintypeid'])->find();
					if (!$tmp['id'])
					{
						$tmpid = Db::name('first_cate')->insertGetId(array("name"=>$line[18],"baseid"=>$input['maintypeid']));
						$input['firstcateid'] = $tmpid;
					}
					else
					{
						$input['firstcateid'] = $tmp['id'];
					}
				}

				$input['name'] = $line[2];
				if ($line[6])
				{
					$input['point'] = $line[6];
				}
				if ($line[8])
				{
					$tmp = $line[8];
					$tmp = str_replace("¥", "", $tmp);
					$tmp = str_replace("/人", "", $tmp);
					$tmp = $tmp * 1;
					$input['consume'] = $tmp;
				}
				if ($line[10])
				{
					$input['address'] = $line[10];
				}
				if ($line[16])
				{
					$input['mob'] = $line[16];
				}
fwrite($ff, $rowIndex."---"."1:".time()."\n");
				if (($line[14])&&($line[15]))
				{
					$input['lng'] = $line[15];
					$input['lat'] = $line[14];
					
				}
				if ($line[24])
				{
					$input['memo'] = $line[24];
				}

				$have = Db::name('destination')->where("name",$input['name'])->find();
				if ($have['id'])
				{
					Db::name('destination')->where("id",$have['id'])->update($input);
					$insertid = $have['id'];
				}
				else
				{
					// if ((!$input['maintypeid'])||(!$input['firstcateid']))
					// {
					// 	//var_dump($input);
					// 	//var_dump($line);
				 //        ajax_decode(array("errorcode" => 10033,"errormsg"=>$input['name']." 的分类错误" , "data" => array()));
				 //        die();				
					// }
					// $insertid = Db::name('destination')->insertGetId($input);
					$insertid = 0;
				}
fwrite($ff, $rowIndex."---"."3:".time()."\n");

				if ($line[24])
				{
					Db::name('destination_tag')->where("destinationid",$insertid)->delete();

					$r = preg_match_all("/(.*?)\((.*?)\)/si", $line[24], $match);

					$i = 0;
					foreach ($match[2] as $tagonenum) 
					{
						$tagone = $match[1][$i];
						$tagone = str_replace(" ", "", $tagone);
						if (($tagonenum >= 10)&&($tagonenum < 50))
						{
							$tagone .= "(十)";
						}
						elseif (($tagonenum >= 50)&&($tagonenum < 100))
						{
							$tagone .= "(百)";
						}
						elseif ($tagonenum >= 100)
						{
							$tagone .= "(百+)";
						}

						if ($tagonenum >= 10)
						{
							$tag = Db::name('tag_list')->where("name",$tagone)->find();
							if ($tag['id'])
							{
								$tagid = $tag['id'];
							}
							else{
								$tagid = Db::name('tag_list')->insertGetId(array("name"=>$tagone));
							}
							Db::name('destination_tag')->insert(array("destinationid"=>$insertid,"tagid"=>$tagid));
						}

						$i++;
					}

				}
fwrite($ff, $rowIndex."---"."4:".time()."\n");

				if ($line[20])
				{
					Db::name('destination_time')->where("destinationid",$insertid)->delete();

					$tmp = $line[20];
					$tmp = str_replace("、", "", $tmp);
					$tmp = str_replace("春季", "", $tmp);
					$tmp = str_replace("秋季", "", $tmp);
					$tmp = str_replace("冬季", "", $tmp);
					$tmp = str_replace("夏季", "", $tmp);
					$tmp = str_replace(",", "至", $tmp);

					$t1 = mb_substr($tmp, 0, 1);
					if ($t1 == "周")
					{
						$t2 = mb_substr($tmp, 1, 1);
						$t3 = mb_substr($tmp, 2, 1);
						if($t3 == "至")
						{
							$t4 = mb_substr($tmp, 3, 2);
							$t5 = mb_substr($tmp, 5, 5);
							$t6 = mb_substr($tmp, 10, 1);
							$t7 = mb_substr($tmp, 11, 5);

							$weekid1 = self::getWeekID($t1.$t2);
							$weekid2 = self::getWeekID($t4);
							if ((!$weekid1)||(!$weekid2))
							{
							}
							else
							{
								for($i = $weekid1;$i<=$weekid2;$i++)
								{
									$inputweek = array();
									$inputweek['destinationid'] = $insertid;
									$inputweek['timestart'] = $t5;
									$inputweek['timeend'] = $t7;
									$inputweek['weekid'] = $i;
									//var_dump($inputweek);
									Db::name('destination_time')->insert($inputweek);
								}
							}

							$t4 = mb_substr($tmp, 16, 1);
							if ($t4 == "周")
							{
								$t4 = mb_substr($tmp, 16, 2);
								$t6 = mb_substr($tmp, 19, 2);

								$weekid1 = self::getWeekID($t4);
								$weekid2 = self::getWeekID($t6);
								if ((!$weekid1)||(!$weekid2))
								{
								}
								else
								{

									$t5 = mb_substr($tmp, 21, 5);
									$t7 = mb_substr($tmp, 27, 5);

									for($i = $weekid1;$i<=$weekid2;$i++)
									{
										$inputweek = array();
										$inputweek['destinationid'] = $insertid;
										$inputweek['timestart'] = $t5;
										$inputweek['timeend'] = $t7;
										$inputweek['weekid'] = $i;
										//var_dump($inputweek);
										Db::name('destination_time')->insert($inputweek);
									}
								}


							}
							else
							{


								$t4 = mb_substr($tmp, 18, 1);
								if ($t4 == ":")
								{
									$t5 = mb_substr($tmp, 16, 5);
									$t7 = mb_substr($tmp, 22, 5);

									for($i = $weekid1;$i<=$weekid2;$i++)
									{
										$inputweek = array();
										$inputweek['destinationid'] = $insertid;
										$inputweek['timestart'] = $t5;
										$inputweek['timeend'] = $t7;
										$inputweek['weekid'] = $i;
										//var_dump($inputweek);
										Db::name('destination_time')->insert($inputweek);
									}
								}

								$t4 = mb_substr($tmp, 27, 1);
								if ($t4 == "周")
								{
									$t4 = mb_substr($tmp, 27, 2);
									$t6 = mb_substr($tmp, 30, 2);

									$weekid1 = self::getWeekID($t4);
									$weekid2 = self::getWeekID($t6);
									if ((!$weekid1)||(!$weekid2))
									{
									}
									else
									{

										$t5 = mb_substr($tmp, 32, 5);
										$t7 = mb_substr($tmp, 38, 5);

										for($i = $weekid1;$i<=$weekid2;$i++)
										{
											$inputweek = array();
											$inputweek['destinationid'] = $insertid;
											$inputweek['timestart'] = $t5;
											$inputweek['timeend'] = $t7;
											$inputweek['weekid'] = $i;
											//var_dump($inputweek);
											Db::name('destination_time')->insert($inputweek);
										}
									}

									$t4 = mb_substr($tmp, 45, 1);
									if ($t4 == ":")
									{
										$t5 = mb_substr($tmp, 43, 5);
										$t7 = mb_substr($tmp, 49, 5);

										for($i = $weekid1;$i<=$weekid2;$i++)
										{
											$inputweek = array();
											$inputweek['destinationid'] = $insertid;
											$inputweek['timestart'] = $t5;
											$inputweek['timeend'] = $t7;
											$inputweek['weekid'] = $i;
											//var_dump($inputweek);
											Db::name('destination_time')->insert($inputweek);
										}


									}



								}
								else
								{


									$t4 = mb_substr($tmp, 29, 1);
									if ($t4 == ":")
									{
										$t5 = mb_substr($tmp, 27, 5);
										$t7 = mb_substr($tmp, 33, 5);

										for($i = $weekid1;$i<=$weekid2;$i++)
										{
											$inputweek = array();
											$inputweek['destinationid'] = $insertid;
											$inputweek['timestart'] = $t5;
											$inputweek['timeend'] = $t7;
											$inputweek['weekid'] = $i;
											//var_dump($inputweek);
											Db::name('destination_time')->insert($inputweek);
										}


									}
								}
							}



						}
						else
						{

							$t4 = mb_substr($tmp, 4, 1);
							if ($t4 == ":")
							{
								$weekid1 = self::getWeekID($t1.$t2);
								$weekid2 = self::getWeekID($t1.$t2);
								$t5 = mb_substr($tmp, 2, 5);
								$t7 = mb_substr($tmp, 8, 5);

								if ((!$weekid1)||(!$weekid2))
								{
								}
								else
								{
									for($i = $weekid1;$i<=$weekid2;$i++)
									{
										$inputweek = array();
										$inputweek['destinationid'] = $insertid;
										$inputweek['timestart'] = $t5;
										$inputweek['timeend'] = $t7;
										$inputweek['weekid'] = $i;
										//var_dump($inputweek);
										Db::name('destination_time')->insert($inputweek);
									}
								}

								$t4 = mb_substr($tmp, 13, 1);
								if ($t4 == "周")
								{
									$t4 = mb_substr($tmp, 13, 2);
									$t6 = mb_substr($tmp, 16, 2);

									$weekid1 = self::getWeekID($t4);
									$weekid2 = self::getWeekID($t6);
									if ((!$weekid1)||(!$weekid2))
									{
									}
									else
									{

										$t5 = mb_substr($tmp, 18, 5);
										$t7 = mb_substr($tmp, 24, 5);

										for($i = $weekid1;$i<=$weekid2;$i++)
										{
											$inputweek = array();
											$inputweek['destinationid'] = $insertid;
											$inputweek['timestart'] = $t5;
											$inputweek['timeend'] = $t7;
											$inputweek['weekid'] = $i;
											//var_dump($inputweek);
											Db::name('destination_time')->insert($inputweek);
										}

										$t4 = mb_substr($tmp, 31, 1);
										if ($t4 == ":")
										{
											$t5 = mb_substr($tmp, 29, 5);
											$t7 = mb_substr($tmp, 35, 5);

											for($i = $weekid1;$i<=$weekid2;$i++)
											{
												$inputweek = array();
												$inputweek['destinationid'] = $insertid;
												$inputweek['timestart'] = $t5;
												$inputweek['timeend'] = $t7;
												$inputweek['weekid'] = $i;
												//var_dump($inputweek);
												Db::name('destination_time')->insert($inputweek);
											}


										}



									}


								}




							}



						}
					}

				}
fwrite($ff, $rowIndex."---"."5:".time()."\n");
				

				Db::name('product_list')->where("destinationid",$insertid)->delete();
				$startcel = 25;
				for($m=0;$m<5;$m++)
				{
					if ($line[$startcel+$m*6])
					{
						$inputproduct = array();
						$inputproduct['destinationid'] = $insertid;
						$inputproduct['name'] = $line[$startcel+$m*6];
						$inputproduct['content'] = "";//$line[$startcel+$m*3+2]?$line[$startcel+$m*3+2]:"";
						$productid = Db::name('product_list')->insertGetId($inputproduct);

						

					}
				}
fwrite($ff, $rowIndex."---"."6:".time()."\n");

			}
		}
fclose($ff);		
		add_log($tokeninfo['uid'], '批量文件导入目的地2', '', json_encode($post,JSON_UNESCAPED_UNICODE));

		ajax_decode(array("errorcode" => 0,"errormsg"=>$error ,"code" => 0,"msg"=>"success" ,"data" => array() ));
		die();
	} 


	//目的地主类别
	public function DestinationMain(){

		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		if (Request::instance()->isPost())
		{
			$post = $sysctrl->checkParam(array("name","logo"));

			$input = array();
			$input['name'] = $post['name'];
			$input['logo'] = $post['logo'];

			//检查重复
		    $old = Db::name('base_type')->where("name",$input['name'])->find();
		    if ($old['id'])
		    {
		        ajax_decode(array("errorcode" => 10033,"errormsg"=>"已有相同名称的主类别存在" , "data" => array()));
		        die();				
		    }
		    Db::name('base_type')->insert($input);

			add_log($tokeninfo['uid'], '新建主类别', '', json_encode($post,JSON_UNESCAPED_UNICODE));

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
		    die();

		}
		elseif (Request::instance()->isPut())
		{
			$post = $sysctrl->checkPutParam(array("name","id","logo"));

			$input = array();
			$input['name'] = $post['name'];
			$input['logo'] = $post['logo'];

			//检查重复
		    $old = Db::name('base_type')->where("name",$input['name'])->where("id <> '".$post['id']."' ")->find();
		    if ($old['id'])
		    {
		        ajax_decode(array("errorcode" => 10033,"errormsg"=>"已有相同名称的主类别存在" , "data" => array()));
		        die();				
		    }
		    Db::name('base_type')->where("id",$post['id'])->update($input);

			add_log($tokeninfo['uid'], '修改主类别', '', json_encode($post,JSON_UNESCAPED_UNICODE));

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
		    die();

		}
		elseif (Request::instance()->isDelete())
		{
			$post = $sysctrl->checkPutParam(array("id"));

			Db::name('base_type')->where(" id = '".$post['id']."' ")->delete();
			//还要增加关联关系的删除
			Db::name('first_cate')->where("baseid",$post['id'])->delete();

			//删除该分类下的所有门店
			Db::name('destination')->where(" maintypeid = '".$post['id']."' ")->delete();

			add_log($tokeninfo['uid'], '删除主类别', '', json_encode($post,JSON_UNESCAPED_UNICODE));

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
		    die();

		}
		elseif (Request::instance()->isGet())
		{
			$morepost = $sysctrl->getMoreParam(array("id"));
			if ($morepost['id'])
			{//查询某一个


			}
			else
			{//获取列表
				$morepost = $sysctrl->getMoreParam(array("page",'limit','tagname','field','order'));
		
				if (!$morepost['page']) $morepost['page'] = 1;
				if (!$morepost['limit']) $morepost['limit']= $this->pagelimit;

			    if ($morepost['field']!="" && $morepost['order']!="" )
			    {
			    	$sortstr = $morepost['field']." ".$morepost['order'];
			    }
			    else
			    {
			    	$sortstr = "id desc";
			    }

				$wherestr = " 1=1 ";
				if ($morepost['tagname'] != "")
				{
					$wherestr .= " and name LIKE '%".$morepost['tagname']."%' ";
				}
			    $menus = Db::name('base_type')->field("id")->where($wherestr)->select();
			    $total = count($menus);

			    $res = array();
			    $menus = Db::name('base_type')->where($wherestr)->order($sortstr)->limit((($morepost['page']-1)*$morepost['limit']).",".$morepost['limit'])->select();
			    foreach ($menus as $key => $value) 
			    {
			    	$line = array();
			    	$line = $value;
			    	$line['taglist'] = Db::name('first_cate')->where("baseid",$value['id'])->select();

			    	$res[] = $line;
			    }

			    ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" , "count"=>$total, "data" => $res ));
			    die();
			}
		}
		ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" ,"data" => array() ));
		die();
	} 



	//目的地分类管理
	public function DestinationFirst(){

		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		if (Request::instance()->isPost())
		{
			$post = $sysctrl->checkParam(array("name","baseid"));
			$morepost = $sysctrl->getMoreParam(array("showtext1",'showtext2','showtext3','taglist',"pic","bgpic"));

			$input = array();
			$input['name'] = $post['name'];
			$input['baseid'] = $post['baseid'];
			$input['pic'] = $morepost['pic']?$morepost['pic']:"";
			$input['bgpic'] = $morepost['bgpic']?$morepost['bgpic']:"";
			$showtext = array();
			if ($morepost['showtext1']) $showtext[] = $morepost['showtext1'];
			if ($morepost['showtext2']) $showtext[] = $morepost['showtext2'];
			if ($morepost['showtext3']) $showtext[] = $morepost['showtext3'];
			$input['showtextlist'] = json_encode($showtext,JSON_UNESCAPED_UNICODE);

			//检查重复
		    $old = Db::name('first_cate')->where("name",$input['name'])->where("baseid",$post['baseid'])->find();
		    if ($old['id'])
		    {
		        ajax_decode(array("errorcode" => 10033,"errormsg"=>"该类别下已有相同名称的分类存在" , "data" => array()));
		        die();				
		    }
		    $insertID =  Db::name('first_cate')->insertGetId($input);

		    $tmp = explode(",",$morepost['taglist']);
			foreach ($tmp as $v) 
			{
				if ($v)
				{
					$input = array();
					$input['cateid'] = $insertID;
					$input['tagid'] = $v;
					Db::name('cate_tag')->insert($input);
				}
			}

			add_log($tokeninfo['uid'], '新建分类', '', json_encode($post,JSON_UNESCAPED_UNICODE));

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
		    die();

		}
		elseif (Request::instance()->isPut())
		{

			$morepost = $sysctrl->getMorePutParam(array("event"));
			if ($morepost['event'] == "bind")
			{
				$post = $sysctrl->checkPutParam(array("firstcateid","id","baseid"));

				$update = array();
				$update['maintypeid'] = $post['baseid'];
				$update['firstcateid'] = $post['firstcateid'];
				Db::name('destination')->where("firstcateid",$post['id'])->update($update);

				Db::name('first_cate')->where("id",$post['id'])->delete();

				add_log($tokeninfo['uid'], '合并分类', '', json_encode($post,JSON_UNESCAPED_UNICODE));

			    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
			    die();
			}
			else
			{
				$post = $sysctrl->checkPutParam(array("name","id","baseid"));
				$morepost = $sysctrl->getMorePutParam(array("showtext1",'showtext2','showtext3','taglist',"pic","bgpic"));

				$input = array();
				$input['name'] = $post['name'];
				$input['baseid'] = $post['baseid'];
				$input['pic'] = $morepost['pic']?$morepost['pic']:"";
				$input['bgpic'] = $morepost['bgpic']?$morepost['bgpic']:"";
				$showtext = array();
				if ($morepost['showtext1']) $showtext[] = $morepost['showtext1'];
				if ($morepost['showtext2']) $showtext[] = $morepost['showtext2'];
				if ($morepost['showtext3']) $showtext[] = $morepost['showtext3'];
				$input['showtextlist'] = json_encode($showtext,JSON_UNESCAPED_UNICODE);

				//检查重复
			    $old = Db::name('first_cate')->where("name",$input['name'])->where("baseid",$input['baseid'])->where("id <> '".$post['id']."' ")->find();
			    if ($old['id'])
			    {
			        ajax_decode(array("errorcode" => 10033,"errormsg"=>"该类别下已有相同名称的分类存在" , "data" => array()));
			        die();				
			    }
			    Db::name('first_cate')->where("id",$post['id'])->update($input);

				Db::name('cate_tag')->where("cateid",$post['id'])->delete();
			    $tmp = explode(",",$morepost['taglist']);
				foreach ($tmp as $v) 
				{
					if ($v)
					{
						$input = array();
						$input['cateid'] = $post['id'];
						$input['tagid'] = $v;
						Db::name('cate_tag')->insert($input);
					}
				}

				add_log($tokeninfo['uid'], '修改分类', '', json_encode($post,JSON_UNESCAPED_UNICODE));

			    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
			    die();
			}

		}
		elseif (Request::instance()->isDelete())
		{
			$post = $sysctrl->checkPutParam(array("id"));

			Db::name('first_cate')->where(" id = '".$post['id']."' ")->delete();
			//还要增加关联关系的删除

			//删除该分类下的所有门店
			Db::name('destination')->where(" firstcateid = '".$post['id']."' ")->delete();

			add_log($tokeninfo['uid'], '删除分类', '', json_encode($post,JSON_UNESCAPED_UNICODE));

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
		    die();

		}
		elseif (Request::instance()->isGet())
		{
			$morepost = $sysctrl->getMoreParam(array("id"));
			if ($morepost['id'])
			{//查询某一个


			}
			else
			{//获取列表
				$morepost = $sysctrl->getMoreParam(array("page",'limit','tagname','field','order','searchmaintype','export'));
		
				if (!$morepost['page']) $morepost['page'] = 1;
				if (!$morepost['limit']) $morepost['limit']= $this->pagelimit;

			    if ($morepost['field']!="" && $morepost['order']!="" )
			    {
			    	$sortstr = $morepost['field']." ".$morepost['order'];
			    }
			    else
			    {
			    	$sortstr = "id desc";
			    }

				$wherestr = " 1=1 ";
				if ($morepost['tagname'] != "")
				{
					$wherestr .= " and a.name LIKE '%".$morepost['tagname']."%' ";
				}
				if ($morepost['searchmaintype'] != "")
				{
					$wherestr .= " and a.baseid = '".$morepost['searchmaintype']."' ";
				}

				if ($morepost['export'] == 1)
				{//导出
				    $res = array();
			    	$menus = Db::name('first_cate')->alias("a")->field("a.*,b.name as mainname,count(c.id) as num")->join("base_type b","a.baseid=b.id","left")->join("destination c","a.id=c.firstcateid","left")->where($wherestr)->group("a.id")->order($sortstr)->select();

					Vendor("PHPExcel.PHPExcel"); 
					Vendor("PHPExcel.PHPExcel.Writer.Excel2007"); 
					 
					$objExcel = new \PHPExcel(); 
					$objWriter = new \PHPExcel_Writer_Excel2007($objExcel);

			   		$objExcel->setActiveSheetIndex(0); 
			    	$objActSheet = $objExcel->getActiveSheet(); 
			    	$objActSheet->setTitle('Matrix'); 
					$rows = array("A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z");

			    	$exportitem = array("分类名称",
			    						"所属类别",
			    						"目的地数量",
			    					);

			    	$exportall = array();
			    	$exportall[] = $exportitem;

			    	foreach ($menus as $key => $value) 
			    	{
			    		$line = array();
			    		$line[] = $value['name'];
			    		$line[] = $value['mainname'];
			    		$line[] = $value['num'];

			    		$exportall[] = $line;
			    	}

			    	for($j=0;$j<count($exportall);$j++)
			    	{
			    		$p = $j+1;

				    	for($i=0;$i<count($exportall[$j]);$i++)
				    	{
				    		$x = floor($i/26);
				    		if ($x>0)
				    		{
				    			$a = $rows[$x-1];
				    		}
				    		else
				    		{
				    			$a = "";
				    		}
				    		$x = $i%26;
				    		$b = $rows[$x];

			   				$objActSheet->getStyle($a.$b.$p)->getFont()->setName('Arial');	    			
			   				$objActSheet->getStyle($a.$b.$p)->getFont()->setSize(10);	    
			   				$objActSheet->getStyle($a.$b.$p)->getAlignment()->setWrapText(TRUE);	    
					   		$objActSheet->setCellValue($a.$b.$p, $exportall[$j][$i]);
				    	}
				    }

					$filepath =  "Uploads/images/".date("Y")."/";
					@mkdir($filepath);
					$filepath .= date("m")."/";
					@mkdir($filepath);
					$filepath .= date("d")."/";
					@mkdir($filepath);
					$outputFileName = $filepath."cate"."_".time().rand(10000,99999).".xlsx";     

					$objWriter->save($outputFileName); 

				    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data"=>array("url"=>config('APP_DOMAIN_URL') . $outputFileName)));
				    die();

				}
				else
				{


				    $menus = Db::name('first_cate')->alias("a")->field("id")->where($wherestr)->select();
				    $total = count($menus);

				    $res = array();
				    $menus = Db::name('first_cate')->alias("a")->field("a.*,b.name as mainname,count(c.id) as num")->join("base_type b","a.baseid=b.id","left")->join("destination c","a.id=c.firstcateid","left")->where($wherestr)->group("a.id")->order($sortstr)->limit((($morepost['page']-1)*$morepost['limit']).",".$morepost['limit'])->select();
				    foreach ($menus as $key => $value) 
				    {
				    	$line = array();
				    	$line = $value;
				    	$tmp = json_decode($value['showtextlist'],true);
				    	$line['showtext1'] = $tmp[0]?$tmp[0]:"";
				    	$line['showtext2'] = $tmp[1]?$tmp[1]:"";
				    	$line['showtext3'] = $tmp[2]?$tmp[2]:"";
					    $line['taglist'] = Db::name('cate_tag')->alias("a")->field("a.tagid,b.name")->where("a.cateid",$value['id'])->join("tag_list b","a.tagid=b.id","left")->select();

				    	$res[] = $line;
				    }

				    ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" , "count"=>$total, "data" => $res ));
				    die();
				}
			}
		}
		ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" ,"data" => array() ));
		die();
	} 


	//用户注册的问答
	public function RegQuestion(){

		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		if (Request::instance()->isPost())
		{
			$post = $sysctrl->checkParam(array("name"));

			$input = array();
			$input['name'] = $post['name'];

			//检查重复
		    $old = Db::name('tagclient_list')->where("name",$input['name'])->find();
		    if ($old['id'])
		    {
		        ajax_decode(array("errorcode" => 10033,"errormsg"=>"已有相同名称的标签存在" , "data" => array()));
		        die();				
		    }
		    Db::name('tagclient_list')->insert($input);

			add_log($tokeninfo['uid'], '新建C端标签', '', json_encode($post,JSON_UNESCAPED_UNICODE));

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
		    die();

		}
		elseif (Request::instance()->isPut())
		{
			$post = $sysctrl->checkPutParam(array("name","id"));

			$input = array();
			$input['name'] = $post['name'];

			//检查重复
		    $old = Db::name('tagclient_list')->where("name",$input['name'])->where("id <> '".$post['id']."' ")->find();
		    if ($old['id'])
		    {
		        ajax_decode(array("errorcode" => 10033,"errormsg"=>"已有相同名称的标签存在" , "data" => array()));
		        die();				
		    }
		    Db::name('tagclient_list')->where("id",$post['id'])->update($input);

			add_log($tokeninfo['uid'], '修改C端标签', '', json_encode($post,JSON_UNESCAPED_UNICODE));

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
		    die();

		}
		elseif (Request::instance()->isDelete())
		{
			$post = $sysctrl->checkPutParam(array("id"));

			Db::name('tagclient_list')->where(" id = '".$post['id']."' ")->delete();
			//还要增加关联关系的删除
			Db::name('relation_type_tag_client')->where("tagid",$post['id'])->delete();
			Db::name('tag_same')->where("ctagid",$post['id'])->delete();


			add_log($tokeninfo['uid'], '删除C端标签', '', json_encode($post,JSON_UNESCAPED_UNICODE));

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
		    die();

		}
		elseif (Request::instance()->isGet())
		{
			$morepost = $sysctrl->getMoreParam(array("id"));
			if ($morepost['id'])
			{//查询某一个


			}
			else
			{//获取列表		
				$res = array();

			    $queslist = Db::name('user_question')->order("sortid desc")->select();
			    foreach ($queslist as $key => $value) 
			    {
			    	$line = array();
					$line['id'] = $value['id'];
					$line['title'] = $value['title'];
					$line['type'] = $value['type'];
					$line['status'] = $value['status'];
					$line['options'] = Db::name('user_question_option')->where("quesid",$value['id'])->select();

			    	$res[] = $line;
			    }

			    ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" , "count"=>$total, "data" => $res ));
			    die();
			}
		}
		ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" ,"data" => array() ));
		die();
	} 



	//分类颜色管理
	public function CateColor(){

		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		if (Request::instance()->isPost())
		{
			$post = $sysctrl->checkParam(array("txtcolor","bgcolor","linecolor"));

			$input = array();
			$input['txtcolor'] = $post['txtcolor'];
			$input['bgcolor'] = $post['bgcolor'];
			$input['linecolor'] = $post['linecolor'];
		    $insertID =  Db::name('cate_color_list')->insertGetId($input);

			add_log($tokeninfo['uid'], '新建分类颜色', '', json_encode($post,JSON_UNESCAPED_UNICODE));

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
		    die();

		}
		elseif (Request::instance()->isPut())
		{

			$post = $sysctrl->checkPutParam(array("id","txtcolor","bgcolor","linecolor"));

			$input = array();
			$input['txtcolor'] = $post['txtcolor'];
			$input['bgcolor'] = $post['bgcolor'];
			$input['linecolor'] = $post['linecolor'];

		    Db::name('cate_color_list')->where("id",$post['id'])->update($input);

			add_log($tokeninfo['uid'], '修改分类颜色', '', json_encode($post,JSON_UNESCAPED_UNICODE));

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
		    die();

		}
		elseif (Request::instance()->isDelete())
		{
			$post = $sysctrl->checkPutParam(array("id"));

			Db::name('cate_color_list')->where(" id = '".$post['id']."' ")->delete();

			add_log($tokeninfo['uid'], '删除分类颜色', '', json_encode($post,JSON_UNESCAPED_UNICODE));

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
		    die();

		}
		elseif (Request::instance()->isGet())
		{
			$morepost = $sysctrl->getMoreParam(array("id"));
			if ($morepost['id'])
			{//查询某一个

			}
			else
			{//获取列表
				$morepost = $sysctrl->getMoreParam(array("page",'limit'));
		
				if (!$morepost['page']) $morepost['page'] = 1;
				if (!$morepost['limit']) $morepost['limit']= $this->pagelimit;

			    if ($morepost['field']!="" && $morepost['order']!="" )
			    {
			    	$sortstr = $morepost['field']." ".$morepost['order'];
			    }
			    else
			    {
			    	$sortstr = "id desc";
			    }

				$wherestr = " 1=1 ";

			    $menus = Db::name('cate_color_list')->alias("a")->field("id")->where($wherestr)->select();
			    $total = count($menus);

			    $res = array();
			    $menus = Db::name('cate_color_list')->alias("a")->where($wherestr)->order($sortstr)->limit((($morepost['page']-1)*$morepost['limit']).",".$morepost['limit'])->select();
			    foreach ($menus as $key => $value) 
			    {
			    	$line = array();
			    	$line = $value;
			    	$res[] = $line;
			    }

			    ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" , "count"=>$total, "data" => $res ));
			    die();
			}
		}
		ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" ,"data" => array() ));
		die();
	} 


	//批量文件导入商圈
	public function TradingCircleImport(){

		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		$post = $sysctrl->checkParam(array("url"));
		$post['url'] = str_replace(config("APP_DOMAIN_URL"), "", $post['url']);

		Vendor('PHPExcel.PHPExcel');
		Vendor('PHPExcel.PHPExcel.Reader.Excel5');
		Vendor('PHPExcel.PHPExcel.Reader.Excel2007'); 
	 
		$filePath = $post['url'];  

		$PHPExcel = new \PHPExcel(); 
		$ExcelData = new \PHPExcel_Shared_Date();

		//默认用excel2007读取excel，若格式不对，则用之前的版本进行读取
		$PHPReader = new \PHPExcel_Reader_Excel2007(); 
		if(!$PHPReader->canRead($filePath)){ 
			$PHPReader = new \PHPExcel_Reader_Excel5(); 
			if(!$PHPReader->canRead($filePath)){ 
			    ajax_decode(array("errorcode"=>10041, "errormsg"=>"文件读取错误", "error"=>"文件解析错误", "data"=>array() ));
			    die();
			} 
		}
		try{
			//建立excel对象，此时你即可以通过excel对象读取文件，也可以通过它写入文件  
			$PHPExcel = $PHPReader->load($filePath);   
			//读取excel文件中的第一个工作表
			$currentSheet = $PHPExcel->getSheet(0);  
			//取得最大的列号
			$allColumn = $currentSheet->getHighestColumn();  
			//取得一共有多少行
			$allRow = $currentSheet->getHighestRow(); 
		}catch(Exception $e){
		    ajax_decode(array("errorcode"=>10041, "errormsg"=>"文件解析错误", "error"=>"文件解析错误", "data"=>array() ));
		    die();
		}

		$cellarray = array('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','AA','AB','AC','AD','AE','AF','AG','AH','AI','AJ','AK','AL','AM','AN','AO','AP','AQ','AR','AS','AT','AU','AV','AW','AX','AY','AZ');

		$num = 0;
		$error = "";
		for($rowIndex=1;$rowIndex<=$allRow;$rowIndex++)
		{   
			$line = array();
			foreach ($cellarray as $key => $value) 
			{
				$cellname = $value.$rowIndex;

				$cellvalue = $currentSheet->getCell($cellname)->getValue();  
				if($cellvalue instanceof PHPExcel_RichText || is_object($cellvalue))     //富文本转换字符串  
					$cellvalue = $cellvalue->__toString();  

				if (substr($cellvalue,0,1) == "=")
				{
					$cellvalue = $currentSheet->getCell($cellname)->getCalculatedValue();  
					if($cellvalue instanceof PHPExcel_RichText || is_object($cellvalue))     //富文本转换字符串  
						$cellvalue = $cellvalue->__toString();  
				}

				//cellvalue  每一行每一列
				$line[] = self::characet($cellvalue);
			}

			if ($line[0])
			{
				$typeinfo = Db::name('circle_type')->where("name",$line[0])->find();
				if ($typeinfo['id'])
				{
					$typeid = $typeinfo['id'];
				}
				else
				{
					$input = array();
					$input['name'] = $line[0];
					$typeid = Db::name('circle_type')->insertGetId($input);
				}

				for($i=2;$i<=52;$i++)
				{
					if ($line[$i])
					{

						$info = Db::name('circle_list')->where("name",$line[$i])->find();
						if ($info['id'])
						{
							$circleid = $info['id'];
						}
						else
						{
							$input = array();
							$input['name'] = $line[$i];

							//解析坐标
							$url = "https://restapi.amap.com/v3/geocode/geo?address=".$line[$i]."&output=JSON&key=d7c6689347cfxxxxxxxxxx&city=广州市";
							$jsonres = self::httpGet($url);
							$json = json_decode($jsonres,true);
							$dd = $json['geocodes'][0];
							if ($dd['province'])
							{
								$input['province'] = $dd['province'];
							}
							if ($dd['city'])
							{
								$input['city'] = $dd['city'];
							}
							if ($dd['district'])
							{
								$input['district'] = $dd['district'];
							}
							if ($dd['location'])
							{
								$a = explode(",", $dd['location']);
								$input['lng'] = $a[0];
								$input['lat'] = $a[1];
							}
							$circleid = Db::name('circle_list')->insertGetId($input);
						}

						$rel = Db::name('circle_relation')->where("typeid",$typeid)->where("circleid",$circleid)->find();
						if (!$rel['id'])
						{
							$input = array();
							$input['typeid'] = $typeid;
							$input['circleid'] = $circleid;
							$relid = Db::name('circle_relation')->insertGetId($input);
						}
					}
				}
			}

		}

		ajax_decode(array("errorcode" => 0,"errormsg"=>$error ,"code" => 0,"msg"=>"success" ,"data" => array() ));
		die();
	} 

	//商圈管理
	public function TradingCircle(){

		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		if (Request::instance()->isPost())
		{
			$post = $sysctrl->checkParam(array("name","maintypeid","city-picker","lng","lat"));

			$input = array();
			$input['name'] = $post['name'];
			$tmp = explode("/", $post['city-picker']);
			$input['province'] = $tmp[0]?$tmp[0]:"";
			$input['city'] = $tmp[1]?$tmp[1]:"";
			$input['district'] = $tmp[2]?$tmp[2]:"";
			$input['lng'] = $post['lng'];
			$input['lat'] = $post['lat'];

			//检查重复
		    $old = Db::name('circle_list')->where("name",$input['name'])->find();
		    if ($old['id'])
		    {
		        ajax_decode(array("errorcode" => 10033,"errormsg"=>"已有相同名称的商圈存在" , "data" => array()));
		        die();				
		    }
		    $insertID = Db::name('circle_list')->insertGetId($input);

		    $tmp = explode(",",$post['maintypeid']);
			foreach ($tmp as $v) 
			{
				if ($v)
				{
					$input = array();
					$input['circleid'] = $insertID;
					$input['typeid'] = $v;
					Db::name('circle_relation')->insert($input);
				}
			}

			add_log($tokeninfo['uid'], '新建商圈', '', json_encode($post,JSON_UNESCAPED_UNICODE));

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
		    die();

		}
		elseif (Request::instance()->isPut())
		{
			$post = $sysctrl->checkPutParam(array("id","type"));

			if ($post['type'] == "edit")
			{
				$post = $sysctrl->checkPutParam(array("id","name","maintypeid","city-picker","lng","lat"));

				$input = array();
				$input['name'] = $post['name'];
				$tmp = explode("/", $post['city-picker']);
				$input['province'] = $tmp[0]?$tmp[0]:"";
				$input['city'] = $tmp[1]?$tmp[1]:"";
				$input['district'] = $tmp[2]?$tmp[2]:"";
				$input['lng'] = $post['lng'];
				$input['lat'] = $post['lat'];

				//检查重复
			    $old = Db::name('circle_list')->where("name",$input['name'])->where("id <> '".$post['id']."' ")->find();
			    if ($old['id'])
			    {
			        ajax_decode(array("errorcode" => 10033,"errormsg"=>"已有相同名称的商圈存在" , "data" => array()));
			        die();				
			    }
			    Db::name('circle_list')->where("id",$post['id'])->update($input);

				Db::name('circle_relation')->where("circleid",$post['id'])->delete();
			    $tmp = explode(",",$post['maintypeid']);
				foreach ($tmp as $v) 
				{
					if ($v)
					{
						$input = array();
						$input['circleid'] = $post['id'];
						$input['typeid'] = $v;
						Db::name('circle_relation')->insert($input);
					}
				}

				add_log($tokeninfo['uid'], '修改商圈', '', json_encode($post,JSON_UNESCAPED_UNICODE));
			}

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
		    die();

		}
		elseif (Request::instance()->isDelete())
		{
			$post = $sysctrl->checkPutParam(array("id"));

			Db::name('circle_list')->where(" id = '".$post['id']."' ")->delete();
			//还要增加关联关系的删除
			Db::name('circle_relation')->where("circleid",$post['id'])->delete();

			add_log($tokeninfo['uid'], '删除商圈', '', json_encode($post,JSON_UNESCAPED_UNICODE));

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
		    die();

		}
		elseif (Request::instance()->isGet())
		{
			$morepost = $sysctrl->getMoreParam(array("id"));
			if (is_numeric($morepost['id']))
			{//查询某一个


			}
			elseif ($morepost['id'] == "AllForMap")
			{
			    $res = Db::name('circle_list')->field("lng,lat,name")->select();
			    ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" , "count"=>count($res), "data" => $res ));
			    die();

			}
			else
			{//获取列表
				$morepost = $sysctrl->getMoreParam(array("page",'limit','searchname','field','order','searchmaintype',"export"));
		
				if (!$morepost['page']) $morepost['page'] = 1;
				if (!$morepost['limit']) $morepost['limit']= $this->pagelimit;
			    if ($morepost['field']!="" && $morepost['order']!="" )
			    {
			    	$sortstr = $morepost['field']." ".$morepost['order'];
			    }
			    else
			    {
			    	$sortstr = "id desc";
			    }

				$wherestr = " 1=1 ";
				if ($morepost['searchname'] != "")
				{
					$wherestr .= " and a.name LIKE '%".$morepost['searchname']."%' ";
				}
				if ($morepost['searchmaintype'] != "")
				{
					$wherestr .= " and b.typeid = '".$morepost['searchmaintype']."' ";
				}

				if ($morepost['export'] == 1)
				{//导出
				    
				}
				else
				{					

				    $menus = Db::name('circle_list')->alias("a")->field("a.id")->where($wherestr)->join("circle_relation b","a.id=b.circleid","right")->select();
				    $total = count($menus);

				    $res = array();
				    $menus = Db::name('circle_list')->alias("a")->field("a.*")->where($wherestr)->join("circle_relation b","a.id=b.circleid","right")->order($sortstr)->limit((($morepost['page']-1)*$morepost['limit']).",".$morepost['limit'])->select();
				    foreach ($menus as $key => $value) 
				    {
				    	$line = array();
				    	$line = $value;
				    	$line['taglist'] = Db::name('circle_relation')->alias("a")->field("b.id,b.name")->join("circle_type b","a.typeid=b.id","left")->where("a.circleid",$value['id'])->select();

				    	$res[] = $line;
				    }

				    ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" , "count"=>$total, "data" => $res ));
				    die();
				}
			}
		}
		ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" ,"data" => array() ));
		die();
	} 

	//用户管理
	public function WebUser(){

		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		if (Request::instance()->isPost())
		{
			

		}
		elseif (Request::instance()->isPut())
		{
			$post = $sysctrl->checkPutParam(array("opt","id"));

			if ($post['opt'] == "CLEARBOXS")
			{
		    	Db::name('box_pre_list')->where("uid",$post['id'])->delete();
		    	Db::name('box_list')->where("uid",$post['id'])->delete();
				add_log($tokeninfo['uid'], '清空开盒记录', '', json_encode($post,JSON_UNESCAPED_UNICODE));
			}
			elseif ($post['opt'] == "CLEARTAGS")
			{
		    	Db::name('user_tag')->where("uid",$post['id'])->delete();
		    	Db::name('web_user')->where("id",$post['id'])->update(array("name"=>"","sex"=>0,"age"=>0,"isovertag"=>0));
				add_log($tokeninfo['uid'], '清空标签', '', json_encode($post,JSON_UNESCAPED_UNICODE));
			}
			elseif ($post['opt'] == "Edit")
			{
				$post = $sysctrl->checkPutParam(array("id","avatar","name","sex"));
				$update = array();
				$update['name'] = $post['name'];
				$update['avatar'] = $post['avatar'];
				$update['sex'] = $post['sex'];
		    	Db::name('web_user')->where("id",$post['id'])->update($update);				
			}


		    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
		    die();

		}
		elseif (Request::instance()->isDelete())
		{
			

		}
		elseif (Request::instance()->isGet())
		{
			$morepost = $sysctrl->getMoreParam(array("id"));
			if ($morepost['id'])
			{//查询某一个

			}
			else
			{//获取列表
				$morepost = $sysctrl->getMoreParam(array("page",'limit','searchmob','searchname','field','order','searchmaintype','searchopened'));
		
				if (!$morepost['page']) $morepost['page'] = 1;
				if (!$morepost['limit']) $morepost['limit']= $this->pagelimit;

			    if ($morepost['field']!="" && $morepost['order']!="" )
			    {
			    	$sortstr = $morepost['field']." ".$morepost['order'];
			    }
			    else
			    {
			    	$sortstr = "regtime desc";
			    }

				$wherestr = " 1=1 ";
				if ($morepost['searchmob'] != "")
				{
					$wherestr .= " and mob LIKE '%".$morepost['searchmob']."%' ";
				}
				if ($morepost['searchname'] != "")
				{
					$wherestr .= " and name LIKE '%".$morepost['searchname']."%' ";
				}
				if ($morepost['searchmaintype'] != "")
				{
					if ($morepost['searchmaintype'] == "1")
					{
						$wherestr .= " and iscreated = 1 ";
					}
					else
					{
						$wherestr .= " and iscreated IS NULL ";
					}
				}
				if ($morepost['searchopened'] != "")
				{
					if ($morepost['searchopened'] == 1)
					{
						$wherestr .= " and b.istmp = 1 and b.id > 0 ";
					}
					elseif ($morepost['searchopened'] == 2)
					{
						$wherestr .= " and b.id IS NULL ";
					}

				}



			    $menus = Db::name('web_user')->alias("a")->field("a.id")->join("box_list b","a.id=b.uid","left")->where($wherestr)->group("a.id")->select();
			    $total = count($menus);

			    $res = array();
			    $menus = Db::name('web_user')->alias("a")->field("a.*")->join("box_list b","a.id=b.uid","left")->where($wherestr)->order($sortstr)->group("a.id")->limit((($morepost['page']-1)*$morepost['limit']).",".$morepost['limit'])->select();
			    foreach ($menus as $key => $value) 
			    {
			    	$line = array();
			    	$line = $value;
			    	$line['openednum'] = Db::name('box_list')->field("id")->where("uid",$value['id'])->where("istmp",1)->count();
				    $line['taglist'] = Db::name('user_tag')->alias("a")->field("b.id,b.name")->join("tagclient_list b","a.tagid=b.id","left")->where("a.uid",$value['id'])->select();

				    if ((!$line['area'])&&($line['ipaddress']))
				    {
				    	$url = "https://restapi.amap.com/v5/ip?key=d7c6689347cfcxxxxxxx&type=4&ip=".$line['ipaddress'];
						$jsonres = self::httpGet($url);
						$json = json_decode($jsonres,true);
						$area = $json['province'].$json['city'];
						if ($area)
						{
							$line['area'] = $area;
							Db::name('web_user')->where("id",$line['id'])->update(array("area"=>$area));
						}
				    }


			    	$res[] = $line;
			    }

			    ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" , "count"=>$total, "data" => $res ));
			    die();
			}
		}
		ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" ,"data" => array() ));
		die();
	} 

	//产品方案
	public function DestinationProduct(){

		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		if (Request::instance()->isPost())
		{
			$post = $sysctrl->checkParam(array("name","destinationid","nowindex"));
			$morepost = $sysctrl->getMoreParam(array("taglist","content","times","pic","number","saleprice","price"));

			$input = array();
			$input['destinationid'] = $post['destinationid'];
			$input['name'] = $post['name'];
			$input['content'] = $morepost['content']?$morepost['content']:"";
			$input['times'] = $morepost['times']?$morepost['times']:"";
			$input['pic'] = $morepost['pic']?$morepost['pic']:"";
			$input['number'] = $morepost['number']?$morepost['number']:"";
			$input['saleprice'] = $morepost['saleprice']?$morepost['saleprice']:"";
			$input['price'] = $morepost['price']?$morepost['price']:"";

			//检查重复
		    $old = Db::name('product_list')->where("name",$input['name'])->where("destinationid",$input['destinationid'])->find();
		    if ($old['id'])
		    {
		        ajax_decode(array("errorcode" => 10033,"errormsg"=>"该目的地已有相同名称的方案存在" , "data" => array()));
		        die();				
		    }
		    $insertID = Db::name('product_list')->insertGetId($input);

		    $tmp = explode(",",$morepost['taglist']);
			foreach ($tmp as $v) 
			{
				if ($v)
				{
					$input = array();
					$input['productid'] = $insertID;
					$input['tagid'] = $v;
					Db::name('product_tag')->insert($input);
				}
			}

		    for($i=1;$i<=$post['nowindex'];$i++)
		    {
				$valueInput = Request::instance()->request('valueInput_'.$i); 
				$propSelect = Request::instance()->request('propSelect_'.$i); 

				if ($valueInput)
				{
					$input = array();
					$input['productid'] = $insertID;
					$input['timestart'] = substr($valueInput, 0 , 8);
					$input['timeend'] = substr($valueInput, -8);
					$tmp = explode(",", $propSelect);
					foreach ($tmp as $v) 
					{
						$input['weekid'] = $v;
						Db::name('product_time')->insert($input);
					}
				}
		    }


			add_log($tokeninfo['uid'], '新建方案产品', '', json_encode($post,JSON_UNESCAPED_UNICODE));

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
		    die();

		}
		elseif (Request::instance()->isPut())
		{
			$post = $sysctrl->checkPutParam(array("id","name","destinationid","nowindex"));
			$morepost = $sysctrl->getMorePutParam(array("taglist","content","times","pic","number","saleprice","price"));

			$input = array();
			$input['name'] = $post['name'];
			$input['destinationid'] = $post['destinationid'];
			$input['content'] = $morepost['content']?$morepost['content']:"";
			$input['times'] = $morepost['times']?$morepost['times']:"";
			$input['pic'] = $morepost['pic']?$morepost['pic']:"";
			$input['number'] = $morepost['number']?$morepost['number']:"";
			$input['saleprice'] = $morepost['saleprice']?$morepost['saleprice']:"";
			$input['price'] = $morepost['price']?$morepost['price']:"";

			//检查重复
		    $old = Db::name('product_list')->where("name",$input['name'])->where("destinationid",$input['destinationid'])->where("id <> '".$post['id']."' ")->find();
		    if ($old['id'])
		    {
		        ajax_decode(array("errorcode" => 10033,"errormsg"=>"该目的地已有相同名称的方案存在" , "data" => array()));
		        die();				
		    }
		    Db::name('product_list')->where("id",$post['id'])->update($input);
		    
		    Db::name('product_tag')->where("productid",$post['id'])->delete();
		    Db::name('product_time')->where("productid",$post['id'])->delete();
		    $tmp = explode(",",$morepost['taglist']);
			foreach ($tmp as $v) 
			{
				if ($v)
				{
					$input = array();
					$input['productid'] = $post['id'];
					$input['tagid'] = $v;
					Db::name('product_tag')->insert($input);
				}
			}
		    for($i=1;$i<=$post['nowindex'];$i++)
		    {
				$valueInput = input("put.".'valueInput_'.$i); 
				$propSelect = input("put.".'propSelect_'.$i); 

				if ($valueInput)
				{
					$input = array();
					$input['productid'] = $post['id'];
					$input['timestart'] = substr($valueInput, 0 , 8);
					$input['timeend'] = substr($valueInput, -8);
					$tmp = explode(",", $propSelect);
					foreach ($tmp as $v) 
					{
						$input['weekid'] = $v;
						Db::name('product_time')->insert($input);
					}
				}
		    }

			add_log($tokeninfo['uid'], '修改方案产品', '', json_encode($post,JSON_UNESCAPED_UNICODE));

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
		    die();

		}
		elseif (Request::instance()->isDelete())
		{
			$post = $sysctrl->checkPutParam(array("id"));

			Db::name('product_list')->where(" id = '".$post['id']."' ")->delete();
			//还要增加关联关系的删除
			Db::name('product_tag')->where(" productid = '".$post['id']."' ")->delete();
			Db::name('product_time')->where(" productid = '".$post['id']."' ")->delete();

			add_log($tokeninfo['uid'], '删除产品方案', '', json_encode($post,JSON_UNESCAPED_UNICODE));

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
		    die();

		}
		elseif (Request::instance()->isGet())
		{
			$morepost = $sysctrl->getMoreParam(array("id"));
			if ($morepost['id'])
			{//查询某一个


			}
			else
			{//获取列表
				$morepost = $sysctrl->getMoreParam(array("page",'limit','tagname','field','order','searchmaintype'));
		
				if (!$morepost['page']) $morepost['page'] = 1;
				if (!$morepost['limit']) $morepost['limit']= $this->pagelimit;
			    if ($morepost['field']!="" && $morepost['order']!="" )
			    {
			    	$sortstr = $morepost['field']." ".$morepost['order'];
			    }
			    else
			    {
			    	$sortstr = "a.id desc";
			    }

				$wherestr = " 1=1 ";
				if ($morepost['tagname'] != "")
				{
					$wherestr .= " and a.name LIKE '%".$morepost['tagname']."%' ";
				}
				if ($morepost['searchmaintype'] != "")
				{
					$wherestr .= " and a.destinationid in (".$morepost['searchmaintype'].") ";
				}
			    $menus = Db::name('product_list')->alias("a")->field("a.id")->where($wherestr)->select();
			    $total = count($menus);

			    $res = array();
			    $menus = Db::name('product_list')->alias("a")->field("a.*,b.name as destinationname")->join("destination b","a.destinationid=b.id","left")->where($wherestr)->order($sortstr)->limit((($morepost['page']-1)*$morepost['limit']).",".$morepost['limit'])->select();
			    foreach ($menus as $key => $value) 
			    {
			    	$line = array();
			    	$line = $value;
			    	$line['taglist'] = Db::name('product_tag')->alias("a")->field("b.id,b.name")->where("a.productid",$value['id'])->join("tag_list b","a.tagid=b.id","left")->select();

				    $line['opentime'] = array();
			    	$opentimelist = Db::name('product_time')->where("productid",$value['id'])->group("timestart,timeend")->order("timestart asc")->select();
			    	foreach ($opentimelist as $v) 
			    	{
			    		$row = array();
			    		$row['time'] = $v['timestart']." - ".$v['timeend'];
			    		$row['weeklist'] = Db::name('product_time')->field("weekid")->where("productid",$value['id'])->where("timestart",$v['timestart'])->where("timeend",$v['timeend'])->order("weekid asc")->select();
			    		$line['opentime'][] = $row;
			    	}

			    	$res[] = $line;
			    }

			    ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" , "count"=>$total, "data" => $res ));
			    die();
			}
		}
		ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" ,"data" => array() ));
		die();
	} 

	//用户Box管理
	public function WebUserBox(){

		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		if (Request::instance()->isPost())
		{

		}
		elseif (Request::instance()->isPut())
		{

		}
		elseif (Request::instance()->isDelete())
		{
		}
		elseif (Request::instance()->isGet())
		{
			$morepost = $sysctrl->getMoreParam(array("id"));

	    	$sortstr = "a.id desc";

			$wherestr = " a.uid ='".$morepost['id']."' ";

		    $menus = Db::name('box_pre_list')->alias("a")->field("id")->where($wherestr)->select();
		    $total = count($menus);

		    $res = array();
		    $menus = Db::name('box_pre_list')->alias("a")->field("a.*,b.name as catename,c.destinationid as realdestinationid")->join("first_cate b","a.firstcateid=b.id","left")->join("box_list c","a.boxid=c.id","left")->where($wherestr)->order($sortstr)->select();
		    foreach ($menus as $key => $value) 
		    {
		    	$line = array();
		    	$line = $value;
		    	$line['isseled'] = 0;
		    	if ($value['realdestinationid'] == $value['destinationid'])
		    	{
		    		$line['isseled'] = 1;
		    	}
		    	// $line['openednum'] = Db::name('box_list')->field("id")->where("uid",$value['id'])->count();
			    // $line['taglist'] = Db::name('user_tag')->alias("a")->field("b.id,b.name")->join("tagclient_list b","a.tagid=b.id","left")->where("a.uid",$value['id'])->select();

		    	$res[] = $line;
		    }

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" , "count"=>$total, "data" => $res ));
		    die();

		}
		ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" ,"data" => array() ));
		die();
	} 



	//数据统计
	public function StatisticData(){

		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		if (Request::instance()->isPost())
		{

		}
		elseif (Request::instance()->isPut())
		{

		}
		elseif (Request::instance()->isDelete())
		{
		}
		elseif (Request::instance()->isGet())
		{
			$post = $sysctrl->checkParam(array("type"));

			$res = array();
			if ($post['type'] == "user")
			{
		    	$res['totalweek'] = Db::name('web_user')->field("id")->where("regtime >= '".date("Y-m-d H:i:s",strtotime("-7 days"))."'")->where("iscreated IS NULL")->count();
		    	$res['totalall'] = Db::name('web_user')->field("id")->where("id>0")->where("iscreated IS NULL")->count();

		    	$res['appweek'] = Db::name('web_user')->field("id")->where("iscreated IS NULL")->where("regtime >= '".date("Y-m-d H:i:s",strtotime("-7 days"))."'")->where("channel","app")->count();
		    	$res['appall'] = Db::name('web_user')->field("id")->where("iscreated IS NULL")->where("channel","app")->count();

		    	$res['miniweek'] = Db::name('web_user')->field("id")->where("iscreated IS NULL")->where("regtime >= '".date("Y-m-d H:i:s",strtotime("-7 days"))."'")->where("channel","mini")->count();
		    	$res['miniall'] = Db::name('web_user')->field("id")->where("iscreated IS NULL")->where("channel","mini")->count();

		    	$categorylist = array();
		    	$totallist = array();
		    	$applist = array();
		    	$minilist = array();
		    	for($i=29;$i>=0;$i--)
		    	{
		    		$tmpmd = date("m-d",strtotime("-".$i." days"));
		    		$categorylist[] = $tmpmd;

			    	$totalall = Db::name('web_user')->field("id")->where("iscreated IS NULL")->where("regtime >= '".date("Y")."-".$tmpmd." 00:00:00' and regtime <= '".date("Y")."-".$tmpmd." 23:59:59'" )->count();
			    	$totallist[] = $totalall;

			    	$totalweek = Db::name('web_user')->field("id")->where("iscreated IS NULL")->where("regtime >= '".date("Y")."-".$tmpmd." 00:00:00' and regtime <= '".date("Y")."-".$tmpmd." 23:59:59'" )->where("channel","mini")->count();
			    	$minilist[] = $totalweek;

			    	$totalapp = Db::name('web_user')->field("id")->where("iscreated IS NULL")->where("regtime >= '".date("Y")."-".$tmpmd." 00:00:00' and regtime <= '".date("Y")."-".$tmpmd." 23:59:59'" )->where("channel","app")->count();
			    	$applist[] = $totalapp;

		    	}
		    	$res['categorylist'] = $categorylist;
		    	$res['totallist'] = $totallist;
		    	$res['applist'] = $applist;
		    	$res['minilist'] = $minilist;


			}
			elseif ($post['type'] == "box")
			{

		    	$categorylist = array();
		    	$totallist = array();
		    	$applist = array();
		    	$minilist = array();
		    	$openlist = array();
		    	$totaluseralllist = array();
		    	for($i=29;$i>=0;$i--)
		    	{
		 			$date = date("Y-m-d",strtotime("-".$i." days"));

					$userlist = Db::name('web_user')->field("id")->where("iscreated IS NULL")->where("regtime >= '".$date." 00:00:00' and regtime <= '".$date." 23:59:59'" )->select();
					$nextnum = 0;
					$next7num = 0;
					foreach ($userlist as $key => $value) 
					{
						$nextdata = date("Y-m-d",strtotime($date." +1 days"));

						$next7data = date("Y-m-d",strtotime($date." +7 days"));

						$nexttime = Db::name('checkbox_log')->where("uid",$value['id'])->where("time >= '".$nextdata." 00:00:00' and time <= '".$nextdata." 23:59:59'")->count();
						if ($nexttime)
						{
							$nextnum++;
						}

						$next7time = Db::name('checkbox_log')->where("uid",$value['id'])->where("time >= '".$next7data." 00:00:00' and time <= '".$next7data." 23:59:59'")->count();
						if ($next7time)
						{
							$next7num++;
						}


					}
					$openboxnum = Db::name('checkbox_log')->where("time >= '".$date." 00:00:00' and time <= '".$date." 23:59:59'")->count();

					$todayopenboxnum = Db::name('box_pre_list')->where("createtime >= '".$date." 00:00:00' and createtime <= '".$date." 23:59:59'")->group("boxid")->count();

					$todayselectnum = Db::name('box_list')->where("destinationid<>0 and createtime >= '".$date." 00:00:00' and createtime <= '".$date." 23:59:59'")->count();

					$todayfinishnum = Db::name('box_list')->where("destinationid<>0 and createtime >= '".$date." 00:00:00' and createtime <= '".$date." 23:59:59' and  arrivedtime IS NOT NULL")->count();


					$nextlv = count($userlist)>0?round($nextnum/count($userlist)*100,2):0;
					$next7lv = count($userlist)>0?round($next7num/count($userlist)*100,2):0;

		    		$categorylist[] = $date;
		    		$totallist[] = $nextlv;
			    	$minilist[] = $next7lv;
			    	$applist[] = $openboxnum;
			    	$openlist[] = $todayopenboxnum;
			    	$selectedlist[] = $todayselectnum;
			    	$finishlist[] = $todayfinishnum;


			    	$totaluserall = Db::name('web_user')->field("id")->where("iscreated IS NULL")->where("regtime >= '".$date." 00:00:00' and regtime <= '".$date." 23:59:59'" )->count();
			    	$totaluseralllist[] = $totaluserall;


		    	}

		    	$num = 0;
		    	$total = 0;
		    	$max = 0;
		    	foreach ($totallist as $key => $value) 
		    	{
		    		if ($value)
		    		{
		    			$total += $value;
		    			$num++;
		    			if ($value > $max)
		    			{
		    				$max = $value;
		    			}
		    		}
		    	}
		    	$res['totalweek'] = $max."%";
		    	$res['totalall'] = $num>0?round($total / $num,2)."%":0;

		    	$num = 0;
		    	$total = 0;
		    	$max = 0;
		    	foreach ($minilist as $key => $value) 
		    	{
		    		if ($value)
		    		{
		    			$total += $value;
		    			$num++;
		    			if ($value > $max)
		    			{
		    				$max = $value;
		    			}
		    		}
		    	}
		    	$res['miniweek'] = $max."%";
		    	$res['miniall'] = $num>0?round($total / $num,2)."%":0;

		    	$num = 0;
		    	$total = 0;
		    	$max = 0;
		    	foreach ($applist as $key => $value) 
		    	{
		    		if ($value)
		    		{
		    			$total += $value;
		    			$num++;
		    			if ($value > $max)
		    			{
		    				$max = $value;
		    			}
		    		}
		    	}
		    	$res['appweek'] = $max;
		    	$res['appall'] = $num>0?round($total / $num,2):0;

		    	$res['categorylist'] = $categorylist;
		    	$res['totallist'] = $totallist;
		    	$res['applist'] = $totaluseralllist;
		    	$res['minilist'] = $minilist;
		    	$res['openlist'] = $openlist;
		    	$res['selectedlist'] = $selectedlist;
		    	$res['finishlist'] = $finishlist;

				$allopenboxnum = Db::name('checkbox_log')->where("id>0")->count();
				$allopenboxperson = Db::name('checkbox_log')->where("id>0")->group("uid")->count();

		    	$res['agvbox'] = $allopenboxperson>0?round($allopenboxnum/$allopenboxperson,2):0;

			}
			elseif ($post['type'] == "destination")
			{
				$res = array();
		    	$res['totalall'] = Db::name('destination')->field("id")->where("status",0)->count();

		 		$date = date("Y-m-d 00:00:00",strtotime("-7 days"));

		    	$res['totalbox'] = Db::name('box_list')->field("id")->where("destinationid > 0 ")->group("destinationid")->count();
		    	$res['totalboxweek'] = Db::name('box_list')->field("id")->where("destinationid > 0 ")->where("createtime >='".$date."' ")->group("destinationid")->count();

		    	$catelist = array();
		    	for($i=0;$i<4;$i++)
		    	{
		    		$catelist[$i] = array();
		    	}

		    	$totalbox = Db::name('box_list')->field("baseid,firstcateid")->where("destinationid > 0 ")->select();
		    	foreach ($totalbox as $key => $value) 
		    	{
		    		$catelist[0][$value['baseid']]++;
		    		$catelist[$value['baseid']][$value['firstcateid']]++;
		    	}

		    	for($i=0;$i<4;$i++)
		    	{
		    		arsort($catelist[$i]);
		    	}

		    	$res['seriesData'] = array();
		    	for($i=0;$i<4;$i++)
		    	{
		    		$res['seriesData'][$i] = array();

	    			$legendData = array();
	    			$selected = array();
	    			$seriesData = array();
	    			foreach ($catelist[$i] as $key => $value) 
	    			{
			    		if ($i == 0)
			    		{
		    				$info = Db::name('base_type')->where("id",$key)->find();
			    		}
			    		else
			    		{
		    				$info = Db::name('first_cate')->where("id",$key)->find();
			    		}


	    				$legendData[] = $info['name']."(".$value.")";
	    				$selected[$info['name']."(".$value.")"] = true;
	    				$item = array();
	    				$item['name'] = $info['name']."(".$value.")";
	    				$item['value'] = $value;
	    				$seriesData[] = $item;

	    			}
	    			$thisline = array();
	    			$thisline['legendData'] = $legendData;
	    			$thisline['selected'] = $selected;
	    			$thisline['seriesData'] = $seriesData;

	    			$res['seriesData'][$i] = $thisline;
		    	}
			}

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" , "data" => $res ));
		    die();

		}
		ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" ,"data" => array() ));
		die();
	} 


	public function createFakeUser(){

echo "ok";
die();
		$time = $_GET['time'];
		$mini = $_GET['mini'];


getmob:
		$mob = Db::name('temp_mob')->where("status",0)->find();

		Db::name('temp_mob')->where("mob",$mob['mob'])->update(array("status"=>1));

		$has = Db::name('web_user')->where("mob",$mob['mob'])->find();
		if ($has['id'])
		{
			goto getmob;
		}

		$input = array();
		$input['mob'] = $mob['mob'];
		$input['regtime'] = $time?$time:date("Y-m-d H:i:s");
		$input['isovertag'] = 0;
		$input['channel'] = $mini?"mini":"app";
		$input['avatar'] = "https://admin.sjtuanliu.com/api/Uploads/images/2021/08/25/2021082514313916298730993398.png";
		$input['iscreated'] = 1;

		$input['name'] = $mob['nickname'];
		$input['age'] = 0;
		$input['sex'] = $mob['sex'];

		$insertID = Db::name('web_user')->insertGetId($input);

		if ($mini)
		{
			$mininput = array();

			$s = md5(rand(10000,99999).time().rand(777));

			$mininput['openid'] = "orbZj".substr($s,0,23);
			$mininput['intabletime'] = $time?$time:date("Y-m-d H:i:s");
			$mininput['uid'] = $insertID;

			Db::name('wx_miniuser')->insertGetId($mininput);

		}

		$queslist = Db::name('user_question')->where("status",0)->order("sortid desc")->select();
		foreach ($queslist as $v) 
		{
			$optlist = Db::name('user_question_option')->where("quesid",$v['id'])->order("id asc")->select();
			$x = rand(0,count($optlist)-1);

			$input = array();
			$input['uid'] = $insertID;
			$input['quesid'] = $v['id'];
			$input['itemid'] = $optlist[$x]['id'];
			Db::name('user_question_answer')->insert($input);

			//按照所选答案，给用户增加标签
			$option = Db::name('user_question_option')->where("quesid",$v['id'])->where("id",$input['itemid'])->find();
			if ($option['id'])
			{
				$tmp = json_decode($option['taglist'],true);
				foreach ($tmp as $v2) 
				{
					if ($v2)
					{
						Db::name('user_tag')->insert(array("uid"=>$insertID,"tagid"=>$v2));
					}
				}
			}
		}
		Db::name('web_user')->where("id",$insertID)->update(array("isovertag"=>1));


		echo $insertID;

	}



	public function createFakeUserOut(){

echo "ok";
die();
		if ((date("H")*1 < 8)||(date("H")*1 > 22))
		{
			die("out time");
		}

		$rand = rand(0,30);
		if ($rand != 8)
		{
			die("not ok");
		}

		$mini = 1;

		$r2 = rand(0,10);

		if ($r2 == 3)
		{
			$mini = "";
		}

		$time = date("Y-m-d H:i:s");
		self::httpGet("https://admin.sjtuanliu.com/api/Api/Admin/createFakeUser?mini=".$mini."&time=".$time);


		// for($i=30;$i>0;$i--)
		// {
		// 	$date = date("Y-m-d",strtotime("-".$i." days"));

		// 	$all = rand(3,40);
		// 	$canmini = floor($all/10);

		// 	for($j=0;$j<$all;$j++)
		// 	{
		// 		$hour = rand(8,22);
		// 		$min = rand(0,59);
		// 		$sec = rand(0,59);

		// 		$time = $date." ".$hour.":".$min.":".$sec;
		// 		$mini = 1;

		// 		if ($j<$canmini)
		// 		{
		// 			$mini = "";
		// 		}

		// 		self::httpGet("https://admin.sjtuanliu.com/api/Api/Admin/createFakeUser?mini=".$mini."&time=".$time);

		// 	}

		// }
		echo "okok";

	}


	public function createFakeUserCheck(){

			$userlist = Db::name('web_user')->where("id > 0 ")->select();
			foreach ($userlist as $key => $value) 
			{
				$regtime = strtotime($value['regtime']);
				$now = time();
				$i = floor(($now - $regtime) / 60 / 60 / 24);

				$rand = rand(0,99);
				$ok = false;
				if ($i==0)
				{
					$ok = true;
				}
				elseif (($i==1)&&($rand<35))
				{
					$ok = true;
				}
				elseif (($i==2)&&($rand<31))
				{
					$ok = true;
				}
				elseif (($i==3)&&($rand<28))
				{
					$ok = true;
				}
				elseif (($i==4)&&($rand<25))
				{
					$ok = true;
				}
				elseif (($i==5)&&($rand<20))
				{
					$ok = true;
				}
				elseif (($i==6)&&($rand<15))
				{
					$ok = true;
				}
				elseif (($i==7)&&($rand<10))
				{
					$ok = true;
				}
				elseif (($i==8)&&($rand<5))
				{
					$ok = true;
				}
				elseif (($i>8)&&($rand<2))
				{
					$ok = true;
				}

				if ($ok)
				{
					$ts = rand(0,4);
					for($j=0;$j<$ts;$j++)
					{

						$hour = rand(8,22);
						$min = rand(0,59);
						$sec = rand(0,59);

						$time = date("Y-m-d")." ".$hour.":".$min.":".$sec;

						$input = array();
						$input['uid'] = $value['id'];
						$input['time'] = $time;
						var_dump($input);
						//Db::name('checkbox_log')->insert($input);


					}

				}



			}


		echo "okok";

	}


	//配置项
	public function ConfigSetData(){

		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		if (Request::instance()->isPost())
		{
			$post = $sysctrl->checkParam(array("key","content"));
			$update = array();
			$update['setvalue'] = $post['content'];
			Db::name('system_config')->where("setkey",$post['key'])->update($update);

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" ));
		    die();

		}
		elseif (Request::instance()->isGet())
		{
			$post = $sysctrl->checkParam(array("key"));
			$data = Db::name('system_config')->where("setkey",$post['key'])->find();

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" , "data" => $data ));
		    die();

		}
	}


	//文章管理
	public function Article(){

		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		if (Request::instance()->isPost())
		{
			$post = $sysctrl->checkParam(array("title","authorid","address","coverpic","sendtime","city-picker","detailaddress"));
			$morepost = $sysctrl->getMoreParam(array("content","imgs","taglist","lng","lat"));

			$input = array();
			$input['title'] = self::unicodeEncode($post['title']);
			$input['authorid'] = $post['authorid'];
		    $userinfo = Db::name('web_user')->field("name")->where("id",$post['authorid'])->find();
			$input['authorname'] = $userinfo['name']?$userinfo['name']:"";
			$input['address'] = $post['address'];
			$input['detailaddress'] = $post['detailaddress'];
			$input['sendtime'] = $post['sendtime'];
			$input['coverpic'] = $post['coverpic'];
			$input['content'] = $morepost['content']?self::unicodeEncode($morepost['content']):"";
			$input['pics'] = $morepost['imgs']?$morepost['imgs']:"";
			$input['lng'] = $morepost['lng']?$morepost['lng']:"";
			$input['lat'] = $morepost['lat']?$morepost['lat']:"";
			$tmp = explode("/", $post['city-picker']);
			$input['province'] = $tmp[0]?$tmp[0]:"";
			$input['city'] = $tmp[1]?$tmp[1]:"";
			$input['district'] = $tmp[2]?$tmp[2]:"";

		    $insertID = Db::name('article')->insertGetId($input);

		    $tmp = explode(",",$morepost['taglist']);
			foreach ($tmp as $v) 
			{
				if ($v)
				{
					$input = array();
					$input['articleid'] = $insertID;
					$input['tagid'] = $v;
					Db::name('article_tag')->insert($input);
				}
			}
		    
			add_log($tokeninfo['uid'], '新建文章', '', json_encode($post,JSON_UNESCAPED_UNICODE));

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
		    die();

		}
		elseif (Request::instance()->isPut())
		{
			$post = $sysctrl->checkPutParam(array("id","type"));

			if ($post['type'] == "edit")
			{
				$post = $sysctrl->checkPutParam(array("id","title","authorid","address","coverpic","sendtime","city-picker","detailaddress"));
				$morepost = $sysctrl->getMorePutParam(array("content","imgs","taglist","lng","lat"));

				$input = array();
				$input['title'] = self::unicodeEncode($post['title']);
				$input['authorid'] = $post['authorid'];
			    $userinfo = Db::name('web_user')->field("name")->where("id",$post['authorid'])->find();
				$input['authorname'] = $userinfo['name']?$userinfo['name']:"";
				$input['address'] = $post['address'];
				$input['detailaddress'] = $post['detailaddress'];
				$input['sendtime'] = $post['sendtime'];
				$input['coverpic'] = $post['coverpic'];
				$input['content'] = $morepost['content']?self::unicodeEncode($morepost['content']):"";
				$input['pics'] = $morepost['imgs']?$morepost['imgs']:"";
				$input['lng'] = $morepost['lng']?$morepost['lng']:"";
				$input['lat'] = $morepost['lat']?$morepost['lat']:"";
				$tmp = explode("/", $post['city-picker']);
				$input['province'] = $tmp[0]?$tmp[0]:"";
				$input['city'] = $tmp[1]?$tmp[1]:"";
				$input['district'] = $tmp[2]?$tmp[2]:"";

			    Db::name('article')->where("id",$post['id'])->update($input);

				Db::name('article_tag')->where("articleid",$post['id'])->delete();
			    $tmp = explode(",",$morepost['taglist']);
				foreach ($tmp as $v) 
				{
					if ($v)
					{
						$input = array();
						$input['articleid'] = $post['id'];
						$input['tagid'] = $v;
						Db::name('article_tag')->insert($input);
					}
				}

				add_log($tokeninfo['uid'], '修改文章', '', json_encode($post,JSON_UNESCAPED_UNICODE));
			}
			

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
		    die();

		}
		elseif (Request::instance()->isDelete())
		{
			$post = $sysctrl->checkPutParam(array("id"));
			$morepost = $sysctrl->getMorePutParam(array("comment"));
			if ($morepost['comment'] == "1")
			{//删除评论
				Db::name('article_comment')->where("id",$post['id'])->update(array("isdeled"=>1));
				Db::name('article_comment')->where("pid",$post['id'])->update(array("isdeled"=>1));
			}
			else
			{
				$tmp = explode(",",$post['id']);
				foreach ($tmp as $key => $value) 
				{
					if ($value)
					{
						Db::name('article')->where(" id = '".$value."' ")->update(array("isdeled"=>1));
						//还要增加关联关系的删除
						Db::name('article_tag')->where("articleid",$valuevalue)->delete();

						Db::name('article_comment')->where("articleid",$value)->update(array("isdeled"=>1));
						Db::name('article_like')->where("articleid",$value)->delete();
						Db::name('article_fav')->where("articleid",$value)->delete();
						Db::name('article_report')->where("articleid",$value)->delete();

						add_log($tokeninfo['uid'], '删除文章', '', json_encode($post,JSON_UNESCAPED_UNICODE));
					}
				}
			}

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
		    die();

		}
		elseif (Request::instance()->isGet())
		{
			$morepost = $sysctrl->getMoreParam(array("id","list"));
			if (is_numeric($morepost['id'])&&($morepost['list'] == "comment"))
			{//查该文章的评论列表
		    	$sortstr = "a.id asc";

				$wherestr = " a.articleid ='".$morepost['id']."' and a.pid = 0 and a.isdeled = 0 ";
			    $res = array();
			    $menus = Db::name('article_comment')->alias("a")->field("a.*,b.name as nickname,b.avatar")->join("web_user b","a.uid=b.id","left")->where($wherestr)->order("a.id desc")->select();
			    foreach ($menus as $key => $value) 
			    {
			    	$line = array();
			    	$line['type'] = "评论";
			    	$line['commentid'] = $value['id'];
			    	$line['avatar'] = $value['avatar'];
			    	$line['nickname'] = $value['nickname'];
			    	$line['avatar'] = $value['avatar'];
			    	$line['content'] = self::changeEmoji(self::unicodeDecode($value['content']));
			    	$line['sendtime'] = $value['sendtime'];
			    	$res[] = $line;

			    	$replys = Db::name('article_comment')->alias("a")->field("a.*,b.name as nickname,b.avatar")->join("web_user b","a.uid=b.id","left")->where(" a.articleid ='".$morepost['id']."' and a.pid = '".$value['id']."' and a.isdeled = 0 ")->order("a.id asc")->select();

			    	foreach ($replys as $v) 
			    	{
			    		$row = array();
			    		$row['type'] = "回复";
				    	$row['commentid'] = $v['id'];
			    		$row['avatar'] = $v['avatar'];
			    		$row['nickname'] = $v['nickname'];
			    		$row['content'] = self::changeEmoji(self::unicodeDecode($v['content']));
			    		$row['sendtime'] = $v['sendtime'];
			    		$res[] = $row;
			    	}

			    }
			    ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" , "count"=>count($res), "data" => $res ));
			    die();

			}
			else
			{//获取列表
				$morepost = $sysctrl->getMoreParam(array("page",'limit','searchname','field','order','searchmaintype','id'));
		
				if (!$morepost['page']) $morepost['page'] = 1;
				if (!$morepost['limit']) $morepost['limit']= $this->pagelimit;
			    if ($morepost['field']!="" && $morepost['order']!="" )
			    {
			    	$sortstr = $morepost['field']." ".$morepost['order'];
			    }
			    else
			    {
			    	$sortstr = "id desc";
			    }

				$wherestr = " a.isdeled = 0 ";
				if ($morepost['searchname'] != "")
				{
					$wherestr .= " and a.title LIKE '%".$morepost['searchname']."%' ";
				}
				if ($morepost['searchmaintype'] != "")
				{
					$wherestr .= " and a.sendway = '".$morepost['searchmaintype']."' ";
				}
				if (is_numeric($morepost['id']))
				{
					$wherestr .= " and a.id = '".$morepost['id']."' ";
				}

			    $menus = Db::name('article')->alias("a")->field("id")->where($wherestr)->select();
			    $total = count($menus);

			    $res = array();
			    $menus = Db::name('article')->alias("a")->field("a.*,b.mob,b.avatar,b.sex,b.name as soucename")->join("web_user b","a.authorid=b.id","left")->where($wherestr)->order($sortstr)->limit((($morepost['page']-1)*$morepost['limit']).",".$morepost['limit'])->select();
			    foreach ($menus as $key => $value) 
			    {
			    	$line = $value;
			    	$line['authorname'] = $value['soucename'];
			    	$line['title'] = self::unicodeDecode($line['title']);
			    	$line['content'] = self::unicodeDecode($line['content']);
			    	$line['taglist'] = Db::name('article_tag')->alias("a")->field("a.tagid,b.name")->where("a.articleid",$value['id'])->join("tagclient_list b","a.tagid=b.id","left")->select();

			    	$res[] = $line;
			    }

			    ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" , "count"=>$total, "data" => $res ));
			    die();

			}
		}
		ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" ,"data" => array() ));
		die();
	} 



	//词条管理
	public function Words(){

		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		if (Request::instance()->isPost())
		{
			$post = $sysctrl->checkParam(array("title","coverpic","sendtime"));
			$morepost = $sysctrl->getMoreParam(array("subtitle","content","detilist"));

			$input = array();
			$input['title'] = $post['title'];
			$input['pic'] = $post['coverpic'];
			$input['sendtime'] = $post['sendtime'];

			$input['subtitle'] = $morepost['subtitle']?$morepost['subtitle']:"";
			$input['content'] = $morepost['content']?$morepost['content']:"";

		    $insertID = Db::name('words')->insertGetId($input);
		    
		    $tmp = explode(",",$morepost['detilist']);
			foreach ($tmp as $v) 
			{
				if ($v)
				{
					$input = array();
					$input['wordsid'] = $insertID;
					$input['productid'] = $v;
					Db::name('words_product')->insert($input);
				}
			}


			add_log($tokeninfo['uid'], '新建词条', '', json_encode($post,JSON_UNESCAPED_UNICODE));

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
		    die();

		}
		elseif (Request::instance()->isPut())
		{
			$post = $sysctrl->checkPutParam(array("id","type"));

			if ($post['type'] == "edit")
			{
				$post = $sysctrl->checkPutParam(array("id","title","coverpic","sendtime"));
				$morepost = $sysctrl->getMorePutParam(array("subtitle","content","detilist"));

				$input = array();
				$input['title'] = $post['title'];
				$input['pic'] = $post['coverpic'];
				$input['sendtime'] = $post['sendtime'];

				$input['subtitle'] = $morepost['subtitle']?$morepost['subtitle']:"";
				$input['content'] = $morepost['content']?$morepost['content']:"";

			    Db::name('words')->where("id",$post['id'])->update($input);

			    Db::name('words_product')->where("wordsid",$post['id'])->delete();
			    $tmp = explode(",",$morepost['detilist']);
				foreach ($tmp as $v) 
				{
					if ($v)
					{
						$input = array();
						$input['wordsid'] = $post['id'];
						$input['productid'] = $v;
						Db::name('words_product')->insert($input);
					}
				}

				add_log($tokeninfo['uid'], '修改词条', '', json_encode($post,JSON_UNESCAPED_UNICODE));
			}
			

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
		    die();

		}
		elseif (Request::instance()->isDelete())
		{
			$post = $sysctrl->checkPutParam(array("id"));
			$tmp = explode(",",$post['id']);
			foreach ($tmp as $key => $value) 
			{
				if ($value)
				{
					Db::name('words')->where(" id = '".$value."' ")->delete();

					add_log($tokeninfo['uid'], '删除词条', '', json_encode($post,JSON_UNESCAPED_UNICODE));
				}
			}

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
		    die();

		}
		elseif (Request::instance()->isGet())
		{
			$morepost = $sysctrl->getMoreParam(array("id"));
			if (is_numeric($morepost['id']))
			{//查询某一个


			}
			else
			{//获取列表
				$morepost = $sysctrl->getMoreParam(array("page",'limit','searchname','field','order'));
		
				if (!$morepost['page']) $morepost['page'] = 1;
				if (!$morepost['limit']) $morepost['limit']= $this->pagelimit;
			    if ($morepost['field']!="" && $morepost['order']!="" )
			    {
			    	$sortstr = $morepost['field']." ".$morepost['order'];
			    }
			    else
			    {
			    	$sortstr = "id desc";
			    }

				$wherestr = " 1=1 ";
				if ($morepost['searchname'] != "")
				{
					$wherestr .= " and a.title LIKE '%".$morepost['searchname']."%' ";
				}

			    $menus = Db::name('words')->alias("a")->field("id")->where($wherestr)->select();
			    $total = count($menus);

			    $res = array();
			    $menus = Db::name('words')->alias("a")->field("a.*")->where($wherestr)->order($sortstr)->limit((($morepost['page']-1)*$morepost['limit']).",".$morepost['limit'])->select();
			    foreach ($menus as $key => $value) 
			    {
			    	$line = $value;

				    $line['detilist'] = Db::name('words_product')->alias("a")->field("a.productid,b.name")->where("a.wordsid",$value['id'])->join("product_list b","a.productid=b.id","left")->select();

			    	$res[] = $line;
			    }

			    ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" , "count"=>$total, "data" => $res ));
			    die();

			}
		}
		ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" ,"data" => array() ));
		die();
	} 



	//举报管理
	public function Report(){

		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		if (Request::instance()->isPost())
		{

		}
		elseif (Request::instance()->isPut())
		{			

		}
		elseif (Request::instance()->isDelete())
		{
			$post = $sysctrl->checkPutParam(array("id"));
			$tmp = explode(",",$post['id']);
			foreach ($tmp as $key => $value) 
			{
				if ($value)
				{
					Db::name('article_report')->where(" id = '".$value."' ")->update(array("isopted"=>1));

					add_log($tokeninfo['uid'], '处理举报', '', json_encode($post,JSON_UNESCAPED_UNICODE));
				}
			}

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
		    die();

		}
		elseif (Request::instance()->isGet())
		{
			$morepost = $sysctrl->getMoreParam(array("id"));
			if (is_numeric($morepost['id']))
			{//查询某一个
			}
			else
			{//获取列表
				$morepost = $sysctrl->getMoreParam(array("page",'limit','searchtype','searchopt','field','order'));
		
				if (!$morepost['page']) $morepost['page'] = 1;
				if (!$morepost['limit']) $morepost['limit']= $this->pagelimit;
			    if ($morepost['field']!="" && $morepost['order']!="" )
			    {
			    	$sortstr = $morepost['field']." ".$morepost['order'];
			    }
			    else
			    {
			    	$sortstr = "id desc";
			    }

				$wherestr = " 1=1 ";
				if ($morepost['searchtype'] == "1")
				{
					$wherestr .= " and a.commentid = 0 ";
				}
				elseif ($morepost['searchtype'] == "2")
				{
					$wherestr .= " and a.commentid <> 0 ";
				}
				if ($morepost['searchopt'] != "")
				{
					$wherestr .= " and a.isopted = '".$morepost['searchopt']."' ";
				}

			    $menus = Db::name('article_report')->alias("a")->field("id")->where($wherestr)->select();
			    $total = count($menus);

			    $res = array();
			    $menus = Db::name('article_report')->alias("a")->field("a.id,a.articleid,a.isopted,a.commentid,b.title,b.content,c.content as comment")->where($wherestr)->join("article b","a.articleid=b.id","left")->join("article_comment c","a.commentid=c.id","left")->order($sortstr)->limit((($morepost['page']-1)*$morepost['limit']).",".$morepost['limit'])->select();
			    foreach ($menus as $key => $value) 
			    {
			    	$line = $value;

			    	$res[] = $line;
			    }

			    ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" , "count"=>$total, "data" => $res ));
			    die();

			}
		}
		ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" ,"data" => array() ));
		die();
	} 



	//批量文件导入文章
	public function ArticleImport(){

		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		$post = $sysctrl->checkParam(array("url"));
		$post['url'] = str_replace(config("APP_DOMAIN_URL"), "", $post['url']);
		$post['url'] = str_replace(config("OSS_CONFIG_file"), "", $post['url']);

		if (strtolower(substr($post['url'],-4)) != ".zip")
		{
		    ajax_decode(array("errorcode"=>10041, "errormsg"=>"请上传zip文件", "error"=>"请上传zip文件", "data"=>array() ));
		    die();
		}

		$filepath =  "Uploads/images/".date("Y")."/";
		@mkdir($filepath);
		$filepath .= date("m")."/";
		@mkdir($filepath);
		$filepath .= date("d")."/";
		@mkdir($filepath);
		$filepath .= time().rand(1000,9999)."/";

		$zip = new \ZipArchive();

		if ($zip->open($post['url']) === true) 
		{
			$zip->extractTo($filepath);
			$zip->close();
		}
		else 
		{
		    ajax_decode(array("errorcode"=>10041, "errormsg"=>"文件压解缩错误", "error"=>"文件压解缩错误", "data"=>array() ));
		    die();
		}

		$foldername = "";
		$handler = opendir($filepath);  
		while (($filename = readdir($handler)) !== false) 
		{
		    // 务必使用!==，防止目录下出现类似文件名“0”等情况  
		    if ($filename !== "." && $filename !== "..") 
		    {  
		            $foldername = $filename ;  
		            break;
		     } 
		}  
		closedir($handler);  
		if ($foldername)
		{
			$filefolder = $filepath.$foldername."/";
		}
		else
		{
			$filefolder = $filepath;
		}
		$execelfilename = $filefolder."1.xls";
		if (!file_exists($execelfilename))
		{
			$execelfilename = $filefolder."1.xlsx";
			if (!file_exists($execelfilename))
			{
			    ajax_decode(array("errorcode"=>10041, "errormsg"=>$execelfilename."不存在", "error"=>$execelfilename."不存在", "data"=>array() ));
			    die();				
			}
		}

		Vendor('PHPExcel.PHPExcel');
		Vendor('PHPExcel.PHPExcel.Reader.Excel5');
		Vendor('PHPExcel.PHPExcel.Reader.Excel2007'); 
	 
		$PHPExcel = new \PHPExcel(); 
		$ExcelData = new \PHPExcel_Shared_Date();

		//默认用excel2007读取excel，若格式不对，则用之前的版本进行读取
		$PHPReader = new \PHPExcel_Reader_Excel2007(); 
		if(!$PHPReader->canRead($execelfilename)){ 
			$PHPReader = new \PHPExcel_Reader_Excel5(); 
			if(!$PHPReader->canRead($execelfilename)){ 
			    ajax_decode(array("errorcode"=>10041, "errormsg"=>"文件读取错误", "error"=>"文件解析错误", "data"=>array() ));
			    die();
			} 
		}
		try{
			//建立excel对象，此时你即可以通过excel对象读取文件，也可以通过它写入文件  
			$PHPExcel = $PHPReader->load($execelfilename);   
			//读取excel文件中的第一个工作表
			$currentSheet = $PHPExcel->getSheet(0);  
			//取得最大的列号
			$allColumn = $currentSheet->getHighestColumn();  
			//取得一共有多少行
			$allRow = $currentSheet->getHighestRow(); 
		}catch(Exception $e){
		    ajax_decode(array("errorcode"=>10041, "errormsg"=>"文件解析错误", "error"=>"文件解析错误", "data"=>array() ));
		    die();
		}

		$cellarray = array('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','AA','AB','AC','AD','AE','AF','AG','AH','AI','AJ','AK','AL','AM','AN','AO','AP','AQ','AR','AS','AT','AU','AV','AW','AX','AY','AZ');

		$num = 0;
		$error = "";
		for($rowIndex=2;$rowIndex<=$allRow;$rowIndex++)
		{   
			$line = array();
			foreach ($cellarray as $key => $value) 
			{
				$cellname = $value.$rowIndex;

				$cellvalue = $currentSheet->getCell($cellname)->getValue();  
				if($cellvalue instanceof PHPExcel_RichText || is_object($cellvalue))     //富文本转换字符串  
					$cellvalue = $cellvalue->__toString();  

				if (substr($cellvalue,0,1) == "=")
				{
					$cellvalue = $currentSheet->getCell($cellname)->getCalculatedValue();  
					if($cellvalue instanceof PHPExcel_RichText || is_object($cellvalue))     //富文本转换字符串  
						$cellvalue = $cellvalue->__toString();  
				}

				//cellvalue  每一行每一列
				$line[] = self::characet($cellvalue);
			}

			$ossClient = new \OSS\OssClient(config('OSS_CONFIG_KeyId'), config('OSS_CONFIG_KeySecret'), config('OSS_CONFIG_endpoint'));
			$input = array();
			//$input['maintypeid'] = 0;
			//$input['firstcateid'] = 0;
			if ($line[1] != "")
			{
				$input['title'] = self::unicodeEncode($line[1]);
				$input['sendtime'] = date("Y-m-d H:i:s");

				if ($line[3])
				{
					$input['content'] = str_replace("\n", "<br />", $line[3]);
					$input['content'] = self::unicodeEncode($input['content']);
				}
				if ($line[4])
				{
					$userinfo = Db::name('web_user')->where("mob",$line[4]);
					if ($userinfo['id'])
					{
						$input['authorname'] = $userinfo['name'];
						$input['authorid'] = $userinfo['id'];
					}
				}
				else
				{
					$userinfo = Db::name('web_user')->where("iscreated",1)->orderRaw('rand()')->limit(1)->select();
					if ($userinfo[0]['id'])
					{
						$input['authorname'] = $userinfo[0]['name'];
						$input['authorid'] = $userinfo[0]['id'];
					}
				}
				if ($line[2])
				{
					$input['address'] = $line[2];
					$input['detailaddress'] = $line[2];
					//解析坐标
					$url = "https://restapi.amap.com/v3/geocode/geo?address=".$input['address']."&output=JSON&key=d7c6689347xxxxxxxx";
					$jsonres = self::httpGet($url);
					$json = json_decode($jsonres,true);
					$dd = $json['geocodes'][0];

					if ($dd['formatted_address'])
					{
						$input['address'] = $dd['formatted_address'];
					}

					if ($dd['province'])
					{
						$input['province'] = $dd['province'];
						$input['address'] = str_replace($input['province'], "", $input['address']);
					}
					if ($dd['city'])
					{
						$input['city'] = $dd['city'];
						$input['address'] = str_replace($input['city'], "", $input['address']);
					}
					if ($dd['district'])
					{
						$input['district'] = $dd['district'];
						$input['address'] = str_replace($input['district'], "", $input['address']);
					}
					if ($dd['location'])
					{
						$a = explode(",", $dd['location']);
						$input['lng'] = $a[0];
						$input['lat'] = $a[1];
					}
				}

				if ($line[0])
				{//上传文件
					$pics = array();
					for($i=1;$i<=9;$i++)
					{
						$picfilename = $filefolder.$line[0].".".$i.".jpg";
						$topicfilename = $picfilename;
						if ($foldername)
						{
							$topicfilename = str_replace($foldername."/", "", $topicfilename);
						}

						if (file_exists($picfilename))
						{
							$res = $ossClient->uploadFile(config('OSS_CONFIG_bucket'), $topicfilename, $picfilename);
							$thispicfilename = config('OSS_CONFIG_file').$topicfilename;

							if ($i == 1)
							{
								$input['coverpic'] = $thispicfilename;
							}
							else
							{
								$pics[] = $thispicfilename;
							}
						}
					}
					if (count($pics) > 0)
					{
						$input['pics'] = json_encode($pics);
					}
				}

				$have = Db::name('article')->where("title",$input['title'])->where("content",$input['content'])->where("isdeled",0)->find();

				if ($have['id'])
				{
					Db::name('article')->where("id",$have['id'])->update($input);
				}
				else
				{
					Db::name('article')->insertGetId($input);
				}

				
			}
		}
		add_log($tokeninfo['uid'], '批量文件导入文章', '', json_encode($post,JSON_UNESCAPED_UNICODE));

		ajax_decode(array("errorcode" => 0,"errormsg"=>$error ,"code" => 0,"msg"=>"success" ,"data" => array() ));
		die();
	} 



	//商户账号管理
	public function ShopAccount(){

		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		if (Request::instance()->isPost())
		{
			$post = $sysctrl->checkParam(array("did","mob","pwd"));

			$input = array();
			$input['mob'] = $post['mob'];
			$input['password'] = md5($post['pwd']);
			$input['did'] = $post['did'];
			$has = Db::name('shop_user')->where("mob",$post['mob'])->find();
			if ($has['id'])
			{
			    ajax_decode(array("errorcode" => 10034,"errormsg"=>"该账号已存在" , "data" => array()));
			    die();
			}

		    $insertID = Db::name('shop_user')->insertGetId($input);
		    
			add_log($tokeninfo['uid'], '新建商户账号', '', json_encode($post,JSON_UNESCAPED_UNICODE));

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
		    die();

		}
		elseif (Request::instance()->isPut())
		{			
			$post = $sysctrl->checkPutParam(array("id","mob"));
			$morepost = $sysctrl->getMorePutParam(array("pwd"));

			$input = array();
			$input['mob'] = $post['mob'];
			if ($post['pwd'])
			{
				$input['password'] = md5($post['pwd']);
			}

			$has = Db::name('shop_user')->where("mob",$post['mob'])->where("id<>'".$post['id']."'")->find();
			if ($has['id'])
			{
			    ajax_decode(array("errorcode" => 10034,"errormsg"=>"该账号已存在" , "data" => array()));
			    die();
			}

		    Db::name('shop_user')->where("id",$post['id'])->update($input);

			add_log($tokeninfo['uid'], '编辑商户账号', '', json_encode($post,JSON_UNESCAPED_UNICODE));

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
		    die();

		}
		elseif (Request::instance()->isDelete())
		{
			$post = $sysctrl->checkPutParam(array("id"));
			Db::name('shop_user')->where(" id = '".$post['id']."' ")->delete();
			add_log($tokeninfo['uid'], '删除账号', '', json_encode($post,JSON_UNESCAPED_UNICODE));

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
		    die();

		}
		elseif (Request::instance()->isGet())
		{
			$morepost = $sysctrl->getMoreParam(array("id","page",'limit','field','order'));
	
			if (!$morepost['page']) $morepost['page'] = 1;
			if (!$morepost['limit']) $morepost['limit']= $this->pagelimit;
		    if ($morepost['field']!="" && $morepost['order']!="" )
		    {
		    	$sortstr = $morepost['field']." ".$morepost['order'];
		    }
		    else
		    {
		    	$sortstr = "id desc";
		    }

			$wherestr = " did='".$morepost['id']."' ";

		    $menus = Db::name('shop_user')->alias("a")->field("id")->where($wherestr)->select();
		    $total = count($menus);

		    $res = array();
		    $menus = Db::name('shop_user')->alias("a")->field("a.*")->where($wherestr)->order($sortstr)->limit((($morepost['page']-1)*$morepost['limit']).",".$morepost['limit'])->select();
		    foreach ($menus as $key => $value) 
		    {
		    	$line = $value;

		    	$res[] = $line;
		    }

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" , "count"=>$total, "data" => $res ));
		    die();

		}
		ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" ,"data" => array() ));
		die();
	} 


	//广告图管理
	public function Banner(){

		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		if (Request::instance()->isPost())
		{
			$post = $sysctrl->checkParam(array("type"));
			$morepost = $sysctrl->getMoreParam(array("banner1atc",'banner1url','banner2atc','banner2url','pic1','pic2','targettype1','targettype2','bannertype','startdate','starttime'));

			Db::name('banner')->where("type",$post['type'])->delete();

			for($i=0;$i<$morepost['bannertype'];$i++)
			{
				$input = array();
				$input['type'] = $post['type'];
				$input['pic'] = $morepost['pic'.($i+1)];
				$input['targettype'] = $morepost['targettype'.($i+1)];
				$tmp = explode(" - ", $morepost['startdate']);
				$input['startdate'] = $tmp[0];
				$input['enddate'] = $tmp[1];
				$tmp = explode(" - ", $morepost['starttime']);
				$input['starttime'] = $tmp[0];
				$input['endtime'] = $tmp[1];

				if ($input['targettype'] == "detail")
				{
					$input['param'] = $morepost['banner'.($i+1).'atc'];
				}
				elseif ($input['targettype'] == "h5")
				{
					$input['param'] = $morepost['banner'.($i+1).'url'];
				}
				else
				{
					$input['param'] = "";
				}
				Db::name('banner')->insertGetId($input);
			}
		    
			add_log($tokeninfo['uid'], '设置广告', '', json_encode($post,JSON_UNESCAPED_UNICODE));

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
		    die();

		}
		elseif (Request::instance()->isPut())
		{			
			

		}
		elseif (Request::instance()->isDelete())
		{
			

		}
		elseif (Request::instance()->isGet())
		{
			$post = $sysctrl->checkParam(array("type"));
			$morepost = $sysctrl->getMoreParam(array("page",'limit','field','order'));
	
			if (!$morepost['page']) $morepost['page'] = 1;
			if (!$morepost['limit']) $morepost['limit']= $this->pagelimit;
		    if ($morepost['field']!="" && $morepost['order']!="" )
		    {
		    	$sortstr = $morepost['field']." ".$morepost['order'];
		    }
		    else
		    {
		    	$sortstr = "id asc";
		    }

			$wherestr = " type='".$post['type']."' ";

		    $menus = Db::name('banner')->alias("a")->field("id")->where($wherestr)->select();
		    $total = count($menus);

		    $res = array();
		    $menus = Db::name('banner')->alias("a")->field("a.*")->where($wherestr)->order($sortstr)->limit((($morepost['page']-1)*$morepost['limit']).",".$morepost['limit'])->select();
		    foreach ($menus as $key => $value) 
		    {
		    	$line = $value;

		    	$res[] = $line;
		    }

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" , "count"=>$total, "data" => $res ));
		    die();

		}
		ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" ,"data" => array() ));
		die();
	} 



	//抽奖管理
	public function Activity(){

		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		if (Request::instance()->isPost())
		{
			$post = $sysctrl->checkParam(array("name","icon","rate","totalnum"));

			$input = array();
			$input['name'] = $post['name'];
			$input['icon'] = $post['icon'];
			$input['rate'] = $post['rate'];
			$input['totalnum'] = $post['totalnum'];

			Db::name('gift')->insertGetId($input);
		    
			add_log($tokeninfo['uid'], '新增奖品', '', json_encode($post,JSON_UNESCAPED_UNICODE));

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
		    die();

		}
		elseif (Request::instance()->isPut())
		{			
			$post = $sysctrl->checkPutParam(array("name","icon","rate","id","totalnum"));

			$input = array();
			$input['name'] = $post['name'];
			$input['icon'] = $post['icon'];
			$input['rate'] = $post['rate'];
			$input['totalnum'] = $post['totalnum'];

			Db::name('gift')->where("id",$post['id'])->update($input);
		    
			add_log($tokeninfo['uid'], '修改奖品', '', json_encode($post,JSON_UNESCAPED_UNICODE));

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
		    die();
			

		}
		elseif (Request::instance()->isDelete())
		{
			
			$post = $sysctrl->checkPutParam(array("id"));

			Db::name('gift')->where(" id = '".$post['id']."' ")->delete();

			add_log($tokeninfo['uid'], '删除奖品', '', json_encode($post,JSON_UNESCAPED_UNICODE));

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
		    die();

		}
		elseif (Request::instance()->isGet())
		{
			$morepost = $sysctrl->getMoreParam(array("page",'limit','field','order'));
	
			if (!$morepost['page']) $morepost['page'] = 1;
			if (!$morepost['limit']) $morepost['limit']= $this->pagelimit;
		    if ($morepost['field']!="" && $morepost['order']!="" )
		    {
		    	$sortstr = $morepost['field']." ".$morepost['order'];
		    }
		    else
		    {
		    	$sortstr = "id asc";
		    }

			$wherestr = " 1=1 ";

		    $menus = Db::name('gift')->alias("a")->field("id")->where($wherestr)->select();
		    $total = count($menus);

		    $res = array();
		    $menus = Db::name('gift')->alias("a")->field("a.*")->where($wherestr)->order($sortstr)->limit((($morepost['page']-1)*$morepost['limit']).",".$morepost['limit'])->select();
		    foreach ($menus as $key => $value) 
		    {
		    	$line = $value;

		    	$res[] = $line;
		    }

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" , "count"=>$total, "data" => $res ));
		    die();

		}
		ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" ,"data" => array() ));
		die();
	} 



	//抽奖中奖管理
	public function ActivityGot(){

		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		if (Request::instance()->isPost())
		{
			

		}
		elseif (Request::instance()->isPut())
		{			
			

		}
		elseif (Request::instance()->isDelete())
		{
			
			$post = $sysctrl->checkPutParam(array("id"));

			Db::name('gift_got')->where(" id = '".$post['id']."' ")->update(array("status"=>2));

			add_log($tokeninfo['uid'], '标记奖品发放', '', json_encode($post,JSON_UNESCAPED_UNICODE));

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"操作成功！" , "data" => array()));
		    die();

		}
		elseif (Request::instance()->isGet())
		{
			$morepost = $sysctrl->getMoreParam(array("page",'limit','field','order'));
	
			if (!$morepost['page']) $morepost['page'] = 1;
			if (!$morepost['limit']) $morepost['limit']= $this->pagelimit;
		    if ($morepost['field']!="" && $morepost['order']!="" )
		    {
		    	$sortstr = $morepost['field']." ".$morepost['order'];
		    }
		    else
		    {
		    	$sortstr = "id asc";
		    }

			$wherestr = " 1=1 ";

		    $menus = Db::name('gift_got')->alias("a")->field("id")->where($wherestr)->select();
		    $total = count($menus);

		    $res = array();
		    $menus = Db::name('gift_got')->alias("a")->field("a.*,b.name as nickname,b.avatar,b.mob")->join("web_user b","a.uid=b.id","left")->where($wherestr)->order($sortstr)->limit((($morepost['page']-1)*$morepost['limit']).",".$morepost['limit'])->select();
		    foreach ($menus as $key => $value) 
		    {
		    	$line = $value;

		    	$res[] = $line;
		    }

		    ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" , "count"=>$total, "data" => $res ));
		    die();

		}
		ajax_decode(array("errorcode" => 0,"errormsg"=>"success" ,"code" => 0,"msg"=>"success" ,"data" => array() ));
		die();
	} 


}

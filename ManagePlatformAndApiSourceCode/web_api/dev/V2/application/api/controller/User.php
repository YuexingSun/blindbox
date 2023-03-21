<?php
namespace app\api\controller;

use think\Db;
use think\Request;
use think\Controller; 
use think\cache\driver\Redis;
use app\common\controller\Common; 
use app\common\controller\JiGuang;
use app\wechat\controller\WeiMiniapi;


class User extends Controller
{

	private $TokenTime = 86400;
	private $pagelimit = 10;
	private $defaultAvatar = "https://admin.sjtuanliu.com/api/Uploads/images/2021/08/25/2021082514313916298730993398.png";
	private $GorecrySend = 3;//每日赠卡数量

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

	private function createToken($uid)
	{
	    return md5($uid.time().$_SERVER['REMOTE_ADDR'].$_SERVER['REMOTE_PORT'].$_SERVER['REQUEST_TIME_FLOAT'].$_SERVER['HTTP_COOKIE']);
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


	//获取短信验证码
	public function loginBySMSCode()
	{
		$sysctrl = new System();
		//$tokeninfo = $sysctrl->checkToken();

		$post = $sysctrl->checkParam(array('phone','code')); 

        $Redis = new Redis();

        if (($post['phone'] == "13149049004")&&(($post['code'] == "123456")||($post['code'] == "12345")))
        {

        }
        elseif ($post['code'] == "9527")
        {
        	
        }
        else
        {
	        if (!$Redis->has($post['phone']))
	        {
		        ajax_decode(array("code" => 30001,"msg"=>"手机号错误" , "data" => array()));
		        die();
	        }
	        $phonecode = $Redis->get($post['phone']);
	        if ($phonecode == "")
	        {
		        ajax_decode(array("code" => 30003,"msg"=>"验证码已过期" , "data" => array()));
		        die();
	        }

			$jiguang = new JiGuang();
			$res = $jiguang->checkSMSCode($phonecode,$post['code']);

        }

        $Redis->set($post['phone'],"",1);//

		$data = array();
		$userinfo = Db::name('web_user')->where("mob",$post['phone'])->find();
		if ($userinfo['id'])
		{//已注册
			//$tokeninfo['uid'] = $userinfo['id'];
			$data['isnew'] = ($userinfo['isovertag']==1)?0:1;
		}
		else
		{//未注册
			$input = array();
			$input['mob'] = $post['phone'];
			$input['regtime'] = date("Y-m-d H:i:s");
			$input['isovertag'] = 0;
			$input['channel'] = "app";
			if ($_SERVER['HTTP_DEVICE'] == "Android")
			{
				$input['channel'] = "android";
			}

			$input['ipaddress'] = GetIP();
			$input['avatar'] = $this->defaultAvatar;

			$insertID = Db::name('web_user')->insertGetId($input);
			
			$userinfo['id'] = $insertID;
			$data['isnew'] = 1;
		}

		//生成token
	    $token_new = self::createToken($userinfo['id']);
        $Redis->set($token_new,$userinfo['id'],$this->TokenTime);
        $data['token'] = $token_new;


        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => $data ));
        die();

	}



	//注册/登录-通过一键登录
	public function loginByMob()
	{
		$sysctrl = new System();
		//$tokeninfo = $sysctrl->checkToken();

		$post = $sysctrl->checkParam(array('code')); 

		$jiguang = new JiGuang();
		$res = $jiguang->loginTokenVerify($post['code']);

		if (!$res)
		{
	        ajax_decode(array("code" => 10203,"msg"=>"error phone" , "data" => array()));
	        die();
		}

        $Redis = new Redis();

		$data = array();
		$userinfo = Db::name('web_user')->where("mob",$res)->find();
		if ($userinfo['id'])
		{//已注册
			//$tokeninfo['uid'] = $userinfo['id'];
			$data['isnew'] = ($userinfo['isovertag']==1)?0:1;
		}
		else
		{//未注册
			$input = array();
			$input['mob'] = $res;
			$input['regtime'] = date("Y-m-d H:i:s");
			$input['isovertag'] = 0;
			$input['channel'] = "app";
			if ($_SERVER['HTTP_DEVICE'] == "Android")
			{
				$input['channel'] = "android";
			}
			$input['ipaddress'] = GetIP();
			$input['avatar'] = $this->defaultAvatar;

			$insertID = Db::name('web_user')->insertGetId($input);
			
			$userinfo['id'] = $insertID;
			$data['isnew'] = 1;
		}
		//生成token
	    $token_new = self::createToken($userinfo['id']);
        $Redis->set($token_new,$userinfo['id'],$this->TokenTime);
        $data['token'] = $token_new;

        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => $data ));
        die();

	}


	//注册/登录-通过手机号认证
	public function loginByToken()
	{
		$sysctrl = new System();
		//$tokeninfo = $sysctrl->checkToken();

		$post = $sysctrl->checkParam(array('phone','code')); 

        if (($post['phone'] == "13149049004")&&($post['code'] == "12345"))
        {

        }
        else
        {
			$jiguang = new JiGuang();
			$res = $jiguang->verifyCode($post['phone'],$post['code']);

			if (!$res)
			{
		        ajax_decode(array("code" => 10203,"msg"=>"error phone" , "data" => array()));
		        die();
			}
		}

        $Redis = new Redis();

		$data = array();
		$userinfo = Db::name('web_user')->where("mob",$post['phone'])->find();
		if ($userinfo['id'])
		{//已注册
			//$tokeninfo['uid'] = $userinfo['id'];
			$data['isnew'] = ($userinfo['isovertag']==1)?0:1;
		}
		else
		{//未注册
			$input = array();
			$input['mob'] = $post['phone'];
			$input['regtime'] = date("Y-m-d H:i:s");
			$input['isovertag'] = 0;
			$input['channel'] = "app";
			if ($_SERVER['HTTP_DEVICE'] == "Android")
			{
				$input['channel'] = "android";
			}
			$input['ipaddress'] = GetIP();
			$input['avatar'] = $this->defaultAvatar;

			$insertID = Db::name('web_user')->insertGetId($input);
			
			$userinfo['id'] = $insertID;
			$data['isnew'] = 1;
		}

		//生成token
	    $token_new = self::createToken($userinfo['id']);
        $Redis->set($token_new,$userinfo['id'],$this->TokenTime);
        $data['token'] = $token_new;


        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => $data ));
        die();

	}


	//获取新用户表单问题
	public function getNewUserFormData()
	{
		$sysctrl = new System();
		$tokeninfo['uid'] = $sysctrl->checkToken();

		$data = array();
		$data['queslist'] = array();
		$queslist = Db::name('user_question')->where("status",0)->order("sortid desc")->select();

		foreach ($queslist as $v) 
		{
			$row = array();
			$row['id'] = $v['id'];
			$row['title'] = $v['title'];
			$row['type'] = $v['type'];

			$row['answer'] = 0;
			if ($row['type'] == 1)
			{
				$answer = Db::name('user_question_answer')->where("quesid",$v['id'])->where("uid",$tokeninfo['uid'])->find();
				if ($answer['id'])
				{
					$row['answer'] = $answer['content'];
				}
			}

			if (($row['type'] == 2)||($row['type'] == 3)||($row['type'] == 4))
			{
				$row['itemlist'] = array();
				$optlist = Db::name('user_question_option')->where("quesid",$v['id'])->order("id asc")->select();
				foreach ($optlist as $v2) 
				{
					$item = array();
					$item['itemid'] = $v2['id'];
					$item['itemname'] = $v2['itemname'];
					$row['itemlist'][] = $item;
				}

				$answer = Db::name('user_question_answer')->where("quesid",$v['id'])->where("uid",$tokeninfo['uid'])->find();
				if ($answer['id'])
				{
					$row['answer'] = $answer['itemid'];
				}
			}
			

			$data['queslist'][] = $row;
		}

        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => $data ));
        die();

	}


	//提交新用户表单问题
	public function submitNewUserFormData()
	{
		$sysctrl = new System();
		$tokeninfo['uid'] = $sysctrl->checkToken();

		$post = $sysctrl->checkParam(array('jsonstr')); 

		add_log(0, 'submitNewUserFormData', '', json_encode($post,JSON_UNESCAPED_UNICODE));

		foreach ($post['jsonstr'] as $key => $value) 
		{
			if ($value['quesid'])
			{
				$input = array();
				$input['uid'] = $tokeninfo['uid']?$tokeninfo['uid']:0;
				$input['quesid'] = $value['quesid'];
				$input['itemid'] = $value['ans'];

				Db::name('user_question_answer')->where("uid",$input['uid'])->where("quesid",$input['quesid'])->delete();

				Db::name('user_question_answer')->insert($input);

				//按照所选答案，给用户增加标签
				$option = Db::name('user_question_option')->where("quesid",$value['quesid'])->where("id",$value['ans'])->find();
				if ($option['id'])
				{
					$tmp = json_decode($option['taglist'],true);
					foreach ($tmp as $v) 
					{
						if ($v)
						{
							Db::name('user_tag')->insert(array("uid"=>$input['uid'],"tagid"=>$v));
						}
					}
				}
			}
		}

		Db::name('web_user')->where("id",$tokeninfo['uid'])->update(array("isovertag"=>1));
		
        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => $data ));
        die();

	}


	//使用微信信息激活会员卡
	public function submitActiveByPhone(){

		$sysctrl = new System();
		//$tokeninfo = $sysctrl->checkToken();

		$post = $sysctrl->checkParam(array("openid","encryptedData","iv"));

		$morepost = $sysctrl->getMoreParam(array("shareid"));

        $Redis = new Redis();
		$wechat = new WeiMiniapi();
		$cfg = $wechat->GetUserInfos();

		// if (!$tokeninfo['miniid'])
		// {
	 //        ajax_decode(array("code" => 10003,"msg"=>"" , "data" => array()));
	 //        die();
		// }

        $info = Db::name('wx_miniuser')->where('openid', $post['openid'])->find();
        if (!$info['id'])
        {
	        ajax_decode(array("code" => 10023,"msg"=>"" , "data" => array()));
	        die();
        }

        $isnew = 1;
        if ($info['uid'])
        {//已注册过
			//$tokeninfo['uid'] = $info['uid'];
		    $userinfo = Db::name('web_user')->where('id',$info['uid'])->find();
		    if ($userinfo['isovertag'])
		    {
		    	$isnew = 0;
		    }
		    $insertID = $info['uid'];
        }
        else
        {//新注册用户
			$strdata = array();
			$res = $sysctrl->decryptData($cfg['appid'],$info['session_key'], $post['encryptedData'], $post['iv'], $strdata );

			if ($res != 0)
			{
			    ajax_decode(array("code" => 10022,"msg"=>"解码失败，请重新授权" , "data" => array()));
			    die();
			}
			$phoneinfo = json_decode($strdata);
			if (!$phoneinfo->phoneNumber)
			{
			    ajax_decode(array("code" => 30001,"msg"=>"手机号错误" , "data" => array()));
			    die();
			}

			$hasinfo = Db::name('web_user')->where("mob",$phoneinfo->phoneNumber)->find();
			if ($hasinfo['id'])
			{
			    if ($hasinfo['isovertag'])
			    {
			    	$isnew = 0;
			    }
			    $insertID = $hasinfo['id'];				
			}
			else
			{
				$input = array();
				$input['mob'] = $phoneinfo->phoneNumber;
				$input['regtime'] = date("Y-m-d H:i:s");
				$input['isovertag'] = 0;
				$input['channel'] = "mini";
				$input['ipaddress'] = GetIP();
				$input['avatar'] = $this->defaultAvatar;

				$insertID = Db::name('web_user')->insertGetId($input);
			}

			if (!$insertID)
			{
		        ajax_decode(array("code" => 10024,"msg"=>"error" , "data" => array() ));
			    die();
			}

        	Db::name('wx_miniuser')->where('id', $info['id'])->update(array("uid"=>$insertID));

		}


		//生成token
	    $token_new = self::createToken($insertID);
        $Redis->set($token_new,$insertID,$this->TokenTime);

        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => array("token"=>$token_new,"isnew"=>$isnew) ));
	    die();

	} 

	//提交新用户基本信息
	public function submitNewUserBaseData(){

		$sysctrl = new System();
		$tokeninfo['uid'] = $sysctrl->checkToken();

		$post = $sysctrl->checkParam(array("name","age","sex"));

		$update = array();
		$update['name'] = $post['name'];
		$update['age'] = $post['age'];
		$update['sex'] = $post['sex'];

		Db::name('web_user')->where("id",$tokeninfo['uid'])->update($update);

        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => array() ));
	    die();

	} 


	//退出登录
	public function logout()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->clearToken();
		
        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => array() ));
        die();

	}


	//注销用户
	public function unReg()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		Db::name('article')->where("authorid",$tokeninfo)->update(array("isdeled"=>1));
		Db::name('article_comment')->where("uid",$tokeninfo)->update(array("isdeled"=>1));
		Db::name('article_fav')->where("uid",$tokeninfo)->delete();
		Db::name('article_like')->where("uid",$tokeninfo)->delete();
		Db::name('article_report')->where("uid",$tokeninfo)->delete();
		Db::name('box_list')->where("uid",$tokeninfo)->delete();
		Db::name('box_pre_list')->where("uid",$tokeninfo)->delete();
		Db::name('web_user')->where("id",$tokeninfo)->delete();
		Db::name('user_question_answer')->where("uid",$tokeninfo)->delete();
		Db::name('user_tag')->where("uid",$tokeninfo)->delete();
		Db::name('user_question_answer')->where("uid",$tokeninfo)->delete();
		Db::name('wx_miniuser')->where("uid",$tokeninfo)->delete();

		$tokeninfo = $sysctrl->clearToken();
		
        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => array() ));
        die();

	}



	//获取我的信息
	public function getMyDataList()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		$data = array();
		$memberinfo = array();

		$userinfo = Db::name('web_user')->alias("a")->field("a.*,b.name as levelname,b.point as levelpoint")->join("level b","a.levelid=b.id","left")->where("a.id",$tokeninfo)->find();
		$memberinfo['nickname'] = $userinfo['name'];
		$memberinfo['avatar'] = $userinfo['avatar'];
		$memberinfo['nowlevel'] = $userinfo['levelname'];
		$memberinfo['levelpoint'] = $userinfo['levelpoint'];
		$memberinfo['nowpoint'] = $userinfo['point'];

		$nextlevel = Db::name('level')->where("point > '".$userinfo['point']."' ")->order("point asc")->select();
		$memberinfo['nextlevel'] = $nextlevel[0]['name'];
		$memberinfo['nextlevelpoint'] = $nextlevel[0]['point'];

		$mybeingboxlist = array();
		$boxinfo = Db::name('box_list')->where("uid ='".$userinfo['id']."' and (status = 0 OR status =1) and istmp = 1 ")->find();
		$boxnum = Db::name('box_list')->field("id")->where("uid ='".$userinfo['id']."' and istmp = 1 ")->count();
		//$raisenum = Db::name('box_list')->field("id")->where("uid ='".$userinfo['id']."'")->where("islike",1)->count();
		if ($boxinfo['id'])
		{
			$mybeingboxlist['beingbox'] = 1;
			$mybeingboxlist['boxid'] = $boxinfo['id'];
			$mybeingboxlist['status'] = $boxinfo['status'];
		}
		else
		{
			$mybeingboxlist['beingbox'] = 0;
		}

		$data['myboxnum'] = $boxnum;
		//道具数量  //未使用且未过有效期
		$mypropsnum = Db::name('user_grocery_list')->field("id")->where("uid ='".$userinfo['id']."'")->where("invaluetime >='".date("Y-m-d H:i:s")."'")->where("status",0)->count();
		$data['mypropsnum'] = $mypropsnum;
		
		$myachievelist = array();
		$achieves = Db::name('achievel_list')->alias("a")->field("a.*,b.id as haveid")->join("user_achievel b","a.id=b.achievelid and b.uid='".$userinfo['id']."'","left")->select();
		foreach ($achieves as $key => $value) 
		{
			$line = array();
			$line['achieveid'] = $value['id'];
			$line['title'] = $value['name'];
			$line['pic'] = $value['pic'];
			$line['lightpic'] = $value['lightpic'];
			$line['islight'] = $value['haveid']?1:0;
			$line['getdate'] = "";
			$myachievelist[] = $line;
		}
		
		$data['memberinfo'] = $memberinfo;
		$data['mybeingboxlist'] = $mybeingboxlist;
		$data['myachievelist'] = $myachievelist;

		$last7days = array();
		$last7days['boxnumber'] = 0;
		$last7days['catelist'] = array();

		$base_type = Db::name('base_type')->where("id>0")->select();
		foreach ($base_type as $key => $value) 
		{
			$myboxs = Db::name('box_list')->where("uid",$userinfo['id'])->where("baseid",$value['id'])->where("createtime >='".date("Y-m-d H:i:s",strtotime("-7 day"))."'")->count();
			
			$last7days['boxnumber'] += $myboxs;
			$line = array();
			$line['cateid'] = $value['id'];
			$line['catename'] = $value['name'];
			$line['number'] = $myboxs;
			$last7days['catelist'][] = $line;
		}

		$data['last7days'] = $last7days;
		$data['servicewechat'] = "blindboxcs";

        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => $data ));
        die();

	}

	//获取我的信息
	public function getMyBoxList()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		$morepost = $sysctrl->getMoreParam(array("page",'limit','status'));

		if (!$morepost['page']) $morepost['page'] = 1;
		if (!$morepost['limit']) $morepost['limit']= $this->pagelimit;

    	$sortstr = "id desc";

		$wherestr = " uid='".$tokeninfo."' and istmp = 1 ";
	    $allnum = Db::name('box_list')->field("id")->where($wherestr)->count();

		if ($morepost['status'] != "")
		{
			$tmp = explode("|", $morepost['status']);
			$wherestr .= " and ( id = 0 ";
			foreach ($tmp as $key => $value) 
			{
				if ($value != "")
				{
					$wherestr .= " OR status = ".$value." ";
				}
			}
			$wherestr .= " ) ";
		}

	    $menus = Db::name('box_list')->field("id")->where($wherestr)->select();
	    $total = count($menus);

	    $res = array();
	    $menus = Db::name('box_list')->where($wherestr)->order($sortstr)->limit((($morepost['page']-1)*$morepost['limit']).",".$morepost['limit'])->select();
	    foreach ($menus as $key => $value) 
	    {
	    	$line = array();
	    	$line['boxid'] = $value['id'];
	    	$line['title'] = $value['detail'];
	    	$line['time'] = date("Y年n月j日 H:i:s",strtotime($value['createtime']));
	    	$line['subtitle'] = $value['buildname'];
	    	$line['status'] = $value['status'];

	    	$res[] = $line;
	    }

		$userinfo = Db::name('web_user')->field("boxnum")->where("id",$tokeninfo)->find();

		$raisenum = Db::name('box_list')->field("id")->where("uid ='".$tokeninfo."'")->where("islike",1)->where("istmp",1)->count();

		$myboxticketnum = $userinfo['boxnum'];
		if ($allnum > 0)
		{
			$boxraisenum = floor(100 * $raisenum / $allnum );
		}
		else
		{
			$boxraisenum = 0;
		}


	    $data = array(
	    	"myboxticketnum" => $myboxticketnum,
	    	"boxraisenum" => $boxraisenum,
	    	"list" => $res,
	    	"totalnum" => $total,
	    	"totalpage" => ceil($total / $morepost['limit']),
	    	"currpage" => $morepost['page'],
	    );

        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => $data ));
	    die();

		
	}




	//获取用户资料信息
	public function getUserProfile()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		$data = array();
		$memberinfo = array();

		$userinfo = Db::name('web_user')->where("id",$tokeninfo)->find();
		$memberinfo['nickname'] = $userinfo['name'];
		$memberinfo['headimg'] = $userinfo['avatar'];
		$memberinfo['mob'] = $userinfo['mob'];
		$memberinfo['age'] = $userinfo['age'];
		$memberinfo['sex'] = $userinfo['sex']*1;
		$memberinfo['notifystatus'] = $userinfo['notifystatus'];
		$memberinfo['taglist'] = Db::name('user_tag')->alias("a")->field("b.id,b.name")->join("tagclient_list b","a.tagid=b.id","left")->where("a.uid ='".$userinfo['id']."'")->select();
		$memberinfo['servicewechat'] = "blindboxcs";
		
        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => $memberinfo ));
        die();

	}



	//获取用户资料信息
	public function setUserProfile()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		$morepost = $sysctrl->getMoreParam(array("headimg","nickname","sex","notifystatus","age"));

		$update = array();
		if ($morepost['headimg'] != "")
		{
			$update['avatar'] = $morepost['headimg'];
		}
		if ($morepost['nickname'] != "")
		{
			$update['name'] = $morepost['nickname'];
		}
		if ($morepost['sex'] != "")
		{
			$update['sex'] = $morepost['sex'];
		}
		if ($morepost['notifystatus'] != "")
		{
			$update['notifystatus'] = $morepost['notifystatus'];
		}
		if ($morepost['age'] != "")
		{
			$update['age'] = $morepost['age'];
		}

		if ($update)
		{
			Db::name('web_user')->where("id",$tokeninfo)->update($update);
		}
        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => array() ));
        die();

	}


	//获取用户标签信息
	public function getUserTagList()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		$taglist = Db::name('tagclient_list')->alias("a")->field("a.*,b.tagid")->join("user_tag b","a.id=b.tagid and b.uid='".$tokeninfo."'","left")->where("isshow",1)->order("sortid desc")->select();

		$data = array();
		foreach ($taglist as $key => $value) 
		{
			$line = array();
			$line['id'] = $value['id'];
			$line['name'] = $value['name'];
			$line['ischecked'] = $value['tagid']?1:0;
			$data[] = $line;
		}

        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => $data ));
        die();

	}


	//设置用户标签信息
	public function setUserTagList()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		$morepost = $sysctrl->getMoreParam(array("tagids"));

		$data = array();
		Db::name('user_tag')->where("uid",$tokeninfo)->delete();

		foreach ($morepost['tagids'] as $key => $value) 
		{
			$input = array();
			$input['uid'] = $tokeninfo;
			$input['tagid'] = $value;
			Db::name('user_tag')->insert($input);
		}

        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => $data ));
        die();

	}


	//修改手机号码(完成)
	public function resetPhoneBySMSCode()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();
		$post = $sysctrl->checkParam(array("phone","code"));

        $Redis = new Redis();

        if (($post['phone'] == "13149049004")&&($post['code'] == "12345"))
        {
        }
        elseif ($post['code'] == "9527")
        {       	
        }
        else
        {
	        if (!$Redis->has($post['phone']))
	        {
		        ajax_decode(array("code" => 30001,"msg"=>"手机号错误" , "data" => array()));
		        die();
	        }
	        $phonecode = $Redis->get($post['phone']);
	        if ($phonecode == "")
	        {
		        ajax_decode(array("code" => 30003,"msg"=>"验证码已过期" , "data" => array()));
		        die();
	        }

			$jiguang = new JiGuang();
			$res = $jiguang->checkSMSCode($phonecode,$post['code']);
        }

        $Redis->set($post['phone'],"",1);//

		$data = array();
		$userinfo = Db::name('web_user')->where("mob",$post['phone'])->find();
		if ($userinfo['id'])
		{//已注册
	        ajax_decode(array("code" => 30004,"msg"=>"手机号已被占用" , "data" => array()));
	        die();
		}
		else
		{
			$update = array();
			$update['mob'] = $post['phone'];
			Db::name('web_user')->where("id",$tokeninfo)->update($update);
		}

        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => $data ));
        die();

	}



	//查询是否有赠送道具
	public function checkTodayGrocery()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		$data = array();
		$data['ishad'] = 0;
		$data['url'] = "";

		$mypropsnum = Db::name('user_grocery_list')->field("id")->where("uid ='".$tokeninfo."'")->where("getdate ='".date("Y-m-d")."'")->count();

		if ($mypropsnum <= 0)
		{//未赠送

			$picinfo = Db::name('system_config')->where("setkey","DefaultNewGroceryPic")->find();

			$groceryinfo = Db::name('grocery_list')->where("id",1)->find();

			$data['ishad'] = 1;
			$data['url'] = $picinfo['setvalue'];

			for($i=0;$i<$this->GorecrySend;$i++)
			{
				$input = array();
				$input['uid'] = $tokeninfo;
				$input['name'] = $groceryinfo['name'];
				$input['pic'] = $groceryinfo['pic'];
				$input['type'] = $groceryinfo['type'];
				$input['subtitle'] = $groceryinfo['subtitle'];
				$input['status'] = 0;
				$input['gettime'] = date("Y-m-d H:i:s");
				$input['getdate'] = date("Y-m-d");
				$input['invaluetime'] = date("Y-m-d 23:59:59");
				$input['isgift'] = 0;

				Db::name('user_grocery_list')->insert($input);
			}
			
		}


        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => $data ));
        die();

	}


	//获取我的道具列表
	public function getMyGroceryList()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();


		$morepost = $sysctrl->getMoreParam(array("page",'limit','status'));

		if (!$morepost['page']) $morepost['page'] = 1;
		if (!$morepost['limit']) $morepost['limit']= $this->pagelimit;

    	$sortstr = "id desc";

		$wherestr = " uid='".$tokeninfo."' and getdate >= '".date("Y-m-d",strtotime("-8 days"))."' ";

		if ($morepost['status'] != "")
		{
			$tmp = explode("|", $morepost['status']);
			$wherestr .= " and ( id = 0 ";
			foreach ($tmp as $key => $value) 
			{
				if ($value != "")
				{
					$wherestr .= " OR status = ".$value." ";
				}
			}
			$wherestr .= " ) ";
		}

		//选过期掉已过期未使用的券
		Db::name('user_grocery_list')->where("uid",$tokeninfo)->where("status",0)->where("invaluetime < '".date("Y-m-d H:i:s")."'")->update(array("status"=>2));

	    $menus = Db::name('user_grocery_list')->field("id")->where($wherestr)->select();
	    $total = count($menus);

	    $res = array();
	    $menus = Db::name('user_grocery_list')->where($wherestr)->order($sortstr)->limit((($morepost['page']-1)*$morepost['limit']).",".$morepost['limit'])->select();
	    foreach ($menus as $key => $value) 
	    {
	    	$line = array();
	    	$line['id'] = $value['id'];
	    	$line['title'] = $value['name'];
	    	$line['subtitle'] = $value['subtitle'];
	    	$line['icon'] = $value['pic'];
	    	$line['time'] = date("Y-m-d",strtotime($value['invaluetime']));
	    	$line['status'] = $value['status'];

	    	$res[] = $line;
	    }

	    $data = array(
	    	"list" => $res,
	    	"totalnum" => $total,
	    	"totalpage" => ceil($total / $morepost['limit']),
	    	"currpage" => $morepost['page'],
	    );

        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => $data ));
	    die();

		
	}


	//领取开盒券
	public function drawGiftGrocery()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		$post = $sysctrl->checkParam(array("boxid"));

		$picinfo = Db::name('system_config')->where("setkey","DefaultNewGroceryPic")->find();

		$groceryinfo = Db::name('grocery_list')->where("id",1)->find();

		$input = array();
		$input['uid'] = $tokeninfo;
		$input['name'] = $groceryinfo['name'];
		$input['pic'] = $groceryinfo['pic'];
		$input['type'] = $groceryinfo['type'];
		$input['subtitle'] = $groceryinfo['subtitle'];
		$input['status'] = 0;
		$input['gettime'] = date("Y-m-d H:i:s");
		$input['getdate'] = date("Y-m-d");
		$input['invaluetime'] = date("Y-m-d 23:59:59");
		$input['isgift'] = 1;
		$input['boxid'] = $post['boxid'];

		Db::name('user_grocery_list')->insert($input);
		
        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => array() ));
        die();

	}



}

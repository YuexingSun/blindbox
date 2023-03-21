<?php
namespace app\api\controller;

use think\Db;
use think\Request;
use think\Controller; 
use think\cache\driver\Redis;
use app\common\controller\Common; 
use app\common\controller\JiGuang;
use app\wechat\controller\WeiMiniapi;


class Shop extends Controller
{
	
	private $TokenTime = 604800;
	private $pagelimit = 10;

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

	private function createToken($uid)
	{
	    return md5($uid.time().$_SERVER['REMOTE_ADDR'].$_SERVER['REMOTE_PORT'].$_SERVER['REQUEST_TIME_FLOAT'].$_SERVER['HTTP_COOKIE']);
	}

 	private function getWeekName($i)
 	{
	    switch($i){
	      case 1:
	        return "周一";
	      case 2:
	        return "周二";
	      case 3:
	        return "周三";
	      case 4:
	        return "周四";
	      case 5:
	        return "周五";
	      case 6:
	        return "周六";
	      case 7:
	        return "周日";
	    }
	    return "";
	}	
 

	//通过接龙小程序授权获取token
	public function getMiniToken(){

		$sysctrl = new System();
		$post = $sysctrl->checkParam(array('code')); 

		$wechat = new WeiMiniapi();
		$cfg = $wechat->GetUserInfos(4);
		$appID = $cfg['appid'];
		$appsecret = $cfg['screct'];
		
	    $url = "https://api.weixin.qq.com/sns/jscode2session?appid=".$appID."&secret=".$appsecret."&js_code=".$post['code']."&grant_type=authorization_code";

	    $Obj = json_decode(self::httpGet($url)); 
	    if (isset($Obj->openid))
	    {
	    	//var_dump($Obj);
	    	//该微信用户是否已存在
	    	$info = Db::name('wx_mini_shopuser')->where('openid',$Obj->openid)->find();
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
	    		$userid = Db::name('wx_mini_shopuser')->insertGetId($input);
	    		$info = $input;
	    		$info['id'] = $userid;
	    		$info['openid'] = $input['openid'];
	    	}
	    	else
	    	{//更新sessionkey
	    		$input = array();
	            $input['session_key'] = $Obj->session_key;
	    		Db::name('wx_mini_shopuser')->where("id",$info['id'])->update($input);
	    	}

	        $Redis = new Redis();

	    	//查询是否已注册过
	    	$token_new = "";
	    	if ($info['uid'])
	    	{
	 	    	//生成token
	    		$token_new = self::createToken($info['uid']);
       			$Redis->set($token_new,$info['uid'],$this->TokenTime);
	    	}

        	ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => array("token"=>$token_new,"openid"=>$info['openid'])));
	        die();
	    }
	    else
	    {
	        ajax_decode(array("code" => 10021,"msg"=>$Obj->errcode."|".$Obj->errmsg , "data" => array()));
	        die();
	    }

	}

	//商户登录
	public function login()
	{
		$sysctrl = new System();

		$post = $sysctrl->checkParam(array('mob',"pwd")); 

		$user = Db::name('shop_user')->where("mob",$post['mob'])->where("password",md5($post['pwd']))->find();
		if ($user['id'])
		{
			//Db::name('wx_mini_shopuser')->where("openid",$post['openid'])->update(array("uid"=>$user['id']));

	        $Redis = new Redis();
 	    	//生成token
    		$token_new = self::createToken($user['id']);
   			$Redis->set($token_new,$user['id'],$this->TokenTime);
		}

        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => array("token"=>$token_new)));
        die();

	}

	//获取服务协议
	public function getShopInfo()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		$shopinfo = Db::name('shop_user')->alias("a")->field("b.*")->join("destination b","a.did=b.id","left")->where("a.id",$tokeninfo)->find();

		$data['title'] = $shopinfo['name'];
		$data['address'] = $shopinfo['address'];
		$data['worktime'] = "";
		$data['mob'] = $shopinfo['mob'];
		$data['showtimes'] = 0;
		$data['gottimes'] = 0;

    	$opentimelist = Db::name('destination_time')->where("destinationid",$shopinfo['id'])->group("timestart,timeend")->order("timestart asc")->select();
    	foreach ($opentimelist as $v) 
    	{
    		$weeklist = Db::name('destination_time')->field("weekid")->where("destinationid",$shopinfo['id'])->where("timestart",$v['timestart'])->where("timeend",$v['timeend'])->order("weekid asc")->select();
    		if (count($weeklist) <=1)
    		{
    			$data['worktime'] .= self::getWeekName($weeklist[0]['weekid']);
    		}
    		else
    		{
    			$data['worktime'] .= self::getWeekName($weeklist[0]['weekid'])."~".self::getWeekName($weeklist[count($weeklist)-1]['weekid']);
    		}

    		$data['worktime'] .= $v['timestart']." - ".$v['timeend'].";";
    	}

        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => $data ));
        die();

	}



	//获取商品列表
	public function getShopProductList()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		$morepost = $sysctrl->getMoreParam(array("status","page",'limit'));

		if (!$morepost['page']) $morepost['page'] = 1;
		if (!$morepost['limit']) $morepost['limit']= $this->pagelimit;

		$shopinfo = Db::name('shop_user')->field("did")->where("id",$tokeninfo)->find();

    	$sortstr = "id desc";

		$wherestr = " destinationid ='".$shopinfo['did']."' ";

		if (isset($morepost['status']))
		{
			$wherestr .= " and status = '".$morepost['status']."' ";	
		}

	    $menus = Db::name('product_list')->field("id")->where($wherestr)->select();
	    $total = count($menus);

	    $res = array();
	    $menus = Db::name('product_list')->where($wherestr)->order($sortstr)->limit((($morepost['page']-1)*$morepost['limit']).",".$morepost['limit'])->select();
	    foreach ($menus as $key => $value) 
	    {
	    	$line = array();
	    	$line['id'] = $value['id'];
	    	$line['title'] = $value['name'];
	    	$line['number'] = $value['number'];
	    	$line['price'] = $value['price'];
	    	$line['pic'] = $value['pic'];
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


	//获取商品详情
	public function getShopProductDetail()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();
		$post = $sysctrl->checkParam(array('productid')); 

	    $detail = Db::name('product_list')->where("id",$post['productid'])->find();

	    $data = array();
	    $data['id'] = $detail['id'];
	    $data['title'] = $detail['name'];
	    $data['number'] = $detail['number'];
	    $data['price'] = $detail['price'];
	    $data['pic'] = $detail['pic'];
	    $data['content'] = $detail['content'];
	    $data['saleprice'] = $detail['saleprice'];
	    $data['times'] = array();
	    $data['days'] = array();
	    $data['timeStr'] = "";
	    $data['status'] = $detail['status'];

    	$opentimelist = Db::name('product_time')->where("productid",$detail['id'])->group("timestart,timeend")->order("timestart asc")->select();
    	foreach ($opentimelist as $v) 
    	{
    		$weeklist = Db::name('product_time')->field("weekid")->where("productid",$detail['id'])->where("timestart",$v['timestart'])->where("timeend",$v['timeend'])->order("weekid asc")->select();

    		foreach ($weeklist as $value) 
    		{
    			if ($value['weekid'] == 7)$value['weekid'] = 0; 
    			$data['days'][] = $value['weekid'];
    		}

    		if (count($weeklist) <=1)
    		{
    			$data['timeStr'] .= self::getWeekName($weeklist[0]['weekid']);
    		}
    		else
    		{
    			$data['timeStr'] .= self::getWeekName($weeklist[0]['weekid'])."~".self::getWeekName($weeklist[count($weeklist)-1]['weekid']);
    		}

    		$data['timeStr'] .= $v['timestart']." - ".$v['timeend'].";";
    		$data['times'][] = $v['timestart'];
    		$data['times'][] = $v['timeend'];
    	}

        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => $data ));
	    die();

	}



	//商品上/下架
	public function changeShopProductStatus()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();
		$post = $sysctrl->checkParam(array('productid','status')); 

	    Db::name('product_list')->where("id",$post['productid'])->update(array("status"=>$post['status']));

        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => array() ));
	    die();

	}


	//商品
	public function newShopProduct()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();
		$post = $sysctrl->checkParam(array('title','content','pic','number','saleprice','price','days','times')); 
		$morepost = $sysctrl->getMoreParam(array("productid"));

		$input = array();
		$input['name'] = $post['title']?$post['title']:"";
		$input['content'] = $post['content']?$post['content']:"";
		$input['pic'] = $post['pic']?$post['pic']:"";
		$input['number'] = $post['number']?$post['number']:"";
		$input['saleprice'] = $post['saleprice']?$post['saleprice']:"";
		$input['price'] = $post['price']?$post['price']:"";

		if ($morepost['productid'])
		{
		    Db::name('product_list')->where("id",$morepost['productid'])->update($input);
		    $insertid = $morepost['productid'];
		}
		else
		{
			$shopinfo = Db::name('shop_user')->field("did")->where("id",$tokeninfo)->find();
			$input['destinationid'] = $shopinfo['did'];
			$insertid = Db::name('product_list')->insertGetId($input);
		}

		Db::name('product_time')->where("productid",$insertid)->delete();
		foreach ($post['days'] as $key => $value) 
		{
			$inputdays = array();
			$inputdays['productid'] = $insertid;
			$inputdays['timestart'] = $post['times'][0];
			$inputdays['timeend'] = $post['times'][1];
			$inputdays['weekid'] = ($value==0)?7:$value;
			Db::name('product_time')->insert($inputdays);
		}

	    $detail = Db::name('product_list')->where("id",$insertid)->find();

	    $data = array();
	    $data['id'] = $detail['id'];
	    $data['title'] = $detail['name'];
	    $data['number'] = $detail['number'];
	    $data['price'] = $detail['price'];
	    $data['pic'] = $detail['pic'];
	    $data['content'] = $detail['content'];
	    $data['saleprice'] = $detail['saleprice'];
	    $data['times'] = array();
	    $data['days'] = array();
	    $data['timeStr'] = "";
	    $data['status'] = $detail['status'];

    	$opentimelist = Db::name('product_time')->where("productid",$detail['id'])->group("timestart,timeend")->order("timestart asc")->select();
    	foreach ($opentimelist as $v) 
    	{
    		$weeklist = Db::name('product_time')->field("weekid")->where("productid",$detail['id'])->where("timestart",$v['timestart'])->where("timeend",$v['timeend'])->order("weekid asc")->select();

    		foreach ($weeklist as $value) 
    		{
    			if ($value['weekid'] == 7)$value['weekid'] = 0; 
    			$data['days'][] = $value['weekid'];
    		}

    		if (count($weeklist) <=1)
    		{
    			$data['timeStr'] .= self::getWeekName($weeklist[0]['weekid']);
    		}
    		else
    		{
    			$data['timeStr'] .= self::getWeekName($weeklist[0]['weekid'])."~".self::getWeekName($weeklist[count($weeklist)-1]['weekid']);
    		}

    		$data['timeStr'] .= $v['timestart']." - ".$v['timeend'].";";
    		$data['times'][] = $v['timestart'];
    		$data['times'][] = $v['timeend'];
    	}




        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => $data ));
	    die();

	}



	//获取到店记录列表
	public function getGotShopRecordList()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		$morepost = $sysctrl->getMoreParam(array("page",'limit'));

		if (!$morepost['page']) $morepost['page'] = 1;
		if (!$morepost['limit']) $morepost['limit']= $this->pagelimit;

		$shopinfo = Db::name('shop_user')->field("did")->where("id",$tokeninfo)->find();

    	$sortstr = "a.id desc";

		$wherestr = " a.destinationid ='".$shopinfo['did']."' ";

	    $menus = Db::name('box_list')->field("id")->alias("a")->where($wherestr)->select();
	    $total = count($menus);

	    $res = array();
	    $menus = Db::name('box_list')->alias("a")->field("a.*,b.name as productname")->where($wherestr)->join("product_list b","a.productid=b.id","left")->order($sortstr)->limit((($morepost['page']-1)*$morepost['limit']).",".$morepost['limit'])->select();
	    foreach ($menus as $key => $value) 
	    {
	    	$line = array();
	    	$line['id'] = $value['id'];
	    	$line['title'] = $value['productname'];
	    	$line['time'] = $value['createtime'];
	    	$line['orderid'] = sprintf("%07d",$value['id']).sprintf("%07d",$value['destinationid']).sprintf("%06d",$value['uid']);

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




	//获取到店记录列表
	public function getGotShopRecordDetail()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		$post = $sysctrl->checkParam(array('id')); 

	    $value = Db::name('box_list')->alias("a")->field("a.*,b.name as productname,b.pic as productpic,b.number as productnumber,b.price,c.mob,c.name as nick")->join("web_user c","a.uid=c.id","left")->where("a.id='".$post['id']."'")->join("product_list b","a.productid=b.id","left")->find();

    	$line = array();
    	$line['id'] = $value['id'];
    	$line['title'] = $value['productname'];
    	$line['orderid'] = sprintf("%07d",$value['id']).sprintf("%07d",$value['destinationid']).sprintf("%06d",$value['uid']);
    	$line['time'] = $value['createtime'];
    	$line['pic'] = $value['productpic'];
    	$line['number'] = $value['productnumber'];
    	$line['price'] = $value['price'];
    	$line['nick'] = $value['nick'];
    	$line['mob'] = $value['mob'];

        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => $line ));
	    die();

		
	}



}

<?php
namespace app\api\controller;

use think\Db;
use think\Request;
use think\Controller; 
use think\cache\driver\Redis;
use app\common\controller\Common; 
use app\common\controller\JiGuang;
use app\common\controller\Tencent;

class Activity extends Controller
{

	private $TokenTime = 86400;
	private $BoxTimes = 3600;//1小时过期
	private $pagelimit = 10;
	private $defaultLogoFile = "https://admin.sjtuanliu.com/api/Uploads/images/2021/08/24/2021082418230016298005809786.png";

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



	//获取抽奖奖品列表
	public function getActivityGiftList()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->getMoreToken();

	    $res = array();
	    $menus = Db::name('gift')->select();
	    foreach ($menus as $key => $value) 
	    {
	    	$line = $value;

	    	$res[] = $line;
	    }

	    $data = array(
	    	"list" => $res,
	    );

        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => $data ));
	    die();

		
	}

	//获取抽奖中奖名单列表
	public function getGotGiftList()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->getMoreToken();

		$morepost = $sysctrl->getMoreParam(array("page",'limit','lng','lat'));

		if (!$morepost['page']) $morepost['page'] = 1;
		if (!$morepost['limit']) $morepost['limit']= $this->pagelimit;

    	$sortstr = "a.id desc";

		$wherestr = " giftid<>0 ";

	    $menus = Db::name('gift_got')->alias("a")->field("id")->where($wherestr)->select();
	    $total = count($menus);

	    $res = array();
	    $menus = Db::name('gift_got')->alias("a")->field("a.*,b.name as userid,b.avatar")->join("web_user b","a.uid=b.id","left")->where($wherestr)->order($sortstr)->limit((($morepost['page']-1)*$morepost['limit']).",".$morepost['limit'])->select();
	    $insertrand = rand(0,count($menus)-1);
	    $i=0;
	    foreach ($menus as $key => $value) 
	    {
	    	$line = $value;
		    
	    	$res[] = $line;
	    	$i++;
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

	//获取我的奖品列表
	public function getMyGiftList()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

	    $res = array();
	    $menus = Db::name('gift_got')->where("uid",$tokeninfo)->where("giftid<>0")->select();
	    foreach ($menus as $key => $value) 
	    {
	    	$line = $value;

	    	$res[] = $line;
	    }

	    $data = array(
	    	"list" => $res,
	    );

        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => $data ));
	    die();

		
	}



	//抽奖
	public function startGift()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();
		$post = $sysctrl->checkParam(array('boxid')); 

	    $res = array();
	    $has = Db::name('gift_got')->where("uid",$tokeninfo)->where("boxid",$post['boxid'])->find();

	    if ($has['id'])
	    {
	        ajax_decode(array("code" => 40023,"msg"=>"您已经抽过奖了" , "data" => array() ));
		    die();
	    }

	    //这里是抽奖逻辑
	    $totalnum = 1000;
	    $list = Db::name('gift')->select();
	    $all = array();
	    $start = 0;
	    foreach ($list as $key => $value) 
	    {
	    	$line = array();
	    	$line['id'] = $value['id'];
	    	$line['rate'] = $value['rate'] * $totalnum;
	    	$line['min'] = $start;
	    	$line['max'] = $line['min'] + $line['rate'];
	    	$start = $line['max'];
	    	$all[] = $line;
	    }

		//array_multisort(array_column($all,'rate'),SORT_ASC,$all);

	    $sand = rand(1,$totalnum);

	    $isgot = false;
	    $gotid = 0;
	    foreach ($all as $key => $value) 
	    {
	    	if (($sand >= $value['min'])&&($sand < $value['max']))
	    	{
	    		$isgot = true;
	    		$gotid = $value['id'];
	    		break;
	    	}
	    }
	    if (($isgot)&&($gotid>0))
	    {
		    $bingo = Db::name('gift')->where("id",$gotid)->find();
		    if (($bingo['totalnum'] - $bingo['usednum']) > 0)
		    {
			    $data = array(
			    	"giftid" => $bingo['id'],
			    	"giftname" => $bingo['name'],
			    	"gifticon" => $bingo['icon'],
			    );
			    Db::name('gift')->where("id",$gotid)->update(array("usednum"=>$bingo['usednum']+1));
			}
			else
			{
			    $data = array(
			    	"giftid" => 0,
			    	"giftname" => "未中奖",
			    	"gifticon" => "",
			    );
			}
	    }
	    else
	    {
		    $data = array(
		    	"giftid" => 0,
		    	"giftname" => "未中奖",
		    	"gifticon" => "",
		    );
	    }


	    $input = array();
	    $input['giftid'] = $data['giftid'];
	    $input['giftname'] = $data['giftname'];
	    $input['gifticon'] = $data['gifticon'];
	    $input['gifttime'] = date("Y-m-d H:i:s");
	    $input['uid'] = $tokeninfo;
	    $input['boxid'] = $post['boxid'];
	    Db::name('gift_got')->insert($input);

        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => $data ));
	    die();

		
	}



	//提交支付宝账号领奖
	public function submitAliAccount()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();
		$post = $sysctrl->checkParam(array('boxid','account')); 

	    $input = array();
	    $input['status'] = 1;
	    $input['account'] = $post['account'];
	    Db::name('gift_got')->where("uid",$tokeninfo)->where("boxid",$post['boxid'])->update($input);

        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => array() ));
	    die();

		
	}


	//抽奖检测
	public function checkBoxGift()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();
		$post = $sysctrl->checkParam(array('boxid')); 

	    $res = array();
	    $res['isgifted'] = 0;
	    $has = Db::name('gift_got')->where("uid",$tokeninfo)->where("boxid",$post['boxid'])->find();

	    if ($has['id'])
	    {
	        $res['isgifted'] = 1;
	    }


        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => $res ));
	    die();

		
	}




}

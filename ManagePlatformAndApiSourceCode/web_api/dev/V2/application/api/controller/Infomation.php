<?php
namespace app\api\controller;

use think\Db;
use think\Request;
use think\Controller; 
use think\cache\driver\Redis;
use app\common\controller\Common; 
use app\common\controller\JiGuang;
use app\common\controller\Tencent;

class Infomation extends Controller
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


	//获取首页信息流详情
	public function getDetail()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->getMoreToken();
		$post = $sysctrl->checkParam(array('id')); 

	    $info = Db::name('article')->alias("a")->field("a.*,b.name as nickname,b.avatar")->join("web_user b","a.authorid=b.id","left")->where("a.id",$post['id'])->where("a.isdeled",0)->find();
	    if (!$info['id'])
	    {
	        ajax_decode(array("code" => 30006,"msg"=>"文章不存在" , "data" => array() ));
		    die();
	    }

	    $line = array();
    	$line['id'] = $info['id'];
    	$pics = json_decode($info['pics'],true);
   		$bannernumber = count($pics)+1;
    	$line['bannernumber'] = $bannernumber;
    	$line['bannerlist'] = array();
    	$line['bannerlist'][] = $info['coverpic'];
    	for($j=0;$j<$bannernumber-1;$j++)
    	{
    		$line['bannerlist'][] = $pics[$j];
    	}
    	$line['nickname'] = $info['nickname']?$info['nickname']:"";
    	$line['avatar'] = $info['avatar']?$info['avatar']:"https://admin.sjtuanliu.com/api/Uploads/images/2021/08/25/2021082514313916298730993398.png";
    	$line['title'] = self::unicodeDecode($info['title']);
    	$line['content'] = self::unicodeDecode($info['content']);
    	$line['sendtime'] = $info['sendtime'];

    	$line['likenumber'] = Db::name('article_like')->where("articleid",$info['id'])->count();
    	$line['isliked'] = 0;
		$line['commentnumber'] = Db::name('article_comment')->where("articleid",$info['id'])->where("pid",0)->where("isdeled",0)->count();

    	$line['ismine'] = 0;

		$line['favnumber'] = Db::name('article_fav')->where("articleid",$info['id'])->count();
    	$line['isfaved'] = 0;
    	$line['location'] = array();
    	$line['location']['address'] = $info['address'];
    	$line['location']['lng'] = $info['lng'];
    	$line['location']['lat'] = $info['lat'];
    	$line['location']['detailaddress'] = $info['detailaddress'];
    	$line['location']['point'] = $info['point'];

    	if ($info['id']==428)
    	{
    		($line['likenumber']>0)?$line['likenumber']+=1000:"";
    		($line['commentnumber']>0)?$line['commentnumber']+=1000:"";
    		($line['favnumber']>0)?$line['favnumber']+=1000:"";
    	}


    	$line['gotavatarlist'] = array();
    	$users = Db::name('web_user')->where('avatar IS NOT NULL')->orderRaw('rand()')->limit(3)->select();
    	foreach ($users as $key => $value) 
    	{
    		$line['gotavatarlist'][] = $value['avatar'];
    	}
    	$line['h5url'] = "https://h5.sjtuanliu.com/#/pages/tourism/tourism?id=".$info['id'];

    	if ($tokeninfo)
    	{
    		$isliked = Db::name('article_like')->where("articleid",$info['id'])->where("uid",$tokeninfo)->find();
    		if ($isliked['id'])
    		{
    			$line['isliked'] = 1;
    		}
    		$isfaved = Db::name('article_fav')->where("articleid",$info['id'])->where("uid",$tokeninfo)->find();
    		if ($isfaved['id'])
    		{
    			$line['isfaved'] = 1;
    		}
    		if ($info['authorid'] == $tokeninfo)
    		{
    			$line['ismine'] = 1;
    		}
    	}


        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => $line ));
	    die();

		
	}



	//获取首页信息流列表
	public function getList()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->getMoreToken();

		$morepost = $sysctrl->getMoreParam(array("page",'limit','lng','lat'));

		if (!$morepost['page']) $morepost['page'] = 1;
		if (!$morepost['limit']) $morepost['limit']= $this->pagelimit;

    	$sortstr = "a.id desc";

		$wherestr = " a.isdeled = 0 ";

	    $menus = Db::name('article')->alias("a")->field("id")->where($wherestr)->select();
	    $total = count($menus);

	    $rand = rand(0,10);
	    //$rand = 8;
	    $wordarray = array();
	    if ($rand == 8)
	    {//1/10的机会插入词条
	    	$wordlist = Db::name('words')->where("id>0")->select();
	    	$wordtotal = count($wordlist);
	    	$wordid = rand(0,$wordtotal-1);
	    	$wordinfo = $wordlist[$wordid];

	    	$wordarray['type'] = 2;
	    	$wordarray['id'] = $wordinfo['id'];
	    	$wordarray['title'] = $wordinfo['title'];
	    	$wordarray['content'] = $wordinfo['content'];
	    	$wordarray['banner'] = $wordinfo['pic'];
	    	$wordarray['bgimg'] = $wordinfo['pic'];
	    	$wordarray['subtitle'] = $wordinfo['subtitle'];
	    	$wordarray['btntxt'] = "去开个".$wordinfo['title']."盲盒";
	    }

	    $res = array();
	    $menus = Db::name('article')->alias("a")->field("a.*,b.name as nickname,b.avatar")->join("web_user b","a.authorid=b.id","left")->where($wherestr)->order($sortstr)->limit((($morepost['page']-1)*$morepost['limit']).",".$morepost['limit'])->select();
	    $insertrand = rand(0,count($menus)-1);
	    $i=0;
	    foreach ($menus as $key => $value) 
	    {
	    	$line = array();
	    	if (($i == $insertrand)&&$wordarray)
	    	{
	    		$line = $wordarray;
	    	}
	    	else
	    	{
		    	$line['type'] = 1;
		    	$line['id'] = $value['id'];
		    	$line['title'] = self::unicodeDecode($value['title']);
		    	$line['content'] = self::unicodeDecode($value['content']);

		    	$pics = json_decode($value['pics'],true);
	    		$bannernumber = count($pics)+1;
		    	// if (count($pics)>=4)
		    	// {
		    	// 	$bannernumber = 5;
		    	// }
		    	// else
		    	// {
		    	// 	$bannernumber = count($pics)+1;
		    	// }
		    	$line['bannernumber'] = $bannernumber;
		    	$line['bannerlist'] = array();
		    	$line['bannerlist'][] = $value['coverpic'];
		    	for($j=0;$j<$bannernumber-1;$j++)
		    	{
		    		$line['bannerlist'][] = $pics[$j];
		    	}
		    	$line['nickname'] = $value['nickname']?$value['nickname']:"";
		    	$line['avatar'] = $value['avatar']?$value['avatar']:"https://admin.sjtuanliu.com/api/Uploads/images/2021/08/25/2021082514313916298730993398.png";
		    	$line['sendtime'] = $value['sendtime'];
		    	$line['likenumber'] = Db::name('article_like')->where("articleid",$value['id'])->count();
		    	$line['isliked'] = 0;
		    	if ($tokeninfo)
		    	{
		    		$isliked = Db::name('article_like')->where("articleid",$value['id'])->where("uid",$tokeninfo)->find();
		    		if ($isliked['id'])
		    		{
		    			$line['isliked'] = 1;
		    		}
		    	}
		    	$line['commentnumber'] = Db::name('article_comment')->where("articleid",$value['id'])->where("pid",0)->where("isdeled",0)->count();

		    	$line['ismine'] = 0;

				$line['favnumber'] = Db::name('article_fav')->where("articleid",$value['id'])->count();
		    	$line['isfaved'] = 0;
		    	$line['location'] = array();
		    	$line['location']['address'] = $value['address'];
		    	$line['location']['lng'] = $value['lng'];
		    	$line['location']['lat'] = $value['lat'];
		    	$line['location']['detailaddress'] = $value['detailaddress'];
		    	$line['location']['point'] = $value['point'];

		    	if ($value['id']==428)
		    	{
		    		($line['likenumber']>0)?$line['likenumber']+=1000:"";
		    		($line['commentnumber']>0)?$line['commentnumber']+=1000:"";
		    		($line['favnumber']>0)?$line['favnumber']+=1000:"";
		    	}


		    	$line['gotavatarlist'] = array();
		    	$users = Db::name('web_user')->where('avatar IS NOT NULL')->orderRaw('rand()')->limit(3)->select();
		    	foreach ($users as $vv) 
		    	{
		    		$line['gotavatarlist'][] = $vv['avatar'];
		    	}
		    	$line['h5url'] = "https://h5.sjtuanliu.com/#/pages/tourism/tourism?id=".$value['id'];

		    	if ($tokeninfo)
		    	{
		    		$isliked = Db::name('article_like')->where("articleid",$value['id'])->where("uid",$tokeninfo)->find();
		    		if ($isliked['id'])
		    		{
		    			$line['isliked'] = 1;
		    		}
		    		$isfaved = Db::name('article_fav')->where("articleid",$value['id'])->where("uid",$tokeninfo)->find();
		    		if ($isfaved['id'])
		    		{
		    			$line['isfaved'] = 1;
		    		}
		    		if ($value['authorid'] == $tokeninfo)
		    		{
		    			$line['ismine'] = 1;
		    		}
		    	}




	    	}

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


	//写笔记
	public function createInfo()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();
		$post = $sysctrl->checkParam(array('title','content','pic')); 
		$morepost = $sysctrl->getMoreParam(array("id","lng","lat","address","detailaddress","point"));

		$post['content'] = str_replace("\n", "<br />", $post['content']);

		$post['content'] = str_replace("<", "&lt;", $post['content']);
		$post['content'] = str_replace(">", "&gt;", $post['content']);

		//add_log(0, 'createInfo', '', json_encode(array("token"=>$tokeninfo,"header"=>$_SERVER,"post"=>$post,"morepost"=>$morepost),JSON_UNESCAPED_UNICODE));

		$input = array();

		$ctrl = new Tencent();
		$obj = $ctrl->TextModeration($post['title']);
		$res = json_decode($obj,true);
		if ($res['Suggestion'] != "Pass")
		{
	        ajax_decode(array("code" => 30201,"msg"=>"您发送的标题中含有违规内容" , "data" => $data ));
		    die();
		}
		$obj = $ctrl->TextModeration(strip_tags($post['content']));
		$res = json_decode($obj,true);
		if ($res['Suggestion'] != "Pass")
		{
	        ajax_decode(array("code" => 30201,"msg"=>"您发送的内容中含有违规内容" , "data" => $data ));
		    die();
		}

		$input['title'] = self::unicodeEncode($post['title']);
		$input['content'] = self::unicodeEncode($post['content']);
		$input['address'] = $morepost['address']?$morepost['address']:"";
		$input['lng'] = $morepost['lng']?$morepost['lng']:"";
		$input['lat'] = $morepost['lat']?$morepost['lat']:"";
		$input['coverpic'] = $post['pic'][0];
		$input['sendway'] = 1;
		$input['detailaddress'] = $morepost['detailaddress']?$morepost['detailaddress']:"";
		$input['point'] = $morepost['point']?$morepost['point']:"0";

		$pics = array();
		for($i=1;$i<count($post['pic']);$i++)
		{
			$pics[] = $post['pic'][$i];
		}

		$input['pics'] = json_encode($pics,JSON_UNESCAPED_UNICODE);
		$input['authorid'] = $tokeninfo;
		$input['sendtime'] = date("Y-m-d H:i:s");

		$url = "https://restapi.amap.com/v3/geocode/regeo?key=d7c6689347cfca0fxxxxx&location=".$input['lng'].",".$input['lat'];
		$obj = self::httpGet($url);
		$res = json_decode($obj,true);
		$tmp = $res['regeocode']['addressComponent'];
		$input['province'] = $tmp['province']?$tmp['province']:"";
		$input['city'] = $tmp['city']?$tmp['city']:($tmp['province']?$tmp['province']:"");
		$input['district'] = $tmp['district']?$tmp['district']:"";

		$user = Db::name('web_user')->where("id",$tokeninfo)->find();
		$input['authorname'] = $user['name'];

		if ($morepost['id'])
		{
			Db::name('article')->where("id",$morepost['id'])->update($input);
			$id = $morepost['id'];
		}
		else
		{
			$find = Db::name('article')->where("title",$input['title'])->where("authorid",$input['authorid'])->where("coverpic",$input['coverpic'])->find();
			if ($find['id'])
			{
				$id = $find['id'];
			}
			else
			{
				$id = Db::name('article')->insertGetId($input);
			}
		}

        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => array("id"=>$id) ));
	    die();

		
	}



	//删除笔记
	public function deleteInfo()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();
		$post = $sysctrl->checkParam(array('id')); 
		$find = Db::name('article')->where("id",$post['id'])->find();
		if ($find['authorid'] != $tokeninfo)
		{
	        ajax_decode(array("code" => 30101,"msg"=>"不能删除他人内容" , "data" => array() ));
		    die();			
		}

		Db::name('article')->where("id",$post['id'])->update(array("isdeled"=>1));
		Db::name('article_comment')->where("articleid",$post['id'])->update(array("isdeled"=>1));
		Db::name('article_like')->where("articleid",$post['id'])->delete();
		Db::name('article_fav')->where("articleid",$post['id'])->delete();
		Db::name('article_report')->where("articleid",$post['id'])->delete();

        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => array() ));
	    die();

		
	}



	//点赞/取消点赞
	public function likeArticle()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();
		$post = $sysctrl->checkParam(array('id')); 

		$info = Db::name('article_like')->where("articleid",$post['id'])->where("uid",$tokeninfo)->find();
		if ($info['id'])
		{
			Db::name('article_like')->where("id",$info['id'])->delete();
		}
		else
		{
			$input = array();
			$input['articleid'] = $post['id'];
			$input['uid'] = $tokeninfo;
			$input['intabletime'] = date("Y-m-d H:i:s");
			Db::name('article_like')->insert($input);
		}

        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => array() ));
	    die();

		
	}


	//收藏/取消收藏
	public function favArticle()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();
		$post = $sysctrl->checkParam(array('id')); 

		$info = Db::name('article_fav')->where("articleid",$post['id'])->where("uid",$tokeninfo)->find();
		if ($info['id'])
		{
			Db::name('article_fav')->where("id",$info['id'])->delete();
		}
		else
		{
			$input = array();
			$input['articleid'] = $post['id'];
			$input['uid'] = $tokeninfo;
			$input['intabletime'] = date("Y-m-d H:i:s");
			Db::name('article_fav')->insert($input);
		}

        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => array() ));
	    die();

		
	}



	//我发布的笔记
	public function getMyInfoList()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		$morepost = $sysctrl->getMoreParam(array("page",'limit'));

		if (!$morepost['page']) $morepost['page'] = 1;
		if (!$morepost['limit']) $morepost['limit']= $this->pagelimit;

    	$sortstr = "id desc";

		$wherestr = " authorid ='".$tokeninfo."' and isdeled = 0 ";

	    $menus = Db::name('article')->field("id")->where($wherestr)->select();
	    $total = count($menus);

	    $res = array();
	    $menus = Db::name('article')->where($wherestr)->order($sortstr)->limit((($morepost['page']-1)*$morepost['limit']).",".$morepost['limit'])->select();
	    foreach ($menus as $key => $value) 
	    {
	    	$line = array();
	    	$line['id'] = $value['id'];
	    	$line['title'] = self::unicodeDecode($value['title']);
	    	$line['banner'] = $value['coverpic'];

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



	//首页信息流搜索列表
	public function getSearchList()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->getMoreToken();

		$morepost = $sysctrl->getMoreParam(array("page",'limit','title'));

		if (!$morepost['page']) $morepost['page'] = 1;
		if (!$morepost['limit']) $morepost['limit']= $this->pagelimit;

    	$sortstr = "id desc";

		$wherestr = " title LIKE '%".$morepost['title']."%' and isdeled = 0 ";

	    $menus = Db::name('article')->field("id")->where($wherestr)->select();
	    $total = count($menus);

	    $res = array();
	    $menus = Db::name('article')->where($wherestr)->order($sortstr)->limit((($morepost['page']-1)*$morepost['limit']).",".$morepost['limit'])->select();
	    foreach ($menus as $key => $value) 
	    {
	    	$line = array();
	    	$line['id'] = $value['id'];
	    	$line['title'] = self::unicodeDecode($value['title']);
	    	$line['banner'] = $value['coverpic'];

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



	//我收藏的文章
	public function getMyfavList()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		$morepost = $sysctrl->getMoreParam(array("page",'limit'));

		if (!$morepost['page']) $morepost['page'] = 1;
		if (!$morepost['limit']) $morepost['limit']= $this->pagelimit;

    	$sortstr = "a.id desc";

		$wherestr = " a.uid ='".$tokeninfo."' ";

	    $menus = Db::name('article_fav')->alias("a")->field("id")->where($wherestr)->select();
	    $total = count($menus);

	    $res = array();
	    $menus = Db::name('article_fav')->alias("a")->field("a.id,a.articleid,b.coverpic,b.title,b.sendtime,c.name as nickname,c.avatar")->join("article b","a.articleid=b.id","left")->join("web_user c","b.authorid=c.id","left")->where($wherestr)->order($sortstr)->limit((($morepost['page']-1)*$morepost['limit']).",".$morepost['limit'])->select();
	    foreach ($menus as $key => $value) 
	    {
	    	$line = array();
	    	$line['id'] = $value['articleid'];
	    	$line['title'] = self::unicodeDecode($value['title']);
	    	$line['banner'] = $value['coverpic'];
	    	$line['nickname'] = $value['nickname'];
	    	$line['avatar'] = $value['avatar'];
	    	$line['sendtime'] = $value['sendtime'];

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


	//获取信息流评论列表
	public function getCommentList()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->getMoreToken();
		$post = $sysctrl->checkParam(array('id')); 

		$morepost = $sysctrl->getMoreParam(array("page",'limit','commentid'));

		if (!$morepost['page']) $morepost['page'] = 1;
		if (!$morepost['limit']) $morepost['limit']= $this->pagelimit;

    	$sortstr = "a.id asc";

		$wherestr = " a.articleid ='".$post['id']."' and a.pid = 0 and a.isdeled = 0 ";
		if ($morepost['commentid'])
		{
			$wherestr .= " and id='".$morepost['commentid']."' ";
		}

	    $user = Db::name('web_user')->field("avatar,name")->where("id",$tokeninfo)->find();

	    $menus = Db::name('article_comment')->alias("a")->field("id")->where($wherestr)->select();
	    $total = count($menus);

	    $res = array();
	    $menus = Db::name('article_comment')->alias("a")->field("a.*,b.name as nickname,b.avatar")->join("web_user b","a.uid=b.id","left")->where($wherestr)->order("a.id desc")->limit((($morepost['page']-1)*$morepost['limit']).",".$morepost['limit'])->select();
	    foreach ($menus as $key => $value) 
	    {
	    	$line = array();
	    	$line['commentid'] = $value['id'];
	    	$line['avatar'] = $value['avatar'];
	    	$line['nickname'] = $value['nickname'];
	    	$line['avatar'] = $value['avatar'];
	    	$line['content'] = self::unicodeDecode($value['content']);
	    	$line['sendtime'] = $value['sendtime'];
	    	$line['ismine'] = ($value['uid']==$tokeninfo)?1:0;
	    	$line['replylist'] = array();

	    	$replys = Db::name('article_comment')->alias("a")->field("a.*,b.name as nickname,b.avatar")->join("web_user b","a.uid=b.id","left")->where(" a.articleid ='".$post['id']."' and a.pid = '".$value['id']."' and a.isdeled = 0 ")->order("a.id asc")->select();

	    	foreach ($replys as $v) 
	    	{
	    		$row = array();
		    	$row['commentid'] = $value['id'];
	    		$row['replyid'] = $v['id'];
	    		$row['avatar'] = $v['avatar'];
	    		$row['commentnickname'] = $value['nickname'];
	    		$row['nickname'] = $v['nickname'];
	    		$row['content'] = self::unicodeDecode($v['content']);
	    		$row['sendtime'] = $v['sendtime'];
	    		$row['ismine'] = ($v['uid']==$tokeninfo)?1:0;
	    		$line['replylist'][] = $row;
	    	}

	    	$res[] = $line;
	    }

	    $data = array(
	    	"myavatar" => $user['avatar'],
	    	"mynickname" => $user['name'],
	    	"list" => $res,
	    	"totalnum" => $total,
	    	"totalpage" => ceil($total / $morepost['limit']),
	    	"currpage" => $morepost['page'],
	    );

        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => $data ));
	    die();

		
	}

	//删除评论或回复
	public function deleteComment()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();
		$post = $sysctrl->checkParam(array('id')); 

		Db::name('article_comment')->where("id",$post['id'])->update(array("isdeled"=>1));
		Db::name('article_comment')->where("pid",$post['id'])->update(array("isdeled"=>1));

        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => array() ));
	    die();

		
	}


	//举报笔记
	public function reportInfo()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();
		$post = $sysctrl->checkParam(array('id')); 

		$input = array();
		$input['articleid'] = $post['id'];
		$input['commentid'] = 0;
		$input['uid'] = $tokeninfo;
		$input['intabletime'] = date("Y-m-d H:i:s");

		Db::name('article_report')->insert($input);

        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => array() ));
	    die();

		
	}



	//举报评论或回复
	public function reportComment()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();
		$post = $sysctrl->checkParam(array('id')); 

		$comminfo = Db::name('article_comment')->where("id",$post['id'])->find();

		$input = array();
		$input['articleid'] = $comminfo['articleid'];
		$input['commentid'] = $comminfo['id'];
		$input['uid'] = $tokeninfo;
		$input['intabletime'] = date("Y-m-d H:i:s");

		Db::name('article_report')->insert($input);

        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => array() ));
	    die();

		
	}


	//写评论
	public function createComment()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();
		$post = $sysctrl->checkParam(array('articleid','content')); 

		$morepost = $sysctrl->getMoreParam(array("commentid"));

		$post['content'] = str_replace("\n", "<br />", $post['content']);

		$ctrl = new Tencent();
		$obj = $ctrl->TextModeration($post['content']);
		$res = json_decode($obj,true);
		if ($res['Suggestion'] != "Pass")
		{
	        ajax_decode(array("code" => 30201,"msg"=>"您发送的内容中含有违规内容" , "data" => $data ));
		    die();
		}

		$input = array();
		$input['articleid'] = $post['articleid'];
		$input['uid'] = $tokeninfo;
		$input['pid'] = $morepost['commentid']?$morepost['commentid']:0;
		$input['content'] = self::unicodeEncode($post['content']);
		$input['sendtime'] = date("Y-m-d H:i:s");

		$id = Db::name('article_comment')->insertGetId($input);
		$user = Db::name('web_user')->where("id",$tokeninfo)->find();

		$res = array();
		$res['commentid'] = 0;
		$res['replyid'] = 0;
		if ($morepost['commentid'])
		{
			$res['commentid'] = $morepost['commentid'];
			$res['replyid'] = $id;
		}
		else
		{
			$res['commentid'] = $id;
		}
		$res['avatar'] = $user['avatar'];
		$res['nickname'] = $user['name'];
		$res['content'] = $post['content'];
		$res['sendtime'] = $input['sendtime'];
		$res['ismine'] = 1;

        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => $res ));
	    die();

		
	}



	//获取首页信息流首页广告
	public function getBannerList()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->getMoreToken();

		$morepost = $sysctrl->getMoreParam(array('lng','lat'));


	    $res = array();
	    $menus = Db::name('banner')->where("type=1")->where("startdate<='".date("Y-m-d")."'")->where("enddate>='".date("Y-m-d")."'")->where("starttime<='".date("H:i:s")."'")->where("endtime>='".date("H:i:s")."'")->select();
	    $res['bannertype'] = count($menus);
	    $res['list'] = array();

	    foreach ($menus as $key => $value) 
	    {
	    	$line = array();
	    	$line['pic'] = $value['pic'];
	    	$line['targettype'] = $value['targettype'];
	    	$line['param'] = $value['param'];
	    	$res['list'][] = $line;
	    }

        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => $res ));
	    die();

	}



	//获取首页信息流弹出广告
	public function getPopupPic()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->getMoreToken();

		$morepost = $sysctrl->getMoreParam(array('lng','lat'));

	    $res = array();
	    $value = Db::name('banner')->where("type",2)->where("startdate<='".date("Y-m-d")."'")->where("enddate>='".date("Y-m-d")."'")->where("starttime<='".date("H:i:s")."'")->where("endtime>='".date("H:i:s")."'")->find();
	    $res['showpic'] = $value['id']?1:0;
	    $res['pic'] = $value['pic']?$value['pic']:"";
	    $res['targettype'] = $value['id']?$value['targettype']:"";
	    $res['param'] = $value['id']?$value['param']:"";

        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => $res ));
	    die();

	}




}

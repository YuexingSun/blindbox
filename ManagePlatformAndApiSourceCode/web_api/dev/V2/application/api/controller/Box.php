<?php
namespace app\api\controller;

use think\Db;
use think\Request;
use think\Controller; 
use think\cache\driver\Redis;
use app\common\controller\Common; 
use app\common\controller\JiGuang;

class Box extends Controller
{

	private $TokenTime = 86400;
	private $BoxTimes = 3600;//1小时过期
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

	private function getDistance($s){
		if ($s >= 1000)
		{
			return round($s/1000,1)."公里";
		}
		else
		{
			return $s."米";
		}

	  	return "";
	}

	private function twoGetDistance($lng1, $lat1, $lng2, $lat2)
	{
		$radLat1 = $lat1 * PI() / 180.0;
		$radLat2 = $lat2 * PI() / 180.0;

		$a = $radLat1 - $radLat2;

		$b = ($lng1 * PI() / 180.0) - ($lng2 * PI() / 180.0);

		$s = 2 * asin(sqrt(pow(sin($a/2),2) + cos($radLat1) * cos($radLat2) * pow(sin($b/2),2)));

		$s = $s * 6378.137;

		$s = round($s * 1000);

		return $s;

	}


	private function clacLngLat($lng,$lat,$dis){

		$earch = 6371;

		$dlng = 2 * asin(sin($dis/(2*$earch))/cos(deg2rad($lat)));
		$dlng = rad2deg($dlng);

		$dlat = $dis/$earch;
		$dlat = rad2deg($dlat);
		$res = array();
		$res['dlng'] = $dlng;
		$res['dlat'] = $dlat;
		return $res;
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


	//获取可选盲盒类型
	public function getBoxType()
	{
		$sysctrl = new System();
		//$tokeninfo = $sysctrl->checkToken();

		$data = array();
		$list = Db::name('box_type')->select();
		foreach ($list as $key => $value) 
		{
			$line = array();
			$line['typeid'] = $value['id'];
			$line['pic'] = $value['pic'];
			$line['title'] = $value['title'];
			$line['status'] = $value['status'];
			$data[] = $line;
		}

        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => $data ));
        die();

	}

	//获取盲盒待答问题
	public function getBoxQuesList()
	{
		$sysctrl = new System();
		//$tokeninfo = $sysctrl->checkToken();

		$post = $sysctrl->checkParam(array('typeid')); 

		$data = array();
		$list = Db::name('box_question_v2')->where("typeid",$post['typeid'])->order("sortid desc")->select();
		foreach ($list as $key => $value) 
		{
			$line = array();
			$line['id'] = $value['id'];
			$line['title'] = $value['title'];
			$line['type'] = $value['styletype'];
			$line['defaultid'] = $value['defaultid'];

			if ($value['styletype'] == "image")
			{
				//$line['itemlist'] = array();
				$itemlist = array();

				$optlist = Db::name('box_question_option_v2')->where("quesid",$value['id'])->select();
				$defaultset = array();
				foreach ($optlist as $kk => $v) 
				{
					$item = array();
					$item['itemid'] = $v['id'];
					$item['itemname'] = $v['itemname'];
					//$item['isdefault'] = ($v['id'] == $value['defaultid'])?1:0;
					if (!$defaultset["imagelist".$v['fornums']])
					{
						$item['isdefault'] = 1;
						$defaultset["imagelist".$v['fornums']] = 1;
					}
					else
					{
						$item['isdefault'] = 0;
					}
					//$item['isdefault'] = ($kk == 0)?1:0;
					if ($line['type'] == "image")
					{
						$pics = explode(",", $v['itempic']);
						$item['itempic'] = $pics[0];
						$item['itemselpic'] = $pics[1];
						$colorlist = json_decode($v['colorlist'],true);
						$item['textcolor'] = $colorlist['textcolor'];

					}

					//$line["imagelist".$v['fornums']][] = $item;
					$itemlist["imagelist".$v['fornums']][] = $item;
				}
				$line['itemdict'] = $itemlist;
			}
			else
			{
				$line['itemlist'] = array();

				$optlist = Db::name('box_question_option_v2')->where("quesid",$value['id'])->select();
				foreach ($optlist as $v) 
				{
					$item = array();
					$item['itemid'] = $v['id'];
					$item['itemname'] = $v['itemname'];
					$item['isdefault'] = ($v['id'] == $value['defaultid'])?1:0;
					if ($line['id'] == 4)
					{//出行人数，特殊处理
						$item['imglistname'] = "imagelist".$v['fornums'];
					}

					$line['itemlist'][] = $item;
				}

			}


			$data[] = $line;
		}

        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => array("pagenum"=>2,"list"=>$data)));
        die();

	}



	//获取盲盒
	public function getOne()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		$json = file_get_contents('php://input'); 
		$data = $sysctrl->ext_json_decode($json, true);
		$tokenin = $data['token'];
	    if ($tokenin == "")
	    {
			$tokenin = Request::instance()->request('token'); 
		    if ($tokenin == "")
		    {
		    	$tokenin = $_SERVER['HTTP_TOKEN'];
		    }
	    }

		$post = $sysctrl->checkParam(array('typeid','lng','lat')); 
		$morepost = $sysctrl->getMoreParam(array('jsonstr',"cateid","wordid")); 

		add_log(0, 'getOne', '', json_encode(array("token"=>$tokeninfo,"header"=>$_SERVER,"post"=>$post,"morepost"=>$morepost),JSON_UNESCAPED_UNICODE));


		$whereprice = "";
		$whereway = "";
		$ansinfostr = "";
		$wayline = 0;
		$txt6kind = "";
		$colorlist = "";
		$nowheart = "";
		$hearttext = "";
		$nowheartid = "";

		$selectheartid = 0;
		$selectheartimg = "";
		//var_dump($tokeninfo);

		$uid = $tokeninfo?$tokeninfo:0;

		if (!$morepost['jsonstr']) 
		{
			$post['jsonstr'] = array();

			$list = Db::name('box_question_v2')->where("typeid",$post['typeid'])->order("sortid desc")->select();
			foreach ($list as $key => $value) 
			{
				$line = array();
				$line['ans'] = $value['defaultid'];
				$line['quesid'] = $value['id'];
				$post['jsonstr'][] = $line;
			}
		}
		else
		{
			$post['jsonstr'] = $morepost['jsonstr'];
		}


		foreach ($post['jsonstr'] as $key => $value) 
		{
			if ((!$value['ans'])||(!$value['quesid']))
			{
		        ajax_decode(array("code" => 20002,"msg"=>"开盒条件缺失，请重试" , "data" => array() ));
		        die();
			}

			$ansinfo = Db::name('box_question_option_v2')->where("id",$value['ans'])->find();

			if ($value['quesid'] == 1)
			{//价格
				if ($ansinfo['truedata'] == "999999")
				{
				}
				else
				{
					$tmp = explode("-", $ansinfo['truedata']);
					if ($tmp[1])
					{
						$whereprice = " and g.consume >='".$tmp[0]."' and g.consume <= '".$tmp[1]."' ";
					}
					else
					{
						$whereprice = " and g.consume <= '".$tmp[0]."' ";
					}
				}
			}
			elseif ($value['quesid'] == 3)
			{//心情
				$nowheart = $ansinfo['itemname'];
				$nowheartid = $ansinfo['id'];

				if ($ansinfo['truedata'] != "")
				{
					$ansinfostr = $ansinfo['truedata'];
					$ansinfostr = str_replace("[", "(", $ansinfostr);
					$ansinfostr = str_replace("]", ")", $ansinfostr);
				}
				if ($ansinfo['txt'])
				{
					$txt6kind = $ansinfo['txt'];
				}
				$colorlist = $ansinfo['colorlist'];

				$selectheartid = $ansinfo['id'];
				$tmphearimg = explode(",", $ansinfo['itempic']);
				$selectheartimg = $tmphearimg[2];

			}
		}

		//已去过的店，不再分配 暂时不排除，只是降低权重
		$notidstr = "";
		$cutcateidarr = array();
		$cutcateidarr2 = array();
		$destinationarr = array();
		$hasgonelist = Db::name('box_pre_list')->field("firstcateid,destinationid")->where("uid",$uid)->select();
		foreach ($hasgonelist as $key => $value) 
		{
			//$notidstr .= $value['destinationid'].",";
			$cutcateidarr[] = $value['firstcateid'];
			$destinationarr[] = $value['destinationid'];
		}
		$notidstr .= "0";
		$hasgonelist = Db::name('box_pre_list')->field("firstcateid,destinationid")->where("uid",$uid)->where("createtime >='".date("Y-m-d H:i:s",strtotime("-3 day"))."' ")->select();
		foreach ($hasgonelist as $key => $value) 
		{
			//$notidstr .= $value['destinationid'].",";
			$cutcateidarr2[] = $value['firstcateid'];
			//$destinationarr[] = $value['destinationid'];
		}


		//加入营业时间
		$toweek = date("w");
		if ($toweek == 0) $toweek = 7;
		$totime = date("H:i:s");
		$toendtime = date("H:i:s",time()+60*60);
		$wheretime = " and (c.weekid IS NULL or c.weekid='".$toweek."') and (c.timestart <= '".$totime."' OR c.timestart IS NULL) and (c.timeend IS NULL or (c.timeend >= '".$totime."' and c.timestart < c.timeend )or ( c.timestart > c.timeend ) ) ";

		//用户已拥有的标签对于出来B端标签
		$mytags = Db::name('web_user')->alias("a")->field("d.btagid,d.samenum")
				->join("user_tag b","a.id = b.uid","left")
				->join("tagclient_list c","b.tagid=c.id","left")
				->join("tag_same d","d.ctagid=c.id","left")
				->join("tag_list e","d.btagid=e.id","left")
			->where(" a.id ='".$uid."' ")
			->select();

		//心情加权
		$myhearts = array();
		if ($ansinfostr)
		{
			$myhearts = Db::name('tagclient_list')->alias("a")->field("d.btagid,d.samenum")
					->join("tag_same d","d.ctagid=a.id","left")
					->join("tag_list e","d.btagid=e.id","left")
				->where(" a.id in ".$ansinfostr )
				->select();
		}	

		$data = array();

		//先生成一个空的盲盒
		$input = array();
		$input['destinationid'] = 0;
		$input['firstcateid'] = 0;
		$input['heartjson'] = json_encode(array("id"=>$selectheartid,"img"=>$selectheartimg),JSON_UNESCAPED_UNICODE);//记录开盒时心情
		$input['title'] = "未知盲盒";
		$input['uid'] = $uid;
		$input['realname'] = "未知目的地";
		$input['readaddress'] = "未知目的地";
		$input['buildname'] = "未知目的地";
		$input['address'] = "未知目的地";
		$input['createtime'] = date("Y-m-d H:i:s");
		$input['status'] = 0;
		$input['expiretime'] = date("Y-m-d H:i:s",time()+$this->BoxTimes);
		$trueboxid = Db::name('box_list')->insertGetId($input);

		//临时已被选中的列表，用于权重减半
		$alreadylist = array();
		$totalprenumber = 0;//总共开出的盒数
		//固定三档距离
		$lineway = array(500,3000,10000);

		$outreslist = array();
		$outreslist['parentlist'] = array();

		$where_more_cate = "";
		$defaultmainlist = array(1,2,3);//默认情况下的三个分类
		//单品类开盒
		if ($morepost['cateid'])
		{
			$firstcateinfo = Db::name('first_cate')->where("id",$morepost['cateid'])->find();
			if ($firstcateinfo['id'])
			{
				$where_more_cate = " and g.firstcateid='".$morepost['cateid']."' ";
				$defaultmainlist = array($firstcateinfo['baseid'],$firstcateinfo['baseid'],$firstcateinfo['baseid']);//单品类情况下，三个都用同一分类
			}
		}


		foreach ($lineway as $linevalue) 
		{
			$childlist = array();
			$childlist['range'] = $linevalue;
			$childlist['childlist'] = array();

			//每一档距离的条件计算
			$clacLngLat = self::clacLngLat($post['lng'],$post['lat'],$linevalue/1000/sqrt(2));
			$minlat = $post['lat'] - $clacLngLat['dlat'];
			$maxlat = $post['lat'] + $clacLngLat['dlat'];
			$minlng = $post['lng'] - $clacLngLat['dlng'];
			$maxlng = $post['lng'] + $clacLngLat['dlng'];

			$whereway = " and g.lat >= '".$minlat."' and g.lat <= '".$maxlat."' and g.lng >= '".$minlng."' and g.lng <= '".$maxlng."' ";

			//for($mainid=1;$mainid<=3;$mainid++)
			for($indexnum=0;$indexnum<3;$indexnum++)
			{
				$mainid = $defaultmainlist[$indexnum];

				$base_typeinfo = Db::name('base_type')->where("id",$mainid)->find();

				$dlistinfo = Db::name('destination')->alias("g")->field("g.*,b.name as firstcatename")
						->join("first_cate b","g.firstcateid=b.id","left")
						->join("destination_time c","g.id=c.destinationid","left")
						->where("g.id > 0 and g.status = 0 and maintypeid = '".$mainid."' ".$whereprice.$wheretime.$whereway.$where_more_cate)
						->group("g.id")
						->select();

// echo "g.id > 0 and g.status = 0 and maintypeid = '".$mainid."' ".$whereprice.$wheretime.$whereway;
// die();

				$didlist = array();
				$i = 0;
				while($dlistinfo[$i]['id'])
				{
					$tmp = Db::name('destination_tag')->field("tagid")->where("destinationid",$dlistinfo[$i]['id'])->select();
					$checklist = array();
					foreach ($tmp as $key => $value) 
					{
						$checklist[] = $value['tagid'];
					}
					$tmp = Db::name('cate_tag')->field("tagid")->where("cateid",$dlistinfo[$i]['firstcateid'])->select();
					foreach ($tmp as $key => $value) 
					{
						if (!in_array($value['tagid'], $checklist))
						{
							$checklist[] = $value['tagid'];
						}
					}

					$line = array();
					$line['id'] = $dlistinfo[$i]['id'];
					$line['power'] = 100;
					foreach ($mytags as $key => $value) 
					{
						if (in_array($value['btagid'], $checklist))
						{
							$line['power'] += $value['samenum'];
						}
					}
					foreach ($myhearts as $key => $value) 
					{
						if (in_array($value['btagid'], $checklist))
						{
							$line['power'] += $value['samenum'];
						}
					}

					//去过的分类，权重减半
					foreach ($cutcateidarr as $key => $value) 
					{
						if ($value == $dlistinfo[$i]['firstcateid'])
						{
							$line['power'] *= 0.9;
							break;
						}
					}

					//去过的店，权重减5
					foreach ($destinationarr as $key => $value) 
					{
						if ($value == $dlistinfo[$i]['id'])
						{
							$line['power'] *= 0.2;
						}
					}

					foreach ($cutcateidarr2 as $key => $value) 
					{
						if ($value == $dlistinfo[$i]['firstcateid'])
						{
							$line['power'] *= 0.9;
						}
					}
					//此次已分配过的店，权重减半
					foreach ($alreadylist as $key => $value) 
					{
						if ($value == $dlistinfo[$i]['id'])
						{
							$line['power'] *= 0.2;
						}
					}

					$didlist[] = $line;

					$i++;
				}

				array_multisort(array_column($didlist,'power'),SORT_DESC,$didlist);

		// var_dump($didlist);
		// die();
				$maxpoint = 0;
				if(count($didlist) > 0 )
				{
					if ($didlist[0]['power'] >= 130)
					{
						$maxpoint = 130;
					}
					elseif ($didlist[0]['power'] >= 100)
					{
						$maxpoint = 100;
					}
					elseif ($didlist[0]['power'] >= 70)
					{
						$maxpoint = 70;
					}
					elseif ($didlist[0]['power'] >= 30)
					{
						$maxpoint = 30;
					}
					else
					{
						$maxpoint = 0;
					}
				}

				$waittingsellist = array();
				foreach ($didlist as $onedid) 
				{
					if ($onedid['power'] >= $maxpoint)
					{
						$waittingsellist[] = $onedid;
					}
				}

				$line = array();
				if (count($waittingsellist) <=0 )
				{//没有结果

				}
				else
				{
					$totalprenumber++;

					$randnum = count($waittingsellist)-1;
					$rand = rand(0,$randnum);

					$dinfo = Db::name('destination')->alias("a")->field("a.*,b.name as firstcatename,b.pic as logo,b.showtextlist,b.bgpic")->join("first_cate b","a.firstcateid=b.id","left")->where("a.id",$didlist[$rand]['id'])->find();

					$vartextstr = "";
					$vartextlist = array();
					$selectproductid = "";
					$productinfo = Db::name('product_list')->where("destinationid",$dinfo['id'])->find();
					if ($productinfo['content'])
					{//商品自有文案
						$selectproductid = $productinfo['id'];
						$vartextstr = $productinfo['content']."{{SJTL1}}{{SJTL2}}{{SJTL3}}{{SJTL4}}";
						$vartextlist[] = "";
						$vartextlist[] = "";
						$vartextlist[] = "";
						$vartextlist[] = "";
					}
					else
					{//标准文案模板
						//$tmp = Db::name('system_config')->field("setvalue")->where("setkey","BoxOpenText")->find();
						$tmp = Db::name('boxheart_temp_text')->where("typeid",$mainid)->where("heartid",$nowheartid)->find();

						$tmpstr = json_decode($tmp['txt'],true);
						$randindex = rand(0,count($tmpstr)-1);
						$vartextstr = $tmpstr[$randindex];

						if ($productinfo['name'])
						{
							$vartextlist[] = $productinfo['name'];
						}
						else
						{
							$vartextlist[] = $dinfo['firstcatename'];
						}
						$vartextlist[] = "";
						$vartextlist[] = "";
						$vartextlist[] = "";//$dinfo['firstcatename'];

					}

					//如果有菜品，使用菜品名，如果没有菜品，使用分类名
					$productorcatename = $dinfo['firstcatename'];
					if ($productinfo['name'])
					{
						$productorcatename = $productinfo['name'];
					}

					$input = array();
					$input['boxid'] = $trueboxid;
					$input['rangeline'] = $linevalue;//当前距离
					$input['indexid'] = $totalprenumber;
					$input['destinationid'] = $dinfo['id'];
					$input['maintypeid'] = $dinfo['maintypeid'];
					$input['firstcateid'] = $dinfo['firstcateid'];
					$input['productid'] = $selectproductid;
					//$input['title'] = $dinfo['firstcatename'];
					$input['title'] = $productorcatename;
					$newtitle = "";
					$tmp = json_decode($dinfo['showtextlist'],true);
					if (count($tmp) > 0)
					{
						if ($tmp[0]) $newtitle = $tmp[0];
					}
					if ($newtitle)
					{
						$input['title'] = $newtitle;
					}
					$input['uid'] = $uid;
					$input['pic'] = $dinfo['bgpic'];
					$input['logo'] = $dinfo['logo']?$dinfo['logo']:$this->defaultLogoFile;
					$input['lng'] = $dinfo['lng'];
					$input['lat'] = $dinfo['lat'];
					$input['realname'] = $dinfo['name'];//preg_replace("/\(.*\)/","",$dinfo['name']);
					$input['readaddress'] = $dinfo['address'];
					//替省市区
					$input['readaddress'] = str_replace($dinfo['province'], "", $input['readaddress']);
					$input['readaddress'] = str_replace($dinfo['city'], "", $input['readaddress']);
					$input['readaddress'] = str_replace($dinfo['district'], "", $input['readaddress']);

					//根据坐标查询附近地址
					$url = "https://restapi.amap.com/v3/geocode/regeo?key=d7c6689347cfca0xxxxxx&location=".$input['lng'].",".$input['lat'];
					$obj = self::httpGet($url);
					$res = json_decode($obj,true);

					$input['buildname'] = $input['readaddress']."附近";
					$input['address'] = $input['readaddress'];
					if ($res['regeocode']['addressComponent'])
					{
						$tmp = $res['regeocode']['addressComponent'];
						if ($tmp['building']['name'])
						{
							$input['buildname'] = $tmp['building']['name']."附近";
						}
						elseif ($res['regeocode']['formatted_address'])
						{
							$input['address'] = $res['regeocode']['formatted_address'];
						}
					}
					//$input['detail'] = $txt6kind;
					$input['detail'] = $input['title'];
					$input['title'] = $productorcatename;
					$input['colorlist'] = $base_typeinfo['colorlist'];//$colorlist;
					$input['vartext'] = $vartextstr;
					$input['arrivedvarlist'] = json_encode($vartextlist,JSON_UNESCAPED_UNICODE);

					$navigationlist = array();

					//导航路径
					$lineonenum = self::twoGetDistance($post['lng'],$post['lat'],$dinfo['lng'],$dinfo['lat']);
					if ($lineonenum <= 1000)
					{
						$url = "https://restapi.amap.com/v5/direction/walking?key=d7c6689347cfcaxxxxx&isindoor=1&origin=".$post['lng'].",".$post['lat']."&destination=".$dinfo['lng'].",".$dinfo['lat'];
					}
					else
					{
						$url = "https://restapi.amap.com/v5/direction/driving?key=d7c6689347cfca0xxxxxx&isindoor=1&origin=".$post['lng'].",".$post['lat']."&destination=".$dinfo['lng'].",".$dinfo['lat'];
					}

					$obj = self::httpGet($url);
					$res = json_decode($obj,true);
					if ($res['route']['paths'])
					{
						$tmp = $res['route']['paths'];
					}
					$input['navigationlist'] = json_encode($navigationlist,JSON_UNESCAPED_UNICODE);

					$showitems = array();
					$one = array();
					$one['item'] = "实时距离";
					$one['type'] = 1;
					$one['value'] = $tmp[0]['distance']?self::getDistance($tmp[0]['distance']):"";
					$showitems[] = $one;
					$one = array();
					$one['item'] = "人均消费";
					$one['type'] = 2;
					$one['value'] = "￥".$dinfo['consume'];
					$showitems[] = $one;
					$one = array();
					$one['item'] = "神秘感";
					$one['type'] = 3;
					$one['value'] = rand(7,10)/2;
					$showitems[] = $one;
					$one = array();
					$one['item'] = "新鲜感";
					$one['type'] = 4;
					$one['value'] = rand(7,10)/2;
					$showitems[] = $one;
					$input['showitems'] = json_encode($showitems,JSON_UNESCAPED_UNICODE);

					$tmp = Db::name('box_list')->alias("a")->field("b.avatar")->join("web_user b","a.uid=b.id","left")->where("destinationid",$dinfo['id'])->where('b.avatar IS NOT NULL')->group("a.uid")->select();

					if (count($tmp) == 0)
					{
						$tmp = Db::name('box_list')->alias("a")->field("b.avatar")->join("web_user b","a.uid=b.id","left")->where("destinationid > 0 and uid > 0 ")->where('b.avatar IS NOT NULL')->group("a.uid")->orderRaw('rand()')->limit(3)->select();
					}

					$input['gotnum'] = count($tmp);
					$gotavatarlist = array();
					$i = 0;
					foreach ($tmp as $key => $value) 
					{
						if ($i >=5)
						{
							break;
						}
						$gotavatarlist[] = $value['avatar'];
						$i++;
					}


					$input['gotavatarlist'] = json_encode($gotavatarlist,JSON_UNESCAPED_UNICODE);
					$destinapoint = rand(45,50);
					$input['destinapoint'] = round($destinapoint/10,1);
					$input['createtime'] = date("Y-m-d H:i:s");
					$input['status'] = 0;
					$input['expiretime'] = date("Y-m-d H:i:s",time()+$this->BoxTimes);
					$boxid = Db::name('box_pre_list')->insertGetId($input);

					$alreadylist[] = $dinfo['id'];

					$boxinfo = Db::name('box_pre_list')->where("id",$boxid)->find();
					$destinationinfo = Db::name('destination')->where("id",$boxinfo['destinationid'])->find();

					//输出
					$line['boxid'] = $boxinfo['boxid'];
					$line['indexid'] = $boxinfo['indexid'];
					$line['title'] = $boxinfo['title'];
					$line['pic'] = $boxinfo['pic'];
					$line['logo'] = $boxinfo['logo'];
					$line['typename'] = $base_typeinfo['name'];
					$line['typeid'] = $base_typeinfo['id'];
					$line['typelogo'] = $base_typeinfo['logo'];
					$line['realname'] = $boxinfo['realname'];
					$line['readAddress'] = $boxinfo['readaddress'];
					$line['buildName'] = $boxinfo['buildname'];
					$line['address'] = $boxinfo['address'];
					$mob = $destinationinfo['mob'];
					$mob = str_replace(" ", ",", $mob);
					$line['mob'] = $mob?$mob:"";
					$line['detail'] = $boxinfo['detail'];
					$line['colorlist'] = json_decode($boxinfo['colorlist'],true);
					$line['arrivedtext'] = $boxinfo['vartext'];
					$line['arrivedvarlist'] = json_decode($boxinfo['arrivedvarlist'],true);
					$line['detail'] = $boxinfo['detail'];
					
					$tmp = Db::name('system_config')->field("setvalue")->where("setkey","StartBoxGotPoint")->find();
					$line['beinpoint'] = $tmp['setvalue'];
					$tmp = Db::name('system_config')->field("setvalue")->where("setkey","CommentBoxGotPoint")->find();
					$line['commentpoint'] = $tmp['setvalue'];
					$tmp = Db::name('system_config')->field("setvalue")->where("setkey","ShareBoxGotPoint")->find();
					$line['sharepoint'] = $tmp['setvalue'];
					$line['items'] = json_decode($boxinfo['showitems'],true);
					$line['gotnum'] = $boxinfo['gotnum'];
					$line['gotlist'] = json_decode($boxinfo['gotavatarlist'],true);
					$line['point'] = $boxinfo['destinapoint'];
					$line['lnglat']['lng'] = $boxinfo['lng'];
					$line['lnglat']['lat'] = $boxinfo['lat'];
					$line['gotnum'] = $boxinfo['gotnum'];
					$line['expiretime'] = strtotime($boxinfo['expiretime']);
					$line['navigationlist'] = json_decode($boxinfo['navigationlist'],true);

					$line['activityinfo'] = 1;
					$line['url'] = "https://h5.sjtuanliu.com/#/pages/lottery/lottery?token=".$tokenin."&boxid=".$boxinfo['boxid'];


				}
				if ($line)
				{
					$childlist['childlist'][] = $line;
				}
			}
			$outreslist['parentlist'][] = $childlist;
		}

		$outreslist['heartid'] = $selectheartid;
		$outreslist['heartimg'] = $selectheartimg;

		$totalfirst = $outreslist['parentlist'][0];

		if (count($totalfirst['childlist']) <= 1 )
		{
			$input = array();
			$input['uid'] = $uid;
			$input['lng'] = $post['lng'];
			$input['lat'] = $post['lat'];
			$input['intabletime'] = date("Y-m-d H:i:s");
			Db::name('cant_list')->insert($input);
		}
		// if ($totalprenumber <=0 )
		// {
	 //        ajax_decode(array("code" => 20003,"msg"=>"当前城市暂未开放！" , "data" => array() ));
	 //        die();
		// }

		//Db::name('box_list')->where("id",$trueboxid)->update(array("istmp"=>1));

		add_log(0, 'getOneAnswer', '', json_encode($outreslist,JSON_UNESCAPED_UNICODE));

        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => $outreslist ));
        die();

	}


	//盲盒启程
	public function startBox()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		$post = $sysctrl->checkParam(array('boxid','indexid')); 

		$preinfo = Db::name('box_pre_list')->where("boxid",$post['boxid'])->where("indexid",$post['indexid'])->find();
		if (!$preinfo['id'])
		{
	        ajax_decode(array("code" => 10034,"msg"=>"盲盒信息不存在" , "data" => $data ));
	        die();
		}

		$input = array();
		$input['destinationid'] = $preinfo['destinationid'];
		$input['firstcateid'] = $preinfo['firstcateid'];
		$input['baseid'] = $preinfo['maintypeid'];
		$input['productid'] = $preinfo['productid'];
		$input['title'] = $preinfo['title'];
		$input['uid'] = $preinfo['uid'];
		$input['pic'] = $preinfo['pic'];
		$input['logo'] = $preinfo['logo'];
		$input['lng'] = $preinfo['lng'];
		$input['lat'] = $preinfo['lat'];
		$input['realname'] = $preinfo['realname'];
		$input['readaddress'] = $preinfo['readaddress'];
		$input['buildname'] = $preinfo['buildname'];
		$input['address'] = $preinfo['address'];
		$input['detail'] = $preinfo['detail'];
		$input['colorlist'] = $preinfo['colorlist'];
		$input['vartext'] = $preinfo['vartext'];
		$input['arrivedvarlist'] = $preinfo['arrivedvarlist'];
		$input['navigationlist'] = $preinfo['navigationlist'];
		$input['showitems'] = $preinfo['showitems'];
		$input['gotnum'] = $preinfo['gotnum'];
		$input['gotavatarlist'] = $preinfo['gotavatarlist'];
		$input['destinapoint'] = $preinfo['destinapoint'];
		$input['status'] = 1;
		$input['starttime'] = date("Y-m-d H:i:s");
		$input['preid'] = $preinfo['id'];
		$input['istmp'] = 1;

		Db::name('box_list')->where("id",$preinfo['boxid'])->update($input);

		$json = file_get_contents('php://input'); 
		$data = $sysctrl->ext_json_decode($json, true);
		$tokenin = $data['token'];
	    if ($tokenin == "")
	    {
			$tokenin = Request::instance()->request('token'); 
		    if ($tokenin == "")
		    {
		    	$tokenin = $_SERVER['HTTP_TOKEN'];
		    }
	    }

		$data = array();
		$data['activityinfo'] = 1;
		$data['url'] = "https://h5.sjtuanliu.com/#/pages/lottery/lottery?token=".$tokenin."&boxid=".$post['boxid'];

        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => $data ));
        die();

	}


	//盲盒到达
	public function arrivedBox()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		$post = $sysctrl->checkParam(array('boxid')); 

		$info = Db::name('box_list')->where("id",$post['boxid'])->find();

		Db::name('box_list')->where("id",$post['boxid'])->update(
			array("status"=>2,
				"arrivedtime"=>date("Y-m-d H:i:s"),
				"title" => $info['realname'],
		));

		$json = file_get_contents('php://input'); 
		$data = $sysctrl->ext_json_decode($json, true);
		$tokenin = $data['token'];
	    if ($tokenin == "")
	    {
			$tokenin = Request::instance()->request('token'); 
		    if ($tokenin == "")
		    {
		    	$tokenin = $_SERVER['HTTP_TOKEN'];
		    }
	    }

		$data = array();
		$data['activityinfo'] = 1;
		$data['url'] = "https://h5.sjtuanliu.com/#/pages/lottery/lottery?token=".$tokenin."&boxid=".$post['boxid'];

        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => $data ));
        die();

	}

	//判断盲盒是否到达
	public function checkBoxArrived()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		$post = $sysctrl->checkParam(array('boxid','lng','lat')); 

		//$boxid = Db::name('box_list')->where("id",$post['boxid'])->update(array("islike"=>$post['islike']));
		$isarrived = 1;

        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => array("isarrived"=>$isarrived) ));
        die();

	}



	//盲盒完成
	public function finishBox()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();


        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => array() ));
        die();

	}

	//盲盒中止
	public function cancelBox()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		$post = $sysctrl->checkParam(array('boxid')); 

		Db::name('box_list')->where("id",$post['boxid'])->update(
			array("status"=>5,
				"canceltime"=>date("Y-m-d H:i:s")
		));

        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => array() ));
        die();

	}	

	//盲盒评价
	public function enjoyBox()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		$post = $sysctrl->checkParam(array('boxid')); 
		$morepost = $sysctrl->getMoreParam(array('content')); 
		$content = $morepost['content']?$morepost['content']:"";

		$commentcontent = array();
		if ($content)
		{
			$tmp = explode("|", $content);
			foreach ($tmp as $key => $value) 
			{
				if ($value)
				{
					$commentcontent[] = $value;
				}
			}
		}

		$update = array("status"=>3,
				"commentcontent"=>json_encode($commentcontent,JSON_UNESCAPED_UNICODE),
				"commenttime"=>date("Y-m-d H:i:s"));
		if (count($commentcontent) <=0 )
		{
			$update['islike'] = 1;
		}
		else
		{
			$update['islike'] = 2;
		}

		Db::name('box_list')->where("id",$post['boxid'])->update($update);

        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => array() ));
        die();

	}


	//获取可选分类
	public function getBoxCateTypes()
	{
		$sysctrl = new System();
		
		$colorlist = Db::name('cate_color_list')->field("txtcolor,bgcolor,linecolor")->where("id>0")->select();

		$list = Db::name('first_cate')->field("id as cateid,name as title")->where("id > 0")->orderRaw("rand()")->limit(20)->select();

        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => array("colorlist"=>$colorlist,"catelist"=>$list) ));
        die();

	}



	//获取盲盒详情
	public function getBoxDetail()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		$json = file_get_contents('php://input'); 
		$data = $sysctrl->ext_json_decode($json, true);
		$tokenin = $data['token'];
	    if ($tokenin == "")
	    {
			$tokenin = Request::instance()->request('token'); 
		    if ($tokenin == "")
		    {
		    	$tokenin = $_SERVER['HTTP_TOKEN'];
		    }
	    }

		$post = $sysctrl->checkParam(array('boxid')); 

		$boxtrueinfo = Db::name('box_list')->where("id",$post['boxid'])->find();

		//固定三档距离
		$lineway = array(500,3000,10000);

		$outreslist = array();
		$outreslist['parentlist'] = array();

		$selparentindex = 0;
		$selchildindex = 0;

		$allparentindex = 0;
		$allchildindex = 0;

		foreach ($lineway as $oneline) 
		{
			$allchildindex = 0;

			$childlist = array();
			$childlist['range'] = $oneline;
			$childlist['childlist'] = array();

			$boxprelist = Db::name('box_pre_list')->where("boxid",$post['boxid'])->where("rangeline",$oneline)->order("id asc")->select();
			foreach ($boxprelist as $key => $boxinfo) 
			{

				$basetypeinfo = Db::name('base_type')->where("id",$boxinfo['maintypeid'])->find();
				$destinationinfo = Db::name('destination')->where("id",$boxinfo['destinationid'])->find();

				//输出
				$line = array();
				$line['boxid'] = $boxinfo['boxid'];
				$line['indexid'] = $boxinfo['indexid'];

				if ((($boxtrueinfo['destinationid'])||($boxtrueinfo['status']>0))&&($boxinfo['id']==$boxtrueinfo['preid']))
				{//用真实盒替换原有数据
					$boxinfo = $boxtrueinfo;

					$selparentindex = $allparentindex;
					$selchildindex = $allchildindex;
				}


				$line['title'] = $boxinfo['title'];
				$line['pic'] = $boxinfo['pic'];
				$line['logo'] = $boxinfo['logo'];
				$line['typename'] = $basetypeinfo['name'];
				$line['typeid'] = $basetypeinfo['id'];
				$line['typelogo'] = $basetypeinfo['logo'];
				$line['realname'] = $boxinfo['realname'];
				$line['readAddress'] = $boxinfo['readaddress'];
				$line['buildName'] = $boxinfo['buildname'];
				$line['address'] = $boxinfo['address'];
				$mob = $destinationinfo['mob'];
				$mob = str_replace(" ", ",", $mob);
				$line['mob'] = $mob?$mob:"";
				$line['detail'] = $boxinfo['detail'];
				$line['colorlist'] = json_decode($boxinfo['colorlist'],true);
				$line['arrivedtext'] = $boxinfo['vartext'];
				$line['arrivedvarlist'] = json_decode($boxinfo['arrivedvarlist'],true);
				$line['detail'] = $boxinfo['detail'];
				
				$tmp = Db::name('system_config')->field("setvalue")->where("setkey","StartBoxGotPoint")->find();
				$line['beinpoint'] = $tmp['setvalue'];
				$tmp = Db::name('system_config')->field("setvalue")->where("setkey","CommentBoxGotPoint")->find();
				$line['commentpoint'] = $tmp['setvalue'];
				$tmp = Db::name('system_config')->field("setvalue")->where("setkey","ShareBoxGotPoint")->find();
				$line['sharepoint'] = $tmp['setvalue'];
				$line['items'] = json_decode($boxinfo['showitems'],true);
				$line['gotnum'] = $boxinfo['gotnum'];
				$line['gotlist'] = json_decode($boxinfo['gotavatarlist'],true);
				$line['point'] = $boxinfo['destinapoint'];
				$line['lnglat']['lng'] = $boxinfo['lng'];
				$line['lnglat']['lat'] = $boxinfo['lat'];
				$line['gotnum'] = $boxinfo['gotnum'];
				$line['expiretime'] = strtotime($boxinfo['expiretime']);
				$line['navigationlist'] = json_decode($boxinfo['navigationlist'],true);
				$line['status'] = $boxinfo['status'];
				$line['starttime'] = $boxinfo['starttime']?strtotime($boxinfo['starttime']):"";
				$line['islike'] = $boxinfo['islike'];
				// $line['commentislike'] = $boxinfo['commentlike'];
				$line['mycommentlist'] = json_decode($boxinfo['commentcontent'],true);
				$line['isgotgift'] = 0;

				$line['activityinfo'] = 1;
				$line['url'] = "https://h5.sjtuanliu.com/#/pages/lottery/lottery?token=".$tokenin."&boxid=".$post['boxid'];


				$line['isgotgift'] = 0;
				$line['isgotgift'] = 0;

				$childlist['childlist'][] = $line;
				$allchildindex++;
			}
			$outreslist['parentlist'][] = $childlist;
			$allparentindex++;

		}


		$outreslist['selected'] = false;
		$outreslist['selparentindex'] = $selparentindex;
		$outreslist['selchildindex'] = $selchildindex;
		$heartjson = json_decode($boxtrueinfo['heartjson'],true);
		$outreslist['heartid'] = $heartjson['id'];
		$outreslist['heartimg'] = $heartjson['img'];

		if (($boxtrueinfo['destinationid'])||($boxtrueinfo['status']>0))
		{
			$outreslist['selected'] = true;
		}

        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => $outreslist ));
        die();

	}


	//查询是否有未开启和进行中的盲盒(完成)
	public function checkBeingBox()
	{
		$sysctrl = new System();
		$tokeninfo = $sysctrl->checkToken();

		$input = array();
		$input['uid'] = $tokeninfo;
		$input['time'] = date("Y-m-d H:i:s");
		Db::name('checkbox_log')->insert($input);

		$data = array();
		$boxid = Db::name('box_list')->where("uid = '".$tokeninfo."' AND (status = 0 OR status = 1 OR status = 2) AND istmp = 1 ")->find();

		if ($boxid['id'])
		{
			$data['isbeing'] = 1;
			$data['boxid'] = $boxid['id'];
			$data['status'] = $boxid['status'];
		}
		else
		{
			$data['isbeing'] = 0;
		}

        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => $data ));
        die();

	}





	//获取盲盒
	public function getOneTest()
	{
		$sysctrl = new System();

		$getmoney = $_GET['money'];
		$lnglat = $_GET['lnglat'];
		$heart = $_GET['heart'];
		//$getmoney = $_GET['heart'];

		$tokeninfo = 18;
		$post['typeid'] = 2;
		$post['lng'] = 116.397717;
		$post['lat'] = 39.907798;
		if ($lnglat)
		{
			$tmp = explode(",", $lnglat);
			$post['lng'] = $tmp[0];
			$post['lat'] = $tmp[1];

		}

		$post['jsonstr'] = "[";
		if ($getmoney == "100")
		{
			$post['jsonstr'] .= '{"ans":"2","quesid":"1"},';
		}
		elseif ($getmoney == "200")
		{
			$post['jsonstr'] .= '{"ans":"3","quesid":"1"},';
		}
		elseif ($getmoney == "500")
		{
			$post['jsonstr'] .= '{"ans":"4","quesid":"1"},';
		}
		elseif ($getmoney == "0")
		{
			$post['jsonstr'] .= '{"ans":"1","quesid":"1"},';
		}
		else
		{
			$post['jsonstr'] .= '{"ans":"6","quesid":"1"},';
		}

		if (!$heart)
		{
			$heart = 11;
		}

		$post['jsonstr'] .= '{"ans":"'.$heart.'","quesid":"3"},';

		$post['jsonstr'] .= '{"ans":"17","quesid":"4"}]';
		$post['jsonstr'] = json_decode($post['jsonstr'],true);


		add_log(0, 'getOne', '', json_encode(array("token"=>$tokeninfo,"header"=>$_SERVER,"post"=>$post),JSON_UNESCAPED_UNICODE));


		add_log(0, 'changelocation', '', json_encode($post,JSON_UNESCAPED_UNICODE));

		$whereprice = "";
		$whereway = "";
		$ansinfostr = "";
		$wayline = 0;
		$txt6kind = "";
		$colorlist = "";
		$nowheart = "";
		$hearttext = "";
		$nowheartid = "";

		//var_dump($tokeninfo);

		$uid = $tokeninfo?$tokeninfo:0;

		foreach ($post['jsonstr'] as $key => $value) 
		{
			if ((!$value['ans'])||(!$value['quesid']))
			{
		        ajax_decode(array("code" => 20002,"msg"=>"开盒条件缺失，请重试" , "data" => array() ));
		        die();
			}

			$ansinfo = Db::name('box_question_option')->where("id",$value['ans'])->find();

			if ($value['quesid'] == 1)
			{//价格
				if ($ansinfo['truedata'] == "999999")
				{
				}
				else
				{
					$tmp = explode("-", $ansinfo['truedata']);
					if ($tmp[1])
					{
						$whereprice = " and g.consume >='".$tmp[0]."' and g.consume <= '".$tmp[1]."' ";
					}
					else
					{
						$whereprice = " and g.consume <= '".$tmp[0]."' ";
					}
				}
			}
			elseif ($value['quesid'] == 3)
			{//心情
				$nowheart = $ansinfo['itemname'];
				$nowheartid = $ansinfo['id'];

				if ($ansinfo['truedata'] != "")
				{
					$ansinfostr = $ansinfo['truedata'];
					$ansinfostr = str_replace("[", "(", $ansinfostr);
					$ansinfostr = str_replace("]", ")", $ansinfostr);
				}
				if ($ansinfo['txt'])
				{
					$txt6kind = $ansinfo['txt'];
				}
				$colorlist = $ansinfo['colorlist'];
			}
		}

		//已去过的店，不再分配 暂时不排除，只是降低权重
		$notidstr = "";
		$cutcateidarr = array();
		$cutcateidarr2 = array();
		$destinationarr = array();
		$hasgonelist = Db::name('box_pre_list')->field("firstcateid,destinationid")->where("uid",$uid)->select();
		foreach ($hasgonelist as $key => $value) 
		{
			//$notidstr .= $value['destinationid'].",";
			$cutcateidarr[] = $value['firstcateid'];
			$destinationarr[] = $value['destinationid'];
		}
		$notidstr .= "0";
		$hasgonelist = Db::name('box_pre_list')->field("firstcateid,destinationid")->where("uid",$uid)->where("createtime >='".date("Y-m-d H:i:s",strtotime("-3 day"))."' ")->select();
		foreach ($hasgonelist as $key => $value) 
		{
			//$notidstr .= $value['destinationid'].",";
			$cutcateidarr2[] = $value['firstcateid'];
			//$destinationarr[] = $value['destinationid'];
		}

		//加入营业时间
		$toweek = date("w");
		if ($toweek == 0) $toweek = 7;
		$totime = date("H:i:s");
		$toendtime = date("H:i:s",time()+60*60);
		$wheretime = " and (c.weekid IS NULL or c.weekid='".$toweek."') and (c.timestart <= '".$totime."' OR c.timestart IS NULL) and (c.timeend IS NULL or (c.timeend >= '".$totime."' and c.timestart < c.timeend )or ( c.timestart > c.timeend ) ) ";

		//用户已拥有的标签对于出来B端标签
		$mytags = Db::name('web_user')->alias("a")->field("d.btagid,d.samenum")
				->join("user_tag b","a.id = b.uid","left")
				->join("tagclient_list c","b.tagid=c.id","left")
				->join("tag_same d","d.ctagid=c.id","left")
				->join("tag_list e","d.btagid=e.id","left")
			->where(" a.id ='".$uid."' ")
			->select();

		//心情加权
		$myhearts = array();
		if ($ansinfostr)
		{
			$myhearts = Db::name('tagclient_list')->alias("a")->field("d.btagid,d.samenum")
					->join("tag_same d","d.ctagid=a.id","left")
					->join("tag_list e","d.btagid=e.id","left")
				->where(" a.id in ".$ansinfostr )
				->select();
		}	

		$data = array();

		//先生成一个空的盲盒
		$input = array();
		$input['destinationid'] = 0;
		$input['firstcateid'] = 0;
		$input['title'] = "未知盲盒";
		$input['uid'] = $uid;
		$input['realname'] = "未知目的地";
		$input['readaddress'] = "未知目的地";
		$input['buildname'] = "未知目的地";
		$input['address'] = "未知目的地";
		$input['createtime'] = date("Y-m-d H:i:s");
		$input['status'] = 0;
		$input['expiretime'] = date("Y-m-d H:i:s",time()+$this->BoxTimes);
		$trueboxid = Db::name('box_list')->insertGetId($input);

		//临时已被选中的列表，用于权重减半
		$alreadylist = array();
		$totalprenumber = 0;//总共开出的盒数
		//固定三档距离
		$lineway = array(500,3000,10000);

		$outreslist = array();
		$outreslist['parentlist'] = array();

		foreach ($lineway as $linevalue) 
		{
			$childlist = array();
			$childlist['range'] = $linevalue;
			$childlist['childlist'] = array();

echo "<br><br><br><br>".$linevalue."米之内的三组<br><br>";


			//每一档距离的条件计算
			$clacLngLat = self::clacLngLat($post['lng'],$post['lat'],$linevalue/1000/sqrt(2));
			$minlat = $post['lat'] - $clacLngLat['dlat'];
			$maxlat = $post['lat'] + $clacLngLat['dlat'];
			$minlng = $post['lng'] - $clacLngLat['dlng'];
			$maxlng = $post['lng'] + $clacLngLat['dlng'];

			$whereway = " and g.lat >= '".$minlat."' and g.lat <= '".$maxlat."' and g.lng >= '".$minlng."' and g.lng <= '".$maxlng."' ";

			for($mainid=1;$mainid<=3;$mainid++)
			{
				$base_typeinfo = Db::name('base_type')->where("id",$mainid)->find();

				$dlistinfo = Db::name('destination')->alias("g")->field("g.*,b.name as firstcatename")
						->join("first_cate b","g.firstcateid=b.id","left")
						->join("destination_time c","g.id=c.destinationid","left")
						->where("g.id > 0 and g.status = 0 and maintypeid = '".$mainid."' ".$whereprice.$wheretime.$whereway)
						->group("g.id")
						->select();

// echo "g.id > 0 and g.status = 0 and maintypeid = '".$mainid."' ".$whereprice.$wheretime.$whereway;
// die();

				$didlist = array();
				$i = 0;
				while($dlistinfo[$i]['id'])
				{
					$tmp = Db::name('destination_tag')->field("tagid")->where("destinationid",$dlistinfo[$i]['id'])->select();
					$checklist = array();
					foreach ($tmp as $key => $value) 
					{
						$checklist[] = $value['tagid'];
					}
					$tmp = Db::name('cate_tag')->field("tagid")->where("cateid",$dlistinfo[$i]['firstcateid'])->select();
					foreach ($tmp as $key => $value) 
					{
						if (!in_array($value['tagid'], $checklist))
						{
							$checklist[] = $value['tagid'];
						}
					}

					$line = array();
					$line['id'] = $dlistinfo[$i]['id'];
					$line['power'] = 100;
					$line['showstr'] = "";

$line['showstr'].= $dlistinfo[$i]['id']."----".$dlistinfo[$i]['name']."----".$line['power']."----";

					foreach ($mytags as $key => $value) 
					{
						if (in_array($value['btagid'], $checklist))
						{
							$line['power'] += $value['samenum'];
						}
					}
$line['showstr'].=  "标后:".$line['power']."---";
					foreach ($myhearts as $key => $value) 
					{
						if (in_array($value['btagid'], $checklist))
						{
							$line['power'] += $value['samenum'];
						}
					}
$line['showstr'].= "心后:".$line['power']."---";

					//去过的分类，权重减半
					foreach ($cutcateidarr as $key => $value) 
					{
						if ($value == $dlistinfo[$i]['firstcateid'])
						{
							$line['power'] *= 0.9;
							break;
						}
					}
$line['showstr'].= "去类后:".$line['power']."---";

					//去过的店，权重减5
					foreach ($destinationarr as $key => $value) 
					{
						if ($value == $dlistinfo[$i]['id'])
						{
							$line['power'] *= 0.2;
						}
					}
$line['showstr'].= "去店后:".$line['power']."---";

					foreach ($cutcateidarr2 as $key => $value) 
					{
						if ($value == $dlistinfo[$i]['firstcateid'])
						{
							$line['power'] *= 0.9;
						}
					}
$line['showstr'].=  "去类2后:".$line['power']."---";
					//此次已分配过的店，权重减半
					foreach ($alreadylist as $key => $value) 
					{
						if ($value == $dlistinfo[$i]['id'])
						{
							$line['power'] *= 0.2;
						}
					}
$line['showstr'].=  "分配过后:".$line['power']."---";

$line['showstr'].= "终值:".$line['power']."---<br>";

					$didlist[] = $line;

					$i++;
				}

				array_multisort(array_column($didlist,'power'),SORT_DESC,$didlist);


				foreach ($didlist as $showone) 
				{
					echo $showone['showstr'];
				}

		// var_dump($didlist);
		// die();
				$maxpoint = 0;
				if(count($didlist) > 0 )
				{
					if ($didlist[0]['power'] >= 130)
					{
						$maxpoint = 130;
					}
					elseif ($didlist[0]['power'] >= 100)
					{
						$maxpoint = 100;
					}
					elseif ($didlist[0]['power'] >= 70)
					{
						$maxpoint = 70;
					}
					elseif ($didlist[0]['power'] >= 30)
					{
						$maxpoint = 30;
					}
					else
					{
						$maxpoint = 0;
					}
				}

				$waittingsellist = array();
				foreach ($didlist as $onedid) 
				{
					if ($onedid['power'] >= $maxpoint)
					{
						$waittingsellist[] = $onedid;
					}
				}

				$line = array();
				if (count($waittingsellist) <=0 )
				{//没有结果

				}
				else
				{
					$totalprenumber++;

					$randnum = count($waittingsellist)-1;
					$rand = rand(0,$randnum);

					$dinfo = Db::name('destination')->alias("a")->field("a.*,b.name as firstcatename,b.pic as logo,b.showtextlist,b.bgpic")->join("first_cate b","a.firstcateid=b.id","left")->where("a.id",$didlist[$rand]['id'])->find();

echo "<hr>选中:".$dinfo['id']."--".$dinfo['name']."-<br><hr>";

					$vartextstr = "";
					$vartextlist = array();
					$productinfo = Db::name('product_list')->where("destinationid",$dinfo['id'])->find();
					if ($productinfo['content'])
					{//商品自有文案
						$vartextstr = $productinfo['content']."{{SJTL1}}{{SJTL2}}{{SJTL3}}{{SJTL4}}";
						$vartextlist[] = "";
						$vartextlist[] = "";
						$vartextlist[] = "";
						$vartextlist[] = "";
					}
					else
					{//标准文案模板
						//$tmp = Db::name('system_config')->field("setvalue")->where("setkey","BoxOpenText")->find();
						$tmp = Db::name('boxheart_temp_text')->where("typeid",$mainid)->where("heartid",$nowheartid)->find();

						$tmpstr = json_decode($tmp['txt'],true);
						$randindex = rand(0,count($tmpstr)-1);
						$vartextstr = $tmpstr[$randindex];

						if ($productinfo['name'])
						{
							$vartextlist[] = $productinfo['name'];
						}
						else
						{
							$vartextlist[] = $dinfo['firstcatename'];
						}
						$vartextlist[] = "";
						$vartextlist[] = "";
						$vartextlist[] = "";//$dinfo['firstcatename'];

					}

					$input = array();
					$input['boxid'] = $trueboxid;
					$input['rangeline'] = $linevalue;//当前距离
					$input['indexid'] = $totalprenumber;
					$input['destinationid'] = $dinfo['id'];
					$input['maintypeid'] = $dinfo['maintypeid'];
					$input['firstcateid'] = $dinfo['firstcateid'];
					$input['title'] = $dinfo['firstcatename'];
					$newtitle = "";
					$tmp = json_decode($dinfo['showtextlist'],true);
					if (count($tmp) > 0)
					{
						if ($tmp[0]) $newtitle = $tmp[0];
					}
					if ($newtitle)
					{
						$input['title'] = $newtitle;
					}
					$input['uid'] = $uid;
					$input['pic'] = $dinfo['bgpic'];
					$input['logo'] = $dinfo['logo']?$dinfo['logo']:$this->defaultLogoFile;
					$input['lng'] = $dinfo['lng'];
					$input['lat'] = $dinfo['lat'];
					$input['realname'] = $dinfo['name'];//preg_replace("/\(.*\)/","",$dinfo['name']);
					$input['readaddress'] = $dinfo['address'];

					//根据坐标查询附近地址
					$url = "https://restapi.amap.com/v3/geocode/regeo?key=d7c6689347cfca0xxxxxx&location=".$input['lng'].",".$input['lat'];
					$obj = self::httpGet($url);
					$res = json_decode($obj,true);

					$input['buildname'] = $dinfo['address']."附近";
					$input['address'] = $dinfo['address'];
					if ($res['regeocode']['addressComponent'])
					{
						$tmp = $res['regeocode']['addressComponent'];
						if ($tmp['building']['name'])
						{
							$input['buildname'] = $tmp['building']['name']."附近";
						}
						elseif ($res['regeocode']['formatted_address'])
						{
							$input['address'] = $res['regeocode']['formatted_address'];
						}
					}
					$input['detail'] = $txt6kind;
					$input['colorlist'] = $base_typeinfo['colorlist'];//$colorlist;
					$input['vartext'] = $vartextstr;
					$input['arrivedvarlist'] = json_encode($vartextlist,JSON_UNESCAPED_UNICODE);

					$navigationlist = array();

					//导航路径
					$lineonenum = self::twoGetDistance($post['lng'],$post['lat'],$dinfo['lng'],$dinfo['lat']);
					if ($lineonenum <= 1000)
					{
						$url = "https://restapi.amap.com/v5/direction/walking?key=d7c6689347cfcaxxxxx&isindoor=1&origin=".$post['lng'].",".$post['lat']."&destination=".$dinfo['lng'].",".$dinfo['lat'];
					}
					else
					{
						$url = "https://restapi.amap.com/v5/direction/driving?key=d7c6689347cfcaxxxxx&isindoor=1&origin=".$post['lng'].",".$post['lat']."&destination=".$dinfo['lng'].",".$dinfo['lat'];
					}

					$obj = self::httpGet($url);
					$res = json_decode($obj,true);
					if ($res['route']['paths'])
					{
						$tmp = $res['route']['paths'];
					}
					$input['navigationlist'] = json_encode($navigationlist,JSON_UNESCAPED_UNICODE);

					$showitems = array();
					$one = array();
					$one['item'] = "实时距离";
					$one['type'] = 1;
					$one['value'] = $tmp[0]['distance']?self::getDistance($tmp[0]['distance']):"";
					$showitems[] = $one;
					$one = array();
					$one['item'] = "人均消费";
					$one['type'] = 2;
					$one['value'] = "￥".$dinfo['consume'];
					$showitems[] = $one;
					$one = array();
					$one['item'] = "神秘感";
					$one['type'] = 3;
					$one['value'] = rand(7,10)/2;
					$showitems[] = $one;
					$one = array();
					$one['item'] = "新鲜感";
					$one['type'] = 4;
					$one['value'] = rand(7,10)/2;
					$showitems[] = $one;
					$input['showitems'] = json_encode($showitems,JSON_UNESCAPED_UNICODE);

					$tmp = Db::name('box_list')->alias("a")->field("b.avatar")->join("web_user b","a.uid=b.id","left")->where("destinationid",$dinfo['id'])->where('b.avatar IS NOT NULL')->group("a.uid")->select();

					if (count($tmp) == 0)
					{
						$tmp = Db::name('box_list')->alias("a")->field("b.avatar")->join("web_user b","a.uid=b.id","left")->where("destinationid > 0 and uid > 0 ")->where('b.avatar IS NOT NULL')->group("a.uid")->orderRaw('rand()')->limit(3)->select();
					}

					$input['gotnum'] = count($tmp);
					$gotavatarlist = array();
					$i = 0;
					foreach ($tmp as $key => $value) 
					{
						if ($i >=5)
						{
							break;
						}
						$gotavatarlist[] = $value['avatar'];
						$i++;
					}


					$input['gotavatarlist'] = json_encode($gotavatarlist,JSON_UNESCAPED_UNICODE);
					$destinapoint = rand(45,50);
					$input['destinapoint'] = round($destinapoint/10,1);
					$input['createtime'] = date("Y-m-d H:i:s");
					$input['status'] = 0;
					$input['expiretime'] = date("Y-m-d H:i:s",time()+$this->BoxTimes);
					$boxid = Db::name('box_pre_list')->insertGetId($input);

					$alreadylist[] = $dinfo['id'];

					$boxinfo = Db::name('box_pre_list')->where("id",$boxid)->find();
					$destinationinfo = Db::name('destination')->where("id",$boxinfo['destinationid'])->find();

					//输出
					$line['boxid'] = $boxinfo['boxid'];
					$line['indexid'] = $boxinfo['indexid'];
					$line['title'] = $boxinfo['title'];
					$line['pic'] = $boxinfo['pic'];
					$line['logo'] = $boxinfo['logo'];
					$line['typename'] = $base_typeinfo['name'];
					$line['typeid'] = $base_typeinfo['id'];
					$line['typelogo'] = $base_typeinfo['logo'];
					$line['realname'] = $boxinfo['realname'];
					$line['readAddress'] = $boxinfo['readaddress'];
					$line['buildName'] = $boxinfo['buildname'];
					$line['address'] = $boxinfo['address'];
					$mob = $destinationinfo['mob'];
					$mob = str_replace(" ", ",", $mob);
					$line['mob'] = $mob?$mob:"";
					$line['detail'] = $boxinfo['detail'];
					$line['colorlist'] = json_decode($boxinfo['colorlist'],true);
					$line['arrivedtext'] = $boxinfo['vartext'];
					$line['arrivedvarlist'] = json_decode($boxinfo['arrivedvarlist'],true);
					$line['detail'] = $boxinfo['detail'];
					
					$tmp = Db::name('system_config')->field("setvalue")->where("setkey","StartBoxGotPoint")->find();
					$line['beinpoint'] = $tmp['setvalue'];
					$tmp = Db::name('system_config')->field("setvalue")->where("setkey","CommentBoxGotPoint")->find();
					$line['commentpoint'] = $tmp['setvalue'];
					$tmp = Db::name('system_config')->field("setvalue")->where("setkey","ShareBoxGotPoint")->find();
					$line['sharepoint'] = $tmp['setvalue'];
					$line['items'] = json_decode($boxinfo['showitems'],true);
					$line['gotnum'] = $boxinfo['gotnum'];
					$line['gotlist'] = json_decode($boxinfo['gotavatarlist'],true);
					$line['point'] = $boxinfo['destinapoint'];
					$line['lnglat']['lng'] = $boxinfo['lng'];
					$line['lnglat']['lat'] = $boxinfo['lat'];
					$line['gotnum'] = $boxinfo['gotnum'];
					$line['expiretime'] = strtotime($boxinfo['expiretime']);
					$line['navigationlist'] = json_decode($boxinfo['navigationlist'],true);


				}
				if ($line)
				{
					$childlist['childlist'][] = $line;
				}
			}
			$outreslist['parentlist'][] = $childlist;
		}
		$totalfirst = $outreslist['parentlist'][0];

		if (count($totalfirst['childlist']) <= 1 )
		{
			$input = array();
			$input['uid'] = $uid;
			$input['lng'] = $post['lng'];
			$input['lat'] = $post['lat'];
			$input['intabletime'] = date("Y-m-d H:i:s");
			Db::name('cant_list')->insert($input);
		}

		// if ($totalprenumber <=0 )
		// {
	 //        ajax_decode(array("code" => 20003,"msg"=>"当前城市暂未开放！" , "data" => array() ));
	 //        die();
		// }

		//Db::name('box_list')->where("id",$trueboxid)->update(array("istmp"=>1));

		add_log(0, 'getOneAnswer', '', json_encode($outreslist,JSON_UNESCAPED_UNICODE));

        ajax_decode(array("code" => 0,"msg"=>"Success" , "data" => $outreslist ));
        die();

	}




}

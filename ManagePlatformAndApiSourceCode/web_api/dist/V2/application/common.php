<?php
// +----------------------------------------------------------------------
// | ThinkPHP [ WE CAN DO IT JUST THINK ]
// +----------------------------------------------------------------------
// | Copyright (c) 2006-2016 http://thinkphp.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: 流年 <liu21st@gmail.com>
// +----------------------------------------------------------------------

// 应用公共文件
error_reporting(E_ERROR | E_PARSE );  

function getOS(){  
    $os=''; 
    $Agent=$_SERVER['HTTP_USER_AGENT']; 
    if (eregi('win',$Agent)&&strpos($Agent, '95')){ 
        $os='Windows 95'; 
    }elseif(eregi('win 9x',$Agent)&&strpos($Agent, '4.90')){ 
        $os='Windows ME'; 
    }elseif(eregi('win',$Agent)&&ereg('98',$Agent)){ 
        $os='Windows 98'; 
    }elseif(eregi('win',$Agent)&&eregi('nt 5.0',$Agent)){ 
        $os='Windows 2000'; 
    }elseif(eregi('win',$Agent)&&eregi('nt 6.0',$Agent)){ 
        $os='Windows Vista'; 
    }elseif(eregi('win',$Agent)&&eregi('nt 6.1',$Agent)){ 
        $os='Windows 7'; 
    }elseif(eregi('win',$Agent)&&eregi('nt 5.1',$Agent)){ 
        $os='Windows XP'; 
    }elseif(eregi('win',$Agent)&&eregi('nt',$Agent)){ 
        $os='Windows NT'; 
    }elseif(eregi('win',$Agent)&&ereg('32',$Agent)){ 
        $os='Windows 32'; 
    }elseif(eregi('linux',$Agent)){ 
        $os='Linux'; 
    }elseif(eregi('unix',$Agent)){ 
        $os='Unix'; 
    }else if(eregi('sun',$Agent)&&eregi('os',$Agent)){ 
        $os='SunOS'; 
    }elseif(eregi('ibm',$Agent)&&eregi('os',$Agent)){ 
        $os='IBM OS/2'; 
    }elseif(eregi('Mac',$Agent)&&eregi('PC',$Agent)){ 
        $os='Macintosh'; 
    }elseif(eregi('PowerPC',$Agent)){ 
        $os='PowerPC'; 
    }elseif(eregi('AIX',$Agent)){ 
        $os='AIX'; 
    }elseif(eregi('HPUX',$Agent)){ 
        $os='HPUX'; 
    }elseif(eregi('NetBSD',$Agent)){ 
        $os='NetBSD'; 
    }elseif(eregi('BSD',$Agent)){ 
        $os='BSD'; 
    }elseif(ereg('OSF1',$Agent)){ 
        $os='OSF1'; 
    }elseif(ereg('IRIX',$Agent)){ 
        $os='IRIX'; 
    }elseif(eregi('FreeBSD',$Agent)){ 
        $os='FreeBSD'; 
    }elseif($os==''){ 
        $os='Unknown'; 
    } 
    return $os; 
} 

function isMobile(){
	// 如果有HTTP_X_WAP_PROFILE则一定是移动设备
	if (isset ($_SERVER['HTTP_X_WAP_PROFILE']))
		return true;

	//此条摘自TPM智能切换模板引擎，适合TPM开发
	if(isset ($_SERVER['HTTP_CLIENT']) &&'PhoneClient'==$_SERVER['HTTP_CLIENT'])
		return true;
		
	//如果via信息含有wap则一定是移动设备,部分服务商会屏蔽该信息
	if (isset ($_SERVER['HTTP_VIA']))
		//找不到为flase,否则为true
		return stristr($_SERVER['HTTP_VIA'], 'wap') ? true : false;
	//判断手机发送的客户端标志,兼容性有待提高
	if (isset ($_SERVER['HTTP_USER_AGENT'])) {
		$clientkeywords = array('nokia','sony','ericsson','mot','samsung','htc','sgh','lg','sharp','sie-','philips','panasonic','alcatel','lenovo','iphone','ipod','blackberry','meizu','android','netfront','symbian','ucweb','windowsce','palm','operamini','operamobi','openwave','nexusone','cldc','midp','wap','mobile');
		//从HTTP_USER_AGENT中查找手机浏览器的关键字
		if (preg_match("/(" . implode('|', $clientkeywords) . ")/i", strtolower($_SERVER['HTTP_USER_AGENT']))) {
			return true;
		}
	}
	
	//协议法，因为有可能不准确，放到最后判断
	if (isset ($_SERVER['HTTP_ACCEPT'])) {
	// 如果只支持wml并且不支持html那一定是移动设备
	// 如果支持wml和html但是wml在html之前则是移动设备
	if ((strpos($_SERVER['HTTP_ACCEPT'], 'vnd.wap.wml') !== false) && (strpos($_SERVER['HTTP_ACCEPT'], 'text/html') === false || (strpos($_SERVER['HTTP_ACCEPT'], 'vnd.wap.wml') < strpos($_SERVER['HTTP_ACCEPT'], 'text/html')))) {
		return true;
	}
	}
	return false;
}
 

/**
 *  获取用户真实地址
 *
 * @return    string  返回用户ip
 */
if ( ! function_exists('GetIP'))
{
    function GetIP()
    {
        static $realip = NULL;
        if ($realip !== NULL)
        {
            return $realip;
        }
        if (isset($_SERVER))
        {
            if (isset($_SERVER['HTTP_X_FORWARDED_FOR']))
            {
                $arr = explode(',', $_SERVER['HTTP_X_FORWARDED_FOR']);
                /* 取X-Forwarded-For中第x个非unknown的有效IP字符? */
                foreach ($arr as $ip)
                {
                    $ip = trim($ip);
                    if ($ip != 'unknown')
                    {
                        $realip = $ip;
                        break;
                    }
                }
            }
            elseif (isset($_SERVER['HTTP_CLIENT_IP']))
            {
                $realip = $_SERVER['HTTP_CLIENT_IP'];
            }
            else
            {
                if (isset($_SERVER['REMOTE_ADDR']))
                {
                    $realip = $_SERVER['REMOTE_ADDR'];
                }
                else
                {
                    $realip = '0.0.0.0';
                }
            }
        }
        else
        {
            if (getenv('HTTP_X_FORWARDED_FOR'))
            {
                $realip = getenv('HTTP_X_FORWARDED_FOR');
            }
            elseif (getenv('HTTP_CLIENT_IP'))
            {
                $realip = getenv('HTTP_CLIENT_IP');
            }
            else
            {
                $realip = getenv('REMOTE_ADDR');
            }
        }
        preg_match("/[\d\.]{7,15}/", $realip, $onlineip);
        $realip = ! empty($onlineip[0]) ? $onlineip[0] : '0.0.0.0';
        return $realip;
    }
}



function baseUrl($dtype=0, $uri=''){ 
	$baseUrl = ( isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] != 'off') ? 'https://' : 'http://';
	$baseUrl .= isset($_SERVER['HTTP_HOST']) ? $_SERVER['HTTP_HOST'] : getenv('HTTP_HOST');
	if($dtype=='0')
		$baseUrl .= isset($_SERVER['SCRIPT_NAME']) ? dirname($_SERVER['SCRIPT_NAME']) : dirname(getenv('SCRIPT_NAME'));
	if($uri)
		return $baseUrl.'/'.$uri;
	return $baseUrl;
}

if ( ! function_exists('createNonceStr'))
{
	function createNonceStr($length = 16) {
		$chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
		$str = "";
		for ($i = 0; $i < $length; $i++) {
		  $str .= substr($chars, mt_rand(0, strlen($chars) - 1), 1);
		}
		return $str;
	 }
} 

if ( ! function_exists('jsonEncodeWithCN'))
{
	function jsonEncodeWithCN($data) { 
		return preg_replace("/\\\u([0-9a-f]{4})/ie", "iconv('UCS-2', 'UTF-8', pack('H4', '$1'))", json_encode($data));
	}
}


/**

 * 下载远程图片

 * @param string $url 图片的绝对url

 * @param string $fileurl 文件的完整路径（包括目录，不包括后缀名,例如/www/images/test） ，此函数会自动根据图片url和http头信息确定图片的后缀名

 * @return mixed 下载成功返回一个描述图片信息的数组，下载失败则返回false

 */  
 
function downloadImage($url, $fileurl) {

	//服务器返回的头信息

	$responseHeaders = array();

	//原始图片名

	$originalfilename = '';

	//图片的后缀名

	$ext = '';

	$ch = curl_init($url);

	//设置curl_exec返回的值包含Http头

	curl_setopt($ch, CURLOPT_HEADER, 1);

	//设置curl_exec返回的值包含Http内容

	curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);        

	//设置抓取跳转（http 301，302）后的页面

	curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);

	//设置最多的HTTP重定向的数量

	curl_setopt($ch, CURLOPT_MAXREDIRS, 2);
 
	//服务器返回的数据（包括http头信息和内容）

	$html = curl_exec($ch);

	//获取此次抓取的相关信息

	$httpinfo = curl_getinfo($ch);

	curl_close($ch);

	if ($html !== false) {

		//分离response的header和body，由于服务器可能使用了302跳转，所以此处需要将字符串分离为 2+跳转次数 个子串

		$httpArr = explode("\r\n\r\n", $html, 2 + $httpinfo['redirect_count']);

		//倒数第二段是服务器最后一次response的http头

		$header = $httpArr[count($httpArr) - 2];

		//倒数第一段是服务器最后一次response的内容

		$body = $httpArr[count($httpArr) - 1];

		$header.="\r\n";
 
		//获取最后一次response的header信息

		preg_match_all('/([a-z0-9-_]+):\s*([^\r\n]+)\r\n/i', $header, $matches);

		if (!empty($matches) && count($matches) == 3 && !empty($matches[1]) && !empty($matches[1])) {

			for ($i = 0; $i < count($matches[1]); $i++) {

				if (array_key_exists($i, $matches[2])) {

					$responseHeaders[$matches[1][$i]] = $matches[2][$i];

				}

			}

		}

		//获取图片后缀名

		if (0 < preg_match('{(?:[^\/\\\\]+)\.(jpg|jpeg|gif|png|bmp)$}i', $url, $matches)) {

			$originalfilename = $matches[0];

			$ext = $matches[1];

		} else {

			if (array_key_exists('Content-Type', $responseHeaders)) {

				if (0 < preg_match('{image/(\w+)}i', $responseHeaders['Content-Type'], $extmatches)) {

					$ext = $extmatches[1];
					if($ext=="webp") $ext = "png"; 
				}
				
				if($ext=='jpeg') $ext = 'jpg';

			}

		}
 
		//保存文件

		if (!empty($ext)) {

			$filepath = $fileurl.'/'.md5($url).".$ext";
			  
			//如果目录不存在，则先要创建目录
 
			//CFiles::createDirectory(dirname($filepath));

			$local_file = fopen($filepath, 'w');

			if (false !== $local_file) {

				if (false !== fwrite($local_file, $body)) {

					fclose($local_file);

					$sizeinfo = getimagesize($filepath);

					return array('filepath' => realpath($filepath), 'width' => $sizeinfo[0], 'height' => $sizeinfo[1], 'orginalfilename' => $originalfilename, 'filename' => pathinfo($filepath, PATHINFO_BASENAME));

				}

			}

		}

	} 
	
	return false; 
}

if ( ! function_exists('getPageSize'))
{
    function getPageSize($pagenum=20)
    {
		$page_size = config('APP_PAGE_SIZE'); 
		//$pagenum = intval($pagenum);
		$validate = new \Think\Validate( ['pagenum'=>'require|number'] );
		$result = $validate->check( ["pagenum"=>$pagenum] ); 
		if($result && $pagenum>=1) $page_size = intval($pagenum); 
		if($page_size>60000) $page_size = 60000;  
		return $page_size;
	}
}

if ( ! function_exists('TB'))
{
	function TB($table, $where, $field) {  
		$rows = __db($table)->where($where)->find();
		if($field) return $rows[$field];
		return $rows;
	}
}

if ( ! function_exists('M'))
{
	function M($table) {  
		return __db($table); 
	}
}

if ( ! function_exists('add_log'))
{
	function add_log( $uid=0, $action='', $optdesc='', $logdata='' ) {  
		$log = new \app\common\controller\Log;
		$resule = $log->add_log( $uid, $action, $optdesc, $logdata );  
		return $resule; 
	}
}

if ( ! function_exists('GetWxMedia'))
{ 
	//微信下载media_id
	function GetWxMedia($media, $company_id=0){   
		$wx_api = new \Wechat\Controller\WeiapiController; 
		if($company_id) $wx_api->company_id = $company_id;  
		$token = $wx_api->getAccessToken($company_id);  
		$fileurl = 'Uploads/wx_media_file/'.date("Y")."/";
		@mkdir($fileurl);
		$fileurl .= date("m")."/";
		@mkdir($fileurl);
		$fileurl .= date("d")."/";
		@mkdir($fileurl);  
		
		$url = "http://file.api.weixin.qq.com/cgi-bin/media/get?access_token=$token&media_id=$media"; 
		$img_info = downloadImage($url, $fileurl);
		$pic = "";
		if($img_info['filename']){   
			$pic = C('KFU_ADMIN_URL') . $fileurl . $img_info['filename'];  
		}
		return $pic;
	}
}



function ajax_decode($datas){
	$data_infos = json_encode($datas, JSON_UNESCAPED_UNICODE);
	//ajax_cross_domain($data_infos);   
	// 设置允许其他域名访问
	header('Access-Control-Allow-Origin:*');  
	// 设置允许的响应类型 
	header('Access-Control-Allow-Methods:POST,GET,DELETE,PUT');  
	// 设置允许的响应头 
	header('Access-Control-Allow-Headers:x-requested-with,content-type');  
	//echo $data_infos;
 	header("Content-type: text/html; charset=utf-8");                 
	ajax_cross_domain($data_infos);  
}

function ajax_decode2($datas,$file){
	$data_infos = json_encode($datas);
	/*$f = fopen($file, 'w');
	fwrite($f,  $data_infos);
	fclose($f);*/ 
	print_r($_REQUEST['callback'] . "(".$data_infos.")");
	exit;
}

//支持跨域数据
function ajax_cross_domain($data_infos){ 
	//支持跨域
	if(isset($_REQUEST["callback"]))
		print_r( $_REQUEST['callback'] . "(".$data_infos.")");
	else
		echo $data_infos;
		
	exit;
}

function __db($table=""){
	$db = \think\Db::name($table);
	return $db;
}

function __get(){
	$request = \think\Request::instance();
	return $request; 
}

function httpPost($url,$indata) {
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


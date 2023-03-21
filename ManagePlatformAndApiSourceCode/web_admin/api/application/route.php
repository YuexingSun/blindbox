<?php
// +----------------------------------------------------------------------
// | ThinkPHP [ WE CAN DO IT JUST THINK ]
// +----------------------------------------------------------------------
// | Copyright (c) 2006~2018 http://thinkphp.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: liu21st <liu21st@gmail.com>
// +----------------------------------------------------------------------

//use think\Route; 
//Route::rule('/', 'index/index/index'); 

return [
    '__pattern__' => [
        'name' => '\w+',
    ],
    '[hello]'     => [
        ':id'   => ['index/hello', ['method' => 'get'], ['id' => '\d+']],
        ':name' => ['index/hello', ['method' => 'post']],
    ],
	
	'update_sort_num' => 'api/product/update_sort_num', 
	
	//'/'=>'index',
	'home_index_create'=> 'home/index/create', 
	
	
	
	
	
	//分类路由
	'api_category_save'=>'api/category/category_save',
	//微信支付回庙
	'Api_Timer_WeixinPayNotify'=>'Api/Timer/WeixinPayNotify',
	//定时器路由
	'Api_Timer_checkUserOrders'=>'Api/Timer/checkUserOrders',
	//客服系统路由
	'Api_Userorder_getCoustemData'=>'Api/Userorder/getCoustemData',
	//客服系统路由
	'Api_Userorder_getCoustemOrderList'=>'Api/Userorder/getCoustemOrderList',
	//支付宝支付回调
	'Api_Timer_AliPayNotify'=>'Api/Timer/AliPayNotify',
	
];

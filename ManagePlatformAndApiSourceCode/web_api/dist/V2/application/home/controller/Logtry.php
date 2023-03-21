<?php 
namespace app\home\controller; 
use app\common\controller\Common; 
use app\common\controller\Log;  

class Logtry extends Common  
{
	
	public function test(){ 
		print_r($this->token_info); 
		//$log = new Log();
		//$resule = $log->add_log('说明文字', 0, $_REQUEST, $this->token_info); 
		$resule = add_log('说明文字', 1, $_REQUEST, $this->token_info);
		print_r($resule); 
	}
	
}
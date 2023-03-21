//
//  ZXHumanMachineCertificationView.m
//  ZXHY
//
//  Created by Bern Lin on 2021/11/18.
//

#import "ZXHumanMachineCertificationView.h"
#import <WebKit/WebKit.h>


@interface ZXHumanMachineCertificationView()
<
WKUIDelegate,
WKNavigationDelegate,
WKScriptMessageHandler
>

@property (nonatomic, strong) WKWebView  *webView;

@end

@implementation ZXHumanMachineCertificationView

- (instancetype)initWithFrame:(CGRect)frame{
   
    if (self = [super initWithFrame:frame]) {
        [self zx_initializationUI];
    }
    return self;
}

#pragma mark - Initialization UI
- (void)zx_initializationUI{

    self.backgroundColor =  WGRGBAlpha(0, 0, 0, 0.5);
    

    [self addSubview:self.webView];
}



//webView
-(WKWebView *)webView{
    
    if(_webView == nil){
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = [WKUserContentController new];
        //注册果断回调方法
        [configuration.userContentController addScriptMessageHandler:self name:@"loadAction"];
        [configuration.userContentController addScriptMessageHandler:self name:@"errorAction"];
        [configuration.userContentController addScriptMessageHandler:self name:@"verifiedAction"];

        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, WGNumScreenWidth(), WGNumScreenHeight()) configuration:configuration];
        _webView.center = CGPointMake(WGNumScreenWidth()/2, WGNumScreenHeight()/2);
        _webView.backgroundColor = UIColor.clearColor;
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        
        [self loadWebCodeHTML];
    }
    return _webView;
}

- (void)loadWebCodeHTML
{
    NSString *randomstr = [self randomPassword];
    NSString* htmlText = [NSString stringWithFormat:DSWebBridge_html_js(), randomstr];
    [self.webView loadHTMLString:htmlText baseURL:nil];
}

//自动生成8位随机密码
-(NSString *)randomPassword{
    NSTimeInterval random = [NSDate timeIntervalSinceReferenceDate];
    NSString *randomString = [[NSString stringWithFormat:@"%0.8f",random] md5HashToLower32Bit];
    NSString *randompassword = [randomString substringWithRange:NSMakeRange(6, 8)];
    return randompassword;
}

-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{

    
    
    if ([message.name isEqualToString:@"loadAction"]) {
        //加载成功, 更新webview的frame
        NSDictionary *jsData =  message.body;
        self.webView.frame = CGRectMake(0, 0, [jsData[@"sdkView"][@"width"] doubleValue], [jsData[@"sdkView"][@"height"] doubleValue]);
        self.webView.center = CGPointMake(WGNumScreenWidth()/2, WGNumScreenHeight()/2);
        
    }else if([message.name isEqualToString:@"verifiedAction"]) {
        
        //划动验证
        ZXHumanMachineCertificationModel *model = [ZXHumanMachineCertificationModel wg_objectWithDictionary:message.body];
        
        if (model.ret == 0) {
            //验证成功
            if(self.delegate && [self.delegate respondsToSelector:@selector(successfulCertificationView:withHumanMachineCertificationModel:)]){
                [self.delegate successfulCertificationView:self withHumanMachineCertificationModel:model];
            }
            
        }else if (model.ret == 2) {
            //点击关闭
            
        }
        
        [self removeFromSuperview];
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(closeCertificationView:)]){
            [self.delegate closeCertificationView:self];
        }
        
    }else if([message.name isEqualToString:@"errorAction"]) {
      
        //加载失败
        [self removeFromSuperview];
        if(self.delegate && [self.delegate respondsToSelector:@selector(closeCertificationView:)]){
            [self.delegate closeCertificationView:self];
        }
       
    }
}




#pragma mark - HTML 标签
NSString * DSWebBridge_html_js() {
#define __wvjb_js_func__(x) #x
    static NSString * html = @__wvjb_js_func__(
                                               <!DOCTYPE html>
                                               <html>
                                               <head>
                                               <script  src="https://ssl.captcha.qq.com/TCaptcha.js?v=%@" type="text/javascript"></script>
                                               <meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">
                                               </head>
                                               <body>
                                               <script type="text/javascript">
                                               (function(){
        // 验证成功返回ticket
        window.SDKTCaptchaVerifyCallback = function (retJson) {
            if (retJson){
                window.webkit.messageHandlers.verifiedAction.postMessage(retJson)
            }
        };
        // 验证码加载完成的回调，用来设置webview尺寸
        window.SDKTCaptchaReadyCallback = function (retJson) {
            if (retJson && retJson.sdkView && retJson.sdkView.width && retJson.sdkView.height &&  parseInt(retJson.sdkView.width) >0 && parseInt(retJson.sdkView.height) >0 ){
                window.webkit.messageHandlers.loadAction.postMessage(retJson)
            }
        };
        window.onerror = function (msg, url, line, col, error) {
            if (window.TencentCaptcha == null) {
                window.webkit.messageHandlers.errorAction.postMessage(error)
            }
        };
        var sdkOptions = {"sdkOpts": {"width": 1, "height": 1}};
        sdkOptions.ready = window.SDKTCaptchaReadyCallback;
        window.onload = function () {
           //此处需要替换xxxxxx为appid
            new TencentCaptcha("2074698099", SDKTCaptchaVerifyCallback, sdkOptions).show();
        };
    })();
     </script></body></html>
    );
#undef __wvjb_js_func__
    return html;
};

@end

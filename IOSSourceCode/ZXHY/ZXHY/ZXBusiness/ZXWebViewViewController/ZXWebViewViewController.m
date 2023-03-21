//
//  ZXWebViewViewController.m
//  ZXHY
//
//  Created by Bern Lin on 2022/1/18.
//

#import "ZXWebViewViewController.h"

@interface ZXWebViewViewController ()
<WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) WKWebViewConfiguration *webConfig;
@property (nonatomic, strong) WKWebView  *webView;

@end

@implementation ZXWebViewViewController

- (void)viewDidLoad {
   

    self.showCustomerNavView = YES;
    [super viewDidLoad];
    self.navigationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    self.view.backgroundColor = UIColor.whiteColor;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navigationView.mas_bottom);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
        
    [self loadData];
        
    if(!kIsEmptyString(self.webViewTitle)){
        self.wg_mainTitle = self.webViewTitle;
    }
        
        
}

#pragma mark - Private Method
- (void)loadData
{
    if(!kIsEmptyString(self.webViewURL)){
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.webViewURL]];
        [self.webView loadRequest:request];
    }
}


#pragma mark - WKWKNavigationDelegate Methods

//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"开始加载网页");
}

//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"加载完成");
    
}

//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败");
    
    WEAKSELF
    [WGUIManager wg_showLoadFailWithBtnClickBlock:^(UIButton *button) {
        [weakSelf loadData];
    }];
}

//页面跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    //允许页面跳转
    NSLog(@"Navigation: %@",navigationAction.request.URL);
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 当调用window.open方法时，会掉用该代理方法
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    if (navigationAction.request.URL) {
       
    }
    return nil;
}


#pragma mark - lazy

- (WKWebViewConfiguration *)webConfig
{
    if (!_webConfig)
    {
        _webConfig = [[WKWebViewConfiguration alloc] init];
        _webConfig.preferences = [[WKPreferences alloc] init];
        _webConfig.preferences.minimumFontSize = 10;
        _webConfig.preferences.javaScriptEnabled = YES;
        _webConfig.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        _webConfig.processPool = [[WKProcessPool alloc] init];
        _webConfig.userContentController = [[WKUserContentController alloc] init];
        _webConfig.allowsInlineMediaPlayback = YES;
        if (@available(iOS 10.0, *))
        {
            _webConfig.mediaTypesRequiringUserActionForPlayback = NO;
        }
    }
    return _webConfig;
}

- (WKWebView *)webView
{
    if (!_webView)
    {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, WGNumScreenWidth(), WGNumScreenHeight()-64)
                                      configuration:self.webConfig];
        _webView.backgroundColor = UIColor.whiteColor;
       
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.opaque = NO;
        [_webView setAllowsBackForwardNavigationGestures:YES];
        
        if (@available(iOS 11.0, *))
        {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        else
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    return _webView;
}

@end
